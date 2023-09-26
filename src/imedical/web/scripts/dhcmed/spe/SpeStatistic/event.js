function InitSpeStatisticEvent(obj) {
	obj.LoadEvent = function(args){
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
  		obj.cboPatType.on("expand", obj.cboPatType_OnExpand, obj);
  		obj.cboPatTypeSub.on("expand", obj.cboPatTypeSub_OnExpand, obj);
  		obj.cboLoc.on("select",  obj.cboLoc_select, obj);
  		obj.btnExport.on('click', obj.btnExport_click, obj);
		
	};
	obj.cboLoc_select = function(){
		Common_LoadCurrPage('gridResult',1);
	}
	
	obj.cboPatType_OnExpand = function(){
		obj.cboPatTypeStore.load({});
		obj.cboPatTypeSub.clearValue();
	}
	
	obj.cboPatTypeSub_OnExpand = function(){
		obj.cboPatTypeSubStore.load({});
	}
	
	obj.btnQuery_click = function(){
		obj.gridResultStore.load({});
	};
	obj.btnExport_click = function() {
		if (obj.gridResultStore.getCount()<1) {
			ExtTool.alert("确认", "无数据记录,不允许导出!");
			return;
		}
		
		var strFileName = "特殊患者统计查询表";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridResult, strFileName);
	}
}
