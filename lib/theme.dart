import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4281159758),
      surfaceTint: Color(4282541411),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283528306),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4283654496),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4292405221),
      onSecondaryContainer: Color(4282272586),
      tertiary: Color(4283319648),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285753734),
      onTertiaryContainer: Color(4294967295),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294638072),
      onBackground: Color(4279901212),
      surface: Color(4294638072),
      onSurface: Color(4279901212),
      surfaceVariant: Color(4292732131),
      onSurfaceVariant: Color(4282468423),
      outline: Color(4285626744),
      outlineVariant: Color(4290889927),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282864),
      inverseOnSurface: Color(4294046192),
      inversePrimary: Color(4289253067),
      primaryFixed: Color(4291095271),
      onPrimaryFixed: Color(4278198303),
      primaryFixedDim: Color(4289253067),
      onPrimaryFixedVariant: Color(4280962379),
      secondaryFixed: Color(4292339172),
      onSecondaryFixed: Color(4279311901),
      secondaryFixedDim: Color(4290496968),
      onSecondaryFixedVariant: Color(4282141000),
      tertiaryFixed: Color(4293516799),
      onTertiaryFixed: Color(4280227632),
      tertiaryFixedDim: Color(4291674594),
      onTertiaryFixedVariant: Color(4283122269),
      surfaceDim: Color(4292532953),
      surfaceBright: Color(4294638072),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243314),
      surfaceContainer: Color(4293848813),
      surfaceContainerHigh: Color(4293454055),
      surfaceContainerHighest: Color(4293059297),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4280633671),
      surfaceTint: Color(4282541411),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283528306),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281877828),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285101942),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282859353),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285753734),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294638072),
      onBackground: Color(4279901212),
      surface: Color(4294638072),
      onSurface: Color(4279901212),
      surfaceVariant: Color(4292732131),
      onSurfaceVariant: Color(4282205252),
      outline: Color(4284047712),
      outlineVariant: Color(4285889659),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282864),
      inverseOnSurface: Color(4294046192),
      inversePrimary: Color(4289253067),
      primaryFixed: Color(4283988857),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4282344032),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285101942),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283522909),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286214285),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284504179),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292532953),
      surfaceBright: Color(4294638072),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243314),
      surfaceContainer: Color(4293848813),
      surfaceContainerHigh: Color(4293454055),
      surfaceContainerHighest: Color(4293059297),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278200102),
      surfaceTint: Color(4282541411),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280633671),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279772452),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281877828),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280688183),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282859353),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294638072),
      onBackground: Color(4279901212),
      surface: Color(4294638072),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292732131),
      onSurfaceVariant: Color(4280165669),
      outline: Color(4282205252),
      outlineVariant: Color(4282205252),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282864),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4291687665),
      primaryFixed: Color(4280633671),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278989361),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281877828),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280430382),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282859353),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281346370),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292532953),
      surfaceBright: Color(4294638072),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243314),
      surfaceContainer: Color(4293848813),
      surfaceContainerHigh: Color(4293454055),
      surfaceContainerHighest: Color(4293059297),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4289253067),
      surfaceTint: Color(4289253067),
      onPrimary: Color(4279318068),
      primaryContainer: Color(4281883481),
      onPrimaryContainer: Color(4292804604),
      secondary: Color(4290496968),
      onSecondary: Color(4280693554),
      secondaryContainer: Color(4281680449),
      onSecondaryContainer: Color(4291418326),
      tertiary: Color(4291674594),
      onTertiary: Color(4281609286),
      tertiaryContainer: Color(4284109164),
      onTertiaryContainer: Color(4294834175),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279374867),
      onBackground: Color(4293059297),
      surface: Color(4279374867),
      onSurface: Color(4293059297),
      surfaceVariant: Color(4282468423),
      onSurfaceVariant: Color(4290889927),
      outline: Color(4287337105),
      outlineVariant: Color(4282468423),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059297),
      inverseOnSurface: Color(4281282864),
      inversePrimary: Color(4282541411),
      primaryFixed: Color(4291095271),
      onPrimaryFixed: Color(4278198303),
      primaryFixedDim: Color(4289253067),
      onPrimaryFixedVariant: Color(4280962379),
      secondaryFixed: Color(4292339172),
      onSecondaryFixed: Color(4279311901),
      secondaryFixedDim: Color(4290496968),
      onSecondaryFixedVariant: Color(4282141000),
      tertiaryFixed: Color(4293516799),
      onTertiaryFixed: Color(4280227632),
      tertiaryFixedDim: Color(4291674594),
      onTertiaryFixedVariant: Color(4283122269),
      surfaceDim: Color(4279374867),
      surfaceBright: Color(4281874745),
      surfaceContainerLowest: Color(4279045902),
      surfaceContainerLow: Color(4279901212),
      surfaceContainer: Color(4280164384),
      surfaceContainerHigh: Color(4280822314),
      surfaceContainerHighest: Color(4281546037),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4289581775),
      surfaceTint: Color(4289253067),
      onPrimary: Color(4278196761),
      primaryContainer: Color(4285765525),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290760396),
      onSecondary: Color(4278982936),
      secondaryContainer: Color(4286944402),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4291937766),
      onTertiary: Color(4279833130),
      tertiaryContainer: Color(4288056490),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279374867),
      onBackground: Color(4293059297),
      surface: Color(4279374867),
      onSurface: Color(4294704122),
      surfaceVariant: Color(4282468423),
      onSurfaceVariant: Color(4291153099),
      outline: Color(4288521379),
      outlineVariant: Color(4286416260),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059297),
      inverseOnSurface: Color(4280887850),
      inversePrimary: Color(4281028172),
      primaryFixed: Color(4291095271),
      onPrimaryFixed: Color(4278195220),
      primaryFixedDim: Color(4289253067),
      onPrimaryFixedVariant: Color(4279778362),
      secondaryFixed: Color(4292339172),
      onSecondaryFixed: Color(4278653715),
      secondaryFixedDim: Color(4290496968),
      onSecondaryFixedVariant: Color(4281088312),
      tertiaryFixed: Color(4293516799),
      onTertiaryFixed: Color(4279504165),
      tertiaryFixedDim: Color(4291674594),
      onTertiaryFixedVariant: Color(4282004044),
      surfaceDim: Color(4279374867),
      surfaceBright: Color(4281874745),
      surfaceContainerLowest: Color(4279045902),
      surfaceContainerLow: Color(4279901212),
      surfaceContainer: Color(4280164384),
      surfaceContainerHigh: Color(4280822314),
      surfaceContainerHighest: Color(4281546037),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4293591037),
      surfaceTint: Color(4289253067),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4289581775),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293918460),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290760396),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965759),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291937766),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279374867),
      onBackground: Color(4293059297),
      surface: Color(4279374867),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282468423),
      onSurfaceVariant: Color(4294311163),
      outline: Color(4291153099),
      outlineVariant: Color(4291153099),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059297),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4278726446),
      primaryFixed: Color(4291358443),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4289581775),
      onPrimaryFixedVariant: Color(4278196761),
      secondaryFixed: Color(4292602600),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290760396),
      onSecondaryFixedVariant: Color(4278982936),
      tertiaryFixed: Color(4293780223),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291937766),
      onTertiaryFixedVariant: Color(4279833130),
      surfaceDim: Color(4279374867),
      surfaceBright: Color(4281874745),
      surfaceContainerLowest: Color(4279045902),
      surfaceContainerLow: Color(4279901212),
      surfaceContainer: Color(4280164384),
      surfaceContainerHigh: Color(4280822314),
      surfaceContainerHighest: Color(4281546037),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
