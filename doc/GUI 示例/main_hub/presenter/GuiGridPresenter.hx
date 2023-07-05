package kun.hscript_node.main_hub.presenter;

import kun.hscript_node.main_hub.gui.GuiGrid.TGuiGrid_InDataSet;
import kun.hscript_node.ram_database.entity.TableEntity;
import kun.hscript_node.ram_database.model.TableModel;

class GuiGridPresenter {
	static public function fromDatabase(database:TableEntity):TGuiGrid_InDataSet {
		var minCol = 1;
		var maxCol = 1;
		var minRow = 1;
		var maxRow = 1;
		var tableModel = new TableModel(database);
		for (k => v in database.data) {
			var d = tableModel.getColRow(k);
			maxCol = Std.int(Math.max(maxCol, d.col));
			maxRow = Std.int(Math.max(maxRow, d.row));
		}
		var columns:Array<Dynamic>;
		columns = new Array();
		columns.push({field: "row", title: "-", editable: false});
		for (i in minCol...maxCol + 1) {
			var excelCol = kun.hscript_node.ram_database.Tools.decimalToExcelColumn(i);
			var aliasname = tableModel.getAlias(Number(i));
			aliasname = aliasname == null ? excelCol : aliasname;
			columns.push({
				{field: excelCol, title: aliasname, editable: true}
			});
		}
		var datasources:Array<Dynamic>;
		datasources = new Array();
		for (row in minRow...maxRow + 1) {
			var d = {row: row}
			for (col in minCol...maxCol + 1) {
				var excelCol = kun.hscript_node.ram_database.Tools.decimalToExcelColumn(col);
				Reflect.setField(d, excelCol, tableModel.get(Number(col), row));
			}
			datasources.push(d);
		}
		return {
			name: database.tableId,
			columns: columns,
			datasources: datasources
		}
	}
}
