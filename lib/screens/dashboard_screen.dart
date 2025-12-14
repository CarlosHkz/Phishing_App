import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/screens/verificar_links_screen.dart';
import 'package:myapp/screens/historico_links_screen.dart';
import 'package:myapp/screens/forum_screen.dart';
import 'package:myapp/screens/dicas_seguranca_screen.dart';
import 'package:myapp/widgets/bottom_nav.dart';
import 'package:myapp/main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const VerificarLinksScreen(),
    const HistoricoLinksScreen(),
    const ForumScreen(),
    const DicasSegurancaScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
   );
  }

}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PhishBlocx'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 100),
            const SizedBox(height: 16),
            const Text(
              'Proteja-se contra links falsos e golpes online',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VerificarLinksScreen()),
                );
              },
              child: const Text('Verificar link'),
            ),
            const SizedBox(height: 32),
            SwitchListTile(
              title: const Text('Dicas de Segurança'),
              value: false,
              onChanged: (value) {},
              secondary: const Icon(Icons.security),
            ),
            SwitchListTile(
              title: const Text('Fórum sobre Phishing'),
              value: false,
              onChanged: (value) {},
              secondary: const Icon(Icons.forum),
            ),
            SwitchListTile(
              title: const Text('Modo Noturno'),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              secondary: const Icon(Icons.dark_mode),
            ),
          ],
        ),
      ),
    );
  }
}