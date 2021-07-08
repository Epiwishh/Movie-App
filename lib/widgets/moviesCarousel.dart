import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/palette.dart';
import 'package:movie_app/pages/detailsPage.dart';

class MoviesCarousel extends StatefulWidget {
  final List? moviesList;

  const MoviesCarousel({Key? key, required this.moviesList}) : super(key: key);

  @override
  _MoviesCarouselState createState() => _MoviesCarouselState();
}

class _MoviesCarouselState extends State<MoviesCarousel> {
  var _current;

  @override
  void initState() {
    _current = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
          height: 600,
          enlargeCenterPage: true,
          viewportFraction: .7,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }),
      itemCount: widget.moviesList!.length,
      itemBuilder: (context, index, pageViewIndex) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      id: widget.moviesList![index]["id"],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 380,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://www.themoviedb.org/t/p/w220_and_h330_face/${widget.moviesList![index]["poster_path"]}"),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  width: 200,
                  child: Center(
                    child: Text(
                      index != _current
                          ? ""
                          : widget.moviesList![index]["title"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Palette.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Palette.yellow,
                    ),
                    Text(widget.moviesList![index]["vote_average"].toString()),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
