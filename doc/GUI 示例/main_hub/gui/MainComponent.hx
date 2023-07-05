package kun.hscript_node.main_hub.gui;

import kun.hscript_node.main_hub.dataset.MessageDataSet;
import core.gui.IController;
import core.gui.FacadeBase;

class MainComponent extends FacadeBase<MessageDataSet> {
	override function init() {
		addToGuiQueue(new GuiTabStrip(this));
		addToGuiQueue(new GuiGrid(this));
	}

	function addToGuiQueue(gui:IController<MessageDataSet>) {
		this.controllers.push(gui);
	}
}
