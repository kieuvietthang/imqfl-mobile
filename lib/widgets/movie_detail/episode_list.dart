import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../utils/theme.dart';

class EpisodeList extends StatefulWidget {
  final Movie movie;
  final Function(String?) onEpisodeSelected;

  const EpisodeList({
    super.key,
    required this.movie,
    required this.onEpisodeSelected,
  });

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  String _selectedLanguage = 'Tiếng Việt';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language buttons
          Row(
            children: [
              _buildLanguageButton('Tiếng Việt', true),
              const SizedBox(width: 8),
              _buildLanguageButton('Tiếng Phổ Thông', false),
            ],
          ),
          const SizedBox(height: 16),
          
          // Episode info
          Text(
            'Trọn bộ ${widget.movie.totalEpisodes} tập',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Thành viên VIP xem toàn tập.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          
          // Episodes grid
          _buildEpisodesGrid(),
          
          const SizedBox(height: 100), // Bottom padding
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
    // Generate demo episodes based on total episodes
    final totalEpisodes = widget.movie.totalEpisodes > 0 ? widget.movie.totalEpisodes : 12;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
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
        // Demo video URL - in real app, this would come from API
        final demoVideoUrl = 'https://example.com/episode_$episodeNumber';
        widget.onEpisodeSelected(demoVideoUrl);
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
