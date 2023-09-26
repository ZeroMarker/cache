
function InitDMReportListEvent(obj){
	obj.LoadEvent=function(args){
		obj.gridDeathReport.on("rowdblclick",obj.gridDeathReport_click,obj);
		obj.btnFind.on('click',obj.btnFind_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.btnExportDtl.on('click',obj.btnExportDtl_click,obj);
		obj.cboSSHosp.on('select',obj.cboSSHosp_select,obj);
		obj.cboSSHosp.getStore().load({
			callback : function(){
				obj.gridDeathReportStore.load({params:{ start:0,limit:50 } });
			}
		});
		//obj.btnFind_click();
		
		//add by pylian 108577 加入监听，输入【登记号】回车不能自动补零 
		//输入框回车事件
		obj.txtRegNoENTER = function ()
		{
			var RegNo = obj.txtRegNo.getValue();
			RegNo=RegNo.replace(/(^\s*)|(\s*$)/g, "");
			var Reglength=RegNo.length
			for(var i=0;i<(10-Reglength);i++)
			{
				RegNo="0"+RegNo;
			}
			obj.txtRegNo.setValue(RegNo);
			
		}
		if (IsSecret!=1) {     //不涉密就隐藏【病人密级】和【病人级别】两列
			var cm = obj.gridDeathReport.getColumnModel();
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
	obj.cboSSHosp_select = function(){
		Common_SetValue("cboRepLoc","");
		obj.cboRepLoc.getStore().load();
	}
    obj.gridDeathReport_click=function(){
        var rowRecord=obj.gridDeathReport.getSelectionModel().getSelected();
        if (rowRecord==null) return;
        var reportRowId=rowRecord.get("RowID");
        var patientID=rowRecord.get("PatientID");
        var EpisodeID=rowRecord.get("EpisodeID");
        var locId=obj.cboRepLoc.getValue();
        if (locId==""){
           locId=session['LOGON.CTLOCID']
        }
        var objFunction=ExtTool.StaticServerObject("DHCMed.DTHService.ReportSrv");
        var menuId=objFunction.GetReportID("死亡报告");
        DeathReportLookUpHeader(reportRowId,EpisodeID);
	}
	obj.btnFind_click=function(){
		var startDate=obj.txtStartDate.getRawValue();
		var endDate=obj.txtEndDate.getRawValue();
		if ((startDate == '')||(endDate == '')) {
			ExtTool.alert("提示","开始日期、结束日期不允许为空!");
		}
		obj.gridDeathReportStore.load({
			params:{
				start:0
				,limit:50
			}
		});
	}
	
	obj.btnExport_click=function(){
		if (obj.gridDeathReport.getStore().getCount() < 1) {
			ExtTool.alert("确认", "无数据记录，不允许导出!");
			return;
		}
		var startDate=obj.txtStartDate.getRawValue();
		var endDate=obj.txtEndDate.getRawValue();
		var loc=obj.cboRepLoc.getValue();
		var hospId=obj.cboSSHosp.getValue();
		var status=obj.cboRepStatus.getValue();
		var PatName=obj.txtPatName.getValue();
		var MrNo=obj.txtMrNo.getValue();
		var RegNo=obj.txtRegNo.getValue();
		var Arg=startDate+"^"+endDate+"^"+loc+"^"+hospId+"^"+status+"^"+PatName+"^"+MrNo+"^"+RegNo;
		ExportDataToExcel("","","死亡报告查询列表",Arg);
	}
	
	//导出报告卡详细数据
	obj.btnExportDtl_click=function(){
		if (obj.gridDeathReport.getStore().getCount() < 1) {
			ExtTool.alert("确认", "无数据记录，不允许导出!");
			return;
		}
		var startDate=obj.txtStartDate.getRawValue();
		var endDate=obj.txtEndDate.getRawValue();
		var loc=obj.cboRepLoc.getValue();
		var hospId=obj.cboSSHosp.getValue();
		var status=obj.cboRepStatus.getValue();
		var PatName=obj.txtPatName.getValue();
		var MrNo=obj.txtMrNo.getValue();
		var RegNo=obj.txtRegNo.getValue();
		var Arg=startDate+"^"+endDate+"^"+loc+"^"+hospId+"^"+status+"^"+PatName+"^"+MrNo+"^"+RegNo;
		ExportDataToExcelNP("","","死亡报告明细表",Arg);
	}
}

function RefreshRowByReportID(ReportID){
	if (!ReportID) return;
	var RepStatusInfo = ExtTool.RunServerMethod("DHCMed.DTH.Report","GetStatusInfoByID",ReportID);
	if (RepStatusInfo == '') return;
	var arrStatus = RepStatusInfo.split('^');
	var objGrid = Ext.getCmp('gridDeathReport');
	if (!objGrid) return;
	var objStore = objGrid.getStore();
	if (!objStore) return
	var SelectIndex = objStore.find('RowID',ReportID);
	if (SelectIndex > -1){
		var rd = objStore.getAt(SelectIndex);
		rd.set('RepStatusCode',arrStatus[1]);
		rd.set('RepStatusDesc',arrStatus[2]);
		rd.commit();
	}
}
