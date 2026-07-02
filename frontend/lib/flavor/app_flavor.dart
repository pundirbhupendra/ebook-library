enum Flavor { dev, staging, prod }

class AppFlavor {
  const AppFlavor._({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.showBanner,
  });

  static late AppFlavor current;

  final Flavor flavor;
  final String appName;
  final String baseUrl;
  final bool showBanner;

  static void initialize(Flavor flavor) {
    current = switch (flavor) {
      Flavor.dev => const AppFlavor._(
        flavor: Flavor.dev,
        appName: 'Ebook Library Dev',
        baseUrl: String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://10.0.2.2:3000',
        ),
        showBanner: true,
      ),
      Flavor.staging => const AppFlavor._(
        flavor: Flavor.staging,
        appName: 'Ebook Library Staging',
        baseUrl: String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://staging-api.ebook-library.example.com',
        ),
        showBanner: true,
      ),
      Flavor.prod => const AppFlavor._(
        flavor: Flavor.prod,
        appName: 'Ebook Library',
        baseUrl: String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.ebook-library.example.com',
        ),
        showBanner: false,
      ),
    };
  }

  bool get useMockFallback => false;
  String get label => flavor.name.toUpperCase();
}
