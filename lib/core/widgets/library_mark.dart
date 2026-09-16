import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LibraryMark extends StatelessWidget {
  final double size;
  final bool inverted;

  const LibraryMark({super.key, this.size = 72, this.inverted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: inverted ? Colors.white : AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: inverted
            ? null
            : const [
                BoxShadow(
                  color: Color(0x291769E0),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
      ),
      child: Icon(
        Icons.local_library_rounded,
        size: size * 0.52,
        color: inverted ? AppColors.primary : Colors.white,
      ),
    );
  }
}
