import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../../app/app.dart';
import '../../app/routes.dart';
import '../../models/meme_response.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/primary_button.dart';

class ProcessingScreen extends StatefulWidget {
  final XFile imageFile;

  const ProcessingScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Start backend switch analysis on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnalysis();
    });
  }

  Future<void> _startAnalysis() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final apiService = ApiServiceProvider.of(context);
      final MemeResponse response = await apiService.analyzeSwitches(widget.imageFile);

      if (!mounted) return;

      // Navigate to Result Screen and replace processing screen from stack
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.result,
        arguments: response,
      );
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'The switches refused to cooperate. Please try again with another photo.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: _errorMessage != null
                ? _buildErrorView()
                : const PlayfulSwitchLoader(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.errorBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sentiment_dissatisfied_rounded,
            color: AppColors.error,
            size: 36,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Switch Disconnect',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _errorMessage!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        PrimaryButton(
          label: 'Try again',
          icon: Icons.refresh_rounded,
          onPressed: _startAnalysis,
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Choose another photo',
          variant: ButtonVariant.outline,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
