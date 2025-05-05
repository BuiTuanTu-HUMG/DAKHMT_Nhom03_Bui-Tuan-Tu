plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.app_theo_doi_suc_khoe" // ✅ Đổi thành tên gói của bạn nếu cần
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.app_theo_doi_suc_khoe" // ✅ Đổi lại ID cho đúng với app bạn
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

   buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}


    buildFeatures {
        viewBinding = true
    }
}

flutter {
    source = "../.."
}
