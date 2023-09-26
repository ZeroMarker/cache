//Query Discharge patient by department or ward
//Author: LiYang 2009-7-7


function DisplayLoc(DepTypeID)
{
	var strMethod = document.getElementById("MethodGetLocByDep").value;
	var ret = cspRunServerMethod(strMethod, DepTypeID);
	var arry = ret.split(CHR_1);
	var arryFields = null;
	var tmp = "";
	var objDep = null;
	
	AddListItem("cboDepartment", "È«²¿", "");//add by liuxuefeng 2009-07-16
	for(var i = 0; i < arry.length; i ++)
	{
			tmp = arry[i];
			if(tmp == "")
				continue;
			arryFields = tmp.split(CHR_2);
			objDep = new Object();
			objDep.RowID = arryFields[0];
			objDep.Title = arryFields[1];
			AddListItem("cboDepartment", objDep.Title, objDep.RowID);
	}
}


//Modified By LiYang 2009-07-07 pass Loc paramater to query
function btnQueryOnClick() {
	
	  var strURL = "";
    strURL = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.DischargeByWard.List&a=a" +
        "&cType=" + GetParam(window.parent, "MrType") +
        "&FromDate=" + getElementValue("FromDate") + 
        "&ToDate=" + getElementValue("ToDate") + 
        "&Ward=" + getElementValue("cboDepartment") +
        "&Loc=";
    window.parent.frames[1].location.href = strURL;   
}


//2009-07-07  Add By LiYang Add Print function
function btnPrintOnClick()
{
	var objDoc = window.parent.frames[1].document;
	var objTable = objDoc.getElementById("tDHC_WMR_DischargeByWard_List");
	var arry = new Array();
	var objPat = null;
	var objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");
	for(var row = 1; row < objTable.rows.length; row ++)
	{
		objPat = new Object();
		objPat.RegNo = getElementValue("PapmiNoz" + row, objDoc);
		objPat.PatName = getElementValue("PatNamez" + row, objDoc);
		objPat.MrNo = getElementValue("MrNOz" + row, objDoc);
		objPat.DischgDate = getElementValue("DischgDatez" + row, objDoc);
		objPat.Bed = getElementValue("Bedz" + row, objDoc);
		objPat.Doc = getElementValue("Docz" + row, objDoc);
		objPat.WardDesc = getElementValue("WardDescz" + row, objDoc);
		arry.push(objPat);
	}
	var objDicWard = new ActiveXObject("Scripting.Dictionary");
	var cnt = 0;
	for(var i = 0; i < arry.length; i ++)
	{
		objPat = arry[i];
		if(objDicWard.Exists(objPat.WardDesc))
		{
			cnt = objDicWard.Item(objPat.WardDesc);
			cnt ++;
			objDicWard.Remove(objPat.WardDesc);
			objDicWard.Add(objPat.WardDesc, cnt);
		}
		else
		{
			objDicWard.Add(objPat.WardDesc, 1);
		}
	}
	
	
    var intYPos = 0;
    var LeftMarge = 1.0;
    var TopMarge = 1.5;
    var LineHeight = 0.5;	
    var intXPos = 0;
	
  	objPrinter.FontSize = 11;
	var arryKey = objDicWard.Keys().toArray();
	for(var i = 0; i < arryKey.length; i ++)
	{
		intYPos += 2;
		cnt = objDicWard.Item(arryKey[i]);
		objPrinter.FontBold  = true;
		objPrinter.PrintContents(LeftMarge, TopMarge + LineHeight * intYPos,  arryKey[i] + "  " + t["Total"] + objDicWard.Item(arryKey[i]));
		objPrinter.FontBold  = false;
		intYPos ++;
		intXPos = 0;
		for(var j = 0; j < arry.length; j ++)
		{
			objPat = arry[j];
			if(objPat.WardDesc != arryKey[i])
				continue;
			objPrinter.PrintContents(LeftMarge + 6 * intXPos , TopMarge + LineHeight * intYPos, objPat.MrNo);//Modify by liuxuefeng 2009-10-23
			objPrinter.PrintContents(LeftMarge + 6 * intXPos + 1.5, TopMarge + LineHeight * intYPos, objPat.PatName);//Modify by liuxuefeng 2009-10-23
			objPrinter.PrintContents(LeftMarge + 6 * intXPos + 3.0, TopMarge + LineHeight * intYPos, objPat.DischgDate);//Modify by liuxuefeng 2009-10-23
			objPrinter.PrintContents(LeftMarge + 6 * intXPos + 5.5, TopMarge + LineHeight * intYPos,"|");//add by liuxuefeng 2009-10-23
			intXPos ++;
			if (intXPos >= 3)
			{
				intYPos ++;
				intXPos = 0;
			}
	        if(intYPos >= 40)
	        {
	            objPrinter.NewPage();
	            intYPos = 0;
	        } 
		}
	}
	objPrinter.EndDoc();
}

function init()
{
    MakeComboBox("cboDepartment");
		DisplayLoc(GetParam(window.parent, "DepID"));
		
    document.getElementById("cmdQuery").onclick = btnQueryOnClick;
    document.getElementById("btnPrint").onclick = btnPrintOnClick;
    
    //btnQueryOnClick();
}

window.onload = init;