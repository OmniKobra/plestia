// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../general.dart';
// import '../providers/article_provider.dart';
// import '../providers/blog_provider.dart';
// import '../providers/gallery_provider.dart';
import '../providers/home_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/articles/articles_tab.dart';
import '../widgets/blog/blog_tab.dart';
import '../widgets/gallery/gallery_tab.dart';
import '../widgets/home/home_tab.dart';
import '../widgets/home/langbutton.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget buildCurrentTab(TabView vie) {
    switch (vie) {
      case TabView.home:
        return const HomeTab();
      case TabView.articles:
        return const ArticlesTab();
      case TabView.gallery:
        return const GalleryTab();
      case TabView.blog:
        return const BlogTab();
      default:
        return const HomeTab();
    }
  }

  int giveViewNumber({
    required TabView vie,
    required int homeTabNumber,
    required int articleTabNumber,
    required int galleryTabNumber,
    required int blogTabNumber,
  }) {
    switch (vie) {
      case TabView.home:
        return homeTabNumber;
      case TabView.articles:
        return articleTabNumber;
      case TabView.gallery:
        return galleryTabNumber;
      case TabView.blog:
        return blogTabNumber;
      default:
        return homeTabNumber;
    }
  }

  Widget buildButton(String title, TabView v, void Function(TabView) changeTab,
      TabView current) {
    return Container(
      margin:
          EdgeInsets.all(MediaQuery.of(context).size.width >= 800 ? 5 : 2.5),
      child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                  EdgeInsets.all(
                      MediaQuery.of(context).size.width > 800 ? 12 : 8)),
              elevation: MaterialStateProperty.all<double?>(0),
              side: MaterialStateProperty.all<BorderSide?>(BorderSide(
                  width: 2,
                  color: v != current
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.secondary)),
              shape: MaterialStateProperty.all<OutlinedBorder?>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.all<Color?>(
                  v == current ? Colors.transparent : Theme.of(context).colorScheme.secondary)),
          onPressed: () {
            changeTab(v);
          },
          child: Text(title, style: TextStyle(color: v == current ? Theme.of(context).colorScheme.secondary : Colors.white, fontWeight: v == current ? FontWeight.bold : FontWeight.normal, fontSize: MediaQuery.of(context).size.width > 800 ? 22.5 : 15))),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = General.language(context);
    final dir = Provider.of<ThemeModel>(context).textDirection;
    final handler =
        Provider.of<HomeProvider>(context, listen: false).setCurrentView;
    final currentView = Provider.of<HomeProvider>(context).currentView;
    // final editGallery =
    //     Provider.of<GalleryProvider>(context, listen: false).setIsEditing;
    // final editArticles =
    //     Provider.of<ArticleProvider>(context, listen: false).setIsEditing;
    // final editBlog =
    //     Provider.of<BlogProvider>(context, listen: false).setIsEditing;
    // void editHome(bool _) {}

    // void Function(bool) giveEditHandler() {
    //   switch (currentView) {
    //     case TabView.home:
    //       return editHome;
    //     case TabView.articles:
    //       return editArticles;
    //     case TabView.gallery:
    //       return editGallery;
    //     case TabView.blog:
    //       return editBlog;
    //     default:
    //       return editHome;
    //   }
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: dir == TextDirection.ltr
            ? [if (MediaQuery.of(context).size.width > 600) const LangButton()]
            : [
                buildButton(lang.home4, TabView.blog, handler, currentView),
                buildButton(lang.home3, TabView.gallery, handler, currentView),
                buildButton(lang.home2, TabView.articles, handler, currentView),
                buildButton(lang.home1, TabView.home, handler, currentView),
                const SizedBox(width: 10),
                Container(
                    width: 80,
                    margin: EdgeInsets.all(
                        MediaQuery.of(context).size.width >= 800 ? 2.5 : 0),
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width >= 800 ? 6 : 4),
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Fplestia_ar.png?alt=media&token=0405e5c0-ac66-47cd-bd79-7b5cfd304697&_gl=1*1qmpsqd*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzE3Ni4yMi4wLjA.',
                      fit: BoxFit.cover,
                    )),
              ],
        title: Row(
            mainAxisAlignment: dir == TextDirection.rtl
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: dir == TextDirection.rtl
                ? [
                    if (MediaQuery.of(context).size.width > 600)
                      const LangButton()
                  ]
                : <Widget>[
                    Container(
                        height: 115,
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Fplestia_en.png?alt=media&token=d09c6e28-2c5a-40ae-a943-3ea92feb8dd4&_gl=1*rb00ah*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzIyNS41NC4wLjA.',
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(width: 5),
                    buildButton(lang.home1, TabView.home, handler, currentView),
                    buildButton(
                        lang.home2, TabView.articles, handler, currentView),
                    buildButton(
                        lang.home3, TabView.gallery, handler, currentView),
                    buildButton(lang.home4, TabView.blog, handler, currentView),
                    const Spacer()
                  ]),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Expanded(child: buildCurrentTab(currentView))],
          ),
        ),
      ),
      floatingActionButton: MediaQuery.of(context).size.width <= 600
          ? Container(
              margin: const EdgeInsets.only(top: 25), child: const LangButton())
          : null,
      floatingActionButtonLocation: dir == TextDirection.rtl
          ? FloatingActionButtonLocation.startTop
          : FloatingActionButtonLocation.endTop,
    );
  }
}
