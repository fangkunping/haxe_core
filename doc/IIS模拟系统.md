## 说明

2020-02-26: 增加了直接回调的形式, 该形式不使用 `信息分发`(MessageDispatcher)

IIS模拟系统是模拟API调用的一个微服务，其自身封装了 `信息分发`(MessageDispatcher) 和 `路由`; 系统的主要特点包括：

* 分离逻辑，将通用的功能抽象为API服务，供其它模块使用
* 将所有API服务的返回转化为回调的形式，统一同步和异步的操作
* 远程API也可以利用该系统做桥接，方便多语言移植和分布操作

## 使用

### 初始化，定义路由

`注意`：需要在import 控制器类，否则haxe不会编译所有的类到最终项目里面

```haxe
import tdd.controller.TestController;

IIS.start(
	new Setting()
	.setRouterClass(["tdd.controller.TestController"])
	.setRequestType(IIS_REQUEST_TYPE.CALLBACK) //可以不用配置， 缺省为 IIS_REQUEST_TYPE.CALLBACK
);
```

### 请求API

2020-02-26：增加了`请求类型`缺省参数 `IIS_REQUEST_TYPE.NONE` 即 使用IIS的配置requestType ，详见 IIS.request 函数说明

`IIS_REQUEST_TYPE.NONE` 是为了在使用request函数时，不需要输入请求类型参数。

```haxe
IIS.request("tdd/test", {name: "Max", age: 40}, (v:String) -> {
    new Assert().equip("Hello, My name is Max, I am 40 years old", v);
});
```

### IIS系统update

2020-02-26：

* 当请求类型为 `IIS_REQUEST_TYPE.CALLBACK` 时，所有信息都是立即返回到调用者
* 当请求类型为 `IIS_REQUEST_TYPE.EVENT` 时, 调用立即执行并将结果储存起来，必须使用update方法返回结果（延迟1毫秒），update的使用方式和`信息分发`(MessageDispatcher) 使用方式一致。

```haxe
IIS.update();
```

### Controller类定义

返回的信息必须使用response调用


```haxe
package tdd.controller;

typedef GetNameRequest = {name:String, age:Int}

class TestController {
	public function new() {}

	@router("tdd/test")
	public function getName(data:GetNameRequest, response:Dynamic->Void) {
		response('Hello, My name is ${data.name}, I am ${data.age} years old');
	}
}
```
