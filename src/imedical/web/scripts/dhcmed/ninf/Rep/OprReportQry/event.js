var ExpAll=0;
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
		//Add By LiYang 2013-01-08 导出民科接口按钮事件
		obj.btnExportInterface.on("click", obj.btnExportInterface_click, obj);
		obj.btnExportAllInterface.on("click", obj.btnExportAllInterface_click, obj);
		
		//提供给子窗体调用,刷新当前页面
		window.WindowRefresh_Handler = obj.WindowRefresh_Handler;
		
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.gridInfReport.getColumnModel();
			var cfg = null;
			for(var i=0;i<cm.config.length;++i)
	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
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
	
	//Add By LiYang 2013-01-08 导出民科接口按钮事件
	obj.btnExportInterface_click = function(objBtn, objEvent, skipMapping)
	{
		var RepType="OPR";
		ExpAll=0;
		//是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var strRowIDList = "";
		for(var indRec = 0; indRec < obj.gridInfReportStore.getCount(); indRec++)
		{
			var objRec = obj.gridInfReportStore.getAt(indRec);
			if (objRec.get("checked")) {
			
				if(strRowIDList != "") strRowIDList += "^"
				strRowIDList += objRec.get("ReportID")
			}
		}
		if(strRowIDList == "") {
			ExtTool.alert("提示","请选择需要导出的报告!");
			return;
		}
		
		ExtTool.RunQuery(
			{
				ClassName : 'DHCMed.NINFService.Srv.ExportMinkeSrv',
				QueryName : 'QryValidateInfo',
				Arg1 : strRowIDList,
				Arg2 : "^",
				Arg3 : RepType,
				ArgCnt : 3
			},
			function(arryResult, skipMapping){
				if ((arryResult.length > 0) && (!skipMapping)) {
					var objFrms = new InitwinProblem(strRowIDList, "^",RepType, obj);
					objFrms.winProblem.show();
				} else {
					ExtTool.prompt("文件路径", "请输入民科接口文件存放路径...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
								
								//创建进度条
								Ext.MessageBox.progress("接口文件", "开始导出民科接口文件...");
								var intTotalCnt = 0;
								for(var indRec = 0; indRec < obj.gridInfReportStore.getCount(); indRec++)
								{
									var objRec = obj.gridInfReportStore.getAt(indRec);
									if (objRec.get("checked") == false) continue;
									intTotalCnt++;
								}
								
								for(var indRec = 0; indRec < obj.gridInfReportStore.getCount(); indRec++)
								{
									var objRec = obj.gridInfReportStore.getAt(indRec);
									if (objRec.get("checked") == false) continue;
									
									//更新进度条
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "正在处理：" + objRec.get("PapmiNo") + " " + objRec.get("PatName"));
									
									//var ret = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinkeSrv", "ExportReport", objRec.get("ReportID"), 1);
									var strfolderName = objRec.get("PapmiNo") + " " + objRec.get("PatName") + " " + objRec.get("AdmitDate");
									var strPath = ExportPath + "\\" + strfolderName;
									
									objExportMinke.ExportMinkeData(objRec.get("ReportID"), strPath,RepType);
								}
								
								//关闭进度条
								Ext.MessageBox.hide();
								
								ExtTool.confirm("接口文件", "共处理了" + intTotalCnt + "份患者感染报告信息,是否打开文件存放文件夹!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
								
								//打开民科程序，导入报告信息
								//objExportMinke.LaunchMinkeInterface(ExportPath);
							}
						},
						null,
						false,
						"D:\\民科手术接口文件"
					)
				}
			}
			,obj
			,skipMapping
		)
	}
	
	
	//Add By LiYang 2013-01-08 导出民科接口按钮事件
	obj.btnExportAllInterface_click = function(objBtn, objEvent, skipMapping)
	{
		var RepType="OPR";
		ExpAll=1;
		//是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var strRowIDList = "";
		for(var indRec = 0; indRec < obj.gridInfReportStore.getCount(); indRec++)
		{
			var objRec = obj.gridInfReportStore.getAt(indRec);
			//if (objRec.get("checked")) {
			
				if(strRowIDList != "") strRowIDList += "^"
				strRowIDList += objRec.get("ReportID")
			//}
		}
		
		if(strRowIDList == "") {
			ExtTool.alert("提示","请选择需要导出的报告!");
			return;
		}
		
		ExtTool.RunQuery(
			{
				ClassName : 'DHCMed.NINFService.Srv.ExportMinkeSrv',
				QueryName : 'QryValidateInfo',
				Arg1 : strRowIDList,
				Arg2 : "^",
				Arg3 : RepType,
				ArgCnt : 3
			},
			function(arryResult, skipMapping){
				if ((arryResult.length > 0) && (!skipMapping)) {
					var objFrm = new InitwinProblem(strRowIDList, "^",RepType, obj);
					objFrm.winProblem.show();
				} else {
					ExtTool.prompt("文件路径", "请输入民科接口文件存放路径...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
								
								//创建进度条
								Ext.MessageBox.progress("接口文件", "开始导出民科接口文件...");
								var intTotalCnt = 0;
								for(var indRec = 0; indRec < obj.gridInfReportStore.getCount(); indRec++)
								{
									var objRec = obj.gridInfReportStore.getAt(indRec);
									//if (objRec.get("checked") == false) continue;
									intTotalCnt++;
								}
								
								for(var indRec = 0; indRec < obj.gridInfReportStore.getCount(); indRec++)
								{
									var objRec = obj.gridInfReportStore.getAt(indRec);
									//if (objRec.get("checked") == false) continue;
									
									//更新进度条
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "正在处理：" + objRec.get("PapmiNo") + " " + objRec.get("PatName"));
									
									//var ret = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinkeSrv", "ExportReport", objRec.get("ReportID"), 1);
									var strfolderName = objRec.get("PapmiNo") + " " + objRec.get("PatName") + " " + objRec.get("AdmitDate");
									var strPath = ExportPath + "\\" + strfolderName;
									
									objExportMinke.ExportMinkeData(objRec.get("ReportID"), strPath,RepType);
								}
								
								//关闭进度条
								Ext.MessageBox.hide();
								
								ExtTool.confirm("接口文件", "共处理了" + intTotalCnt + "份患者感染报告信息,是否打开文件存放文件夹!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
								
								//打开民科程序，导入报告信息
								//objExportMinke.LaunchMinkeInterface(ExportPath);
							}
						},
						null,
						false,
						"D:\\民科手术接口文件"
					)
				}
			}
			,obj
			,skipMapping
		)
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
