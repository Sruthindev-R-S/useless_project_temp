import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/routes.dart';
import '../../utils/constants.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/primary_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return;
    setState(() => _isPicking = true);

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (!mounted) return;

      if (pickedFile != null) {
        Navigator.of(context).pushNamed(
          AppRoutes.upload,
          arguments: pickedFile,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        title: 'Camera unavailable',
        message: 'Could not access the camera or gallery. Please check permissions.',
      );
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  void _showErrorDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.borderFocus, width: 2),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Got it',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Interactive Quirky Logo
              const AppLogo(size: 76, isInteractive: true),
              const SizedBox(height: 8),
              const Text(
                'Tap switch to flip',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 32),

              // Headline
              const Text(
                'Show us your switches.\nWe\'ll judge them.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle / Description
              const Text(
                'Take a photo of any switchboard.\nWe\'ll count what is ON, what is OFF, and reveal your electrical personality.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),

              const Spacer(flex: 2),

              // Action Buttons
              PrimaryButton(
                label: 'Take a photo',
                icon: Icons.camera_alt_rounded,
                isLoading: _isPicking,
                onPressed: () => _pickImage(ImageSource.camera),
              ),

              const SizedBox(height: 12),

              PrimaryButton(
                label: 'Choose from gallery',
                icon: Icons.photo_library_outlined,
                variant: ButtonVariant.outline,
                isLoading: _isPicking,
                onPressed: () => _pickImage(ImageSource.gallery),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
