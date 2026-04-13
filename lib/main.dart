import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/schedule_provider.dart';
import 'services/ai_schedule_service.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => AiScheduleServices()),
      ],
      child: const ScheduleResolverApp(),
    ),
  );
}

class ScheduleResolverApp extends StatelessWidget {
  const ScheduleResolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Resolver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF472B6),
          onPrimary: Color(0xFF1A0010),
          surface: Color(0xFF111114),
          onSurface: Color(0xFFF1F0F5),
          surfaceContainerHighest: Color(0xFF1C1C21),
          outline: Color(0xFF2E2E36),
        ),
        scaffoldBackgroundColor: const Color(0xFF0E0E11),
        textTheme: GoogleFonts.dmSansTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: const Color(0xFFF1F0F5),
          displayColor: const Color(0xFFF1F0F5),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0E0E11),
          foregroundColor: const Color(0xFFF1F0F5),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F0F5),
            letterSpacing: 0.3,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1C1C21),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF2E2E36), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF472B6),
            foregroundColor: const Color(0xFF1A0010),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFF472B6),
            side: const BorderSide(color: Color(0xFF3D2030), width: 1),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1C1C21),
          labelStyle: GoogleFonts.dmSans(color: const Color(0xFF888896), fontSize: 13),
          hintStyle: GoogleFonts.dmSans(color: const Color(0xFF555560)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E2E36), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E2E36), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFF472B6), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF472B6),
          foregroundColor: Color(0xFF1A0010),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color(0xFFF472B6),
          inactiveTrackColor: Color(0xFF2E2E36),
          thumbColor: Color(0xFFF472B6),
          overlayColor: Color(0x20F472B6),
          trackHeight: 3,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF2E2E36),
          thickness: 1,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}