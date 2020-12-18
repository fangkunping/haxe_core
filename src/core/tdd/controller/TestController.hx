package core.tdd.controller;

typedef GetNameRequest = {name:String, age:Int}

class TestController {
	public function new() {}

	@router("tdd/test")
	public function getName(data:GetNameRequest, response:Dynamic->Void) {
		response('Hello, My name is ${data.name}, I am ${data.age} years old');
	}
}
