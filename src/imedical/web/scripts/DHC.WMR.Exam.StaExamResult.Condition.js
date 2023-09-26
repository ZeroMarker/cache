function btnQueryOnClick()
{
	var URL = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Exam.StaExamResult.List";
	URL += "&From=" + getElementValue("txtStartDate");
	URL += "&To=" + getElementValue("txtEndDate");
	URL += "&RuleID=" + getElementValue("cboRule");
	URL += "&DepType=" + getElementValue("cboDepType");
	URL += "&DateType=" + getElementValue("cboDateType");
	window.parent.frames[1].location.href = URL;
	
}


function WindowOnLoad()
{
	MakeComboBox("cboRule");
	MakeComboBox("cboDepType");
	MakeComboBox("cboDateType");
	var objItm = null;

	AddListItem("cboDepType", t["DepType1"], "1");
	AddListItem("cboDepType", t["DepType2"], "2");
	
	var arryRuleDic = GetExamRuleDicList("MethodGetExamRuleDicList", "Y");
	var objRule = null;
	for(var i = 0; i < arryRuleDic.length; i ++)
	{
		objItm = arryRuleDic[i];
		objRule = GetRuleByDic("MethodGetRuleByDic", objItm.RowID, "Y");
		if(objRule != null)
			AddListItem("cboRule", objRule.RuleDic.Title, objRule.RowID);
	}
	

	
	var arryDateType = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "DateType", "Y");
	for(var i = 0; i < arryDateType.length; i ++)
	{
		objItm = arryDateType[i];
		AddListItem("cboDateType", objItm.Description, objItm.Code);
	}
	
	document.getElementById("btnQuery").onclick = btnQueryOnClick;
}

window.onload = WindowOnLoad;