import 'package:flutter/material.dart';
import '../models/movie.dart';

class EpisodeSelectorWidget extends StatelessWidget {
  final List<Episode> episodes;
  final int currentEpisodeIndex;
  final Function(int) onEpisodeSelected;

  const EpisodeSelectorWidget({
    super.key,
    required this.episodes,
    required this.currentEpisodeIndex,
    required this.onEpisodeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Danh sách tập phim',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episode = episodes[index];
                final isSelected = index == currentEpisodeIndex;
                
                return GestureDetector(
                  onTap: () => onEpisodeSelected(index),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFFF6B35), width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? Icons.play_arrow : Icons.movie,
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tập ${index + 1}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (episode.name.isNotEmpty && episode.name != 'Tập ${index + 1}')
                          Text(
                            episode.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white70 : Colors.white54,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget để hiển thị thông tin episode hiện tại
class CurrentEpisodeInfoWidget extends StatelessWidget {
  final Episode? currentEpisode;
  final int episodeIndex;
  final int totalEpisodes;

  const CurrentEpisodeInfoWidget({
    super.key,
    this.currentEpisode,
    required this.episodeIndex,
    required this.totalEpisodes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${episodeIndex + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentEpisode?.name ?? 'Tập ${episodeIndex + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$totalEpisodes tập',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (currentEpisode?.linkM3u8.isNotEmpty == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00DC5A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'HD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
