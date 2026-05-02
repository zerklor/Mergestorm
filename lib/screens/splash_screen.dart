import 'dart:async';

import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF4D6),
              const Color(0xFFFFE1A8),
              const Color(0xFFF9A23F).withOpacity(0.92),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.90, end: 1.0),
                duration: const Duration(milliseconds: 1100),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 148,
                  height: 148,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E8).withOpacity(0.92),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(color: const Color(0xFFF7C86B), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26C57B18),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(18),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final colors = [
                        const Color(0xFFFDE68A),
                        const Color(0xFFFBBF24),
                        const Color(0xFFF59E0B),
                        const Color(0xFFF97316),
                      ];
                      return Container(
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x228A5A12),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Mergestorm',
                style: TextStyle(
                  color: Color(0xFF9A4C00),
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Fusionne, progresse, débloque des skins.',
                style: TextStyle(
                  color: const Color(0xFFB35E05),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF28C18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}