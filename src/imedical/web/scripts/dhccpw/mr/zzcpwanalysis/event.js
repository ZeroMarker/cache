
function InitMonitorViewportEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		obj.btnBuild.on("click", obj.btnBuild_OnClick, obj);
	}
	obj.btnQuery_OnClick = function()
	{
		obj.ResultGridPanelStore.removeAll();
		if (obj.cboAnalysisType.getValue()=='')
		{
			//ExtTool.alert("提示","请选择统计类型!");
			ExtTool.alert("提示","请选择统计方式!");	//	Modified by zhaoyu 2012-11-16 查询统计--临床路径月报表-不输入【统计方式】直接点击【查询】，提示"请选择统计类型" 缺陷编号168
			return;
		}
		obj.ResultGridPanelStore.load({});
	}
	obj.btnExport_OnClick = function(){
		var strFileName="医疗机构临床路径管理信息月报表";
		var ctloc=obj.cboLoc.getRawValue();
		if (ctloc==""){
			strFileName=strFileName+"-全院";
		}
		else{
			strFileName=strFileName+"-"+ctloc;
		}
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
	}
	//Add BY Niucaicai 2011-08-18 自动任务批量处理数据 按钮事件
	obj.btnBuild_OnClick = function()
	{
		var dfDateFrom = obj.dfDateFrom.getRawValue();
		var dfDateTo = obj.dfDateTo.getRawValue();
		if((dfDateFrom=="")||(dfDateTo==""))
		{
			ExtTool.alert("提示","开始日期、结束日期都不能为空!!");
			return;
		}
		var objClinPathWayAnalysisBat = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWayAnalysisBat");
		var ret = objClinPathWayAnalysisBat.BatchAnalysisData(dfDateFrom,dfDateTo,0);
		if(ret<0)
		{
			ExtTool.alert("提示","初始数据失败!!");
			return;
		}
		if(ret>=0)
		{
			ExtTool.alert("提示","初始数据成功，共 "+ret+" 条数据!");
			return;
		}
	}
}
