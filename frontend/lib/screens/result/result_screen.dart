import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/routes.dart';
import '../../models/meme_response.dart';
import '../../utils/constants.dart';
import '../../widgets/meme_result.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/switch_count_display.dart';

class ResultScreen extends StatelessWidget {
  final MemeResponse response;

  const ResultScreen({
    super.key,
    required this.response,
  });

  void _shareResult(BuildContext context) {
    final text = '⚡ My switchboard results: ${response.onCount} ON, ${response.offCount} OFF!\n'
        'Verdict: ${response.effectiveVerdict}\n'
        'Judged by ${AppConstants.appName}!';

    try {
      SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: '${AppConstants.appName} Switch Analysis',
        ),
      );
    } catch (_) {
      // Fallback
    }
  }

  void _tryAnother(BuildContext context) {
    // Navigate cleanly back to Home, clearing previous route state
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('The Verdict'),
        actions: [
          IconButton(
            tooltip: 'Share result',
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () => _shareResult(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Switch count breakdown
              SwitchCountDisplay(
                onCount: response.onCount,
                offCount: response.offCount,
              ),

              const SizedBox(height: 24),

              // Meme reveal
              MemeResultWidget(
                response: response,
              ),

              const SizedBox(height: 32),

              // Action Buttons
              PrimaryButton(
                label: 'Try another switchboard',
                icon: Icons.refresh_rounded,
                onPressed: () => _tryAnother(context),
              ),

              const SizedBox(height: 12),

              PrimaryButton(
                label: 'Share with friends',
                icon: Icons.share_outlined,
                variant: ButtonVariant.outline,
                onPressed: () => _shareResult(context),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
