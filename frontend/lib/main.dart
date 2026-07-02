import 'package:flutter/material.dart';

import 'di/injection.dart';
import 'flavor/app_flavor.dart';
import 'router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  await bootstrap(Flavor.dev);
}

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppFlavor.initialize(flavor);
  await configureDependencies();
  runApp(DigitalEbookLibraryApp(router: sl<AppRouter>()));
}

class DigitalEbookLibraryApp extends StatelessWidget {
  const DigitalEbookLibraryApp({required this.router, super.key});

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    final flavor = AppFlavor.current;
    final app = MaterialApp.router(title: flavor.appName, debugShowCheckedModeBanner: false, theme: AppTheme.light, darkTheme: AppTheme.dark, routerConfig: router.router);

    if (!flavor.showBanner) return app;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: flavor.label,
        location: BannerLocation.topStart,
        color: flavor.flavor == Flavor.dev ? const Color(0xFF2E7D32) : const Color(0xFFEF6C00),
        child: app,
      ),
    );
  }
}
