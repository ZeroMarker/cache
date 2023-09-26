// dhcmed.fbd.qrybydate.csp
function InitviewScreenEvent(obj) {
	
	obj.LoadEvent = function(args) {
		obj.cboDateType.setValue("IndexReportDate");
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
				obj.gridReportStore.load({});
			}
		});
		//obj.gridReportStore.load({});
		obj.cboDiseaseCate.on('select', obj.cboDiseaseCate_select, obj);
		obj.btnQuery.on('click', obj.btnQuery_click, obj);
		obj.btnExportSel.on('click', obj.btnExportSel_click, obj);
		obj.btnExportAll.on('click', obj.btnExportAll_click, obj);
		obj.gridReport.on('rowdblclick', obj.gridReport_rowdbclick, obj);
		
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.gridReport.getColumnModel();
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
	
	obj.cboDiseaseCate_select = function() {
		obj.cboDiseaseDescStore.removeAll();
		obj.cboDiseaseDesc.setValue('');
		obj.cboDiseaseDescStore.load({});
	}
	
	obj.gridReport_rowdbclick = function(objGrid, rowIndex) {
		var record = obj.gridReportStore.getAt(rowIndex);
		var strUrl = "./dhcmed.fbd.report.csp?1=1"
		strUrl = strUrl + "&PatientID=" + record.get("PatientID");
		strUrl = strUrl + "&EpisodeID=" + record.get("EpisodeID");
		strUrl = strUrl + "&ReportID=" + record.get("ID");
		strUrl = strUrl + "&LocFlag=" + LocFlag;
		var r_width = "1170px", r_height = "682px";
		var v_left = (window.screen.availWidth - 10 - r_width) / 2;
		var v_top = (window.screen.availHeight - 10 - r_height) / 2;
		var r_params = "dialogWidth=" + r_width + ",dialogHeight=" + r_height + ",status=yes,toolbar=no,menubar=no,location=no";
		var ret = window.showModalDialog(strUrl, "_blank", r_params);
		if (ret) { obj.gridReportStore.load({}); }
	}
	
	obj.btnQuery_click = function() {
		//fix bug 7443 2015-03-02 未勾选【报告状态】查询时，页面显示空
		var repStatus = obj.GetSelStatus();
		if (repStatus == ''){
			window.alert("请选择报告状态！");
			return;
		}
		obj.gridReportStore.removeAll();
		obj.gridReportStore.load({});
	}
	
	obj.btnExportSel_click = function() {
		if (obj.gridReportStore.getCount()<1) {
			ExtTool.alert("确认", "无数据记录,不允许导出!");
			return;
		}
		var cntSel = 0;
		for (var i=0; i<obj.gridReportStore.getCount(); i++) {
			var record = obj.gridReportStore.getAt(i);
			if (record.get("checked")) {
				cntSel++;
				break;
			}
		}
		if (cntSel==0) {
			ExtTool.alert("提示", "请至少选中一行记录!");
			return;
		}
		var strFileName = "食源性疾病报告明细表";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridReport, strFileName, true);
	}
	
	obj.btnExportAll_click = function() {
		if (obj.gridReportStore.getCount()<1) {
			ExtTool.alert("确认", "无数据记录,不允许导出!");
			return;
		}
		var strFileName = "食源性疾病报告明细表";
		var objExcelTool = Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.gridReport, strFileName, false);
	}
	
}