

function InitPatientDtlEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.pnTimeLine.on("activate", obj.pnTimeLine_activate, obj);
		obj.pnCtlRst.on("activate", obj.pnCtlRst_activate, obj);
		obj.pnEpr.on("activate", obj.pnEpr_activate, obj);
		obj.pnLab.on("activate", obj.pnLab_activate, obj);
		obj.pnRis.on("activate", obj.pnRis_activate, obj);
		obj.pnOrder.on("activate", obj.pnOrder_activate, obj);
		obj.pnClose.on("activate", obj.pnClose_activate, obj);
		obj.ViewObservation.on("activate", obj.ViewObservation_activate, obj);
		
		obj.gridDiagnoseStore.load({});
	}
	
	obj.pnCtlRst_activate = function()
	{
		Ext.getCmp("dtCtlRstFromDate").setValue(obj.AdmitDate);
		obj.pnCtlRstStore.load({params : {start:0,limit:100}});
	}
	
	//因为timeline中csp路径问题，重新定义dhcmed.cc.timeline.csp，通过转发实现访问
	//csp/timeline/下的文件不需要再拷贝到csp目录下
	obj.pnTimeLine_activate = function()
	{
		var strTemplate = "./dhcmed.main.timelineview.csp?queryCode=&EpisodeID={0}&startDate={1}&timeLineId=INFReason&PatientID={2}";
		var strURL = String.format(strTemplate, obj.EpisodeID, obj.AdmitDate, obj.PatientID);
		document.getElementById("ifTimeLine").src = strURL;
	}
	
	 obj.ViewObservation_activate = function()
    {
		//alert(obj.EpisodeID);
		var strTemplate = "./dhcmed.ninf.srv.viewobservation.csp?+&EmrCode={0}&EpisodeID={1}";
		//window.showModalDialog(strUrl ,"","dialogWidth=300px;dialogHeight=300px;status=no");
		var strURL = String.format(strTemplate, "DHCNURTEM", obj.EpisodeID);
		document.getElementById("ifViewObservation").src = strURL;
    }
	
	obj.pnEpr_activate = function()
	{
		//var strTemplate = "./epr.newfw.episodelistbrowser.csp?EpisodeID={0}&PatientID={1}";
		var strTemplate = "./emr.record.browse.csp?EpisodeID={0}&PatientID={1}";     //update by jiangpengpeng 2015-07-13
		var strURL = String.format(strTemplate, obj.EpisodeID, obj.PatientID);
		document.getElementById("ifEpr").src = strURL;
	}
	
	obj.pnLab_activate = function()
	{
		var strTemplate = "./dhcmed.ninf.bc.labresult.csp?EpisodeID={0}&PatientID={1}";
		var strURL = String.format(strTemplate, obj.EpisodeID, obj.PatientID);
		document.getElementById("ifLab").src = strURL;
	}
	
	obj.pnRis_activate = function()
	{
		var strTemplate = "./dhcmed.ninf.bc.risresult.csp?EpisodeID={0}&PatientID={1}";
		var strURL = String.format(strTemplate, obj.EpisodeID, obj.PatientID);
		document.getElementById("ifRis").src = strURL;
	}
	
	obj.pnOrder_activate = function()
	{
		var strTemplate = "./dhcnurdoctorordersheet.csp?EpisodeID={0}&PatientID={1}";
		var strURL = String.format(strTemplate, obj.EpisodeID, obj.PatientID);
		document.getElementById("ifOrder").src = strURL;
	}
	
	obj.pnClose_activate = function()
	{
		obj.WinPatientDtl.close();
	}
}

