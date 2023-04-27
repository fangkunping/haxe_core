## 使用方法

### 创建MessageDispatcher实例

```haxe
final md:MessageDispatcher = new MessageDispatcher();
```

### 实例update

进行时间判断和广播消息。建议加载主循环中，开启一个线程单独做update。

```haxe
md.update();
```

### 注册监听者

```haxe
// 返回的uuid为唯一id，可用于注销监听者
// 调用次数, <= 0 表示无限次调用，缺省为0 
final uuid:Int = md.register("on_test", (e : Dynamic) -> {
    trace(e);
}, 0);
```


### 发送事件

```haxe
// 可发送任何数据
// 最后一个参数是延迟发送的时间, 毫秒，缺省为0
md.send("on_test", "hello world", 1);
```

`注意`：

* 立即发送（即最后一个参数不填写或<=0），那么会立即向所有的监听者广播
* 延迟发送则需要等到 `实例.update()` 时才进行时间判断和发送操作

### 注销监听者

```haxe
md.unregister("on_test", uuid);
```

### 清理
设置 maxClearMount 的值（缺省 50）
每执行一次 update 累计一次数量，当数量到达 maxClearMount 就进行清理操作