
function InitAimRepLnkEvent(obj) {
	obj.LoadEvent = function(args){
		obj.pnAimReport.on("activate", obj.pnAimReport_activate, obj);
		obj.pnClose.on("activate", obj.pnClose_activate, obj);
	}
	
	obj.pnClose_activate = function()
	{
		obj.WinAimRepLnk.close();
	}
	
	obj.pnAimReport_activate = function()
	{
		var EpisodeID = obj.EpisodeID;
		var CtlResults = obj.CtlResults;
		var strAdmTrans = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CtlAimRepSrv","GetMRBAdmTrans",EpisodeID, CtlResults);
		if (strAdmTrans == '') return;
		var arrAdmTrans = strAdmTrans.split("^");
		
		var strUrl = "./dhcmed.ninf.rep.aimreport.csp?1=1&EpisodeID=" + arrAdmTrans[0] + "&TransID=" + arrAdmTrans[1] + "&TransLoc=" + arrAdmTrans[2] + "&ModuleList=" + arrAdmTrans[3] + "&2=2";
		document.getElementById("ifAimReport").src = strUrl;
	}
}

