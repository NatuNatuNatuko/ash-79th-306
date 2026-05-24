import 'dart:io';
import 'package:flutter/material.dart';
import 'models.dart';

class EmptyStateCard extends StatelessWidget {
  final String message;

  const EmptyStateCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.indigo),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StorySummaryPage extends StatelessWidget {
  const StorySummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('あらすじ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: storyPosts.isEmpty
            ? const Center(
                child: Text(
                  'まだあらすじが投稿されていません。',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            : ListView.builder(
                itemCount: storyPosts.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final story = storyPosts[storyPosts.length - 1 - index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.author,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(story.content),
                          const SizedBox(height: 10),
                          Text(
                            '${story.timestamp.year}/${story.timestamp.month}/${story.timestamp.day}',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class CastIntroPage extends StatelessWidget {
  const CastIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('キャスト紹介')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: castPosts.isEmpty
            ? const Center(
                child: Text(
                  'まだキャスト紹介がありません。',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 260,
                    child: PageView.builder(
                      itemCount: castPosts.length,
                      itemBuilder: (context, index) {
                        final entry = castPosts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.actorName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.role,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  if (entry.imagePath != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(entry.imagePath!),
                                        height: 130,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Text(entry.comment.isEmpty ? 'コメントなし' : entry.comment),
                                  const Spacer(),
                                  Text(
                                    '${entry.timestamp.year}/${entry.timestamp.month}/${entry.timestamp.day}',
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: castPosts.length,
                      itemBuilder: (context, index) {
                        final entry = castPosts[castPosts.length - 1 - index];
                        return ListTile(
                          title: Text(entry.actorName),
                          subtitle: Text(entry.role),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class OtherSitesPage extends StatelessWidget {
  const OtherSitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('他サイト')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.link),
              title: Text('公式サイト'),
              subtitle: Text('公演情報や最新ニュースはこちら'),
            ),
          ),
          Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.video_library),
              title: Text('制作舞台裏'),
              subtitle: Text('制作に関する特集ページ（準備中）'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Instagramページ'),
              subtitle: Text('公式インスタグラムへようこそ'),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('制作者について')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              '制作チーム',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '志熊けい（旭丘高校79期生）は、本アプリのデザインと制作を担当しています。Flutterを使って表現力のある公演サイトを目指しました。',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            SizedBox(height: 16),
            Text(
              '本アプリでは、あらすじ・キャスト紹介・ブログ・投稿を一つのアプリで楽しめるように構成されています。',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class InstagramPage extends StatelessWidget {
  const InstagramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instagram')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.camera_alt, size: 64, color: Colors.pinkAccent),
              SizedBox(height: 20),
              Text(
                'Instagram機能は現在準備中です。',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                '公開されたらこちらから公式Instagramに飛べるようになります。',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
