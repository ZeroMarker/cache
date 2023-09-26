//设备对照类型表	Mzy0018	2009-07-20
var SelectedRow = 0;
var varRowID=""; //ID
var varTypeCode=""; //编码

function BodyLoadHandler() 
{
	//document.body.scroll="no";
	InitUserInfo();	
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQContrastType');
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
		varRowID="";
		varTypeCode="";
		parent.DHCEQContrastInfo.location.href="websys.default.csp"
	}
	else
	{
		SelectedRow=selectrow;
		varRowID=GetElementValue("TRowIDz"+selectrow);
		varTypeCode=GetElementValue("TCodez"+selectrow);		

		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContrastInfo&TypeCode="+varTypeCode+"&ContrastTypeDR="+varRowID;
		parent.DHCEQContrastInfo.location.href=lnk;		
	}		
}

document.body.onload = BodyLoadHandler;