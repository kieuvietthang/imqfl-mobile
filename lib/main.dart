// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/advertisement_provider.dart';
import 'providers/banner_carousel_provider.dart';
import 'utils/theme.dart';
import 'utils/router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AdvertisementProvider()),
        ChangeNotifierProvider(create: (_) => BannerCarouselProvider()),
      ],
      child: Builder(
        builder: (context) {
          final router = createRouter(context);

          return Consumer<AuthProvider>(
            builder: (_, auth, __) {
              if (auth.isLoading) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.darkTheme,
                  home: const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return MaterialApp.router(
                title: 'iQIYI Flutter',
                theme: AppTheme.darkTheme,
                routerConfig: router,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
