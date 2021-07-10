import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/models/palette.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/widgets/genresList.dart';

class DetailsPage extends StatefulWidget {
  final int? id;

  const DetailsPage({Key? key, required this.id}) : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic>? movieDetailsMap;
  List? castList;
  bool? isMovieLoading;
  bool? isCastLoading;

  getMovie() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/${widget.id.toString()}?api_key=${TMDB.apiKey()}&language=en-US");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        movieDetailsMap = json.decode(response.body);
        isMovieLoading = false;
      });
    }
  }

  getCast() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/${widget.id.toString()}/credits?api_key=${TMDB.apiKey()}&language=en-US");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> castMap = json.decode(response.body);
        castList = castMap["cast"];
        isCastLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isMovieLoading = true;
    isCastLoading = true;
    getMovie();
    getCast();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Palette.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Palette.transparent,
        elevation: 0,
      ),
      body: isMovieLoading!
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                          ),
                          child: Image.network(
                            "https://www.themoviedb.org/t/p/w1920_and_h1080_face/${movieDetailsMap!['backdrop_path']}",
                            fit: BoxFit.fitHeight,
                            height: size.height * 0.4,
                            width: size.width,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 250),
                          height: 99,
                          width: 338,
                          decoration: BoxDecoration(
                            color: Palette.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Palette.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star,
                                      color: Palette.yellow, size: 40),
                                  Row(
                                    children: [
                                      Text(
                                        movieDetailsMap!["vote_average"]
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text("/10",
                                          style: TextStyle(
                                            color: Palette.grey,
                                            fontSize: 14,
                                          )),
                                    ],
                                  ),
                                  Text(
                                    movieDetailsMap!["vote_count"].toString(),
                                    style: TextStyle(
                                      color: Palette.lightGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Palette.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Image.network(
                                        "https://www.countryflags.io/${(movieDetailsMap!['production_countries'])[0]['iso_3166_1']}/flat/48.png"),
                                  ),
                                  Text(
                                    "Country",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieDetailsMap!["original_title"],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              //// [release_date] returns a full date. We just only need year
                              //// Which is first 4 value of our [release_date].
                              movieDetailsMap!["release_date"].substring(0, 4),
                              style: TextStyle(
                                color: Palette.lightGrey,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              movieDetailsMap!["original_language"]
                                  .toUpperCase(),
                              style: TextStyle(
                                color: Palette.lightGrey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        GenresList(
                          space: 10,
                          width: size.width,
                          genresList: movieDetailsMap!["genres"],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Plot Summary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          movieDetailsMap!["overview"],
                          style: TextStyle(color: Palette.lightGrey),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Cast",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        isCastLoading!
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                height: 200,
                                width: size.width,
                                child: ListView.builder(
                                  itemCount:
                                      movieDetailsMap!["production_companies"]
                                          .length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: index == 0 ? 0 : 20),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                                "https://www.themoviedb.org/t/p/w138_and_h175_face/${castList![index]['profile_path']}"),
                                          ),
                                          Container(
                                            height: 35,
                                            width: 80,
                                            child: Center(
                                              child: Text(
                                                castList![index]["name"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 80,
                                            width: 80,
                                            child: Text(
                                              castList![index]["character"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Palette.lightGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
