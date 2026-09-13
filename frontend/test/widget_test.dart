import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:switch_meme/app/app.dart';
import 'package:switch_meme/models/meme_response.dart';
import 'package:switch_meme/services/api_service.dart';
import 'package:switch_meme/services/http_api_service.dart';
import 'package:switch_meme/services/mock_api_service.dart';

void main() {
  group('MemeResponse Model Tests', () {
    test('JSON parsing and calculations are accurate', () {
      final json = {
        'on': 3,
        'off': 2,
        'meme': 'https://example.com/meme.jpg',
        'title': 'Balanced Setup',
        'caption': 'Perfect harmony',
        'verdict': '60% ON • Electric Zen Master',
      };

      final response = MemeResponse.fromJson(json);

      expect(response.onCount, 3);
      expect(response.offCount, 2);
      expect(response.totalCount, 5);
      expect(response.onPercentage, 60);
      expect(response.memeUrl, 'https://example.com/meme.jpg');
      expect(response.effectiveVerdict, '60% ON • Electric Zen Master');
    });

    test('Effective verdict computes default if none provided', () {
      const responseZero = MemeResponse(onCount: 0, offCount: 5, memeUrl: '');
      expect(responseZero.effectiveVerdict, contains('0% ON'));

      const responseAll = MemeResponse(onCount: 5, offCount: 0, memeUrl: '');
      expect(responseAll.effectiveVerdict, contains('100% ON'));
    });
  });

  group('MockApiService Contract Tests', () {
    test('analyzeSwitches returns valid MemeResponse after delay', () async {
      final mockService = MockApiService();
      final mockFile = XFile.fromData(
        Uint8List.fromList(List.filled(100, 1)),
        name: 'sample_switches.jpg',
      );

      final response = await mockService.analyzeSwitches(mockFile);

      expect(response.onCount, isNonNegative);
      expect(response.offCount, isNonNegative);
      expect(response.totalCount, greaterThan(0));
      expect(response.memeUrl, isNotEmpty);
    });
  });

  group('HttpApiService Tests', () {
    test('parses predict API payload format accurately', () async {
      final mockClient = http_testing.MockClient((request) async {
        expect(request.url.path, '/predict');
        expect(request.method, 'POST');
        return http.Response(
          '{"number of switch": 5, "on switch": 4, "off switch": 1, "number_of_switches": 5, "on_switches": 4, "off_switches": 1, "switches": []}',
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = HttpApiService(client: mockClient);
      final file = XFile.fromData(Uint8List.fromList([1, 2, 3, 4]), name: 'board.jpg');
      final result = await service.analyzeSwitches(file);

      expect(result.onCount, 4);
      expect(result.offCount, 1);
      expect(result.totalCount, 5);
      expect(result.memeUrl, isNotEmpty);
      expect(result.effectiveVerdict, isNotEmpty);
    });

    test('throws InvalidPhotoException on empty file', () async {
      final service = HttpApiService();
      final emptyFile = XFile.fromData(Uint8List.fromList([]), name: 'empty.jpg');

      expect(
        () => service.analyzeSwitches(emptyFile),
        throwsA(isA<InvalidPhotoException>()),
      );
    });
  });

  group('App Widget Smoke Tests', () {
    testWidgets('HomeScreen renders logo, title, and pick buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const SwitchMemeApp());
      await tester.pumpAndSettle();

      expect(find.text('Show us your switches.\nWe\'ll judge them.'), findsOneWidget);
      expect(find.text('Take a photo'), findsOneWidget);
      expect(find.text('Choose from gallery'), findsOneWidget);
    });
  });
}
