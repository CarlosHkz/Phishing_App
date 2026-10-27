import ipaddress
from urllib.parse import urlparse

LIMITE_TAMANHO = 75
LIMITE_HIFENS = 3
LIMITE_PERCENT = 3
LIMITE_SUSPEITA = 2


def analisar_padroes_url(url: str) -> dict:
    motivos = []
    pontos = 0

    if "://" not in url:
        url = "http://" + url

    try:
        parsed = urlparse(url)
        host = parsed.hostname or ""

    except ValueError:
        return {
            "suspeita": True,
            "pontuacao": LIMITE_SUSPEITA,
            "motivos": ["URL malformada"],
        }

    if len(url) > LIMITE_TAMANHO:
        pontos += 1
        motivos.append(
            f"URL muito longa ({len(url)} caracteres)"
        )

    if "@" in parsed.netloc:
        pontos += 2
        motivos.append("Contém '@' antes do domínio")

    try:
        ipaddress.ip_address(host)
        pontos += 2
        motivos.append(
            "Usa endereço IP no lugar de um domínio"
        )

    except ValueError:
        pass

    if host.count("-") >= LIMITE_HIFENS:
        pontos += 1
        motivos.append(
            f"Muitos hifens no domínio ({host.count('-')})"
        )

    if url.count("%") >= LIMITE_PERCENT:
        pontos += 1
        motivos.append(
            f"Muita codificação '%' ({url.count('%')} ocorrências)"
        )

    return {
        "suspeita": pontos >= LIMITE_SUSPEITA,
        "pontuacao": pontos,
        "motivos": motivos,
    }
