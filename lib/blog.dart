import 'dart:io';
import 'package:flutter/material.dart';
import 'models.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ブログ')),
      body: Center(
        child: Text(
          'ブログは現在準備中です。',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }}