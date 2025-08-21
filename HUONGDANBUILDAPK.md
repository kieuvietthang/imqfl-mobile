# Hướng Dẫn Build APK cho Ứng Dụng IQIYI Flutter

## Yêu cầu hệ thống

- Flutter SDK (phiên bản 3.8.1 trở lên)
- Android SDK
- JDK 11 hoặc cao hơn
- Git

## Chuẩn bị môi trường

### 1. Kiểm tra Flutter

```bash
flutter doctor
```

Đảm bảo tất cả các thành phần cần thiết đều được cài đặt đúng cách.

### 2. Kiểm tra Android SDK

Đảm bảo Android SDK được cài đặt và cấu hình đúng trong Flutter:

```bash
flutter doctor --android-licenses
```

## Các bước build APK

### Bước 1: Clone dự án (nếu chưa có)

```bash
git clone https://github.com/trunglemobiledev/imqfl.git
cd iqiyi_fl
```

### Bước 2: Cài đặt dependencies

```bash
flutter pub get
```

**Lưu ý**: Nếu gặp lỗi về symlink trên Windows, hãy bật Developer Mode:
- Mở Settings → Update & Security → For developers
- Chọn "Developer mode"
- Hoặc chạy lệnh: `start ms-settings:developers`

### Bước 3: Dọn dẹp build cache (tùy chọn)

```bash
flutter clean
```

### Bước 4: Build APK

#### Build APK Release (khuyến nghị cho production)

```bash
flutter build apk --release
```

#### Build APK Debug (cho testing)

```bash
flutter build apk --debug
```

#### Build APK cho nhiều kiến trúc

```bash
flutter build apk --split-per-abi
```

Lệnh này sẽ tạo ra các APK riêng biệt cho từng kiến trúc (arm64-v8a, armeabi-v7a, x86_64).

### Bước 5: Tìm file APK

Sau khi build thành công, file APK sẽ được tạo tại:

- **Release APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Split APKs**: `build/app/outputs/flutter-apk/app-{architecture}-release.apk`

## Cấu hình nâng cao

### Đổi tên app hiển thị

#### Cách 1: Sửa trực tiếp AndroidManifest.xml

Mở file `android/app/src/main/AndroidManifest.xml` và thay đổi:

```xml
<application
    android:label="Tên App Mới"
    ...>
```

#### Cách 2: Sử dụng strings.xml (khuyến nghị)

1. Tạo file `android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Tên App Mới</string>
</resources>
```

2. Cập nhật AndroidManifest.xml:

```xml
<application
    android:label="@string/app_name"
    ...>
```

### Cập nhật Android NDK (nếu cần)

Nếu gặp cảnh báo về Android NDK version, cập nhật file `android/app/build.gradle.kts`:

```kotlin
android {
    ndkVersion = "27.0.12077973"
    // ... các cấu hình khác
}
```

### Tối ưu kích thước APK

1. **Enable Proguard** (giảm kích thước code):

```kotlin
buildTypes {
    release {
        minifyEnabled = true
        shrinkResources = true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        signingConfig = signingConfigs.release
    }
}
```

2. **Split APK theo ABI**:

```bash
flutter build apk --split-per-abi --target-platform android-arm,android-arm64,android-x64
```

### Ký APK cho Production

1. Tạo keystore:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Cấu hình signing trong `android/app/build.gradle.kts`:

```kotlin
signingConfigs {
    release {
        keyAlias = keystoreProperties['keyAlias']
        keyPassword = keystoreProperties['keyPassword']
        storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword = keystoreProperties['storePassword']
    }
}
```

3. Tạo file `android/key.properties`:

```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the key store file>
```

## Troubleshooting

### Lỗi thường gặp

1. **Gradle build failed**:
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

2. **Out of memory**:
   ```bash
   export GRADLE_OPTS="-Dorg.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8"
   ```

3. **Android licenses not accepted**:
   ```bash
   flutter doctor --android-licenses
   ```

### Kiểm tra APK

1. **Kích thước APK**:
   ```bash
   ls -lh build/app/outputs/flutter-apk/app-release.apk
   ```

2. **Cài đặt APK lên device**:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

3. **Phân tích APK**:
   ```bash
   flutter build apk --analyze-size
   ```

## Ghi chú quan trọng

- File APK release có kích thước khoảng **22.7MB**
- Ứng dụng sử dụng nhiều dependencies như video player, image caching, navigation
- Font icons được tối ưu tự động (tree-shaking) giảm 99%+ kích thước
- Đảm bảo test APK trên nhiều thiết bị khác nhau trước khi release

## Thông tin dự án

- **Tên**: IQIYI Flutter App
- **Package**: com.example.iqiyi_fl
- **Version**: 1.0.0+1
- **Min SDK**: Theo cấu hình Flutter
- **Target SDK**: Theo cấu hình Flutter

---

*Cập nhật lần cuối: 16/08/2025*
