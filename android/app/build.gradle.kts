import java.io.File
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val projectReleaseKeystorePropertiesFile = rootProject.file("key.properties")
val userReleaseKeystorePropertiesFile = File(
    System.getProperty("user.home"),
    ".deepwidget/key.properties",
)
val releaseKeystorePropertiesFile = listOf(
    projectReleaseKeystorePropertiesFile,
    userReleaseKeystorePropertiesFile,
).firstOrNull { it.isFile } ?: projectReleaseKeystorePropertiesFile
val releaseKeystoreProperties = Properties()
val hasReleaseSigning = releaseKeystorePropertiesFile.isFile
if (hasReleaseSigning) {
    releaseKeystorePropertiesFile.inputStream().use(releaseKeystoreProperties::load)
}

val releaseArtifactTasks = listOf(
    "assembleRelease",
    "bundleRelease",
    "packageRelease",
    "installRelease",
)
if (!hasReleaseSigning && gradle.startParameter.taskNames.any { requestedTask ->
        releaseArtifactTasks.any { releaseTask ->
            requestedTask.contains(releaseTask, ignoreCase = true)
        }
    }
) {
    throw GradleException(
        "Release signing is not configured. Create android/key.properties or ~/.deepwidget/key.properties with a private release keystore.",
    )
}

android {
    namespace = "com.odeepart.deepwidget"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.odeepart.deepwidget"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = releaseKeystoreProperties.getProperty("keyAlias")
                keyPassword = releaseKeystoreProperties.getProperty("keyPassword")
                storeFile = file(releaseKeystoreProperties.getProperty("storeFile"))
                storePassword = releaseKeystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
