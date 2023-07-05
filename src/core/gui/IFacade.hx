package core.gui;

interface IFacade<MessageDataSet> {
    function sendEvent(msg:MessageDataSet):Void; 
}