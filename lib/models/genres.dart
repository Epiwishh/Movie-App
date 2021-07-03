import 'package:movie_app/models/categories.dart';

class Genres {
  final String? genreName;

  Genres(
    this.genreName,
  );
}

List<Genres> genres =
    genresData.map((item) => Genres(item['genreName'] as String)).toList();

var genresData = [
  {
    "genreName": "Action",
  },
  {
    "genreName": "Crime",
  },
  {
    "genreName": "Comedy",
  },
  {
    "genreName": "Drama",
  },
  {
    "genreName": "Biograpy",
  },
];
