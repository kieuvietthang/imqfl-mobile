# Banner Carousel Integration

Đã tích hợp thành công API Banner Carousel với các tính năng sau:

## 🚀 Tính năng đã triển khai

### 1. **API Integration**
- Gọi API `http://160.30.21.68/api/v1/public/banner-carousels`
- Xử lý response JSON và parse thành models
- Fallback đến dữ liệu mặc định nếu API lỗi

### 2. **Models**
- `Movie`: Model cho thông tin phim (id, title, slug)
- `BannerItem`: Model cho banner carousel với movie reference
- `BannerCarouselResponse`: Model cho API response

### 3. **Provider**
- `BannerCarouselProvider`: Quản lý state và gọi API
- Auto-sort theo `sortOrder`
- Loading states và error handling

### 4. **Widget Updates**
- `BannerCarousel`: Sử dụng Consumer pattern
- Hiển thị loading indicator khi fetch dữ liệu
- Auto-scroll với 5 giây interval

### 5. **Navigation**
- Click vào banner item → navigate đến `/movie/{slug}`
- Click vào play button → navigate đến `/movie/{slug}` của banner hiện tại
- Sử dụng GoRouter để navigation

## 📁 Files được cập nhật

```
lib/
├── models/
│   └── banner.dart                    # ✅ Updated - Added Movie model, updated BannerItem
├── providers/
│   └── banner_carousel_provider.dart  # ✅ New - API provider
├── widgets/home/
│   └── banner_carousel.dart          # ✅ Updated - Consumer pattern, navigation
└── main.dart                         # ✅ Updated - Added provider

test/
└── banner_carousel_test.dart         # ✅ New - Model tests
```

## 🎯 Cách sử dụng

### 1. **Trong Widget**
```dart
// Widget sẽ tự động fetch dữ liệu khi khởi tạo
BannerCarousel()
```

### 2. **Manual fetch** 
```dart
context.read<BannerCarouselProvider>().fetchBanners();
```

### 3. **Truy cập dữ liệu**
```dart
Consumer<BannerCarouselProvider>(
  builder: (context, provider, child) {
    final banners = provider.banners;
    final isLoading = provider.isLoading;
    // Use banners data
  },
)
```

## 🔀 Navigation Flow

1. **Banner Click**: Banner item → `/movie/{slug}`
2. **Play Button**: Current banner → `/movie/{slug}`
3. **Dot Indicator**: Scroll tới banner tương ứng

## 📊 API Response Structure

```json
{
  "success": true,
  "message": "Banner carousels retrieved successfully", 
  "data": [
    {
      "id": 12,
      "title": "Quảng cáo detail phim",
      "subtitle": "Web test",
      "bgImage": "http://...",
      "fgImage": "http://...",
      "isFree": true,
      "movie": {
        "id": "d2eca4c55b345610eb26099a8670910a",
        "title": "Anh Đào Hổ Phách", 
        "slug": "anh-dao-ho-phach"
      },
      "sortOrder": 0
    }
  ]
}
```

## ✅ Đã hoàn thành

- [x] Tích hợp API banner carousels
- [x] Models và Provider setup
- [x] Widget updates với Consumer pattern
- [x] Navigation đến movie detail bằng slug
- [x] Error handling và fallback data
- [x] Loading states
- [x] Unit tests cho models
- [x] Auto-sort theo sortOrder

## 🎮 Testing

Chạy tests:
```bash
flutter test test/banner_carousel_test.dart
```

Banner carousel bây giờ sẽ:
1. Tự động gọi API khi widget được tạo
2. Hiển thị loading spinner trong khi fetch dữ liệu  
3. Sắp xếp banners theo sortOrder
4. Allow navigation bằng cách click hoặc tap play button
5. Fallback đến dữ liệu mặc định nếu API lỗi
