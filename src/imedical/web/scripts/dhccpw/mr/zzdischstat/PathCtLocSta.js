
function PathWayStatisticsEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.gridDischStatStore.load({});
		obj.gridDischStat.on("rowdblclick", obj.gridDischStat_rowdblclick, obj);
		obj.btnExport.on("click", obj.btnExport_click, obj);
	}
	
	obj.gridDischStat_rowdblclick = function() {
		var rowIndex = arguments[1];
		var objRec = obj.gridDischStatStore.getAt(rowIndex);
		var CTLocID = objRec.get("CtRowid");
		var CTLocDesc=objRec.get('CtDesc');
		var CTLocPatNum=objRec.get('CTLOCNum');
		var PathWayPerson=objRec.get('pathWayPerson');
		var PathWayNum=objRec.get('pathWayNum');
		if (PathWayPerson==0 || PathWayPerson=="") {
			return;
		}
		
		var DateFrom = obj.dtDateFrom.getRawValue();
		var DateTo = obj.dtDateTo.getRawValue();
		var Title = "<font color='Royal Blue'>科室</font>：" + CTLocDesc;
		Title = Title + "&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>出院人数</font>：" + CTLocPatNum;
		Title = Title + "&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>入径人数</font>：" + PathWayPerson;
		Title = Title + "&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>路径数</font>：" + PathWayNum;
		
		DischStatDtlLookUpHeader(DateFrom,DateTo,CTLocID,Title);
	}
	
	obj.btnExport_click = function() {
		var strFileName="出院患者统计";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridDischStat,strFileName);
	}
}

function InitviewSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.gridDischStatDtlStore.load({});
		obj.btnDtlExport.on("click", obj.btnDtlExport_click, obj);
	};
	
	obj.btnDtlExport_click = function() {
		var strFileName="出院患者-出入径明细列表";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridDischStatDtl,strFileName);
	}
}

function DischStatDtlLookUpHeader(DateFrom,DateTo,CTLocID,Title)
{
	var objSubWindow = new InitviewSubWindow(DateFrom,DateTo,CTLocID,Title);
	objSubWindow.DtlSubWindow.show();
	var numTop=(screen.availHeight-objSubWindow.DtlSubWindow.height)/2;
	var numLeft=(screen.availWidth-objSubWindow.DtlSubWindow.width)/2;
	objSubWindow.DtlSubWindow.setPosition(numLeft,numTop);
	//ExtDeignerHelper.HandleResize(objSubWindow);
}