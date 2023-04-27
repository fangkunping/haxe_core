package core;

class Result<T> {
	static public function err<T>(err_data:T, errCode:Int = -1, errMessage:String = "") {
		var r = new Result<T>();
		r.setErr(err_data, errCode, errMessage);
		return r;
	}

	static public function ok<T>(result_data:T) {
		var r = new Result<T>();
		r.setOk(result_data);
		return r;
	}

	public function new() {}

	public var isOk(default, null):Bool = false;
	public var isErr(default, null):Bool = false;
	public var errCode:Int = -1;
	public var errMessage:String = "";

	private var data:T = null;

	public function setOk(d:T) {
		data = d;
		isOk = true;
		isErr = false;
		errCode = 0;
	}

	public function setErr(err:T, _errCode:Int = -1, _errMessage:String = "") {
		data = err;
		isErr = true;
		isOk = false;
		errCode = _errCode;
		errMessage = _errMessage;
	}

	public function getErrCode():Int {
		return errCode;
	}

	public function getErrMessage():String {
		return errMessage;
	}

	// 返回内容值

	public function unwrap() {
		return data;
	}

	public function bind(fn:T->Result<T>):Result<T> {
		if (isOk) {
			return fn(data);
		} else {
			return this;
		}
	}
}
