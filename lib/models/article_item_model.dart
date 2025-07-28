class ArticleItemModel {
  final String id;
  final String mediaUrl;
  final String title;
  final String description;
  final int numViews;
  final DateTime date;
  const ArticleItemModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.mediaUrl,
      required this.numViews,
      required this.date});
}
