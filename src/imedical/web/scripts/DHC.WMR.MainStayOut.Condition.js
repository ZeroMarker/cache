function btnQueryOnClick()
{
	var MrTypeList="",WorkItemList="";
	MrTypeList=getElementValue("cboMrType");
	WorkItemList=getElementValue("cboWorkItem");
	
	var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainStayOut.List"
		+ "&MrTypeDr=" + MrTypeList + "&IsStayIn=N" + "&WorkItemList=" + WorkItemList;
	/*
	var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainStayOut.List"
		+ "&MrTypeDr=" + getElementValue("cboMrType") + "&IsStayIn=N";
	*/
	window.parent.frames[1].location.href = strUrl;
}


function InitForm()
{
	/*
	MakeComboBox("cboMrType");
	var objArry = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "MrType", "Y");
	var objDic = null;
	for(var i = 0; i < objArry.length; i ++)
	{
		objDic = objArry[i];
		AddListItem("cboMrType",  objDic.Description, objDic.RowID);
	}
	var cboMrType = document.getElementById("cboMrType");
	if(cboMrType.options.length > 0){cboMrType.selectedIndex = 0;}
	*/
}

function InitEvents()
{
	document.getElementById("btnQuery").onclick = btnQueryOnClick;
}

InitForm();
InitEvents();