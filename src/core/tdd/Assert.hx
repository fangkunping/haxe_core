package core.tdd;

import haxe.PosInfos;
//import haxe.CallStack;

class Assert<T> {
	/**
		```haxe
		Assert.eq(10, 10);
		```
	**/
	static public function eq<T>(v1:T, v2:T,?pos:PosInfos){
		new Assert<T>().equip(v1, v2, pos);
	}
	public function new() {}

	public function equip(v1:T, v2:T,?pos:PosInfos) {
		if (v1 != v2) {
			// trace(CallStack.toString(CallStack.callStack()));
			trace('FileName: ${pos.fileName}');
			trace('Class Name: ${pos.className}');
			trace('Method Name: ${pos.methodName}');
			trace('LineNumber: ${pos.lineNumber}');
			trace(' ~~ ${v1} ~~ /= ~~ ${v2} ~~');
		}
	}
}
