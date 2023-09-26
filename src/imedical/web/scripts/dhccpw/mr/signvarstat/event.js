
function InitMonitorViewportEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
	}
	obj.btnQuery_OnClick = function()
	{
		obj.ResultGridPanelStore.load({});
	}
	obj.btnExport_OnClick = function(){
		var strFileName="导出变异记录";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
	}
}
