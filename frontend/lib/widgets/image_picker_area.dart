import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../utils/constants.dart';

/// Clean image preview area with simple border and moderate corner radius.
/// Avoids glassmorphism and heavy neon containers.
class ImagePickerArea extends StatelessWidget {
  final XFile? imageFile;
  final VoidCallback onPickNew;
  final double? height;

  const ImagePickerArea({
    super.key,
    required this.imageFile,
    required this.onPickNew,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final areaHeight = height ?? MediaQuery.of(context).size.height * 0.42;

    return Container(
      width: double.infinity,
      height: areaHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderFocus,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderFocus.withValues(alpha: 0.08),
            offset: const Offset(4, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageFile != null)
              FutureBuilder<Uint8List>(
                future: imageFile!.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textPrimary,
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    return Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                    );
                  }
                  return _buildPlaceholder();
                },
              )
            else
              _buildPlaceholder(),

            // Top tag badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.white, size: 14),
                    SizedBox(width: 5),
                    Text(
                      'YOUR SWITCHES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom change photo button
            Positioned(
              bottom: 12,
              right: 12,
              child: GestureDetector(
                onTap: onPickNew,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderFocus, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded, size: 16, color: AppColors.textPrimary),
                      SizedBox(width: 6),
                      Text(
                        'Change photo',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceMuted,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 8),
            Text(
              'No photo selected',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
