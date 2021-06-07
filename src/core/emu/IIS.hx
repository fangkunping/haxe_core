package core.emu;

import core.message.TelegramData;
import core.message.MessageDispatcher;

class Setting {
	public function new() {}

	public var routerClass:Array<String> = new Array();

	public function getRouterClass():Array<String> {
		return this.routerClass;
	}

	public function setRouterClass(v:Array<String>):Setting {
		this.routerClass = v;
		return this;
	}

	public var requestType:IIS_REQUEST_TYPE = IIS_REQUEST_TYPE.CALLBACK;

	public function getRequestType():IIS_REQUEST_TYPE {
		return this.requestType;
	}

	public function setRequestType(v:IIS_REQUEST_TYPE):Setting {
		if (v == IIS_REQUEST_TYPE.NONE)
			return this;
		this.requestType = v;
		return this;
	}
}

enum IIS_REQUEST_TYPE {
	NONE;
	EVENT;
	CALLBACK;
}

class IIS {
	static private var inc:IIS;

	static public function start(setting:Setting) {
		inc = new IIS(setting);
	}

	/**
	 * 调用API
	 * @param api api地址
	 * @param data 传输的数据
	 * @param callback_fn 回调函数
	 * @param request_type 请求类型，IIS_REQUEST_TYPE.[CALLBACK | EVENT], 缺省为 IIS_REQUEST_TYPE.NONE, 即使用IIS的配置项
	 */
	static public function request(api:String, data:Dynamic, callback_fn:Dynamic->Void, request_type:IIS_REQUEST_TYPE = IIS_REQUEST_TYPE.NONE) {
		inc.do_request(api, data, callback_fn, request_type);
	}

	static public function update() {
		inc.updateEvent();
	}

	private var messageDispatcher:MessageDispatcher;

	private var router:Router;

	private var requestType:IIS_REQUEST_TYPE;

	public function new(setting:Setting) {
		messageDispatcher = new MessageDispatcher();
		router = new Router(messageDispatcher);
		router.setRouterClass(setting.getRouterClass());
		requestType = setting.getRequestType();
	}

	public function updateEvent() {
		messageDispatcher.update();
	}

	public function do_request(api:String, data:Dynamic, callback_fn:Dynamic->Void, request_type) {
		switch (request_type) {
			case IIS_REQUEST_TYPE.NONE:
				do_request(api, data, callback_fn, this.requestType);
			case IIS_REQUEST_TYPE.CALLBACK:
				requestCallBack(api, data, callback_fn);
			case IIS_REQUEST_TYPE.EVENT:
				requestEvent(api, data, callback_fn);
		}
	}

	public function requestEvent(api:String, data:Dynamic, callback_fn:Dynamic->Void) {
		final event_name:String = '${api}_${Math.random()}';
		messageDispatcher.register(event_name, (t) -> {
			callback_fn(t);
		}, 1);
		router.post(api, data, event_name);
	}

	public function requestCallBack(api:String, data:Dynamic, callback_fn:Dynamic->Void) {
		router.postCallBack(api, data, callback_fn);
	}
}
