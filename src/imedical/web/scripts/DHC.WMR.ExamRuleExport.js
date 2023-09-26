var intRows = 0;


function LoadExamRule(DicID)
{
    var objSection = null;
    var objEntry = null;
		var dicEntry = new ActiveXObject("Scripting.Dictionary");
		var dicSection = new ActiveXObject("Scripting.Dictionary"); 
		var objParentEntry = null;
		var arryEntry = new Array();
    //a();
    objCurrRule = GetRuleByDic("MethodGetRuleByDic", DicID, "Y");
    objCurrRule.SectionList = GetSectionByRule("MethodGetSectionByRule", objCurrRule.RowID, "Y");
    for(var i = 0; i < objCurrRule.SectionList.length; i ++)
    {
        objSection = objCurrRule.SectionList[i];
        if(!dicSection.Exists(objSection.RowID))
            dicSection.Add(objSection.RowID, objSection);
        objSection.EntryList = GetEntryBySection("MethodGetEntryBySection", objSection.RowID, "Y");
        for(var j = 0; j < objSection.EntryList.length; j ++)
        {
            objEntry = objSection.EntryList[j];
            if (objEntry.SubEntryList == null)
                objEntry.SubEntryList = new Array();
            if (!dicEntry.Exists(objEntry.RowID)) 
                dicEntry.Add(objEntry.RowID, objEntry);
            arryEntry.push(objEntry);    

        }
    }
    for(var i = 0; i < arryEntry.length; i ++)
    {
    	  objEntry = arryEntry[i];
        if (dicEntry.Exists(objEntry.ParentDr)) 
        {
         	  objParentEntry = dicEntry.Item(objEntry.ParentDr);
         	  objParentEntry.SubEntryList[objParentEntry.SubEntryList.length] = objEntry;
        }
    }
    
    //a();
    ExportToExcel(objCurrRule);
    arryGrade = GetGradeByRuleId("MethodGetGradeByRuleId", objCurrRule.RowID , "Y");
}


function ExportToExcel(objRule)
{
	var objApp = new ActiveXObject("Excel.Application");
	objApp.Visible = true;
	var objBook = objApp.Workbooks.Add();
	var objSheet = objBook.Worksheets.Add();
	var objSection = null;
	var objEntry = null;
	var strPrefix = "";
	intRows = 1;
	for(var intSection = 0; intSection < objRule.SectionList.length; intSection ++)
	{
		objSection = objRule.SectionList[intSection];
		strPrefix = intSection + 1; 
		objSheet.Cells(intRows, 1).value = strPrefix + " " + objSection.SectionDic.Title + "(共" + objSection.Score + "分)"; 
		objSheet.Cells(intRows, 1).Font.Bold = true;
		intRows ++;
		for(var intEntry = 0; intEntry < objSection.EntryList.length; intEntry ++)
		{
			objEntry = objSection.EntryList[intEntry];
			//a();
			if((objEntry.ParentDr == "")||(objEntry.ParentDr == "0")) //Modified by LiYang 2009-08-31
				ExportEntry(objSheet, strPrefix + "." + (intEntry + 1) ,objEntry);
		}
	}
	objBook.PrintPreview();
	
}

function cmdExportOnClick()
{
	var strID = window.event.srcElement.id.replace("cmdExportz", "RuleDrz");
	var RuleID = getElementValue(strID);
	//try{
		LoadExamRule(RuleID);
	//}catch(e)
	//{
	//	window.alert(e.description);
	//}
}


function ExportEntry(objSheet, Prefix, objEntry)
{
	var strPrefix = Prefix ;//+ new String(i + 1);
	objSheet.Cells(intRows, 1).value = strPrefix + " " + objEntry.EntryDic.Title + "(" + objEntry.Score + "分)" + (objEntry.Veto ? "单项否决" : "");
	if(objEntry.Veto)
	{
		objSheet.Cells(intRows, 1).Font.Color = 255;
		objSheet.Cells(intRows, 1).Font.Bold = true;
	}
	intRows ++;	
	for(var i = 0; i < objEntry.SubEntryList.length; i ++)
	{
		objSubEntry = objEntry.SubEntryList[i];
		ExportEntry(objSheet, strPrefix + "." + (i + 1), objSubEntry);
	}
	
}


function WindowOnLoad()
{
	//window.alert("AAAA");
	var objTable = document.getElementById("tDHC_WMR_ExamRule_List");
	var objBtn = null;
	for(var i = 1; i < objTable.rows.length; i ++)
	{
		objBtn = document.getElementById("cmdExportz" + i);
		objBtn.onclick = cmdExportOnClick;
	}
	
}

 WindowOnLoad();