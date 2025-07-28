class GalleryItemModel {
  final String id;
  final String url;
  final String thumbnail;
  final DateTime date;
  final int views;
  const GalleryItemModel(
      {required this.id,
      required this.url,
      required this.thumbnail,
      required this.date,
      required this.views});
}
