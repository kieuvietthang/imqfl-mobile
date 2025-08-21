# iQIYI Flutter

Một ứng dụng Flutter clone iQIYI với giao diện đẹp mắt và các tính năng xem phim/video hiện đại.

## Tính năng chính

- 🎬 Xem phim/video với giao diện thân thiện
- 🔍 Tìm kiếm và khám phá nội dung
- 📱 Hỗ trợ đa nền tảng (iOS, Android, Web, Desktop)
- 🎨 Giao diện tối hiện đại
- 📊 Quản lý trạng thái với Provider
- 🚀 Navigation với GoRouter
- 💾 Lưu trữ dữ liệu local với SharedPreferences

## Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point của ứng dụng
├── models/                   # Data models
│   ├── banner.dart          # Model cho banner
│   ├── category.dart        # Model cho danh mục
│   └── movie.dart           # Model cho phim/video
├── providers/               # State management với Provider
│   ├── auth_provider.dart   # Quản lý authentication
│   └── home_provider.dart   # Quản lý state trang chủ
├── screens/                 # Các màn hình UI
│   ├── auth/               # Màn hình đăng nhập/đăng ký
│   ├── discover/           # Màn hình khám phá
│   ├── download/           # Màn hình tải xuống
│   ├── home/               # Màn hình trang chủ
│   ├── main/               # Màn hình chính (bottom navigation)
│   ├── movie_detail/       # Màn hình chi tiết phim
│   ├── profile/            # Màn hình hồ sơ
│   └── shorts/             # Màn hình video ngắn
├── services/               # Services cho API và logic
│   ├── api_client.dart     # HTTP client
│   ├── category_service.dart # Service cho danh mục
│   ├── movie_service.dart   # Service cho phim/video
│   └── storage_service.dart # Service lưu trữ local
├── utils/                  # Utilities và helpers
│   ├── router.dart         # Cấu hình routing với GoRouter
│   └── theme.dart          # Theme và styling
└── widgets/                # Custom widgets
    ├── home/               # Widgets cho trang chủ
    └── movie_detail/       # Widgets cho chi tiết phim
```

## Dependencies chính

### Core
- `flutter`: Framework chính
- `provider`: State management
- `go_router`: Navigation và routing

### UI & Animations
- `cupertino_icons`: Icons iOS style
- `lucide_icons`: Modern icon set
- `cached_network_image`: Tối ưu hình ảnh từ network
- `carousel_slider`: Slider cho banner
- `smooth_page_indicator`: Page indicator
- `animations`: Animations nâng cao

### Network & Storage
- `http` & `dio`: HTTP requests
- `shared_preferences`: Local storage

### Utils
- `equatable`: So sánh objects dễ dàng

## Bắt đầu

### Yêu cầu
- Flutter SDK ^3.8.1
- Dart SDK tương ứng

### Cài đặt
```bash
# Clone repository
git clone <repository-url>
cd iqfl

# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng
flutter run
```

### Build cho production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Kiến trúc

Dự án sử dụng kiến trúc **Provider Pattern** kết hợp với **Clean Architecture**:

- **Models**: Định nghĩa cấu trúc dữ liệu
- **Providers**: Quản lý state và business logic
- **Services**: Xử lý API calls và data persistence
- **Screens**: UI components theo từng màn hình
- **Widgets**: Reusable UI components
- **Utils**: Helper functions và configurations

## Đóng góp

1. Fork repository
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request
