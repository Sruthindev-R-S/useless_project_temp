import 'package:cross_file/cross_file.dart';
import '../models/meme_response.dart';

/// Custom friendly domain exceptions
class ApiException implements Exception {
  final String message;
  final String? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class InvalidPhotoException extends ApiException {
  InvalidPhotoException([super.message = 'We need a photo with visible electrical switches.'])
      : super(code: 'INVALID_PHOTO');
}

class NetworkUnavailableException extends ApiException {
  NetworkUnavailableException([super.message = 'The switches refused to cooperate. Please check connection.'])
      : super(code: 'NETWORK_ERROR');
}

/// Abstract contract for switch analysis and meme generation.
///
/// The UI only ever talks to this [ApiService] abstraction.
/// When the real backend is ready, implement this interface in `real_api_service.dart`
/// without modifying any UI widgets.
abstract class ApiService {
  /// Analyzes an uploaded switchboard photo and returns switch counts with a meme.
  ///
  /// [imageFile] is an [XFile] from image_picker (compatible with mobile, desktop, & web).
  Future<MemeResponse> analyzeSwitches(XFile imageFile);
}
