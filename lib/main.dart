import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const KahootQuizUygulamasi());
}

class KahootQuizUygulamasi extends StatelessWidget {
  const KahootQuizUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kahoot Word Quiz',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const QuizSayfasi(),
    );
  }
}

class QuizSayfasi extends StatefulWidget {
  const QuizSayfasi({super.key});

  @override
  State<QuizSayfasi> createState() => _QuizSayfasiState();
}

class _QuizSayfasiState extends State<QuizSayfasi> {
  // 100 kelimelik listenin başlangıcı (Dilediğin gibi genişletebilirsin)
  final Map<String, String> _tumKelimeler = {
    'APPLE': 'ELMA',
    'BOOK': 'KİTAP',
    'CAR': 'ARABA',
    'DOOR': 'KAPI',
    'ELEPHANT': 'FİL',
    'FLOWER': 'ÇIÇEK',
    'GARDEN': 'BAHÇE',
    'HOUSE': 'EV',
    'ICE': 'BUZ',
    'JOURNEY': 'YOLCULUK',
  };

  late List<String> _ingilizceListesi;
  String _sorulanKelime = '';
  String _dogruCevap = '';
  List<String> _secenekler = [];
  
  int _dogruSayisi = 0;
  int _yanlisSayisi = 0;
  int _soruSirasi = 1;
  String? _secilenCevap;
  bool _cevaplandi = false;

  @override
  void initState() {
    super.initState();
    _ingilizceListesi = _tumKelimeler.keys.toList();
    _yeniSoruGetir();
  }

  void _yeniSoruGetir() {
    final rastgele = Random();
    
    _sorulanKelime = _ingilizceListesi[rastgele.nextInt(_ingilizceListesi.length)];
    _dogruCevap = _tumKelimeler[_sorulanKelime]!;

    List<String> tumTurkceKelimeler = _tumKelimeler.values.toList();
    tumTurkceKelimeler.remove(_dogruCevap);
    tumTurkceKelimeler.shuffle();

    _secenekler = [
      _dogruCevap,
      tumTurkceKelimeler[0],
      tumTurkceKelimeler[1],
      tumTurkceKelimeler[2],
    ];

    _secenekler.shuffle();

    setState(() {
      _secilenCevap = null;
      _cevaplandi = false;
    });
  }

  void _cevabiKontrolEt(String secilen) {
    if (_cevaplandi) return;

    setState(() {
      _secilenCevap = secilen;
      _cevaplandi = true;

      if (secilen == _dogruCevap) {
        _dogruSayisi++;
      } else {
        _yanlisSayisi++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kahoot renk şablonu (Kırmızı, Mavi, Sarı, Yeşil)
    final List<Color> butonRenkleri = [
      const Color(0xFFE21B3C), // Kırmızı
      const Color(0xFF1368CE), // Mavi
      const Color(0xFFD89E00), // Sarı
      const Color(0xFF26890C), // Yeşil
    ];

    // Kahoot Geometrik Şekilleri
    final List<Widget> sekiller = [
      CustomPaint(size: const Size(30, 30), painter: UcgenPainter()),
      CustomPaint(size: const Size(26, 26), painter: BaklavaPainter()),
      Container(width: 26, height: 26, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
      Container(width: 26, height: 26, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF46178F),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // DÜZELTME: MainAxisAlignment.spaceBetween hatası giderildi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    _ustYuvarlakBilgi("10s", const Color(0xFFE21B3C)),
                    _ustYuvarlakBilgi("Soru:\n$_soruSirasi/10", const Color(0xFF1368CE)),
                  ],
                ),
                const SizedBox(height: 20),

                // Soru Paneli
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      // DÜZELTME: Yeni Flutter SDK standardı .withValues() kullanıldı
                      BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10)
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _sorulanKelime,
                        // DÜZELTME: FontWeight.black yazım hatası FontWeight.w900 yapıldı
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
                        textAlign: TextAlign.center, // DÜZELTME: TextAlign hatası düzeltildi
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Aşağıdakilerden hangisi doğrudur?",
                        // DÜZELTME: Tanımsız whiteBF rengi Colors.white70 ile değiştirildi
                        style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                AnimatedOpacity(
                  opacity: _cevaplandi ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: _cevaplandi
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF46178F),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            setState(() {
                              _soruSirasi++;
                              _yeniSoruGetir();
                            });
                          },
                          icon: const Icon(Icons.arrow_forward, fontWeight: FontWeight.bold),
                          label: const Text('SONRAKİ SORU', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        )
                      : const SizedBox(height: 48),
                ),
                const SizedBox(height: 16),

                // Buton Grid Düzeni
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      String secenek = _secenekler[index];
                      Color butonRengi = butonRenkleri[index];

                      if (_cevaplandi) {
                        if (secenek != _dogruCevap) {
                          // DÜZELTME: .withValues() kullanıldı
                          butonRengi = butonRengi.withValues(alpha: 0.2);
                        }
                      }

                      return InkWell(
                        onTap: () => _cevabiKontrolEt(secenek),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: butonRengi,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              // DÜZELTME: .withValues() kullanıldı
                              BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 4))
                            ],
                            border: _cevaplandi && secenek == _dogruCevap
                                ? Border.all(color: Colors.white, width: 4)
                                : null,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Opacity(
                                opacity: _cevaplandi && secenek != _dogruCevap ? 0.3 : 1.0,
                                child: sekiller[index],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  secenek,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _cevaplandi && secenek != _dogruCevap ? Colors.white38 : Colors.white,
                                  ),
                                ),
                              ),
                              if (_cevaplandi && secenek == _dogruCevap)
                                const Icon(Icons.check_circle, color: Colors.white, size: 30),
                              if (_cevaplandi && _secilenCevap == secenek && secenek != _dogruCevap)
                                const Icon(Icons.cancel, color: Colors.white, size: 30),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Alt Skor Tablosu
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    // DÜZELTME: .withValues() kullanıldı
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _altSkorAlani("CORRECT", _dogruSayisi, Colors.greenAccent),
                      const SizedBox(width: 40),
                      _altSkorAlani("INCORRECT", _yanlisSayisi, Colors.redAccent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ustYuvarlakBilgi(String metin, Color renk) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: renk,
        shape: BoxShape.circle,
        // DÜZELTME: .withValues() kullanıldı
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 3),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4)],
      ),
      alignment: Alignment.center,
      child: Text(
        metin,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _altSkorAlani(String etiket, int skor, Color renk) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(etiket, style: TextStyle(color: renk, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 4),
        // DÜZELTME: .withValues() kullanıldı
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(color: renk.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
          child: Text('$skor', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

// --- KAHOOT GEOMETRİK ŞEKİL ÇİZİCİLERİ ---

class UcgenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BaklavaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}