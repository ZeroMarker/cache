

function cmdQueryOnClick()
{
	var strURL = "./websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.No.Sta.List" 
	+ "&MrType=" + getElementValue("cboMrType") 
	+ "&FromDate=" + getElementValue("txtFromDate")
	+ "&ToDate=" + getElementValue("txtToDate");
	window.parent.frames["RPbottom"].location.href = strURL;
}

function WindowOnload()
{
	var arry = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag","MrType","Y");
	var objItm = null;
	for(var i = 0; i < arry.length; i ++)
	{
		objItm = arry[i];
		AddListItem("cboMrType", objItm.Description, objItm.RowID);
	}
	MakeComboBox("cboMrType");
}

window.onload = WindowOnload;
document.getElementById("cmdQuery").onclick = cmdQueryOnClick;