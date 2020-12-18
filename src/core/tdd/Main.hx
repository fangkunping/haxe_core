package core.tdd;

import haxe.Unserializer;
import haxe.Serializer;


class Main {
	#if unity
	@:functionCode("UnityEngine.Debug.Log(v);")
	static public function trace_test(v:Dynamic, ?infos:haxe.PosInfos):Void {}
	#end

	static public function main() {
		#if unity
		haxe.Log.trace = trace_test;
		#end
		trace(Type.resolveClass("tdd.A"));
		var a = Type.createInstance(Type.resolveClass("tdd.A"), []);
		var fn = Reflect.field(a, "run");
		var s:String = Reflect.callMethod(a, fn, []);
		trace(s);
		trace(Serializer.run(a));
		trace(cast(Unserializer.run(Serializer.run(a)), tdd.A).run());

		trace("==== start tdd ====");
		new TestIIS().run();
		new TestMessageDispatcher().run();
		trace("==== end tdd ====");
		trace(10 * (1.0 + 20 / 10000.0));
		core.emu.IIS.update();
	}
}

class A {
	public var i = 10;

	public function new() {}

	public function run():String {
		return "I am in A!";
	}
}
