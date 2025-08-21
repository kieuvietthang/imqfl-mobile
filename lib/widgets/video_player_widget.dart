import 'package:flutter/material.dart';
import 'package:iqiyi_fl/utils/theme.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final double aspectRatio;
  final bool autoPlay;
  final bool looping;
  final bool showControls;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu URL thay đổi thì khởi tạo lại video player
    if (oldWidget.videoUrl != widget.videoUrl) {
      _reinitializeVideoPlayer();
    }
  }

  Future<void> _reinitializeVideoPlayer() async {
    // Dispose old controllers
    _videoPlayerController.dispose();
    _chewieController?.dispose();

    // Reset state
    setState(() {
      _isInitialized = false;
      _hasError = false;
      _errorMessage = null;
    });

    // Initialize with new URL
    await _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      // Initialize video player controller với M3U8 URL
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _videoPlayerController.initialize();

      // Initialize Chewie controller
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        showControls: widget.showControls,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppTheme.primaryColor,
          handleColor: AppTheme.primaryColor,
          backgroundColor: Colors.grey.shade800,
          bufferedColor: Colors.grey.shade600,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.primaryColor,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không thể phát video',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppTheme.primaryColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Lỗi khi tải video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage ?? 'Có lỗi xảy ra',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _errorMessage = null;
                  });
                  _initializeVideoPlayer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _chewieController == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }

    return Chewie(controller: _chewieController!);
  }
}

// Widget đơn giản hơn cho preview video
class VideoPreviewWidget extends StatelessWidget {
  final String videoUrl;
  final double aspectRatio;
  final Widget? overlay;
  final VoidCallback? onTap;

  const VideoPreviewWidget({
    super.key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.overlay,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 64,
                    color: Colors.white54,
                  ),
                ),
              ),
              if (overlay != null) overlay!,
            ],
          ),
        ),
      ),
    );
  }
}
