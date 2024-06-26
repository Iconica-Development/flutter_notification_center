import "package:flutter/material.dart";

/// Defines the appearance customization for notifications.
class NotificationStyle {
  /// Creates a new [NotificationStyle] instance.
  ///
  /// Each parameter is optional and allows customizing various aspects
  /// of the notification appearance.
  const NotificationStyle({
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.backgroundColor,
    this.leadingIconColor,
    this.pinnedIconColor,
    this.contentPadding,
    this.titleTextAlign,
    this.subtitleTextAlign,
    this.dense,
    this.tileDecoration,
    this.emptyNotificationsBuilder,
    this.appTitleTextStyle,
    this.dividerColor,
    this.isReadDotColor,
    this.showNotificationIcon,
  });

  /// The text style for the title of the notification.
  final TextStyle? titleTextStyle;

  /// The text style for the subtitle of the notification.
  final TextStyle? subtitleTextStyle;

  /// The background color of the notification.
  final Color? backgroundColor;

  /// The color of the leading icon (if any) in the notification.
  final Color? leadingIconColor;

  /// The color of the trailing icon (if any) in the notification.
  final Color? pinnedIconColor;

  /// The padding around the content of the notification.
  final EdgeInsets? contentPadding;

  /// The alignment of the title text within the notification.
  final TextAlign? titleTextAlign;

  /// The alignment of the subtitle text within the notification.
  final TextAlign? subtitleTextAlign;

  /// Whether the notification should be dense or not.
  final bool? dense;

  /// The decoration to apply to the tile of the notification.
  final BoxDecoration? tileDecoration;

  /// A builder function to display when there are no notifications.
  final Widget Function()? emptyNotificationsBuilder;

  /// The text style for the application title.
  final TextStyle? appTitleTextStyle;

  /// The color of the divider.
  final Color? dividerColor;

  /// The color of the dot that shows that anotification has not been read.
  final Color? isReadDotColor;

  /// Whether to show the notification icon.
  final bool? showNotificationIcon;
}
