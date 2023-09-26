/// Mozy	2019-7-1	DHCEQCBarInfoList.js
var SelectedRow = 0;
function BodyLoadHandler() 
{
	document.body.scroll="no";
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQCBarInfoList");
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
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfo";
		parent.DHCEQCBarInfo.location.href=lnk;
	}
	else
	{
		SelectedRow=selectrow;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfo&BarInfoDR="+GetElementValue("TRowIDz"+selectrow);
		parent.DHCEQCBarInfo.location.href=lnk;
	}
}
document.body.onload = BodyLoadHandler;