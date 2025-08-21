import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/advertisement.dart';

class AdvertisementProvider with ChangeNotifier {
  List<Advertisement> _advertisements = [];
  Advertisement? _splashScreenAd;
  bool _isLoading = false;

  List<Advertisement> get advertisements => _advertisements;
  Advertisement? get splashScreenAd => _splashScreenAd;
  bool get isLoading => _isLoading;

  Future<void> fetchAdvertisements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://160.30.21.68/api/v1/public/advertisements'),
      );

      if (response.statusCode == 200) {
        final advertisementResponse = AdvertisementResponse.fromJson(
          json.decode(response.body),
        );
        
        _advertisements = advertisementResponse.data;
        
        // Find advertisement for splash_screen
        try {
          _splashScreenAd = _advertisements.firstWhere(
            (ad) => ad.targetPage == 'splash_screen',
          );
        } catch (e) {
          // Use default values if no splash_screen ad found
          _splashScreenAd = Advertisement(
            id: 0,
            title: 'Chào Mừng Bạn',
            description: 'Bạn muốn khám phá các nội dung thịnh hành trên toàn cầu? Tất cả đều có trên IQIYI, rất nhiều nội dung tuyệt vời đang chờ bạn: các bộ phim truyền hình châu Á, phim điện ảnh và hơn thế nữa. Đăng ký ngay để tham gia cùng với chúng tôi!',
            type: 'image',
            mediaUrl: 'https://pic9.iqiyipic.com/hamster/20250602/09/e5/47df14cd8c_1808_1017.webp',
            linkUrl: '',
            targetPage: 'splash_screen',
            position: 1,
            viewCount: 0,
            clickCount: 0,
          );
        }
      }
    } catch (e) {
      print('Error fetching advertisements: $e');
      // Use default values if API fails
      _splashScreenAd = Advertisement(
        id: 0,
        title: 'Chào Mừng Bạn',
        description: 'Bạn muốn khám phá các nội dung thịnh hành trên toàn cầu? Tất cả đều có trên IQIYI, rất nhiều nội dung tuyệt vời đang chờ bạn: các bộ phim truyền hình châu Á, phim điện ảnh và hơn thế nữa. Đăng ký ngay để tham gia cùng với chúng tôi!',
        type: 'image',
        mediaUrl: 'https://pic9.iqiyipic.com/hamster/20250602/09/e5/47df14cd8c_1808_1017.webp',
        linkUrl: '',
        targetPage: 'splash_screen',
        position: 1,
        viewCount: 0,
        clickCount: 0,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Advertisement> getAdvertisementsByTargetPage(String targetPage) {
    return _advertisements.where((ad) => ad.targetPage == targetPage).toList();
  }
}
