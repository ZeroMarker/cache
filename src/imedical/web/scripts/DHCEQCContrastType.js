var SelectedRow = 0;
var varRowID=""; //ID
var varTypeCode=""; //±àÂë

function BodyLoadHandler() 
{
	//document.body.scroll="no";
	InitUserInfo();
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCContrastType');
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
		parent.DHCEQCContrastInfo.location.href="websys.default.csp"
	}
	else
	{
		SelectedRow=selectrow;
		varRowID=GetElementValue("TRowIDz"+selectrow);
		varDataType=GetElementValue("TDataTypez"+selectrow);		

		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCContrastInfo&DataType="+varDataType+"&ContrastTypeDR="+varRowID;
		//alertShow("lnk="+lnk);
		parent.DHCEQCContrastInfo.location.href=lnk;		
	}		
}

document.body.onload = BodyLoadHandler;