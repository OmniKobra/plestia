// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../providers/home_provider.dart';

class CarouselDescription extends StatefulWidget {
  const CarouselDescription();

  @override
  State<CarouselDescription> createState() => _CarouselDescriptionState();
}

class _CarouselDescriptionState extends State<CarouselDescription> {
  Widget buildDescription(String description, bool widthQuery) => Center(
        child: Container(
            padding:
                widthQuery ? const EdgeInsets.all(16) : const EdgeInsets.all(8),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '“',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: widthQuery ? 50 : 38)),
              WidgetSpan(
                  child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(description,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: widthQuery ? 20 : 15)),
              )),
              WidgetSpan(
                  child: Row(
                children: [
                  const Spacer(),
                  Text('”',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: widthQuery ? 50 : 38)),
                ],
              )),
            ]))),
      );

  Widget buildImage(String url, mediaQuery) => Container(
      height: mediaQuery ? 350 : 200,
      color: Colors.grey.shade50,
      child: ExtendedImage.network(url,
          fit: BoxFit.contain, printError: false, enableLoadState: false));

  Widget buildCarousel(List<String> mediaUrls, bool mediaQuery) =>
      CarouselSlider(
          options: CarouselOptions(
              initialPage: 0,
              viewportFraction: .50,
              enlargeFactor: 0.45,
              pauseAutoPlayOnManualNavigate: true,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              autoPlay: true,
              padEnds: true,
              disableCenter: true,
              autoPlayInterval: const Duration(milliseconds: 2350),
              enableInfiniteScroll: true),
          items: [
            ...mediaUrls.map((url) => buildImage(url, mediaQuery)).toList()
          ]);

  @override
  Widget build(BuildContext context) {
    final widthQuery = MediaQuery.of(context).size.width >= 800;
    final homeProvider = Provider.of<HomeProvider>(context);
    final mediaUrls = homeProvider.carouselMediaUrls;
    final description = homeProvider.aboutDescription;
    return Container(
      padding: widthQuery
          ? const EdgeInsets.all(8)
          : const EdgeInsets.only(top: 0, bottom: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.grey.shade50),
      child: widthQuery
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buildCarousel(mediaUrls, widthQuery)),
                Expanded(child: buildDescription(description, widthQuery))
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                  ),
                  child: buildCarousel(mediaUrls, widthQuery),
                ),
                Container(height: 5, color: Colors.grey.shade50),
                buildDescription(description, widthQuery)
              ],
            ),
    );
  }
}
