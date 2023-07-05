package core;

import haxe.Timer;

class Common {
	// 返回时间戳 毫秒
	static public function time_stamp():Float {
		return getTimestamp();
	}

	// 返回时间戳 毫秒
	static public function getTimestamp():Float {
		#if js
		return js.lib.Date.now();
		#else
		return Sys.time() * 1000;
		#end
	}

	// 返回时间戳 秒
	static public function getTimestampSecond():Int {
		return Std.int(getTimestamp() / 1000);
	}

	/**
	 * [读取field多个信息]
	 * @param o 
	 * @param keys 键的数组
	 * @param def 找不到时返回的数据
	 * @return Dynamic
	 */
	static public function getField<T>(o:Dynamic, keys:Array<String>, def:T = null):Dynamic {
		var sub_obj = o;
		for (key in keys) {
			if (Reflect.hasField(sub_obj, key)) {
				sub_obj = Reflect.field(sub_obj, key);
			} else {
				return def;
			}
		}
		return sub_obj;
	}

	// Dynamic -> uriQuery
	static public function formatUrlQuery(d:Dynamic):String {
		var r:Array<String> = new Array();
		var fields = Reflect.fields(d);
		for (field in fields) {
			r.push('${field}=${StringTools.urlEncode(Std.string(Reflect.field(d, field)))}');
		}
		return r.join("&");
	}

	/**
	 * [格式化浮点数]
	 * 格式化会四舍五入。
	 * @param _n 
	 * @param prec 保留小数点后几位 
	 */
	public static function floatToStringPrecision(_n:Float, prec:Int) {
		if (prec == 0) {
			return Std.string(Math.round(_n));
		}
		var n = Math.round(_n * Math.pow(10, prec));
		var str = '' + n;
		var len = str.length;
		if (len <= prec) {
			while (len < prec) {
				str = '0' + str;
				len++;
			}
			return '0.' + str;
		} else {
			return str.substr(0, str.length - prec) + '.' + str.substr(str.length - prec);
		}
	}

	public static function concatDynamic(fromObj:Dynamic, toObj:Dynamic, isReplace:Bool = true) {
		for (key in Reflect.fields(fromObj)) {
			if (isReplace == false && Reflect.hasField(toObj, key))
				continue;
			Reflect.setField(toObj, key, Reflect.field(fromObj, key));
		}
	}
}
