import 'package:flutter/material.dart';

class EbookSearchBar extends StatelessWidget {
  const EbookSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return TextField(
          key: const ValueKey('ebook_search_bar'),
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search title, author, or filename',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary.withOpacity(0.8),
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: onClear,
                  ),
            filled: true,
            fillColor: theme.brightness == Brightness.light
                ? Colors.white.withOpacity(0.9)
                : theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
