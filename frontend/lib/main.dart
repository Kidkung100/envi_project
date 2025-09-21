import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'fullscreen_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  static Future<List<dynamic>> getParticipants() async {
    final response = await http.get(Uri.parse("$baseUrl/participants"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load participants");
    }
  }

  static Future<List<dynamic>> getGameScores() async {
    final response = await http.get(Uri.parse("$baseUrl/game_scores"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load game scores");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Participant Tree Website',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  bool _isFullscreen = false;
  StreamSubscription<void>? _fullscreenSubscription;
  late Timer _timer;

  late Future<List<dynamic>> _participantsFuture;
  late Future<List<dynamic>> _gameScoresFuture;

  final String _googleFormUrl =
      'https://docs.google.com/forms/d/e/1FAIpQLSePPVeU_upjSzNj_TjM4ISi5fMN1rc4-O_fOR83KkPdLiV66Q/viewform?usp=header';
  final String _treeAsset = 'assets/tree.png';
  final String _leafAsset = 'assets/leaf.png';
  final String _game1Url = 'https://score-database-39a80.web.app/';
  final String _game2Url = 'https://howto-61589.web.app/';

  final List<Offset> _leafPositions = [
    const Offset(140, 285), //1
    const Offset(430, 260), //2
    const Offset(168, 252), //3
    const Offset(475, 250), //4
    const Offset(250, 110), //5
    const Offset(460, 160), //6
    const Offset(185, 185), //7
    const Offset(550, 200), //8
    const Offset(264, 185), //9
    const Offset(590, 210), //10
    const Offset(343, 150), //11
    const Offset(400, 90), //12
    const Offset(313, 208), //13
    const Offset(338, 117), //14
    const Offset(115, 190), //15
    const Offset(425, 150), //16
    const Offset(285, 315), //17
    const Offset(365, 205), //18
    const Offset(236, 88), //19
    const Offset(443, 127), //20
    const Offset(98, 230), //21
    const Offset(473, 126), //22
    const Offset(625, 200), //23
    const Offset(212.34, 195.94), //24
    const Offset(384, 301), //25
    const Offset(397, 177), //26
    const Offset(285, 276), //27
    const Offset(388, 261), //28
    const Offset(313, 166.33), //29
    const Offset(290, 166.33), //30
    const Offset(375, 161), //31
    const Offset(255, 285), //32
    const Offset(392.65, 127.77), //33
    const Offset(423.49, 109.81), //34
    const Offset(267, 249.36), //35
    const Offset(408, 275), //36
    const Offset(108, 282), //37
    const Offset(163, 220), //38
    const Offset(417, 226), //39
    const Offset(215, 233.14), //40
    const Offset(445.98, 230.27), //41
    const Offset(451.90, 197), //42
    const Offset(140.87, 233.55), //43
    const Offset(503, 227), //44
    const Offset(232, 261.49), //45
    const Offset(303, 122.56), //46
    const Offset(244.36, 224.20), //47
    const Offset(520, 187.21), //48
    const Offset(234.74, 153), //49
    const Offset(146.59, 189.88), //50
    const Offset(481.56, 216.71), //51
    const Offset(489, 190), //52
    const Offset(497.86, 150.24), //53
    const Offset(581.05, 179), //54
    const Offset(578, 159), //55
    const Offset(281.39, 124.46), //56
    const Offset(280.79, 120.61), //57
    const Offset(521.60, 134.88), //58
    const Offset(357, 104.59), //59
    const Offset(212.53, 132.62), //60
  ];
  final List<double> _leafAngles = [
    -1.55, //1
    -0.4, //2
    -1.3, //3
    0.4, //4
    -0.2, //5
    0.2, //6
    -0.5, //7
    0.25, //8
    -1, //9
    0.6, //10
    -0.25, //11
    0.2, //12
    -0.4, //13
    -0.7, //14
    -0.6, //15
    -0.3, //16
    -0.8, //17
    0.0, //18
    -0.2, //19
    -0.4, //20
    -0.7, //21
    0.4, //22
    -0.22, //23
    0.33, //24
    -0.45, //25
    0.05, //26
    -0.5, //27
    0, //28
    -0.5, //29
    -0.7, //30
    -0.1, //31
    -0.6, //32
    0.1, //33
    0.4, //34
    -0.7, //35
    -0.2, //36
    -1.55, //37
    -0.9, //38
    0.3, //39
    0.15, //40
    0.1, //41
    0.6, //42
    -0.2, //43
    0.1, //44
    -0.5, //45
    -0.6, //46
    -0.55, //47
    0.10, //48
    -0.7, //49
    -0.42, //50
    0.33, //51
    0.20, //52
    -0.50, //53
    0.6, //54
    -0.05, //55
    0.60, //56
    0.00, //57
    -0.2, //58
    -0.1, //59
    -0.6, //60
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchData());

    if (kIsWeb) {
      initFullscreenListener((bool isFull) {
        if (!mounted) return;
        setState(() => _isFullscreen = isFull);
      });
    }
  }

  void _fetchData() {
    setState(() {
      _participantsFuture = ApiService.getParticipants();
      _gameScoresFuture = ApiService.getGameScores();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _fullscreenSubscription?.cancel();
    super.dispose();
  }

  void _toggleFullscreen() {
    if (kIsWeb) toggleFullscreen(_isFullscreen);
  }

  List<Widget> _buildLeavesWithAnimation(int participantCount) {
    List<Widget> leaves = [];
    for (int i = 0; i < _leafPositions.length; i++) {
      final bool isVisible = i < participantCount;
      leaves.add(
        Positioned(
          key: ValueKey('leaf_anim_$i'),
          left: _leafPositions[i].dx,
          top: _leafPositions[i].dy,
          child: AnimatedScale(
            scale: isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            child: Transform.rotate(
              angle: (i < _leafAngles.length) ? _leafAngles[i] : 0.0,
              child: Image.asset(_leafAsset, width: 100, height: 90),
            ),
          ),
        ),
      );
    }
    return leaves;
  }

  /// ================= PAGE ONE =================
  Widget _buildPageOneContent(List<dynamic> docs) {
    int participantCount = docs.length;
    final ecoBoxDecoration = BoxDecoration(
      color: const Color(0xFFF5F3E8),
      borderRadius: BorderRadius.circular(16.0),
      border: Border.all(color: Colors.green.shade200.withOpacity(0.8)),
      boxShadow: [
        BoxShadow(
          color: Colors.green.shade900.withOpacity(0.15),
          spreadRadius: 1,
          blurRadius: 12,
          offset: const Offset(4, 4),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // QR
          Expanded(
            flex: 2,
            child: Container(
              height: 480,
              decoration: ecoBoxDecoration,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'ลงทะเบียนเข้าร่วม',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: _googleFormUrl,
                    version: QrVersions.auto,
                    size: 280,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'สแกน QR Code เพื่อลงทะเบียนทำแบบทดสอบ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => setState(() => _currentPageIndex = 1),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('หน้าคะแนนเกม '),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Tree + Leaves
          Expanded(
            flex: 3,
            child: Container(
              height: 480,
              decoration: ecoBoxDecoration,
              padding: const EdgeInsets.all(16),
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 800,
                  height: 800,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(_treeAsset),
                      ..._buildLeavesWithAnimation(participantCount),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Participant Table
          Expanded(
            flex: 3,
            child: Container(
              height: 480,
              padding: const EdgeInsets.all(16),
              decoration: ecoBoxDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ผู้เข้าร่วม ($participantCount คน)',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: DataTable(
                                columnSpacing: 20,
                                columns: const [
                                  DataColumn(label: Text('รหัสพนักงาน')),
                                  DataColumn(label: Text('ชื่อ-สกุล')),
                                  DataColumn(label: Text('คะแนน')),
                                ],
                                rows: docs.map((data) {
                                  String employeeId =
                                      data['employeeId']?.toString().padLeft(
                                        5,
                                        '0',
                                      ) ??
                                      '-';
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(employeeId)),
                                      DataCell(Text(data['name'] ?? '-')),
                                      DataCell(
                                        Text(data['score']?.toString() ?? '-'),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= PAGE TWO =================
  Widget _buildPageTwoContent(List<dynamic> gameDocs) {
    final ecoBoxDecoration = BoxDecoration(
      color: const Color(0xFFF5F3E8),
      borderRadius: BorderRadius.circular(16.0),
      border: Border.all(color: Colors.green.shade200.withOpacity(0.8)),
      boxShadow: [
        BoxShadow(
          color: Colors.green.shade900.withOpacity(0.15),
          spreadRadius: 1,
          blurRadius: 12,
          offset: const Offset(4, 4),
        ),
      ],
    );

    Widget buildGameQrCode(String title, String url) {
      return Expanded(
        flex: 2,
        child: Container(
          height: 480,
          decoration: ecoBoxDecoration,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: QrImageView(data: url, version: QrVersions.auto),
              ),
              const SizedBox(height: 16),
              const Text(
                'สแกน QR Code เพื่อเล่นเกม',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('กลับหน้าหลัก'),
                onPressed: () => setState(() => _currentPageIndex = 0),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildGameQrCode('เกมที่ 1 Carbon Hunting', _game1Url),
              const SizedBox(width: 24),
              buildGameQrCode('เกมที่ 2 How to ทิ้ง', _game2Url),
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: Container(
                  height: 480,
                  padding: const EdgeInsets.all(16),
                  decoration: ecoBoxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ตารางคะแนนเกม',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth,
                                  ),
                                  child: DataTable(
                                    columnSpacing: 30,
                                    headingRowColor: WidgetStateProperty.all(
                                      Colors.green.shade50,
                                    ),
                                    columns: const [
                                      DataColumn(label: Text('รหัสพนักงาน')),
                                      DataColumn(label: Text('ชื่อ-สกุล')),
                                      DataColumn(label: Text('เกม 1')),
                                      DataColumn(label: Text('เกม 2')),
                                      DataColumn(label: Text('รวม')),
                                    ],
                                    rows: gameDocs.map((data) {
                                      int score1 = data['game1_score'] ?? 0;
                                      int score2 = data['game2_score'] ?? 0;
                                      int total = score1 + score2;
                                      String employeeId =
                                          data['employeeId']
                                              ?.toString()
                                              .padLeft(5, '0') ??
                                          '-';
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(employeeId)),
                                          DataCell(Text(data['name'] ?? 'N/A')),
                                          DataCell(Text(score1.toString())),
                                          DataCell(Text(score2.toString())),
                                          DataCell(
                                            Text(
                                              total.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFutureContent(
    Future<List<dynamic>> future,
    Widget Function(List<dynamic>) builder,
  ) {
    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: Text('เกิดข้อผิดพลาดในการเชื่อมต่อข้อมูล')),
          );
        }
        final docs = snapshot.data ?? [];
        return builder(docs);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 140, 164, 5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: const Color.fromARGB(255, 140, 164, 5)),
          ),
          Center(
            child: ConstrainedBox(
              constraints: _isFullscreen
                  ? const BoxConstraints()
                  : const BoxConstraints(maxWidth: 1920),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    _currentPageIndex == 0
                        ? _buildFutureContent(
                            _participantsFuture,
                            _buildPageOneContent,
                          )
                        : _buildFutureContent(
                            _gameScoresFuture,
                            _buildPageTwoContent,
                          ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          if (kIsWeb)
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(
                  _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
                onPressed: _toggleFullscreen,
              ),
            ),
        ],
      ),
    );
  }
}
