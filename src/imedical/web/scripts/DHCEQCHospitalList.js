/// -------------------------------
/// Created By HZY 2011-07-27  HZY0003 ?
/// --------------------------------
var SelectedRow = 0;
function BodyLoadHandler() 
{
	document.body.scroll="no";	
	InitUserInfo();	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCHospitalList');
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
		var EquipTypeID=window.parent.DHCEQCMasterItem.document.getElementById("EquipTypeDR").value
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&Hold2="+""+"&EquipTypeDR="+(EquipTypeID);
		//alertShow(lnk)
		parent.DHCEQCMasterItem.location.href=lnk;
	}
	else
	{
		SelectedRow=selectrow;
		var varID=GetElementValue("TIDz"+selectrow);
		var EquipTypeID=window.parent.DHCEQCMasterItem.document.getElementById("EquipTypeDR").value
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&Hold2="+(varID)+"&EquipTypeDR="+(EquipTypeID);
		//alertShow(lnk)
		parent.DHCEQCMasterItem.location.href=lnk;
	}		
}

document.body.onload = BodyLoadHandler;