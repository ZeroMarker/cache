function InitSpeQueryEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.cboPatTypeSub.on("select",  obj.cboPatTypeSub_select, obj);
		obj.cboLoc.on("select",  obj.cboLoc_select, obj);
		obj.btnExport.on('click', obj.btnExport_click, obj);
		obj.cboPatTypeSubStore.load({});
  	};
	
	obj.cboPatTypeSub_select = function(){
		Common_LoadCurrPage('gridSpeList',1);
	}
	
	obj.cboLoc_select = function(){
		Common_LoadCurrPage('gridSpeList',1);
	}

	obj.btnQuery_click = function(){
		var Status = obj.GetSelStatus();
		if (Status == ''){
			window.alert("请选择报告状态！");
			return;
		}
		Common_LoadCurrPage('gridSpeList',1);
	}
	obj.btnExport_click = function() {
		if (obj.gridSpeListStore.getCount()<1) {
			ExtTool.alert("确认", "无数据记录,不允许导出!");
			return;
		}
		
		var strFileName = "特殊患者明细查询表";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridSpeList, strFileName);
	}


}