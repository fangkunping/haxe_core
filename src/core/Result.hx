package core;

class Result<T> {
	static public function err<T>(err_data:T) {
		var r = new Result<T>();
		r.setErr(err_data);
		return r;
	}

	static public function ok<T>(result_data:T) {
		var r = new Result<T>();
		r.setOk(result_data);
		return r;
	}

	public function new() {}

	public var isOk(default,null):Bool = false;
	public var isErr(default,null):Bool = false;
	private var data:T = null;

	public function setOk(d:T) {
		data = d;
		isOk = true;
		isErr = false;
	}

	public function setErr(err:T) {
		data = err;
		isErr = true;
		isOk = false;
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
