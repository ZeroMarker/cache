
function InitVarianceViewportEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
		obj.cboWard.on("expand", obj.cboWard_OnExpand, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
	}
	obj.btnQuery_OnClick = function()
	{
		obj.ResultGridPanelStore.load({});
	}
	obj.cboLoc_OnExpand = function(){
		obj.cboLocStore.load({});
	}
	obj.cboWard_OnExpand = function(){
		obj.cboWardStore.load({});
	}
	obj.btnExport_OnClick = function(){
		var strFileName="变异分析结果";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
	}
}
