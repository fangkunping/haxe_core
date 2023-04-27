package core.tdd;

import haxe.PosInfos;

// import haxe.CallStack;
class Assert<T> {
	/**
		```haxe
		Assert.eq(10, 10);
		```
	**/
	static public function eq<T>(v1:T, v2:T, ?pos:PosInfos) {
		new Assert<T>().equip(v1, v2, pos);
	}

	static public var logFn:Dynamic->Void = (s:Dynamic) -> {
		trace(s);
	}

	public function new() {}

	public function equip(v1:T, v2:T, ?pos:PosInfos) {
		if (v1 != v2) {
			// trace(CallStack.toString(CallStack.callStack()));
			logFn('FileName: ${pos.fileName}');
			logFn('Class Name: ${pos.className}');
			logFn('Method Name: ${pos.methodName}');
			logFn('LineNumber: ${pos.lineNumber}');
			logFn(' ~~ ${v1} ~~ /= ~~ ${v2} ~~');
		}
	}
}
