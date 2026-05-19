import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onRefresh;

  const CustomAppBar({super.key, required this.title, this.onRefresh});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      centerTitle: false,
      actions: [
        if (onRefresh != null)
          IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh)
      ],
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 1,
    );
  }
}
