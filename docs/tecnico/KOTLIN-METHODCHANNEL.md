# API de Method Channel Android (Kotlin) — Driva MVP

> Implementación nativa del canal `driva/device`.
> Este documento define la estructura Kotlin que se implementará
> en `android/app/src/main/kotlin/.../MainActivity.kt` (o un `handler` aparte).

---

## Registro del canal

```kotlin
// En MainActivity o un Plugin dedicado
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "driva/device"
    ).setMethodCallHandler { call, result ->
        when (call.method) {
            "getBatteryHealth"  -> handleBattery(result)
            "getStorageStats"   -> handleStorage(result)
            "getAppList"        -> handleAppList(result)
            "cleanCache"        -> handleCleanCache(call, result)
            else                -> result.notImplemented()
        }
    }
}
```

---

## Handlers

### getBatteryHealth
```kotlin
private fun handleBattery(result: MethodChannel.Result) {
    val bm = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    val level = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    val temp = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_TEMPERATURE) / 10.0
    val charging = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS)
        == BatteryManager.BATTERY_STATUS_CHARGING
    result.success(ok(mapOf(
        "level" to level,
        "charging" to charging,
        "temperature_c" to temp
    )))
}
```

### getStorageStats
```kotlin
private fun handleStorage(result: MethodChannel.Result) {
    val stat = StatFs(Environment.getDataDirectory().path)
    val total = stat.totalBytes
    val free = stat.availableBytes
    // appCache = suma de caché de apps instaladas (vía PackageManager)
    result.success(ok(mapOf(
        "total" to total,
        "free" to free,
        "cached" to 0,          // placeholder
        "appCache" to 0         // placeholder
    )))
}
```

### getAppList
```kotlin
private fun handleAppList(result: MethodChannel.Result) {
    val pm = packageManager
    val apps = pm.getInstalledApplications(0)
        .filter { it.flags and ApplicationInfo.FLAG_SYSTEM == 0 } // solo de terceros
        .map { app ->
            mapOf(
                "package" to app.packageName,
                "label" to pm.getApplicationLabel(app).toString(),
                "cacheBytes" to app.manageSpaceActivityName // placeholder
            )
        }
    result.success(ok(mapOf("apps" to apps)))
}
```

### cleanCache
```kotlin
private fun handleCleanCache(call: MethodChannel.Result, result: MethodChannel.Result) {
    // Limpiar caché exige acceso a filesDir/cache + Storage Manager
    // Incluye callback (result) asíncrono con freedBytes.
    // (Implementación detallada al codear, requiere StorageManager API 30+,
    //  o deleteCacheDir por app con reflection.)
}
```

---

## Envelope común
```kotlin
private fun ok(data: Map<String, Any>) = mapOf("ok" to true, "data" to data, "error" to null)
private fun fail(msg: String) = mapOf("ok" to false, "data" to null, "error" to msg)
```

---

## Consideraciones / pendientes nativos

- **Limpieza real de caché de apps de terceros** es restringido en Android moderno:
  - Android 11+ (API 30): `StorageManager` / `ACCESS_FILES_MANAGER` para juntar
    archivos `.cache`; limpieza por app requiere `Context.deleteSharedPreferences`
    o confirmación del usuario (intent).
  - Placeholder definido: hay que validar el enfoque permitido por políticas.
- **Temperatura** disponible vía `BatteryManager.BATTERY_PROPERTY_TEMPERATURE`.
- Claros principios: no prometer "liberación de RAM" (no es real ni permitido).
