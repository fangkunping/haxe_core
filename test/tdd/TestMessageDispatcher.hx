package tdd;

import core.tdd.Assert;
import core.message.MessageDispatcher;

class TestMessageDispatcher {
	public function new() {}

	public function run() {
		test1();
		test2();
		test3();
		// 重复接收信息, 注册事件时加上重复次数, 检测, 信息接收n次后, 事件列表为空
		// 循环接收信息, 注册事件时无限次数, 检测, 信息接收n次后, 事件列表仍然存在
	}

	// 注册, 检测注册的事件名和回调函数
	// 注销, 检测注销后的事件是否存在
	private function test1() {
		// 准备回调函数
		final event_fn:Dynamic->Void = create_callback_fn();

		final message_dispatcher = new MessageDispatcher<Dynamic>();
		final uuid = message_dispatcher.register("on_test1", event_fn);
		new Assert().equip(is_event_in_message_dispatcher(message_dispatcher, "on_test1", uuid), true);

		message_dispatcher.unregister("on_test_not_exist", uuid);
		new Assert().equip(is_event_in_message_dispatcher(message_dispatcher, "on_test1", uuid), true);

		message_dispatcher.unregister("on_test1", uuid);
		new Assert().equip(is_event_in_message_dispatcher(message_dispatcher, "on_test1", uuid), false);
	}

	// 发送信息, 检测接收到信息, 检测信息列表已经为空,
	private function test2() {
		// 准备回调函数
		final event_fn:Dynamic->Void = (e:Dynamic) -> {
			new Assert<String>().equip(e, test_msg1);
		};
		// 准备事件
		final telegram:Dynamic = create_telegram1();
		// 注册
		final message_dispatcher = new MessageDispatcher();
		final uuid = message_dispatcher.register("on_test2", event_fn);
		// 发送
		message_dispatcher.send("on_test2", create_telegram1());
		new Assert().equip(is_telegram_in_message_dispatcher(message_dispatcher, "on_test2"), false);
	}

	// 延迟发送信息, 检测指定时间后 接收到信息, 检测信息列表已经为空
	private function test3() {
		// 准备回调函数
		final event_fn:Dynamic->Void = (e:Dynamic) -> {

			new Assert<String>().equip(e, test_msg1);
		};
		// 准备事件
		final telegram:Dynamic = create_telegram1();
		// 注册
		final message_dispatcher = new MessageDispatcher();
		final uuid = message_dispatcher.register("on_test3", event_fn);
		// 一秒 后 发送
		message_dispatcher.send("on_test3", create_telegram1(), 500);
		new Assert().equip(is_telegram_in_message_dispatcher(message_dispatcher, "on_test3"), true);
		#if cs
		Sys.sleep(0.3);
		message_dispatcher.update();
		new Assert().equip(is_telegram_in_message_dispatcher(message_dispatcher, "on_test3"), true);
		Sys.sleep(0.2);
		message_dispatcher.update();
		new Assert().equip(is_telegram_in_message_dispatcher(message_dispatcher, "on_test3"), false);
		#elseif js
		Timer.delay(() -> {
			message_dispatcher.update();
			new Assert().equip(is_telegram_in_message_dispatcher(message_dispatcher, "on_test3"), true);
		}, 300);
		Timer.delay(() -> {
			message_dispatcher.update();
			new Assert().equip(is_telegram_in_message_dispatcher(message_dispatcher, "on_test3"), false);
		}, 600);
		#end
	}

	static public function is_telegram_in_message_dispatcher(message_dispatcher:MessageDispatcher<Dynamic>, _event_name:String):Bool {
		return message_dispatcher.telegrams.exists(_event_name) && message_dispatcher.telegrams[_event_name].length == 1;
	}

	static public function is_event_in_message_dispatcher(message_dispatcher:MessageDispatcher<Dynamic>, _event_name:String, uuid:Int):Bool {
		return message_dispatcher.events.exists(_event_name)
			&& message_dispatcher.events[_event_name].length == 1
			&& message_dispatcher.events[_event_name][0].uuid == uuid;
	}

	static final test_msg1:String = "Hello this is a test1";
	static final test_msg2:String = "Hello this is a test2";

	static public function create_telegram1():Dynamic {
		return test_msg1;
	}

	static public function create_telegram2():Dynamic {
		return test_msg2;
	}

	static public function create_callback_fn():Dynamic->Void {
		return (e:Dynamic) -> {
			new Assert<String>().equip(e, test_msg1);
		}
	}
}
