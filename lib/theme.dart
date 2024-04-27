import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4280575112),
      surfaceTint: Color(4280575112),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4291356415),
      onPrimaryContainer: Color(4278197806),
      secondary: Color(4280771465),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291487487),
      onSecondaryContainer: Color(4278197807),
      tertiary: Color(4284701052),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4293516799),
      onTertiaryContainer: Color(4280227381),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294376190),
      onBackground: Color(4279770144),
      surface: Color(4294376190),
      onSurface: Color(4279770144),
      surfaceVariant: Color(4292731882),
      onSurfaceVariant: Color(4282468429),
      outline: Color(4285626494),
      outlineVariant: Color(4290889678),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281151797),
      inverseOnSurface: Color(4293849590),
      inversePrimary: Color(4287942134),
      primaryFixed: Color(4291356415),
      onPrimaryFixed: Color(4278197806),
      primaryFixedDim: Color(4287942134),
      onPrimaryFixedVariant: Color(4278209645),
      secondaryFixed: Color(4291487487),
      onSecondaryFixed: Color(4278197807),
      secondaryFixedDim: Color(4288073208),
      onSecondaryFixedVariant: Color(4278209391),
      tertiaryFixed: Color(4293516799),
      onTertiaryFixed: Color(4280227381),
      tertiaryFixedDim: Color(4291674345),
      onTertiaryFixedVariant: Color(4283122019),
      surfaceDim: Color(4292336351),
      surfaceBright: Color(4294376190),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294046969),
      surfaceContainer: Color(4293652211),
      surfaceContainerHigh: Color(4293257453),
      surfaceContainerHighest: Color(4292862951),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278208615),
      surfaceTint: Color(4280575112),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282350240),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278208362),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282481313),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282859103),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286214035),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294376190),
      onBackground: Color(4279770144),
      surface: Color(4294376190),
      onSurface: Color(4279770144),
      surfaceVariant: Color(4292731882),
      onSurfaceVariant: Color(4282205257),
      outline: Color(4284047462),
      outlineVariant: Color(4285889410),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281151797),
      inverseOnSurface: Color(4293849590),
      inversePrimary: Color(4287942134),
      primaryFixed: Color(4282350240),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4280312198),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282481313),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280574343),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286214035),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284569465),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336351),
      surfaceBright: Color(4294376190),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294046969),
      surfaceContainer: Color(4293652211),
      surfaceContainerHigh: Color(4293257453),
      surfaceContainerHighest: Color(4292862951),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278199608),
      surfaceTint: Color(4280575112),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278208615),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278199609),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4278208362),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280687932),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282859103),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294376190),
      onBackground: Color(4279770144),
      surface: Color(4294376190),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292731882),
      onSurfaceVariant: Color(4280165674),
      outline: Color(4282205257),
      outlineVariant: Color(4282205257),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281151797),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4292669183),
      primaryFixed: Color(4278208615),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278202439),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4278208362),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278202441),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282859103),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281411655),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336351),
      surfaceBright: Color(4294376190),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294046969),
      surfaceContainer: Color(4293652211),
      surfaceContainerHigh: Color(4293257453),
      surfaceContainerHighest: Color(4292862951),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4287942134),
      surfaceTint: Color(4287942134),
      onPrimary: Color(4278203469),
      primaryContainer: Color(4278209645),
      onPrimaryContainer: Color(4291356415),
      secondary: Color(4288073208),
      onSecondary: Color(4278203470),
      secondaryContainer: Color(4278209391),
      onSecondaryContainer: Color(4291487487),
      tertiary: Color(4291674345),
      onTertiary: Color(4281609035),
      tertiaryContainer: Color(4283122019),
      onTertiaryContainer: Color(4293516799),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279243799),
      onBackground: Color(4292862951),
      surface: Color(4279243799),
      onSurface: Color(4292862951),
      surfaceVariant: Color(4282468429),
      onSurfaceVariant: Color(4290889678),
      outline: Color(4287336856),
      outlineVariant: Color(4282468429),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292862951),
      inverseOnSurface: Color(4281151797),
      inversePrimary: Color(4280575112),
      primaryFixed: Color(4291356415),
      onPrimaryFixed: Color(4278197806),
      primaryFixedDim: Color(4287942134),
      onPrimaryFixedVariant: Color(4278209645),
      secondaryFixed: Color(4291487487),
      onSecondaryFixed: Color(4278197807),
      secondaryFixedDim: Color(4288073208),
      onSecondaryFixedVariant: Color(4278209391),
      tertiaryFixed: Color(4293516799),
      onTertiaryFixed: Color(4280227381),
      tertiaryFixedDim: Color(4291674345),
      onTertiaryFixedVariant: Color(4283122019),
      surfaceDim: Color(4279243799),
      surfaceBright: Color(4281678398),
      surfaceContainerLowest: Color(4278849298),
      surfaceContainerLow: Color(4279770144),
      surfaceContainer: Color(4280033316),
      surfaceContainerHigh: Color(4280691246),
      surfaceContainerHighest: Color(4281414969),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4288205307),
      surfaceTint: Color(4287942134),
      onPrimary: Color(4278196263),
      primaryContainer: Color(4284323774),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4288336380),
      onSecondary: Color(4278196264),
      secondaryContainer: Color(4284454591),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4292003053),
      onTertiary: Color(4279898415),
      tertiaryContainer: Color(4288121777),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279243799),
      onBackground: Color(4292862951),
      surface: Color(4279243799),
      onSurface: Color(4294573055),
      surfaceVariant: Color(4282468429),
      onSurfaceVariant: Color(4291152850),
      outline: Color(4288521386),
      outlineVariant: Color(4286416010),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292862951),
      inverseOnSurface: Color(4280691246),
      inversePrimary: Color(4278209903),
      primaryFixed: Color(4291356415),
      onPrimaryFixed: Color(4278194975),
      primaryFixedDim: Color(4287942134),
      onPrimaryFixedVariant: Color(4278205013),
      secondaryFixed: Color(4291487487),
      onSecondaryFixed: Color(4278194976),
      secondaryFixedDim: Color(4288073208),
      onSecondaryFixedVariant: Color(4278205015),
      tertiaryFixed: Color(4293516799),
      onTertiaryFixed: Color(4279503658),
      tertiaryFixedDim: Color(4291674345),
      onTertiaryFixedVariant: Color(4282003793),
      surfaceDim: Color(4279243799),
      surfaceBright: Color(4281678398),
      surfaceContainerLowest: Color(4278849298),
      surfaceContainerLow: Color(4279770144),
      surfaceContainer: Color(4280033316),
      surfaceContainerHigh: Color(4280691246),
      surfaceContainerHighest: Color(4281414969),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294573055),
      surfaceTint: Color(4287942134),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4288205307),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294573055),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4288336380),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965759),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4292003053),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279243799),
      onBackground: Color(4292862951),
      surface: Color(4279243799),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282468429),
      onSurfaceVariant: Color(4294573055),
      outline: Color(4291152850),
      outlineVariant: Color(4291152850),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292862951),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4278201667),
      primaryFixed: Color(4291947263),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4288205307),
      onPrimaryFixedVariant: Color(4278196263),
      secondaryFixed: Color(4292012799),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4288336380),
      onSecondaryFixedVariant: Color(4278196264),
      tertiaryFixed: Color(4293780223),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4292003053),
      onTertiaryFixedVariant: Color(4279898415),
      surfaceDim: Color(4279243799),
      surfaceBright: Color(4281678398),
      surfaceContainerLowest: Color(4278849298),
      surfaceContainerLow: Color(4279770144),
      surfaceContainer: Color(4280033316),
      surfaceContainerHigh: Color(4280691246),
      surfaceContainerHighest: Color(4281414969),
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
