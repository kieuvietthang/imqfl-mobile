import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../utils/theme.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<BottomNavigationItem> _tabs = [
    BottomNavigationItem(
      route: '/home',
      label: 'Trang chủ',
      icon: LucideIcons.home,
    ),
    BottomNavigationItem(
      route: '/discover',
      label: 'Phát hiện',
      icon: Icons.grid_view,
    ),
    BottomNavigationItem(
      route: '/shorts',
      label: 'Phim ngắn',
      icon: LucideIcons.video,
    ),
    BottomNavigationItem(
      route: '/download',
      label: 'Tải về',
      icon: LucideIcons.download,
    ),
    BottomNavigationItem(
      route: '/profile',
      label: 'Của tôi',
      icon: LucideIcons.user,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final String location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].route)) {
        setState(() {
          _selectedIndex = i;
        });
        break;
      }
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      context.go(_tabs[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
          border: Border(
            top: BorderSide(
              color: Color(0xFF333333),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.backgroundColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppTheme.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: _tabs.map((tab) {
            return BottomNavigationBarItem(
              icon: Icon(tab.icon, size: 22),
              label: tab.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BottomNavigationItem {
  final String route;
  final String label;
  final IconData icon;

  const BottomNavigationItem({
    required this.route,
    required this.label,
    required this.icon,
  });
}
