package kun.hscript_node.gui;

import js.Syntax;

class RamDataBase extends GuiBase {
	var tabStrip:Dynamic;
	var ramdatas:Array<Dynamic> = [
		{
			tableName: "测试",
			tableId: 100,
			alias: [],
			view: {
				maxRow: 10,
				maxCol: 10,
			},
			data: [
				{
					col: "A",
					row: 1,
					data: "adjdie",
					dateType: "String",
				}
			]
		}
	];

	override function init() {
		ID = "ram-database";
		initView();
		initButtonEvent();
		initViewEvent();
	}

	function initView() {
		tabStrip = Syntax.code("$({0}).kendoTabStrip().data('kendoTabStrip')", '#${ID} div[name="tabstrip-container"]');
		clearTabstripContent();
		addTabstripContent();
	}

	function initViewEvent() {}

	function initButtonEvent() {}

	function clearTabstripContent() {
		while (tabStrip.items().length > 0) {
			tabStrip.remove(0);
		}
	}

	function addTabstripContent() {
		for (data in ramdatas) {
			var name = 'table_${data.tableId}';
			tabStrip.append({
				text: data.tableName,
				content: '<div name="${name}"></div>'
			});
			createGridTable(CommonUtils.jquery('#${ID} div[name="${name}"]'), data.tableId, data.data);
		}

		// createChecklistGrpupTable(new JQuery('#${CONSTRACTOR_JOIN_DATAGRID}_${e.id}'), e.id);
		tabStrip.select(getTabstripItem(0));
	}

	function getTabstripItem(itemIndex:Int) {
		return tabStrip.tabGroup.children("li").eq(itemIndex);
	}

	function createGridTable(contentElement:Dynamic, tableId:Int, dataSource:Dynamic) {
		var columns:Array<Dynamic> = [
			{field: "col", title: "A", editable: true},
			{field: "data", title: "描述", editable: true},
			{command: [{name: "destroy", text: "删除"}], title: "&nbsp;", width: "150px"}
		];
		contentElement.kendoGrid({
			dataSource: dataSource,
			columns: columns,
			editable: "inline",
			toolbar: ["create"]
		});
	}
}
