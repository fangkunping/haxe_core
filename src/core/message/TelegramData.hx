package core.message;

class TelegramData<T> {
	public var start_run_time:Float = 0;
	public var telegram:T;

	public function new(_telegram:T, _delay_time:Float) {
		this.telegram = _telegram;
		this.start_run_time = Common.time_stamp() + _delay_time;
	}

}
