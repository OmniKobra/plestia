import 'package:flutter/foundation.dart';

import '../models/blog_item_model.dart';

class BlogProvider with ChangeNotifier {
  List<BlogItemModel> _blogItems = [];
  int _numViews = 0;
  bool _isEditing = false;
  List<BlogItemModel> get blogItems => _blogItems;
  int get numViews => _numViews;
  bool get isEditing => _isEditing;
  void setIsEditing(bool i) {
    _isEditing = i;
    notifyListeners();
  }

  void setBlogItems(List<BlogItemModel> bItems) {
    _blogItems = bItems;
    notifyListeners();
  }

  void addBlogItems(List<BlogItemModel> morebItems) {
    _blogItems.addAll(morebItems);
    notifyListeners();
  }

  void setNumViews(int n) {
    _numViews = n;
    notifyListeners();
  }
}
