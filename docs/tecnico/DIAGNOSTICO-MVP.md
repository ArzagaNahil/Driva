# Diseño estructural del MVP — Driva

> Blueprint del MVP: limpieza de caché + reporte de batería.
> Precede a la instalación de Flutter/SDK.

---

## 1. Arquitectura de capas

```
+----------------------------------------------------------+
|                      UI (Flutter/Dart)                    |
|   Pantallas, widgets, "antes vs después", gráfico bat.    |
|                        riverpod (estado)                   |
+----------------------------------------------------------+
                    |          |
          via Provider          via MethodChannel
                    v          v
+----------------------------------------------------------+
|               Lógica de dominio / servicios                |
|   DeviceHealthService, CleanupService (Dart)              |
|   Orquestan llamadas nativas y transforman datos          |
+----------------------------------------------------------+
                    |
            MethodChannel ("driva/device")
                    |
                    v
+----------------------------------------------------------+
|            Capa nativa Android (Kotlin)                    |
|   Si / LibreoRealCache, BatteryManager, StatFs, ...        |
|   Acceso a APIs del dispositivo que Dart no expone        |
+----------------------------------------------------------+
```

### Flujo de datos
1. Dart solicita datos nativos vía `MethodChannel("driva/device")`.
2. Kotlin ejecuta la API correspondiente y devuelve un `Map`/`JSON`.
3. Dart convierte a modelos tipados (`DeviceHealth`, `CleanupResult...`).
4. riverpod expone el estado a la UI; la UI reacciona.

---

## 2. Contrato de Method Channel "driva/device"

### Métodos (nombre `method` → argumentos → respuesta)

| Method | Args | Respuesta (Map) |
|--------|------|-----------------|
| `getBatteryHealth` | — | `level: int (0-100)`, `charging: bool`, `temperature_c: double` |
| `getStorageStats` | — | `total: int (bytes)`, `free: int`, `cached: int`, `appCache: int` |
| `getAppList` | — | `apps: [{package, label, cacheBytes}]` |
| `cleanCache` | lista de paquetes | `freedBytes: int` |

### Diseño del payload (respuesta unificada)
Todas las respuestas usan un envelope común para errores:
```json
{
  "ok": true,
  "data": { ... },
  "error": null
}
```
En fallo: `"ok": false`, `"error": "mensaje"`.

---

## 3. Modelos de datos (Dart)

```dart
class BatteryHealth {
  final int level;          // 0-100
  final bool charging;
  final double temperatureC;
}

class StorageStats {
  final int totalBytes;
  final int freeBytes;
  final int cacheBytes;     // caché del sistema
  final int appCacheBytes;  // caché de apps de terceros
  int get usedBytes => totalBytes - freeBytes;
}

class AppInfo {
  final String package;
  final String label;
  final int cacheBytes;
}

class CleanupResult {
  final int freedBytes;
  final int appsCleaned;
}
```

---

## 4. Pantallas / flujo de la UI

1. **Home / Dashboard**
   - Tarjeta de batería (nivel %, temperatura, estado de carga).
   - Tarjeta de almacenamiento (ocupado / libre / caché).
   - Botón principal **"Limpiar caché"** (accion central).
   - "Antes vs después" (almacenamiento libre actual vs tras limpiar).

2. **Detalle de memoria**
   - Lista de apps ordenadas por tamaño de caché.
   - Checkbox de selección -> limpiar seleccionadas.

3. **Resultado**
   - Toast/Panel "Liberaste X MB" + diff visual antes/después.

### Navegación
- 1 sola vista principal (Dashboard) con sección expandible de apps.
- Diálogo de resultado tras la limpieza.

---

## 5. Permisos requeridos (Android)

- Acceso a **storage/caché** del dispositivo (para calcular y limpiar).
- Claros de política: transparente sobre qué se limpiará.

---

## 6. Fuera de alcance del MVP (Fase 1+)

- Control de datos móviles por app.
- Mantenimiento programado (background).
- Suscripción/paywall.
- iOS (se agrega luego con Method Channel nativo a Swift).
- Gráficas avanzadas de batería.
