import 'package:flutter/material.dart';

/// App color constants tailored for an indie, tactile, quirky aesthetic.
/// Avoids heavy glassmorphism and neon AI gradients.
class AppColors {
  // Background & Surfaces
  static const Color background = Color(0xFFF9F7F2); // Warm off-white / cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0ECE1);
  static const Color border = Color(0xFFE2DDD5);
  static const Color borderFocus = Color(0xFF1E1E1E);

  // Text & Content
  static const Color textPrimary = Color(0xFF1E1E1E); // Deep Charcoal
  static const Color textSecondary = Color(0xFF6E6E68); // Muted gray
  static const Color textTertiary = Color(0xFF9E9E98);

  // Playful Single Accent (Energetic Switch Tangerine/Orange)
  static const Color accent = Color(0xFFFF5722);
  static const Color accentLight = Color(0xFFFFF0EB);
  static const Color accentDark = Color(0xFFD84315);

  // Switch States
  static const Color switchOn = Color(0xFF10B981); // Crisp Emerald
  static const Color switchOnBg = Color(0xFFE6F7F0);
  static const Color switchOff = Color(0xFF64748B); // Slate
  static const Color switchOffBg = Color(0xFFF1F5F9);

  // Functional
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEE2E2);
}

/// Humorous loading messages rotated during switch analysis.
class AppQuotes {
  static const List<String> processingQuotes = [
    'Counting the little guys...',
    'Checking who is ON...',
    'Checking who is OFF...',
    'Judging your electrical hygiene...',
    'Consulting the meme oracle...',
    'Analyzing the cosmic switch balance...',
    'Almost there...',
  ];

  static const List<String> homeSubtitles = [
    'Show us your switches. We\'ll judge them.',
    'How many switches are having a good day? Take a photo. We\'ll figure it out.',
    'Every switch tells a story. Most of them are weird.',
  ];
}

/// Fallback mock meme item with humorous copy
class MockMemeData {
  final String title;
  final String caption;
  final String personality;
  final String imageUrl;

  const MockMemeData({
    required this.title,
    required this.caption,
    required this.personality,
    required this.imageUrl,
  });
}

class AppConstants {
  static const String appName = 'SwitchMeme';
  static const String appTagline = 'Show us your switches. We\'ll judge them.';

  // Curated mock meme library for diverse switch ratios
  static const List<MockMemeData> mockMemes = [
    MockMemeData(
      title: 'Balanced As All Things Should Be',
      caption: '3 switches ON, 2 switches OFF. You have achieved total domestic harmony.',
      personality: '60% Chaotic Good • Electric Zen Master',
      imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800&auto=format&fit=crop&q=80',
    ),
    MockMemeData(
      title: 'Stadium Lights Mode',
      caption: 'Every switch is ON. The electricity meter is spinning faster than the Earth.',
      personality: '100% Chaotic Radiant • Moth Energy',
      imageUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=800&auto=format&fit=crop&q=80',
    ),
    MockMemeData(
      title: 'Creature of the Night',
      caption: 'Zero switches ON. You navigate the hallway purely through echolocation.',
      personality: '100% Ascetic Monk • Electric Bill Slayer',
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&auto=format&fit=crop&q=80',
    ),
    MockMemeData(
      title: 'The Mystery Switch',
      caption: 'One switch is flipped. Nobody knows what it does. Somewhere in Nebraska, a garage door opens.',
      personality: '50% Enigma • Secret Agent of Switches',
      imageUrl: 'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=800&auto=format&fit=crop&q=80',
    ),
  ];
}
