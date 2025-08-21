import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/home_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/home/banner_carousel.dart';
import '../../widgets/home/movie_grid.dart';
import '../../widgets/home/promo_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadCategories();
    });

    // Listen to scroll for header animation
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Flexible header space for animated header
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
              
              // Banner carousel
              const SliverToBoxAdapter(
                child: BannerCarousel(),
              ),
              
              // Promo box
              const SliverToBoxAdapter(
                child: PromoBox(),
              ),
              
              // Movies section
              Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  return SliverToBoxAdapter(
                    child: MovieGrid(
                      movies: homeProvider.movies,
                      isLoading: homeProvider.moviesLoading,
                      hasMore: homeProvider.hasMore,
                      onLoadMore: homeProvider.loadMoreMovies,
                    ),
                  );
                },
              ),
            ],
          ),
          
          // Animated header
          ValueListenableBuilder<double>(
            valueListenable: _scrollOffset,
            builder: (context, scrollOffset, child) {
              final opacity = (scrollOffset / 100).clamp(0.0, 1.0);
              final backgroundColor = Color.lerp(
                Colors.transparent,
                AppTheme.backgroundColor,
                opacity,
              );
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 12,
                  right: 12,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: Color.lerp(
                        Colors.transparent,
                        const Color(0xFF333333),
                        opacity,
                      )!,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header content
                    Row(
                      children: [
                        // Logo
                        const Text(
                          'YiXiu',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Search bar
                        Expanded(
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 12),
                                Icon(
                                  LucideIcons.search,
                                  size: 16,
                                  color: AppTheme.textSecondary,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'My Stubborn...',
                                      hintStyle: TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // VIP button
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'VIP',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    // Category tabs
                    Consumer<HomeProvider>(
                      builder: (context, homeProvider, child) {
                        if (homeProvider.categories.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        
                        return SizedBox(
                          height: 32,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeProvider.categories.length,
                            itemBuilder: (context, index) {
                              final category = homeProvider.categories[index];
                              final isActive = category.slug == homeProvider.activeCategory;
                              
                              return GestureDetector(
                                onTap: () {
                                  homeProvider.selectCategory(category.slug);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: isActive 
                                        ? AppTheme.primaryColor.withOpacity(0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    border: isActive
                                        ? Border.all(
                                            color: AppTheme.primaryColor,
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    category.name,
                                    style: TextStyle(
                                      color: isActive
                                          ? AppTheme.primaryColor
                                          : AppTheme.textSecondary,
                                      fontSize: 14,
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
