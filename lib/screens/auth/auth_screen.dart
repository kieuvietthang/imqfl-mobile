import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/advertisement_provider.dart';
import '../../utils/theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdvertisementProvider>().fetchAdvertisements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AdvertisementProvider>(
        builder: (context, adProvider, child) {
          final splashAd = adProvider.splashScreenAd;
          final backgroundImage = splashAd?.mediaUrl ?? 'https://pic9.iqiyipic.com/hamster/20250602/09/e5/47df14cd8c_1808_1017.webp';
          
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.95),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 0.85, 1.0],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.8],
                  ),
                ),
                child: SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthProvider>().skipLogin();
                        context.go('/home');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Để sau',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        splashAd?.title ?? 'Chào Mừng Bạn',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        splashAd?.description ?? 'Bạn muốn khám phá các nội dung thịnh hành trên toàn cầu? Tất cả đều có trên IQIYI, rất nhiều nội dung tuyệt vời đang chờ bạn: các bộ phim truyền hình châu Á, phim điện ảnh và hơn thế nữa. Đăng ký ngay để tham gia cùng với chúng tôi!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 80),
                      
                      // Login button
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading ? null : () {
                                _showLoginBottomSheet(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: authProvider.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'ĐĂNG NHẬP NGAY',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
                ),
            ),
          );
        },
      ),
    );
  }

  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF111117),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Demo login buttons
              _buildDemoLoginButton(
                context,
                title: 'Đăng nhập Demo',
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthProvider>().login('demo_token_123');
                  context.go('/home');
                },
              ),
              const SizedBox(height: 16),
              _buildDemoLoginButton(
                context,
                title: 'Bỏ qua đăng nhập',
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthProvider>().skipLogin();
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoLoginButton(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
