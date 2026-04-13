import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get light {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.light,
    );

    // Override surface colors to remove green tint
    final colorScheme = baseScheme.copyWith(
      surface: Colors.white,
      surfaceContainerLowest: const Color(0xFFF8FAFB),
      surfaceContainerLow: const Color(0xFFF3F5F7),
      surfaceContainer: const Color(0xFFEEF0F2),
      surfaceContainerHigh: const Color(0xFFE8EAED),
      surfaceContainerHighest: const Color(0xFFE1E4E7),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFB),
      textTheme: GoogleFonts.notoSansTcTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        surfaceTintColor: Colors.transparent,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.3),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F5F7)),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFFF8FAFB);
          }
          return Colors.white;
        }),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.notoSansTcTextTheme(
        ThemeData.dark().textTheme,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
