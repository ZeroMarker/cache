
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
		obj.ResultGridPanelStore.removeAll();
		obj.ResultGridPanelStore.load({
			params : {
				start : 0,
				limit : 1000
			}
		});
	}
	obj.cboLoc_OnExpand = function(){
		obj.cboLocStore.load({});
	}
	obj.cboWard_OnExpand = function(){
		obj.cboWardStore.load({});
	}
	
	obj.btnExport_OnClick = function(){
		var strFileName="病情变异明细";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
	}
	/*
	obj.btnExport_OnClick = function()
	{
		if (obj.ResultGridPanelStore.getCount()<1)
		{
			alert("列表无数据，不允许导出!");
			return;
		}
		var DateFrom = obj.DateFrom;
		var DateTo = obj.DateTo;
		var cArguments=DateFrom+"^"+DateTo+"^"+"";
		var flg=ExportDataToExcel("","","病情变异明细.xls",cArguments);
	}
	*/
}
