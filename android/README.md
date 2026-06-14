# Sigarasizim Android

Bu klasor, iOS uygulamasinin Android / Google Play surumu icin eklenen Jetpack Compose projesidir.

## Neler var

- `Jetpack Compose` ile 5 sekmeli Android arayuzu
- `DataStore` ile kalici ayarlar ve sigara birakma oturumu
- `AdMob` banner ve interstitial reklam altyapisi
- Gunluk motivasyon bildirimi icin `BroadcastReceiver`
- Turkce ve Ingilizce metin destegi

## Yayinlamadan once degistirilecekler

1. `android/app/build.gradle.kts` icindeki `manifestPlaceholders["admobAppId"]`
2. `android/app/src/main/java/com/idakimi/sigarasizim/Ads.kt` icindeki:
   - `bannerAdUnitId`
   - `interstitialAdUnitId`
3. Uygulama ikonlari, splash ve Play Store gorselleri
4. Release imzalama ve `versionCode` / `versionName`

## Derleme

Android Studio ile `android/` klasorunu acin ve Gradle sync calistirin.

Yerel ortamda `gradle` veya `gradlew` bulunmadigi icin bu repoda komut satirindan derleme dogrulanamadi.

## Google Mobile Ads notu

Projede Google'in ornek test reklam kimlikleri kullaniliyor. Uygulamayi yayina almadan once bunlari kendi AdMob hesabinizdaki uretim kimlikleri ile degistirin.

## Release imzalama ve AAB

1. `android/keystore.properties.example` dosyasini `android/keystore.properties` olarak kopyalayin.
2. Kendi release keystore bilgilerinizle doldurun.
3. Keystore dosyanizi `android/` klasoru icine koyun veya `storeFile` alaninda tam yol verin.
4. Android Studio veya terminalden su komutu calistirin:

```bash
cd android
./gradlew bundleRelease
```

Olusan dosya:

```text
android/app/build/outputs/bundle/release/app-release.aab
```

Notlar:

- `keystore.properties` ve `.jks` dosyalari `.gitignore` icinde tutulur.
- Release signing ayari sadece `keystore.properties` varsa devreye girer.
- Android Gradle Plugin 8.x icin Java 17 veya ustu kullanmaniz gerekir.
