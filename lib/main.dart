import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GuvendeApp());
}

class GuvendeApp extends StatelessWidget {
  const GuvendeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Güvende',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color pudra = Color(0xFFD9A6A6);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      // ÜST BAR
      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'GÜVENDE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),

      // ANA İÇERİK
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hoş geldin',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: yazi,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Güvenliğin için buradayız.',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 25),

              // ACİL DURUM
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SosSayfasi()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: bordo,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: bordo.withValues(alpha: 0.20),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 48,
                      ),

                      SizedBox(height: 8),

                      Text(
                        'ACİL DURUM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'Yardıma ihtiyacın olduğunda dokun',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Hızlı Erişim',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: yazi,
                ),
              ),

              const SizedBox(height: 15),

              // 1. SATIR
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KonumSayfasi(),
                          ),
                        );
                      },
                      child: _MenuKutusu(
                        ikon: Icons.location_on_rounded,
                        baslik: 'Konumum',
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GuvenCemberimSayfasi(),
                          ),
                        );
                      },
                      child: _MenuKutusu(
                        ikon: Icons.people_alt_rounded,
                        baslik: 'Güven Çemberim',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 2. SATIR
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GuvenliBolgeSayfasi(),
                          ),
                        );
                      },
                      child: _MenuKutusu(
                        ikon: Icons.map_rounded,
                        baslik: 'Güvenli Bölgeler',
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const YolculukSayfasi(),
                          ),
                        );
                      },
                      child: _MenuKutusu(
                        ikon: Icons.directions_walk_rounded,
                        baslik: 'Yolculuk',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // ALT MENÜ
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HaritaSayfasi()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BildirimlerSayfasi(),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilSayfasi()),
            );
          }
        },
        selectedItemColor: bordo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Harita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Bildirimler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// HIZLI ERİŞİM KUTULARI
class _MenuKutusu extends StatelessWidget {
  final IconData ikon;
  final String baslik;

  const _MenuKutusu({required this.ikon, required this.baslik});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFD9A6A6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, size: 34, color: const Color(0xFF641E35)),

          const SizedBox(height: 10),

          Text(
            baslik,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2D2424),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AcilDurumSayfasi extends StatelessWidget {
  const AcilDurumSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Acil Durum',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 35),

            const Icon(Icons.warning_rounded, color: bordo, size: 70),

            const SizedBox(height: 20),

            const Text(
              'Acil Durum',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Yardıma ihtiyacın varsa\nSOS butonuna dokun.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 50),

            Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                color: bordo,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: bordo.withValues(alpha: 0.25),

                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 45),

            const Row(
              children: [
                Icon(Icons.location_on_outlined, color: bordo),
                SizedBox(width: 10),
                Text(
                  'Konumun paylaşılacak',
                  style: TextStyle(fontSize: 15, color: yazi),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Row(
              children: [
                Icon(Icons.people_outline, color: bordo),
                SizedBox(width: 10),
                Text(
                  'Güven çemberine bildirim gönderilecek',
                  style: TextStyle(fontSize: 15, color: yazi),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GuvenCemberimSayfasi extends StatefulWidget {
  const GuvenCemberimSayfasi({super.key});

  @override
  State<GuvenCemberimSayfasi> createState() => _GuvenCemberimSayfasiState();
}

class _GuvenCemberimSayfasiState extends State<GuvenCemberimSayfasi> {
  static const Color bordo = Color(0xFF641E35);
  static const Color pudra = Color(0xFFD9A6A6);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  Future<void> kisiEkle() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Önce giriş yapmalısınız.')));
      return;
    }

    final adController = TextEditingController();
    final telefonController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: krem,
          title: const Text(
            'Güvenilir Kişi Ekle',
            style: TextStyle(fontWeight: FontWeight.bold, color: yazi),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: adController,
                decoration: InputDecoration(
                  labelText: 'Ad Soyad',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: telefonController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Telefon Numarası',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('İPTAL', style: TextStyle(color: bordo)),
            ),
            ElevatedButton(
              onPressed: () async {
                final ad = adController.text.trim();
                final telefon = telefonController.text.trim();

                if (ad.isEmpty || telefon.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ad soyad ve telefon numarasını girin.'),
                    ),
                  );
                  return;
                }

                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('trustedContacts')
                      .add({
                        'ad': ad,
                        'telefon': telefon,
                        'createdAt': FieldValue.serverTimestamp(),
                      });

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Güvenilir kişi başarıyla eklendi.'),
                      ),
                    );
                  }
                } on FirebaseException catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.message ?? 'Kişi eklenirken hata oluştu.',
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: bordo,
                foregroundColor: Colors.white,
              ),
              child: const Text('EKLE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: krem,
      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Güven Çemberim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Güvendiğin kişiler',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: kisiEkle,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: pudra,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: bordo,
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Güvenilir kişi ekle',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: yazi,
                        ),
                      ),
                    ),
                    Icon(Icons.add_rounded, color: bordo, size: 28),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Güven Çemberin',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: user == null
                  ? const Center(
                      child: Text(
                        'Kişilerini görmek için giriş yapmalısın.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('trustedContacts')
                          .orderBy('createdAt', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: bordo),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Kişiler yüklenirken bir hata oluştu.'),
                          );
                        }

                        final kisiler = snapshot.data?.docs ?? [];

                        if (kisiler.isEmpty) {
                          return const Center(
                            child: Text(
                              'Henüz güvenilir kişi eklenmedi.',
                              style: TextStyle(color: Colors.black54),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: kisiler.length,
                          itemBuilder: (context, index) {
                            final kisi = kisiler[index];

                            final ad = kisi['ad'] as String? ?? '';
                            final telefon = kisi['telefon'] as String? ?? '';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: pudra, width: 1.5),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 27,
                                    backgroundColor: pudra,
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: bordo,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ad,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: yazi,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          telefon,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('trustedContacts')
                                          .doc(kisi.id)
                                          .delete();
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: bordo,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final adController =
                                          TextEditingController(text: ad);
                                      final telefonController =
                                          TextEditingController(text: telefon);

                                      await showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            backgroundColor: krem,
                                            title: const Text(
                                              'Güvenilir Kişiyi Düzenle',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: yazi,
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: adController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Ad Soyad',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                TextField(
                                                  controller: telefonController,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Telefon Numarası',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                },
                                                child: const Text(
                                                  'İPTAL',
                                                  style: TextStyle(
                                                    color: bordo,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final yeniAd = adController
                                                      .text
                                                      .trim();
                                                  final yeniTelefon =
                                                      telefonController.text
                                                          .trim();

                                                  if (yeniAd.isEmpty ||
                                                      yeniTelefon.isEmpty) {
                                                    return;
                                                  }

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(user.uid)
                                                      .collection(
                                                        'trustedContacts',
                                                      )
                                                      .doc(kisi.id)
                                                      .update({
                                                        'ad': yeniAd,
                                                        'telefon': yeniTelefon,
                                                      });

                                                  if (dialogContext.mounted) {
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: bordo,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: const Text('KAYDET'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color: bordo,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class KonumSayfasi extends StatefulWidget {
  const KonumSayfasi({super.key});

  @override
  State<KonumSayfasi> createState() => _KonumSayfasiState();
}

class _KonumSayfasiState extends State<KonumSayfasi> {
  static const Color bordo = Color(0xFF641E35);
  static const Color pudra = Color(0xFFD9A6A6);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  Position? _konum;
  final MapController _mapController = MapController();
  bool _yukleniyor = false;
  String? _hata;

  Future<Position> _konumuAl() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Cihazın konum servisi kapalı. Lütfen ayarlardan aç.');
    }
    var izin = await Geolocator.checkPermission();
    if (izin == LocationPermission.denied) {
      izin = await Geolocator.requestPermission();
    }
    if (izin == LocationPermission.denied) {
      throw Exception('Konum izni verilmedi.');
    }
    if (izin == LocationPermission.deniedForever) {
      throw Exception('Konum izni ayarlardan kalıcı olarak kapatılmış.');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
  }

  void _konumuUygula(Position konum) {
    setState(() => _konum = konum);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mapController.move(LatLng(konum.latitude, konum.longitude), 15);
    });
  }

  Future<void> _konumuGuncelle() async {
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });
    try {
      final konum = await _konumuAl();
      if (!mounted) return;
      _konumuUygula(konum);
    } catch (e) {
      if (!mounted) return;
      setState(() => _hata = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  Future<void> _konumuPaylas() async {
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });
    try {
      final konum = await _konumuAl();
      if (!mounted) return;
      _konumuUygula(konum);
      final haritaLinki =
          'https://www.google.com/maps/search/?api=1&query=${konum.latitude},${konum.longitude}';
      await SharePlus.instance.share(
        ShareParams(text: 'Mevcut konumum: $haritaLinki'),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _hata = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _konumuGuncelle();
  }

  @override
  Widget build(BuildContext context) {
    final konumMetni = _konum == null
        ? 'Konum henüz alınmadı'
        : '${_konum!.latitude.toStringAsFixed(5)}, ${_konum!.longitude.toStringAsFixed(5)}';

    return Scaffold(
      backgroundColor: krem,
      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Konumum',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: _konum == null
                      ? Container(
                          color: pudra,
                          child: Center(
                            child: _yukleniyor
                                ? const CircularProgressIndicator(color: bordo)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on_rounded,
                                        color: bordo,
                                        size: 65,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Mevcut Konumun',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: yazi,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                        ),
                                        child: Text(
                                          _hata ?? 'Konum almak için aşağıdaki düğmeye dokun',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: yazi),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        )
                      : FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: LatLng(
                              _konum!.latitude,
                              _konum!.longitude,
                            ),
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.guvende',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                    _konum!.latitude,
                                    _konum!.longitude,
                                  ),
                                  width: 48,
                                  height: 48,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: bordo,
                                    size: 48,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.my_location_rounded,
                      color: bordo,
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mevcut Konumun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: yazi,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _hata ?? konumMetni,
                            style: TextStyle(
                              fontSize: 13,
                              color: _hata == null ? Colors.black54 : bordo,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Konumu yenile',
                      onPressed: _yukleniyor ? null : _konumuGuncelle,
                      icon: const Icon(Icons.refresh_rounded, color: bordo),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _yukleniyor ? null : _konumuPaylas,
                  icon: const Icon(Icons.share_location_rounded),
                  label: Text(
                    _yukleniyor ? 'Konum alınıyor...' : 'Konumumu Paylaş',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bordo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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

class GuvenliBolgeSayfasi extends StatefulWidget {
  const GuvenliBolgeSayfasi({super.key});

  @override
  State<GuvenliBolgeSayfasi> createState() => _GuvenliBolgeSayfasiState();
}

class _GuvenliBolgeSayfasiState extends State<GuvenliBolgeSayfasi> {
  static const Color bordo = Color(0xFF641E35);
  static const Color pudra = Color(0xFFD9A6A6);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  final MapController _mapController = MapController();
  final TextEditingController _aramaController = TextEditingController();
  final TextEditingController _adController = TextEditingController();
  Position? _konum;
  LatLng? _seciliNokta;
  String? _seciliAdres;
  String? _hata;
  bool _konumYukleniyor = false;
  bool _aramaYukleniyor = false;
  bool _kaydediyor = false;
  List<Map<String, dynamic>> _aramaSonuclari = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _bolgeAboneligi;
  StreamSubscription<User?>? _authAboneligi;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _kayitliBolgeler = [];

  CollectionReference<Map<String, dynamic>>? get _bolgeler {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('safeZones');
  }

  @override
  void initState() {
    super.initState();
    _authAboneligi = FirebaseAuth.instance.authStateChanges().listen((_) {
      _bolgeAboneligi?.cancel();
      final bolgeler = _bolgeler;
      if (mounted) {
        setState(() {
          _kayitliBolgeler = [];
          _hata = null;
        });
      }
      if (bolgeler == null) return;
      _bolgeAboneligi = bolgeler.snapshots().listen(
        (snapshot) {
          if (mounted) setState(() => _kayitliBolgeler = snapshot.docs);
        },
        onError: (Object error) {
          if (mounted) {
            setState(() => _hata = _firestoreHataMetni(error, 'yüklenemedi'));
          }
        },
      );
    });
  }

  String _firestoreHataMetni(Object error, String islem) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Bölgelere erişim izni yok. Hesabını kontrol et ve Firestore kurallarını yayımla.';
        case 'unauthenticated':
          return 'Bölgeleri görmek için giriş yapmalısın.';
        case 'unavailable':
          return 'İnternet bağlantısı yok. Bölgeler $islem.';
      }
    }
    return 'Bölgeler $islem. (${error.toString()})';
  }

  Future<void> _konumuGuncelle() async {
    setState(() {
      _konumYukleniyor = true;
      _hata = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Konum servisi kapalı. Cihaz ayarlarından aç.');
      }
      var izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
      }
      if (izin == LocationPermission.denied ||
          izin == LocationPermission.deniedForever) {
        throw Exception('Konum izni gerekli.');
      }
      final konum = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      if (!mounted) return;
      final nokta = LatLng(konum.latitude, konum.longitude);
      setState(() {
        _konum = konum;
        _seciliNokta = nokta;
        _seciliAdres = 'Mevcut konum';
      });
      _mapController.move(nokta, 15);
    } catch (e) {
      if (mounted) {
        setState(() => _hata = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _konumYukleniyor = false);
    }
  }

  Future<void> _adresAra() async {
    final sorgu = _aramaController.text.trim();
    if (sorgu.length < 3) {
      setState(() {
        _hata = 'Aramak için en az 3 karakter yaz.';
        _aramaSonuclari = [];
      });
      return;
    }
    setState(() {
      _aramaYukleniyor = true;
      _hata = null;
      _aramaSonuclari = [];
    });
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': sorgu,
        'format': 'jsonv2',
        'limit': '5',
        'accept-language': 'tr',
      });
      final response = await http
          .get(
            uri,
            headers: {'User-Agent': 'GuvendeSafetyApp/1.0 (address search)'},
          )
          .timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        throw Exception('Adres araması şu anda kullanılamıyor.');
      }
      final data = jsonDecode(response.body) as List<dynamic>;
      if (!mounted) return;
      setState(() => _aramaSonuclari = data.cast<Map<String, dynamic>>());
      if (_aramaSonuclari.isEmpty) {
        setState(() => _hata = 'Bu adres için sonuç bulunamadı.');
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _hata = 'Adres aranamadı. İnternet bağlantını kontrol et.',
        );
      }
    } finally {
      if (mounted) setState(() => _aramaYukleniyor = false);
    }
  }

  void _sonucSec(Map<String, dynamic> sonuc) {
    final nokta = LatLng(
      double.parse(sonuc['lat'] as String),
      double.parse(sonuc['lon'] as String),
    );
    final adres = sonuc['display_name'] as String? ?? 'Seçilen adres';
    setState(() {
      _seciliNokta = nokta;
      _seciliAdres = adres;
      _aramaController.text = adres;
      _aramaSonuclari = [];
      _hata = null;
    });
    _mapController.move(nokta, 16);
  }

  void _haritadaNoktaSec(TapPosition _, LatLng nokta) {
    setState(() {
      _seciliNokta = nokta;
      _seciliAdres = null;
      _hata = null;
    });
  }

  Future<void> _bolgeKaydet() async {
    final koleksiyon = _bolgeler;
    final ad = _adController.text.trim();
    final nokta = _seciliNokta;
    if (koleksiyon == null) {
      setState(() => _hata = 'Bölge kaydetmek için giriş yapmalısın.');
      return;
    }
    if (nokta == null || ad.isEmpty) {
      setState(() => _hata = 'Bir konum seçip bölgeye ad ver.');
      return;
    }
    setState(() {
      _kaydediyor = true;
      _hata = null;
    });
    try {
      await koleksiyon.add({
        'name': ad,
        'address': _seciliAdres ?? '',
        'latitude': nokta.latitude,
        'longitude': nokta.longitude,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      setState(() {
        _seciliNokta = null;
        _seciliAdres = null;
        _adController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Güvenli bölge kaydedildi.')),
      );
    } catch (error) {
      if (mounted) {
        setState(() => _hata = _firestoreHataMetni(error, 'kaydedilemedi'));
      }
    } finally {
      if (mounted) setState(() => _kaydediyor = false);
    }
  }

  @override
  void dispose() {
    _authAboneligi?.cancel();
    _bolgeAboneligi?.cancel();
    _mapController.dispose();
    _aramaController.dispose();
    _adController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bolgeler = _bolgeler;
    return Scaffold(
      backgroundColor: krem,
      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Güvenli Bölgeler',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Text(
                'Güvenli Bölgeler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: yazi,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Haritaya dokun veya adres ara, sonra bölgeyi kaydet.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _aramaController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _adresAra(),
                      decoration: InputDecoration(
                        hintText: 'Adres veya yer ara',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: bordo,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Adresi ara',
                    onPressed: _aramaYukleniyor ? null : _adresAra,
                    icon: _aramaYukleniyor
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: bordo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (_aramaSonuclari.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: _aramaSonuclari
                        .map(
                          (sonuc) => ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.location_on_outlined,
                              color: bordo,
                            ),
                            title: Text(
                              sonuc['display_name'] as String? ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _sonucSec(sonuc),
                          ),
                        )
                        .toList(),
                  ),
                ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 330,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _konum == null
                          ? const LatLng(39.0, 35.0)
                          : LatLng(_konum!.latitude, _konum!.longitude),
                      initialZoom: _konum == null ? 5 : 15,
                      onTap: _haritadaNoktaSec,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.guvende.app',
                      ),
                      MarkerLayer(
                        markers: [
                          if (_konum != null)
                            Marker(
                              point: LatLng(
                                _konum!.latitude,
                                _konum!.longitude,
                              ),
                              width: 44,
                              height: 44,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                                size: 32,
                              ),
                            ),
                          if (_seciliNokta != null)
                            Marker(
                              point: _seciliNokta!,
                              width: 48,
                              height: 48,
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: bordo,
                                size: 44,
                              ),
                            ),
                          ..._kayitliBolgeler.map((doc) {
                            final data = doc.data();
                            final lat = (data['latitude'] as num).toDouble();
                            final lon = (data['longitude'] as num).toDouble();
                            return Marker(
                              point: LatLng(lat, lon),
                              width: 44,
                              height: 44,
                              child: GestureDetector(
                                onTap: () =>
                                    _mapController.move(LatLng(lat, lon), 16),
                                child: const Icon(
                                  Icons.shield_rounded,
                                  color: bordo,
                                  size: 36,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution('© OpenStreetMap contributors'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Haritada dokunarak kaydedilecek konumu seç.',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Mevcut konumumu bul',
                    onPressed: _konumYukleniyor ? null : _konumuGuncelle,
                    icon: _konumYukleniyor
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: bordo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (_seciliNokta != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _seciliAdres ??
                            '${_seciliNokta!.latitude.toStringAsFixed(5)}, ${_seciliNokta!.longitude.toStringAsFixed(5)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _adController,
                        maxLength: 80,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Bölge adı',
                          hintText: 'Örn. Evim',
                          filled: true,
                          fillColor: krem,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _kaydediyor ? null : _bolgeKaydet,
                          icon: _kaydediyor
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.bookmark_add_outlined),
                          label: const Text('Güvenli Bölgeyi Kaydet'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bordo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_hata != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _hata!,
                    style: const TextStyle(color: bordo, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 18),
              if (bolgeler == null)
                const Text(
                  'Kaydedilen bölgeleri görmek için giriş yapmalısın.',
                  style: TextStyle(color: Colors.black54),
                )
              else
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: bolgeler
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        _firestoreHataMetni(snapshot.error!, 'yüklenemedi'),
                        style: const TextStyle(color: bordo),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: bordo),
                      );
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Text(
                        'Henüz güvenli bölge kaydedilmedi.',
                        style: TextStyle(color: Colors.black54),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kaydedilen Bölgeler',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: yazi,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...docs.map((doc) {
                          final data = doc.data();
                          final lat = (data['latitude'] as num).toDouble();
                          final lon = (data['longitude'] as num).toDouble();
                          final adres = data['address'] as String? ?? '';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: pudra,
                                child: Icon(Icons.shield_rounded, color: bordo),
                              ),
                              title: Text(
                                data['name'] as String? ?? 'Güvenli Bölge',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: yazi,
                                ),
                              ),
                              subtitle: Text(
                                adres.isEmpty
                                    ? '${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}'
                                    : adres,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () =>
                                  _mapController.move(LatLng(lat, lon), 16),
                              trailing: IconButton(
                                tooltip: 'Bölgeyi sil',
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: bordo,
                                ),
                                onPressed: () async {
                                  try {
                                    await doc.reference.delete();
                                  } catch (_) {
                                    if (mounted) {
                                      setState(
                                        () => _hata =
                                            'Bölge silinemedi. Tekrar dene.',
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class YolculukSayfasi extends StatefulWidget {
  const YolculukSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color pudra = Color(0xFFD9A6A6);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  State<YolculukSayfasi> createState() => _YolculukSayfasiState();
}

class _YolculukSayfasiState extends State<YolculukSayfasi> {
  final _hedefController = TextEditingController();
  final _koordinatController = TextEditingController();
  final _mapController = MapController();
  Position? _konum;
  LatLng? _hedefKonum;
  StreamSubscription<Position>? _konumAboneligi;
  DateTime? _baslangic;
  Timer? _saat;
  Duration _gecenSure = Duration.zero;
  bool _baslatiliyor = false;
  bool _tamamlandi = false;
  bool _haritaHazir = false;
  String? _hata;

  bool get _aktif => _baslangic != null && !_tamamlandi;

  void _konumuHaritayaOrtala() {
    final konum = _konum;
    if (_haritaHazir && konum != null) {
      _mapController.move(LatLng(konum.latitude, konum.longitude), 15);
    }
  }

  LocationSettings _takipAyarlariniOlustur() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        intervalDuration: Duration(seconds: 5),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        pauseLocationUpdatesAutomatically: false,
        allowBackgroundLocationUpdates: false,
      );
    }
    return const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
  }

  Future<Position> _ilkKonumuAl() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Konum servisi kapalı. Lütfen cihaz ayarlarından aç.');
    }
    var izin = await Geolocator.checkPermission();
    if (izin == LocationPermission.denied) {
      izin = await Geolocator.requestPermission();
    }
    if (izin == LocationPermission.denied ||
        izin == LocationPermission.deniedForever) {
      throw Exception('Yolculuk takibi için konum izni gerekli.');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
  }

  Future<void> _yolculuguBaslat() async {
    if (_hedefController.text.trim().isEmpty &&
        _koordinatController.text.trim().isEmpty) {
      setState(
        () => _hata = 'Başlamadan önce bir hedef adı veya koordinat gir.',
      );
      return;
    }
    LatLng? hedef;
    final koordinat = _koordinatController.text.trim();
    if (koordinat.isNotEmpty) {
      final parcalar = koordinat
          .split(RegExp(r'[,;\s]+'))
          .where((e) => e.isNotEmpty)
          .toList();
      final lat = parcalar.isNotEmpty ? double.tryParse(parcalar[0]) : null;
      final lon = parcalar.length > 1 ? double.tryParse(parcalar[1]) : null;
      if (lat == null ||
          lon == null ||
          lat < -90 ||
          lat > 90 ||
          lon < -180 ||
          lon > 180) {
        setState(
          () => _hata =
              'Koordinatı enlem, boylam şeklinde gir (ör. 41.0082, 28.9784).',
        );
        return;
      }
      hedef = LatLng(lat, lon);
    }
    setState(() {
      _baslatiliyor = true;
      _hata = null;
    });
    try {
      final konum = await _ilkKonumuAl();
      if (!mounted) return;
      setState(() {
        _konum = konum;
        _hedefKonum = hedef;
        _baslangic = DateTime.now();
        _tamamlandi = false;
        _gecenSure = Duration.zero;
        _haritaHazir = false;
      });
      _konumAboneligi?.cancel();
      _konumAboneligi =
          Geolocator.getPositionStream(
            locationSettings: _takipAyarlariniOlustur(),
          ).listen(
            (yeniKonum) {
              if (!mounted) return;
              setState(() => _konum = yeniKonum);
              _konumuHaritayaOrtala();
            },
            onError: (Object error) {
              if (!mounted || !_aktif) return;
              setState(() {
                _hata = error is LocationServiceDisabledException
                    ? 'Konum servisi kapandı. Takibe devam etmek için cihaz ayarlarından aç.'
                    : error is PermissionDeniedException
                    ? 'Konum izni kaldırıldığı için takip durdu. İzni ayarlardan aç.'
                    : 'Konum güncellenemedi. GPS ayarlarını kontrol edip yeniden deneyebilirsin.';
              });
            },
          );
      _saat = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted && _baslangic != null) {
          setState(() => _gecenSure = DateTime.now().difference(_baslangic!));
        }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(LatLng(konum.latitude, konum.longitude), 15);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _hata = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _baslatiliyor = false);
    }
  }

  Future<void> _yolculuguBitir() async {
    final abonelik = _konumAboneligi;
    _konumAboneligi = null;
    await abonelik?.cancel();
    _saat?.cancel();
    if (!mounted) return;
    setState(() {
      _tamamlandi = true;
      if (_baslangic != null) {
        _gecenSure = DateTime.now().difference(_baslangic!);
      }
    });
  }

  String get _sureMetni {
    final dakika = _gecenSure.inMinutes;
    final saniye = _gecenSure.inSeconds % 60;
    final saat = _gecenSure.inHours;
    return saat > 0
        ? '${saat}s ${dakika % 60}dk ${saniye}sn'
        : '${dakika}dk ${saniye}sn';
  }

  @override
  void dispose() {
    _konumAboneligi?.cancel();
    _saat?.cancel();
    _hedefController.dispose();
    _koordinatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final merkez = _konum == null
        ? const LatLng(39.0, 35.0)
        : LatLng(_konum!.latitude, _konum!.longitude);
    return Scaffold(
      backgroundColor: YolculukSayfasi.krem,
      appBar: AppBar(
        backgroundColor: YolculukSayfasi.bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Yolculuk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Güvenli Yolculuk',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: YolculukSayfasi.yazi,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Hedefini belirle, yolculuğunu başlat ve varışında tamamla.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            if (_aktif || _tamamlandi) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 270,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: merkez,
                      initialZoom: _konum == null ? 5 : 15,
                      onMapReady: () {
                        _haritaHazir = true;
                        _konumuHaritayaOrtala();
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.guvende',
                      ),
                      if (_konum != null && _hedefKonum != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [
                                LatLng(_konum!.latitude, _konum!.longitude),
                                _hedefKonum!,
                              ],
                              color: YolculukSayfasi.bordo,
                              strokeWidth: 3,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          if (_konum != null)
                            Marker(
                              point: LatLng(
                                _konum!.latitude,
                                _konum!.longitude,
                              ),
                              width: 44,
                              height: 44,
                              child: const Icon(
                                Icons.my_location,
                                color: YolculukSayfasi.bordo,
                                size: 38,
                              ),
                            ),
                          if (_hedefKonum != null)
                            Marker(
                              point: _hedefKonum!,
                              width: 44,
                              height: 44,
                              child: const Icon(
                                Icons.flag_rounded,
                                color: Colors.green,
                                size: 38,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(
                      _tamamlandi
                          ? Icons.check_circle
                          : Icons.navigation_rounded,
                      color: _tamamlandi ? Colors.green : YolculukSayfasi.bordo,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tamamlandi
                                ? 'Yolculuk tamamlandı'
                                : 'Yolculuk devam ediyor',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: YolculukSayfasi.yazi,
                            ),
                          ),
                          Text(
                            'Hedef: ${_hedefController.text.trim().isEmpty ? 'Belirtilmedi' : _hedefController.text.trim()}  •  Süre: $_sureMetni',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_tamamlandi)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Varış bildirimi: Yolculuğunu tamamlandı olarak işaretledin.',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: YolculukSayfasi.pudra,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.directions_walk_rounded,
                      color: YolculukSayfasi.bordo,
                      size: 48,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Yolculuğa hazır mısın?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: YolculukSayfasi.yazi,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Hedef adını ve istersen harita koordinatını gir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _hedefController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Hedef adı',
                  hintText: 'Örn. Ev, okul veya iş',
                  prefixIcon: const Icon(
                    Icons.location_on_rounded,
                    color: YolculukSayfasi.bordo,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _koordinatController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Hedef koordinatı (isteğe bağlı)',
                  hintText: '41.0082, 28.9784',
                  prefixIcon: const Icon(
                    Icons.map_outlined,
                    color: YolculukSayfasi.bordo,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
            if (_hata != null) ...[
              const SizedBox(height: 12),
              Text(
                _hata!,
                style: const TextStyle(color: YolculukSayfasi.bordo),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _baslatiliyor
                    ? null
                    : (_aktif
                          ? _yolculuguBitir
                          : (_tamamlandi
                                ? () => setState(() {
                                    _tamamlandi = false;
                                    _baslangic = null;
                                    _konum = null;
                                    _hedefKonum = null;
                                    _gecenSure = Duration.zero;
                                    _haritaHazir = false;
                                  })
                                : _yolculuguBaslat)),
                icon: Icon(
                  _aktif
                      ? Icons.flag_rounded
                      : _tamamlandi
                      ? Icons.add_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(
                  _baslatiliyor
                      ? 'Konum alınıyor...'
                      : _aktif
                      ? 'YOLCULUĞU BİTİR / VARIŞI BİLDİR'
                      : _tamamlandi
                      ? 'YENİ YOLCULUK'
                      : 'YOLCULUĞU BAŞLAT',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: YolculukSayfasi.bordo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Konum yalnızca bu ekran açıkken izlenir. Uygulama arka plandayken takip yapılmaz; yolculuk bilgisi kalıcı olarak kaydedilmez.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class SosSayfasi extends StatefulWidget {
  const SosSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  State<SosSayfasi> createState() => _SosSayfasiState();
}

class _SosSayfasiState extends State<SosSayfasi> {
  bool _baslatiliyor = false;

  Future<Position> _konumuAl() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception(
        'Konum hizmetleri kapalı. Cihaz ayarlarından açıp tekrar deneyin.',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Konum izni verilmedi. SOS başlatılamadı.');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
  }

  Future<void> _sosOnayla() async {
    if (_baslatiliyor) return;
    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('SOS başlatılsın mı?'),
        content: const Text(
          'Güncel konumun alınacak ve SOS kaydı oluşturulmaya çalışılacak. '
          'Güvenilir kişilere otomatik SMS veya bildirim gönderilmez; '
          'konum bağlantısını paylaşım ekranından sen gönderebilirsin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('VAZGEÇ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: SosSayfasi.bordo),
            child: const Text('SOS’U BAŞLAT'),
          ),
        ],
      ),
    );
    if (onay != true || !mounted) return;

    setState(() => _baslatiliyor = true);
    try {
      final position = await _konumuAl();
      final user = FirebaseAuth.instance.currentUser;
      final trustedContacts = <Map<String, String>>[];
      DocumentReference<Map<String, dynamic>>? incidentRef;
      var contactsLoaded = user == null;
      var recordSaved = user == null;
      String? recordError;

      if (user != null) {
        try {
          final contacts = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('trustedContacts')
              .get();
          for (final contact in contacts.docs) {
            final data = contact.data();
            trustedContacts.add({
              'ad': data['ad'] as String? ?? 'Güvenilir kişi',
              'telefon': data['telefon'] as String? ?? '',
            });
          }
          contactsLoaded = true;
        } on FirebaseException {
          contactsLoaded = false;
        }

        try {
          incidentRef = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('sosAlerts')
              .add({
                'status': 'active',
                'latitude': position.latitude,
                'longitude': position.longitude,
                'mapUrl':
                    'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',
                'createdAt': FieldValue.serverTimestamp(),
              });
          recordSaved = true;
        } on FirebaseException catch (error) {
          recordSaved = false;
          recordError = '${error.code}: ${error.message ?? error.toString()}';
        }
      }

      if (!mounted) return;
      final cancelled = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => SosAktifSayfasi(
            position: position,
            trustedContacts: trustedContacts,
            incidentRef: incidentRef,
            recordSaved: recordSaved,
            recordError: recordError,
            contactsLoaded: contactsLoaded,
            signedIn: user != null,
          ),
        ),
      );
      if (cancelled == true && mounted) Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _baslatiliyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SosSayfasi.krem,
      appBar: AppBar(
        backgroundColor: SosSayfasi.bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Acil Yardım',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              'Acil Yardım',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: SosSayfasi.yazi,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kendini güvende hissetmediğinde\nSOS yardımını başlatabilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const Spacer(),
            Semantics(
              button: true,
              label: 'SOS yardımını başlat',
              child: GestureDetector(
                onTap: _baslatiliyor ? null : _sosOnayla,
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    color: SosSayfasi.bordo,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: SosSayfasi.bordo.withValues(alpha: 0.25),
                        blurRadius: 25,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: _baslatiliyor
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: Colors.white,
                                size: 45,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'SOS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Row(
              children: [
                Icon(Icons.location_on_outlined, color: SosSayfasi.bordo),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Başlatırken güncel konumun alınır.',
                    style: TextStyle(color: SosSayfasi.yazi, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Row(
              children: [
                Icon(Icons.people_outline, color: SosSayfasi.bordo),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Otomatik mesaj gönderimi yapılandırılmamıştır.',
                    style: TextStyle(color: SosSayfasi.yazi, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _baslatiliyor ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: SosSayfasi.bordo,
                  side: const BorderSide(color: SosSayfasi.bordo, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'İPTAL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BildirimlerSayfasi extends StatelessWidget {
  const BildirimlerSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color pudra = Color(0xFFD9A6A6);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Bildirimler',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: pudra.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: bordo,
                    size: 30,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Güvenliğinle ilgili bildirimler burada görünecek.',
                      style: TextStyle(color: yazi, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: bordo, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Güvenli Bölge',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: yazi,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Henüz gösterilecek bir bildirim yok. SOS uyarıları güvenilir kişilere otomatik gönderilmez; konumunu paylaşım ekranından kendin gönderebilirsin.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilSayfasi extends StatelessWidget {
  const ProfilSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color pudra = Color(0xFFD9A6A6);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),

            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: pudra,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 50,
                color: bordo,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Hoş Geldin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Hesabını yönet',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),

            const SizedBox(height: 30),

            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    _ProfilMenu(
                      icon: Icons.login_rounded,
                      title: 'Giriş Yap',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GirisSayfasi(),
                          ),
                        );
                      },
                    ),

                    _ProfilMenu(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Kayıt Ol',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KayitSayfasi(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),

            _ProfilMenu(
              icon: Icons.edit_outlined,
              title: 'Profil Bilgilerim',
              onTap: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GirisSayfasi()),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilBilgileriSayfasi(),
                  ),
                );
              },
            ),

            _ProfilMenu(
              icon: Icons.settings_outlined,
              title: 'Ayarlar',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AyarlarSayfasi(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'ÇIKIŞ YAP',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: bordo,
                      side: const BorderSide(color: bordo, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilBilgileriSayfasi extends StatefulWidget {
  const ProfilBilgileriSayfasi({super.key});

  @override
  State<ProfilBilgileriSayfasi> createState() => _ProfilBilgileriSayfasiState();
}

class _ProfilBilgileriSayfasiState extends State<ProfilBilgileriSayfasi> {
  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  final _adController = TextEditingController();
  bool _yukleniyor = true;
  bool _kaydediyor = false;
  String? _hata;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _bilgileriYukle();
  }

  Future<void> _bilgileriYukle() async {
    final user = _user;
    if (user == null) {
      setState(() {
        _yukleniyor = false;
        _hata = 'Profil bilgilerini görmek için giriş yapmalısın.';
      });
      return;
    }
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!mounted) return;
      _adController.text =
          (snapshot.data()?['name'] as String?) ?? user.displayName ?? '';
    } on FirebaseException catch (error) {
      if (mounted) {
        setState(
          () => _hata = error.message ?? 'Profil bilgileri yüklenemedi.',
        );
      }
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  Future<void> _kaydet() async {
    final user = _user;
    final ad = _adController.text.trim();
    if (user == null || ad.isEmpty) {
      setState(() => _hata = 'Lütfen ad soyad bilgisini gir.');
      return;
    }
    setState(() {
      _kaydediyor = true;
      _hata = null;
    });
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': ad,
        'phone': user.phoneNumber ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await user.updateDisplayName(ad);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil bilgilerin kaydedildi.')),
      );
    } on FirebaseException catch (error) {
      if (mounted) {
        setState(() => _hata = error.message ?? 'Profil kaydedilemedi.');
      }
    } finally {
      if (mounted) setState(() => _kaydediyor = false);
    }
  }

  @override
  void dispose() {
    _adController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    return Scaffold(
      backgroundColor: krem,
      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Profil Bilgilerim'),
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator(color: bordo))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFD9A6A6),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 48,
                    color: bordo,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _adController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Ad Soyad',
                    prefixIcon: const Icon(Icons.person_outline, color: bordo),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Telefon Numarası',
                    prefixIcon: const Icon(Icons.phone_outlined, color: bordo),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  child: Text(
                    user?.phoneNumber ?? 'Kayıtlı telefon bulunamadı',
                  ),
                ),
                if (_hata != null) ...[
                  const SizedBox(height: 12),
                  Text(_hata!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _kaydediyor ? null : _kaydet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bordo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _kaydediyor
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('BİLGİLERİ KAYDET'),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProfilMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfilMenu({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  static const Color bordo = Color(0xFF641E35);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: bordo),
        title: Text(
          title,
          style: const TextStyle(color: yazi, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }
}

class HaritaSayfasi extends StatefulWidget {
  const HaritaSayfasi({super.key});

  @override
  State<HaritaSayfasi> createState() => _HaritaSayfasiState();
}

class _HaritaSayfasiState extends State<HaritaSayfasi> {
  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);

  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _locationLoading = false;
  bool _showSafeZones = true;
  String? _locationError;

  Future<void> _showCurrentLocation() async {
    setState(() {
      _locationLoading = true;
      _locationError = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception(
          'Konum servisi kapalı. Cihaz ayarlarından açıp tekrar dene.',
        );
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception(
          'Konum izni verilmedi. Konumunu göstermek için izin gerekli.',
        );
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Konum izni kapalı. Cihaz ayarlarından Güvende için konum izni ver.',
        );
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      if (!mounted) return;
      final point = LatLng(position.latitude, position.longitude);
      setState(() => _currentLocation = point);
      _mapController.move(point, 15);
    } catch (error) {
      if (mounted) {
        setState(
          () =>
              _locationError = error.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _locationLoading = false);
    }
  }

  CollectionReference<Map<String, dynamic>>? get _safeZones {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('safeZones');
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Harita',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _safeZones?.snapshots(),
                    builder: (context, snapshot) {
                      final zones = snapshot.data?.docs ?? [];
                      final markers = <Marker>[
                        if (_currentLocation != null)
                          Marker(
                            point: _currentLocation!,
                            width: 48,
                            height: 48,
                            child: const Icon(
                              Icons.my_location_rounded,
                              color: Colors.blue,
                              size: 34,
                            ),
                          ),
                        if (_showSafeZones)
                          ...zones.map((doc) {
                            final data = doc.data();
                            final latitude = data['latitude'];
                            final longitude = data['longitude'];
                            if (latitude is! num || longitude is! num) {
                              return null;
                            }
                            return Marker(
                              point: LatLng(
                                latitude.toDouble(),
                                longitude.toDouble(),
                              ),
                              width: 56,
                              height: 58,
                              child: Tooltip(
                                message:
                                    data['name'] as String? ?? 'Güvenli Bölge',
                                child: const Icon(
                                  Icons.shield_rounded,
                                  color: bordo,
                                  size: 38,
                                ),
                              ),
                            );
                          }).whereType<Marker>(),
                      ];
                      return Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: const MapOptions(
                              initialCenter: LatLng(39.0, 35.0),
                              initialZoom: 5,
                              minZoom: 3,
                              maxZoom: 19,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.guvende.app',
                                errorTileCallback: (tile, error, stackTrace) {},
                              ),
                              MarkerLayer(markers: markers),
                              const RichAttributionWidget(
                                attributions: [
                                  TextSourceAttribution(
                                    '© OpenStreetMap contributors',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              _safeZones != null)
                            const Positioned(
                              top: 12,
                              left: 12,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_safeZones == null)
                            const Positioned(
                              top: 12,
                              left: 12,
                              right: 12,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Güvenli bölgelerini görmek için giriş yap.',
                                  ),
                                ),
                              ),
                            )
                          else if (snapshot.hasError)
                            const Positioned(
                              top: 12,
                              left: 12,
                              right: 12,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Güvenli bölgeler yüklenemedi. Bağlantını ve hesap erişimini kontrol et.',
                                  ),
                                ),
                              ),
                            )
                          else if (snapshot.connectionState !=
                                  ConnectionState.waiting &&
                              zones.isEmpty)
                            const Positioned(
                              top: 12,
                              left: 12,
                              right: 12,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Henüz kayıtlı güvenli bölgen yok.',
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            right: 12,
                            bottom: 38,
                            child: FloatingActionButton.small(
                              heroTag: 'harita_konum_ortala',
                              backgroundColor: Colors.white,
                              foregroundColor: bordo,
                              tooltip: 'Konumuma git',
                              onPressed: _currentLocation == null
                                  ? _showCurrentLocation
                                  : () => _mapController.move(
                                      _currentLocation!,
                                      15,
                                    ),
                              child: const Icon(Icons.my_location_rounded),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            bottom: 12,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  '© OpenStreetMap',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              if (_locationError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _locationError!,
                    style: const TextStyle(color: bordo, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _locationLoading ? null : _showCurrentLocation,
                  style: FilledButton.styleFrom(
                    backgroundColor: bordo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _locationLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.my_location_rounded),
                  label: Text(
                    _locationLoading
                        ? 'Konum alınıyor…'
                        : 'Mevcut konumumu göster',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      setState(() => _showSafeZones = !_showSafeZones),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: bordo,
                    side: const BorderSide(color: bordo),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(
                    _showSafeZones
                        ? Icons.visibility_off_outlined
                        : Icons.shield_outlined,
                  ),
                  label: Text(
                    _showSafeZones
                        ? 'Güvenli bölgeleri gizle'
                        : 'Güvenli bölgeleri göster',
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

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _telefonController = TextEditingController();
  bool _yukleniyor = false;

  String _telefonDuzenle(String telefon) {
    telefon = telefon.replaceAll(RegExp(r'\s+'), '');
    if (telefon.startsWith('0')) telefon = telefon.substring(1);
    if (!telefon.startsWith('+90')) telefon = '+90$telefon';
    return telefon;
  }

  Future<void> _girisYap() async {
    final telefon = _telefonDuzenle(_telefonController.text.trim());
    if (_telefonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Telefon numaranı gir.')));
      return;
    }
    setState(() => _yukleniyor = true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: telefon,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) _profilAc();
        },
        verificationFailed: (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.message ?? 'Giriş yapılamadı.')),
            );
            setState(() => _yukleniyor = false);
          }
        },
        codeSent: (verificationId, _) {
          if (!mounted) return;
          setState(() => _yukleniyor = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SmsDogrulamaSayfasi(
                verificationId: verificationId,
                telefon: telefon,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (_) {
          if (mounted) setState(() => _yukleniyor = false);
        },
      );
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Giriş yapılamadı.')),
        );
      }
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  void _profilAc() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ProfilBilgileriSayfasi()),
      (route) => route.isFirst,
    );
  }

  @override
  void dispose() {
    _telefonController.dispose();
    super.dispose();
  }

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Giriş Yap',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 35),

            const Icon(Icons.shield_outlined, size: 75, color: bordo),

            const SizedBox(height: 15),

            const Text(
              'Güvende',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: bordo,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Hesabına giriş yap',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),

            const SizedBox(height: 35),

            TextField(
              controller: _telefonController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telefon Numarası',
                prefixIcon: const Icon(Icons.phone_outlined, color: bordo),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _yukleniyor ? null : _girisYap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bordo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _yukleniyor
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'GİRİŞ YAP',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KayitSayfasi()),
                );
              },
              child: const Text(
                'Hesabın yok mu? Kayıt Ol',
                style: TextStyle(color: bordo, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({super.key});

  @override
  State<KayitSayfasi> createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  final TextEditingController adSoyadController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  bool _dogrulamaTamamlandi = false;

  String telefonNumarasiniDuzenle(String telefon) {
    telefon = telefon.replaceAll(' ', '');

    if (telefon.startsWith('0')) {
      telefon = telefon.substring(1);
    }

    if (!telefon.startsWith('+90')) {
      telefon = '+90$telefon';
    }

    return telefon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Kayıt Ol',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Text(
              'Hesap Oluştur',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Güvende hesabını oluştur.',
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: adSoyadController,
              decoration: InputDecoration(
                labelText: 'Ad Soyad',
                prefixIcon: const Icon(Icons.person_outline, color: bordo),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: telefonController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telefon Numarası',
                prefixIcon: const Icon(Icons.phone_outlined, color: bordo),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: bordo,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  final adSoyad = adSoyadController.text.trim();
                  final telefon = telefonNumarasiniDuzenle(
                    telefonController.text.trim(),
                  );

                  if (adSoyad.isEmpty ||
                      telefonController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Lütfen ad soyad ve telefon numaranızı girin.',
                        ),
                      ),
                    );
                    return;
                  }

                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: telefon,
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                          try {
                            final result = await FirebaseAuth.instance
                                .signInWithCredential(credential);
                            final user = result.user;
                            if (user == null) return;
                            _dogrulamaTamamlandi = true;
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({
                                  'name': adSoyad,
                                  'phone': user.phoneNumber ?? telefon,
                                  'updatedAt': FieldValue.serverTimestamp(),
                                  'createdAt': FieldValue.serverTimestamp(),
                                }, SetOptions(merge: true));
                            await user.updateDisplayName(adSoyad);
                            if (!context.mounted) return;
                            {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ProfilBilgileriSayfasi(),
                                ),
                                (route) => route.isFirst,
                              );
                            }
                          } on FirebaseException catch (error) {
                            if (!context.mounted) return;
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error.message ??
                                        'Profil bilgileri kaydedilemedi.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                    verificationFailed: (FirebaseAuthException e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.message ?? 'Telefon doğrulaması başlatılamadı.',
                          ),
                        ),
                      );
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      if (_dogrulamaTamamlandi) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SmsDogrulamaSayfasi(
                            verificationId: verificationId,
                            telefon: telefon,
                            adSoyad: adSoyad,
                          ),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bordo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'KAYIT OL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Zaten hesabın var mı? Giriş Yap',
                style: TextStyle(color: bordo, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmsDogrulamaSayfasi extends StatefulWidget {
  final String verificationId;
  final String telefon;
  final String? adSoyad;

  const SmsDogrulamaSayfasi({
    super.key,
    required this.verificationId,
    required this.telefon,
    this.adSoyad,
  });

  @override
  State<SmsDogrulamaSayfasi> createState() => _SmsDogrulamaSayfasiState();
}

class _SmsDogrulamaSayfasiState extends State<SmsDogrulamaSayfasi> {
  final TextEditingController kodController = TextEditingController();

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  bool yukleniyor = false;

  Future<void> koduDogrula() async {
    final kod = kodController.text.trim();

    if (kod.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen 6 haneli SMS kodunu girin.')),
      );
      return;
    }

    setState(() {
      yukleniyor = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: kod,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          if (widget.adSoyad != null) 'name': widget.adSoyad,
          'phone': user.phoneNumber ?? widget.telefon,
          'updatedAt': FieldValue.serverTimestamp(),
          if (widget.adSoyad != null) 'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        if (widget.adSoyad != null) {
          await user.updateDisplayName(widget.adSoyad!);
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hesabınız başarıyla oluşturuldu.')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProfilBilgileriSayfasi()),
        (route) => route.isFirst,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Kod doğrulanamadı.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          yukleniyor = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,
      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Telefon Doğrulama',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Icon(Icons.sms_outlined, size: 70, color: bordo),

            const SizedBox(height: 25),

            const Text(
              'SMS Kodunu Gir',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '${widget.telefon} numarasına gönderilen 6 haneli kodu gir.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: kodController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'SMS Kodu',
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: yukleniyor ? null : koduDogrula,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bordo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: yukleniyor
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'DOĞRULA',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AyarlarSayfasi extends StatelessWidget {
  const AyarlarSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Ayarlar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.notifications_outlined,
                      color: bordo,
                    ),
                    title: const Text(
                      'Bildirimler',
                      style: TextStyle(
                        color: yazi,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeThumbColor: bordo,
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: bordo,
                    ),
                    title: const Text(
                      'Konum İzinleri',
                      style: TextStyle(
                        color: yazi,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KonumIzinleriSayfasi(),
                        ),
                      );
                    },
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GizlilikSayfasi(),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.lock_outline_rounded,
                      color: bordo,
                    ),
                    title: const Text(
                      'Gizlilik ve Güvenlik',
                      style: TextStyle(
                        color: yazi,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YardimSayfasi(),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.help_outline_rounded,
                      color: bordo,
                    ),
                    title: const Text(
                      'Yardım',
                      style: TextStyle(
                        color: yazi,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(height: 1),

                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GuvendeHakkindaSayfasi(),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: bordo,
                    ),
                    title: const Text(
                      'Güvende Hakkında',
                      style: TextStyle(
                        color: yazi,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KonumIzinleriSayfasi extends StatefulWidget {
  const KonumIzinleriSayfasi({super.key});

  @override
  State<KonumIzinleriSayfasi> createState() => _KonumIzinleriSayfasiState();
}

class _KonumIzinleriSayfasiState extends State<KonumIzinleriSayfasi> {
  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  bool izinVerildi = false;
  @override
  void initState() {
    super.initState();
    konumIzniniKontrolEt();
  }

  Future<void> konumIzniniKontrolEt() async {
    final izin = await Geolocator.checkPermission();

    if (!mounted) return;

    setState(() {
      izinVerildi =
          izin == LocationPermission.always ||
          izin == LocationPermission.whileInUse;
    });
  }

  Future<void> konumIzniIste() async {
    final servisAcik = await Geolocator.isLocationServiceEnabled();

    if (!servisAcik) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Konum hizmetleri kapalı. Lütfen cihazınızdan konumu açın.',
          ),
        ),
      );
      return;
    }

    LocationPermission izin = await Geolocator.checkPermission();

    if (izin == LocationPermission.denied) {
      izin = await Geolocator.requestPermission();
    }

    if (izin == LocationPermission.denied ||
        izin == LocationPermission.deniedForever) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Konum izni verilmedi.')));
      return;
    }

    if (!mounted) return;

    setState(() {
      izinVerildi = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Konum izni başarıyla verildi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,
      appBar: AppBar(
        title: const Text('Konum İzinleri'),
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.location_on_outlined, size: 70, color: bordo),

            const SizedBox(height: 20),

            const Text(
              'Konum İzinleri',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Konum özelliği, güvenlik özelliklerinin '
              'çalışabilmesi için kullanılacaktır.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: yazi),
            ),

            const SizedBox(height: 25),

            ListTile(
              leading: const Icon(Icons.my_location, color: bordo),
              title: const Text('Konum erişimi'),
              subtitle: Text(
                izinVerildi
                    ? 'Konum izni etkin.'
                    : 'Konum izni henüz etkinleştirilmedi.',
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: konumIzniIste,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bordo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  izinVerildi ? 'KONUM İZNİ VERİLDİ' : 'KONUM İZNİ VER',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: bordo,
                  side: const BorderSide(color: bordo),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('GERİ DÖN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GizlilikSayfasi extends StatelessWidget {
  const GizlilikSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Gizlilik ve Güvenlik',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.lock_outline_rounded, size: 70, color: bordo),

            const SizedBox(height: 20),

            const Text(
              'Gizlilik ve Güvenlik',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.location_on_outlined, color: bordo),
                    title: Text('Konum Bilgileri'),
                    subtitle: Text(
                      'Konum bilgilerin güvenlik özellikleri için kullanılır.',
                    ),
                  ),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.people_outline, color: bordo),
                    title: Text('Güven Çemberi'),
                    subtitle: Text(
                      'Güven çemberindeki kişilerle paylaşılan bilgiler.',
                    ),
                  ),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.security_outlined, color: bordo),
                    title: Text('Güvenlik'),
                    subtitle: Text(
                      'Kişisel bilgilerin korunmasına yönelik ayarlar.',
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: bordo,
                  side: const BorderSide(color: bordo),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'GERİ DÖN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YardimSayfasi extends StatelessWidget {
  const YardimSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,

      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Yardım',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.help_outline_rounded, size: 70, color: bordo),

            const SizedBox(height: 20),

            const Text(
              'Nasıl Yardımcı Olabiliriz?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: yazi,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.warning_amber_rounded, color: bordo),
                    title: Text('SOS nasıl kullanılır?'),
                    subtitle: Text(
                      'Acil Yardım ekranından SOS işlemini başlatabilirsin.',
                    ),
                  ),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.people_outline, color: bordo),
                    title: Text('Güven Çemberi'),
                    subtitle: Text(
                      'Güvendiğin kişileri Güven Çemberine ekleyebilirsin.',
                    ),
                  ),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.location_on_outlined, color: bordo),
                    title: Text('Konum'),
                    subtitle: Text(
                      'Konum özellikleri güvenlik işlemlerinde kullanılacaktır.',
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: bordo,
                  side: const BorderSide(color: bordo),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'GERİ DÖN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GuvendeHakkindaSayfasi extends StatelessWidget {
  const GuvendeHakkindaSayfasi({super.key});

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: krem,
      appBar: AppBar(
        backgroundColor: bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Güvende Hakkında',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 25),

            const Icon(Icons.shield_outlined, size: 80, color: bordo),

            const SizedBox(height: 20),

            const Text(
              'Güvende',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: bordo,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Güvenliğin için tasarlanmış bir mobil uygulama.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: yazi),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.security_outlined, color: bordo),
                    title: Text(
                      'Güvenlik',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Güvenlik ihtiyaçlarında hızlı ve kolay erişim sağlamayı amaçlar.',
                    ),
                  ),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.warning_amber_rounded, color: bordo),
                    title: Text(
                      'Acil Yardım',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Acil durumlarda SOS özelliklerine hızlıca ulaşabilmeni sağlar.',
                    ),
                  ),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.info_outline_rounded, color: bordo),
                    title: Text(
                      'Uygulama Sürümü',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Sürüm 1.0.0'),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: bordo,
                  side: const BorderSide(color: bordo),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'GERİ DÖN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SosAktifSayfasi extends StatefulWidget {
  const SosAktifSayfasi({
    super.key,
    required this.position,
    required this.trustedContacts,
    required this.recordSaved,
    required this.recordError,
    required this.contactsLoaded,
    required this.signedIn,
    this.incidentRef,
  });

  final Position position;
  final List<Map<String, String>> trustedContacts;
  final DocumentReference<Map<String, dynamic>>? incidentRef;
  final bool recordSaved;
  final String? recordError;
  final bool contactsLoaded;
  final bool signedIn;

  static const Color bordo = Color(0xFF641E35);
  static const Color krem = Color(0xFFFFF8F0);
  static const Color yazi = Color(0xFF2D2424);

  @override
  State<SosAktifSayfasi> createState() => _SosAktifSayfasiState();
}

class _SosAktifSayfasiState extends State<SosAktifSayfasi> {
  bool _islemde = false;

  String get _mapsLink =>
      'https://www.google.com/maps/search/?api=1&query=${widget.position.latitude},${widget.position.longitude}';

  Future<void> _konumuPaylas() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text:
              'Acil yardıma ihtiyacım var. Lütfen beni hemen ara. Güncel konumum: $_mapsLink',
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Paylaşım ekranı açıldı. Gönderimin tamamlandığını uygulama doğrulayamaz.',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Paylaşım ekranı açılamadı. Konum bağlantısını kopyalayıp kendin gönderebilirsin.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _sosIptalEt() async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('SOS’u durdur?'),
        content: const Text(
          'Açık SOS kaydı kapatılacak. Bu işlem acil servisleri bilgilendirmez.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('DEVAM ET'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: SosAktifSayfasi.bordo,
            ),
            child: const Text('SOS’U DURDUR'),
          ),
        ],
      ),
    );
    if (onay != true || !mounted) return;
    setState(() => _islemde = true);
    try {
      if (widget.incidentRef != null) {
        await widget.incidentRef!.update({
          'status': 'cancelled',
          'cancelledAt': FieldValue.serverTimestamp(),
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.incidentRef == null
                ? 'SOS bu cihazda durduruldu.'
                : 'SOS durduruldu ve kayıt kapatıldı.',
          ),
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } on FirebaseException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'SOS kaydı kapatılamadı: ${error.message ?? 'Bağlantıyı kontrol edip tekrar deneyin.'}',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _islemde = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationText =
        '${widget.position.latitude.toStringAsFixed(6)}, ${widget.position.longitude.toStringAsFixed(6)}';
    return Scaffold(
      backgroundColor: SosAktifSayfasi.krem,
      appBar: AppBar(
        backgroundColor: SosAktifSayfasi.bordo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'SOS Aktif',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.warning_amber_rounded,
                size: 72,
                color: SosAktifSayfasi.bordo,
              ),
              const SizedBox(height: 12),
              const Text(
                'SOS Aktif',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: SosAktifSayfasi.bordo,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.recordSaved
                    ? 'SOS kaydı açık.'
                    : 'Konum alındı; SOS kaydı buluta kaydedilemedi.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: SosAktifSayfasi.yazi,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Güncel konum',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: SosAktifSayfasi.yazi,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(locationText),
                    TextButton.icon(
                      onPressed: _konumuPaylas,
                      icon: const Icon(Icons.share_location_rounded),
                      label: const Text('Konum bağlantısını paylaş'),
                    ),
                    const Divider(),
                    const Text(
                      'Güven çemberi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: SosAktifSayfasi.yazi,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!widget.signedIn)
                      const Text('Kişileri göstermek için giriş yapmalısın.')
                    else if (!widget.contactsLoaded)
                      const Text(
                        'Güvenilir kişiler yüklenemedi. İnternet bağlantını kontrol et.',
                      )
                    else if (widget.trustedContacts.isEmpty)
                      const Text('Güven çemberinde kayıtlı kişi yok.')
                    else
                      ...widget.trustedContacts.map(
                        (contact) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: const Icon(
                            Icons.person_outline,
                            color: SosAktifSayfasi.bordo,
                          ),
                          title: Text(contact['ad'] ?? 'Güvenilir kişi'),
                          subtitle: Text(contact['telefon'] ?? ''),
                        ),
                      ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bu kişiler otomatik olarak bilgilendirilmedi. Paylaşım ekranında seçtiğin uygulamadan mesajı sen gönderebilirsin.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    if (widget.signedIn)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          widget.recordSaved
                              ? 'SOS durumu hesabına kaydedildi.'
                              : 'SOS durumu hesabına kaydedilemedi.'
                                    '${widget.recordError == null ? '' : '\n${widget.recordError}'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _islemde ? null : _sosIptalEt,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SosAktifSayfasi.bordo,
                    side: const BorderSide(
                      color: SosAktifSayfasi.bordo,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _islemde
                      ? const CircularProgressIndicator()
                      : const Text(
                          'SOS’U DURDUR',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
