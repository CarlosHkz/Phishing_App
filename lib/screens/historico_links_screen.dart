import 'package:flutter/material.dart';
import 'package:myapp/services/history_service.dart';
import 'package:myapp/services/history_service.dart';

class HistoricoLinksScreen extends StatefulWidget {
  const HistoricoLinksScreen({super.key});

  @override
  State<HistoricoLinksScreen> createState() => _HistoricoLinksScreenState();
}

class _HistoricoLinksScreenState extends State<HistoricoLinksScreen> {
  late Future<List<HistoryItem>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = HistoryService.buscarHistorico();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, size: 22),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "HISTÓRICO DE\nLINKS ACESSADAS",
                style: TextStyle(
                  fontSize: 28,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: FutureBuilder<List<HistoryItem>>(
                  future: _futureHistory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Erro ao carregar histórico."),
                      );
                    }

                    final items = snapshot.data!;

                    if (items.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhum link verificado ainda.",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildItem(
                          url: item.url,
                          isSafe: item.seguro,
                          date: item.data,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
  required String url,
  required bool isSafe,
  required String date,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isSafe ? Icons.check_circle : Icons.error,
          color: isSafe ? Colors.green : Colors.red,
          size: 28,
        ),
        const SizedBox(width: 10),

        /// 🟩 EXPANDED evita overflow e elimina o aviso amarelo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✔️ Limita tamanho e evita estouro
              Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                isSafe ? "Este link é seguro" : "Não seguro",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSafe ? Colors.green : Colors.red,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                date,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}
