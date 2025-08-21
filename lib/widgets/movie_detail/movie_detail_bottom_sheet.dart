import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/movie.dart';

class MovieDetailBottomSheet extends StatefulWidget {
  final Movie movie;
  final VoidCallback? onClose;

  const MovieDetailBottomSheet({
    super.key,
    required this.movie,
    this.onClose,
  });

  @override
  State<MovieDetailBottomSheet> createState() => _MovieDetailBottomSheetState();
}

class _MovieDetailBottomSheetState extends State<MovieDetailBottomSheet>
    with TickerProviderStateMixin {
  String _activeTab = 'Lịch cập nhật';
  String? _videoUrl;
  bool _showFullDescription = false;
  String _selectedLanguage = 'Tiếng Việt';

  @override
  void initState() {
    super.initState();
    // Set status bar for immersive video experience
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _playVideo(String? url) {
    if (url != null && url.isNotEmpty) {
      setState(() {
        _videoUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xFF181820),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: SingleChildScrollView(
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
          // Video player or thumbnail
          if (_videoUrl != null)
            _buildVideoPlayer()
          else
            _buildThumbnailSection(),
          
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: widget.onClose ?? () => Navigator.of(context).pop(),
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF121318),
      child: Stack(
        children: [
          // Video placeholder with realistic UI
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Video đang phát...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Video controls overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Progress bar
                  Row(
                    children: [
                      const Text(
                        '05:24',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF00DC5A),
                            inactiveTrackColor: Colors.white24,
                            thumbColor: const Color(0xFF00DC5A),
                            overlayColor: const Color(0xFF00DC5A).withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            trackHeight: 3,
                          ),
                          child: Slider(
                            value: 0.3,
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '45:30',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.skip_previous, color: Colors.white, size: 24),
                          const SizedBox(width: 16),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00DC5A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.pause, color: Colors.black, size: 24),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.skip_next, color: Colors.white, size: 24),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.volume_up, color: Colors.white, size: 20),
                          const SizedBox(width: 16),
                          const Icon(Icons.settings, color: Colors.white, size: 20),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => setState(() => _videoUrl = null),
                            child: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailSection() {
    return Stack(
      children: [
        // Movie thumbnail
        CachedNetworkImage(
          imageUrl: widget.movie.thumb,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => Container(
            color: const Color(0xFF2A2A2A),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF00DC5A)),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFF2A2A2A),
            child: const Center(
              child: Icon(
                Icons.movie,
                color: Colors.white54,
                size: 48,
              ),
            ),
          ),
        ),
        
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        
        // Play button
        Center(
          child: GestureDetector(
            onTap: () => _playVideo('demo_video_url'),
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
            '[${widget.movie.lang}] ${widget.movie.name}',
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
              const Icon(Icons.star, color: Color(0xFF00DC5A), size: 16),
              const SizedBox(width: 4),
              const Text(
                '9.8',
                style: TextStyle(
                  color: Color(0xFF00DC5A),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                widget.movie.year.toString(),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 16),
              _buildMetaTag('T13'),
              const SizedBox(width: 8),
              _buildMetaTag('Phụ đề'),
              const SizedBox(width: 8),
              if (widget.movie.countries.isNotEmpty)
                _buildMetaTag(widget.movie.countries[0]),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            widget.movie.description,
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
                color: Color(0xFF00DC5A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cast list
          if (widget.movie.categories.isNotEmpty)
            _buildCastSection(),
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
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildCastSection() {
    // Demo cast data
    final demoActors = ['Trương Hàm Vận', 'Lưu Vũ Ninh', 'Đường Hiểu Thiên', 'Lý Nhật Lân'];
    
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
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: demoActors.length,
            itemBuilder: (context, index) {
              final actor = demoActors[index];
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
                          actor.split(' ').map((n) => n[0]).join(''),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      actor,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Diễn viên',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
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
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
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
                  bottom: BorderSide(
                    color: Color(0xFF00DC5A),
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF00DC5A) : Colors.white54,
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        );
      case 'Bình luận':
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Bình luận',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
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
              _buildLanguageButton('Tiếng Việt', _selectedLanguage == 'Tiếng Việt'),
              const SizedBox(width: 8),
              _buildLanguageButton('Tiếng Phổ Thông', _selectedLanguage == 'Tiếng Phổ Thông'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Episode info
          Text(
            'Trọn bộ ${widget.movie.totalEpisodes} tập',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Thành viên VIP xem toàn tập.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
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
          color: isActive ? const Color(0xFF00DC5A) : const Color(0xFF333333),
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
    final totalEpisodes = widget.movie.totalEpisodes > 0 ? widget.movie.totalEpisodes : 12;
    
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
    return GestureDetector(
      onTap: () {
        _playVideo('demo_episode_$episodeNumber');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            episodeNumber.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
