import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class CastList extends StatelessWidget {
  final List<String> actors;

  const CastList({
    super.key,
    required this.actors,
  });

  @override
  Widget build(BuildContext context) {
    if (actors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Diễn viên',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            itemBuilder: (context, index) {
              final actor = actors[index];
              return _buildCastItem(actor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastItem(String actorName) {
    // Create initials from actor name
    final words = actorName.split(' ');
    final initials = words.map((word) => word.isNotEmpty ? word[0] : '').join('');

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          // Avatar placeholder
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF666666),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                initials.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Actor name
          Text(
            actorName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          
          // Role
          const Text(
            'Diễn viên',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
