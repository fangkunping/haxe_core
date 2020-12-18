package core;

import haxe.Timer;

class Common {
	// 返回时间戳 毫秒
	static public function time_stamp():Float {
		return Date.now().getTime();
	}

	// 返回时间戳 毫秒
	static public function getTimestamp():Float {
		return Date.now().getTime();
	}

	// 返回时间戳 秒
	static public function getTimestampSecond():Int {
		return Std.int(Timer.stamp());
	}

	// 读取field多个信息
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
}
