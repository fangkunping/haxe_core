package core.until.php;

import php.Syntax;

class ApcTools {
	/**
	 * Apc缓存-设置缓存
	 * 设置缓存key，value和缓存时间
	 * @param  string $key   KEY值
	 * @param  string $value 值
	 * @param  Int $time  缓存时间, 秒
	 */
	static public function setCache(key, value, time:Int = 0) {
		if (time == 0)
			time = null; // null情况下永久缓存
		return Syntax.code("apcu_store({0}, {1}, {2})", key, value, time);
	}

	/**
	 * Apc缓存-获取缓存
	 * 通过KEY获取缓存数据
	 * @param  string $key   KEY值
	 */
	static public function getCache(key) {
		return Syntax.code("apcu_fetch({0})", key);
	}

	/**
	 * Apc缓存-清除一个缓存
	 * 从memcache中删除一条缓存
	 * @param  string $key   KEY值
	 */
	static public function clear(key) {
		return Syntax.code("apcu_delete({0})", key);
	}

	/**
	 * Apc缓存-清空所有缓存
	 * 不建议使用该功能
	 * @return
	 */
	static public function clearAll() {
		return Syntax.code("apcu_clear_cache()"); // 清楚缓存
	}

	/**
	 * 检查APC缓存是否存在
	 * @param  string $key   KEY值
	 */
	static public function exists(key) {
		return Syntax.code("apcu_exists({0})", key);
	}

	/**
	 * 字段自增-用于记数
	 * @param string $key  KEY值
	 * @param int    $step 新增的step值
	 */
	static public function inc(key, step) {
		return Syntax.code("apcu_inc({0}, (int) {1})", key, step);
	}

	/**
	 * 字段自减-用于记数
	 * @param string $key  KEY值
	 * @param int    $step 新增的step值
	 */
	static public function dec(key, step) {
		return Syntax.code("apcu_dec({0}, (int) {1})", key, step);
	}

	/**
	 * 返回APC缓存信息
	 */
	static public function info() {
		return Syntax.code("apcu_cache_info()");
	}
}
