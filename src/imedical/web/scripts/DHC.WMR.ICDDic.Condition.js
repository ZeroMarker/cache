
function windowOnload()
{
	document.getElementById("cmdQuery").onclick = BtnQueryOnClick;
	MakeComboBox("cboDicType");
	var arry = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "ICDType","Y");
	var objItm = null;
	for(var i = 0; i < arry.length ; i ++)
	{
		objItm = arry[i];
		AddListItem("cboDicType", objItm.Description, objItm.RowID);
	}
}

function BtnQueryOnClick()
{
	var strUrl = "./websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ICDDic.List";
	strUrl += "&DicType=" + getElementValue("cboDicType");
	strUrl += "&ICDCode=" + getElementValue("txtICDCode");
	strUrl += "&Desc=" + getElementValue("txtDisease");
	window.parent.frames["RPMain"].location.href = strUrl;
	
}


window.onload = windowOnload;
