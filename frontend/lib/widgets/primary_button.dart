import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum ButtonVariant { primary, secondary, outline }

/// Tactile, responsive button adhering to the indie-hackathon design principle.
class PrimaryButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = 54,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Border? border;

    switch (widget.variant) {
      case ButtonVariant.primary:
        bgColor = AppColors.textPrimary;
        textColor = Colors.white;
        border = Border.all(color: AppColors.textPrimary, width: 1.5);
        break;
      case ButtonVariant.secondary:
        bgColor = AppColors.accent;
        textColor = Colors.white;
        border = Border.all(color: AppColors.accentDark, width: 1.5);
        break;
      case ButtonVariant.outline:
        bgColor = Colors.transparent;
        textColor = AppColors.textPrimary;
        border = Border.all(color: AppColors.borderFocus, width: 1.5);
        break;
    }

    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedScale(
      scale: _isPressed && isEnabled ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: isEnabled ? bgColor : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: border,
          boxShadow: isEnabled && widget.variant != ButtonVariant.outline
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onHighlightChanged: (pressed) {
              setState(() {
                _isPressed = pressed;
              });
            },
            onTap: isEnabled ? widget.onPressed : null,
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20, color: textColor),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: isEnabled ? textColor : AppColors.textTertiary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
