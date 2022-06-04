/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsBallGen {
  const $AssetsBallGen();

  /// File path: assets/ball/ball1.png
  AssetGenImage get ball1 => const AssetGenImage('assets/ball/ball1.png');

  /// File path: assets/ball/ball10.png
  AssetGenImage get ball10 => const AssetGenImage('assets/ball/ball10.png');

  /// File path: assets/ball/ball11.png
  AssetGenImage get ball11 => const AssetGenImage('assets/ball/ball11.png');

  /// File path: assets/ball/ball12.png
  AssetGenImage get ball12 => const AssetGenImage('assets/ball/ball12.png');

  /// File path: assets/ball/ball13.png
  AssetGenImage get ball13 => const AssetGenImage('assets/ball/ball13.png');

  /// File path: assets/ball/ball14.png
  AssetGenImage get ball14 => const AssetGenImage('assets/ball/ball14.png');

  /// File path: assets/ball/ball15.png
  AssetGenImage get ball15 => const AssetGenImage('assets/ball/ball15.png');

  /// File path: assets/ball/ball16.png
  AssetGenImage get ball16 => const AssetGenImage('assets/ball/ball16.png');

  /// File path: assets/ball/ball2.png
  AssetGenImage get ball2 => const AssetGenImage('assets/ball/ball2.png');

  /// File path: assets/ball/ball3.png
  AssetGenImage get ball3 => const AssetGenImage('assets/ball/ball3.png');

  /// File path: assets/ball/ball4.png
  AssetGenImage get ball4 => const AssetGenImage('assets/ball/ball4.png');

  /// File path: assets/ball/ball5.png
  AssetGenImage get ball5 => const AssetGenImage('assets/ball/ball5.png');

  /// File path: assets/ball/ball6.png
  AssetGenImage get ball6 => const AssetGenImage('assets/ball/ball6.png');

  /// File path: assets/ball/ball7.png
  AssetGenImage get ball7 => const AssetGenImage('assets/ball/ball7.png');

  /// File path: assets/ball/ball8.png
  AssetGenImage get ball8 => const AssetGenImage('assets/ball/ball8.png');

  /// File path: assets/ball/ball9.png
  AssetGenImage get ball9 => const AssetGenImage('assets/ball/ball9.png');
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_icon.png
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app_icon.png');
}

class Assets {
  Assets._();

  static const $AssetsBallGen ball = $AssetsBallGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
