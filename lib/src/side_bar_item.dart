import 'package:flutter/material.dart';

import 'menu_item.dart';

class SideBarItem extends StatelessWidget {
  const SideBarItem({
    @required this.items,
    @required this.index,
    this.onSelected,
    this.selectedRoute,
    this.depth = 0,
    this.iconColor,
    this.activeIconColor,
    @required this.textStyle,
    this.activeTextStyle,
    @required this.backgroundColor,
    @required this.activeBackgroundColor,
    @required this.borderColor,
  });

  final List<MenuItem> items;
  final int index;
  final void Function(MenuItem item) onSelected;
  final String selectedRoute;
  final int depth;
  final Color iconColor;
  final Color activeIconColor;
  final TextStyle textStyle;
  final TextStyle activeTextStyle;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color borderColor;
  bool get isLast => index == items.length - 1;

  @override
  Widget build(BuildContext context) {
    if (depth > 0 && isLast) {
      return _buildTiles(context, items[index]);
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      child: _buildTiles(context, items[index]),
    );
  }

  Widget _buildTiles(BuildContext context, MenuItem item) {
    bool selected = _isSelected(selectedRoute, [item]);

    if (item.children.isEmpty) {
      return ListTile(
        contentPadding: _getTilePadding(depth),
        leading: _buildIcon(item, selected),
        title: _buildTitle(item.title, item.textStyle != null ? item.textStyle : textStyle, selected),
        selected: selected,
        tileColor: backgroundColor,
        selectedTileColor: activeBackgroundColor,
        onTap: () {
          if (onSelected != null) {
            onSelected(item);
          }
        },
        dense: item is HeaderMenuItem ? true : false,
      );
    }

    int index = 0;
    final childrenTiles = item.children.map((child) {
      return SideBarItem(
        items: item.children,
        index: index++,
        onSelected: onSelected,
        selectedRoute: selectedRoute,
        depth: depth + 1,
        iconColor: iconColor,
        activeIconColor: activeIconColor,
        textStyle: textStyle,
        activeTextStyle: activeTextStyle,
        backgroundColor: backgroundColor,
        activeBackgroundColor: activeBackgroundColor,
        borderColor: borderColor,
      );
    }).toList();

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: _getTilePadding(depth),
        leading: _buildIcon(item),
        title: _buildTitle(item.title, textStyle),
        initiallyExpanded: selected,
        children: childrenTiles,
      ),
    );
  }

  bool _isSelected(String route, List<MenuItem> items) {
    for (final item in items) {
      if (item.route == route) {
        return true;
      }
      if (item.children.isNotEmpty) {
        return _isSelected(route, item.children);
      }
    }
    return false;
  }

  Widget _buildIcon(MenuItem item, [bool selected = false]) {
    return item.icon != null
        ? Icon(
            item.icon,
            size: 22,
            color: selected
                ? activeIconColor != null
                    ? activeIconColor
                    : activeTextStyle.color
                : iconColor != null
                    ? iconColor
                    : textStyle.color,
          )
        : (item is HeaderMenuItem)
            ? null
            : SizedBox();
  }

  Widget _buildTitle(String title, TextStyle _textStyle, [bool selected = false]) {
    return Text(
      title,
      style: selected ? activeTextStyle : _textStyle,
    );
  }

  EdgeInsets _getTilePadding(int depth) {
    return EdgeInsets.only(
      left: 10.0 + 10.0 * depth,
      right: 10.0,
    );
  }
}
