class BlogContent {
  final bool isText;
  final bool mediaIsAsset;
  final bool isInEdit;
  final String description;
  final String mediaURL;
  final String thumbnailURL;
  final String assetPath;
  const BlogContent(
      {required this.isText,
      required this.mediaIsAsset,
      required this.isInEdit,
      required this.description,
      required this.mediaURL,
      required this.thumbnailURL,
      required this.assetPath});
}
