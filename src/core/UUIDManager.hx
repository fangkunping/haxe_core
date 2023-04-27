package core;


interface I_UUIDGenerate<T> {
	function fetch():T;
	function fetchLastUUID():T;
}


class UUIDGenerateImpl_INT implements I_UUIDGenerate<Int> {
	var uuid:Int;
	var maxValue:Int;
	var minValue:Int;

	public function new(_minValue:Int = 1, _maxValue:Int = 900000000) {
		minValue = _minValue;
		uuid = minValue - 1;
		maxValue = _maxValue;
	}

	public function fetch() {
		if (uuid >= maxValue) {
			uuid = minValue - 1;
		}
		uuid++;
		return uuid;
	}

	public function fetchLastUUID() {
		return uuid;
	}
}
