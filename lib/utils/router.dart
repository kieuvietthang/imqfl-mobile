import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/shorts/shorts_screen.dart';
import '../screens/download/download_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/movie_detail/movie_detail_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/auth',
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
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/discover',
          name: 'discover',
          builder: (context, state) => const DiscoverScreen(),
        ),
        GoRoute(
          path: '/shorts',
          name: 'shorts',
          builder: (context, state) => const ShortsScreen(),
        ),
        GoRoute(
          path: '/download',
          name: 'download',
          builder: (context, state) => const DownloadScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
