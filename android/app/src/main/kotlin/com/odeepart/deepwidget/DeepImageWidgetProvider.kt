package com.odeepart.deepwidget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.BitmapShader
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.graphics.Shader
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File
import kotlin.math.roundToInt

class DeepImageWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val imagePath = widgetData.getString(IMAGE_KEY, null)
        val imageName = widgetData.getString(IMAGE_NAME_KEY, null)
            ?: context.getString(R.string.deep_widget_image_description)
        val borderRadiusPercent = widgetData
            .getInt(BORDER_RADIUS_KEY, DEFAULT_BORDER_RADIUS_PERCENT)
            .coerceIn(0, MAX_BORDER_RADIUS_PERCENT)
        val bitmap = decodeWidgetBitmap(imagePath, borderRadiusPercent)
        val launchIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
        )

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.deep_image_widget).apply {
                setOnClickPendingIntent(R.id.deep_widget_root, launchIntent)
                setContentDescription(R.id.deep_widget_image, imageName)

                if (bitmap != null) {
                    setImageViewBitmap(R.id.deep_widget_image, bitmap)
                    setViewVisibility(R.id.deep_widget_image, View.VISIBLE)
                    setViewVisibility(R.id.deep_widget_empty_state, View.GONE)
                } else {
                    setViewVisibility(R.id.deep_widget_image, View.GONE)
                    setViewVisibility(R.id.deep_widget_empty_state, View.VISIBLE)
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun decodeWidgetBitmap(imagePath: String?, borderRadiusPercent: Int): Bitmap? {
        if (imagePath.isNullOrBlank()) return null
        val imageFile = File(imagePath)
        if (!imageFile.isFile) return null

        return runCatching {
            val bounds = BitmapFactory.Options().apply {
                inJustDecodeBounds = true
            }
            BitmapFactory.decodeFile(imagePath, bounds)
            if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null

            var sampleSize = 1
            while (
                bounds.outWidth / sampleSize > MAX_DECODE_EDGE ||
                bounds.outHeight / sampleSize > MAX_DECODE_EDGE
            ) {
                sampleSize *= 2
            }

            val options = BitmapFactory.Options().apply {
                inSampleSize = sampleSize
                inPreferredConfig = Bitmap.Config.ARGB_8888
                inScaled = false
            }
            val decoded = BitmapFactory.decodeFile(imagePath, options) ?: return null
            val longestEdge = maxOf(decoded.width, decoded.height)
            val resized = if (longestEdge <= MAX_WIDGET_EDGE) {
                decoded
            } else {
                val scale = MAX_WIDGET_EDGE.toFloat() / longestEdge
                val targetWidth = (decoded.width * scale).roundToInt().coerceAtLeast(1)
                val targetHeight = (decoded.height * scale).roundToInt().coerceAtLeast(1)
                Bitmap.createScaledBitmap(decoded, targetWidth, targetHeight, true).also {
                    if (it !== decoded) decoded.recycle()
                }
            }
            roundBitmapCorners(resized, borderRadiusPercent)
        }.getOrNull()
    }

    private fun roundBitmapCorners(source: Bitmap, radiusPercent: Int): Bitmap {
        if (radiusPercent <= 0) return source

        val radius = minOf(source.width, source.height) * radiusPercent / 100f
        val rounded = Bitmap.createBitmap(
            source.width,
            source.height,
            Bitmap.Config.ARGB_8888,
        )
        val shader = BitmapShader(source, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply { this.shader = shader }
        Canvas(rounded).drawRoundRect(
            RectF(0f, 0f, source.width.toFloat(), source.height.toFloat()),
            radius,
            radius,
            paint,
        )
        source.recycle()
        return rounded
    }

    private companion object {
        const val IMAGE_KEY = "widget_image"
        const val IMAGE_NAME_KEY = "widget_image_name"
        const val BORDER_RADIUS_KEY = "widget_border_radius_percent"
        const val DEFAULT_BORDER_RADIUS_PERCENT = 12
        const val MAX_BORDER_RADIUS_PERCENT = 50
        const val MAX_WIDGET_EDGE = 900
        const val MAX_DECODE_EDGE = MAX_WIDGET_EDGE * 2
    }
}
