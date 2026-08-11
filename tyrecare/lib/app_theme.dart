import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF090A0D);
  static const surface = Color(0xFF14161B);
  static const surfaceRaised = Color(0xFF1A1D24);
  static const border = Color(0xFF2A2E37);
  static const primary = Color(0xFFE6494F);
  static const primaryBright = Color(0xFFFF646A);
  static const textMuted = Color(0xFFA6ABB7);
}

ThemeData tyreCareTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    surface: AppColors.surface,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme.copyWith(primary: AppColors.primary, surface: AppColors.surface),
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: .4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      labelStyle: const TextStyle(color: AppColors.textMuted),
      hintStyle: const TextStyle(color: AppColors.textMuted),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primaryBright,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: .7),
  );
}

class PremiumSectionTitle extends StatelessWidget {
  const PremiumSectionTitle(this.title, {super.key, this.action});
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(title.toUpperCase(), style: const TextStyle(color: AppColors.textMuted, letterSpacing: 1, fontSize: 12, fontWeight: FontWeight.w800))),
    ?action,
  ]);
}
