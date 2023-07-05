package kun.hscript_node.main_hub.gui;

import js.Syntax;
import kun.hscript_node.main_hub.dataset.MessageDataSet;
import core.gui.GuiBase;

class GuiTabStrip extends GuiBase<MessageDataSet> {
	var tabStrip:Dynamic;
	final ID = "ram-database";

	override function init() {
		tabStrip = Syntax.code("$({0}).kendoTabStrip({1}).data('kendoTabStrip')", '#${ID} div[name="tabstrip-container"]', {
			select: e -> {
				var selectTitle = Syntax.code("$({0})", e.item).find("> .k-link").text();
				this.facade.sendEvent(MessageDataSet.TabStrip(onTabSelect(selectTitle)));
			}
		});
	}

	override function onEvent(msg:MessageDataSet) {
		switch (msg) {
			case TabStrip(ds):
				switch (ds) {
					case UpdateView(dataset):
						updateTabs(dataset);
					case _:
				}
			case _:
		}
	}

	function updateTabs(dataSet:TGuiTabStrip_InDataSet) {
		for (d in dataSet) {
			tabStrip.append(d);
		}
		sendEvent(TabStrip(onViewRenderDone));
		tabStrip.select(getTabstripItem(0));
	}

	function getTabstripItem(itemIndex:Int) {
		return tabStrip.tabGroup.children("li").eq(itemIndex);
	}
}

typedef TGuiTabStrip_InDataSet = Array<{
	text:String,
	content:String
}>

enum GuiTabStrip_Event {
	UpdateView(dataset:TGuiTabStrip_InDataSet);
	onTabSelect(title:String);
	onViewRenderDone;
}
