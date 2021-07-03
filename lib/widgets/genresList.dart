import 'package:flutter/material.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/palette.dart';

class GenresList extends StatelessWidget {
  final List genresList;
  final double width;

  const GenresList({Key? key, required this.width, required this.genresList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      child: ListView.builder(
        itemCount: genresList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            child: Container(
              margin: EdgeInsets.only(left: index == 0 ? 18 : 24),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Palette.lightGrey.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: Text(
                  genresList[index]["name"],
                  style: TextStyle(
                    color: Palette.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
