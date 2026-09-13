import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/routes.dart';
import '../../utils/constants.dart';
import '../../widgets/image_picker_area.dart';
import '../../widgets/primary_button.dart';

class UploadScreen extends StatefulWidget {
  final XFile? initialImage;

  const UploadScreen({
    super.key,
    this.initialImage,
  });

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isRePicking = false;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  Future<void> _showPickSourceSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select Switch Photo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Take New Photo',
                icon: Icons.camera_alt_rounded,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Choose from Gallery',
                icon: Icons.photo_library_outlined,
                variant: ButtonVariant.outline,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isRePicking = true);
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _selectedImage = pickedFile;
        });
      }
    } catch (e) {
      if (mounted) {
        _showFriendlyNotice(
          'Photo selection issue',
          'Could not load the selected photo. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRePicking = false);
      }
    }
  }

  void _showFriendlyNotice(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _analyzeSwitches() {
    if (_selectedImage == null) {
      _showFriendlyNotice(
        'No switch?',
        'That\'s okay. Pick a photo with switches to proceed.',
      );
      return;
    }

    Navigator.of(context).pushNamed(
      AppRoutes.processing,
      arguments: _selectedImage!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Switch Inspector'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ready for inspection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Make sure the switches are clearly visible so our meme algorithm can count them.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Image Preview Area
              ImagePickerArea(
                imageFile: _selectedImage,
                onPickNew: _showPickSourceSheet,
              ),

              const SizedBox(height: 28),

              // Analyze CTA
              PrimaryButton(
                label: 'Judge this switchboard',
                icon: Icons.bolt_rounded,
                variant: ButtonVariant.secondary,
                isLoading: _isRePicking,
                onPressed: _selectedImage != null ? _analyzeSwitches : null,
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: _showPickSourceSheet,
                  child: const Text(
                    'Pick a different photo',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
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
