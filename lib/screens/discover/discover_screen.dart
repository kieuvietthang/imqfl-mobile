import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../utils/theme.dart';
import '../../models/search_result.dart';
import '../../models/movie.dart';
import '../../models/category.dart';
import '../../services/search_service.dart';
import '../../services/movie_service.dart';
import '../../services/category_service.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final SearchService _searchService = SearchService();
  final MovieService _movieService = MovieService();
  final CategoryService _categoryService = CategoryService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<SearchResult> _searchResults = [];
  List<Movie> _trendingMovies = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isTrendingLoading = false;
  bool _isCategoriesLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMorePages = true;
  String _currentQuery = '';
  Timer? _debounceTimer;
  bool _isSearchMode = false;

  // Category filters
  final List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial content from khoa-hoc category to show in grid
    _loadInitialMovies();
    // Load trending movies from main screen API using khoa-hoc category
    _loadTrendingMovies();
    // Load categories for filter tags
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMorePages) {
        if (_isSearchMode && _searchController.text.trim().isNotEmpty) {
          _loadMoreSearchResults();
        } else if (!_isSearchMode) {
          _loadMoreResults();
        }
      }
    }
  }

  Future<void> _searchMovies(String query) async {
    if (query.trim() == _currentQuery.trim() && _currentPage == 1) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _currentQuery = query.trim();
      _currentPage = 1;
      _searchResults.clear();
    });

    try {
      final response = await _searchService.searchMovies(
        query: query.trim().isEmpty ? 'đấu' : query.trim(),
        page: _currentPage,
        limit: 20, // Increase limit to 20 for better user experience
      );

      if (mounted) {
        setState(() {
          _searchResults = response.items;
          _hasMorePages = _currentPage < response.pagination.totalPages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Không thể tải dữ liệu. Vui lòng thử lại.';
        });
      }
    }
  }

  Future<void> _loadInitialMovies() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _currentQuery = '';
      _currentPage = 1;
      _searchResults.clear();
    });

    try {
      // Load initial movies from khoa-hoc category to show in grid
      final result = await _movieService.getMovies(
        MovieQueryParams(
          typeList: "khoa-hoc", // Use khoa-hoc category for initial content
          page: 1,
          limit: 20, // Load 20 items initially
          sortField: "year",
          sortType: "desc",
        ),
      );

      if (mounted) {
        // Convert Movie objects to SearchResult format for grid display
        final searchResults = result.movies
            .map(
              (movie) => SearchResult(
                id: movie.id,
                name: movie.name,
                slug: movie.slug,
                originName: movie.originalName,
                posterUrl: movie.poster,
                thumbUrl: movie.thumb,
                year: movie.year,
                tmdb: TmdbInfo(
                  type: movie.type,
                  id: movie.id,
                  season: null, // Movies don't have seasons by default
                  voteAverage: 0.0, // Default rating
                  voteCount: 0,
                ),
                imdb: ImdbInfo(id: null),
                modified: ModifiedInfo(time: movie.modified),
              ),
            )
            .toList();

        setState(() {
          _searchResults = searchResults;
          _hasMorePages = _currentPage < result.totalPages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Không thể tải dữ liệu. Vui lòng thử lại.';
        });
      }
    }
  }

  Future<void> _loadMoreResults() async {
    if (_isLoading || !_hasMorePages) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Load more movies from khoa-hoc category instead of search
      final result = await _movieService.getMovies(
        MovieQueryParams(
          typeList: "khoa-hoc",
          page: _currentPage + 1,
          limit: 20,
          sortField: "year",
          sortType: "desc",
        ),
      );

      if (mounted) {
        // Convert Movie objects to SearchResult format for grid display
        final searchResults = result.movies
            .map(
              (movie) => SearchResult(
                id: movie.id,
                name: movie.name,
                slug: movie.slug,
                originName: movie.originalName,
                posterUrl: movie.poster,
                thumbUrl: movie.thumb,
                year: movie.year,
                tmdb: TmdbInfo(
                  type: movie.type,
                  id: movie.id,
                  season: null,
                  voteAverage: 0.0,
                  voteCount: 0,
                ),
                imdb: ImdbInfo(id: null),
                modified: ModifiedInfo(time: movie.modified),
              ),
            )
            .toList();

        setState(() {
          _currentPage++;
          _searchResults.addAll(searchResults);
          _hasMorePages = _currentPage < result.totalPages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreSearchResults() async {
    if (_isLoading || !_hasMorePages || _currentQuery.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _searchService.searchMovies(
        query: _currentQuery,
        page: _currentPage + 1,
        limit: 20,
      );

      if (mounted) {
        setState(() {
          _currentPage++;
          _searchResults.addAll(response.items);
          _hasMorePages = _currentPage < response.pagination.totalPages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadTrendingMovies() async {
    setState(() {
      _isTrendingLoading = true;
    });

    try {
      // Load popular movies from khoa-hoc category as default (science category)
      final result = await _movieService.getMovies(
        MovieQueryParams(
          typeList: "khoa-hoc", // Back to khoa-hoc (science) category
          page: 1,
          limit: 20, // Increase limit to 20 as requested
          sortField: "year",
          sortType: "desc",
        ),
      );

      if (mounted) {
        setState(() {
          _trendingMovies = result.movies;
          _isTrendingLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTrendingLoading = false;
        });
      }
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isCategoriesLoading = true;
    });

    try {
      // Load categories from CategoryService like home screen
      final categories = await _categoryService.getCategories();

      if (mounted) {
        setState(() {
          _categories = categories;
          _isCategoriesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCategoriesLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim() != _currentQuery.trim()) {
        if (query.trim().isNotEmpty) {
          _searchMovies(query);
        } else {
          // Clear search results when query is empty
          setState(() {
            _searchResults.clear();
            _currentQuery = '';
            _hasError = false;
            _errorMessage = '';
          });
        }
      }
    });

    // Rebuild to show/hide search results vs trending
    setState(() {});
  }

  void _toggleCategory(Category category) {
    setState(() {
      if (_selectedCategories.contains(category.slug)) {
        _selectedCategories.remove(category.slug);
      } else {
        _selectedCategories.add(category.slug);
      }
    });
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchMode = false;
                _searchController.clear();
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.textPrimary,
              size: 24,
            ),
            padding: const EdgeInsets.all(8),
          ),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                ),
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Nhập tên phim hoặc từ khóa...',
                  hintStyle: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.textSecondary,
                    size: 22,
                  ),
                ),
                onSubmitted: _searchMovies,
                onChanged: _onSearchChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    if (_searchController.text.isEmpty) {
      return _buildTrendingSearch();
    } else {
      return _buildSearchResults();
    }
  }

  Widget _buildTrendingSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'Tìm kiếm hot',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: _isTrendingLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _trendingMovies.length,
                  itemBuilder: (context, index) {
                    final movie = _trendingMovies[index];
                    return _buildTrendingItemFromMovie(movie, index + 1);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTrendingItemFromMovie(Movie movie, int rank) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie detail instead of searching
        context.push('/movie/${movie.slug}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Rank number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rank <= 3
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  rank.toString(),
                  style: TextStyle(
                    color: rank <= 3
                        ? AppTheme.backgroundColor
                        : AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Movie poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: movie.poster,
                width: 80,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 60,
                  color: AppTheme.cardColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 60,
                  color: AppTheme.cardColor,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppTheme.textTertiary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (movie.originalName.isNotEmpty &&
                      movie.originalName != movie.name)
                    const SizedBox(height: 2),
                  if (movie.originalName.isNotEmpty &&
                      movie.originalName != movie.name)
                    Text(
                      movie.originalName,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Play icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppTheme.textSecondary,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading && _searchResults.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _searchMovies(_searchController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.backgroundColor,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppTheme.textSecondary),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy phim nào',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Thử tìm kiếm với từ khóa khác',
              style: TextStyle(color: AppTheme.textTertiary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildMovieCard(_searchResults[index]);
            }, childCount: _searchResults.length),
          ),
        ),

        if (_isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: _isSearchMode
            ? _buildSearchInterface()
            : _buildDiscoverInterface(),
      ),
    );
  }

  Widget _buildDiscoverInterface() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Header with title and search - simple SliverToBoxAdapter
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Kho phim',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearchMode = true;
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    color: AppTheme.textPrimary,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Category filters
        SliverToBoxAdapter(child: _buildCategoryFilters()),

        // Content area - now directly include slivers instead of SliverFillRemaining
        ..._buildContentSlivers(),
      ],
    );
  }

  Widget _buildSearchInterface() {
    return Column(
      children: [
        // Search header
        _buildSearchHeader(),

        // Search results or trending
        Expanded(child: _buildSearchContent()),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: _isCategoriesLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            )
          : GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategories.contains(category.slug);

                return GestureDetector(
                  onTap: () => _toggleCategory(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.backgroundColor
                              : AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<Widget> _buildContentSlivers() {
    if (_hasError) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _searchMovies(_currentQuery),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (_searchResults.isEmpty && _isLoading) {
      return [
        const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        ),
      ];
    }

    if (_searchResults.isEmpty) {
      return [
        const SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie_outlined,
                  size: 64,
                  color: AppTheme.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  'Không tìm thấy phim nào',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.65, // Same as home screen for uniform sizes
            crossAxisSpacing: 8,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return _buildMovieCard(_searchResults[index]);
          }, childCount: _searchResults.length),
        ),
      ),

      if (_isLoading)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
          ),
        ),
    ];
  }

  Widget _buildMovieCard(SearchResult movie) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie detail screen with slug
        context.push('/movie/${movie.slug}');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Stack(
                  children: [
                    movie.posterUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: movie.posterUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppTheme.surfaceColor,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppTheme.surfaceColor,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: AppTheme.textTertiary,
                                  size: 32,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: AppTheme.surfaceColor,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppTheme.textTertiary,
                                size: 32,
                              ),
                            ),
                          ),

                    // Type badge (TV/Movie)
                    if (movie.tmdb.type != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            movie.tmdb.type == 'tv' ? 'TV' : 'Movie',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                    // Season info for TV shows
                    if (movie.tmdb.type == 'tv' && movie.tmdb.season != null)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'S${movie.tmdb.season}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Movie info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    movie.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Year and rating
                  Row(
                    children: [
                      if (movie.year > 0)
                        Text(
                          movie.year.toString(),
                          style: const TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                      if (movie.year > 0 && movie.tmdb.voteAverage > 0)
                        const Text(
                          ' • ',
                          style: TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                      if (movie.tmdb.voteAverage > 0)
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppTheme.accentColor,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                movie.tmdb.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: AppTheme.textTertiary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
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
