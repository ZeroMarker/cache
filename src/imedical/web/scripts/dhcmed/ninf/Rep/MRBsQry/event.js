
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args) {
		//var curDate = new Date();
		//var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		//var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		//Common_SetValue('txtDateFrom',timeYesterday);
		obj.txtDateFrom.setValue(new Date().add(Date.DAY, -1));
		
		obj.cboSSHosp.on('expand',obj.cboSSHosp_expand,obj);		//add by yanjf 20140417
		obj.cboSSHosp.on('select',obj.cboSSHosp_Select,obj);		//add by yanjf 20140417
		
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnExport.on("click",obj.btnExport_click,obj);
		obj.checkMDR.on("check",obj.checkMDR_check,obj);
		
		obj.gridLabResult.on("rowcontextmenu", obj.gridLabResult_rowcontextmenu, obj);
		var objCmp = Ext.getCmp("mnuMRBCasesX");
		if (objCmp) objCmp.on("click", obj.mnuMRBCasesX_click, obj);
        var objCmp = Ext.getCmp("mnuBaseInfo");
		if (objCmp) objCmp.on("click", obj.mnuBaseInfo_click, obj);
        var objCmp = Ext.getCmp("mnuLabReport");
		if (objCmp) objCmp.on("click", obj.mnuLabReport_click, obj);
		var objCmp = Ext.getCmp("mnuObservation");
		if (objCmp) objCmp.on("click", obj.mnuObservation_click, obj);
		var objCmp = Ext.getCmp("mnuPrintAntiDrug");
		if (objCmp) objCmp.on("click", obj.mnuPrintAntiDrug_click, obj);
		var objCmp = Ext.getCmp("mnuExportAntiDrug");
		if (objCmp) objCmp.on("click", obj.mnuExportAntiDrug_click, obj);
		
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.gridLabResult.getColumnModel();
    			var cfg = null;
    			for(var i=0;i<cm.config.length;++i)
   	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
		
		obj.checkMDR_check();
		obj.btnQuery_click();
  	};
	
    obj.cboSSHosp_expand=function(){
	    obj.cboLoc.setValue('');
	}
	obj.cboSSHosp_Select=function(){
	    obj.cboLoc.getStore().load({}); 
	}
	
	//查看检验报告
	obj.mnuLabReport_click = function(){
		if (obj.gridLabResult.getSelectionModel().getCount() == 0) return;
        var objRec = obj.gridLabResult.getSelectionModel().getSelected();
        ShowTestWin(objRec.get("PatientID"),objRec.get("OEItemID"),objRec.get("TestSetRow"));
	}
	
	obj.checkMDR_check = function() {
		Common_SetValue('cboMRBDic',"","");
		if (Common_GetValue('checkMDR')) {
			Common_SetDisabled('cboMRBDic',false);
		} else {
			Common_SetDisabled('cboMRBDic',true);
		}
	}
	
	obj.btnQuery_click = function() {
		obj.gridLabResultStore.load({params : {start : 0,limit : 200}});
	}
	
	obj.btnExport_click = function() {
		var strFileName="多重耐药菌明细";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridLabResult,strFileName);
	}
	
	obj.gridLabResult_rowcontextmenu = function(grid,rowIndex,e) {
		grid.getSelectionModel().clearSelections();
		grid.getSelectionModel().selectRow(rowIndex,true);
		//Ext.getCmp("mnuMRBCasesX").disable();
		//Ext.getCmp("mnuMRBCasesX").enable();
        obj.mnuMenu.showAt(e.getXY());
        e.stopEvent();
    }
    
    obj.mnuObservation_click = function()
    {
        if (obj.gridLabResult.getSelectionModel().getCount() == 0) return;
        var objRec = obj.gridLabResult.getSelectionModel().getSelected();
		var strUrl = "./dhcmed.ninf.srv.viewobservation.csp?"+"EmrCode=DHCNURTEM"+"&EpisodeID="+objRec.get("Paadm");
		window.showModalDialog(strUrl ,"","dialogWidth=300px;dialogHeight=300px;status=no");
    }

    obj.mnuPrintAntiDrug_click = function()
    {
		if (obj.gridLabResult.getSelectionModel().getCount() == 0) return;
        var objRec = obj.gridLabResult.getSelectionModel().getSelected();
		var paadm = objRec.get("Paadm");
		var TestSetRow = objRec.get("TestSetRow");
		var OEItemID = objRec.get("OEItemID");
		var cArguments=paadm+"^"+TestSetRow+"^"+OEItemID;
		var flg=PrintDataByExcel("","","",cArguments);
    }
    obj.mnuExportAntiDrug_click = function()
    {

		if(obj.gridLabResult.getSelectionModel().getCount() == 0) return;
        var objRec = obj.gridLabResult.getSelectionModel().getSelected();
		var paadm = objRec.get("Paadm");
		var TestSetRow = objRec.get("TestSetRow");
		var OEItemID = objRec.get("OEItemID");
		var cArguments=paadm+"^"+TestSetRow+"^"+OEItemID;
		var flg=ExportDataToExcel("","","",cArguments);
    }
    obj.mnuMRBCasesX_click = function()
    {
        if (obj.gridLabResult.getSelectionModel().getCount() == 0) return;
        var objRec = obj.gridLabResult.getSelectionModel().getSelected();
        var frmMsgSender = new InitSendMassage(objRec.get("Paadm"),objRec.get("ActDate"));
        frmMsgSender.winSendMassage.show();
		frmMsgSender.LoadPage();
    }
    
    obj.mnuBaseInfo_click = function()
    {
        if (obj.gridLabResult.getSelectionModel().getCount() == 0) return;
        var objRec = obj.gridLabResult.getSelectionModel().getSelected();
		var objDisplayWin = new InitPatientDtl(objRec.get("Paadm"),"INTCCS");
		objDisplayWin.WinPatientDtl.show();
    }
}

function ShowTestWin(PatientID, OrderID, LabTestNo)
{
	var obj = new Object();
	var strURL = "./dhcmed.ninf.labreportview.csp?PatientID=" + PatientID + 
			"&TestSetRow=" + LabTestNo +
			"&OrderID="+ OrderID;
	obj.objWin = new Ext.Window(
		{
			title:"辅助检查结果",
			html:"<iframe id='labWin' height='420' width='1000' src='" + strURL + "'/>",
			height:500,
			width:1000,
			modal:true,
			buttons:[
				{
					text : "关闭",
					handler: function(){
						obj.objWin.close();
					}
				}
			]
			
		}
	);
	
	obj.objWin.show();
	return obj;
}