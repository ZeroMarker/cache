/// filename: DHCPEPreGADM.Audit.JS
/// Created by SongDeBo 2006/6/27
/// Description: Õ≈ÃÂ‘§‘º…Û∫À
/// 
var gMyName="DHCPEPreGADM.Audit";
var gUserId=session['LOGON.USERID']

function IniMe(){
	Ini();	//In DHCPEPreAudit.Common.JS
	
	gData.TableName="tDHCPEPreGADM_Audit";
	gData.AdmType="GROUP";
	
	var obj=document.getElementById("btnQuery");
	obj.onclick=btnQuery_Click;		


	status=GetCtlValueById("txtStatus",1);
	if (status==""){
		btnQuery_Click();
	}	
}

function btnQuery_Click(){
	
	var myName=GetCtlValueById("txtGrpName",1);
	var recordDate=GetCtlValueById("txtRecordDate",1);
	var preRegDate=GetCtlValueById("txtPreRegDate",1);
	var qryStatus="PREREG";
	
	//if (GetCtlValueById("chkAudited",1)==1) qryStatus=qryStatus+","+"CHECKED";
	
	if (GetCtlValueById("chkAudited",1)==1)
	{ qryStatus="^"+"CHECKED"; }
	else { qryStatus="^PREREG"; }
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+gMyName +
			"&Name=" + myName + 
			"&BookDate="+preRegDate + "&Status="+qryStatus +
			"&UpdateDate="+recordDate ;
	document.location.href=lnk;
	return false;
	
//RegNo As %String = "", Name As %String = "", PEDate As %String = "", PETime As %String = "", Status As %String = "", UpdateUser As %String = "", UpdateDate As %String = ""
}

document.body.onload=IniMe;