import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Minimalist, quirky switchboard logo icon with a tactile toggle design.
class AppLogo extends StatefulWidget {
  final double size;
  final bool isInteractive;

  const AppLogo({
    super.key,
    this.size = 64,
    this.isInteractive = true,
  });

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> with SingleTickerProviderStateMixin {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final plateWidth = size;
    final plateHeight = size * 1.35;

    return GestureDetector(
      onTap: widget.isInteractive
          ? () {
              setState(() {
                _isOn = !_isOn;
              });
            }
          : null,
      child: Container(
        width: plateWidth,
        height: plateHeight,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(size * 0.22),
          border: Border.all(
            color: AppColors.borderFocus,
            width: size * 0.04,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.borderFocus.withValues(alpha: 0.12),
              offset: const Offset(3, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Top screw dot
            Positioned(
              top: size * 0.1,
              child: Container(
                width: size * 0.08,
                height: size * 0.08,
                decoration: const BoxDecoration(
                  color: AppColors.border,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Bottom screw dot
            Positioned(
              bottom: size * 0.1,
              child: Container(
                width: size * 0.08,
                height: size * 0.08,
                decoration: const BoxDecoration(
                  color: AppColors.border,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Switch toggle slot & button
            Container(
              width: size * 0.38,
              height: size * 0.65,
              padding: EdgeInsets.all(size * 0.04),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(size * 0.1),
                border: Border.all(
                  color: AppColors.border,
                  width: 1.5,
                ),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                alignment: _isOn ? Alignment.topCenter : Alignment.bottomCenter,
                child: Container(
                  width: size * 0.30,
                  height: size * 0.26,
                  decoration: BoxDecoration(
                    color: _isOn ? AppColors.accent : AppColors.switchOff,
                    borderRadius: BorderRadius.circular(size * 0.06),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: size * 0.1,
                      height: size * 0.03,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
