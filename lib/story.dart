import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class StoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ストーリー紹介'),
      ),
      body: Center(
        child: Text(
          'ここにストーリーの紹介文を入力してください。',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}