function InitViewport1Event(obj) {
	obj.LoadEvent = function() {
		obj.cboHospital.on('select',obj.cboHospital_OnSelect,obj);
		obj.cboSurvNumber.on('select',obj.cboSurvNumber_OnSelect,obj);
		obj.cboLoc.on('select',obj.cboLoc_OnSelect,obj);
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.btnExport.on("click", obj.btnExport_click, obj);
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
	
	obj.cboSurvNumber_OnSelect = function() {
		var SurvNumber = obj.cboSurvNumber.getRawValue();
		var SurvLocID = obj.cboLoc.getValue();
		if ((!SurvNumber)||(!SurvLocID)) return;
		obj.btnQuery_click();
	};
	
	obj.cboLoc_OnSelect = function() {
		var SurvNumber = obj.cboSurvNumber.getRawValue();
		var SurvLocID = obj.cboLoc.getValue();
		if ((!SurvNumber)||(!SurvLocID)) return;
		obj.btnQuery_click();
	};
	
	obj.btnQuery_click = function(){
		obj.GridPanelStore.removeAll();
		var SurvNumber = obj.cboSurvNumber.getRawValue();
		var SurvLocID = obj.cboLoc.getValue();
		if ((!SurvNumber)||(!SurvLocID)) {
			ExtTool.alert("��ʾ", "��ѡ������źͿ���!");   //update by likai for bug:3887
			return;
		}
		
		obj.GridPanelStore.load({
			callback : function(){
				obj.GetPatCount();
			}
		});
	};
	
	obj.GetPatCount= function(){
		var YCCount = obj.GridPanel.getStore().getCount(); 
		if (YCCount==0) {
			var LocDesc = obj.cboLoc.getRawValue();
			ExtTool.alert("��ʾ", LocDesc+"û����Ҫ����Ļ���!");
			return;
		}
		var SCCount=0;
		for (var indRec = 0; indRec < YCCount; indRec++) {
	    	var record = obj.GridPanel.getStore().getAt(indRec);
	      	var value = record.get("LinkReport"); 
	      	if (value) {
	      		SCCount++;
	      	}
		}
		var bbar1=Ext.getCmp("bbar1");
		var bbar2=Ext.getCmp("bbar2");
	 	bbar1.el.dom.innerText='Ӧ��������' + YCCount;
	 	bbar2.el.dom.innerText='ʵ��������' + SCCount;
	};
	
	obj.btnExport_click = function(){
		if (obj.GridPanel.getStore().getCount() < 1) {
			ExtTool.alert("��ʾ", "�����ݼ�¼����������!");
			return;
		}
		
		var strFileName = "����洲�Ե���ǼǱ�";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.GridPanel, strFileName);
	};
	
	obj.UpdateBedRec = function(rowid,reportID){
		var objCls=ExtTool.StaticServerObject("DHCMed.NINF.CSS.BedSurvRec");
		var ret=objCls.UpdateCSSInfo(rowid,reportID);
		obj.btnQuery_click();
	}
	
	obj.NewHDMReport = function(rowid,PatientID ,EpisodeID){
		/* update by zf 2014-05-05
		var FormCode="DHCMed.CRF.NINFCrossSection"; // ��������
		var FormName="������������ǼǱ�";
		var strURL = "dhcmed.crf.reportfrom.csp?a=a" +
			"&EpisodeID=" + EpisodeID +
			"&PatientID=" + PatientID +
			"&GoalUserID=" +
			"&FormCode=" + FormCode +  
			"&Caption=" + FormName +
			"&DataID=" +  //DataID+
			"&LocFlag=";
		var ret = window.showModalDialog(strURL, null, "dialogHeight:600px;dialogWidth:800px;center:yes;scroll:no;toolbar=no;menubar=no;location=no;");	
		if(ret>0){
			obj.UpdateBedRec(rowid,ret);
		}
		*/
		var SurvNumber = Common_GetText('cboSurvNumber');
		var strURL = "dhcmed.ninf.css.clinreport.csp?a=a" + "&EpisodeID=" + EpisodeID + "&SurvNumber=" + SurvNumber;
		var height = (window.screen.availHeight - 50);
		var width = (window.screen.availWidth - 100);
		var ret = window.showModalDialog(strURL, null, "dialogHeight:" + height + "px;dialogWidth:" + width + "px;center:yes;scroll:no;toolbar=no;menubar=no;location=no;");	
		if(ret*1>0){
			obj.UpdateBedRec(rowid,ret);
		}
	}
	
	obj.OpenHDMReport = function(rowid,ReportID){
		/* update by zf 2014-05-05
		var strURL = "dhcmed.crf.reportfrom.csp?a=a" +
			"&EpisodeID=" + //EpisodeID +
			"&PatientID=" + //PatientID +
			"&GoalUserID=" +
			"&FormCode=" + //FormCode +  
			"&Caption=" + //FormName +
			"&DataID=" + ReportID+
			"&LocFlag=1"; //�����
		var ret = window.showModalDialog(strURL, null, "dialogHeight:600px;dialogWidth:800px;center:yes;scroll:no;toolbar=no;menubar=no;location=no;");	
		if(ret>0){
			obj.UpdateBedRec(rowid,ReportID);
		}
		*/
		var strURL = "dhcmed.ninf.css.clinreport.csp?a=a" + "&ReportID=" + ReportID;
		var height = (window.screen.availHeight - 50);
		var width = (window.screen.availWidth - 100);
		var ret = window.showModalDialog(strURL, null, "dialogHeight:" + height + "px;dialogWidth:" + width + "px;center:yes;scroll:no;toolbar=no;menubar=no;location=no;");	
		if(ret*1>0){
			obj.UpdateBedRec(rowid,ret);
		}
	}
}
function DisplayEPRView(EpisodeID,PatientID)
{
	if (!EpisodeID) return;
	//emr.record.browse.csp����EPR3���°���Ӳ���
    //epr.newfw.episodelistbrowser.csp���ھɰ���Ӳ���EPR2
    //update by pylian 2015-09-17 ���µ��Ӳ����ĵ�ַ
	var strUrl = "./emr.record.browse.csp?EpisodeID=" + EpisodeID + "&PatientID=" + PatientID + "&2=2";
	var r_width = 950;
	var r_height = 600;
	var v_left = (window.screen.availWidth - 10 - r_width) / 2;		// ��ô��ڵ�ˮƽλ��;
	var v_top = (window.screen.availHeight - 30 - r_height) / 2;	// ��ô��ڵĴ�ֱλ��;
	var r_params = "left=" + v_left +
					",top=" + v_top + 
					",width=" + r_width + 
					",height=" + r_height + 
					",status=yes,toolbar=no,menubar=no,location=no,resizable=yes";
	window.open(strUrl, "_blank", r_params);
}