import 'dart:io';
import 'package:flutter/material.dart';
import 'models.dart';

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
                                    '${entry.timestamp.year}/${entry.timestamp.month}/${entry.timestamp.day} ${entry.timestamp.hour}:${entry.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
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
