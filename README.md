# Driva

App Android de **higiene digital**: mide el estado real de la batería y el
almacenamiento, guía la limpieza de caché app por app y registra cuánto espacio
se ha liberado de verdad. Sin promesas mágicas de velocidad.

> Estado: **MVP completado** (fase 1). Todavía no está publicada en Google Play.

## Stack

- Flutter + Material 3 (seed `#00B894`)
- Kotlin nativo mediante `MethodChannel('driva/device')`
- Riverpod para el estado

## Estructura

```
android/        Proyecto Android + canales nativos (MainActivity.kt)
lib/            Código Dart: modelos, servicios, estado y UI
test/           Tests de widgets
docs/           Landing pública (GitHub Pages) y documentación técnica
docs/tecnico/   Diagnóstico, estructura y Method Channel
```

La landing se publica en **https://arzaganahil.github.io/Driva/** desde
`docs/` con el workflow `.github/workflows/pages.yml`.

## Por qué la limpieza es guiada

Desde Android 11 (y de forma definitiva en Android 16 / SDK 36) el sistema
impide que una app de terceros lea o borre la caché de otras apps. Verificado en
un dispositivo real con ADB: `Permission denied`. Driva no simula esa limpieza:
abre los Ajustes de cada app, pide los MB liberados y construye un historial
honesto.

## Desarrollo

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Requisitos locales (no versionados): `android/local.properties` con la ruta del
SDK de Android.
