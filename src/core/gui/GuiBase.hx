package core.gui;

import haxe.ds.Option;

class GuiBase<MessageDataSet> implements IController<MessageDataSet> {
	var facade:IFacade<MessageDataSet>;

	public function new(_facade:IFacade<MessageDataSet>) {
		facade = _facade;
		init();
	}

	function init() {}

	public function sendEvent(msg:MessageDataSet) {
		facade.sendEvent(msg);
	}

	public function onEvent(msg:MessageDataSet) {}

}
