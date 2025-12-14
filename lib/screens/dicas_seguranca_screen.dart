import 'package:flutter/material.dart';

class DicasSegurancaScreen extends StatelessWidget {
  const DicasSegurancaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DICAS DE SEGURANÇA'),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.block, color: Colors.blue),
            title: Text('Não clique em links suspeitos'),
          ),
          ListTile(
            leading: Icon(Icons.system_update, color: Colors.blue),
            title: Text('Mantenha seu software atualizado'),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text('Desconfie de mensagens não solicitadas'),
          ),
          ListTile(
            leading: Icon(Icons.forum, color: Colors.blue),
            title: Text('Mais dicas no fórum'),
          ),
        ],
      ),
    );
  }
}
