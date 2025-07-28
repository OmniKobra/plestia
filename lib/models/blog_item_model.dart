import 'blog_item_content.dart';

class BlogItemModel {
  final String id;
  final String title;
  final DateTime date;
  final int views;
  final List<BlogContent> contents;
  const BlogItemModel(
      {required this.id,
      required this.title,
      required this.date,
      required this.views,
      required this.contents});
}
