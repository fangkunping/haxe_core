package kun.hscript_node.main_hub.controller;

import core.gui.IFacade;
import kun.hscript_node.main_hub.dataset.MessageDataSet;
import core.gui.IController;

class IndexController implements IController<MessageDataSet> {
	var facade:IFacade<MessageDataSet>;

	public function new(facade:IFacade<MessageDataSet>) {
		this.facade = facade;
	}

	public function sendEvent(msg:MessageDataSet) {}

	public function onEvent(msg:MessageDataSet) {
		switch (msg) {
			case IndexController(event):
				switch (event) {
					case Init:
						facade.sendEvent(RamDatabaseController(LoadAllData));
					case _:
				}
			case _:
		}
	}
}

enum IndexController_Event {
	Init;
}
