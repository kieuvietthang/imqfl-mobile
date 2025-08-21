import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_detail/movie_detail_bottom_sheet.dart';

class MovieDetailUtils {
  static void showMovieDetail(BuildContext context, Movie movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => MovieDetailBottomSheet(
        movie: movie,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
  
  static void showMovieDetailFullScreen(BuildContext context, Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: MovieDetailBottomSheet(
            movie: movie,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
