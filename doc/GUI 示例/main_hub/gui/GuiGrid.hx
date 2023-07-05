package kun.hscript_node.main_hub.gui;

import kun.hscript_node.main_hub.dataset.MessageDataSet;

class GuiGrid extends core.gui.GuiBase<MessageDataSet> {
	final ID = "ram-database";
	var grid:Dynamic;

	override function onEvent(msg:MessageDataSet) {
		switch (msg) {
			case Grid(ds):
				switch (ds) {
					case UpdateView(dataset):
						render(dataset);
				}
			case _:
		}
	}

	function render(dataset:TGuiGrid_InDataSet) {
		grid = CommonUtils.jquery('#${ID} div[name="${dataset.name}"]').kendoGrid({
			dataSource: dataset.datasources,
			columns: dataset.columns,
			editable: "inline",
			toolbar: ["create"]
		});
	}
}

typedef TGuiGrid_InDataSet = {
	name:Int,
	columns:Array<Dynamic>,
	datasources:Array<Dynamic>,
}

enum GuiGrid_Event {
	UpdateView(dataset:TGuiGrid_InDataSet);
}
