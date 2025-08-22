// utils/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/shorts/shorts_screen.dart';
import '../screens/download/download_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/movie_detail/movie_detail_screen.dart';

GoRouter createRouter(BuildContext context) {
  final auth = context.read<AuthProvider>();

  return GoRouter(
    refreshListenable: auth,

    redirect: (ctx, state) {
      final a = ctx.read<AuthProvider>();

      if (a.isLoading) return null;

      final goingAuth = state.matchedLocation == '/auth';

      if (!a.isLoggedIn && !goingAuth) return '/auth';
      if (a.isLoggedIn && goingAuth) return '/home';
      return null;
    },

    initialLocation: '/home',

    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/movie/:slug',
        name: 'movie_detail',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return MovieDetailScreen(movieSlug: slug);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(path: '/home',     name: 'home',     builder: (c, s) => const HomeScreen()),
          GoRoute(path: '/discover', name: 'discover', builder: (c, s) => const DiscoverScreen()),
          GoRoute(path: '/shorts',   name: 'shorts',   builder: (c, s) => const ShortsScreen()),
          GoRoute(path: '/download', name: 'download', builder: (c, s) => const DownloadScreen()),
          GoRoute(path: '/profile',  name: 'profile',  builder: (c, s) => const ProfileScreen()),
        ],
      ),
    ],
  );
}
