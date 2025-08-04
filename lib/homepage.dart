import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'api.dart';
import 'store.dart';
import 'reviewpage.dart';

class Homepage extends StatefulWidget {
  final double appBarMargin;
  final double listItemMargin;

  const Homepage({
    super.key,
    this.appBarMargin = 8.0,
    this.listItemMargin = 24.0,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();

  final NaverApiService apiService = NaverApiService(
    clientId: 'CPqLZ5WMXtR9h3kfF2ux',
    clientSecret: 'ib6uLDYoo5',
  );

  List<Store> searchResults = [];

  void search(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    debugPrint('Searching for: $trimmedQuery');

    try {
      final results = await apiService.searchLocal(trimmedQuery);
      debugPrint('Found ${results.length} results');

      setState(() {
        searchResults = results.map((json) => Store.fromJson(json)).toList();
      });
    } catch (e) {
      debugPrint('Error fetching results: $e');
      setState(() => searchResults = []);
    }
  }

  Future<void> searchByCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        try {
          permission = await Geolocator.requestPermission();
        } on PermissionRequestInProgressException {
          debugPrint('⚠️ 위치 권한 요청 중입니다. 잠시 후 다시 시도하세요.');
          return;
        }

        if (permission == LocationPermission.denied) {
          debugPrint('위치 권한이 거부되었습니다.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해야 합니다.');
        return;
      }

      double lat = 37.497942;
      double lon = 127.027621;

      const vworldKey = '99C77382-1779-3E6A-A623-868430D6EF9F';
      final vworldUrl = Uri.parse(
        'https://api.vworld.kr/req/address?service=address&request=getAddress'
        '&key=$vworldKey&point=$lon,$lat&type=BOTH&format=json',
      );

      final res = await http.get(vworldUrl);
      if (res.statusCode == 200) {
        final json = res.body;
        debugPrint('💬 VWORLD 응답 본문: $json');
        final data = jsonDecode(json);
        final resultsList = data['response']?['result'];
        if (resultsList != null && resultsList.isNotEmpty) {
          final address = resultsList[0]['text'];
          final results = await apiService.searchLocal(address);
          setState(() {
            searchResults = results
                .map((json) => Store.fromJson(json))
                .toList();
          });
        } else {
          debugPrint('VWORLD 응답에 주소 결과가 없습니다.');
        }
      } else {
        debugPrint('VWORLD API 실패: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('위치 기반 검색 오류: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.purple[50],
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.appBarMargin),
          child: SizedBox(
            width: double.infinity,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintText: '검색어를 입력해 주세요',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onSubmitted: search,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.gps_fixed),
            tooltip: '현재 위치로 검색',
            onPressed: () {
              searchByCurrentLocation();
            },
          ),
        ],
      ),
      body: searchResults.isEmpty
          ? const SizedBox.shrink()
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final item = searchResults[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewPage(store: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: widget.listItemMargin,
                      vertical: 8.0,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.roadAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
