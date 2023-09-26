function InitViewport1Event(obj) {
	obj.LoadEvent = function(args) {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.chkIsViewAll.on("check",obj.chkIsViewAll_check,obj);
		obj.txtElDesc.on('specialKey',obj.txtElDesc_specialKey,obj);
		obj.txtElCode.on('specialKey',obj.txtElCode_specialKey,obj);
		obj.gridDataItem.on("rowclick",obj.gridDataItem_rowclick,obj);
		obj.gridDataItemLnk.on("cellclick",obj.gridDataItemLnk_cellclick,obj);
		
		obj.txtItemAlias.on("specialKey",obj.txtItemAlias_specialKey,obj);
		obj.txtItemAlias.setWidth(100);
		
		obj.gridDataItemStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.txtItemAlias_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_LoadCurrPage('gridDataItem',1)
		obj.ClearDataItem();
	}
	
	obj.gridDataItemLnk_cellclick = function(grid, rowIndex, columnIndex, e)
	{
		if (columnIndex !=1) return;
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else if (recValue == '0'){
			var newValue = '1';
		} else {
			return;
		}
		
		if (newValue == '1') {
			var FPItemID = "";
			var objFPItem = obj.gridDataItem.getSelectionModel().getSelected();
			if (objFPItem) {
				FPItemID = objFPItem.get("ID");
			}
			var MRItemID = objRec.get("MRItemID");
			var inputStr = FPItemID + CHR_1 + "" + CHR_1 + MRItemID;
			var flg = ExtTool.RunServerMethod("DHCWMR.FP.DataItemLnk","Update",inputStr,CHR_1);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","关联模板单元/元数据错误!");
				return;
			} else {
				objRec.set("ItemLnkID", flg);
			}
		} else {
			var ItemLnkID = objRec.get("ItemLnkID");
			var flg = ExtTool.RunServerMethod("DHCWMR.FP.DataItemLnk","DeleteById",ItemLnkID);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","取消关联模板单元/元数据错误!");
				return;
			}
		}
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.ClearDataItem = function() {
		obj.RecRowID = "";
		Common_SetValue("txtDICode","");
		Common_SetValue("txtDIDesc","");
		Common_SetValue("txtDIResume","");
	}
	
	obj.btnUpdate_click = function() {
		var errinfo = "";
		var Code = Common_GetValue("txtDICode");
		var Desc = Common_GetValue("txtDIDesc");
		var Resume = Common_GetValue("txtDIResume");
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Resume;
		var flg = ExtTool.RunServerMethod("DHCWMR.FP.DataItem","Update",inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		obj.ClearDataItem();
		Common_LoadCurrPage("gridDataItem");
	}
	
	obj.gridDataItem_rowclick = function(){
		var index=arguments[1];
		var objRec = obj.gridDataItemStore.getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearDataItem();
			obj.gridDataItemLnkStore.removeAll();
		} else {
			obj.RecRowID = objRec.get("ID");
			Common_SetValue("txtDICode",objRec.get("DICode"));
			Common_SetValue("txtDIDesc",objRec.get("DIDesc"));
			Common_SetValue("txtDIResume",objRec.get("DIResume"));
			obj.gridDataItemLnkStore.removeAll();
			obj.gridDataItemLnkStore.load({params : {start : 0,limit : 50}});
		}
	}
	
	obj.chkIsViewAll_check = function() {
		obj.gridDataItemLnkStore.removeAll();
		obj.gridDataItemLnkStore.load({params : {start : 0,limit : 50}});
	}
  	obj.txtElDesc_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) {
			return;
		}
		Common_SetValue("txtElCode","");
		obj.gridDataItemLnkStore.removeAll();
		obj.gridDataItemLnkStore.load({params : {start : 0,limit : 50}});
	}
	
  	obj.txtElCode_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) {
			return;
		}
		Common_SetValue("txtElDesc","");
		obj.gridDataItemLnkStore.removeAll();
		obj.gridDataItemLnkStore.load({params : {start : 0,limit : 50}});
	}
}

