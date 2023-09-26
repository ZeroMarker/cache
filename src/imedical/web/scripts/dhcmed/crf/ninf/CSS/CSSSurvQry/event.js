function InitViewport1Event(obj) {
	obj.LoadEvent = function() {
		obj.cboHospital.on('select',obj.cboHospital_OnSelect,obj);
		obj.cboSurvNumber.on('select',obj.cboSurvNumber_OnSelect,obj);
		obj.cboLoc.on('select',obj.cboLoc_OnSelect,obj);
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.btnExport.on("click", obj.btnExport_click, obj);
		obj.btnExportToMK.on("click", obj.btnExportToMK_click, obj);
		obj.btnExportToMKAll.on("click", obj.btnExportToMKAll_click, obj);
		
		obj.GridPanel.on("rowdblclick", obj.GridPanel_rowdblclick, obj);
	};
	
	obj.cboHospital_OnSelect = function()
	{
		obj.cboSurvNumber.getStore().removeAll();
		obj.cboSurvNumber.getStore().load({});
		obj.cboLoc.getStore().removeAll();
		obj.cboLoc.getStore().load({});
		
		obj.cboSurvNumber.setValue('');
		obj.cboSurvNumber.setRawValue('');
		obj.cboLoc.setValue('');
		obj.cboLoc.setRawValue('');
	}
	
	obj.GridPanel_rowdblclick = function(objGrid, rowIndex)
	{
		var record = objGrid.getStore().getAt(rowIndex);
		var ReportID = record.get("LinkReport");
		var strURL = "dhcmed.ninf.css.clinreport.csp?1=1" + "&ReportID=" + ReportID + "&2=2";
		var ret = window.showModalDialog(strURL, null, "dialogHeight:" + (window.screen.availHeight - 100) + "px;dialogWidth:" + (window.screen.availWidth - 100) + "px;center:yes;scroll:no;toolbar=no;menubar=no;location=no;");
		if(ret*1>0){
			//更新成功触发事件
		}
	}
	
	obj.cboSurvNumber_OnSelect = function() {
		var SurvNumber = obj.cboSurvNumber.getRawValue();
		var SurvLocID = obj.cboLoc.getValue();
		if ((!SurvNumber)||(!SurvLocID)) return;
		//obj.btnQuery_click();
	};
	
	obj.cboLoc_OnSelect = function() {
		var SurvNumber = obj.cboSurvNumber.getRawValue();
		var SurvLocID = obj.cboLoc.getValue();
		if ((!SurvNumber)||(!SurvLocID)) return;
		//obj.btnQuery_click();
	};
	
	obj.btnQuery_click = function(){
		obj.GridPanelStore.removeAll();
		var SurvNumber = Common_GetText('cboSurvNumber');
		var Category = Common_GetValue('cbgCategory');
		if (SurvNumber == '') {
			ExtTool.alert("提示", "请选择调查编号!");
			return;
		}
		if (Category == '') {
			ExtTool.alert("提示", "请选择分类!");
			return;
		}
		obj.GridPanelStore.load({params : {start : 0,limit : 200}});
	};
	
	obj.btnExport_click = function(){
		if (obj.GridPanel.getStore().getCount() < 1) {
			ExtTool.alert("提示", "无数据记录，不允许导出!");
			return;
		}
		
		//var strFileName = "横断面调查查询列表";
		//var objExcelTool = Ext.dhcc.DataToExcelTool;
		//objExcelTool.ExprotGrid(obj.GridPanel, strFileName);
		
		var strFileName = "横断面调查查询列表";
		ExportGridByCls(obj.GridPanel, strFileName);
	};
	
	//导出民科接口按钮事件
	obj.btnExportToMK_click = function(objBtn, objEvent, skipMapping)
	{
		ExpAll = false;
		//是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var strRowIDList = "";
		for(var indRec = 0; indRec < obj.GridPanelStore.getCount(); indRec++)
		{
			var objRec = obj.GridPanelStore.getAt(indRec);
			if (objRec.get("checked")) {
				if (objRec.get("LinkReport") == '') continue;
				
				if(strRowIDList != "") strRowIDList += "^"
				strRowIDList += objRec.get("LinkReport")
			}
		}
		if(strRowIDList == "") {
			ExtTool.alert("提示","请选择需要导出的报告!");
			return;
		}
		
		ExtTool.RunQuery(
			{
				ClassName : 'DHCMed.NINFService.Srv.ExportMinKeCss',
				QueryName : 'QryValidateInfo',
				Arg1 : strRowIDList,
				Arg2 : "^",
				ArgCnt : 2
			},
			function(arryResult, skipMapping){
				if ((arryResult.length > 0) && (!skipMapping)) {
					var objFrm = new InitwinProblem(strRowIDList, "^", obj);
					objFrm.winProblem.show();
				} else {
					ExtTool.prompt("文件路径", "请输入民科横断面接口文件存放路径...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
								
								//创建进度条
								Ext.MessageBox.progress("接口文件", "开始导出民科横断面接口文件...");
								var intTotalCnt = 0;
								for(var indRec = 0; indRec < obj.GridPanelStore.getCount(); indRec++)
								{
									var objRec = obj.GridPanelStore.getAt(indRec);
									if (objRec.get("checked") == false) continue;
									if (objRec.get("LinkReport") == '') continue;
									intTotalCnt++;
								}
								
								for(var indRec = 0; indRec < obj.GridPanelStore.getCount(); indRec++)
								{
									var objRec = obj.GridPanelStore.getAt(indRec);
									if (objRec.get("checked") == false) continue;
									if (objRec.get("LinkReport") == '') continue;
									
									//更新进度条
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "正在处理：" + objRec.get("PapmiNo") + " " + objRec.get("Name"));
									
									//var ret = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinKeCss", "ExportReport", objRec.get("ReportID"), 1);
									var strfolderName = objRec.get("PapmiNo") + " " + objRec.get("Name") + " " + objRec.get("AdmDate");
									var strPath = ExportPath + "\\" + strfolderName;
									var exportFlg = objExportMinke.ExportMinkeData(objRec.get("LinkReport"), strPath);
									if (exportFlg){
										var inputStr = objRec.get("LinkReport");
										inputStr = inputStr + "^" + session['LOGON.USERID'];
										inputStr = inputStr + "^" + session['LOGON.CTLOCID'];
										exportFlg=ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinKeCss", "UpdateExportFlg", inputStr, "^");
										if (exportFlg){
											objRec.set('ExportFlg', exportFlg);
											objRec.commit();
										}
									}
								}
								
								//关闭进度条
								Ext.MessageBox.hide();
								
								ExtTool.confirm("接口文件", "共处理了" + intTotalCnt + "份横断面调查登记表,是否打开文件存放文件夹!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
							}
						},
						null,
						false,
						"D:\\民科横断面接口文件"
					)
				}
			}
			,obj
			,skipMapping
		)
	}
	
	obj.btnExportToMKAll_click = function(objBtn, objEvent, skipMapping)
	{
		ExpAll = true;
		//是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var strRowIDList = "";
		for(var indRec = 0; indRec < obj.GridPanelStore.getCount(); indRec++)
		{
			var objRec = obj.GridPanelStore.getAt(indRec);
			if (!objRec) continue;
			if (objRec.get("LinkReport") == '') continue;
			
			if(strRowIDList != "") strRowIDList += "^"
			strRowIDList += objRec.get("LinkReport");
		}
		if(strRowIDList == "") {
			ExtTool.alert("提示","报告列表中无报告!");
			return;
		}
		
		ExtTool.RunQuery(
			{
				ClassName : 'DHCMed.NINFService.Srv.ExportMinKeCss',
				QueryName : 'QryValidateInfo',
				Arg1 : strRowIDList,
				Arg2 : "^",
				ArgCnt : 2
			},
			function(arryResult, skipMapping){
				if ((arryResult.length > 0) && (!skipMapping)) {
					var objFrm = new InitwinProblem(strRowIDList, "^", obj);
					objFrm.winProblem.show();
				} else {
					ExtTool.prompt("文件路径", "请输入民科横断面接口文件存放路径...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
								
								//创建进度条
								Ext.MessageBox.progress("接口文件", "开始导出民科横断面接口文件...");
								var intTotalCnt = 0;
								for(var indRec = 0; indRec < obj.GridPanelStore.getCount(); indRec++)
								{
									var objRec = obj.GridPanelStore.getAt(indRec);
									if (!objRec) continue;
									if (objRec.get("LinkReport") == '') continue;
									intTotalCnt++;
								}
								
								for(var indRec = 0; indRec < obj.GridPanelStore.getCount(); indRec++)
								{
									var objRec = obj.GridPanelStore.getAt(indRec);
									if (!objRec) continue;
									if (objRec.get("LinkReport") == '') continue;
									
									//更新进度条
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "正在处理：" + objRec.get("PapmiNo") + " " + objRec.get("Name"));
									
									//var ret = ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinKeCss", "ExportReport", objRec.get("ReportID"), 1);
									var strfolderName = objRec.get("PapmiNo") + " " + objRec.get("Name") + " " + objRec.get("AdmDate");
									var strPath = ExportPath + "\\" + strfolderName;
									var exportFlg = objExportMinke.ExportMinkeData(objRec.get("LinkReport"), strPath);
									if (exportFlg){
										var inputStr = objRec.get("LinkReport");
										inputStr = inputStr + "^" + session['LOGON.USERID'];
										inputStr = inputStr + "^" + session['LOGON.CTLOCID'];
										exportFlg=ExtTool.RunServerMethod("DHCMed.NINFService.Srv.ExportMinKeCss", "UpdateExportFlg", inputStr, "^");
										if (exportFlg){
											objRec.set('ExportFlg', exportFlg);
											objRec.commit();
										}
									}
								}
								
								//关闭进度条
								Ext.MessageBox.hide();
								
								ExtTool.confirm("接口文件", "共处理了" + intTotalCnt + "份横断面调查登记表,是否打开文件存放文件夹!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
							}
						},
						null,
						false,
						"D:\\民科横断面接口文件"
					)
				}
			}
			,obj
			,skipMapping
		)
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