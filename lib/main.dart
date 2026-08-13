import 'package:flutter/material.dart';

void main() {
  runApp(const VoxStudioApp());
}

class VoxStudioApp extends StatelessWidget {
  const VoxStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoxStudio AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF06B6D4),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF06B6D4),
          secondary: Color(0xFF8B5CF6),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainDashboard()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'VoxStudio AI',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Next-Gen AI Automation Suite',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  int userCredits = 5;

  final List<Widget> _tabs = [
    const ShortsEngineTab(),
    const DownloaderTab(),
    const VoiceStudioTab(),
    const AutoPilotTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VoxStudio AI', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
            EdgeInsets.symmetric(horizontal: 16)
            
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF8B5CF6)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text('$userCredits Credits', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF06B6D4),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation), label: 'Shorts'),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Downloader'),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Voice AI'),
          BottomNavigationBarItem(icon: Icon(Icons.rocket_launch), label: 'Auto-Pilot'),
        ],
      ),
    );
  }
}

class ShortsEngineTab extends StatelessWidget {
  const ShortsEngineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('1-Click Viral Shorts Engine', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Paste Video URL...',
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class DownloaderTab extends StatelessWidget {
  const DownloaderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Downloader Module'));
  }
}

class VoiceStudioTab extends StatelessWidget {
  const VoiceStudioTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Voice Studio Module'));
  }
}

class AutoPilotTab extends StatelessWidget {
  const AutoPilotTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Auto Pilot Module'));
  }
}

