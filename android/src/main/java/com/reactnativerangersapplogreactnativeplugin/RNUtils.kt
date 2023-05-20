package com.reactnativerangersapplogreactnativeplugin

import androidx.annotation.Nullable

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableType
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeArray
import com.facebook.react.bridge.WritableNativeMap

import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

/**
 *
 * @param jsonObject
 * @return map
 * @throws JSONException
 */
@Throws(JSONException::class)
fun convertJsonToMap(jsonObject: JSONObject): WritableMap {
    val map: WritableMap = WritableNativeMap()
    val iterator = jsonObject.keys()
    while (iterator.hasNext()) {
        val key = iterator.next()
        when (val value = jsonObject[key]) {
            is JSONObject -> {
                map.putMap(key, convertJsonToMap(value))
            }

            is JSONArray -> {
                map.putArray(key, convertJsonToArray(value))
            }

            is Boolean -> {
                map.putBoolean(key, value)
            }

            is Int -> {
                map.putInt(key, value)
            }

            is Double -> {
                map.putDouble(key, value)
            }

            is String -> {
                map.putString(key, value)
            }

            else -> {
                map.putString(key, value.toString())
            }
        }
    }
    return map
}

/**
 *
 * @param jsonArray
 * @return
 * @throws JSONException
 */
@Throws(JSONException::class)
fun convertJsonToArray(jsonArray: JSONArray): WritableArray {
    val array: WritableArray = WritableNativeArray()
    for (i in 0 until jsonArray.length()) {
        when (val value = jsonArray[i]) {
            is JSONObject -> {
                array.pushMap(convertJsonToMap(value))
            }

            is JSONArray -> {
                array.pushArray(convertJsonToArray(value))
            }

            is Boolean -> {
                array.pushBoolean(value)
            }

            is Int -> {
                array.pushInt(value)
            }

            is Double -> {
                array.pushDouble(value)
            }

            is String -> {
                array.pushString(value)
            }

            else -> {
                array.pushString(value.toString())
            }
        }
    }
    return array
}

/**
 *
 * @param readableMap
 * @return
 * @throws JSONException
 */
@Throws(JSONException::class)
fun convertMapToJson(readableMap: ReadableMap?): JSONObject? {
    val jsonObject = JSONObject()
    if (readableMap == null) {
        return null
    }
    val iterator = readableMap.keySetIterator()
    if (!iterator.hasNextKey()) {
        return null
    }
    while (iterator.hasNextKey()) {
        val key = iterator.nextKey()
        val readableType = readableMap.getType(key)
        try {
            when (readableType) {
                ReadableType.Null -> jsonObject.put(key, null)
                ReadableType.Boolean -> jsonObject.put(key, readableMap.getBoolean(key))
                ReadableType.Number -> jsonObject.put(key, readableMap.getDouble(key))
                ReadableType.String -> jsonObject.put(key, readableMap.getString(key))
                ReadableType.Map -> jsonObject.put(key, convertMapToJson(readableMap.getMap(key)))
                ReadableType.Array -> jsonObject.put(
                    key,
                    convertArrayToJson(readableMap.getArray(key))
                )

                else -> {
                }
            }
        } catch (_: JSONException) {
        }
    }
    return jsonObject
}

/**
 *
 * @param readableArray
 * @return
 * @throws JSONException
 */
@Throws(JSONException::class)
fun convertArrayToJson(readableArray: ReadableArray?): JSONArray {
    val array = JSONArray()
    for (i in 0 until readableArray!!.size()) {
        when (readableArray.getType(i)) {
            ReadableType.Null -> {
            }

            ReadableType.Boolean -> array.put(readableArray.getBoolean(i))
            ReadableType.Number -> array.put(readableArray.getDouble(i))
            ReadableType.String -> array.put(readableArray.getString(i))
            ReadableType.Map -> array.put(convertMapToJson(readableArray.getMap(i)))
            ReadableType.Array -> array.put(convertArrayToJson(readableArray.getArray(i)))
        }
    }
    return array
}

/**
 *
 * @param readableArray
 * @return WritableArray
 */
fun convertReadableArrayToWritableArray(@Nullable readableArray: ReadableArray?): WritableArray {
    val array: WritableArray = Arguments.createArray()
    if (null == readableArray) {
        return array
    }
    loop@ for (i in 0 until readableArray.size()) {
        when (readableArray.getType(i)) {
            ReadableType.Null -> continue@loop
            ReadableType.Boolean -> array.pushBoolean(readableArray.getBoolean(i))
            ReadableType.Number -> array.pushDouble(readableArray.getDouble(i))
            ReadableType.String -> array.pushString(readableArray.getString(i))
            ReadableType.Map -> array.pushMap(convertReadableMapToWritableMap(readableArray.getMap(i)))
            ReadableType.Array -> array.pushArray(
                convertReadableArrayToWritableArray(
                    readableArray.getArray(
                        i
                    )
                )
            )
        }
    }
    return array
}

/**
 *
 * @param readableMap
 * @return WritableMap
 */
fun convertReadableMapToWritableMap(@Nullable readableMap: ReadableMap?): WritableMap {
    val map: WritableMap = Arguments.createMap()
    if (null == readableMap) {
        return map
    }
    val iterator = readableMap.keySetIterator()
    loop@ while (iterator.hasNextKey()) {
        val key = iterator.nextKey()
        when (readableMap.getType(key)) {
            ReadableType.Null -> continue@loop
            ReadableType.Boolean -> map.putBoolean(key, readableMap.getBoolean(key))
            ReadableType.String -> map.putString(key, readableMap.getString(key))
            ReadableType.Number -> map.putDouble(key, readableMap.getDouble(key))
            ReadableType.Map -> map.putMap(
                key,
                convertReadableMapToWritableMap(readableMap.getMap(key))
            )

            ReadableType.Array -> map.putArray(
                key,
                convertReadableArrayToWritableArray(readableMap.getArray(key))
            )
        }
    }
    return map
}