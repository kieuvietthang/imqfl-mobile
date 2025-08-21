import 'dart:developer';
import '../models/movie.dart';
import 'api_client.dart';

class MovieQueryParams {
  final String? typeList;
  final int? page;
  final String? sortField;
  final String? sortType;
  final String? sortLang;
  final String? category;
  final String? country;
  final int? year;
  final int? limit;

  const MovieQueryParams({
    this.typeList,
    this.page,
    this.sortField,
    this.sortType,
    this.sortLang,
    this.category,
    this.country,
    this.year,
    this.limit,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    
    if (page != null) map['page'] = page;
    if (sortField != null) map['sort_field'] = sortField;
    if (sortType != null) map['sort_type'] = sortType;
    if (sortLang != null) map['sort_lang'] = sortLang;
    if (category != null) map['category'] = category;
    if (country != null) map['country'] = country;
    if (year != null) map['year'] = year;
    if (limit != null) map['limit'] = limit;
    
    return map;
  }
}

class MovieService {
  final ApiClient _apiClient = ApiClient();

  // Lấy danh sách phim
  Future<({List<Movie> movies, int totalPages})> getMovies([MovieQueryParams? params]) async {
    final movieParams = params ?? const MovieQueryParams();
    
    log('[MovieService.getMovies] Bắt đầu gọi API với params: ${movieParams.toMap()}');
    
    try {
      final typeList = movieParams.typeList ?? "phim-bo"; // default
      final queryParams = movieParams.toMap();

      final endpoint = '/public/list/$typeList';
      
      log('[MovieService.getMovies] Endpoint: $endpoint');
      log('[MovieService.getMovies] Params sau khi xử lý: $queryParams');

      final response = await _apiClient.get(endpoint, queryParameters: queryParams);
      
      log('[MovieService.getMovies] Raw response data: ${response.data}');
      
      final data = response.data;
      if (data != null) {
        final movieListResponse = MovieListResponse.fromJson(data);
        
        log('[MovieService.getMovies] Items count: ${movieListResponse.items.length}');
        log('[MovieService.getMovies] Pagination info: ${movieListResponse.pagination.totalPages}');

        final result = (
          movies: movieListResponse.items,
          totalPages: movieListResponse.pagination.totalPages,
        );
        
        log('[MovieService.getMovies] Kết quả trả về: '
            'moviesCount: ${result.movies.length}, totalPages: ${result.totalPages}');

        return result;
      } else {
        log('[MovieService.getMovies] No data in response');
        return (movies: <Movie>[], totalPages: 1);
      }
    } catch (error) {
      log('[MovieService.getMovies] Lỗi khi gọi API danh sách phim: $error');
      
      return (movies: <Movie>[], totalPages: 1);
    }
  }

  // Lấy chi tiết phim
  Future<Movie?> getMovieDetails(String slug) async {
    log('[MovieService.getMovieDetails] Bắt đầu lấy chi tiết phim với slug: $slug');
    
    try {
      final endpoint = '/public/movies/$slug';
      
      log('[MovieService.getMovieDetails] Endpoint: $endpoint');
      log('[MovieService.getMovieDetails] Slug parameter: $slug');

      final response = await _apiClient.get(endpoint);

      log('[MovieService.getMovieDetails] Raw response data: ${response.data}');
      
      final data = response.data;
      if (data != null && data['movie'] != null) {
        final movie = Movie.fromJson(data['movie']);
        
        log('[MovieService.getMovieDetails] Movie title: ${movie.name}');
        log('[MovieService.getMovieDetails] Movie type: ${movie.type}');

        return movie;
      } else {
        log('[MovieService.getMovieDetails] No movie data in response');
        return null;
      }
    } catch (error) {
      log('[MovieService.getMovieDetails] Lỗi khi lấy chi tiết phim:');
      log('[MovieService.getMovieDetails] Slug: $slug');
      log('[MovieService.getMovieDetails] Error: $error');
      
      rethrow;
    }
  }
}
