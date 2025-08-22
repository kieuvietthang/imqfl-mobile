import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:iqiyi_fl/providers/auth_provider.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../models/advertisement.dart';
import '../services/auth_service.dart';
import '../widgets/custom_snackbar_widget.dart';
import '../widgets/loading.dart';

class AdvertisementProvider with ChangeNotifier {
  List<Advertisement> _advertisements = [];
  Advertisement? _splashScreenAd;
  bool _isLoading = false;
  final authApi = AuthService();

  List<Advertisement> get advertisements => _advertisements;

  Advertisement? get splashScreenAd => _splashScreenAd;

  bool get isLoading => _isLoading;

  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool obscure = true;
  bool obscure1 = true;
  bool submitting = false;

  bool _isCheck = true;

  bool get isCheck => _isCheck;

  void setCheck(bool value) {
    _isCheck = value;
    notifyListeners();
  }

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
            description:
            'Bạn muốn khám phá các nội dung thịnh hành trên toàn cầu? Tất cả đều có trên IQIYI, rất nhiều nội dung tuyệt vời đang chờ bạn: các bộ phim truyền hình châu Á, phim điện ảnh và hơn thế nữa. Đăng ký ngay để tham gia cùng với chúng tôi!',
            type: 'image',
            mediaUrl:
            'https://pic9.iqiyipic.com/hamster/20250602/09/e5/47df14cd8c_1808_1017.webp',
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
        description:
        'Bạn muốn khám phá các nội dung thịnh hành trên toàn cầu? Tất cả đều có trên IQIYI, rất nhiều nội dung tuyệt vời đang chờ bạn: các bộ phim truyền hình châu Á, phim điện ảnh và hơn thế nữa. Đăng ký ngay để tham gia cùng với chúng tôi!',
        type: 'image',
        mediaUrl:
        'https://pic9.iqiyipic.com/hamster/20250602/09/e5/47df14cd8c_1808_1017.webp',
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

  String? validateName(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập họ tên';
    if (value.length < 2) return 'Họ tên tối thiểu 2 ký tự';
    return null;
  }

  String? validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập email';
    final emailRx = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRx.hasMatch(value)) return 'Email không hợp lệ';
    return null;
  }

  String? validatePassword(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (value.length <= 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  String? validateConfirm(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập lại mật khẩu';
    if (value != passCtrl.text.trim()) return 'Mật khẩu nhập lại không khớp';
    return null;
  }


  void onRegister({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      Loading.show(context);

      final res = await authApi.registerUser(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (res != null) {
        context.read<AuthProvider>().login(res.data.accessToken);
        Loading.hide(context);
        context.go('/home');
      }
    } catch (e) {
      Loading.hide(context);
      print("Đăng ký thất bại: $e");
    }
  }

  Future<void> onLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      Loading.show(context);
      final res = await authApi.loginUser(email: email, password: password);

      if (res != null) {
        final token = res.data.accessToken;

        final accessToken = await context.read<AuthProvider>().login(token);
        Loading.hide(context);

        if (accessToken) {
          context.go('/home');
        } else {
          AppSnackbar.error(context, 'Không lưu được phiên đăng nhập');
        }
      }
    } catch (e) {
      Loading.hide(context);
      AppSnackbar.error(context, 'Đăng nhập thất bại');
    }
  }


  void clear(){
    confirmCtrl.clear();
    emailCtrl.clear();
    nameCtrl.clear();
    passCtrl.clear();
  }

    @override
    void dispose() {
      confirmCtrl.dispose();
      emailCtrl.dispose();
      nameCtrl.dispose();
      passCtrl.dispose();
      super.dispose();
    }
  }
