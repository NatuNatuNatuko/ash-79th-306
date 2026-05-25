import 'package:asahi_79th_306/Kei.dart';
import 'package:asahi_79th_306/blog.dart';
import 'package:asahi_79th_306/link.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models.dart';
import 'cast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitStory() {
    if (_authorController.text.isEmpty ||
        _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('名前とあらすじを入力してください')),
      );
      return;
    }

    storyPosts.add(
      StoryPost(
        author: _authorController.text,
        content: _contentController.text,
        timestamp: DateTime.now(),
      ),
    );

    

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('あらすじを投稿しました！')),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('投稿を削除'),
          content: const Text('この投稿を削除しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                storyPosts.removeAt(index);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text(
                '削除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCE4EC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'あらすじ投稿',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(
                hintText: '投稿者名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'あらすじを入力してください',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitStory,
              child: const Text('投稿する'),
            ),
            const SizedBox(height: 32),
            const Text(
              '投稿一覧',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            storyPosts.isEmpty
                ? const Center(
                    child: Text(
                      'まだ投稿がありません',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: storyPosts.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final post = storyPosts[storyPosts.length - 1 - index];
                      final postIndex = storyPosts.length - 1 - index;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.author,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        _formatTime(post.timestamp),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () =>
                                        _confirmDelete(postIndex),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(post.content),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'たった今';
    if (diff.inHours < 1) return '${diff.inMinutes}分前';
    if (diff.inDays < 1) return '${diff.inHours}時間前';
    return '${dateTime.month}/${dateTime.day}';
  }
}

class CastPage extends StatefulWidget {
  final VoidCallback onPostAdded;

  const CastPage({super.key, required this.onPostAdded});

  @override
  State<CastPage> createState() => _CastPageState();
}

class _CastPageState extends State<CastPage> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _commentController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickCastImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submitCastPost() {
    if (_nameController.text.isEmpty || _roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('名前と役名を入力してください')),
      );
      return;
    }

    castPosts.add(
      CastPost(
        actorName: _nameController.text,
        role: _roleController.text,
        comment: _commentController.text,
        imagePath: _selectedImage?.path,
        timestamp: DateTime.now(),
      ),
    );

    widget.onPostAdded();
    _nameController.clear();
    _roleController.clear();
    _commentController.clear();
    setState(() {
      _selectedImage = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('キャスト投稿を保存しました！')),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('投稿を削除'),
          content: const Text('このキャスト投稿を削除しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                castPosts.removeAt(index);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text(
                '削除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'キャスト投稿',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: '役者名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(
                hintText: '役名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'コメントや演出のポイント',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickCastImage,
              icon: const Icon(Icons.photo),
              label: const Text('写真を追加（任意）'),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitCastPost,
              child: const Text('キャスト投稿する'),
            ),
            const SizedBox(height: 32),
            const Text(
              'キャスト投稿一覧',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            castPosts.isEmpty
                ? const Center(
                    child: Text(
                      'まだキャスト投稿がありません',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: castPosts.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final entry = castPosts[castPosts.length - 1 - index];
                      final entryIndex = castPosts.length - 1 - index;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (entry.imagePath != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(entry.imagePath!),
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if (entry.imagePath != null)
                                const SizedBox(height: 12),
                              Text(
                                entry.actorName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.role,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(entry.comment),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatCastDate(entry.timestamp),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () =>
                                        _confirmDelete(entryIndex),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  String _formatCastDate(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'クラス劇サイト',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // If you place a local Shirayukihime TTF at assets/fonts/Shirayukihime.ttf
        // the app will use it (fontFamily). GoogleFonts provides a fallback
        // Japanese-friendly font (Sawarabi Mincho) if the local font is not present.
        fontFamily: 'Shirayukihime',
        textTheme: GoogleFonts.sawarabiMinchoTextTheme(),
      ),
      home: const AnimatedTabPage(),
    );
  }
}

class AnimatedTabPage extends StatefulWidget {
  const AnimatedTabPage({super.key});

  @override
  State<AnimatedTabPage> createState() => _AnimatedTabPageState();
}

class _AnimatedTabPageState extends State<AnimatedTabPage> {
  void _openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.indigo,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '白雪姫',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '公演サイトへようこそ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
           
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('キャスト紹介'),
              onTap: () {
                Navigator.pop(context);
                _openPage(const CastIntroPage());
              },
            ),

            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('ブログ'),
              onTap: () {
                Navigator.pop(context);
                _openPage(const BlogPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('他サイト'),
              onTap: () {
                Navigator.pop(context);
                _openPage(LinkPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('制作者について'),
              onTap: () {
                Navigator.pop(context);
                _openPage(ProfilePage());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '白雪姫',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Shirayukihime',
          ),
        ),
        leadingWidth: 85,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openPage(const BlogPage()),
          ),
        ],
        
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(7),
        child: const Text(
          "©志熊けい　旭丘高校306",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: HomePage(onPostAdded: () => setState(() {})),
    );
  }
}

class AnimatedPage extends StatefulWidget {
  final Color color;
  final String text;
  final IconData icon;

  const AnimatedPage({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
  });

  @override
  State<AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,

      child: Center(
        child: SlideTransition(
          position: _slideAnimation,

          child: FadeTransition(
            opacity: _fadeAnimation,

            child: ScaleTransition(
              scale: _scaleAnimation,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(
                    widget.icon,
                    size: 120,
                    color: Colors.indigo,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'ここに内容を書けます',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onPostAdded;

  const HomePage({super.key, required this.onPostAdded});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _castPageController;
  Timer? _castAutoScrollTimer;

  @override
  void initState() {
    super.initState();
    _castPageController = PageController(viewportFraction: 0.9);
    _castAutoScrollTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _advanceCastSlider(),
    );
  }

  @override
  void dispose() {
    _castAutoScrollTimer?.cancel();
    _castPageController.dispose();
    super.dispose();
  }

  void _advanceCastSlider() {
    if (castPosts.isEmpty || !_castPageController.hasClients) return;
    final nextPage = (_castPageController.page?.round() ?? 0) + 1;
    final page = nextPage >= castPosts.length ? 0 : nextPage;
    _castPageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final latestBlogPosts = diaryEntries.reversed.take(3).toList();
    final latestStory = storyPosts.isNotEmpty ? storyPosts.last : null;

    return Container(
      color: const Color(0xFFE3F2FD),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Image.asset('assets/example.png', height: 100),
                    const SizedBox(height: 12),
                    const Text(
                      'クラス劇2026へようこそ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '最新情報をチェックして、あらすじ・キャスト・ブログを楽しんでください。',
                      style: TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'あらすじプレビュー',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                latestStory != null
                    ? latestStory.content.length > 200
                        ? '${latestStory.content.substring(0, 200)}…'
                        : latestStory.content
                    : 'まだあらすじが投稿されていません。',
                      ),
            ),
           
            const Divider(height: 32, thickness: 1.2),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '最新ブログ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (latestBlogPosts.isEmpty)
              const EmptyStateCard(message: 'まだブログ記事がありません。')
            else
              Column(
                children: latestBlogPosts.map((entry) {
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
                            entry.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            entry.description.length > 100
                                ? '${entry.description.substring(0, 100)}…'
                                : entry.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${entry.timestamp.year}/${entry.timestamp.month}/${entry.timestamp.day}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogPage()),
                ),
                child: const Text('もっと見る'),
              ),
            ),
            
            const Divider(height: 32, thickness: 1.2),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'キャスト紹介',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 240,
              child: castPosts.isEmpty
                  ? const Center(
                      child: Text(
                        'キャスト紹介がまだありません。',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : PageView.builder(
                      controller: _castPageController,
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
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: Text(
                                      entry.comment.isEmpty
                                          ? 'コメントなし'
                                          : entry.comment.length > 100
                                              ? '${entry.comment.substring(0, 100)}…'
                                              : entry.comment,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _formatCastDate(entry.timestamp),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CastIntroPage()),
                ),
                child: const Text('もっと見る'),
              ),
            ),
            const Divider(height: 32, thickness: 1.2),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Instagram',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.pinkAccent, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '公式Instagramは準備中です。',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '公開したらここからアクセスできます。',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LinkPage()),
                      ),
                      child: const Text('見る'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatCastDate(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }
}

class PostPage extends StatefulWidget {
  final VoidCallback onPostAdded;

  const PostPage({super.key, required this.onPostAdded});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitPost() {
    if (_authorController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('名前と内容を入力してください')),
      );
      return;
    }

    posts.add(
      Post(
        author: _authorController.text,
        content: _contentController.text,
        timestamp: DateTime.now(),
      ),
    );

    _authorController.clear();
    _contentController.clear();

    widget.onPostAdded();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('投稿しました！')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFEBEE),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            const SizedBox(height: 16),
            const Text(
              '投稿する',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                hintText: 'あなたの名前',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'メッセージを入力してください',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.message),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _submitPost,
              icon: const Icon(Icons.send),
              label: const Text('投稿する'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'すべての投稿',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            posts.isEmpty
                ? const Center(
                    child: Text(
                      'まだ投稿がありません',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final post = posts[posts.length - 1 - index];
                      final postIndex = posts.length - 1 - index;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.author,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          _formatTime(post.timestamp),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () =>
                                        _showDeleteDialog(context, postIndex),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                post.content,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'たった今';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('投稿を削除'),
          content: const Text('この投稿を削除してもよろしいですか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                posts.removeAt(index);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text(
                '削除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submitDiaryEntry() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('タイトルと内容を入力してください'),
        ),
      );
      return;
    }

    diaryEntries.add(
      DiaryEntry(
        title: _titleController.text,
        description: _descriptionController.text,
        imagePath: _selectedImage?.path,
        timestamp: DateTime.now(),
      ),
    );

    setState(() {
      _selectedImage = null;
    });

    _titleController.clear();
    _descriptionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('日記を投稿しました！')),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('日記を削除'),
          content: const Text('この日記を削除してもよろしいですか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                diaryEntries.removeAt(index);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('日記を削除しました')),
                );
              },
              child: const Text(
                '削除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF8E1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '日記ブログ',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            const SizedBox(height: 16),
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            if (_selectedImage != null) const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'タイトル',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '今日の出来事や感想を書いてください',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('写真を追加（任意）'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitDiaryEntry,
              child: const Text('日記を投稿する'),
            ),
            const SizedBox(height: 32),
            const Text(
              '日記一覧',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (diaryEntries.isEmpty)
              const Center(
                child: Text(
                  'まだ日記がありません',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              )
            else ...List.generate(diaryEntries.length, (reverseIndex) {
              final index = diaryEntries.length - 1 - reverseIndex;
              final entry = diaryEntries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (entry.imagePath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(entry.imagePath!),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (entry.imagePath != null)
                        const SizedBox(height: 12),
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatEntryDate(entry.timestamp),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _showDeleteDialog(context, index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(entry.description),
                    ],
                  ),
                ),
              );
            }
            ),
          ],
        ),
      ),
      
    );
  }

  String _formatEntryDate(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}