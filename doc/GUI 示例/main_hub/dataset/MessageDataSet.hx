package kun.hscript_node.main_hub.dataset;

import kun.hscript_node.main_hub.controller.IndexController;
import kun.hscript_node.main_hub.controller.RamDatabaseController;
import kun.hscript_node.main_hub.gui.GuiTabStrip;
import kun.hscript_node.main_hub.gui.GuiGrid;

enum MessageDataSet {
	IndexController(ds:IndexController_Event);
	RamDatabaseController(ds:RamDatabaseController_Event);
	TabStrip(ds:GuiTabStrip_Event);
	Grid(ds:GuiGrid_Event);
}
