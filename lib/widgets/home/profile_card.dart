// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard();

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }

  Widget buildNameAndBio(String name, String bio, bool widthQuery) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Text(
                name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 27 : 19),
              )),
          const SizedBox(height: 5),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Text(
                bio,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: widthQuery ? 16.5 : 13.75,
                    fontFamily: "Roboto"),
              ))
        ],
      ),
    );
  }

  Widget buildTiktokInstaButtons(
      String instaUrl, String tiktokUrl, bool widthQuery) {
    final buttonStyle = ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
            const EdgeInsets.all(8)),
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all<Color?>(Colors.transparent),
        elevation: MaterialStateProperty.all<double?>(0));
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 45,
          width: 142.5,
          child: TextButton(
              onPressed: () {
                launch(instaUrl);
              },
              style: buttonStyle,
              child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Fbyplestia_IG.png?alt=media&token=b42b7d53-469a-4a93-b62b-5127f78e258f&_gl=1*9e8byf*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzQ0NS41NS4wLjA.')),
        ),
        SizedBox(
          height: 41.25,
          width: 124.5,
          child: TextButton(
              onPressed: () {
                launch(tiktokUrl);
              },
              style: buttonStyle,
              child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Fbyplestia_tiktok.png?alt=media&token=fa6bfbf3-cc94-4683-b114-ee4b2dfbf0a0&_gl=1*wmrs2x*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzUxMi41NC4wLjA.')),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthQuery = MediaQuery.of(context).size.width >= 800;
    final homeProvider = Provider.of<HomeProvider>(context);
    final avatarUrl = homeProvider.avatarUrl;
    final name = homeProvider.name;
    final bio = homeProvider.bio;
    final instaUrl = homeProvider.instagramUrl;
    final tiktokUrl = homeProvider.tiktokUrl;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                    color: Colors.white,
                    width: widthQuery
                        ? 600
                        : MediaQuery.of(context).size.width - 75,
                    height: widthQuery ? 525 : 475,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Stack(children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Column(children: [
                                const SizedBox(height: 10),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: CircleAvatar(
                                        radius: widthQuery ? 90 : 60,
                                        backgroundColor: Colors.grey.shade100,
                                        backgroundImage:
                                            NetworkImage(avatarUrl))),
                                const SizedBox(height: 15),
                                buildNameAndBio(name, bio, widthQuery),
                                const Spacer(),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10, bottom: 0),
                                    child: buildTiktokInstaButtons(
                                        instaUrl, tiktokUrl, widthQuery))
                              ]))
                        ]))))));
  }
}
