import 'package:flutter/material.dart';
import 'package:myapp/services/link_verifier_service.dart';

class VerificarLinksScreen extends StatefulWidget {
  const VerificarLinksScreen({super.key});

  @override
  State<VerificarLinksScreen> createState() => _VerificarLinksScreenState();
}

class _VerificarLinksScreenState extends State<VerificarLinksScreen> {
  final _textController = TextEditingController();
  final _linkVerifier = LinkVerifierService();

  bool? _isSafe;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _verifyLink() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = _textController.text.trim();

    try {
      final isSafe = await _linkVerifier.verifyLink(url);

      setState(() {
        _isSafe = isSafe;
      });

      // 🔥 SALVA NO HISTÓRICO APÓS VERIFIC

    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao verificar link. Tente novamente.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VERIFICAR URLS'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Cole o link que deseja verificar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Verificar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),

            const SizedBox(height: 30),

            if (_errorMessage != null)
              Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            if (_isSafe != null && _errorMessage == null)
              Center(
                child: Text(
                  _isSafe! ? 'Este link é seguro ✔️' : 'Este link NÃO é seguro ❌',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isSafe! ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
