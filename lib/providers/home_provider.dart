import 'package:flutter/foundation.dart';

enum TabView { home, articles, gallery, blog }

class HomeProvider extends ChangeNotifier {
  String _name = '';
  //TODO MAX 250 CHARACTERS
  String _bio = '';
  String _avatarUrl = '';
  String _bannerUrl = '';
  String _tiktokUrl = '';
  String _instagramUrl = '';
  //TODO MAX 400
  String _aboutDescription = '';
  int _numViews = 500000;
  int _numLikes = 0;
  bool _isAdmin = false;
  List<String> _carouselMediaUrls = [];
  TabView _currentView = TabView.home;
  String get name => _name;
  String get bio => _bio;
  String get avatarUrl => _avatarUrl;
  String get bannerUrl => _bannerUrl;
  String get tiktokUrl => _tiktokUrl;
  String get instagramUrl => _instagramUrl;
  String get aboutDescription => _aboutDescription;
  int get numViews => _numViews;
  int get numLikes => _numLikes;
  bool get isAdmin => _isAdmin;
  List<String> get carouselMediaUrls => _carouselMediaUrls;
  TabView get currentView => _currentView;

  void setCurrentView(TabView v) {
    if (currentView != v) {
      _currentView = v;
      notifyListeners();
    }
  }

  void setName(String n) {
    _name = n;
    notifyListeners();
  }

  void setBio(String b) {
    _bio = b;
    notifyListeners();
  }

  void setAvatarUrl(String u) {
    _avatarUrl = u;
    notifyListeners();
  }

  void setBannerUrl(String bu) {
    _bannerUrl = bu;
    notifyListeners();
  }

  void setTiktokUrl(String tu) {
    _tiktokUrl = tu;
    notifyListeners();
  }

  void setInstagramUrl(String iu) {
    _instagramUrl = iu;
    notifyListeners();
  }

  void setAboutDescription(String ad) {
    _aboutDescription = ad;
    notifyListeners();
  }

  void setNumViews(int nv) {
    _numViews = nv;
    notifyListeners();
  }

  void setNumLikes(int nl) {
    _numLikes = nl;
    notifyListeners();
  }

  void setIsAdmin(bool isA) {
    _isAdmin = isA;
    notifyListeners();
  }

  void setCarouselMediaUrls(List<String> u) {
    _carouselMediaUrls = u;
    notifyListeners();
  }

  void initHomePage({
    required String paramName,
    required String paramBio,
    required String paramAvatar,
    required String paramBanner,
    required String paramTiktok,
    required String paramInsta,
    required String paramAbout,
    required List<String> paramCarouselMediaUrls,
  }) {
    setName(paramName);
    setBio(paramBio);
    setAvatarUrl(paramAvatar);
    setBannerUrl(paramBanner);
    setTiktokUrl(paramTiktok);
    setInstagramUrl(paramInsta);
    setAboutDescription(paramAbout);
    setCarouselMediaUrls(paramCarouselMediaUrls);
  }
}
