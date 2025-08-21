import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onClose;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.onClose,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundColor,
      child: Stack(
        children: [
          // Video placeholder (will be replaced with actual video player)
          if (!_isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_filled,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Video Player',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sẽ được tích hợp video player thật',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          
          // Loading indicator
          if (_isLoading)
            Container(
              color: AppTheme.backgroundColor,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryColor),
                    SizedBox(height: 16),
                    Text(
                      'Đang tải video...',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Close button
          if (widget.onClose != null)
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
