
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
    {
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		obj.cboTargetWard.on("expand", obj.cboTargetWard_OnExpand, obj);
		
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.gridCasesX.getColumnModel();
    			var cfg = null;
    			for(var i=0;i<cm.config.length;++i)
   	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
  	};
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