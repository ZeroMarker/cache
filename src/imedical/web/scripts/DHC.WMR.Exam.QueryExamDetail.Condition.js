function btnQueryOnClick()
{
	var URL = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Exam.QueryExamDetail.List";
	URL += "&From=" + getElementValue("txtStartDate");
	URL += "&To=" + getElementValue("txtEndDate");
	URL += "&RuleID=" + getElementValue("cboRule");
	URL += "&Department=" + getElementValue("cboDepartment", document, true);
	URL += "&SubDepartment=" + getElementValue("cboLoc", document, true);
	URL += "&DateType=" + getElementValue("cboDateType");
	window.parent.frames[1].location.href = URL;
	
}


function WindowOnLoad()
{
	MakeComboBox("cboRule");
	MakeComboBox("cboDepartment");
	MakeComboBox("cboLoc");
	MakeComboBox("cboDateType");
	var objItm = null;
	
	AddListItem("cboDepartment", "", "0");
	var arryDep = GetAllDep("MethodGetAllDep");
	for(var i = 0; i < arryDep.length; i ++)
	{
		objItm = arryDep[i];
		AddListItem("cboDepartment", objItm.Department, objItm.RowID);
	}
	
	
	var arryRuleDic = GetExamRuleDicList("MethodGetExamRuleDicList", "Y");
	var objRule = null;
	for(var i = 0; i < arryRuleDic.length; i ++)
	{
		objItm = arryRuleDic[i];
		objRule = GetRuleByDic("MethodGetRuleByDic", objItm.RowID, "Y");
		if(objRule != null)
			AddListItem("cboRule", objRule.RuleDic.Title, objRule.RowID);
	}
	
	document.getElementById("cboDepartment").onpropertychange = function()
	{
		//a();
		var arryLoc = GetCtLocByDep("MethodGetCtLocByDep", getElementValue("cboDepartment"));
		ClearListBox("cboLoc");
		AddListItem("cboLoc", "", "0");
		for(var i = 0; i < arryLoc.length; i ++)
		{
			objItm = arryLoc[i];
			AddListItem("cboLoc", GetDesc(objItm.Department, "-"), objItm.Department);
		}
	};
	
	var arryDateType = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "DateType", "Y");
	for(var i = 0; i < arryDateType.length; i ++)
	{
		objItm = arryDateType[i];
		AddListItem("cboDateType", objItm.Description, objItm.Code);
	}
	
	document.getElementById("btnQuery").onclick = btnQueryOnClick;
}

window.onload = WindowOnLoad;