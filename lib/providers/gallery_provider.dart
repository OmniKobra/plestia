import 'package:flutter/foundation.dart';
import '../models/gallery_item_model.dart';

class GalleryProvider with ChangeNotifier {
  List<GalleryItemModel> _galleryItems = [];
  bool _isEditing = false;
  List<GalleryItemModel> get galleryItems => _galleryItems;
  bool get isEditing => _isEditing;
  int _numViews = 0;
  int get numViews => _numViews;

  void setIsEditing(bool i) {
    _isEditing = i;
    notifyListeners();
  }

  void setGalleryItems(List<GalleryItemModel> i) {
    _galleryItems = i;
    notifyListeners();
  }

  void addGalleryItems(List<GalleryItemModel> moreI) {
    _galleryItems.addAll(moreI);
    notifyListeners();
  }

  void setNumViews(int nv) {
    _numViews = nv;
    notifyListeners();
  }
}
