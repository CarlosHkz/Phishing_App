import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FÓRUM SOBRE PHISHING'),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('Compartilhamento de experiências e dúvidas'),
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('O que é Phishing e como funciona'),
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('O que fazer para não levar golpes pela internet'),
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('Dicas de segurança web'),
          ),
        ],
      ),
    );
  }
}
