
function InitViewportEvent(obj) {
	obj.LoadEvent = function(args)
    	{
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.btnExport.on("click", obj.btnExport_click, obj);
  	}
	
	obj.btnQuery_click = function()
	{
		obj.gridInfReportStore.removeAll();
		obj.gridInfReportStore.load({});
	}
	
	obj.btnExport_click = function(){
		if (obj.gridInfReport.getStore().getCount() > 0)
		{
			var strFileName="感染报告相关信息查询";
			var objExcelTool=Ext.dhcc.DataToExcelTool;
			objExcelTool.ExprotGrid(obj.gridInfReport,strFileName);
		} else {
			ExtTool.alert("提示","查询列表数据为空!");
		}
	}
}
