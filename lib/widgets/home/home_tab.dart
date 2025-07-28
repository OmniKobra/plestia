// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../error.dart';
import '../loading.dart';
import 'home_carousel_description.dart';
import 'inquiries_section.dart';
import 'profile_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab();

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final firestore = FirebaseFirestore.instance;
  var stateabout = '';
  var stateavatar = '';
  var statebanner = '';
  var statebio = '';
  var stateinstagramUrl = '';
  var statetiktokUrl = '';
  var statename = '';
  List<String> statemediaList = [];
  late Future<void> _getHome;
  Future<void> getHome(
      void Function(
              {required String paramAbout,
              required String paramAvatar,
              required String paramBanner,
              required String paramBio,
              required List<String> paramCarouselMediaUrls,
              required String paramInsta,
              required String paramName,
              required String paramTiktok})
          initHomePage) async {
    return firestore.collection('general').doc('home').get().then((doc) {
      final about = doc.get('about');
      final avatar = doc.get('avatarUrl');
      final banner = doc.get('bannerUrl');
      final bio = doc.get('bio');
      final instagramUrl = doc.get('instagramUrl');
      final tiktokUrl = doc.get('tiktokUrl');
      final name = doc.get('name');
      final media = doc.get('mediaUrls') as List;
      final mediaList = media.map((url) => url as String).toList();
      stateabout = about;
      stateavatar = avatar;
      statebanner = banner;
      statebio = bio;
      stateinstagramUrl = instagramUrl;
      statetiktokUrl = tiktokUrl;
      statename = name;
      statemediaList = mediaList;
      initHomePage(
          paramName: name,
          paramBio: bio,
          paramAvatar: avatar,
          paramBanner: banner,
          paramTiktok: tiktokUrl,
          paramInsta: instagramUrl,
          paramAbout: about,
          paramCarouselMediaUrls: mediaList);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final initHomePage =
        Provider.of<HomeProvider>(context, listen: false).initHomePage;
    _getHome = getHome(initHomePage);
  }

  @override
  Widget build(BuildContext context) {
    const heightBox = SizedBox(height: 20);
    final widthQuery = MediaQuery.of(context).size.width >= 800;
    final initHomePage =
        Provider.of<HomeProvider>(context, listen: false).initHomePage;
    return FutureBuilder(
        future: _getHome,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (snapshot.hasError) {
            return MyErrorWidget(() {
              setState(() {
                _getHome = getHome(initHomePage);
              });
            });
          }
          return Builder(builder: (context) {
            // final initHomePag2 =
            //     Provider.of<HomeProvider>(context, listen: false).initHomePage;
            // initHomePag2(
            //     paramName: statename,
            //     paramBio: statebio,
            //     paramAvatar: stateavatar,
            //     paramBanner: statebanner,
            //     paramTiktok: statetiktokUrl,
            //     paramInsta: stateinstagramUrl,
            //     paramAbout: stateabout,
            //     paramCarouselMediaUrls: statemediaList);
            return Builder(builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      Provider.of<HomeProvider>(context)
                                          .bannerUrl))),
                          child: const ProfileCard()),
                      Container(height: 20, color: Colors.grey.shade50),
                      const CarouselDescription(),
                      heightBox,
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: widthQuery ? 300 : 150,
                              width: widthQuery ? 300 : 150,
                              color: Colors.white,
                              padding: const EdgeInsets.all(16),
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Fplestia.png?alt=media&token=9e516780-bcfb-4825-a49d-acd667c19b02&_gl=1*qf96le*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzM1MC40MC4wLjA.',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Center(
                            child: Container(
                              height: widthQuery ? 300 : 150,
                              width: widthQuery ? 300 : 150,
                              color: Colors.white,
                              padding: const EdgeInsets.all(16),
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Fpress_logo.png?alt=media&token=39fd8e7f-59a6-406f-89f0-38a4327fb824&_gl=1*o43ii0*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzU2Ni42MC4wLjA.',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      heightBox,
                      const InquirySection(),
                      Container(height: 20, color: Colors.grey.shade50),
                    ],
                  ))
                ],
              );
            });
          });
        });
  }
}
