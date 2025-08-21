import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../utils/theme.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  const MovieGrid({
    super.key,
    required this.movies,
    this.isLoading = false,
    this.onLoadMore,
    this.hasMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'DANH SÁCH PHIM',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        if (movies.isEmpty && !isLoading)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                'Không có phim nào',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              // color: Colors.red,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(
                    movie: movie,
                    // Navigation will be handled inside MovieCard
                  );
                },
              ),
            ),
          ),
        
        // Loading indicator
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Đang tải...',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        // Load more button
        if (!isLoading && hasMore)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ElevatedButton(
                onPressed: onLoadMore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Xem thêm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        
        // End message
        if (!isLoading && !hasMore && movies.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Đã hiển thị tất cả phim',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        
        const SizedBox(height: 100), // Bottom padding for tab bar
      ],
    );
  }
}
