import 'package:flutter/foundation.dart';
import '../models/article_item_model.dart';

class ArticleProvider with ChangeNotifier {
  List<ArticleItemModel> _articles = [];
  int _numViews = 0;
  bool _isEditing = false;
  List<ArticleItemModel> get articles => _articles;
  int get numViews => _numViews;
  bool get isEditing => _isEditing;

  void setIsEditing(bool i) {
    _isEditing = i;
    notifyListeners();
  }

  void setArticles(List<ArticleItemModel> a) {
    _articles = a;
    notifyListeners();
  }

  void addArticles(List<ArticleItemModel> ma) {
    _articles.addAll(ma);
    notifyListeners();
  }

  void setNumViews(int nv) {
    _numViews = nv;
    notifyListeners();
  }
}
