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
			//���³ɹ������¼�
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
			ExtTool.alert("��ʾ", "��ѡ�������!");
			return;
		}
		if (Category == '') {
			ExtTool.alert("��ʾ", "��ѡ�����!");
			return;
		}
		obj.GridPanelStore.load({params : {start : 0,limit : 200}});
	};
	
	obj.btnExport_click = function(){
		if (obj.GridPanel.getStore().getCount() < 1) {
			ExtTool.alert("��ʾ", "�����ݼ�¼����������!");
			return;
		}
		
		//var strFileName = "���������ѯ�б�";
		//var objExcelTool = Ext.dhcc.DataToExcelTool;
		//objExcelTool.ExprotGrid(obj.GridPanel, strFileName);
		
		var strFileName = "���������ѯ�б�";
		ExportGridByCls(obj.GridPanel, strFileName);
	};
	
	//������ƽӿڰ�ť�¼�
	obj.btnExportToMK_click = function(objBtn, objEvent, skipMapping)
	{
		ExpAll = false;
		//�Ƿ������ֵ���ռ�飨true��������
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
			ExtTool.alert("��ʾ","��ѡ����Ҫ�����ı���!");
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
					ExtTool.prompt("�ļ�·��", "��������ƺ����ӿ��ļ����·��...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
								
								//����������
								Ext.MessageBox.progress("�ӿ��ļ�", "��ʼ������ƺ����ӿ��ļ�...");
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
									
									//���½�����
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "���ڴ���" + objRec.get("PapmiNo") + " " + objRec.get("Name"));
									
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
								
								//�رս�����
								Ext.MessageBox.hide();
								
								ExtTool.confirm("�ӿ��ļ�", "��������" + intTotalCnt + "�ݺ�������ǼǱ�,�Ƿ���ļ�����ļ���!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
							}
						},
						null,
						false,
						"D:\\��ƺ����ӿ��ļ�"
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
		//�Ƿ������ֵ���ռ�飨true��������
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
			ExtTool.alert("��ʾ","�����б����ޱ���!");
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
					ExtTool.prompt("�ļ�·��", "��������ƺ����ӿ��ļ����·��...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
								
								//����������
								Ext.MessageBox.progress("�ӿ��ļ�", "��ʼ������ƺ����ӿ��ļ�...");
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
									
									//���½�����
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "���ڴ���" + objRec.get("PapmiNo") + " " + objRec.get("Name"));
									
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
								
								//�رս�����
								Ext.MessageBox.hide();
								
								ExtTool.confirm("�ӿ��ļ�", "��������" + intTotalCnt + "�ݺ�������ǼǱ�,�Ƿ���ļ�����ļ���!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
							}
						},
						null,
						false,
						"D:\\��ƺ����ӿ��ļ�"
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
	var v_left = (window.screen.availWidth - 10 - r_width) / 2;		// ��ô��ڵ�ˮƽλ��;
	var v_top = (window.screen.availHeight - 30 - r_height) / 2;	// ��ô��ڵĴ�ֱλ��;
	var r_params = "left=" + v_left +
					",top=" + v_top + 
					",width=" + r_width + 
					",height=" + r_height + 
					",status=yes,toolbar=no,menubar=no,location=no";
	window.open(strUrl, "_blank", r_params);
}