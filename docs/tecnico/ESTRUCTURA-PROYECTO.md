# Estructura de carpetas del proyecto Flutter + Driva

## Documentos (docs/)
```
docs/
  DIAGNOSTICO-MVP.md        # arquitectura, modelos, UI, contrato channel
  KOTLIN-METHODCHANNEL.md   # API Kotlin del canal driva/device
  ESTRUCTURA-PROYECTO.md    # este archivo
```

## App (se generará con `flutter create`)
```
lib/
  main.dart                     # entry point
  core/
    device_channel.dart         # wrapper del MethodChannel "driva/device"
    models/
      battery_health.dart
      storage_stats.dart
      app_info.dart
      cleanup_result.dart
  services/
    device_health_service.dart  # orquesta getBatteryHealth/getStorageStats
    cleanup_service.dart        # orquesta getAppList/cleanCache
  state/
    dashboard_providers.dart    # riverpod providers
  ui/
    dashboard_screen.dart       # home principal
    widgets/
      battery_card.dart
      storage_card.dart
      app_list_tile.dart
    result_dialog.dart          # "Liberaste X MB" antes/después
android/
  app/src/main/kotlin/.../MainActivity.kt   # MethodChannel Kotlin
```

> La estructura precisa de `android/` la genera `flutter create`; aquí solo se
> documenta dónde vive el código nativo.
