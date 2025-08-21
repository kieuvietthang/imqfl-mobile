import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';
import '../models/movie.dart';
import '../services/category_service.dart';
import '../services/movie_service.dart';

class HomeProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final MovieService _movieService = MovieService();

  // Categories
  List<Category> _categories = [];
  bool _categoriesLoading = false;
  String? _categoriesError;

  // Movies
  List<Movie> _movies = [];
  bool _moviesLoading = false;
  String? _moviesError;
  int _currentPage = 1;
  int _totalPages = 1;
  String _activeCategory = '';

  // Getters
  List<Category> get categories => _categories;
  bool get categoriesLoading => _categoriesLoading;
  String? get categoriesError => _categoriesError;

  List<Movie> get movies => _movies;
  bool get moviesLoading => _moviesLoading;
  String? get moviesError => _moviesError;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  String get activeCategory => _activeCategory;
  bool get hasMore => _currentPage < _totalPages;

  Future<void> loadCategories() async {
    try {
      _categoriesLoading = true;
      _categoriesError = null;
      notifyListeners();

      _categories = await _categoryService.getCategories();
      
      // Set category đầu tiên làm active
      if (_categories.isNotEmpty && _activeCategory.isEmpty) {
        _activeCategory = _categories[0].slug;
        await loadMoviesByCategory(_activeCategory, 1);
      }
    } catch (e) {
      _categoriesError = 'Error loading categories: $e';
    } finally {
      _categoriesLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoviesByCategory(String categorySlug, int page, {bool append = false}) async {
    if (_moviesLoading) return;
    
    try {
      _moviesLoading = true;
      if (!append) {
        _moviesError = null;
      }
      notifyListeners();

      debugPrint("Loading movies for category: $categorySlug, page: $page");
      
      final result = await _movieService.getMovies(
        MovieQueryParams(
          typeList: categorySlug,
          page: page,
          limit: 20,
          sortField: "year",
          sortType: "desc",
        ),
      );

      if (append) {
        _movies.addAll(result.movies);
      } else {
        _movies = result.movies;
      }
      
      _totalPages = result.totalPages;
      _currentPage = page;
      _activeCategory = categorySlug;
    } catch (e) {
      _moviesError = 'Error loading movies: $e';
      debugPrint("Error loading movies: $e");
    } finally {
      _moviesLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCategory(String categorySlug) async {
    if (_activeCategory == categorySlug) return;
    
    _currentPage = 1;
    await loadMoviesByCategory(categorySlug, 1, append: false);
  }

  Future<void> loadMoreMovies() async {
    if (_currentPage < _totalPages && !_moviesLoading) {
      await loadMoviesByCategory(_activeCategory, _currentPage + 1, append: true);
    }
  }

  void clearErrors() {
    _categoriesError = null;
    _moviesError = null;
    notifyListeners();
  }
}
