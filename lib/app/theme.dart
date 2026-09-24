import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//  <--------- App Colors --------->
//* TO hold the white-and-blue colour tokens for one brightness, exposed through context.colors so light and dark stay in sync
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.ink,
    required this.inkSoft,
    required this.muted,
    required this.subtle,
    required this.brown,
    required this.brownMuted,
    required this.accent,
    required this.rose,
    required this.roseSoft,
    required this.rosePale,
    required this.tint,
    required this.tintStrong,
    required this.tintSoft,
    required this.field,
    required this.imageBg,
    required this.border,
    required this.divider,
    required this.chipRose,
    required this.onChipRose,
    required this.gold,
    required this.onGold,
    required this.goldDeep,
    required this.success,
    required this.navBar,
    required this.button,
    required this.onButton,
    required this.danger,
  });

  //  <--------- Canvas And Text Tokens --------->
  //* TO colour the page canvas, cards and the primary and secondary text levels
  final Color background;
  final Color surface;
  final Color ink;
  final Color inkSoft;
  final Color muted;
  final Color subtle;
  final Color brown;
  final Color brownMuted;

  //  <--------- Brand Tokens --------->
  //* TO colour links, highlights, discount badges, timers and primary actions in blue
  final Color accent;
  final Color rose;
  final Color roseSoft;
  final Color rosePale;

  //  <--------- Tint Tokens --------->
  //* TO fill icon circles, chips, the search field and product image frames
  final Color tint;
  final Color tintStrong;
  final Color tintSoft;
  final Color field;
  final Color imageBg;
  final Color border;
  final Color divider;

  //  <--------- Chip And Pill Tokens --------->
  //* TO colour the blue chips and the warm highlight pill
  final Color chipRose;
  final Color onChipRose;
  final Color gold;
  final Color onGold;
  final Color goldDeep;

  //  <--------- Status And Control Tokens --------->
  //* TO colour success states, the nav bar and solid blue buttons
  final Color success;
  final Color navBar;
  final Color button;
  final Color onButton;

  //!  <--------- Danger Token --------->
  //* TO show real errors in red so they never blend in with the blue highlight colour
  final Color danger;

  //  <--------- Light Palette --------->
  static const light = AppColors(
    background: Color(0xFFF5F8FF),
    surface: Colors.white,
    ink: Color(0xFF0F1B33),
    inkSoft: Color(0xFF1E2A44),
    muted: Color(0xFF94A3B8),
    subtle: Color(0xFF64748B),
    brown: Color(0xFF4B5B7A),
    brownMuted: Color(0xFF7C8BA8),
    accent: Color(0xFF1D4ED8),
    rose: Color(0xFF2563EB),
    roseSoft: Color(0xFF3B82F6),
    rosePale: Color(0xFF93C5FD),
    tint: Color(0xFFE6EFFF),
    tintStrong: Color(0xFFDBE7FF),
    tintSoft: Color(0xFFF0F5FF),
    field: Color(0xFFEDF2FA),
    imageBg: Color(0xFFF3F6FC),
    border: Color(0xFFE6ECF5),
    divider: Color(0xFFEEF3FB),
    chipRose: Color(0xFFDBEAFE),
    onChipRose: Color(0xFF1E3A8A),
    gold: Color(0xFFC7DBFF),
    onGold: Color(0xFF0B2A6B),
    goldDeep: Color(0xFF1E40AF),
    success: Color(0xFF10B981),
    navBar: Color(0xF2FFFFFF),
    button: Color(0xFF2563EB),
    onButton: Colors.white,
    danger: Color(0xFFDC2626),
  );

  //  <--------- Dark Palette --------->
  static const dark = AppColors(
    background: Color(0xFF0B1220),
    surface: Color(0xFF131C2E),
    ink: Color(0xFFEEF3FF),
    inkSoft: Color(0xFFDCE5F5),
    muted: Color(0xFF7F8FAD),
    subtle: Color(0xFF9AA8C4),
    brown: Color(0xFFB6C2DA),
    brownMuted: Color(0xFF8C9BB8),
    accent: Color(0xFF60A5FA),
    rose: Color(0xFF3B82F6),
    roseSoft: Color(0xFF60A5FA),
    rosePale: Color(0xFF93C5FD),
    tint: Color(0xFF1B2A47),
    tintStrong: Color(0xFF22355A),
    tintSoft: Color(0xFF16223A),
    field: Color(0xFF1A2439),
    imageBg: Color(0xFF182238),
    border: Color(0xFF223050),
    divider: Color(0xFF1D2A45),
    chipRose: Color(0xFF1E3A8A),
    onChipRose: Color(0xFFDBEAFE),
    gold: Color(0xFF1E3A8A),
    onGold: Color(0xFFDBEAFE),
    goldDeep: Color(0xFF1E40AF),
    success: Color(0xFF34D399),
    navBar: Color(0xF2131C2E),
    button: Color(0xFF3B82F6),
    onButton: Colors.white,
    danger: Color(0xFFF87171),
  );

  //  <--------- Theme Extension Overrides --------->
  //* TO blend every token when the theme animates between light and dark
  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      ink: l(ink, other.ink),
      inkSoft: l(inkSoft, other.inkSoft),
      muted: l(muted, other.muted),
      subtle: l(subtle, other.subtle),
      brown: l(brown, other.brown),
      brownMuted: l(brownMuted, other.brownMuted),
      accent: l(accent, other.accent),
      rose: l(rose, other.rose),
      roseSoft: l(roseSoft, other.roseSoft),
      rosePale: l(rosePale, other.rosePale),
      tint: l(tint, other.tint),
      tintStrong: l(tintStrong, other.tintStrong),
      tintSoft: l(tintSoft, other.tintSoft),
      field: l(field, other.field),
      imageBg: l(imageBg, other.imageBg),
      border: l(border, other.border),
      divider: l(divider, other.divider),
      chipRose: l(chipRose, other.chipRose),
      onChipRose: l(onChipRose, other.onChipRose),
      gold: l(gold, other.gold),
      onGold: l(onGold, other.onGold),
      goldDeep: l(goldDeep, other.goldDeep),
      success: l(success, other.success),
      navBar: l(navBar, other.navBar),
      button: l(button, other.button),
      onButton: l(onButton, other.onButton),
      danger: l(danger, other.danger),
    );
  }
}

//  <--------- App Theme Context Extension --------->
//* TO give widgets quick access to the colour tokens, text theme and brightness
extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

//  <--------- Soft Shadow --------->
//* TO share one subtle elevation shadow across cards and avatars
const softShadow = [
  BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
];

//  <--------- App Theme --------->
//* TO build the light and dark ThemeData from the AppColors tokens
class AppTheme {
  AppTheme._();

  //  <--------- Public Builders --------->
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  //  <--------- Theme Builder --------->
  //* TO map the tokens onto a Material colour scheme and component themes
  static ThemeData _build(AppColors c, Brightness brightness) {
    //  <--------- Colour Scheme --------->
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.button,
      onPrimary: c.onButton,
      primaryContainer: c.tint,
      onPrimaryContainer: c.ink,
      secondary: c.accent,
      onSecondary: Colors.white,
      secondaryContainer: c.chipRose,
      onSecondaryContainer: c.onChipRose,
      tertiary: c.rose,
      onTertiary: Colors.white,
      tertiaryContainer: c.tintSoft,
      onTertiaryContainer: c.rose,
      error: c.danger,
      onError: Colors.white,
      errorContainer: c.danger.withValues(alpha: 0.1),
      onErrorContainer: c.danger,
      surface: c.surface,
      onSurface: c.ink,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.background,
      surfaceContainerHigh: c.tintSoft,
      surfaceContainerHighest: c.imageBg,
      onSurfaceVariant: c.brown,
      outline: c.border,
      outlineVariant: c.divider,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: c.ink,
      onInverseSurface: c.surface,
      inversePrimary: c.surface,
    );

    //  <--------- Typography --------->
    //* TO apply the Plus Jakarta Sans font with ink coloured text
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      base.textTheme,
    ).apply(bodyColor: c.ink, displayColor: c.ink);

    //  <--------- Component Themes --------->
    //* TO style app bars, cards, chips, inputs, buttons, sheets and dialogs consistently
    return base.copyWith(
      extensions: [c],
      textTheme: textTheme,
      scaffoldBackgroundColor: c.background,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.18,
          color: c.ink,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: c.border),
        backgroundColor: c.surface,
        selectedColor: c.button,
        labelStyle: textTheme.labelLarge?.copyWith(color: c.ink),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: c.onButton),
        checkmarkColor: c.onButton,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.field,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: c.muted,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.ink.withValues(alpha: 0.4)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: BorderSide(color: c.border),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: c.accent),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: c.surface),
        actionTextColor: c.rosePale,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(color: c.divider, thickness: 1),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: c.button,
          selectedForegroundColor: c.onButton,
          foregroundColor: c.brown,
          side: BorderSide(color: c.border),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
