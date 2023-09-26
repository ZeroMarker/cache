function InitMonitorViewportEvent(obj)
{	obj.LoadEvent = function(args)
	{
	}
	obj.btnQuery_click = function()
	{
		//par= obj.cboPathWayDic.getValue();
		//alert(par)
		obj.ResultGridPanelStore.load({});
	};
	obj.cboLoc_OnExpand = function(){
		obj.cboLocStore.load({});
	}	
/*Viewport1新增代码占位符*/
}