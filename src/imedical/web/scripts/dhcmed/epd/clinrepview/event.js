
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.txtRegNo.on("select", obj.txtRegNo_select, obj);
		obj.btnNewRep.on('click',obj.btnNewRep_click,obj);
		obj.gridEpdReport.on("rowdblclick", obj.gridEpdReport_rowdblclick, obj);
		
		if (EpisodeID != ''){
			obj.txtRegNo.setValue(RegNo);
			objRegNoStore = obj.txtRegNo.getStore();
			objRegNoStore.load({
				callback : function() {
					var ind = this.find("Paadm",EpisodeID);
					if (ind > -1) {
						obj.txtRegNo.setValue(EpisodeID);
						obj.txtRegNo.setRawValue(RegNo);
						var objRec = this.getAt(ind);
						obj.txtRegNo_select(obj.txtRegNo,objRec);
						obj.btnNewRep_click();
					}
				},
				scope : objRegNoStore,
				add : false
			});
			obj.txtRegNo.setDisabled(true);
		}
		
		obj.txtPatName.setDisabled(true);
		obj.txtSex.setDisabled(true);
		obj.txtAge.setDisabled(true);
		obj.txtAdmType.setDisabled(true);
		obj.txtAdmLoc.setDisabled(true);
		obj.txtAdmDate.setDisabled(true);
		obj.txtAdmStatus.setDisabled(true);
		
		//提供给子窗体调用,刷新当前页面
		window.WindowRefresh_Handler = obj.WindowRefresh_Handler;
		
		//提供给子窗体调用,关闭当前页面
		window.WindowClose_Handler = obj.WindowClose_Handler;
	}
	
	obj.txtRegNo_select = function(cbo,rec){
		if (rec) {
			obj.txtPatName.setValue(rec.get('PatName'));
			obj.txtSex.setValue(rec.get('Sex'));
			obj.txtAge.setValue(rec.get('Age'));
			obj.txtAdmType.setValue(rec.get('AdmType'));
			obj.txtAdmLoc.setValue(rec.get('AdmLoc'));
			obj.txtAdmDate.setValue(rec.get('AdmDate'));
			obj.txtAdmStatus.setValue(rec.get('AdmStatus'));
			
			obj.EpisodeID = rec.get('Paadm');
			obj.PatientID = rec.get('PatientID');
			
			obj.gridEpdReportStore.removeAll();
			obj.gridEpdReportStore.load({});
		} else {
			obj.txtPatName.setValue('');
			obj.txtSex.setValue('');
			obj.txtAge.setValue('');
			obj.txtAdmType.setValue('');
			obj.txtAdmLoc.setValue('');
			obj.txtAdmDate.setValue('');
			obj.txtAdmStatus.setValue('');
			
			obj.EpisodeID = '';
			obj.PatientID = '';
			
			obj.gridEpdReportStore.removeAll();
		}
	}
	
	obj.btnNewRep_click = function()
	{
		var lnk="dhcmed.epd.report.csp?&1=1&PatientID=" + obj.PatientID + "&EpisodeID=" + obj.EpisodeID + "&ReportID=";
		obj.viewReportWin('winEpdReport',lnk);
	}
	
	obj.gridEpdReport_rowdblclick = function(objGrid, rowIndex)
	{
		var record = objGrid.getStore().getAt(rowIndex);
		var ReportID = record.get("RowID");
		var lnk="dhcmed.epd.report.csp?&1=1&PatientID=" + '' + "&EpisodeID=" + '' + "&ReportID=" + ReportID;
		obj.viewReportWin('winEpdReport',lnk);
	}
	
	obj.viewReportWin = function(winid,url){
		var win_report = new Ext.Window({
			id : winid,
			width : (window.screen.availWidth - 100),
			height : (window.screen.availHeight - 80),
			modal : true,
			plain : true,
			html : '<iframe id="' + winid + '" width=100% height=100% frameborder=0 scrolling=auto src="' + url + '"></iframe>'
		});
		win_report.show();
	}
	
	obj.WindowRefresh_Handler = function()
	{
		obj.gridEpdReportStore.load({});
	}
	
	obj.WindowClose_Handler = function()
	{
		var win_report = Ext.getCmp('winEpdReport');
		win_report.close();
	}
}
