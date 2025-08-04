import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'store.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, List<Store>>(
  HomeViewModel.new,
);

class HomeViewModel extends Notifier<List<Store>> {
  @override
  List<Store> build() => [];

  Future<void> getAddressAndSearch() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('위치 권한이 거부되었습니다.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해야 합니다.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double lat = position.latitude;
      double lon = position.longitude;

      debugPrint('위도: $lat, 경도: $lon');

      const vworldKey = '99C77382-1779-3E6A-A623-868430D6EF9F';
      final vworldUrl = Uri.parse(
        'https://api.vworld.kr/req/address?service=address&request=getAddress&key=$vworldKey&point=$lon,$lat&type=BOTH&format=json',
      );

      final vworldRes = await http.get(vworldUrl);
      final vworldJson = jsonDecode(vworldRes.body);

      final resultsList = vworldJson['response']?['result'];
      if (resultsList == null || resultsList.isEmpty) {
        debugPrint('VWORLD 응답에 주소 결과가 없습니다.');
        return;
      }

      final address = resultsList[0]['text'];

      const naverClientId = 'CPqLZ5WMXtR9h3kfF2ux';
      const naverClientSecret = 'ib6uLDYoo5';

      final naverUrl = Uri.parse(
        'https://openapi.naver.com/v1/search/local.json?query=$address',
      );

      final naverRes = await http.get(
        naverUrl,
        headers: {
          'X-Naver-Client-Id': naverClientId,
          'X-Naver-Client-Secret': naverClientSecret,
        },
      );

      if (naverRes.statusCode == 200) {
        final naverJson = jsonDecode(naverRes.body);
        final items = naverJson['items'] as List<dynamic>;
        final stores = items.map((json) => Store.fromJson(json)).toList();
        state = stores;
        debugPrint('state updated with ${state.length} items');
      } else {
        throw Exception('네이버 API 오류: ${naverRes.statusCode}');
      }
    } on PermissionRequestInProgressException {
      debugPrint('⚠️ 위치 권한 요청 중입니다. 잠시 후 다시 시도하세요.');
    } catch (e, stacktrace) {
      debugPrint('getAddressAndSearch error: $e');
      debugPrint('Stacktrace: $stacktrace');
    }
  }
}
