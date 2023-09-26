/// DHCPEStationSResult.js
var obj;
function InitMe() {
	var SummaryForm=document.forms['fDHCPEStationSResult'];
	if (SummaryForm) {
		var Audit=SummaryForm.all['BAudit'];
		var SumResult=SummaryForm.all['BSumResult'];
		var Update=SummaryForm.all['BUpdate'];
		if (Audit) {Audit.onclick=Audit_click;}
		if (SumResult) {SumResult.onclick=SumResult_click;}
		if (Update) {Update.onclick=Update_click;}
		/*var StationObj=SummaryForm.all['StationID'];
		if ((StationObj)&&(StationObj.value!=""))
		{
			var CancelAudit=SummaryForm.all['BCancelAudit'];
			if (CancelAudit) {CancelAudit.style.display = "none";}
		}*/
	}
}
/*
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}*/
function Update_click(){
	var SummaryForm=document.forms['fDHCPEStationSResult'];
	if (SummaryForm) {
		var objtbl=SummaryForm.document.getElementById('tDHCPEStationSResult');
	
		if (objtbl) { var rows=objtbl.rows.length; }
		
		var lastrowindex=rows - 1;
		var i,obj,ID,Remark,Strings;
		var ID,Remark,Strings="";
		for (i=1;i<rows;i++)
		{
			obj=SummaryForm.document.getElementById("TRowIdz"+i);
			if (obj) ID=obj.value;
			obj=SummaryForm.document.getElementById("TRemarkz"+i);
			if (obj) Remark=obj.value;
			if (Strings=="")
			{
				Strings=ID+"&&"+Remark
			}
			else
			{
				Strings=Strings+"^"+ID+"&&"+Remark
			}
		}
		if (Strings=="") return false;
		var obj=SummaryForm.document.getElementById("UpdateBox");
		if (obj) var encmeth=obj.value;
		var flag=cspRunServerMethod(encmeth,Strings)
		alert(t[flag]);
		return false;
		
		
	}
}
function StationSCancelSub()
{
	StatusChange("Cancel");
}
function Audit_click() {
	StatusChange("Submit");
}
function StatusChange(Type)
{
	var SummaryForm=document.forms['fDHCPEStationSResult'];
	if (SummaryForm) {
	obj=SummaryForm.document.getElementById("ChartID");
	if (obj) var ChartID=obj.value;
	obj=SummaryForm.document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	obj=SummaryForm.document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,ChartID,Type);
	alert(t[flag]);
	return false;
	}
}
function SumResult_click(){
	var SummaryForm=document.forms['fDHCPEStationSResult'];
	if (SummaryForm) {
	var Type=0
	obj=SummaryForm.document.getElementById("SSID");
	if (obj) var SSID=obj.value;
	if (SSID!="")
	{
		if (confirm(t['04'])) var Type=1;
	}
	obj=SummaryForm.document.getElementById("ChartID");
	if (obj) var ChartID=obj.value;
	obj=SummaryForm.document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	obj=SummaryForm.document.getElementById("SumResultBox");
	if (obj) var encmeth=obj.value;
	var Remark=""
	obj=SummaryForm.document.getElementById("Remark");
	if (obj) Remark=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,ChartID,Type,Remark);
	if (flag==0)
	{
		window.location.reload();
		return false;
	}
	alert(t[flag]);
	return false;
	}
}


