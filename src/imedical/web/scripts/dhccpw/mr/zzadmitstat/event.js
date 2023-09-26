
function InitviewMainEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.gridAdmStatStore.load({});
		obj.gridAdmStat.on("rowdblclick", obj.gridAdmStat_rowdblclick, obj);
		obj.btnExport.on("click", obj.btnExport_click, obj);
	}
	
	obj.gridAdmStat_rowdblclick = function() {
		var rowIndex = arguments[1];
		var objRec = obj.gridAdmStatStore.getAt(rowIndex);
		var CTLocID = objRec.get("CtRowid");
		var CTLocDesc = objRec.get("CtDesc");
		var InHospitalNum = objRec.get("InHospitalNum");
		var InPathWayNum = objRec.get("InPathWayNum");
		var PathWayNum = objRec.get("PathWayNum");
		if (InPathWayNum==0 || InPathWayNum=="") {
			return;
		}
		
		var Title = "<font color='Royal Blue'>科室</font>：" + CTLocDesc;
		Title = Title + "&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>在院人数</font>：" + InHospitalNum;
		Title = Title + "&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>入径人数</font>：" + InPathWayNum;
		Title = Title + "&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>路径数</font>：" + PathWayNum;
		
		AdmStatDtlLookUpHeader(CTLocID,Title);
	}
	
	obj.btnExport_click = function() {
		var strFileName="在院患者统计";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridAdmStat,strFileName);
	}
}

function InitviewSubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.gridAdmStatDtlStore.load({});
		obj.btnDtlExport.on("click", obj.btnDtlExport_click, obj);
	};
	
	obj.btnDtlExport_click = function() {
		var strFileName="在院患者-出入径明细列表";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridAdmStatDtl,strFileName);
	}
}

function AdmStatDtlLookUpHeader(CTLocID,Title)
{
	var objSubWindow = new InitviewSubWindow(CTLocID,Title);
	objSubWindow.DtlSubWindow.show();
	var numTop=(screen.availHeight-objSubWindow.DtlSubWindow.height)/2;
	var numLeft=(screen.availWidth-objSubWindow.DtlSubWindow.width)/2;
	objSubWindow.DtlSubWindow.setPosition(numLeft,numTop);
	//ExtDeignerHelper.HandleResize(objSubWindow);
}