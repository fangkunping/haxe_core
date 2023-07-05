package core.gui;

interface IController<MessageDataSet> {
	function sendEvent(msg:MessageDataSet):Void;
	function onEvent(msg:MessageDataSet):Void;
}
