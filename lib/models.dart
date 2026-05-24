class Post {
  final String author;
  final String content;
  final DateTime timestamp;

  Post({
    required this.author,
    required this.content,
    required this.timestamp,
  });
}

class DiaryEntry {
  final String title;
  final String description;
  final String? imagePath;
  final DateTime timestamp;

  DiaryEntry({
    required this.title,
    required this.description,
    this.imagePath,
    required this.timestamp,
  });
}

class StoryPost {
  final String author;
  final String content;
  final DateTime timestamp;

  StoryPost({
    required this.author,
    required this.content,
    required this.timestamp,
  });
}

class CastPost {
  final String actorName;
  final String role;
  final String comment;
  final String? imagePath;
  final DateTime timestamp;

  CastPost({
    required this.actorName,
    required this.role,
    required this.comment,
    this.imagePath,
    required this.timestamp,
  });
}

final posts = <Post>[];
final diaryEntries = <DiaryEntry>[];
final storyPosts = <StoryPost>[];
final castPosts = <CastPost>[];
