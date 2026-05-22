import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('製作者プロフィール'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              '志熊けい',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              '旭丘高校79期生。　\nアマチュアイラストレーター、アマチュアプログラマー。かつては動画師としても活動していた。\nイラストは主にデジタルで、セミリアルスタイルを得意としている。\nプログラミングは主にFlutterで、鯱光祭アプリ開発を行っていた。',
              style: TextStyle(fontSize: 16),
            ),
          ],
      ),
    ));
  }
}