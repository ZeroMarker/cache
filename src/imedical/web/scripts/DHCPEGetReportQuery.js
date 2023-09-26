//DHCPEGetReportQuery.js
//查询出来到期还未发报告的


var SelectedRow=0
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	
	obj=document.getElementById("RegNo");
	if (obj) obj.onkeydown=RegNo_keydown;

	
}

function RegNo_keydown(e)
{
var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	} 
}

function BFind_Click()
{
	var iRegNo="",iName="",iStartDate="",iEndDate="",iIsGroup="0";
	var obj;
	obj=document.getElementById("RegNo");
	if (obj) {
			iRegNo=obj.value;
			if (iRegNo.length<8&&iRegNo.length>0) {iRegNo=RegNoMask(iRegNo);}
	}
	obj=document.getElementById("Name");
	if (obj) iName=obj.value;
	obj=document.getElementById("StartDate");
	if (obj) iStartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) iEndDate=obj.value;
	obj=document.getElementById("IsGroup");
	if (obj&&obj.checked) iIsGroup="1";
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEGetReportQuery"
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&StartDate="+iStartDate
			+"&EndDate="+iEndDate
			+"&IsGroup="+iIsGroup
	;
	location.href=lnk;
	return false;
}

function SelectRowHandler(){  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEGetReportQuery');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
	SelectedRow=selectrow;
	}
	
}
document.body.onload = BodyLoadHandler;