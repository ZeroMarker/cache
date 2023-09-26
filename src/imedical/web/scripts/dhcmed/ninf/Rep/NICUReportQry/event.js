
function InitViewportEvent(obj) {
	obj.LoadEvent = function(args)
    {
		if (obj.AdminPower != '1') {
			obj.cboRepLoc.setDisabled(true);
			var LogLocID = session['LOGON.CTLOCID'];
			var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
			var objLoc = objCtlocSrv.GetObjById(LogLocID);
			if (objLoc) {
				obj.cboRepLoc.setValue(objLoc.Rowid);
				obj.cboRepLoc.setRawValue(objLoc.Descs);
			}
		}
		
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.btnExport.on("click", obj.btnExport_click, obj);
		obj.gridInfReport.on("rowdblclick", obj.gridInfReport_rowdblclick, obj);
		
		//提供给子窗体调用,刷新当前页面
		window.WindowRefresh_Handler = obj.WindowRefresh_Handler;
  	}
	
	obj.btnQuery_click = function()
	{
		obj.gridInfReportStore.removeAll();
		obj.gridInfReportStore.load({});
	}
	
	obj.btnExport_click = function(){
		if (obj.gridInfReport.getStore().getCount() > 0)
		{
			var strFileName=RepTypeDesc;
			var objExcelTool=Ext.dhcc.DataToExcelTool;
			objExcelTool.ExprotGrid(obj.gridInfReport,strFileName);
		} else {
			ExtTool.alert("提示","查询列表数据为空!");
		}
	}
	
	obj.gridInfReport_rowdblclick = function(objGrid, rowIndex)
	{
		var record = objGrid.getStore().getAt(rowIndex);
		var ReportID = record.get("ReportID");
		var url="dhcmed.ninf.rep.infreport.csp?1=1&ReportID="+ReportID+"&AdminPower="+obj.AdminPower+"&2=2";
		var oWin = window.open(url,'',"height=" + (window.screen.availHeight - 100) + ",width=" + (window.screen.availWidth - 100) + ",top=20,left=50,resizable=no");
	}
	
	obj.WindowRefresh_Handler = function()
	{
		obj.gridInfReportStore.load({});
	}
}

function DisplayEPRView(EpisodeID,PatientID)
{
	if (!EpisodeID) return;
	
	var strUrl = "./epr.newfw.episodelistbrowser.csp?EpisodeID=" + EpisodeID + "&PatientID=" + PatientID + "&2=2";
	var r_width = 950;
	var r_height = 600;
	var v_left = (window.screen.availWidth - 10 - r_width) / 2;		// 获得窗口的水平位置;
	var v_top = (window.screen.availHeight - 30 - r_height) / 2;	// 获得窗口的垂直位置;
	var r_params = "left=" + v_left +
					",top=" + v_top + 
					",width=" + r_width + 
					",height=" + r_height + 
					",status=yes,toolbar=no,menubar=no,location=no";
	window.open(strUrl, "_blank", r_params);
}

function ViewObservation(EpisodeID)
{
	if (!EpisodeID) return;

	var strUrl = "./dhcmeddoctempature.csp?"+"EmrCode=DHCNURTEM"+"&EpisodeID="+EpisodeID
	window.showModalDialog(strUrl ,"","dialogWidth=300px;dialogHeight=300px;status=no");
}
