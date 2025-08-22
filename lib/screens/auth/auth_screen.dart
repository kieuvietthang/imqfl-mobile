import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          final backgroundImage =
              splashAd?.mediaUrl ??
              'https://pic9.iqiyipic.com/hamster/20250602/09/e5/47df14cd8c_1808_1017.webp';
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
                    colors: [Colors.black.withOpacity(0.9), Colors.transparent],
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
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              splashAd?.description ??
                                  'Bạn muốn khám phá các nội dung thịnh hành trên toàn cầu? Tất cả đều có trên IQIYI, rất nhiều nội dung tuyệt vời đang chờ bạn: các bộ phim truyền hình châu Á, phim điện ảnh và hơn thế nữa. Đăng ký ngay để tham gia cùng với chúng tôi!',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
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
                                    onPressed: authProvider.isLoading
                                        ? null
                                        : () {
                                            _showLoginBottomSheet(context);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
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
    final adProvider = context.read<AdvertisementProvider>();

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
          child: Consumer<AdvertisementProvider>(
            builder: (context, adProvider, _) {
              return Column(
                children: [
                  Visibility(
                    visible: adProvider.isCheck,
                    replacement: _signIn(),
                    child: _login(),
                  ),
                  // Demo login buttons
                  // _buildDemoLoginButton(
                  //   context,
                  //   title: 'Đăng nhập Demo',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     context.read<AuthProvider>().login('demo_token_123');
                  //     context.go('/home');
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                  // _buildDemoLoginButton(
                  //   context,
                  //   title: 'Bỏ qua đăng nhập',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     context.read<AuthProvider>().skipLogin();
                  //     context.go('/home');
                  //   },
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    ).whenComplete(() {
      adProvider.setCheck(true);
      adProvider.clear();
    });
  }

  Widget _login() {
    final cs = Theme.of(context).colorScheme;
    final adProvider = context.read<AdvertisementProvider>();
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: adProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: adProvider.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: adProvider.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: adProvider.passCtrl,
                  obscureText: adProvider.obscure,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () => adProvider.obscure = !adProvider.obscure,
                      ),
                      icon: Icon(
                        adProvider.obscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      tooltip: adProvider.obscure
                          ? 'Hiện mật khẩu'
                          : 'Ẩn mật khẩu',
                    ),
                  ),
                  validator: adProvider.validatePassword,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: (){
                    adProvider.onLogin(
                      email: adProvider.emailCtrl.text,
                      password: adProvider.passCtrl.text,
                      context: context,
                    );

                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('Bạn chưa có tài khoản? '),
                      TextButton(
                        onPressed: () {
                          adProvider.setCheck(false);
                        },
                        child: Text(
                          'Đăng kí ngay',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signIn() {
    final adProvider = context.read<AdvertisementProvider>();
    return Form(
      key: adProvider.formKey1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: const Text(
              'Đăng Kí',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: adProvider.nameCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Họ và tên',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: adProvider.validateName,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: adProvider.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            validator: adProvider.validateEmail,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: adProvider.passCtrl,
            obscureText: adProvider.obscure,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => adProvider.obscure = !adProvider.obscure),
                icon: Icon(
                  adProvider.obscure ? Icons.visibility : Icons.visibility_off,
                ),
                tooltip: adProvider.obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
              ),
            ),
            validator: adProvider.validatePassword,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: adProvider.confirmCtrl,
            obscureText: adProvider.obscure1,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Nhập lại mật khẩu',
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => adProvider.obscure1 = !adProvider.obscure1),
                icon: Icon(
                  adProvider.obscure1 ? Icons.visibility : Icons.visibility_off,
                ),
                tooltip: adProvider.obscure1 ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
              ),
            ),
            validator: adProvider.validateConfirm,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: (){
              adProvider.onRegister(
                name: adProvider.nameCtrl.text,
                email: adProvider.emailCtrl.text,
                password: adProvider.passCtrl.text,
                confirmPassword: adProvider.confirmCtrl.text,
                context: context,
              );
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: Text(
                'Đăng kí',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        ],
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
