import 'dart:convert';
import 'dart:developer';

import 'package:digital_three/models/movie_model_new.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// final movieProvider = FutureProvider.autoDispose<MovieModel>((ref) async {
//   String endpoint = 'https://api.themoviedb.org/3/trending/all/week';
//   final response = await http.get(Uri.parse(endpoint), headers: {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization':
//         'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZjNkYzVmOWFiNmFiOWFmZDNiYjA0OTg0MzgyMWU2OCIsInN1YiI6IjY0OTA2OWU2MmY4ZDA5MDBjNjY2ZjU5ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BUjkeUONqCyUvaDTfR7WA_KvEO-wVMjSat5aqSweq5o',
//   });
//   if (response.statusCode == 200) {
//     final jsonData = json.decode(response.body);
//     return MovieModel.fromJson(jsonData);
//   } else {
//     throw Exception('Failed to load movie data');
//   }
// });

final movieProvider1 = FutureProvider.autoDispose<MovieModelNew>((ref) async {
  final response = await http.post(
    Uri.parse("https://hoblist.com/api/movieList"),
    body: {
      "category": "movies",
      "language": "kannada",
      "genre": "all",
      "sort": "voting",
    },
  );
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    log(response.body.toString());
    return MovieModelNew.fromJson(jsonData);
  } else {
    throw Exception('Failed to load movie data');
  }
});
