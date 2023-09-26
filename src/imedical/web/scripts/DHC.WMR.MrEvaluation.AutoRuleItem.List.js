
var objDicResult = new ActiveXObject("Scripting.Dictionary");
var arryKeys = new Array();

function ReplaceText(src, find, rep)
{
    var str = src;
    while(str.indexOf(find) > -1)
    {
        str = str.replace(find, rep);
    }
    return str;
}
function GetFieldSplitString()
{
    return appletFieldSplit;
}

function GetRowSplitString()
{
    return appletRowSplit;
}

function GetEMRTemplateCategoryList()
{
	/**/
    var strLines = "";
    
	var strMethod = document.getElementById("Method").value;
	var strLines = cspRunServerMethod(strMethod);
	//alert(strLines);
	while (strLines.indexOf(CHR_2)>=0)
	{
		strLines=strLines.replace(CHR_2,appletFieldSplit);
	}
	while (strLines.indexOf(CHR_1)>=0)
	{
		strLines=strLines.replace(CHR_1,appletRowSplit);
	}    
    return strLines;
    
    /*
    var strFieldSpit = "<field>";
    var strRowSplit = "<row>";
    var strLines = "";
    strLines += "1<field>0<field>Category1<field>" + "<row>";
    strLines += "2<field>0<field>Category2<field>" + "<row>";
    strLines += "3<field>0<field>Category3<field>" + "<row>";
    strLines += "4<field>0<field>Category4<field>" + "<row>";
    strLines += "5<field>0<field>Category<field>" + "<row>";
    strLines += "6<field>0<field>Category6<field>" + "<row>";
    strLines += "7<field>1<field>Category1-1<field>" + "<row>";
    strLines += "8<field>2<field>Category2-1<field>" + "<row>";
    strLines += "9<field>3<field>Category3-1<field>" + "<row>";
    strLines += "10<field>4<field>Category4-1<field>" + "<row>";
    strLines += "11<field>5<field>Category5-1<field>" + "<row>";
    strLines += "12<field>6<field>Category6-1<field>" + "<row>";    
    return strLines;
    */
}

function GetEMRTemplateList()
{
	/**/
	var strLines = "";
    
	var strMethod = document.getElementById("MethodTemp").value;
	var strLines = cspRunServerMethod(strMethod);

	while (strLines.indexOf(CHR_2)>=0)
	{
		strLines=strLines.replace(CHR_2,appletFieldSplit);
	}
	while (strLines.indexOf(CHR_1)>=0)
	{
		strLines=strLines.replace(CHR_1,appletRowSplit);
	}
	return strLines;
	
	/*
    var strLines = "";
    strLines += "1<field>1<field>Template1<field>" + "<row>";
    strLines += "2<field>2<field>Template2<field>" + "<row>";
    strLines += "3<field>3<field>Template3<field>" + "<row>";
    strLines += "4<field>4<field>Template4<field>" + "<row>";
    strLines += "5<field>5<field>Template5<field>" + "<row>";
    strLines += "6<field>6<field>Template6<field>" + "<row>";
    strLines += "7<field>7<field>Template1-1<field>" + "<row>";
    strLines += "8<field>8<field>Template2-1<field>" + "<row>";
    strLines += "9<field>9<field>Template3-1<field>" + "<row>";
    strLines += "10<field>10<field>Template4-1<field>" + "<row>";
    strLines += "11<field>11<field>Template5-1<field>" + "<row>";
    strLines += "12<field>12<field>Template6-1<field>" + "<row>";    
    return strLines;
    */
}

function GetEMRData(RowID)
{
	/**/
	var strMethod = document.getElementById("MGetData").value;
	var strLines = cspRunServerMethod(strMethod,RowID);
	while (strLines.indexOf(CHR_2)>=0)
	{
		strLines=strLines.replace(CHR_2,appletFieldSplit);
	}
	while (strLines.indexOf(CHR_1)>=0)
	{
		strLines=strLines.replace(CHR_1,appletRowSplit);
	}
	return strLines;
	
	/*
    var strLines = "";
    strLines += "1<field>1<field>EMRData1<field>" + "<row>";
    strLines += "2<field>0<field>EMRData2<field>" + "<row>";
    strLines += "3<field>0<field>EMRData3<field>" + "<row>";
    strLines += "4<field>2<field>EMRData4<field>" + "<row>";
    strLines += "5<field>3<field>EMRData5<field>" + "<row>";
    strLines += "6<field>1<field>EMRData6<field>" + "<row>";
    return strLines;
    */
}

//Format the returning objects for applate display 
function SerializeForApplet()
{
    var objArry = objDicResult.Items().toArray();
    var strReturn = "";
    var objItem = null;
    for(var i = 0; i < objArry.length; i ++)
    {
        objItem = objArry[i];
        /*
        strReturn += (i + 1) + appletFieldSplit;
        strReturn += objItem.Code + appletFieldSplit;
        strReturn += objItem.Description + appletFieldSplit;
        strReturn += objItem.Expression + appletFieldSplit;
        strReturn += (objItem.IsActive ? "Yes": "No") + (i < objArry.length - 1 ? appletRowSplit : "");
        */
        
        strReturn += (i + 1) + appletFieldSplit;
        strReturn += objItem.Code + appletFieldSplit;
        strReturn += objItem.Description + appletFieldSplit;
        //strReturn += ReplaceText(objItem.Expression, "'", "^") + appletFieldSplit;
        strReturn += ReplaceText(objItem.Expression, "`", "^") + appletFieldSplit;
        strReturn += (objItem.IsActive ? "Yes": "No") + (i < objArry.length - 1 ? appletRowSplit : "");
    }

    return strReturn;
}

function SerializeKeyForApplet()
{
    var objArry = objDicResult.Items().toArray();
    var strReturn = "";
    var objItem = null;
    for(var i = 0; i < objArry.length; i ++)
    {
        objItem = objArry[i];
        strReturn += objItem.RowID  + (i < objArry.length - 1 ? appletFieldSplit : "");
    }
    return strReturn;
}

function DeleteAutoCheckRule(RowID)
{
    if(objDicResult.Exists(RowID))
    {
        objItem = objDicResult.Item(RowID);
        objItem.IsActive = (!objItem.IsActive);
        var ret = UpdateACRule("MethodUpdateACRule", SerializeAutoCheckRuleItem(objItem));
        if(ret > 0)
            window.alert(t["DeleteOK"]);
        else
            window.alert(t["DeleteFail"]);
     }
	 
}

function FindRuleByDesc(Desc)
{
    var arryResult = null;
    var objItm = null;
    //window.alert(Desc);
    if(Desc == "")
        arryResult = GetExamACRAll("MethodGetExamACRAll");
    else
        arryResult = GetExamACRByDesc("MethodGetExamACRByDesc", Desc);
	arryKeys = new Array();
	objDicResult.RemoveAll();
	for(var i = 0; i < arryResult.length; i ++)
	{
	    objItm = arryResult[i];
	    objDicResult.Add(objItm.RowID, objItm);
	    arryKeys[i] = objItm.RowID;
	}
}

function GetExamAutoCheckRuleItemById(RowID)
{
    if(RowID == "")
        return;
    var objItm = GetExamACRById("MethodGetExamACRById", RowID);
    
    var str = objItm.RowID + appletFieldSplit + objItm.Code + appletFieldSplit + objItm.Description  + appletFieldSplit + 
        ReplaceText(objItm.Expression, "`", "^") + appletFieldSplit + (objItm.IsActive ? "Y" : "N") + appletFieldSplit + objItm.ResumeText  +" "+ appletFieldSplit;
        //ReplaceText(objItm.Expression, "'", "^") + appletFieldSplit + (objItm.IsActive ? "Y" : "N") + appletFieldSplit + objItm.ResumeText  +" "+ appletFieldSplit;
    
    /*
    var str = objItm.RowID + appletFieldSplit + objItm.Code + appletFieldSplit + objItm.Description  + appletFieldSplit + 
        objItm.Expression  + appletFieldSplit + (objItm.IsActive ? "Y" : "N") + appletFieldSplit + objItm.ResumeText  +" "+ appletFieldSplit;
        */
    return str;
}

function SaveExamAutoCheckRuleItem(str)
{
    var ret = UpdateACRule("MethodUpdateACRule", str);
    if(ret > 0)
        window.alert(t["SaveOK"]);
    else
        window.alert(t["SaveFail"]);
    return ret;
}

function GetDictionary(dicType)
{
    var str = "";
    var objItem = null;
    var arry = QueryDictionaryByTypeFlagLIST("MethodQueryDictionaryByTypeFlagLIST", dicType, "Y");
    for(var i = 0; i < arry.length; i ++)
    {
        objItem = arry[i];
        str += objItem.RowID + appletFieldSplit;
        str += objItem.DictionaryName + appletFieldSplit;
        str += objItem.Code + appletFieldSplit;
        str += objItem.Description + appletFieldSplit;
        str += objItem.FromDate + appletFieldSplit;
        str += objItem.ToDate + appletFieldSplit;
        str += objItem.TextA + appletFieldSplit;
        str += objItem.TextB + appletFieldSplit;
        str += objItem.TextC + appletFieldSplit;
        str += objItem.TextD + appletFieldSplit;
        str += (objItem.IsActive ? "Yes": "No") + appletFieldSplit;
        str += objItem.ResumeText + appletRowSplit;
    }
    return str;
}



function initForm()
{
	var strApplet = "<applet id='AutoCheckRuleList' codebase='../addins/java' code='com.dhcc.wmr.qualityctl.maintain.AutoRuleItemGenerator' height='600' width='650'></applet>";
    var strAppletJSCaller = "<APPLET ID = 'JSCaller' Name = 'JSCaller' codebase = '../addins/java' code = 'com/dhcc/wmr/qualityctl/utilty/JSCaller.class' width = '0' height	= '0' >";
    var objTable = document.getElementsByTagName("table")[1];
    //window.alert(objTable.rows.length);
    objTable.rows[0].cells[0].appendChild(document.createElement(strApplet));
    objTable.rows[0].cells[0].appendChild(document.createElement(strAppletJSCaller));

}

function initEvent()
{
}

initForm();
initEvent();