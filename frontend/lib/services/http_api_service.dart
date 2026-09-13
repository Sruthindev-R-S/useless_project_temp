import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import '../models/meme_response.dart';
import 'api_service.dart';

/// Real HTTP implementation of [ApiService] connecting to the backend prediction server.
class HttpApiService implements ApiService {
  final String baseUrl;
  final http.Client? _client;
  final Duration timeout;

  static const String defaultBaseUrl = 'https://useless-cf04.onrender.com';

  static const List<String> _highMemes = [
    'assets/memes/high/dileep.gif',
    'assets/memes/high/mammoty.gif',
    'assets/memes/high/bubsy-death.gif',
    'assets/memes/high/shocked.gif',
  ];

  static const List<String> _medMemes = [
    'assets/memes/med/lalettan.gif',
    'assets/memes/med/mamukoya.gif',
    'assets/memes/med/gopi.gif',
  ];

  static const List<String> _lowMemes = [
    'assets/memes/low/prithvi.gif',
    'assets/memes/low/saleem.gif',
  ];

  final Random _random = Random();

  HttpApiService({
    this.baseUrl = defaultBaseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 60),
  }) : _client = client;

  @override
  Future<MemeResponse> analyzeSwitches(XFile imageFile) async {
    // 1. Read and validate image bytes
    final bytes = await imageFile.readAsBytes();
    if (bytes.isEmpty) {
      throw InvalidPhotoException('The selected photo is empty. Please choose a valid image.');
    }

    // 2. Build multipart request to /predict endpoint
    final uri = Uri.parse('$baseUrl/predict');
    final request = http.MultipartRequest('POST', uri);

    final filename = imageFile.name.isNotEmpty ? imageFile.name : 'switchboard.jpg';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
      ),
    );

    http.Response response;
    try {
      final client = _client;
      final streamedResponse = client != null
          ? await client.send(request).timeout(timeout)
          : await request.send().timeout(timeout);

      response = await http.Response.fromStream(streamedResponse).timeout(timeout);
    } on SocketException {
      throw NetworkUnavailableException(
        'Cannot connect to the switchboard server. Please check your internet connection.',
      );
    } on TimeoutException {
      throw NetworkUnavailableException(
        'The switch analysis timed out. The server might be waking up, please try again!',
      );
    } on http.ClientException {
      throw NetworkUnavailableException(
        'Network communication error. Please check connection and try again.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('An unexpected network error occurred: $e');
    }

    // 3. Handle response status codes
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

        final int onCount = (data['on'] ?? data['on switch'] ?? data['on_switches'] ?? data['onCount'] ?? 0) as int;
        final int offCount = (data['off'] ?? data['off switch'] ?? data['off_switches'] ?? data['offCount'] ?? 0) as int;

        // If backend provided meme or metadata directly, prefer it; otherwise resolve witty meme package
        final String? serverMeme = data['meme'] ?? data['memeUrl'] ?? data['meme_url'] as String?;
        final String? serverTitle = data['title'] as String?;
        final String? serverCaption = data['caption'] as String?;
        final String? serverVerdict = (data['verdict'] ?? data['personality']) as String?;

        final resolvedMeme = (serverMeme != null && serverMeme.isNotEmpty)
            ? serverMeme
            : _resolveMemeForCounts(onCount: onCount, offCount: offCount);

        final resolvedTitle = serverTitle ?? _resolveTitleForCounts(onCount: onCount, offCount: offCount);
        final resolvedCaption = serverCaption ?? _resolveCaptionForCounts(onCount: onCount, offCount: offCount);
        final resolvedVerdict = serverVerdict ?? _resolveVerdictForCounts(onCount: onCount, offCount: offCount);

        return MemeResponse(
          onCount: onCount,
          offCount: offCount,
          memeUrl: resolvedMeme,
          title: resolvedTitle,
          caption: resolvedCaption,
          personalityVerdict: resolvedVerdict,
        );
      } catch (e) {
        if (e is ApiException) rethrow;
        throw ApiException('Failed to parse server prediction response: $e');
      }
    } else if (response.statusCode == 422) {
      throw InvalidPhotoException('The server could not process this image. Please select a clear switchboard photo.');
    } else {
      String errorMessage = 'Server responded with status code ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        if (errorBody.containsKey('detail')) {
          errorMessage = errorBody['detail'].toString();
        }
      } catch (_) {}
      throw ApiException(errorMessage);
    }
  }

  String _resolveMemeForCounts({required int onCount, required int offCount}) {
    final total = onCount + offCount;
    if (total == 0) {
      return _lowMemes[_random.nextInt(_lowMemes.length)];
    }
    final ratio = onCount / total;
    if (ratio > 0.6) {
      return _highMemes[_random.nextInt(_highMemes.length)];
    } else if (ratio < 0.4) {
      return _lowMemes[_random.nextInt(_lowMemes.length)];
    } else {
      return _medMemes[_random.nextInt(_medMemes.length)];
    }
  }

  String _resolveTitleForCounts({required int onCount, required int offCount}) {
    final total = onCount + offCount;
    if (total == 0) {
      return 'The Ghost Board';
    }
    if (offCount == 0) {
      return 'Stadium Lights Mode';
    }
    if (onCount == 0) {
      return 'Creature of the Shadows';
    }
    if (onCount == offCount) {
      return 'Zenith of Perfect Balance';
    }
    if (onCount > offCount) {
      return 'High Voltage Activity';
    }
    return 'Stealth Conservation Mode';
  }

  String _resolveCaptionForCounts({required int onCount, required int offCount}) {
    final total = onCount + offCount;
    if (total == 0) {
      return '0 switches detected. Either you aimed at a blank wall or this is a stealth installation.';
    }
    if (offCount == 0) {
      return 'All $onCount switches are ON! Your room is visible from low Earth orbit.';
    }
    if (onCount == 0) {
      return 'All $offCount switches are OFF. Navigating purely by muscle memory and pure instinct.';
    }
    if (onCount == offCount) {
      return '$onCount switches ON, $offCount switches OFF. Perfectly balanced, as all switchboards should be.';
    }
    if (onCount > offCount) {
      return '$onCount switches ON, $offCount switches OFF. High energy vibes running through the circuitry.';
    }
    return '$onCount switches ON, $offCount switches OFF. Electricity bill guardian angel in full action.';
  }

  String _resolveVerdictForCounts({required int onCount, required int offCount}) {
    final total = onCount + offCount;
    if (total == 0) {
      return '0 Switches • Mystery Wall Explorer';
    }
    final percentage = ((onCount / total) * 100).round();
    if (onCount == 0) {
      return '0% ON • Creature of the Shadows';
    }
    if (offCount == 0) {
      return '100% ON • Moth to the Flame';
    }
    if (onCount == offCount) {
      return '50/50 • Perfectly Balanced Neutral';
    }
    if (onCount > offCount) {
      return '$percentage% ON • High Energy Radiator';
    }
    return '${100 - percentage}% OFF • Energy Conservation Specialist';
  }
}
