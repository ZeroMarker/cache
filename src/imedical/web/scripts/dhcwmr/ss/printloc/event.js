function InitViewPortEvents(obj)
{
	obj.LoadEvents = function()
	{
		obj.gridCTHospList.on('rowclick',obj.gridCTHospList_rowclick,obj);
		obj.gridLocList.on('cellclick',obj.gridLocList_cellclick,obj);
	}
	
	obj.gridCTHospList_rowclick = function(grid, rowIndex, columnIndex, e)
	{
		var rowIndex = arguments[1];
		var objRec = obj.gridCTHospListStore.getAt(rowIndex);
		var HospID = objRec.get("HospID");
		obj.HospID = HospID;
		obj.gridLocListStore.load({});
	}
	
	obj.gridLocList_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex !=1) return;
		var HospID = obj.HospID
		var objStore = grid.getStore();
		var record = objStore.getAt(rowIndex);
		var LocID = record.get("LocRowId");
		if (record.get('IsChecked') != '1'){
			var InputStr="";
			InputStr += '^' + HospID;
			InputStr += '^' + LocID; 
			var ret = ExtTool.RunServerMethod("DHCWMR.SS.PrintLoc","Update",InputStr,"^")
			if (ret>0) {
				record.set('IsChecked', '1');
			}else{
				ExtTool.alert('提示','更新失败！');
			}
		} else {
			var ret = ExtTool.RunServerMethod("DHCWMR.SS.PrintLoc","DeleteByHospLocID",HospID,LocID)
			if (ret>0) {
				record.set('IsChecked', '0');
			}else{
				ExtTool.alert('提示','更新失败！');
			}
		}
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
}