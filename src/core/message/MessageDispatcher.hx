package core.message;

using Lambda;

class MessageDispatcher<T> {
	public var events:Map<String, Array<EventData<T>>>;
	public var telegrams:Map<String, Array<TelegramData<T>>>;
	public var event_uuid:Int = 0;
	public var maxClearMount:Int = 50;

	private var clearCount:Int = 0;

	public function new() {
		this.events = new Map();
		this.telegrams = new Map();
	}

	/**
		### 注册

		*  _event_name: 事件名
		*  _call_fn: 回调函数
		*  _call_amount: 调用次数, <= 0 表示无限次调用，缺省为0

	**/
	public function register(_event_name:String, _call_fn:T->Void, _call_amount:Int = 0):Int {
		var event_datas:Array<EventData<T>> = get_event_datas(_event_name);
		event_uuid++;
		event_datas.push(new EventData(event_uuid, _call_fn, _call_amount));
		this.events.set(_event_name, event_datas);
		return event_uuid;
	}

	/**
		## 注销

		*  _event_name：事件名
		*  _uuid：注册时返回的唯一ID
	**/
	public function unregister(_event_name:String, _uuid:Int) {
		if (this.events.exists(_event_name)) {
			this.events.set(_event_name, get_event_datas(_event_name).filter((e:EventData<T>) -> {
				return e.uuid != _uuid;
			}));
		}
	}

	/**
		##发送事件

		*  _event_name: 事件名
		*  _telegram: 信息
		*  _delay_time: 延迟发送的时间, 毫秒，缺省为0
	**/
	public function send(_event_name:String, _telegram:T, _delay_time:Float = 0) {
		// 立即发送
		if (_delay_time <= 0) {
			this.broadcast(_event_name, _telegram);
		} else {
			var telegram_datas:Array<TelegramData<T>> = if (this.telegrams.exists(_event_name)) {
				this.telegrams[_event_name];
			} else {
				new Array();
			}
			telegram_datas.push(new TelegramData(_telegram, _delay_time));
			this.telegrams.set(_event_name, telegram_datas);
		}
	}

	// 更新
	public function update() {
		final now = Common.time_stamp();
		for (_event_name => _telegram_data in this.telegrams) {
			this.telegrams.set(_event_name, _telegram_data.filter((e:TelegramData<T>) -> {
				// 超过待发送时间, 就向事件队列 广播事件
				if (now >= e.start_run_time) {
					this.broadcast_and_fliter(_event_name, e.telegram);
					return false;
				} else {
					return true;
				}
			}));
		}
		// 清理
		clearCount++;
		if (clearCount > maxClearMount) {
			clearCount = 0;
			clearNotExistEvents();
			clearNotExistTelegams();
		}
	}

	// 向事件监听者广播事件信息
	private function broadcast(_event_name:String, _telegram:T) {
		get_event_datas(_event_name).foreach((e:EventData<T>) -> {
			e.callback_fn(_telegram);
			return true;
		});
	}

	// 广播 并 剔除事件接收次数为0的监听器
	private function broadcast_and_fliter(_event_name:String, _telegram:T) {
		var event_datas:Array<EventData<T>> = get_event_datas(_event_name).filter((e:EventData<T>) -> {
			e.callback_fn(_telegram);
			e.call_amount_down();
			return !e.can_remove();
		});
		this.events[_event_name] = event_datas;
	}

	// 获取事件名对应的事件列表
	private function get_event_datas(_event_name:String):Array<EventData<T>> {
		return if (this.events.exists(_event_name)) {
			this.events[_event_name];
		} else {
			new Array();
		};
	}

	private function clearNotExistEvents() {
		for (key in this.events.keys()) {
			if (this.events.get(key).length == 0)
				this.events.remove(key);
		}
	}

	private function clearNotExistTelegams() {
		for (key in this.telegrams.keys()) {
			if (this.telegrams.get(key).length == 0)
				this.telegrams.remove(key);
		}
	}
}
