package core.message;


class EventData<T> {
	public var uuid:Int = 0;
	public var callback_fn:T->Void;
	public var call_amount:Int = 0;
	public var type:EventDataType;

	public function new(_uuid:Int, _callback_fn:T->Void, _call_amount:Int) {
		this.uuid = _uuid;
		this.callback_fn = _callback_fn;
		this.call_amount = _call_amount;
		this.type = if (_call_amount < 1) {
			EventDataType.Loop;
		} else {
			EventDataType.Count;
		}
	}

	public function call_amount_down() {
		if (this.type == EventDataType.Count) {
			this.call_amount--;
		}
	}

	public function can_remove():Bool {
		return if (this.type == EventDataType.Count && this.call_amount < 1) {
			true;
		} else {
			false;
		}
	}
}

enum EventDataType {
	Loop;
	Count;
}
