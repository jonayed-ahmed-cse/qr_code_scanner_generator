import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_code/generate_qr_code.dart';
import 'package:qr_code/scan_qr_code.dart';
import 'package:qr_code/history_screen.dart';

void main() {
  runApp(const MyApp());
}

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color primary;
  final Color accent;
  final Color bgTop;
  final Color bgBottom;
  final Color textPrimary;
  final Color textGrey;
  final Color glassFill;
  final Color glassFillStrong;
  final Color glassBorder;

  const AppPalette({
    required this.primary,
    required this.accent,
    required this.bgTop,
    required this.bgBottom,
    required this.textPrimary,
    required this.textGrey,
    required this.glassFill,
    required this.glassFillStrong,
    required this.glassBorder,
  });

  static const dark = AppPalette(
    primary: Color(0xFF7C6CFF),
    accent: Color(0xFF35E0C6),
    bgTop: Color(0xFF14122A),
    bgBottom: Color(0xFF07070F),
    textPrimary: Color(0xFFF3F4FA),
    textGrey: Color(0xFF9AA0B4),
    glassFill: Color(0x14FFFFFF),
    glassFillStrong: Color(0x1FFFFFFF),
    glassBorder: Color(0x26FFFFFF),
  );

  static const light = AppPalette(
    primary: Color(0xFF6C5CE7),
    accent: Color(0xFF00B0A0),
    bgTop: Color(0xFFEFF1FF),
    bgBottom: Color(0xFFDCE3FA),
    textPrimary: Color(0xFF1E2233),
    textGrey: Color(0xFF667085),
    glassFill: Color(0xB3FFFFFF),
    glassFillStrong: Color(0xE6FFFFFF),
    glassBorder: Color(0x33202436),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? accent,
    Color? bgTop,
    Color? bgBottom,
    Color? textPrimary,
    Color? textGrey,
    Color? glassFill,
    Color? glassFillStrong,
    Color? glassBorder,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      bgTop: bgTop ?? this.bgTop,
      bgBottom: bgBottom ?? this.bgBottom,
      textPrimary: textPrimary ?? this.textPrimary,
      textGrey: textGrey ?? this.textGrey,
      glassFill: glassFill ?? this.glassFill,
      glassFillStrong: glassFillStrong ?? this.glassFillStrong,
      glassBorder: glassBorder ?? this.glassBorder,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      bgTop: Color.lerp(bgTop, other.bgTop, t)!,
      bgBottom: Color.lerp(bgBottom, other.bgBottom, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textGrey: Color.lerp(textGrey, other.textGrey, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassFillStrong: Color.lerp(glassFillStrong, other.glassFillStrong, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
    );
  }
}

class AppColors {
  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? AppPalette.dark;
}

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c.bgTop, c.bgBottom],
            ),
          ),
        ),
        Positioned(
          top: -70,
          right: -60,
          child: _glow(c.primary.withValues(alpha: 0.30), 220),
        ),
        Positioned(
          bottom: -90,
          left: -70,
          child: _glow(c.accent.withValues(alpha: 0.18), 260),
        ),
        child,
      ],
    );
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? fill;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 24,
    this.fill,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fill ?? c.glassFill,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: c.glassBorder, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassCircle extends StatelessWidget {
  final double size;
  final Widget child;
  const GlassCircle({super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.glassFill,
            border: Border.all(color: c.glassBorder, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

ThemeData _buildTheme(AppPalette p, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: p.bgBottom,
    colorScheme: ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: brightness,
      primary: p.primary,
    ),
    extensions: [p],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: p.textPrimary),
      titleTextStyle: TextStyle(
        color: p.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: p.primary.withValues(alpha: 0.5),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.textPrimary,
        backgroundColor: p.glassFill,
        minimumSize: const Size.fromHeight(54),
        side: BorderSide(color: p.glassBorder, width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.textPrimary,
        minimumSize: const Size.fromHeight(48),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.glassFill,
      hintStyle: TextStyle(color: p.textGrey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: p.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: p.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: p.primary, width: 1.5),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner and Generator',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(AppPalette.light, Brightness.light),
      darkTheme: _buildTheme(AppPalette.dark, Brightness.dark),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlassCircle(
                  size: 96,
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 46,
                    color: c.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'QR Link',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fast, precise, and secure QR code management.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: c.textGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ScanQrCode()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Scan QR Code'),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GenerateQRCode(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_box_outlined),
                  label: const Text('Generate QR Code'),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history_rounded),
                  label: const Text('History'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}