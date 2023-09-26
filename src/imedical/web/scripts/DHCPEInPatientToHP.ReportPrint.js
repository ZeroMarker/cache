/// DHCPEInPatientToHP.ReportPrint.js

var CurrentSel=0

function BodyLoadHandler() {
   
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	var obj=document.getElementById("BPrint");
	if (obj){
		obj.disabled=true;
		obj.onclick=BPrint_click;
	}	    
	var obj=document.getElementById("BPrivew");
	if (obj){
		obj.disabled=true;
		obj.onclick=BPrivew_click;
	}
}
function BPrint_click()
{
	Print("Print");
}
function BPrivew_click()
{
	Print("");
}
function Print(Type)
{
	var obj,PAADM="";
	obj=document.getElementById("TEpisodeIDz"+CurrentSel);
	if (obj) PAADM=obj.value;
	var width=screen.width-60;
	var height=screen.height-10;
	var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
 	var lnk="dhcpeireport.normal.otherpat.csp?PatientID="+PAADM+"&Type="+Type;
	open(lnk,"_blank",nwin);
	return false;
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function BFind_click()
{
	var StartDate="",EndDate="",AuditStartDate="",AuditEndDate="",PrintStartDate="",PrintEndDate="",RegNo="",Name="",Status="",obj;
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	
	obj=document.getElementById("AuditStartDate");
	if (obj) AuditStartDate=obj.value;
	obj=document.getElementById("AuditEndDate");
	if (obj) AuditEndDate=obj.value;
	
	obj=document.getElementById("PrintStartDate");
	if (obj) PrintStartDate=obj.value;
	obj=document.getElementById("PrintEndDate");
	if (obj) PrintEndDate=obj.value;
	
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	obj=document.getElementById("Name");
	if (obj) Name=obj.value;
	
	obj=document.getElementById("Status");
	if (obj) Status=obj.value;
	
	
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEInPatientToHP.ReportPrint"
   	+"&StartDate="+StartDate+"&EndDate="+EndDate+"&AuditStartDate="+AuditStartDate+"&AuditEndDate="+AuditEndDate
   	+"&PrintStartDate="+PrintStartDate+"&PrintEndDate="+PrintEndDate+"&RegNo="+RegNo+"&Name="+Name+"&Status="+Status;
   	window.location.href=lnk;
}

function SelectRowHandler() {
	
	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel) {
		var obj=document.getElementById("BPrint");
		if (obj) obj.disabled=true;	    
		var obj=document.getElementById("BPrivew");
		if (obj) obj.disabled=true;
		CurrentSel=0;
		return false;
	}
	CurrentSel=selectrow;
	var obj=document.getElementById("BPrint");
	if (obj){
		obj.disabled=false;
		var StatusObj=document.getElementById("TStatusz"+selectrow);
		if (StatusObj){
			if (StatusObj.innerText=="Œ¥…Û∫À") obj.disabled=true;
		}
	}	    
	var obj=document.getElementById("BPrivew");
	if (obj) obj.disabled=false;
}

document.body.onload = BodyLoadHandler;