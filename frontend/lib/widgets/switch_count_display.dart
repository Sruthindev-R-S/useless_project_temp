import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Clean, high-contrast switch count visualizer.
/// Displays large ON and OFF numbers with tactile toggle dots.
class SwitchCountDisplay extends StatelessWidget {
  final int onCount;
  final int offCount;

  const SwitchCountDisplay({
    super.key,
    required this.onCount,
    required this.offCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
            offset: const Offset(3, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SWITCH REPORT',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Text(
                  '${onCount + offCount} TOTAL',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Numbers row
          Row(
            children: [
              // ON Section
              Expanded(
                child: _buildCountTile(
                  count: onCount,
                  label: 'ON',
                  color: AppColors.switchOn,
                  bgColor: AppColors.switchOnBg,
                  isActive: true,
                ),
              ),
              const SizedBox(width: 16),
              // OFF Section
              Expanded(
                child: _buildCountTile(
                  count: offCount,
                  label: 'OFF',
                  color: AppColors.switchOff,
                  bgColor: AppColors.switchOffBg,
                  isActive: false,
                ),
              ),
            ],
          ),

          // Switch dot visualization row if counts > 0
          if (onCount + offCount > 0 && onCount + offCount <= 16) ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < onCount; i++) _buildDot(isOn: true),
                for (int i = 0; i < offCount; i++) _buildDot(isOn: false),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountTile({
    required int count,
    required String label,
    required Color color,
    required Color bgColor,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isOn}) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: isOn ? AppColors.switchOn : AppColors.surfaceMuted,
        shape: BoxShape.circle,
        border: Border.all(
          color: isOn ? AppColors.switchOn : AppColors.switchOff,
          width: 2,
        ),
      ),
    );
  }
}
