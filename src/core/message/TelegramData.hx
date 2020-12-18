package core.message;

class TelegramData {
	public var start_run_time:Float = 0;
	public var telegram:Dynamic;

	public function new(_telegram:Dynamic, _delay_time:Int) {
		this.telegram = _telegram;
		this.start_run_time = Common.time_stamp() + _delay_time;
	}

}
