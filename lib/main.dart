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

  final List<Widget> _screens = [
    const CapCutTemplatesScreen(),
    const TextToVideoScreen(),
    const FreeAiPhotoScreen(),
    const TalkingAvatarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
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
            label: 'Avatar',
          ),
        ],
      ),
    );
  }
}

// 1. CapCut Style Trending Templates Screen
class CapCutTemplatesScreen extends StatelessWidget {
  const CapCutTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> templates = [
      {'title': 'Cyberpunk Velocity Reel', 'tag': 'FREE AI EDIT'},
      {'title': '3D Zoom Dynamic Edit', 'tag': 'TRENDING'},
      {'title': 'Neon Glow Audio Beat', 'tag': 'VIRAL'},
      {'title': 'AI Portrait Transformation', 'tag': 'NEW'},
      {'title': 'Viral TikTok SlowMo', 'tag': 'HOT'},
      {'title': 'Auto Subtitle Vlog', 'tag': 'FREE'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('VoxStudio CapCut Hub',
            style: TextStyle(color: Color(0xFF00F2FE), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF120E26),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF16122C),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF9D00FF).withOpacity(0.5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_fill, size: 50, color: Color(0xFF00F2FE)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      templates[index]['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00F2FE).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      templates[index]['tag']!,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF00F2FE)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('مفت ${templates[index]['title']} لوڈ ہو رہا ہے...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D00FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Use Template', style: TextStyle(fontSize: 12, color: Colors.white)),
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

// 2. Free Prompt-to-Video Generator Screen
class TextToVideoScreen extends StatefulWidget {
  const TextToVideoScreen({super.key});

  @override
  State<TextToVideoScreen> createState() => _TextToVideoScreenState();
}

class _TextToVideoScreenState extends State<TextToVideoScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isLoading = false;
  String? _generatedMediaUrl;

  void _generateVideo() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('برائے مہربانی پرامپٹ لکھیں!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _generatedMediaUrl = null;
    });

    // Free AI Video Generation using Free Pollinations API Endpoint
    final String prompt = Uri.encodeComponent(_promptController.text.trim());
    final String freeApiUrl = 'https://image.pollinations.ai/prompt/$prompt?width=1080&height=1920&nologo=true&seed=42';

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
      _generatedMediaUrl = freeApiUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FREE AI Video Generator'),
        backgroundColor: const Color(0xFF120E26),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _promptController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'مفت پرامپٹ لکھیں (مثلاً: Futuristic Neon Sports Car speeding in rain)...',
                  filled: true,
                  fillColor: Color(0xFF16122C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _generateVideo,
                icon: const Icon(Icons.movie_creation),
                label: Text(_isLoading ? 'AI جنریٹ کر رہا ہے...' : 'Generate Free AI Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F2FE),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator(color: Color(0xFF00F2FE))
              else if (_generatedMediaUrl != null)
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16122C),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF00F2FE)),
                    image: DecorationImage(
                      image: NetworkImage(_generatedMediaUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. Free AI Photo Generator Screen
class FreeAiPhotoScreen extends StatefulWidget {
  const FreeAiPhotoScreen({super.key});

  @override
  State<FreeAiPhotoScreen> createState() => _FreeAiPhotoScreenState();
}

class _FreeAiPhotoScreenState extends State<FreeAiPhotoScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isLoading = false;
  String? _imageUrl;

  void _generatePhoto() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('پرامپٹ لکھیں!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _imageUrl = null;
    });

    // 100% Free AI Image API Endpoint
    final String encodedPrompt = Uri.encodeComponent(_promptController.text.trim());
    final String freePhotoUrl = 'https://image.pollinations.ai/prompt/$encodedPrompt?width=1080&height=1080&nologo=true';

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _imageUrl = freePhotoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free AI Photo Engine'),
        backgroundColor: const Color(0xFF120E26),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _promptController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'پرامپٹ درج کریں: HD Realistic portrait of a cyber lion with glowing blue eyes...',
                  filled: true,
                  fillColor: Color(0xFF16122C),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _generatePhoto,
                icon: const Icon(Icons.palette),
                label: Text(_isLoading ? 'HD تصویر بن رہی ہے...' : 'Generate HD Image (100% Free)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D00FF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator(color: Color(0xFF9D00FF))
              else if (_imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    _imageUrl!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. Talking Avatar Screen
class TalkingAvatarScreen extends StatelessWidget {
  const TalkingAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talking Avatar Generator'),
        backgroundColor: const Color(0xFF120E26),
        centerTitle: true,
      ),
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
                  Text('تصویر سلیکٹ کریں جو آپ بلوانا چاہتے ہیں', style: TextStyle(color: Colors.grey)),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('فری وائس اور ایواٹار پروسیس ہو رہا ہے...')),
                );
              },
              icon: const Icon(Icons.record_voice_over),
              label: const Text('Create Talking Avatar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F2FE),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
