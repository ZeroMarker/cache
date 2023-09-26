
function InitMonitorViewportEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
	}
	obj.cboLoc_OnExpand = function(){
		obj.cboLocStore.load({});
	}
	obj.btnQuery_OnClick = function()
	{
		obj.ResultGridPanelStore.load({});
	}
	obj.btnExport_OnClick = function(){
		var strFileName="ÁÙ´²Â·¾¶Í³¼Æ";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
	}
}
