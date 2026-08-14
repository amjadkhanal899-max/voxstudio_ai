import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoxStudio AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.deepPurple,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const VideoGeneratorTab(),
    const VoiceGeneratorTab(),
    const DownloaderTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.grey.shade900,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Video AI'),
          BottomNavigationBarItem(icon: Icon(Icons.record_voice_over), label: 'Voice AI'),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Downloader'),
        ],
      ),
    );
  }
}

// 1️⃣ ویڈیو جنریٹر ٹیب
class VideoGeneratorTab extends StatefulWidget {
  const VideoGeneratorTab({super.key});

  @override
  State<VideoGeneratorTab> createState() => _VideoGeneratorTabState();
}

class _VideoGeneratorTabState extends State<VideoGeneratorTab> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎬 AI Video Generator'), backgroundColor: Colors.deepPurple.shade900),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _promptController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter video script or prompt here...',
                      fillColor: Colors.grey.shade900,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isGenerating
                        ? null
                        : () {
                            if (_promptController.text.isEmpty) return;
                            setState(() => _isGenerating = true);
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() => _isGenerating = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('🎉 Video generated successfully!')),
                              );
                            });
                          },
                    child: _isGenerating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Generate AI Video'),
                  ),
                ],
              ),
            ),
          ),
          if (_isAdLoaded && _bannerAd != null)
            SizedBox(width: _bannerAd!.size.width.toDouble(), height: _bannerAd!.size.height.toDouble(), child: AdWidget(ad: _bannerAd!)),
        ],
      ),
    );
  }
}

// 2️⃣ وائس جنریٹر ٹیب
class VoiceGeneratorTab extends StatefulWidget {
  const VoiceGeneratorTab({super.key});

  @override
  State<VoiceGeneratorTab> createState() => _VoiceGeneratorTabState();
}

class _VoiceGeneratorTabState extends State<VoiceGeneratorTab> {
  final TextEditingController _textController = TextEditingController();
  bool _isGeneratingVoice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎙️ AI Voice Generator'), backgroundColor: Colors.deepPurple.shade900),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter text to convert into realistic voice...',
                fillColor: Colors.grey.shade900,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isGeneratingVoice
                  ? null
                  : () {
                      if (_textController.text.isEmpty) return;
                      setState(() => _isGeneratingVoice = true);
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() => _isGeneratingVoice = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🎧 Voice created and ready to play!')),
                        );
                      });
                    },
              child: _isGeneratingVoice
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Generate AI Voice'),
            ),
          ],
        ),
      ),
    );
  }
}

// 3️⃣ ڈاؤنلوڈر ٹیب
class DownloaderTab extends StatefulWidget {
  const DownloaderTab({super.key});

  @override
  State<DownloaderTab> createState() => _DownloaderTabState();
}

class _DownloaderTabState extends State<DownloaderTab> {
  final TextEditingController _urlController = TextEditingController();
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📥 Social Video Downloader'), backgroundColor: Colors.deepPurple.shade900),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Paste Reel / TikTok video link here...',
                fillColor: Colors.grey.shade900,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade800,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isDownloading
                  ? null
                  : () {
                      if (_urlController.text.isEmpty) return;
                      setState(() => _isDownloading = true);
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() => _isDownloading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('⚡ Video Downloaded to Gallery!')),
                        );
                      });
                    },
              child: _isDownloading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Download Video'),
            ),
          ],
        ),
      ),
    );
  }
}
