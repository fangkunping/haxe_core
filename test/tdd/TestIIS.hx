package tdd;

import core.tdd.Assert;
import tdd.controller.TestController;
import core.emu.IIS;

class TestIIS {
	public function new() {}

	public function run() {
		test1();
	}

	// 测试 request 数据
	private function test1() {
		IIS.start(new Setting().setRouterClass([
			"tdd.controller.TestController", 
			"server.controller.EquipController"
		]).setRequestType(IIS_REQUEST_TYPE.CALLBACK));

		// 延迟发送，需要emu.IIS.update(); 见tdd.Main.hx
		IIS.request("tdd/test", {name: "Max", age: 41}, (v : String) -> {
			new Assert().equip("Hello, My name is Max, I am 41 years old", v);
		}, IIS_REQUEST_TYPE.EVENT);
		// 使用iis配置项 IIS_REQUEST_TYPE.CALLBACK 立即发送
		IIS.request("tdd/test", {name: "Max", age: 42}, (v:String) -> {
			new Assert().equip("Hello, My name is Max, I am 42 years old", v);
		});
		// var router = new Router();
		// {tdd/test => { method : getName, class_name : tdd.controller.TestController }}
		// router.setRouterClass();
		// router.post(, "");
	}
}
