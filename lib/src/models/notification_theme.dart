// list_tile_theme.dart

import 'package:flutter/material.dart';

// Define a theme class for customizing ListTile appearance
class NotificationStyle {
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final Color? backgroundColor;
  final Color? leadingIconColor;
  final Color? trailingIconColor;
  final EdgeInsets? contentPadding;
  final double? titleFontSize;
  final double? subtitleFontSize;
  final FontWeight? titleFontWeight;
  final FontWeight? subtitleFontWeight;
  final TextAlign? titleTextAlign;
  final TextAlign? subtitleTextAlign;
  final bool? dense;

  const NotificationStyle({
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.backgroundColor,
    this.leadingIconColor,
    this.trailingIconColor,
    this.contentPadding,
    this.titleFontSize,
    this.subtitleFontSize,
    this.titleFontWeight,
    this.subtitleFontWeight,
    this.titleTextAlign,
    this.subtitleTextAlign,
    this.dense,
  });
}
