
                
 import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const VoxStudioApp());

class VoxStudioApp extends StatelessWidget {
  const VoxStudioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoxStudio AI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A12),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5CC),
          secondary: Color(0xFF7B61FF),
          tertiary: Color(0xFF00D1FF),
          background: Color(0xFF0A0A12),
          surface: Color(0xFF141423),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ================= SPLASH SCREEN =================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _fadeController;
  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    Future.delayed(const Duration(milliseconds: 300), () => _fadeController.forward());
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainDashboard()));
    });
  }
  @override
  void dispose() {
    _orbitController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0A0A12), Color(0xFF1A1033), Color(0xFF0A2A2E)]),
        ),
        child: FadeTransition(
          opacity: _fadeController,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Spacer(),
            Center(child: AnimatedBuilder(animation: _orbitController, builder: (_, __) => CustomPaint(size: const Size(200, 200), painter: AtomicOrbitPainter(angle: _orbitController.value * 2 * math.pi)))),
            const SizedBox(height: 32),
            const Text("VoxStudio AI", style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 8),
            const Text("VIRTUAL AI EDITOR • FAST MODE", style: TextStyle(fontSize: 12, letterSpacing: 3, color: Color(0xFF00E5CC), fontWeight: FontWeight.w600)),
            const Spacer(),
            const Padding(padding: EdgeInsets.only(bottom: 40), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00E5CC))), SizedBox(width: 12), Text("Initializing Fast Engine...", style: TextStyle(color: Colors.white38, fontSize: 12))])),
          ]),
        ),
      ),
    );
  }
}

class AtomicOrbitPainter extends CustomPainter {
  final double angle;
  AtomicOrbitPainter({required this.angle});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paints = [
      Paint()..color = const Color(0xFF00E5CC)..style = PaintingStyle.stroke..strokeWidth = 3,
      Paint()..color = const Color(0xFF7B61FF)..style = PaintingStyle.stroke..strokeWidth = 3,
      Paint()..color = const Color(0xFF00D1FF)..style = PaintingStyle.stroke..strokeWidth = 3,
    ];
    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle + (i * math.pi / 1.5));
      canvas.translate(-center.dx, -center.dy);
      canvas.drawOval(Rect.fromCenter(center: center, width: size.width * 0.9, height: size.width * 0.45), paints[i]);
      canvas.restore();
    }
    canvas.drawCircle(center, 18, Paint()..color = Colors.white.withOpacity(0.15)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
    canvas.drawCircle(center, 10, Paint()..color = Colors.white);
  }
  @override
  bool shouldRepaint(covariant AtomicOrbitPainter old) => true;
}

// ================= MAIN DASHBOARD =================
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});
  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  int _credits = 12;
  final List<Widget> _tabs = const [ShortsEngineTab(), DownloaderTab(), VoiceStudioTab(), AutoPilotTab()];
  void _showProSheet() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: const Color(0xFF141423), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => const ProUpgradeSheet());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0F0F1E), Color(0xFF0A0A12)])),
        child: SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF1E1E32), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF00E5CC).withOpacity(0.3))), child: Row(children: [const Icon(Icons.bolt, size: 16, color: Color(0xFF00E5CC)), const SizedBox(width: 6), Text("$_credits Credits", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))])),
            const Spacer(),
            IconButton(onPressed: _showProSheet, icon: const Icon(Icons.workspace_premium, color: Color(0xFFFFD700))),
            FilledButton(onPressed: _showProSheet, style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00E5CC), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 16)), child: const Text("PRO", style: TextStyle(fontWeight: FontWeight.w900))),
          ])),
          Container(margin: const EdgeInsets.symmetric(horizontal: 16), height: 56, decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)), child: const Center(child: Text("AdMob Adaptive Banner • Dashboard", style: TextStyle(color: Colors.white24, fontSize: 11)))),
          const SizedBox(height: 12),
          Expanded(child: _tabs[_currentIndex]),
          Padding(padding: const EdgeInsets.all(16), child: OutlinedButton.icon(onPressed: () { setState(() => _credits += 5); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rewarded Ad: +5 Credits Unlocked!"), backgroundColor: Color(0xFF00E5CC))); }, icon: const Icon(Icons.play_circle_fill, color: Color(0xFF00E5CC)), label: const Text("Watch Ad to Unlock +5 Credits", style: TextStyle(color: Color(0xFF00E5CC))), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF00E5CC)), minimumSize: const Size(double.infinity, 48)))),
        ])),
      ),
      bottomNavigationBar: NavigationBar(backgroundColor: const Color(0xFF141423), indicatorColor: const Color(0xFF00E5CC).withOpacity(0.2), selectedIndex: _currentIndex, onDestinationSelected: (i) => setState(() => _currentIndex = i), destinations: const [
        NavigationDestination(icon: Icon(Icons.movie_filter_outlined), selectedIcon: Icon(Icons.movie_filter, color: Color(0xFF00E5CC)), label: "Viral Shorts"),
        NavigationDestination(icon: Icon(Icons.download_outlined), selectedIcon: Icon(Icons.download, color: Color(0xFF00E5CC)), label: "Downloader"),
        NavigationDestination(icon: Icon(Icons.mic_none), selectedIcon: Icon(Icons.mic, color: Color(0xFF00E5CC)), label: "Voice"),
        NavigationDestination(icon: Icon(Icons.rocket_launch_outlined), selectedIcon: Icon(Icons.rocket_launch, color: Color(0xFF00E5CC)), label: "Auto-Pilot"),
      ]),
    );
  }
}

// ================= TABS (FIXED EdgeInsets bug) =================
class ShortsEngineTab extends StatefulWidget {
  const ShortsEngineTab({super.key});
  @override
  State<ShortsEngineTab> createState() => _ShortsEngineTabState();
}
class _ShortsEngineTabState extends State<ShortsEngineTab> {
  String selectedStyle = "MrBeast";
  double progress = 0.0;
  bool isGenerating = false;
  void startGen() async {
    setState(() { isGenerating = true; progress = 0; });
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() => progress = i / 100);
    }
    setState(() => isGenerating = false);
  }
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text("1-Click Viral Shorts Engine", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const Text("Auto Long-to-Shorts with AI Highlights", style: TextStyle(color: Colors.white54)),
      const SizedBox(height: 16),
      _NeonCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Input Source", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(decoration: _inputDeco("Paste YouTube link or Pick Local File", Icons.link)),
        const SizedBox(height: 12),
        const Row(children: [ _ActionChip(icon: Icons.folder, label: "Local Video"), SizedBox(width: 8), _ActionChip(icon: Icons.youtube_searched_for, label: "YouTube URL")]),
      ])),
      const SizedBox(height: 12),
      const Text("Style Profiles", style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ["MrBeast", "Hormozi", "Ali Abdaal", "Neon Podcast", "Joe Rogan"].map((s) {
        final isSel = selectedStyle == s;
        return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(s), selected: isSel, onSelected: (_) => setState(() => selectedStyle = s), selectedColor: const Color(0xFF00E5CC), labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white, fontWeight: FontWeight.bold)));
      }).toList())),
      const SizedBox(height: 16),
      FilledButton.icon(onPressed: isGenerating ? null : startGen, icon: const Icon(Icons.bolt), label: Text(isGenerating ? "GENERATING ${(progress * 100).toInt()}% • Fast Mode" : "⚡ FAST GENERATE VIRAL SHORTS"), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00E5CC), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 56))),
      if (isGenerating) ...[const SizedBox(height: 12), LinearProgressIndicator(value: progress, color: const Color(0xFF00E5CC))],
      const SizedBox(height: 16),
      _NeonCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.auto_awesome, size: 16, color: Color(0xFF7B61FF)), SizedBox(width: 6), Text("AI Highlight Detection")]), SizedBox(height: 12), _WaveformPlaceholder()])),
    ]);
  }
}

class DownloaderTab extends StatefulWidget {
  const DownloaderTab({super.key});
  @override
  State<DownloaderTab> createState() => _DownloaderTabState();
}
class _DownloaderTabState extends State<DownloaderTab> {
  final controller = TextEditingController();
  String type = "Video 4K";
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text("Global 1-Click Auto-Downloader", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const Text("No Watermark • YT, TikTok, IG, FB", style: TextStyle(color: Colors.white54)),
      const SizedBox(height: 16),
      _NeonCard(child: Column(children: [
        TextField(controller: controller, decoration: _inputDeco("Paste ANY video link...", Icons.download), maxLines: 2),
        const SizedBox(height: 12),
        Row(children: ["Video 4K", "Audio MP3", "Captions SRT"].map((t) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(t), selected: type == t, onSelected: (_) => setState(() => type = t), selectedColor: const Color(0xFF7B61FF)))) .toList()),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.download), label: const Text("FETCH & DOWNLOAD"), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF7B61FF), minimumSize: const Size(double.infinity, 52))),
      ])),
      const SizedBox(height: 12),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.6, mainAxisSpacing: 10, crossAxisSpacing: 10, children: const [_PlatformTile("YouTube", Icons.play_circle_fill, Colors.red), _PlatformTile("TikTok", Icons.music_note, Colors.white), _PlatformTile("Instagram", Icons.camera_alt, Colors.pink), _PlatformTile("Facebook", Icons.facebook, Colors.blue)]),
    ]);
  }
}

class VoiceStudioTab extends StatefulWidget {
  const VoiceStudioTab({super.key});
  @override
  State<VoiceStudioTab> createState() => _VoiceStudioTabState();
}
class _VoiceStudioTabState extends State<VoiceStudioTab> {
  bool noiseCancel = true;
  String lang = "EN-US";
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text("AI Voice Studio & Dubbing", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const Text("Noise Cancel • Auto Voiceover • Multi-Lang Dub", style: TextStyle(color: Colors.white54)),
      const SizedBox(height: 16),
      _NeonCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("AI Noise Cancellation", style: TextStyle(fontWeight: FontWeight.bold)), Switch(value: noiseCancel, activeColor: const Color(0xFF00E5CC), onChanged: (v) => setState(() => noiseCancel = v))]),
        const Divider(color: Colors.white10),
        const Text("AI Script Generator"),
        const SizedBox(height: 8),
        TextField(maxLines: 3, decoration: _inputDeco("Enter topic: e.g., '5AM motivation...'", Icons.edit_note)),
        const SizedBox(height: 12),
        const Text("Dubbing Language"),
        const SizedBox(height: 6),
        Wrap(spacing: 8, children: ["EN-US", "EN-UK", "ES", "FR", "DE", "HI", "AR", "UR"].map((l) => ChoiceChip(label: Text(l), selected: lang == l, onSelected: (_) => setState(() => lang = l), selectedColor: const Color(0xFF00E5CC))).toList()),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.mic), label: const Text("GENERATE VOICEOVER & DUB"), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00E5CC), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 52))),
      ])),
    ]);
  }
}

class AutoPilotTab extends StatelessWidget {
  const AutoPilotTab({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text("Virtual AI Freelancer", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const Text("Next-Gen Channel Auto-Pilot • US Creator Focus", style: TextStyle(color: Colors.white54)),
      const SizedBox(height: 16),
      _NeonCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Connected Channels (OAuth Secure)", style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 12), const _ChannelRow("YouTube", true), const _ChannelRow("Instagram", false), const _ChannelRow("TikTok", true), const SizedBox(height: 12), OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_link), label: const Text("Connect Channel via OAuth"))])),
      const SizedBox(height: 12),
      _NeonCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Fully Automated Setup", style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), TextField(decoration: _inputDeco("Category: Motivational, Finance...", Icons.category)), const SizedBox(height: 12), FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: const Color(0xFF7B61FF), minimumSize: const Size(double.infinity, 48)), child: const Text("Auto-Generate Titles, Desc, Hashtags"))])),
      const SizedBox(height: 12),
      _NeonCard(child: Column(children: [const Row(children: [Icon(Icons.calendar_month, size: 18), SizedBox(width: 6), Text("Scheduler - 1-Click Multi-Post", style: TextStyle(fontWeight: FontWeight.bold))]), const SizedBox(height: 12), const Row(children: [Expanded(child: _StatBox("Next Post", "Today 9AM EST")), SizedBox(width: 8), Expanded(child: _StatBox("Auto-Publish", "3 Platforms"))]), const SizedBox(height: 12), FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.rocket_launch), label: const Text("PUBLISH TO ALL NOW"), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00E5CC), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)))])),
    ]);
  }
}

class ProUpgradeSheet extends StatelessWidget {
  const ProUpgradeSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 20),
      const Icon(Icons.workspace_premium, size: 48, color: Color(0xFFFFD700)),
      const SizedBox(height: 12),
      const Text("VoxStudio AI Pro", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
      const Text("Unlock Viral Growth", style: TextStyle(color: Color(0xFF00E5CC))),
      const SizedBox(height: 20),
      const ListTile(leading: Icon(Icons.block, color: Color(0xFF00E5CC)), title: Text("Zero Ads - Clean Workflow"), dense: true),
      const ListTile(leading: Icon(Icons.hd, color: Color(0xFF00E5CC)), title: Text("4K Ultra Export - No Watermark"), dense: true),
      const ListTile(leading: Icon(Icons.all_inclusive, color: Color(0xFF00E5CC)), title: Text("Unlimited Channel Auto-Pilot"), dense: true),
      const ListTile(leading: Icon(Icons.bolt, color: Color(0xFF00E5CC)), title: Text("Priority GPU Rendering - Fast Mode x5"), dense: true),
      const SizedBox(height: 12),
      FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 56)), child: const Text("Upgrade to Pro - \$19.99/mo", style: TextStyle(fontWeight: FontWeight.w900))),
      const SizedBox(height: 8),
      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Maybe Later", style: TextStyle(color: Colors.white38))),
      const SizedBox(height: 20),
    ]));
  }
}

// ================= HELPERS (BUG FIXED) =================
InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: const Color(0xFF0F0F1E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white10)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white10)),
    );

class _NeonC
