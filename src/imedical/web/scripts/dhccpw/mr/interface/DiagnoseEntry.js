
/******************************************************************
˵�������¼��ʱ��鵱ǰ����Ƿ�����ٴ�·��׼���׼

���ã�ShowCPW(MRCICDRowid);

���ã�
function LocICDListDoubleClickHandler()   //˫�����ҳ�����ϴ����ٴ�·�����
function HistoryMRDiagnoseListDoubleClickHandler(e)  //˫����ʷ��ϴ����ٴ�·�����
******************************************************************/

function ShowCPW(MRCICDRowid){
	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value}
	if (EpisodeID=='') return;
	var cpwInfo=tkMakeServerCall("web.DHCCPW.MR.Interface","CheckCPWICD",EpisodeID,MRCICDRowid);
	if (cpwInfo){
		//Modified by LiYang 2011-04-26 ��¼�뾶��־
		var arryFields = cpwInfo.split(String.fromCharCode(1));
		//window.alert("CPWID" + arryFields[1]);
		var ret=InPathLog.RecordNewInPathLog(EpisodeID,session['LOGON.USERID'],MRCICDRowid,arryFields[1]);
		//window.alert(ret);
		if(confirm(arryFields[0]+"�Ƿ��뾶?"))
		{
			var path="dhccpw.mr.clinpathway.csp?EpisodeID=" + EpisodeID + 
				"&LogID=" + ret + 
				"&CpwVerID=" + arryFields[1] + 
				"&CpwDesc=" + arryFields[2];
			var numHeigth=screen.availHeight-200;
			var numWidth=screen.availWidth-200;
			var numTop=(screen.availHeight-numHeigth)/2;
			var numLeft=(screen.availWidth-numWidth)/2;
			var posn="height="+ numHeigth +",width="+ numWidth +",top=" + numTop + ",left=" + numLeft + ",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
			websys_createWindow(path,false,posn);
		}
	}
}

//Add By LiYang 2011-04-22
var InPathLog = new Object();

InPathLog.RecordNewInPathLog = function(Paadm, UserID, MRCICDRowid, VerID)
{
	var strArg = "^"+ Paadm + "^";
	strArg += "^"; //PathWayID
	strArg += "" + "^"; //Date
	strArg += "" + "^"; //Time
	strArg += UserID + "^"; //DoctorID
	strArg += MRCICDRowid + "^"; //MRCICDRowid;
	strArg += VerID + "^";
	var ret=tkMakeServerCall("web.DHCCPW.MR.ClinPathWayInPathLogSrv","Update",strArg);
	return ret;
}

InPathLog.UpdateLogResult = function(ID, PathWayID)
{
	var ret = tkMakeServerCall("web.DHCCPW.MR.ClinPathWayInPathLogSrv", "UpdateLogResult", ID,PathWayID);
	return ret;
}