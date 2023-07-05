package core.gui;

class FacadeBase<MessageDataSet> implements IFacade<MessageDataSet> {
	var controllers:Array<IController<MessageDataSet>>;

	public function new() {
		controllers = new Array();
		init();
	}

	function init() {}

	public function sendEvent(msg:MessageDataSet):Void {
		for (controller in controllers) {
			controller.onEvent(msg);
		}
	}

	public function addController(controller:IController<MessageDataSet>) {
		controllers.push(controller);
	}

	public function removeController(controller:IController<MessageDataSet>) {
		controllers.remove(controller);
	}


}
