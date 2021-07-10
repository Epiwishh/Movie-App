import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/models/palette.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/pages/detailsPage.dart';
import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/widgets/genresList.dart';

class MoviesList extends StatefulWidget {
  final int? genreId;

  const MoviesList({Key? key, required this.genreId}) : super(key: key);

  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  List? moviesList;
  List? genresList;
  bool? isLoading;

  getMoviesByGenre() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key=dc2b4aa376d692ba687297d6dc09f1af&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=${widget.genreId}&with_watch_monetization_types=flatrate");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> moviesMap = json.decode(response.body);
        moviesList = moviesMap["results"];
        isLoading = false;
      });
    }
  }

  getGenres() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/genre/movie/list?api_key=${TMDB.apiKey()}&language=en-US");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> genreMap = json.decode(response.body);
        genresList = genreMap["genres"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getMoviesByGenre();
    getGenres();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffE2E0EE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.transparent,
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: moviesList!.length,
              itemBuilder: (context, index) {
                final genreIds = moviesList![index]["genre_ids"];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          id: moviesList![index]["id"],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    width: size.width,
                    height: 150,
                    child: Row(
                      children: [
                        Container(
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://www.themoviedb.org/t/p/w220_and_h330_face/${moviesList![index]["poster_path"]}"),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Palette.white,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 190,
                                                minWidth: 10,
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                    text: moviesList![index]
                                                        ["title"],
                                                    style: TextStyle(
                                                      color: Palette.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              //// [release_date] returns a full date. We just only need year
                                              //// which is first 4 value of our [release_date].
                                              moviesList![index]["release_date"]
                                                  .substring(0, 4),
                                              style: TextStyle(
                                                color: Palette.lightGrey,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          moviesList![index]["vote_average"]
                                              .toString(),
                                          style: TextStyle(
                                            color: Palette.yellow,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: size.width,
                                      height: 90,
                                      child: RichText(
                                        maxLines: 5,
                                        text: TextSpan(
                                            text: moviesList![index]
                                                ["overview"],
                                            style: TextStyle(
                                              color: Palette.black,
                                            )),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    Container(
                                      width: size.width,
                                      height: 20,
                                      child: ListView.builder(
                                        itemCount: genreIds.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          //// [moviesList] returns only genre Ids.
                                          //// So we need to match this ids with [genresList] and print 'genreName'
                                          var x = genresList!
                                              .where((value) =>
                                                  genreIds[index] ==
                                                  value['id'])
                                              .toList();
                                          return Container(
                                            margin: EdgeInsets.only(
                                                left: index == 0 ? 0 : 5),
                                            child: Text(x[0]["name"].toString(),
                                                style: TextStyle(
                                                  color: genreIds[index] ==
                                                          widget.genreId
                                                      ? Palette.green
                                                      : Palette.lightGrey,
                                                )),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
