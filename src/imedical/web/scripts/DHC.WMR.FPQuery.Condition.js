var ICDConfigD = GetDHCWMRICDSettingD("MethodGetDHCWMRICDSettingD");
var ICDConfigO = GetDHCWMRICDSettingO("MethodGetDHCWMRICDSettingO");
var arryICDType = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "ICDType", "Y");
var arryICDFields = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPDisOpeField", "Y");
var CHR_1 = String.fromCharCode(1)
var CHR_2 = String.fromCharCode(2)

function DisplayExtraList()
{
	ClearListBox("cboExtra");
	var arryExtra = GetTemplateDetailByMrType("MethodGetTemplateDetailByMrType", getElementValue("cboMrType"));
	var objExtraDetail = null;
	var objItm = null;
	for(var i = 0; i < arryExtra.length; i ++)
	{
		objItm = arryExtra[i];
		objExtraDetail = GetFrontPageItemDicByID("MethodGetFrontPageItemDicByID", objItm.ItemId);
		AddListItem("cboExtra", objExtraDetail.Description, objItm.RowID);
	}
	
}

function BuildExpress(strArg, objCbo, from, after)
{
	var objItem = null;
	var arryOption = null;
	var strTmp = strArg;
	arryOption = objCbo.options;
	for(var j = 0; j < arryOption.length; j ++)
	{
		objItem = arryOption[j];
		strTmp = ReplaceText(strTmp, "<" + objItem.innerText + ">" , from + objItem.value + after);
	}
	return strTmp;
}

function BuildDisOpeExpress(strArg, objCbo, from, after)
{
	var objItem = null;
	var strTmp = strArg;
	for(var j = 0; j < arryICDFields.length; j ++)
	{
		objItem = arryICDFields[j];
		strTmp = ReplaceText(strTmp, "<" + objItem.Description + ">", from + objItem.Code + after);
	}
	return strTmp;
}



function BtnAddOnClick()
{
	var objSrc = window.event.srcElement;
	var strConditionControl = "";
	var strValueControl = "";
	var strOperatorControl = "";
	var strItemControl = "";
	var strLogical = "";
	switch(objSrc.id)
	{
		case "btnAddBase":
			strConditionControl = "txtBaseInfoCondition";
			strValueControl = "txtBaseInfoValue";
			strOperatorControl = "cboBaseInfoOperator";
			strItemControl = "cboBaseInfo";
			strLogical = "cboRelationBase";
			break;
		case "btnAddDis":
			strConditionControl = "txtDisOpeCondition";
			strValueControl = "txtDisOpeValue";
			strOperatorControl = "cboDisOpeOperator";
			strItemControl = "cboDisOpe";	
			strLogical = "cboRelationICDItem";		
			break;
		case "btnAddExtra":
			strConditionControl = "txtExtraCondition";
			strValueControl = "txtExtraValue";
			strOperatorControl = "cboExtraOperator";
			strItemControl = "cboExtra";		
			strLogical = "cboRelationExtraItem";	
			break;
		case "btnAddAdm":
			strConditionControl = "txtAdmCondition";
			strValueControl = "txtAdmValue";
			strOperatorControl = "cboAdmOperator";
			strItemControl = "cboAdm";	
			strLogical = "cboRelationAdm";		
			break;
	}	
	var strOlderValue = "";
	if(objSrc.id != "btnAddDis")
	{
		strOlderValue = getElementValue(strConditionControl);
		setElementValue(strConditionControl, 
			 strOlderValue + getElementValue(strLogical, document, true) + " " +
			 "(<" + getElementValue(strItemControl, document, true) + "> <" + getElementValue(strOperatorControl, document, true) + "> '" + getElementValue(strValueControl) + "')" + " "
			);
	}else{
		var txtDisOpeCondition = document.getElementById("txtDisOpeCondition");
		strOlderValue = txtDisOpeCondition.GetText();
		var LinePos = txtDisOpeCondition.GetLinePos();
		var newValue = strOlderValue + (LinePos == 0 ? getElementValue("cboICDType") : "") + " " + getElementValue(strLogical, document, true) + " " +
			 "(<" +  getElementValue(strItemControl, document, true)   + "> <" + getElementValue(strOperatorControl, document, true)  + "> '" + getElementValue(strValueControl) + "') "
		txtDisOpeCondition.SetText(newValue);

/*
		var newValue = strOlderValue + (LinePos == 0 ? getElementValue("cboICDType") : "") + " " + getElementValue(strLogical, document, true) + " " +
			 "(<" + getElementValue(strItemControl, document, true)  +  "> " +
			 getElementValue(strOperatorControl, document, true) + ' "' + getElementValue(strValueControl) + '")' + " "
		txtDisOpeCondition.SetText(newValue);
*/
	}
} 

function BuildBinExpress(str)
{
	var strTmp = "";
	for(var i = 0; i < str.length; i ++)
	{
		strTmp += "$c(" + str.charCodeAt(i) + ")";
		if(i < str.length - 1)
			strTmp +="_";	
	}
	return strTmp;	
}

function btnQueryOnClick()
{
	var strICDCondition = document.getElementById("txtDisOpeCondition").GetText();
	var strExtraCondition = getElementValue("txtExtraCondition");
	//var strMainCondition = getElementValue("txtDisOpeCondition");
	var strMainCondition = "";
	var strBaseCondition = getElementValue("txtBaseInfoCondition");
	var strAdmCondition = getElementValue("txtAdmCondition");
	var strVolCondition = "";
	var strFpCondition = "";
	
	strICDCondition = BuildDisOpeExpress(strICDCondition, document.getElementById("cboDisOpe"), "", "");
	strICDCondition = BuildExpress(strICDCondition, document.getElementById("cboDisOpeOperator"), "", "");
	
	strExtraCondition = BuildExpress(strExtraCondition, document.getElementById("cboExtra"), "<", ">");
	strExtraCondition = BuildExpress(strExtraCondition, document.getElementById("cboExtraOperator"), "", "");
	
	strBaseCondition = BuildExpress(strBaseCondition, document.getElementById("cboBaseInfo"), '$p(baseInfo,"^",', ')');
	strBaseCondition = BuildExpress(strBaseCondition, document.getElementById("cboBaseInfoOperator"), "", "");
	strBaseCondition = BuildExpress(strBaseCondition, document.getElementById("cboRelationBase"), "", "");
	strBaseCondition = ReplaceText(strBaseCondition, "AND" , "&&");
	strBaseCondition = ReplaceText(strBaseCondition, "OR" , "||");
	strBaseCondition = ReplaceText(strBaseCondition, "\'" , "\"");
	
	strAdmCondition = BuildExpress(strAdmCondition, document.getElementById("cboAdm"), '$p(adm,"^",', ')');
	strAdmCondition = BuildExpress(strAdmCondition, document.getElementById("cboAdmOperator"), "", "");
	strAdmCondition = BuildExpress(strAdmCondition, document.getElementById("cboRelationAdm"), "", "");	
	strAdmCondition = ReplaceText(strAdmCondition, "AND" , "&&");
	strAdmCondition = ReplaceText(strAdmCondition, "OR" , "||");
	strAdmCondition = ReplaceText(strAdmCondition, "\'" , "\"");
	
	strMainCondition = '&($p(main,"^",2)=' + getElementValue("cboMrType") + ")";
	var strICDExp = "";
	if(strICDCondition != "")
	{
		arryICD = strICDCondition.split("\n");
		for(var i = 0; i < arryICD.length; i ++)
		{
			if((arryICD[i].toLowerCase().indexOf("not")!=2) && (arryICD[i].toLowerCase().indexOf("and")!=2))
			{
				strICDExp += "AND" + String.fromCharCode(2) + arryICD[i];
			}
			if(arryICD[i].toLowerCase().indexOf("not") == 2)
			{
				strICDExp += "NOT" + String.fromCharCode(2) + arryICD[i].substr(5);
			}
			if(arryICD[i].toLowerCase().indexOf("and") == 2)
			{
				strICDExp += "AND" + String.fromCharCode(2) + arryICD[i].substr(5);
			}
			if(arryICD[i].toLowerCase().indexOf("d") == 0)
			{
				strICDExp += String.fromCharCode(2) + "D";	
			}else
			{
				strICDExp += String.fromCharCode(2) + "O";	
			}
				
			if(i < arryICD.length -1)
				strICDExp += String.fromCharCode(1);
		}
	}
	var strExtraExp = "";
	if(strExtraCondition != "")
	{
		arryExtra = strExtraCondition.split("\n");
		for(var i = 0; i < arryExtra.length; i ++)
		{
			if((arryExtra[i].toLowerCase().indexOf("not") != 0) && (arryExtra[i].toLowerCase().indexOf("and") != 0))
			{
				strExtraExp += "AND" + String.fromCharCode(2) + arryExtra[i];
			}
			if(arryExtra[i].toLowerCase().indexOf("not") == 0)
			{
				strExtraExp += "NOT" + String.fromCharCode(2) + arryExtra[i].substr(3);
			}
			if(arryExtra[i].toLowerCase().indexOf("and") == 0)
			{
				strExtraExp += "AND" + String.fromCharCode(2) + arryExtra[i].substr(3);
			}
			if(i < arryExtra.length -1)
				strExtraExp += String.fromCharCode(1);
		}	
	}
	
	//strICDCondition = "AND" + String.fromCharCode(2) + 'ICD LIKE "%I63%"';
	var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.FPQuery.List" +
		"&ICDCondition=" + encodeURIComponent(BuildBinExpress(strICDExp)) +
		"&ExtraCondition=" + encodeURIComponent(BuildBinExpress(strExtraExp)) +
		"&mainCon=" + encodeURIComponent(BuildBinExpress(strMainCondition)) +
		"&baseCon=" + encodeURIComponent(BuildBinExpress(strBaseCondition)) +
		"&volCon=" + encodeURIComponent(BuildBinExpress(strVolCondition)) +
		"&admCon=" + encodeURIComponent(BuildBinExpress(strAdmCondition)) +
		"&fpCon=" + encodeURIComponent(BuildBinExpress(strFpCondition));
	window.parent.frames[1].location.href = strUrl;
}


function initForm()
{
	MakeComboBox("cboDisOpe");
	MakeComboBox("cboBaseInfo");
	MakeComboBox("cboAdm");
	MakeComboBox("cboDisOpeOperator");
	MakeComboBox("cboBaseInfoOperator");
	MakeComboBox("cboAdmOperator");
	MakeComboBox("cboExtraOperator");
	MakeComboBox("cboMrType");
	MakeComboBox("cboExtra");
	MakeComboBox("cboRelationICDItem");
	MakeComboBox("cboRelationExtraItem");
	MakeComboBox("cboRelationBase");
	MakeComboBox("cboRelationAdm");
	MakeComboBox("cboICDType");
	
	var arryOpeDic = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "CompareOperator", "Y");
	var objItm = null;
	var objOption = null;
	for(var i = 0; i < arryOpeDic.length; i ++)
	{
		objItm = arryOpeDic[i];
		AddListItem("cboDisOpeOperator", objItm.Description, objItm.Code);
		AddListItem("cboExtraOperator", objItm.Description, objItm.Code);

	}
	
	var arryCacheCompare = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "CacheCompare", "Y");
	for(var i = 0; i < arryCacheCompare.length; i ++)
	{
		objItm = arryCacheCompare[i];
		AddListItem("cboBaseInfoOperator", objItm.Description, objItm.Code);
		AddListItem("cboAdmOperator", objItm.Description, objItm.Code);
	}
	
	for(var i = 0; i < arryICDType.length; i ++)
	{
		objItm = arryICDType[i];	
		AddListItem("cboICDType", objItm.Description, objItm.Code);	
	}		
	
	for(var i = 0; i < arryICDFields.length; i ++)
	{
		objItm = 	arryICDFields[i];
		if(((ICDConfigD == objItm.TextA) || (objItm.TextA == "")) && ((objItm.TextB == getElementValue("cboICDType")) || (objItm.TextB == "")))
		{
			AddListItem("cboDisOpe", objItm.Description, objItm.Code);
		}	
		
	}
	
	var arryMrType = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "MrType", "Y");
	for(var i = 0; i < arryMrType.length; i ++)
	{
		objItm = arryMrType[i];
		AddListItem("cboMrType", objItm.Description, objItm.RowID);	
	}
	if(arryMrType.length > 0)
		DisplayExtraList();
		
	var arryBaseField = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPBaseField", "Y");
	for(var i = 0; i < arryBaseField.length; i ++)
	{
		objItm = arryBaseField[i];
		AddListItem("cboBaseInfo", objItm.Description, objItm.Code);	
	}		
		
	var arryAdmField = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "FPAdmField", "Y");
	for(var i = 0; i < arryAdmField.length; i ++)
	{
		objItm = arryAdmField[i];
		AddListItem("cboAdm", objItm.Description, objItm.Code);	
	}				
	var arryLogical = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "LogicalRelation", "Y");
	for(var i = 0; i < arryLogical.length; i ++)
	{
		objItm = arryLogical[i];
		AddListItem("cboRelationICDItem", objItm.Description, objItm.Code);	
		AddListItem("cboRelationExtraItem", objItm.Description, objItm.Code);	
	}		
	var arryCacheLogical = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "CacheLogical", "Y");
	for(var i = 0; i < arryCacheLogical.length; i ++)
	{
		objItm = arryCacheLogical[i];	
		AddListItem("cboRelationBase", objItm.Description, objItm.Code);	
		AddListItem("cboRelationAdm", objItm.Description, objItm.Code);	
	}		
		
	document.getElementById("cboMrType").onpropertychange = function()
	{
		if(window.event != null)
		{
			if(window.event.propertyName == "selectedIndex")
				DisplayExtraList();
		}	
	};
	
	document.getElementById("cboICDType").onpropertychange = function()
	{
		if(window.event != null)
		{
			if(window.event.propertyName == "selectedIndex")
			{
				ClearListBox("cboDisOpe");
				var objItm = null;
				for(var i = 0; i < arryICDFields.length; i ++)
				{
					objItm = arryICDFields[i];
					if(((ICDConfigD == objItm.TextA) || (objItm.TextA == "")) && ((objItm.TextB == getElementValue("cboICDType")) || (objItm.TextB == "")))
					{
						AddListItem("cboDisOpe", objItm.Description, objItm.Code);
					}				
				}
				
			}
		}	
	};
	
	document.getElementById("btnAddAdm").onclick = BtnAddOnClick;
	document.getElementById("btnAddBase").onclick = BtnAddOnClick;
	document.getElementById("btnAddDis").onclick = BtnAddOnClick;
	document.getElementById("btnAddExtra").onclick = BtnAddOnClick;
	document.getElementById("btnQuery").onclick = btnQueryOnClick;

	var strApplet = "<APPLET ID = 'txtDisOpeCondition' Name = 'QueryTextBox' codebase = '../addins/java' code = 'com/dhcc/wmr/coding/QueryTextBox.class' width = '690' height	= '60' ALIGN='Left'>";
	var objTable = document.getElementsByTagName("table")[2];
    objTable.rows[3].cells[0].appendChild(document.createElement(strApplet));
	
	
	
}


window.onload = initForm;