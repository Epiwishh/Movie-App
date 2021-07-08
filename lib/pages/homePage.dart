import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/models/categories.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/palette.dart';
import 'package:movie_app/services/tmdbAPI.dart';
import 'package:movie_app/widgets/genresList.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/widgets/moviesCarousel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? categoryIndex;
  List? genreList;
  List? moviesInTheaterList;
  bool? isGenresLoading;
  bool? isMoviesLoading;

  getGenres() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/genre/movie/list?api_key=${TMDB.apiKey()}&language=en-US");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> genreMap = json.decode(response.body);
        genreList = genreMap["genres"];
        isGenresLoading = false;
      });
    }
  }

  getMoviesInTheater() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/now_playing?api_key=${TMDB.apiKey()}&language=en-US");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> moviesInTheaterMap = json.decode(response.body);
      moviesInTheaterList = moviesInTheaterMap["results"];
      isMoviesLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    isGenresLoading = true;
    isMoviesLoading = true;
    getGenres();
    getMoviesInTheater();
    categoryIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    //// This 'size' variable getting size of device
    //// For getting width of device you can call [size.width]
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Palette.white,
      drawer: NavDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Palette.black),
        backgroundColor: Palette.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: 70,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        categoryIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: index == 0 ? 18 : 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categories[index].categorName!,
                            style: TextStyle(
                              color: index == categoryIndex
                                  ? Palette.black
                                  : Palette.lightGrey,
                              fontSize: 28,
                            ),
                          ),
                          index == categoryIndex
                              ? Container(
                                  margin: EdgeInsets.only(top: 15),
                                  width: 40,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Palette.pink,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                )
                              : Center(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            isGenresLoading!
                ? CircularProgressIndicator()
                : GenresList(
                    space: 20,
                    width: size.width,
                    genresList: genreList!,
                  ),
            SizedBox(height: 50), //// It's just for some space
            isMoviesLoading!
                ? Center()
                : MoviesCarousel(
                    moviesList: moviesInTheaterList,
                  ),
          ],
        ),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}
