import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/banner.dart';

class BannerCarouselProvider with ChangeNotifier {
  List<BannerItem> _banners = [];
  bool _isLoading = false;

  List<BannerItem> get banners => _banners;
  bool get isLoading => _isLoading;

  Future<void> fetchBanners() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://160.30.21.68/api/v1/public/banner-carousels'),
      );

      if (response.statusCode == 200) {
        final bannerResponse = BannerCarouselResponse.fromJson(
          json.decode(response.body),
        );
        
        _banners = bannerResponse.data;
        // Sort by sortOrder
        _banners.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      } else {
        // Use default banners if API fails
        _setDefaultBanners();
      }
    } catch (e) {
      print('Error fetching banner carousels: $e');
      // Use default banners if API fails
      _setDefaultBanners();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _setDefaultBanners() {
    _banners = [
      BannerItem(
        id: 1,
        title: 'Kết Hôn',
        subtitle: 'Rồi Bắt Đầu Yêu',
        bgImage: 'https://pic9.iqiyipic.com/hamster/20250602/09/e5/47df14cd8c_1808_1017.webp',
        fgImage: 'https://pic3.iqiyipic.com/hamster/20250602/76/6c/d8f0a5414f_xxx.webp',
        isFree: true,
        movie: const Movie(
          id: 'default-1',
          title: 'Kết Hôn Rồi Bắt Đầu Yêu',
          slug: 'ket-hon-roi-bat-dau-yeu',
        ),
        sortOrder: 0,
      ),
      BannerItem(
        id: 2,
        title: 'Trái Tim',
        subtitle: 'Mùa Đông',
        bgImage: 'https://pic4.iqiyipic.com/hamster/20250714/dd/46/aa51b6aec8_1808_1017.webp',
        fgImage: 'https://pic2.iqiyipic.com/hamster/20250714/f9/38/0bf4788dad_xxx.webp',
        isFree: false,
        movie: const Movie(
          id: 'default-2',
          title: 'Trái Tim Mùa Đông',
          slug: 'trai-tim-mua-dong',
        ),
        sortOrder: 1,
      ),
    ];
  }
}
