package core.emu;

import core.message.MessageDispatcher;

using Lambda;

import haxe.rtti.Meta;

typedef RouterData = {class_name:String, method:String}

class Router<TIn, TOut> {
	private var routerClass:Array<String>;
	private var routerData:Map<String, RouterData>;
	private var messageDispatcher:MessageDispatcher<TOut>;

	public function new(_msgDispatcher:MessageDispatcher<TOut>) {
		messageDispatcher = _msgDispatcher;
	}

	public function setRouterClass(v:Array<String>) {
		routerClass = v;
		routerData = new Map();
		initRouterClass();
	}

	private function initRouterClass() {
		routerClass.iter((routerClassStr:String) -> {
			var theClass = Type.resolveClass(routerClassStr);
			var field_obj = Meta.getFields(theClass);
			Reflect.fields(field_obj).iter((fieldStr) -> {
				var e = Reflect.field(field_obj, fieldStr);
				if (Reflect.hasField(e, "router")) {
					this.routerData.set(e.router[0], {
						class_name: routerClassStr,
						method: fieldStr
					});
				}
			});
		});
	}

	/**
		根据api地址实例化对应的类, 并调用相应的方法

		* data: 传递的数据
		* api: api路径地址
		* event_name: 事件名称, 用于接收返回数据
	**/
	public function post(api:String, data:TIn, event_name:String = null) {
		var classInfo = routerData[api];
		// 实例化类
		var theClass = Type.resolveClass(classInfo.class_name);
		var instance = Type.createInstance(theClass, []);
		// 调用函数
		final response = (d:TOut) -> {
			messageDispatcher.send(event_name, d, 1);
		};
		Reflect.callMethod(instance, Reflect.field(instance, classInfo.method), [data, response]);
	}

	public function postCallBack(api:String, data:TIn, callback_fn:TOut->Void){
		var classInfo = routerData[api];
		// 实例化类
		var theClass = Type.resolveClass(classInfo.class_name);
		var instance = Type.createInstance(theClass, []);
		Reflect.callMethod(instance, Reflect.field(instance, classInfo.method), [data, callback_fn]);
	}
}
