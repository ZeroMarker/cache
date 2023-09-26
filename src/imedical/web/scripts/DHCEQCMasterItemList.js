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
	var objtbl=document.getElementById('tDHCEQCMasterItemList');
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
		var HospitalID=window.parent.DHCEQCMasterItem.document.getElementById("Hold2").value
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&EquipTypeDR="+"&Hold2="+(HospitalID)+"&FacilityFlag="+GetElementValue("FacilityFlag");
		//alertShow(lnk)
		parent.DHCEQCMasterItem.location.href=lnk;
	}
	else
	{
		SelectedRow=selectrow;
		var varID=GetElementValue("TIDz"+selectrow);
		var HospitalID=window.parent.DHCEQCMasterItem.document.getElementById("Hold2").value
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&EquipTypeDR="+(varID)+"&Hold2="+(HospitalID)+"&FacilityFlag="+GetElementValue("FacilityFlag");
		parent.DHCEQCMasterItem.location.href=lnk;
	}		
}
document.body.onload = BodyLoadHandler;