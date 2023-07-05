package kun.hscript_node.main_hub.controller;

import kun.hscript_node.main_hub.presenter.GuiGridPresenter;
import kun.hscript_node.main_hub.presenter.GuiTabStripPresenter;
import core.RecyclableIDGenerator;
import core.gui.IFacade;
import core.FunctionQueueSystem;
import core.gui.IController;
import kun.hscript_node.main_hub.dataset.MessageDataSet;
import kun.hscript_node.ram_database.entity.TableEntity;

using Lambda;

class RamDatabaseController implements IController<MessageDataSet> {
	var facade:IFacade<MessageDataSet>;
	var database:Array<TableEntity>;
	var callbackFnQueues:FunctionQueueSystem;
	var tabRenderFinishCId = RecyclableIDGenerator.NeverID;
	var gridRenderFinishCId = RecyclableIDGenerator.NeverID;

	public function new(facade:IFacade<MessageDataSet>) {
		this.facade = facade;
		database = new Array();
		callbackFnQueues = new FunctionQueueSystem();
		var t1 = new TableEntity();
		t1.fromString('{"tableName":"语文成绩","tableId":0,"view":{"maxCol":1,"maxRow":1},"columnsKey":[1,2],"columnsValue":["姓名","分数"],"dataKey":[131073,65537,131074,65538],"dataValue":["100","张三","90","李四"]}');
		database.push(t1);
		var t2 = new TableEntity();
		t2.fromString('{"tableName":"数学成绩","tableId":1,"view":{"maxCol":1,"maxRow":1},"columnsKey":[],"columnsValue":[],"dataKey":[131073,65537,131074,65538],"dataValue":["120","张三","110","李四"]}');
		database.push(t2);
	}

	public function sendEvent(msg:MessageDataSet) {}

	public function onEvent(msg:MessageDataSet) {
		switch (msg) {
			case TabStrip(ds):
				switch (ds) {
					case onViewRenderDone:
						callbackFnQueues.call(tabRenderFinishCId);
					case onTabSelect(title):
						prepareGridDataset(title);
					case _:
				}
			case RamDatabaseController(ds):
				switch (ds) {
					case LoadAllData:
						loadAllData();
					case _:
				}
			case _:
		}
	}

	function loadAllData() {
		// tab 创建完成
		tabRenderFinishCId = callbackFnQueues.add(() -> {
			trace("tab finish render");
		});
		facade.sendEvent(TabStrip(UpdateView(GuiTabStripPresenter.fromRamDatabase(database))));
	}

	function prepareGridDataset(title:String) {
		var entity = database.find(e -> e.tableName == title);
		facade.sendEvent(Grid(UpdateView(GuiGridPresenter.fromDatabase(entity))));
	}
}

enum RamDatabaseController_Event {
	LoadAllData;
	LoadData(tableName:String);
}
