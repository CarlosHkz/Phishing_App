import os
import psycopg2
import requests
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

# ------------------------------
# CONFIG SAFE BROWSING
# ------------------------------
API_KEY = os.getenv("SAFE_BROWSING_API_KEY")
API_URL = f"https://safebrowsing.googleapis.com/v4/threatMatches:find?key={API_KEY}"

# ------------------------------
# DB CONNECTION
# ------------------------------
def get_db():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        connect_timeout=5
    )

# ------------------------------
# VERIFICAR LINK
# ------------------------------
@app.post("/verificar")
def verificar():
    data = request.json
    url = data.get("url")

    if not url:
        return jsonify({"erro": "URL não fornecida"}), 400

    try:
        payload = {
            "client": {"clientId": "phishblocx", "clientVersion": "1.0"},
            "threatInfo": {
                "threatTypes": [
                    "MALWARE",
                    "SOCIAL_ENGINEERING",
                    "UNWANTED_SOFTWARE",
                    "POTENTIALLY_HARMFUL_APPLICATION",
                ],
                "platformTypes": ["ANY_PLATFORM"],
                "threatEntryTypes": ["URL"],
                "threatEntries": [{"url": url}],
            },
        }

        response = requests.post(API_URL, json=payload, timeout=15)
        result = response.json()

        seguro = "matches" not in result
        detalhes = result.get("matches", [])

    except Exception as e:
        return jsonify({
            "erro": "Falha ao consultar Safe Browsing",
            "detalhe": str(e)
        }), 500

    # ⬇️ SALVAR NO HISTÓRICO (SEM QUEBRAR)
    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute(
            """
            INSERT INTO historico_urls (url, is_safe)
            VALUES (%s, %s)
            """,
            (url, seguro),
        )
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        # não quebra o app
        print("Erro ao salvar histórico:", e)

    return jsonify({
        "url": url,
        "seguro": seguro,
        "detalhes": detalhes
    })

# ------------------------------
# LISTAR HISTÓRICO
# ------------------------------
@app.get("/historico")
def historico():
    try:
        conn = get_db()
        cur = conn.cursor()

        cur.execute("""
            SELECT url, is_safe, data_verificacao
            FROM historico_urls
            ORDER BY data_verificacao DESC
        """)
        rows = cur.fetchall()

        cur.close()
        conn.close()

        return jsonify([
            {
                "url": r[0],
                "is_safe": r[1],
                "data": r[2].strftime("%d/%m/%Y %H:%M")
            }
            for r in rows
        ])
    except Exception as e:
        return jsonify([])  # nunca quebra o app


# ------------------------------
# LIMPAR HISTÓRICO
# ------------------------------
@app.delete("/historico")
def limpar_historico():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("DELETE FROM historico_urls")
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"mensagem": "Histórico apagado"})

@app.get("/db-test")
def db_test():
    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute("SELECT 1;")
        cur.close()
        conn.close()
        return jsonify({"db": "OK"})
    except Exception as e:
        return jsonify({
            "db": "ERRO",
            "detalhe": str(e)
        }), 500


# ------------------------------
# HEALTH CHECK
# ------------------------------
@app.get("/")
def home():
    return jsonify({"status": "online"})
