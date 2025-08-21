import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/banner.dart';
import '../../providers/banner_carousel_provider.dart';
import '../../utils/theme.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel>
    with TickerProviderStateMixin {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();

    // Fetch banners when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerCarouselProvider>().fetchBanners();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerCarouselProvider>(
      builder: (context, provider, child) {
        final banners = provider.banners;

        if (provider.isLoading) {
          return const SizedBox(
            height: 500,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (banners.isEmpty) {
          return const SizedBox(
            height: 500,
            child: Center(child: Text('Không có dữ liệu banner')),
          );
        }

        return Stack(
          clipBehavior: Clip.none, // Allow overflow beyond bounds
          children: [
            // Background image extending beyond widget bounds
            Positioned(
              top: -300, // Extend much further up to cover status bar
              left: 0,
              right: 0,
              height: 800, // Much larger height to cover extended area
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: CachedNetworkImage(
                      height: 600,
                      key: ValueKey(banners[_currentIndex].bgImage),
                      imageUrl: banners[_currentIndex].bgImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: AppTheme.backgroundColor),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.backgroundColor,
                        child: const Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Gradient overlay extending beyond bounds
            Positioned(
              top: -300, // Match background extension
              left: 0,
              right: 0,
              height: 800, // Match background height
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(
                        0.02,
                      ), // Very minimal overlay at status bar
                      Colors.black.withOpacity(0.05), // Light at header area
                      Colors.transparent, // Clear in middle
                      Colors.black.withOpacity(0.3), // Medium at content area
                      Colors.black.withOpacity(0.6), // Darker at bottom
                      AppTheme.backgroundColor, // Full dark at very bottom
                    ],
                    stops: const [0.0, 0.15, 0.35, 0.6, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // Main content area
            SizedBox(
              height:
                  500, // Increased height to allow more space for background to show
              child: Stack(
                children: [
                  // Content carousel
                  CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: banners.length,
                    itemBuilder: (context, index, realIndex) {
                      final banner = banners[index];

                      return AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to movie detail using slug
                                context.go('/movie/${banner.movie.slug}');
                              },
                              child: _buildBannerContent(banner),
                            ),
                          );
                        },
                      );
                    },
                    options: CarouselOptions(
                      height: 500, // Match the SizedBox height
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),

                  // Play button - moved up to be within content area
                  Positioned(
                    bottom: 90, // Moved higher to stay in content area
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to movie detail when play button is tapped
                        context.go(
                          '/movie/${banners[_currentIndex].movie.slug}',
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // Page indicators - moved up accordingly
                  Positioned(
                    bottom: 70, // Moved higher to accommodate play button
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: _currentIndex,
                        count: banners.length,
                        effect: const ExpandingDotsEffect(
                          dotWidth: 16,
                          dotHeight: 8,
                          spacing: 8,
                          activeDotColor: Colors.white,
                          dotColor: Colors.white38,
                        ),
                        onDotClicked: (index) {
                          _carouselController.animateToPage(index);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBannerContent(BannerItem banner) {
    return Stack(
      children: [
        // Foreground image
        Positioned(
          bottom: 20,
          left: 50,
          right: 0,
          child: Container(
            height: 400,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              height: 700,
              imageUrl: banner.fgImage,
              // fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.9,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Container(),
            ),
          ),
        ),

        // Text content
        Positioned(
          bottom: 80,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                banner.subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),

              // Tags
              Row(
                children: [
                  if (banner.isFree)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Miễn phí',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (banner.isFree) const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Dolby Audio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
