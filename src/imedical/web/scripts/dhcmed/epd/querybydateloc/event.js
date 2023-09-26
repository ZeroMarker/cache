function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args) {
		obj.cboHospital.on("expand", obj.cboHospital_OnExpand, obj);
		 //obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);  //fix bug 清空所选择的[报告科室]，重新选择[报告科室]时报错“未指明的错误”
		// obj.cboRepPlace.on("expand", obj.cboRepPlace_OnExpand, obj);
		// obj.cboCDCStatus.on("expand", obj.cboCDCStatus_OnExpand, obj);
		// obj.cboMIFKind.on("expand", obj.cboMIFKind_OnExpand, obj);
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		obj.btnExportAll.on("click", obj.btnExportAll_OnClick, obj);
		obj.DataGridPanel.on("rowdblclick", obj.DataGridPanel_rowdblclick, obj);
		
		//Add By LiYang 2014-07-28 增加批量导出的功能
		obj.btnExportWord.on("click", obj.btnExportWord_OnClick, obj);
		EpidemicExport.Init();

		// ******************************************************** //
		// Add By PanLei 2013-01-17
		// 解决辽阳中心医院提出：传染病报告查询页面，当选中一条报告记录后，点击头菜单“检验结果”，即可弹出辅检结果的页面
		obj.DataGridPanel.on("rowclick", obj.DataGridPanel_rowclick, obj);
		// ******************************************************** //
		/*
		obj.cboHospitalStore.load({
			callback : function() {
				if (session['LOGON.HOSPID']) {
					obj.cboHospital.setValue(session['LOGON.HOSPID']);
				}
				if (tDHCMedMenuOper['admin'] == '1') {
					obj.cboHospital.setDisabled(false);
				} else {
					obj.cboHospital.setDisabled(true);
				}
				obj.cboLocStore.load({
							callback : function() {
								if ((tDHCMedMenuOper['admin'] == '1') || (tDHCMedMenuOper['HospitalAdmin'] == '1')) {
									obj.cboLoc.setDisabled(false);
								} else {
									obj.cboLoc.setValue(session['LOGON.CTLOCID']);
									obj.cboLoc.setDisabled(true);
								}
							},
							scope : obj.cboLocStore,
							add : false
						});
			},
			scope : obj.cboHospitalStore,
			add : false
		});
		*/
		obj.cboHospital.getStore().load({
			callback : function(r){
				if (r.length > 0) {
					var objRec = r[0];
					obj.cboHospital.setValue(objRec.get("CTHospID"));
					obj.cboHospital.setRawValue(objRec.get("CTHospDesc"));
				}
				if (r.length < 2) {
					obj.cboHospital.setDisabled(true);
				}
				obj.btnQuery_OnClick();
			}
		});
		var objConfigManage = ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");
		obj.ReportUrl = objConfigManage.GetValueByKeyHosp("RunqianURL", "");
		obj.ReportFileName = "DHCMed.EPDService.EpidemicSrv_QueryForExport.raq";
		
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.DataGridPanel.getColumnModel();
    			var cfg = null;
	    		for(var i=0;i<cm.config.length;++i)
   	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}
	};

	obj.btnExport_OnClick = function() {
		if (obj.DataGridPanel.getStore().getCount() < 1) {
			ExtTool.alert("确认", "无数据记录，不允许导出!");
			return;
		}

		var store = obj.DataGridPanel.getStore();
		for (var i = 0; i < store.getCount(); i++) {
			var record = store.getAt(i);
			if (record.get("checked")) {
				break;
			} else {
				if (i == store.getCount() - 1) {
					ExtTool.alert("提示信息", "请至少选中一行记录!");
					return;
				}
			}
		}
		var strFileName = "传染病报告明细表";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.DataGridPanel, strFileName, true);
	};

	obj.btnExportAll_OnClick = function() {
		if (obj.DataGridPanel.getStore().getCount() < 1) {
			ExtTool.alert("确认", "无数据记录，不允许导出!");
			return;
		}
		var strFileName = "传染病报告明细表";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.DataGridPanel, strFileName, false);
	};
	
	obj.cboHospital_OnExpand = function() {
		obj.cboHospitalStore.load({});
		obj.cboLoc.clearValue();
	};
	
//	obj.cboLoc_OnExpand = function() {
//		obj.cboLocStore.load({});
//	};
//	obj.cboRepPlace_OnExpand = function() {
//		obj.cboRepPlaceStore.load({});
//	};
//	obj.cboCDCStatus_OnExpand = function() {
//		obj.cboCDCStatusStore.load({});
//	};
//	obj.cboMIFKind_OnExpand = function() {
//		obj.cboMIFKindStore.load({});
//	};
	
	obj.btnQuery_OnClick = function() {
		if(obj.dtToDate.getRawValue() < obj.dtFromDate.getRawValue()) {
			ExtTool.alert("提示", '开始日期应小于结束日期!');
	     }

		obj.DataGridPanelStore.removeAll();
		obj.DataGridPanelStore.load({});
	};

	// add by wuqk 2012-1-19 每5分钟刷新一次查询
	var task = {
		run : function() {
			obj.btnQuery_OnClick();
		},
		interval : 300000 // 1 second=1000 30000=5mins
	}
	Ext.TaskMgr.start(task);

	// 双击弹出上报窗口（页面居中）
	obj.DataGridPanel_rowdblclick = function(objGrid, rowIndex) {
		var record = obj.DataGridPanelStore.getAt(rowIndex);
		var strUrl = "./dhcmed.epd.report.csp?1=1" + 
						"&PatientID=" + record.get("PatientID") + 
						"&EpisodeID=" + record.get("Paadm") + 
						"&ReportID=" + record.get("RowID") + 
						"&IsSecret=" + IsSecret +
						"&LocFlag=" + LocFlag;
		var r_width = "1200px";
		var r_height = "630px";
		var v_left = (window.screen.availWidth - 10 - r_width) / 2;		// 获得窗口的水平位置;
		var v_top = (window.screen.availHeight - 30 - r_height) / 2;	// 获得窗口的垂直位置;
		var r_params = 	"dialogWidth=" + r_width + 
						",dialogHeight=" + r_height + 
						",status=yes,toolbar=no,menubar=no,location=no";

		var ret=window.showModalDialog(strUrl, "_blank", r_params);
		if(ret) obj.DataGridPanelStore.load({});
	};

	// ******************************************************************************************** //
	// Add By PanLei 2013-01-17
	// 解决辽阳中心医院提出：传染病报告查询页面，当选中一条报告记录后，点击头菜单“检验结果”，即可弹出辅检结果的页面
	obj.DataGridPanel_rowclick = function() {
		var rowIndex = arguments[1];
		var objRec = obj.DataGridPanelStore.getAt(rowIndex);
		var PatientID = objRec.get("PatientID");
		var EpisodeID = objRec.get("Paadm");
		// var DiseaseName = objRec.get("DiseaseName");
		// window.alert(objRec.get("CtrlDtl"));
		// var frm =top.document.forms["fEPRMENU"];
		// parent.frames[0].document.forms["fEPRMENU"];

		var frm = parent.document.forms["fEPRMENU"];
		if (frm) {
			var frmEpisodeID = frm.EpisodeID;
			var frmPatientID = frm.PatientID;
			// var frmmradm = frm.DiseaseName;
			frmPatientID.value = PatientID;
			frmEpisodeID.value = EpisodeID;
			// frmmradm.value = DiseaseName;
		}
		var frm = parent.parent.document.forms["fEPRMENU"];
		if (frm) {
			var frmEpisodeID = frm.EpisodeID;
			var frmPatientID = frm.PatientID;
			// var frmmradm = frm.DiseaseName;
			frmPatientID.value = PatientID;
			frmEpisodeID.value = EpisodeID;
			// frmmradm.value = DiseaseName;
		}
		var frm = parent.frames[0].document.forms["fEPRMENU"];
		if (frm) {
			var frmEpisodeID = frm.EpisodeID;
			var frmPatientID = frm.PatientID;
			// var frmmradm = frm.DiseaseName;
			frmPatientID.value = PatientID;
			frmEpisodeID.value = EpisodeID;
			// frmmradm.value = DiseaseName;
		}
		var frm = parent.parent.frames[0].document.forms["fEPRMENU"];
		if (frm) {
			var frmEpisodeID = frm.EpisodeID;
			var frmPatientID = frm.PatientID;
			// var frmmradm = frm.DiseaseName;
			frmPatientID.value = PatientID;
			frmEpisodeID.value = EpisodeID;
			// frmmradm.value = DiseaseName;
		}
	};
	// ******************************************************************************************** //

	obj.GetStatusList = function() {
		var StatusList = "*";
		var objStatusList = obj.cbgRepStatus.getValue();
		for (var statusIndex = 0; statusIndex < objStatusList.length; statusIndex++) {
			StatusList = StatusList + objStatusList[statusIndex].getName() + "*";
		}
		return StatusList;
	};
	
	
	//Add By LiYang 2014-07-28 增加不打开报告直接导出到Word的方法
	obj.btnExportWord_OnClick = function(){
		var arry = new Array();
		for(var i = 0; i < obj.DataGridPanelStore.getCount(); i ++)
		{
			var objRec = obj.DataGridPanelStore.getAt(i);
			if(!objRec.get("checked"))
				continue;
			var objRep = EpidemicExport.objRepManage.GetObjById(objRec.get("RowID"));
			arry[arry.length] = objRep;
		}
		if (arry.length==0) {
			ExtTool.alert("提示信息", "请至少选中一行记录!");
			return;
		}
		EpidemicExport.ExportEpidemicToWord(arry);
	}
	
	/*
	 * obj.btnExport_OnClick = function() { var strUrl = obj.ReportUrl +
	 * obj.ReportFileName + "&FromDate=" + obj.dtFromDate.getRawValue() +
	 * "&ToDate=" + obj.dtToDate.getRawValue() + "&Loc=" + obj.cboLoc.getValue() +
	 * "&Status=" + obj.GetStatusList() + "&RepPlace=" +
	 * obj.cboRepPlace.getValue() + "&UserLoc=" + session['LOGON.CTLOCID']; var
	 * objRepWin = new Ext.Window({ title : '传染病报告查询', height : 400, width :
	 * 600, modal : true, resizable : true, minimizable : true, maximizable :
	 * true, html : '<iframe height="100%" width="100%" src="' + strUrl + '">'
	 * }); objRepWin.show(); };
	 */
}

function DisplayHIVRep(RepID,EpisodeID,PatientID){
	var t=new Date();
		t=t.getTime();
	var url="dhcmed.epd.hivfollow.csp?1=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ReportID="+RepID + "&t=" + t;
	var sFeatures = "dialogWidth=" + window.screen.availWidth + "px;dialogHeight=" + window.screen.availHeight + "px;resizable=no;"
	window.showModalDialog(url,"",sFeatures);
}
