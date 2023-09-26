
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args){
		//进入页面同步科室提示
		if (parseInt(SynchDeptFlg) <= 0) {
			ExtTool.alert("提示","同步科室列表失败!");
		}
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.chkDisplayAll.on("check",obj.chkDisplayAll_check,obj);
		obj.gridLocGrpDic.on('rowclick',obj.gridLocGrpDic_rowclick,obj);
		obj.txtLocAlias.on("specialKey",obj.txtLocAlias_specialKey,obj);
		obj.gridLocGrpCfg.on("cellclick",obj.gridLocGrpCfg_cellclick,obj);
		Common_LoadCurrPage("gridLocGrpDic",1);
		Common_LoadCurrPage("gridLocGrpCfg",1);
  	};
	
	obj.chkDisplayAll_check = function(){
		Common_LoadCurrPage("gridLocGrpCfg",1);
	}
	
	obj.gridLocGrpDic_rowclick = function(grid,rowIndex,e){
		var record = grid.getStore().getAt(rowIndex);
		if (record){
			obj.LocGrpDicID = record.get('DicRowID');
			Common_SetValue('chkDisplayAll',false);
			Common_SetValue('txtLocAlias','');
			Common_LoadCurrPage("gridLocGrpCfg",1);
		}
	}
	
	obj.txtLocAlias_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		Common_LoadCurrPage("gridLocGrpCfg",1);
	}
	
	obj.gridLocGrpCfg_cellclick = function(grid, rowIndex, columnIndex, e)
	{
		if (columnIndex !=1) return;
		var record = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
		var LocGroup = record.get("LocGroup");
		LocGroup = '|' + LocGroup + '|'
		if (LocGroup.indexOf('|' + obj.LocGrpDicID + '|')>-1){
			var recValue = '1';
		} else {
			var recValue = '0';
		}
		
		if (recValue == '1') {
			var newValue = '0';
		} else if (recValue == '0'){
			var newValue = '1';
		} else {
			return;
		}
		
		var DeptCode = "";
		var record = obj.gridLocGrpCfg.getSelectionModel().getSelected();
		if (record) {
			DeptCode = record.get("DeptCode");
		}
		var inputStr = DeptCode + CHR_1 + obj.LocGrpDicID;
		if (newValue == '1') {
			var flg = ExtTool.RunServerMethod("DHCWMR.SS.LocGroup","AddLocGrpCfg",inputStr,CHR_1);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","科室组维护错误!");
				return;
			}
		} else {
			var flg = ExtTool.RunServerMethod("DHCWMR.SS.LocGroup","DelLocGrpCfg",inputStr,CHR_1);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","取消科室组维护错误!");
				return;
			}
		}
		Common_LoadCurrPage("gridLocGrpCfg");
	}
	
	obj.btnUpdate_click = function() {
		var flg = ExtTool.RunServerMethod("DHCWMR.SSService.LocGroupSrv","SynchDeptList");
		if (parseInt(flg) <= 0) {
			ExtTool.alert("提示","同步科室列表失败!");
			return;
		} else {
			ExtTool.alert("提示","同步科室列表成功!");
			Common_LoadCurrPage("gridLocGrpCfg");
		}
	}
}

