import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/ebook.dart';

class BookCover extends StatelessWidget {
  const BookCover({required this.ebook, super.key, this.large = false});

  final Ebook ebook;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = _CoverPalette.from(ebook.id);
    final content = _GeneratedCover(ebook: ebook, colors: colors, large: large);

    if (ebook.coverImageUrl case final url?) {
      return AspectRatio(
        aspectRatio: 0.68,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: large ? 16 : 8,
                offset: Offset(0, large ? 4 : 2),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.24),
                blurRadius: large ? 24 : 12,
                offset: Offset(0, large ? 16 : 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => content,
            ),
          ),
        ),
      );
    }
    return content;
  }
}

class _GeneratedCover extends StatelessWidget {
  const _GeneratedCover({required this.ebook, required this.colors, required this.large});

  final Ebook ebook;
  final _CoverPalette colors;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.68,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: large ? 16 : 8,
              offset: Offset(0, large ? 4 : 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.24),
              blurRadius: large ? 24 : 12,
              offset: Offset(0, large ? 16 : 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [colors.start, colors.end]),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: large ? 24 : 14,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.24), Colors.black.withOpacity(0.12)]),
                    border: Border(right: BorderSide(color: Colors.white.withOpacity(0.14), width: 1.2)),
                  ),
                ),
              ),
              Positioned(
                right: large ? 18 : 12,
                top: large ? 16 : 12,
                child: Container(
                  width: large ? 52 : 34,
                  height: large ? 52 : 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.accent,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Text(
                    ebook.fileType,
                    style: TextStyle(color: Colors.black.withOpacity(0.82), fontSize: large ? 12 : 8, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Positioned(
                left: large ? 34 : 18,
                right: large ? 18 : 12,
                top: large ? 82 : 50,
                child: Text(
                  ebook.title,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: large ? 26 : 15, fontWeight: FontWeight.w900, height: 1.06),
                ),
              ),
              Positioned(
                left: large ? 34 : 18,
                right: large ? 18 : 12,
                bottom: large ? 26 : 18,
                child: Text(
                  _getInitials(ebook.author),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.78), fontSize: large ? 13 : 10, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.18)], stops: const [0.54, 1]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverPalette {
  const _CoverPalette(this.start, this.end, this.accent);

  final Color start;
  final Color end;
  final Color accent;

  static _CoverPalette from(String seed) {
    const palettes = [
      _CoverPalette(Color(0xFF18324D), Color(0xFF2F5F8F), Color(0xFFD8A748)),
      _CoverPalette(Color(0xFF9F2D35), Color(0xFFD7524A), Color(0xFFFFC857)),
      _CoverPalette(Color(0xFF0F766E), Color(0xFF45A29E), Color(0xFFFFE6A7)),
      _CoverPalette(Color(0xFF55346B), Color(0xFF8863A8), Color(0xFFF5B7C7)),
      _CoverPalette(Color(0xFF51633F), Color(0xFF7E8F55), Color(0xFFF1D36F)),
      _CoverPalette(Color(0xFFB15A2B), Color(0xFFE08E45), Color(0xFF2F4858)),
    ];
    final hash = seed.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return palettes[hash % palettes.length];
  }
}

String _getInitials(String name) {
  if (name.isEmpty) return '';
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts[0].substring(0, parts[0].length.clamp(0, 3)).toUpperCase();
  }
  return (parts.first[0] + parts.last[0]).toUpperCase();
}
