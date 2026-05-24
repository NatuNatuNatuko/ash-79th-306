import 'package:flutter/material.dart';

class LinkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('関連リンク'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // ここにリンクの処理を追加
              },
              child: Text('公式サイト'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // ここにリンクの処理を追加
              },
              child: Text('Twitter'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // ここにリンクの処理を追加
              },
              child: Text('Instagram'),
            ),
          ],
        ),
      ),
    );
  }
}