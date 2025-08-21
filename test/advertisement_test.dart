import 'package:flutter_test/flutter_test.dart';
import 'package:iqiyi_fl/models/advertisement.dart';

void main() {
  group('Advertisement Model Tests', () {
    test('should create Advertisement from JSON', () {
      final json = {
        "id": 13,
        "title": "Quảng cáo detail phim",
        "description": "Quảng cáo detail phim",
        "type": "video",
        "media_url": "https://pic3.iqiyipic.com/image/20250804/5f/b6/a_100659295_m_601_vi_720_405.webp",
        "link_url": "https://shopee.vn/Apple-iPhone-16-Pro-Max-256GB-Ch%C3%ADnh-h%C3%A3ng-VN-A-i.308461157.26711038214?sp_atk=c3540c32-6f35-47d2-8a0f-70d0a1ee7a69&xptdk=c3540c32-6f35-47d2-8a0f-70d0a1ee7a69",
        "target_page": "splash_screen",
        "position": 2,
        "view_count": 11,
        "click_count": 0
      };

      final advertisement = Advertisement.fromJson(json);

      expect(advertisement.id, 13);
      expect(advertisement.title, "Quảng cáo detail phim");
      expect(advertisement.description, "Quảng cáo detail phim");
      expect(advertisement.type, "video");
      expect(advertisement.targetPage, "splash_screen");
      expect(advertisement.position, 2);
      expect(advertisement.viewCount, 11);
      expect(advertisement.clickCount, 0);
    });

    test('should create AdvertisementResponse from JSON', () {
      final json = {
        "status": "success",
        "data": [
          {
            "id": 13,
            "title": "Quảng cáo detail phim",
            "description": "Quảng cáo detail phim",
            "type": "video",
            "media_url": "https://pic3.iqiyipic.com/image/20250804/5f/b6/a_100659295_m_601_vi_720_405.webp",
            "link_url": "https://shopee.vn/Apple-iPhone-16-Pro-Max-256GB-Ch%C3%ADnh-h%C3%A3ng-VN-A-i.308461157.26711038214?sp_atk=c3540c32-6f35-47d2-8a0f-70d0a1ee7a69&xptdk=c3540c32-6f35-47d2-8a0f-70d0a1ee7a69",
            "target_page": "splash_screen",
            "position": 2,
            "view_count": 11,
            "click_count": 0
          }
        ],
        "count": 1
      };

      final response = AdvertisementResponse.fromJson(json);

      expect(response.status, "success");
      expect(response.data.length, 1);
      expect(response.count, 1);
      expect(response.data.first.targetPage, "splash_screen");
    });
  });
}
