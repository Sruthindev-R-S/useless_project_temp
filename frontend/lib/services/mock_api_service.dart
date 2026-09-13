import 'package:cross_file/cross_file.dart';
import '../models/meme_response.dart';
import '../utils/constants.dart';
import 'api_service.dart';

// TODO:
// Replace MockApiService with the real API implementation
// once the backend endpoint and response format are provided.
//
// Example real implementation outline:
// class RealApiService implements ApiService {
//   final String baseUrl;
//   RealApiService({required this.baseUrl});
//
//   @override
//   Future<MemeResponse> analyzeSwitches(XFile imageFile) async {
//     final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/analyze'));
//     final bytes = await imageFile.readAsBytes();
//     request.files.add(http.MultipartFile.fromBytes('photo', bytes, filename: imageFile.name));
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//     final json = jsonDecode(response.body);
//     return MemeResponse.fromJson(json);
//   }
// }

/// Mock implementation of [ApiService] for hackathon development & demo.
class MockApiService implements ApiService {
  int _callIndex = 0;

  /// Flag to simulate API error for testing error states in demo
  final bool simulateError;

  MockApiService({this.simulateError = false});

  @override
  Future<MemeResponse> analyzeSwitches(XFile imageFile) async {
    // 1. Validate file existence and size
    final length = await imageFile.length();
    if (length <= 0) {
      throw InvalidPhotoException('The selected photo appears to be empty. Please select another.');
    }

    // 2. Simulate realistic backend processing latency (2.2 seconds)
    await Future.delayed(const Duration(milliseconds: 2200));

    if (simulateError) {
      throw ApiException('The switchboard scanner encountered an unexpected hiccup. Try another angle!');
    }

    // 3. Cycle through curated realistic mock scenarios
    final scenarios = [
      const _MockScenario(
        on: 3,
        off: 2,
        title: 'Optimal Chaos Neutral',
        caption: '3 switches ON, 2 switches OFF. You live right on the edge of productivity.',
        verdict: '60% ON • Perfectly Balanced Indie Hacker',
      ),
      const _MockScenario(
        on: 5,
        off: 0,
        title: 'Moth Overdrive',
        caption: 'All 5 switches ON! Your room is visible from the International Space Station.',
        verdict: '100% ON • Electric Bill Supervillain',
      ),
      const _MockScenario(
        on: 0,
        off: 4,
        title: 'Creature of Pure Darkness',
        caption: 'All switches OFF. You code exclusively by the illumination of error messages.',
        verdict: '0% ON • Stealth Night Stalker',
      ),
      const _MockScenario(
        on: 2,
        off: 1,
        title: 'The Mystery Switch Setup',
        caption: '2 ON, 1 OFF. One of these switches controls something in another dimension.',
        verdict: '67% ON • Enigmatic Switch Operator',
      ),
      const _MockScenario(
        on: 4,
        off: 2,
        title: 'High Voltage Hustle',
        caption: '4 switches ON, 2 switches OFF. 67% illuminated, 100% determined.',
        verdict: '67% ON • Domestic Dynamo',
      ),
    ];

    final scenario = scenarios[_callIndex % scenarios.length];
    _callIndex++;

    // Pick mock meme from library or fallback
    final mockMeme = AppConstants.mockMemes[(_callIndex - 1) % AppConstants.mockMemes.length];

    return MemeResponse(
      onCount: scenario.on,
      offCount: scenario.off,
      memeUrl: mockMeme.imageUrl,
      title: scenario.title,
      caption: scenario.caption,
      personalityVerdict: scenario.verdict,
    );
  }
}

class _MockScenario {
  final int on;
  final int off;
  final String title;
  final String caption;
  final String verdict;

  const _MockScenario({
    required this.on,
    required this.off,
    required this.title,
    required this.caption,
    required this.verdict,
  });
}
