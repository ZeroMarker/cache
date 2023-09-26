
var btnNewRep=document.getElementById("btnCompRep");
if(btnNewRep){
 	btnNewRep.onclick=btnNewRep_click;	
}
function btnNewRep_click()
{
	var EpisodeID = GetParam(window,"EpisodeID");
	var TransID = GetParam(window,"TransID");
	var TransLoc = GetParam(window,"TransLoc");
	var AdminPower = GetParam(window,"AdminPower");
 	var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=COMP&EpisodeID="+EpisodeID+"&TransID="
 	+TransID+"&TransLoc="+TransLoc+"&AdminPower="+AdminPower+"&ReportID=&2=2";
 	window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=850px;dialogHeight=600px;status=no");
	
	//var oWin = window.open(lnk,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	window.location.reload();
}

var btnICURep=document.getElementById("btnICURep");
if(btnICURep){
 	btnICURep.onclick=btnICURep_click;	
}
function btnICURep_click()
{
	var EpisodeID = GetParam(window,"EpisodeID");
	var TransID = GetParam(window,"TransID");
	var TransLoc = GetParam(window,"TransLoc");
	var AdminPower = GetParam(window,"AdminPower");
 	var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=ICU&EpisodeID="+EpisodeID+"&TransID="
 	+TransID+"&TransLoc="+TransLoc+"&AdminPower="+AdminPower+"&ReportID=&2=2";
 	window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=850px;dialogHeight=600px;status=no");
	
	//var oWin = window.open(lnk,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	window.location.reload();
}

var btnNICURep=document.getElementById("btnNICURep");
if(btnNICURep){
 	btnNICURep.onclick=btnNICURep_click;	
}
function btnNICURep_click()
{
	var EpisodeID = GetParam(window,"EpisodeID");
	var TransID = GetParam(window,"TransID");
	var TransLoc = GetParam(window,"TransLoc");
	var AdminPower = GetParam(window,"AdminPower");
 	var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=NICU&EpisodeID="+EpisodeID+"&TransID="
 	+TransID+"&TransLoc="+TransLoc+"&AdminPower="+AdminPower+"&ReportID=&2=2";
 	window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=850px;dialogHeight=600px;status=no");
	
	//var oWin = window.open(lnk,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	window.location.reload();
}

var btnOPRRep=document.getElementById("btnOPRRep");
if(btnOPRRep){
 	btnOPRRep.onclick=btnOPRRep_click;	
}
function btnOPRRep_click()
{
	var EpisodeID = GetParam(window,"EpisodeID");
	var TransID = GetParam(window,"TransID");
	var TransLoc = GetParam(window,"TransLoc");
	var AdminPower = GetParam(window,"AdminPower");
 	var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportType=OPR&EpisodeID="+EpisodeID+"&TransID="
 	+TransID+"&TransLoc="+TransLoc+"&AdminPower="+AdminPower+"&ReportID=&2=2";
 	window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=850px;dialogHeight=600px;status=no");
	
	//var oWin = window.open(lnk,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	window.location.reload();
}

var objTable = document.getElementById("tDHCMed_NINF_InfReportByAdm"); 
if (objTable != null) {
 	objTable.ondblclick=SelectDBRowHandler;
}
function SelectDBRowHandler()	{
		
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) 
	{
		intSelectRow = -1;
	}
	else
	{
		intSelectRow = selectrow;
	} 	
	var obj=document.getElementById("itmReportIDz" + intSelectRow);
	if (obj) {
		var RepRowId=obj.innerText;
	}
	
	var AdminPower = GetParam(window,"AdminPower");
	
	var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportID="+RepRowId+"&AdminPower="+AdminPower+"&2=2";
 	window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=850px;dialogHeight=600px;status=no");
	
	//var oWin = window.open(lnk,'',"height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ",top=0,left=0,resizable=no");
	window.location.reload();
}

//获取参数
function GetParam(obj, key)
{
	var url = obj.location.href;
	var strParams = "";
	var pos = url.indexOf("?");
	var tmpArry = null;
	var strValue = "";
	var tmp = "";
	if( pos < 0) {
		return "";
	} else {
		strParams = url.substring(pos + 1, url.length);
		tmpArry = strParams.split("&");
		for(var i = 0; i < tmpArry.length; i++)
		{
			tmp = tmpArry[i];
			if(tmp.indexOf("=") < 0) continue;
			if(tmp.substring(0, tmp.indexOf("=")) == key)
			{
				strValue = tmp.substring(tmp.indexOf("=") + 1, tmp.length);
			}
		}
		return strValue;
	}
}
