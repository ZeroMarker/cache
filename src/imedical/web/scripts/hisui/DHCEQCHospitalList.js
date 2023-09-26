///	HISUI¸ÄÔì  by Mozy003016		2020-04-23
var SelectedRow = 0;
function BodyLoadHandler() 
{
	document.body.scroll="no";	
	InitUserInfo();	
}

function SelectRowHandler(index,rowdata)
{
	var EquipTypeID=window.parent.DHCEQCMasterItem.document.getElementById("EquipTypeDR").value;
	if (index==SelectedRow)
	{
		SelectedRow= -1;
		$('#tDHCEQCHospitalList').datagrid('unselectAll'); 
		HospitalID="";
	}
	else
	{
		SelectedRow = index;
		HospitalID=rowdata.TID;
	}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&Hold2="+HospitalID+"&EquipTypeDR="+(EquipTypeID);
	parent.DHCEQCMasterItem.location.href=lnk;
}

document.body.onload = BodyLoadHandler;