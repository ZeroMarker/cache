function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
    {
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.gridEnviHyReportStore.load({params : {start : 0,limit : 50}});
		obj.cboSSHosp.on("expand",obj.cboSSHosp_expand,obj);
		obj.cboSSHosp.on("select",obj.cboSSHosp_select,obj);
  	}
	obj.btnQuery_click = function() {
		obj.gridEnviHyReportStore.load({params : {start : 0,limit : 50}});
	}
	obj.cboSSHosp_expand = function () {
		obj.cboLoc.setValue('');	
	}
	obj.cboSSHosp_select = function () {
		obj.cboLoc.getStore.load({});	
	}
	
    obj.ViewEnviHyReport = function(ReportID){
		InputEnviHyRst(ReportID,0);
	}
}

