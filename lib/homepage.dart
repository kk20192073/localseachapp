import 'package:flutter/material.dart';
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

    print('Searching for: $trimmedQuery');

    try {
      final results = await apiService.searchLocal(trimmedQuery);
      print('Found ${results.length} results');

      setState(() {
        searchResults = results.map((json) => Store.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error fetching results: $e');
      setState(() => searchResults = []);
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
