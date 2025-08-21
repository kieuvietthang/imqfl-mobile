import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class ShortsScreen extends StatelessWidget {
  const ShortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phim ngắn'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Shorts Screen',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tính năng sẽ được phát triển sớm',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
