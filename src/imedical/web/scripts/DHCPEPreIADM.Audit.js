/// filename: DHCPEPreIADM.Audit.js
/// Created by SongDeBo 2006/6/19
/// Description: ∏ˆ»À‘§‘º…Û∫À
/// 
var gMyName="DHCPEPreIADM.Audit";
var gUserId=session['LOGON.USERID']

function IniMe(){
	Ini();	//In DHCPEPreAudit.Common.JS
	
	gData.TableName="tDHCPEPreIADM_Audit";
	gData.AdmType="PERSON";
	
	var obj=document.getElementById("btnQuery");
	obj.onclick=btnQuery_Click;		

	status=GetCtlValueById("txtStatus",1);
	if (status==""){
		btnQuery_Click();
	}	
}

function btnQuery_Click(){
	var patName=GetCtlValueById("txtPatName",1);
	var patNo=GetCtlValueById("txtPatNo",1);
	if (patNo!="") patNo=FormatAdmNo(patNo);
	var recordDate=GetCtlValueById("txtRecordDate",1);
	var preRegDate=GetCtlValueById("txtPreRegDate",1);
	var qryStatus="^PREREG";
	
	if (GetCtlValueById("chkAudited",1)==1)
	{ qryStatus="^"+"CHECKED"; }
	else { qryStatus="^PREREG"; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+gMyName +
			"&RegNo="+patNo +"&Name=" + patName + 
			"&PEDate="+preRegDate + "&Status="+qryStatus +
			"&UpdateDate="+recordDate ;
	document.location.href=lnk;
	return false;
	
//RegNo As %String = "", Name As %String = "", PEDate As %String = "", PETime As %String = "", Status As %String = "", UpdateUser As %String = "", UpdateDate As %String = ""
}

document.body.onload=IniMe;
