/// DHCEQManageLocList.js
var SelectedRow = 0;
var job="";
var LocDR="";

function BodyLoadHandler()
{
	//document.body.scroll="no";	
	InitUserInfo();	
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQManageLocList');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	Selected(selectrow);
}
function Selected(selectrow)
{	
	if (SelectedRow==selectrow)
	{
		SelectedRow=0;
		job="";
		LocDR=""
		parent.DHCEQManageEquipList.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQManageEquipList&LocDR=&job="+job;
	}
	else
	{
		SelectedRow=selectrow;
		job=GetElementValue("jobz"+selectrow);
		LocDR=GetElementValue("TLocDRz"+selectrow);
		SetData();		
	}
}
function SetData()
{	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQManageEquipList&LocDR="+LocDR+"&job="+job;
	//alertShow(lnk)
	parent.DHCEQManageEquipList.location.href=lnk;
}
	
document.body.onload = BodyLoadHandler;