plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.frontend"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.frontend"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["appName"] = "Ebook Library"
    }

        flavorDimensions += "environment"

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            manifestPlaceholders["appName"] = "Ebook Library Dev"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            manifestPlaceholders["appName"] = "Ebook Library Staging"
        }
        create("prod") {
            dimension = "environment"
            manifestPlaceholders["appName"] = "Ebook Library"
        }
    }


    buildTypes {

        
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}


// plugins {
//     id("com.android.application")
//     id("kotlin-android")
//     // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//     id("dev.flutter.flutter-gradle-plugin")
// }

// android {
//     namespace = "com.example.frontend"
//     compileSdk = 36
//     ndkVersion = flutter.ndkVersion

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_1_8
//         targetCompatibility = JavaVersion.VERSION_1_8
//         isCoreLibraryDesugaringEnabled = true
//     }

//     kotlinOptions {
//         jvmTarget = "1.8"
//     }

//     defaultConfig {
//         applicationId = "com.example.frontend"
//         minSdk = flutter.minSdkVersion
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName
//         manifestPlaceholders["appName"] = "Ebook Library"
//     }

//     flavorDimensions += "environment"

//     productFlavors {
//         create("dev") {
//             dimension = "environment"
//             applicationIdSuffix = ".dev"
//             versionNameSuffix = "-dev"
//             manifestPlaceholders["appName"] = "Ebook Library Dev"
//         }
//         create("staging") {
//             dimension = "environment"
//             applicationIdSuffix = ".staging"
//             versionNameSuffix = "-staging"
//             manifestPlaceholders["appName"] = "Ebook Library Staging"
//         }
//         create("prod") {
//             dimension = "environment"
//             manifestPlaceholders["appName"] = "Ebook Library"
//         }
//     }

//     buildTypes {
//         release {
//             signingConfig = signingConfigs.getByName("debug")
//         }
//     }
// }

// dependencies {
//     coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
// }

// flutter {
//     source = "../.."
// }
