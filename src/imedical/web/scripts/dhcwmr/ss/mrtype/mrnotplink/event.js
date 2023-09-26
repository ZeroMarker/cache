function InitMrNoTypeLinkEvent(obj){
	obj.LoadEvents = function(){
		obj.gridNoTypeLinkHosp.on('cellclick',obj.gridNoTypeLinkHosp_cellclick,obj);
		obj.gridNoTypeLinkLoc.on('cellclick',obj.gridNoTypeLinkLoc_cellclick,obj);
		obj.gridNoTypeLink.on('rowclick',obj.gridNoTypeLink_rowclick,obj);
		obj.btnDeleteNTL.on('click',obj.btnDeleteNTL_click,obj);
	}
	obj.btnDeleteNTL_click = function(){
		var objRec = Ext.getCmp("gridNoTypeLink").getSelectionModel().getSelected();
		if (!objRec){
			ExtTool.alert("提示","请选择要删除的关联项！");
		}
		var ID = objRec.get("ID");
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.NoTypeLnk","DeleteById",ID);
		if (ret<0){
			ExtTool.alert("提示","删除失败！");
			return;
		} else {
			obj.gridNoTypeLinkStore.load({});
			obj.gridNoTypeLinkLocStore.load({});
		}
	}
	
	obj.gridNoTypeLink_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.gridNoTypeLinkStore.getAt(rowIndex);

	}
	obj.gridNoTypeLinkLoc_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex !=0) return;
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
		
		var Parref="",HospID="",LocID="",PatType="",errinfo = "";
		var Separate = String.fromCharCode(1);
		var Parref = obj.NoTypeID;
		var ChildSub = ""
		var objRec = Ext.getCmp("gridNoTypeLinkHosp").getSelectionModel().getSelected();
		var HospID = objRec.get("HospID");
		var objRec = Ext.getCmp("gridNoTypeLinkLoc").getSelectionModel().getSelected();
		var LocID = objRec.get("LocID");
		if (!HospID){
			errinfo = errinfo + "医院为空!<br>";
		}
		if (!LocID){
			errinfo = errinfo + "科室为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var tmp = Parref + Separate;
			tmp += ChildSub + Separate;
			tmp += HospID + Separate;
			tmp += LocID + Separate;
			tmp += PatType + Separate;
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.NoTypeLnk","Update",tmp,Separate);
		if(ret<0) {
			ExtTool.alert("提示","添加失败！");
			return;
		} else {
			obj.gridNoTypeLinkStore.load({});
			obj.gridNoTypeLinkLocStore.load({});
		}
	}

	obj.gridNoTypeLinkHosp_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex !=0) return;
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = objRec.get(fieldName);
		for (var i =0; i< grid.store.getCount();i++ ){
			var objRecTmp=grid.getStore().getAt(i);
			var fieldNameTmp = grid.getColumnModel().getDataIndex(0);
			var recValueTmp = objRec.get(fieldNameTmp);
			objRecTmp.set(fieldNameTmp, 0);
		}
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
		obj.gridNoTypeLinkLocStore.load({});
	}
	
	obj.GetGridCheckedData = function(){
		var grid = arguments[0];
		var ret = ""
		for (var i =0; i< grid.store.data.items.length;i++ )
			{
				if (grid.store.data.items[i].data.IsChecked==1)
				{
					ret=grid.store.data.items[i].data.rowid;
				}
			}
		return ret;
	}
	
	obj.InitGridStatus = function(){
		var grid = arguments[0];
		for (var i =0; i< grid.store.getCount();i++ ){
			var objRec=grid.getStore().getAt(i);
			var fieldName = grid.getColumnModel().getDataIndex(0);
			objRec.set(fieldName,0);
		}
		grid.getStore().commitChanges();
		grid.getView().refresh();	
	}
}
