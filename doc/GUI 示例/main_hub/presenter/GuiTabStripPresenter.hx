package kun.hscript_node.main_hub.presenter;

import kun.hscript_node.ram_database.entity.TableEntity;
import kun.hscript_node.main_hub.gui.GuiTabStrip.TGuiTabStrip_InDataSet;

class GuiTabStripPresenter {
	static public function fromRamDatabase(database:Array<TableEntity>):TGuiTabStrip_InDataSet {
		return database.map(e -> {
			text: e.tableName,
			content: '<div name="${e.tableId}"></div>'
		});
	}
}
