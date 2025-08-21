import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/advertisement_provider.dart';
import 'providers/banner_carousel_provider.dart';
import 'utils/theme.dart';
import 'utils/router.dart';

void main() {
  runApp(const MyApp());
}

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
      child: MaterialApp.router(
        title: 'iQIYI Flutter',
        theme: AppTheme.darkTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
