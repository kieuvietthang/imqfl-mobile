import 'package:flutter_test/flutter_test.dart';
import 'package:iqiyi_fl/models/banner.dart';

void main() {
  group('Banner Carousel Models Tests', () {
    test('should create Movie from JSON', () {
      final json = {
        "id": "d2eca4c55b345610eb26099a8670910a",
        "title": "Anh Đào Hổ Phách",
        "slug": "anh-dao-ho-phach"
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, "d2eca4c55b345610eb26099a8670910a");
      expect(movie.title, "Anh Đào Hổ Phách");
      expect(movie.slug, "anh-dao-ho-phach");
    });

    test('should create BannerItem from JSON', () {
      final json = {
        "id": 12,
        "title": "Quảng cáo detail phim",
        "subtitle": "Web test",
        "bgImage": "http://160.30.21.68/storage/banner_carousels/1755530774_bg_slide1_wrapper1_background_1.webp",
        "fgImage": "http://160.30.21.68/storage/banner_carousels/1755530774_fg_slide1_wrapper1_character_2.webp",
        "isFree": true,
        "movie": {
          "id": "d2eca4c55b345610eb26099a8670910a",
          "title": "Anh Đào Hổ Phách",
          "slug": "anh-dao-ho-phach"
        },
        "sortOrder": 0
      };

      final banner = BannerItem.fromJson(json);

      expect(banner.id, 12);
      expect(banner.title, "Quảng cáo detail phim");
      expect(banner.subtitle, "Web test");
      expect(banner.isFree, true);
      expect(banner.sortOrder, 0);
      expect(banner.movie.slug, "anh-dao-ho-phach");
    });

    test('should create BannerCarouselResponse from JSON', () {
      final json = {
        "success": true,
        "message": "Banner carousels retrieved successfully",
        "data": [
          {
            "id": 12,
            "title": "Quảng cáo detail phim",
            "subtitle": "Web test",
            "bgImage": "http://160.30.21.68/storage/banner_carousels/1755530774_bg_slide1_wrapper1_background_1.webp",
            "fgImage": "http://160.30.21.68/storage/banner_carousels/1755530774_fg_slide1_wrapper1_character_2.webp",
            "isFree": true,
            "movie": {
              "id": "d2eca4c55b345610eb26099a8670910a",
              "title": "Anh Đào Hổ Phách",
              "slug": "anh-dao-ho-phach"
            },
            "sortOrder": 0
          }
        ]
      };

      final response = BannerCarouselResponse.fromJson(json);

      expect(response.success, true);
      expect(response.message, "Banner carousels retrieved successfully");
      expect(response.data.length, 1);
      expect(response.data.first.movie.slug, "anh-dao-ho-phach");
    });
  });
}
