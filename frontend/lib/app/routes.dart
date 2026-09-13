import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../models/meme_response.dart';
import '../screens/home/home_screen.dart';
import '../screens/upload/upload_screen.dart';
import '../screens/processing/processing_screen.dart';
import '../screens/result/result_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String upload = '/upload';
  static const String processing = '/processing';
  static const String result = '/result';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const HomeScreen(), settings);

      case upload:
        final imageFile = settings.arguments as XFile?;
        return _buildRoute(UploadScreen(initialImage: imageFile), settings);

      case processing:
        final imageFile = settings.arguments as XFile;
        return _buildRoute(ProcessingScreen(imageFile: imageFile), settings);

      case result:
        final response = settings.arguments as MemeResponse;
        return _buildRoute(ResultScreen(response: response), settings);

      default:
        return _buildRoute(const HomeScreen(), settings);
    }
  }

  /// Clean, subtle fade-slide route transition matching the indie aesthetic
  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.04),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
