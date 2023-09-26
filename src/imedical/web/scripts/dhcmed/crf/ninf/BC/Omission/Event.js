
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
    {
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		//obj.cboTargetLoc.on("expand", obj.cboTargetLoc_OnExpand, obj);
		obj.cboTargetWard.on("expand", obj.cboTargetWard_OnExpand, obj);
  	};
	/*obj.cboTargetLoc_OnExpand = function() {
		obj.cboTargetLoc.clearValue();
		obj.cboTargetLoc.getStore().load({});
	};*/
	//add by likai for bug:3963
	obj.cboTargetWard_OnExpand = function() {
		obj.cboTargetWard.clearValue();
		obj.cboTargetWard.getStore().load({});
	};
	obj.btnQuery_click = function() {
		
		obj.gridCasesXStore.load({params : {start : 0,limit : 100}});
	}
	
	obj.btnExport_click = function() {
		var strFileName="感染漏报查询";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridCasesX,strFileName);
	}
}