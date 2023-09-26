function InitMonitorViewportEvent(obj)
{	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_click, obj);	
		obj.btnExport.on("click", obj.btnExport_click, obj);	
	}
	obj.btnQuery_click = function()
	{
		obj.ResultGridPanelStore.removeAll();
		var DateFrom = obj.dfDateFrom.getValue();
		var DateTo = obj.dfDateTo.getValue();
		var sDate = new Date(DateFrom);
		var eDate = new Date(DateTo);
		if (sDate.getTime()>eDate.getTime()){
			ExtTool.alert("提示","开始日期不能大于结束日期！");
		}else if(((eDate.getTime()-sDate.getTime())/1000/60/60/24)>30){
			ExtTool.alert("提示","查询日期相差不能超过31天！");
		}else if ((obj.cboLoc.getValue() == "")&&(obj.cboOrd.getValue() == "")){
			ExtTool.alert("提示","请选择科室或抗生素");
		}else{
			obj.ResultGridPanelStore.load({});
		}
	}
	obj.btnExport_click = function(){
		if (obj.ResultGridPanel.getStore().getCount() > 0)
		{
			var strFileName="抗生素医嘱查询";
			var objExcelTool=Ext.dhcc.DataToExcelTool;
			objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
		} else {
			ExtTool.alert("提示","查询列表数据为空!");
		}
	}
	
	obj.cboLoc_OnExpand = function(){
		obj.cboLocStore.load({});
	}
	obj.cboOrd_OnExpand = function(){
		obj.cboOrdStore.load({});
	}
/*Viewport1新增代码占位符*/
}