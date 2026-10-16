import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SadamVoxUltimateStudio());
}

class SadamVoxUltimateStudio extends StatelessWidget {
  const SadamVoxUltimateStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SADAM VOX',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF080502),
      ),
      home: const FinalStudioDashboard(),
    );
  }
}

class FinalStudioDashboard extends StatefulWidget {
  const FinalStudioDashboard({super.key});

  @override
  State<FinalStudioDashboard> createState() => _FinalStudioDashboardState();
}

class _FinalStudioDashboardState extends State<FinalStudioDashboard> with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late Animation<double> _uiScaleAnimation;
  bool _isProcessing = false;

  final String _replicateToken = "r8_0L28VgblgILx7uvvV5cNsY4thY74zoK14D7Bx";

  @override
  void initState() {
    super.initState();
    _mainAnimationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _uiScaleAnimation = CurvedAnimation(parent: _mainAnimationController, curve: Curves.easeOutBack);
    _mainAnimationController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    super.dispose();
  }

  Future<void> triggerMusicComposer() async {
    setState(() { _isProcessing = true; });
    try {
      final response = await http.post(
        Uri.parse('https://replicate.com'),
        headers: {
          'Authorization': 'Token $_replicateToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'version': '7a7663585c8e0b2d7969345ee03a77ef7af796d78aeae47b960f89d21e105baa', 
          'input': {
            'prompt': 'Premium studio vocal-ready acoustic guitar and piano beat, 320kbps, clear space for vocals',
            'duration': 30,
            'vocal_eq_carving': true 
          }
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        _showFeedback('تم بدء توليد التراك المفرغ بنجاح: ${data['id']}');
      }
    } catch (e) {
      _showFeedback('خطأ في الاتصال بمحرك الموسيقى السحابي');
    }
    setState(() { _isProcessing = false; });
  }

  Future<void> triggerVoiceCleaner() async {
    setState(() { _isProcessing = true; });
    try {
      final response = await http.post(
        Uri.parse('https://replicate.com'),
        headers: {
          'Authorization': 'Token $_replicateToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'version': 'deepfilternet_model_version_id_placeholder', 
          'input': {
            'audio_url': 'https://googleapis.com', 
            'de_esser': true, 
            'noise_reduction': 95 
          }
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        _showFeedback('تم بدء معالجة وتنقية صوت الغناء: ${data['id']}');
      }
    } catch (e) {
      _showFeedback('خطأ في الاتصال بمحرك عزل وتلميع الصوت البشري');
    }
    setState(() { _isProcessing = false; });
  }

  Future<void> triggerVoiceClone() async {
    _showFeedback('تم استدعاء محرك استنساخ وتغيير نبرة الصوت السحابي RVC');
  }

  Future<void> triggerAiSinger() async {
    _showFeedback('تم استدعاء محرك المغني الذكي وتوليد الكورال والهارموني التلقائي');
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF0C0804),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (isLandscape) {
                    return _buildLandscapeLayout(constraints);
                  } else {
                    return _buildPortraitLayout(constraints);
                  }
                },
              ),
            ),
          ),
          if (_isProcessing)
            const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(BoxConstraints constraints) {
    final leftSidebarWidth = constraints.maxWidth * 0.18;
    final rightSidebarWidth = constraints.maxWidth * 0.15;

    return Row(
      children: [
        _buildLeftNetworkSidebar(leftSidebarWidth),
        Expanded(
          child: Column(
            children: [
              _buildTopControlHeader(constraints.maxHeight * 0.13),
              Expanded(
                flex: 4,
                child: ScaleTransition(
                  scale: _uiScaleAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: LayoutBuilder(
                      builder: (context, frameConstraints) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network('https://googleapis.com', width: frameConstraints.maxWidth, fit: BoxFit.contain, errorBuilder: (c, e, s) => const SizedBox()),
                            Positioned.fill(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildFeatureColumn('coin_voice_clone.png', 'lbl_voice_clone.png', 'txt_voice_clone.png', frameConstraints.maxHeight, triggerVoiceClone),
                                  _buildFeatureColumn('coin_ai_singer.png', 'lbl_ai_singer.png', 'txt_ai_singer.png', frameConstraints.maxHeight, triggerAiSinger),
                                  _buildFeatureColumn('coin_voice_cleaner.png', 'lbl_voice_cleaner.png', 'txt_voice_cleaner.png', frameConstraints.maxHeight, triggerVoiceCleaner),
                                  _buildFeatureColumn('coin_music_composer.png', 'lbl_music_composer.png', 'txt_music_composer.png', frameConstraints.maxHeight, triggerMusicComposer),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Image.network('https://googleapis.com', fit: BoxFit.contain, errorBuilder: (c, e, s) => const SizedBox()),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: Image.network('https://googleapis.com', fit: BoxFit.contain, errorBuilder: (c, e, s) => const SizedBox())),
                                  Expanded(child: Image.network('https://googleapis.com', fit: BoxFit.contain, errorBuilder: (c, e, s) => const SizedBox())),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: Image.network('https://googleapis.com', fit: BoxFit.contain, errorBuilder: (c, e, s) => const SizedBox())),
                                  Expanded(child: Image.network('https://googleapis.com', fit: BoxFit.contain, errorBuilder: (c, e, s) => const SizedBox())),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildRightSidebarMenu(rightSidebarWidth),
      ],
    );
  }

  Widget _buildLeftNetworkSidebar(double width) {
    return Container(
      width: width,
      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFF3A2A14), width: 1.5))),
      child: Column(
        children: [
          const SizedBox(height: 6),
          const Text('المشروعات المخزنة', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  child: AspectRatio(
                    aspectRatio: 2.8,
                    
