import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Playful minimalist switch toggle loading animation with cycling quotes.
class PlayfulSwitchLoader extends StatefulWidget {
  final List<String> quotes;
  final Duration quoteInterval;

  const PlayfulSwitchLoader({
    super.key,
    this.quotes = AppQuotes.processingQuotes,
    this.quoteInterval = const Duration(milliseconds: 900),
  });

  @override
  State<PlayfulSwitchLoader> createState() => _PlayfulSwitchLoaderState();
}

class _PlayfulSwitchLoaderState extends State<PlayfulSwitchLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _switchController;
  late Timer _quoteTimer;
  int _quoteIndex = 0;
  bool _switchState = false;

  @override
  void initState() {
    super.initState();
    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Cycle switch toggle back and forth smoothly
    _quoteTimer = Timer.periodic(widget.quoteInterval, (timer) {
      if (mounted) {
        setState(() {
          _quoteIndex = (_quoteIndex + 1) % widget.quotes.length;
          _switchState = !_switchState;
        });
      }
    });
  }

  @override
  void dispose() {
    _quoteTimer.cancel();
    _switchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tactile animated switch toggle
        Container(
          width: 80,
          height: 110,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderFocus, width: 2.5),
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
              // Toggle Slot
              Container(
                width: 34,
                height: 64,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  alignment: _switchState ? Alignment.topCenter : Alignment.bottomCenter,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: _switchState ? AppColors.accent : AppColors.switchOff,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Rotating funny message with animated switcher
        SizedBox(
          height: 54,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              widget.quotes[_quoteIndex],
              key: ValueKey<int>(_quoteIndex),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),
        const Text(
          'Counting the little guys...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
