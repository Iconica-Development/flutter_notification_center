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
  final TextAlign? titleTextAlign;
  final TextAlign? subtitleTextAlign;
  final bool? dense;
  final BoxDecoration? tileDecoration;
  final Widget Function()? emptyNotificationsBuilder;
  final TextStyle? appTitleTextStyle;

  const NotificationStyle({
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.backgroundColor,
    this.leadingIconColor,
    this.trailingIconColor,
    this.contentPadding,
    this.titleTextAlign,
    this.subtitleTextAlign,
    this.dense,
    this.tileDecoration,
    this.emptyNotificationsBuilder,
    this.appTitleTextStyle,
  });
}
