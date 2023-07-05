package core;

/**
 * 函数执行托管系统，可用于异步函数的执行，函数计数执行等。
 * 向该系统提交匿名函数，及执行次数（一次，计数，永久执行），即可获得托管id
 * 通过call函数可以执行托管id对应的托管函数。
 * 使用示例见 test 方法
 */
class FunctionQueueSystem {
	var queues:Array<FunctionQueueSystem_FnEntity>;
	var idGenerator:RecyclableIDGenerator;

	public function new() {
		queues = new Array();
		idGenerator = new RecyclableIDGenerator();
	}

	public function add(fn:Void->Void, type:FunctionQueueSystem_Type = Once):Int {
		var id = idGenerator.allocateID();
		var entity = new FunctionQueueSystem_FnEntity(id, type, fn);
		queues.push(entity);
		return id;
	}

	public function call(id) {
		var entity = fetch(id);
		if (entity == null)
			return;
		entity.fn();
		switch (entity.type) {
			case CountDown(num):
				if (num > 1) {
					entity.type = CountDown(num - 1);
					store(entity);
				}
			case Allways:
				store(entity);
			case _:
		}
	}

	public function remove(id) {
		queues = queues.filter(e -> e.id != id);
	}

	public function countDown(id:Int, countNum:Int) {
		var entity = fetch(id);
		if (entity == null)
			return;
		switch (entity.type) {
			case CountDown(num):
				var newNum = num - countNum;
				if (newNum > 0) {
					entity.type = CountDown(newNum);
					store(entity);
				}
			case Allways:
				store(entity);
			case _:
		}
	}

	function fetch(id):FunctionQueueSystem_FnEntity {
		var entity:FunctionQueueSystem_FnEntity = null;
		queues = queues.filter(e -> {
			if (id == e.id) {
				entity = e;
				return false;
			}
			return true;
		});
		return entity;
	}

	function store(entity:FunctionQueueSystem_FnEntity) {
		queues.push(entity);
	}

	static public function test() {
		var functionQueues = new FunctionQueueSystem();
		var onceFnId = functionQueues.add(() -> {
			trace("once");
		}, Once);
		var countDown2Id = functionQueues.add(() -> {
			trace("count down 3 times");
		}, CountDown(3));
		var allwaysId = functionQueues.add(() -> {
			trace("allways");
		}, Allways);
		// 只执行一次
		functionQueues.call(onceFnId);
		// 本次执行无效
		functionQueues.call(onceFnId);
		// 执行两次
		functionQueues.call(countDown2Id);
		functionQueues.call(countDown2Id);
		// 减少一次，但是不执行
		functionQueues.countDown(countDown2Id, 1);
		// 本次执行无效
		functionQueues.call(countDown2Id);
		// 不限次数执行
		functionQueues.call(allwaysId);
		functionQueues.call(allwaysId);
		functionQueues.call(allwaysId);
		functionQueues.call(allwaysId);
		// 删除
		functionQueues.remove(allwaysId);
		// 本次执行无效
		functionQueues.call(allwaysId);
	}
}

class FunctionQueueSystem_FnEntity {
	public var id:Int;
	public var type:FunctionQueueSystem_Type;
	public var fn:Void->Void;

	public function new(id:Int, type:FunctionQueueSystem_Type, fn:Void->Void) {
		this.id = id;
		this.type = type;
		this.fn = fn;
	}
}

enum FunctionQueueSystem_Type {
	Once;
	CountDown(num:Int);
	Allways;
}
