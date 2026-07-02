// import 'package:core/core.dart';
// import 'package:features/features.dart';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// enum Environment { dev, staging, prod }

// class AppConfig {
//   AppConfig._({required this.environment, required this.appName, required this.supabaseUrl, required this.supabaseAnonKey});

//   static late AppConfig _instance;
//   static AppConfig get instance => _instance;

//   final Environment environment;
//   final String appName;
//   final String supabaseUrl;
//   final String supabaseAnonKey;

//   static Future<void> initialize(Environment env) async {
//     final config = _getConfig(env);
//     _instance = config;

//     // Initialize Supabase
//     await Supabase.initialize(url: config.supabaseUrl, anonKey: config.supabaseAnonKey);

//     // Initialize dependency injection
//     debugPrint('Initializing Core dependencies...');
//     await configureDependencies(environment: env.name);

//     // Initialize feature dependencies
//     debugPrint('Initializing Feature dependencies...');
//     configureFeaturesDependencies(getIt, environment: env.name);
//     debugPrint('Dependencies initialized.');

//     AppLogger.i('App initialized for ${env.name} environment');
//   }

//   static AppConfig _getConfig(Environment env) {
//     switch (env) {
//       case Environment.dev:
//         return AppConfig._(
//           environment: env,
//           appName: 'Finance App (Dev)',
//           // ignore: do_not_use_environment
//           supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://uxcbofznpnnkdvtgvumh.supabase.co'),
//           // ignore: do_not_use_environment
//           supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'key'),
//         );
//       case Environment.staging:
//         return AppConfig._(
//           environment: env,
//           appName: 'Finance App (Staging)',
//           supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://your-staging-project.supabase.co'),
//           supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'your-staging-anon-key'),
//         );
//       case Environment.prod:
//         return AppConfig._(
//           environment: env,
//           appName: 'Finance App',
//           supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://your-prod-project.supabase.co'),
//           supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'your-prod-anon-key'),
//         );
//     }
//   }

//   bool get isDev => environment == Environment.dev;
//   bool get isStaging => environment == Environment.staging;
//   bool get isProd => environment == Environment.prod;
// }
