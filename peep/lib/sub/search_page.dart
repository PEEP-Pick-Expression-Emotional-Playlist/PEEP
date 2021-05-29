import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchPageHeader(),
      body: Container(
        child: Text('검색 화면'),
      ),
    );
  }
}

TextEditingController searchTextEditingController = TextEditingController();

emptyTheTextFormField() {
  searchTextEditingController.clear();
}

AppBar searchPageHeader() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    title: TextFormField(
      controller: searchTextEditingController,
      decoration: InputDecoration(
          hintText: '검색할 곡을 입력하세요',
          filled: true,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey,
              ),
              onPressed: emptyTheTextFormField())),
    ),
  );
}
