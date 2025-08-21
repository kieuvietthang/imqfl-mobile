import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Của tôi'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Người dùng Demo',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Text(
                              authProvider.isLoggedIn ? 'Đã đăng nhập' : 'Chưa đăng nhập',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'VIP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Menu items
            _buildMenuItem(
              icon: Icons.favorite,
              title: 'Yêu thích',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.history,
              title: 'Lịch sử xem',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.download,
              title: 'Tải về',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.settings,
              title: 'Cài đặt',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.help,
              title: 'Trợ giúp',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.info,
              title: 'Về chúng tôi',
              onTap: () {},
            ),
            
            const SizedBox(height: 24),
            
            // Logout button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : () async {
                      final success = await authProvider.logout();
                      if (success && context.mounted) {
                        context.go('/auth');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.red.withOpacity(0.3)),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Đăng xuất',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 100), // Bottom padding for tab bar
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppTheme.textSecondary,
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
