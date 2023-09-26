
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsInfectCCMap = ExtTool.StaticServerObject("DHCMed.EPD.InfectCCMap");
		
	obj.LoadEvent = function(args)
    {
		
		obj.chkIsViewAll.on("check",obj.chkIsViewAll_check,obj);
		obj.gridInfection.on("rowclick",obj.gridInfection_rowclick,obj);
		obj.gridItemDic.on("cellclick",obj.gridItemDic_cellclick,obj);
		obj.gridInfectionStore.load({});
  	};
	
	obj.gridItemDic_cellclick = function(grid, rowIndex, columnIndex, e)
	{
		if (columnIndex !=0) return;
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
	    
		var aInfectID = "";
		var objRecDiag = obj.gridInfection.getSelectionModel().getSelected();
		if (objRecDiag) {
			aInfectID = objRecDiag.get("RowID");
		}
		if (aInfectID=="")
		{
			ExtTool.alert("错误提示","请先选择传染病疾病字典!");
			return;
		}
		var aItemDicID = objRec.get("rowid");
		var str="^"+aInfectID+"^"+aItemDicID;
		if (newValue == '1') {
			var flg = obj.ClsInfectCCMap.Update(str);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","关联监控项目字典错误!");
				return;
			}
		} else {
			var flg = obj.ClsInfectCCMap.DeleteById(str);

		}
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.gridInfection_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridInfection.getStore().getAt(index);
		if (objRec.get("RowID") == obj.RecRowID) {
			obj.ClearFormItem();
			obj.gridItemDicStore.removeAll();
		} else {
			obj.RecRowID = objRec.get("RowID");
			obj.gridItemDicStore.removeAll();
			obj.gridItemDicStore.load({});
		}
	};
	
	obj.chkIsViewAll_check = function()
	{
		obj.gridItemDicStore.removeAll();
		obj.gridItemDicStore.load({});
	};
}



