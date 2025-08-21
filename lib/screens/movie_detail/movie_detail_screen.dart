import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:iqiyi_fl/utils/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/movie.dart';
import '../../services/movie_service.dart';
import '../../widgets/video_player_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieSlug;

  const MovieDetailScreen({super.key, required this.movieSlug});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with TickerProviderStateMixin {
  final MovieService _movieService = MovieService();

  Movie? _movie;
  bool _isLoading = true;
  String? _errorMessage;
  String _activeTab = 'Lịch cập nhật';
  String? _videoUrl;
  bool _showFullDescription = false;
  String _selectedLanguage = 'Tiếng Việt';
  int _currentEpisodeIndex = 0;

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchMovieDetails();
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchMovieDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final movie = await _movieService.getMovieDetails(widget.movieSlug);

      if (movie != null) {
        setState(() {
          _movie = _addDemoEpisodesIfNeeded(movie);
          // Tự động set video URL cho tập đầu tiên
          if (_movie!.episodes.isNotEmpty) {
            final firstEpisode = _movie!.episodes[0];
            if (firstEpisode.linkM3u8.isNotEmpty) {
              _videoUrl = firstEpisode.linkM3u8;
            }
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Không tìm thấy thông tin phim';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Lỗi khi tải thông tin phim: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Movie _addDemoEpisodesIfNeeded(Movie movie) {
    // Nếu movie đã có episodes thì không cần thêm demo, chỉ trả về movie gốc
    if (movie.episodes.isNotEmpty) {
      return movie;
    }

    // Tạo demo episodes với URL mẫu (chỉ khi không có episodes thật)
    final demoEpisodes = <Episode>[];
    final totalEpisodes = movie.totalEpisodes > 0 ? movie.totalEpisodes : 12;

    for (int i = 0; i < totalEpisodes; i++) {
      demoEpisodes.add(
        Episode(
          name: 'Tập ${i + 1}',
          slug: 'tap-${i + 1}',
          filename: 'episode_${i + 1}.m3u8',
          linkEmbed: '',
          linkM3u8: 'https://s6.kkphimplayer6.com/20250702/qJjgbWm2/index.m3u8',
        ),
      );
    }

    // Tạo movie mới với demo episodes
    return Movie(
      id: movie.id,
      name: movie.name,
      slug: movie.slug,
      originalName: movie.originalName,
      poster: movie.poster,
      thumb: movie.thumb,
      description: movie.description,
      year: movie.year,
      status: movie.status,
      type: movie.type,
      quality: movie.quality,
      lang: movie.lang,
      totalEpisodes: movie.totalEpisodes,
      currentEpisode: movie.currentEpisode,
      categories: movie.categories,
      countries: movie.countries,
      actors: movie.actors,
      directors: movie.directors,
      created: movie.created,
      modified: movie.modified,
      episodes: demoEpisodes,
    );
  }

  void _playEpisode(int episodeIndex) {
    if (_movie?.episodes.isEmpty == true) return;

    setState(() {
      _currentEpisodeIndex = episodeIndex;

      // Nếu có episode data thật, set video URL
      if (episodeIndex < _movie!.episodes.length) {
        final episode = _movie!.episodes[episodeIndex];
        if (episode.linkM3u8.isNotEmpty) {
          _videoUrl = episode.linkM3u8;
        } else {
          // Fallback nếu không có linkM3u8
          _videoUrl =
              'https://s6.kkphimplayer6.com/20250702/qJjgbWm2/index.m3u8';
        }
      } else {
        // Fallback nếu index không hợp lệ
        _videoUrl = 'https://s6.kkphimplayer6.com/20250702/qJjgbWm2/index.m3u8';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.primaryColor),
              SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null || _movie == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Không tìm thấy phim',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF181820),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video/Thumbnail Header
            _buildVideoHeader(),

            // Movie Details
            _buildMovieDetails(),

            // Action Buttons
            _buildActionButtons(),

            // Tabs
            _buildTabsSection(),

            // Tab Content
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoHeader() {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          if (_videoUrl != null)
            _buildVideoPlayer()
          else
            _buildThumbnailSection(),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.chevronLeft,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    // Lấy video URL từ episode hiện tại
    String currentVideoUrl =
        'https://s6.kkphimplayer6.com/20250702/qJjgbWm2/index.m3u8'; // fallback URL

    if (_movie?.episodes.isNotEmpty == true &&
        _currentEpisodeIndex < _movie!.episodes.length) {
      final currentEpisode = _movie!.episodes[_currentEpisodeIndex];
      if (currentEpisode.linkM3u8.isNotEmpty) {
        currentVideoUrl = currentEpisode.linkM3u8;
      }
    }

    // Nếu có _videoUrl được set thì ưu tiên sử dụng
    if (_videoUrl != null && _videoUrl!.isNotEmpty) {
      currentVideoUrl = _videoUrl!;
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF121318),
      child: VideoPlayerWidget(
        videoUrl: currentVideoUrl,
        aspectRatio: 16 / 9,
        autoPlay: true,
        showControls: true,
      ),
    );
  }

  Widget _buildThumbnailSection() {
    return Stack(
      children: [
        // Movie thumbnail
        CachedNetworkImage(
          imageUrl: _movie!.thumb,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => Container(
            color: const Color(0xFF2A2A2A),
            child: const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFF2A2A2A),
            child: const Center(
              child: Icon(Icons.movie, color: Colors.white54, size: 48),
            ),
          ),
        ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              stops: const [0.5, 1.0],
            ),
          ),
        ),

        // Play button
        Center(
          child: GestureDetector(
            onTap: () => _playEpisode(0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            '[${_movie!.lang}] ${_movie!.name}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Rating and metadata
          Row(
            children: [
              const Icon(Icons.star, color: AppTheme.primaryColor, size: 16),
              const SizedBox(width: 4),
              const Text(
                '9.8',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _movie!.year.toString(),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 16),
              _buildMetaTag('T13'),
              const SizedBox(width: 8),
              _buildMetaTag('Phụ đề'),
              const SizedBox(width: 8),
              if (_movie!.countries.isNotEmpty)
                _buildMetaTag(_movie!.countries[0]),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            _movie!.description,
            maxLines: _showFullDescription ? null : 2,
            overflow: _showFullDescription ? null : TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _showFullDescription = !_showFullDescription;
              });
            },
            child: Text(
              _showFullDescription ? 'Thu gọn' : 'Xem thêm',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cast list
          if (_movie!.categories.isNotEmpty) _buildCastSection(),
        ],
      ),
    );
  }

  Widget _buildMetaTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _buildCastSection() {
    // Sử dụng actor data từ API, nếu không có thì dùng demo
    List<String> actors = _movie!.actors.isNotEmpty
        ? _movie!.actors
        : [
            'Melanie Scrofano',
            'Romy Weltman',
            'David James Elliott',
            'Andy McQueen',
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Diễn viên',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            itemBuilder: (context, index) {
              final actor = actors[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFF666666),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          actor
                              .split(' ')
                              .map((n) => n.isNotEmpty ? n[0] : '')
                              .join(''),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        actor,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Text(
                      'Diễn viên',
                      style: TextStyle(color: Colors.white54, fontSize: 9),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF333333), width: 1),
          bottom: BorderSide(color: Color(0xFF333333), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(LucideIcons.download, 'Tải xuống'),
          _buildActionButton(LucideIcons.plus, 'Thêm vào'),
          _buildActionButton(LucideIcons.share2, 'Chia sẻ'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildTabsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabButton('Lịch cập nhật'),
          _buildTabButton('Đề xuất cho bạn'),
          _buildTabButton('Bình luận'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title) {
    final isActive = _activeTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(
                  bottom: BorderSide(color: AppTheme.primaryColor, width: 2),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? AppTheme.primaryColor : Colors.white54,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'Lịch cập nhật':
        return _buildEpisodeSection();
      case 'Đề xuất cho bạn':
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Đề xuất cho bạn',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        );
      case 'Bình luận':
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Bình luận',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEpisodeSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language selection
          Row(
            children: [
              _buildLanguageButton(
                'Tiếng Việt',
                _selectedLanguage == 'Tiếng Việt',
              ),
              const SizedBox(width: 8),
              _buildLanguageButton(
                'Tiếng Phổ Thông',
                _selectedLanguage == 'Tiếng Phổ Thông',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Episode info
          Text(
            _movie!.episodes.isNotEmpty
                ? 'Có sẵn ${_movie!.episodes.length} tập'
                : 'Trọn bộ ${_movie!.totalEpisodes} tập',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            'Thành viên VIP xem toàn tập.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Episodes grid
          _buildEpisodesGrid(),

          const SizedBox(height: 50), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor : const Color(0xFF333333),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodesGrid() {
    // Sử dụng số episodes thật từ API, nếu không có thì dùng totalEpisodes
    int totalEpisodes = _movie!.episodes.isNotEmpty
        ? _movie!.episodes.length
        : (_movie!.totalEpisodes > 0 ? _movie!.totalEpisodes : 12);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: totalEpisodes,
      itemBuilder: (context, index) {
        final episodeNumber = index + 1;
        return _buildEpisodeButton(episodeNumber);
      },
    );
  }

  Widget _buildEpisodeButton(int episodeNumber) {
    final isCurrentEpisode = (_currentEpisodeIndex + 1) == episodeNumber;

    return GestureDetector(
      onTap: () {
        _playEpisode(episodeNumber - 1);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentEpisode
              ? const Color(0xFFFF6B35)
              : const Color(0xFF333333),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            episodeNumber.toString(),
            style: TextStyle(
              color: isCurrentEpisode ? Colors.white : Colors.white70,
              fontSize: 14,
              fontWeight: isCurrentEpisode ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
