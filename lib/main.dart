import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const VoxStudioApp());
}

class VoxStudioApp extends StatelessWidget {
  const VoxStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoxStudio AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0914),
        primaryColor: const Color(0xFF00F2FE),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F2FE),
          secondary: Color(0xFF9D00FF),
          surface: Color(0xFF16122C),
        ),
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
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  InterstitialAd? _interstitialAd;

  final List<Widget> _screens = [
    const CapCutTemplatesScreen(),
    const TextToVideoScreen(),
    const FreeAiPhotoScreen(),
    const TalkingAvatarScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test Banner Ad Unit
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerAdLoaded = true),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test Interstitial Ad Unit
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (err) => _interstitialAd = null,
      ),
    );
  }

  void showAdAndProcess(VoidCallback onDone) {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _loadInterstitialAd();
    }
    onDone();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isBannerAdLoaded && _bannerAd != null)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: const Color(0xFF120E26),
            selectedItemColor: const Color(0xFF00F2FE),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.style),
                label: 'CapCut Hub',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_call),
                label: 'AI Video',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome),
                label: 'Free Photo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.record_voice_over),
                label: 'Talking Avatar',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 1. CapCut Style Trending Templates
class CapCutTemplatesScreen extends StatelessWidget {
  const CapCutTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VoxStudio CapCut Templates', style: TextStyle(color: Color(0xFF00F2FE), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF120E26),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            List<String> titles = [
              'Cyberpunk Velocity Reel',
              '3D Zoom Dynamic Edit',
              'Neon Glow Audio Beat',
              'AI Portrait Transformation',
              'Viral TikTok SlowMo',
              'Auto Subtitle Vlog'
            ];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF16122C),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF9D00FF).withOpacity(0.5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_fill, size: 45, color: Color(0xFF00F2FE)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ٹیمپلیٹ پروسیس ہو رہا ہے...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D00FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Use Template', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// 2. Prompt to Video Generator
class TextToVideoScreen extends StatelessWidget {
  const TextToVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prompt-to-Video Generator'), backgroundColor: const Color(0xFF120E26)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'پرامپٹ لکھیں (مثلاً: A super sports car speeding in a neon city at night, 4k 60fps)...',
                filled: true,
                fillColor: Color(0xFF16122C),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('مفت AI ویڈیو جنریٹ ہو رہی ہے...')),
                );
              },
              icon: const Icon(Icons.movie_creation),
              label: const Text('Generate AI Video (FREE)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F2FE),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Free AI Photo Generator
class FreeAiPhotoScreen extends StatelessWidget {
  const FreeAiPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Free AI Photo Generator'), backgroundColor: const Color(0xFF120E26)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'پرامپٹ درج کریں: Ultra HD realistic photo of a robotic tiger with blue glow...',
                filled: true,
                fillColor: Color(0xFF16122C),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ایچ ڈی تصویر تیار ہو رہی ہے...')),
                );
              },
              icon: const Icon(Icons.palette),
              label: const Text('Generate HD Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D00FF),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Talking Avatar System
class TalkingAvatarScreen extends StatelessWidget {
  const TalkingAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Talking Avatar Video Generator'), backgroundColor: const Color(0xFF120E26)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF16122C),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF00F2FE)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_a_photo, size: 40, color: Color(0xFF00F2FE)),
                  SizedBox(height: 8),
                  Text('تصویر سلیکٹ کریں جو آپ بولوانا چاہتے ہیں', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'وہ سکرپٹ لکھیں جو اس کریکٹر سے بولوانا چاہتے ہیں...',
                filled: true,
                fillColor: Color(0xFF16122C),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ٹاکنگ ویڈیو بن رہی ہے...')),
                );
              },
              icon: const Icon(Icons.record_voice_over),
              label: const Text('Create Talking Video'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F2FE),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
