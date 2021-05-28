import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem({
    required this.title,
    this.route,
    this.icon,
    this.children = const [],
    this.textStyle,
  });

  final String title;
  final String? route;
  final IconData? icon;
  final List<MenuItem> children;
  final TextStyle? textStyle;
}

class HeaderMenuItem extends MenuItem {
  const HeaderMenuItem({required title, textStyle}) : super(title: title, textStyle: textStyle);
}
