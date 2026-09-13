import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/http_api_service.dart';
import '../utils/constants.dart';
import 'routes.dart';
import 'theme.dart';

/// Provider widget to supply [ApiService] to the widget tree without third-party boilerplate.
class ApiServiceProvider extends InheritedWidget {
  final ApiService apiService;

  const ApiServiceProvider({
    super.key,
    required this.apiService,
    required super.child,
  });

  static ApiService of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ApiServiceProvider>();
    if (provider == null) {
      // Fallback default
      return HttpApiService();
    }
    return provider.apiService;
  }

  @override
  bool updateShouldNotify(ApiServiceProvider oldWidget) => apiService != oldWidget.apiService;
}

class SwitchMemeApp extends StatelessWidget {
  final ApiService? apiService;

  const SwitchMemeApp({super.key, this.apiService});

  @override
  Widget build(BuildContext context) {
    final service = apiService ?? HttpApiService();

    return ApiServiceProvider(
      apiService: service,
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
