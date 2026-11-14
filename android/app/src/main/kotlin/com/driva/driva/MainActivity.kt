package com.driva.driva

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.BatteryManager
import android.os.Environment
import android.os.StatFs
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "driva/device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getBatteryHealth" -> handleBattery(result)
                    "getStorageStats" -> handleStorage(result)
                    "getAppList" -> handleAppList(result)
                    "cleanCache" -> handleCleanCache(call, result)
                    "openAppSettings" -> handleOpenAppSettings(call, result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun ok(data: Map<String, Any>) =
        mapOf("ok" to true, "data" to data, "error" to null)

    private fun fail(message: String) =
        mapOf("ok" to false, "data" to null, "error" to message)

    private fun handleBattery(result: MethodChannel.Result) {
        val bm = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val level = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val temp = readBatteryTemperature()
        val status = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_STATUS)
        val charging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                status == BatteryManager.BATTERY_STATUS_FULL
        runOnUiThread {
            result.success(ok(mapOf(
                "level" to level,
                "charging" to charging,
                "temperature_c" to temp
            )))
        }
    }

    private fun readBatteryTemperature(): Double = try {
        val intent = registerReceiver(
            null,
            android.content.IntentFilter(android.content.Intent.ACTION_BATTERY_CHANGED)
        )
        val raw = intent?.getIntExtra(android.os.BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0
        // EXTRA_TEMPERATURE is in tenths of a degree Celsius
        raw / 10.0
    } catch (e: Exception) {
        0.0
    }

    private fun handleStorage(result: MethodChannel.Result) {
        try {
            val stat = StatFs(Environment.getDataDirectory().path)
            val total = stat.totalBytes
            val free = stat.availableBytes
            val appCache = computeTotalAppCache()
            runOnUiThread {
                result.success(ok(mapOf(
                    "total" to total,
                    "free" to free,
                    "cached" to 0,
                    "appCache" to appCache
                )))
            }
        } catch (e: Exception) {
            runOnUiThread { result.success(fail(e.message ?: "storage error")) }
        }
    }

    private fun handleAppList(result: MethodChannel.Result) {
        try {
            val pm = packageManager
            val launcherIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
            val resolveInfos = pm.queryIntentActivities(launcherIntent, PackageManager.MATCH_ALL)

            val installed = resolveInfos
                .mapNotNull { ri ->
                    val ai = ri.activityInfo ?: return@mapNotNull null
                    try {
                        mapOf(
                            "package" to ai.packageName,
                            "label" to ri.loadLabel(pm).toString(),
                            "cacheBytes" to (((ai.applicationInfo)?.let { cacheDirFor(it) })?.let { dirSize(it) } ?: 0L)
                        )
                    } catch (e: Exception) {
                        null
                    }
                }
                .distinctBy { it["package"] }
                .sortedByDescending { (it["cacheBytes"] as Long?) ?: 0L }
            runOnUiThread {
                result.success(ok(mapOf("apps" to installed)))
            }
        } catch (e: Exception) {
            runOnUiThread { result.success(fail(e.message ?: "apps error")) }
        }
    }

    private fun handleCleanCache(call: MethodCall, result: MethodChannel.Result) {
        val packages = (call.argument<List<String>>("packages") ?: emptyList()).toSet()
        var freed = 0L
        var cleaned = 0
        try {
            val pm = packageManager
            val targets = pm.getInstalledApplications(0).filter {
                it.flags and ApplicationInfo.FLAG_SYSTEM == 0 && packages.contains(it.packageName)
            }
            for (app in targets) {
                val dir = cacheDirFor(app)
                if (dir != null && dir.exists()) {
                    val before = dirSize(dir)
                    deleteRecursive(dir)
                    freed += maxOf(0, before - dirSize(dir))
                    if (before > 0 && freedChange(before, app) > 0) cleaned++
                }
            }
            // Caché de la propia app siempre se limpia sin restricciones.
            val ownCache = cacheDir
            if (ownCache != null && ownCache.exists()) {
                val before = dirSize(ownCache)
                deleteRecursive(ownCache)
                val after = dirSize(ownCache)
                freed += maxOf(0, before - after)
                if (before > 0 && before - after > 0) cleaned++
            }
        } catch (e: Exception) {
            // No fatal.
        }
        runOnUiThread {
            result.success(ok(mapOf(
                "freedBytes" to freed,
                "appsCleaned" to cleaned
            )))
        }
    }

    private fun handleOpenAppSettings(call: MethodCall, result: MethodChannel.Result) {
        val packageName = call.argument<String>("package")
        if (packageName.isNullOrEmpty()) {
            runOnUiThread { result.success(fail("package required")) }
            return
        }
        try {
            val intent = Intent(
                Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                Uri.parse("package:$packageName")
            )
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            runOnUiThread { result.success(ok(mapOf("opened" to true))) }
        } catch (e: Exception) {
            runOnUiThread { result.success(fail(e.message ?: "cannot open settings")) }
        }
    }

    private fun freedChange(before: Long, app: ApplicationInfo): Long = before

    private fun cacheDirFor(app: ApplicationInfo): File? = try {
        File(app.sourceDir).parentFile?.let { base ->
            val cache = File(base, "cache")
            if (cache.exists()) cache else null
        }
    } catch (e: Exception) {
        null
    }

    private fun computeTotalAppCache(): Long =
        try {
            val pm = packageManager
            val launcherIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
            pm.queryIntentActivities(launcherIntent, PackageManager.MATCH_ALL)
                .mapNotNull { ri ->
                    ri.activityInfo?.let { ai ->
                        try { pm.getPackageInfo(ai.packageName, 0).applicationInfo } catch (_: Exception) { null }
                    }
                }
                .mapNotNull { cacheDirFor(it) }
                .distinct()
                .sumOf { dirSize(it) }
        } catch (e: Exception) {
            0L
        }

    private fun dirSize(dir: File): Long = try {
        dir.walkTopDown().filter { it.isFile }.sumOf { it.length() }
    } catch (e: Exception) {
        0L
    }

    private fun deleteRecursive(file: File) {
        file.walkBottomUp().forEach { it.delete() }
    }
}
