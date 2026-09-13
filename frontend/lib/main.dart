import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'services/http_api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations & system overlay styling
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF9F7F2),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize with live HttpApiService connected to https://useless-cf04.onrender.com/predict
  final apiService = HttpApiService();

  runApp(SwitchMemeApp(apiService: apiService));
}
