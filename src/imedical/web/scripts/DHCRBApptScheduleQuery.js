document.body.onload = DocumentLoadHandler;
var UserID=session['LOGON.USERID'];
function DocumentLoadHandler()
{
	var obj;
	ComboDoc=dhtmlXComboFromStr("DocDesc",'');
	ComboDoc.enableFilteringMode(true);
	ComboDoc.selectHandle=DocList_change;
	
	var DepStr=tkMakeServerCall("web.DHCRBResSession","GetOPDeptStr","","","",session['LOGON.HOSPID']);
	DepStr="\1^"+DepStr
	ComboLoc=dhtmlXComboFromStr("LocDesc",DepStr);
	ComboLoc.enableFilteringMode(true);
	ComboLoc.selectHandle=DepartList_change;
	
	var StatusStr=tkMakeServerCall("web.DHCOPSendMedicare","GetStatusStr");
	ComboStatus=dhtmlXComboFromStr("StatusDesc",StatusStr);
	ComboStatus.enableFilteringMode(true);
	ComboStatus.selectHandle=StatusList_change;
	//ReasonID
	var ReasonStr=tkMakeServerCall("web.DHCRBCReasonNotAvail","GetStopReasonStr");
	ReasonStr="\1^"+ReasonStr
	ComboReason=dhtmlXComboFromStr("ReasonDesc",ReasonStr);
	ComboReason.enableFilteringMode(true);
	ComboReason.selectHandle=ReasonList_change;
	var DocID=DHCC_GetElementData('DocID');
	var DepartID=DHCC_GetElementData('LocID');
	ComboLoc.setComboValue(DepartID);
	DepartList_change();
	if (DocID!=""){
		ComboDoc.setComboValue(DocID);
		DocList_change();
	}
	var StatusID=DHCC_GetElementData('StatusID');
	ComboStatus.setComboValue(StatusID);
	var ReasonID=DHCC_GetElementData('ReasonID');
	ComboReason.setComboValue(ReasonID);
	
	obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_click;
}
function DocList_change()
{
	var DocRowId=DHCC_GetComboValue(ComboDoc);
	DHCC_SetElementData('DocID',DocRowId);
}
function DepartList_change()
{
	var DepRowId=DHCC_GetComboValue(ComboLoc);
	DHCC_SetElementData('LocID',DepRowId);
	ComboDoc.clearAll();
	ComboDoc.setComboText("");
	DHCC_SetElementData('DocID',"");
	if (DepRowId!=""){
		ComboDoc.addOption('');
		var DocStr=tkMakeServerCall("web.DHCRBResSession","GetResDocBroker",DepRowId,"","","");
		if (DocStr!=""){
			var Arr=DHCC_StrToArray(DocStr);
			ComboDoc.addOption(Arr);
		}
	}
}
function StatusList_change()
{
	var StatusRowId=DHCC_GetComboValue(ComboStatus);
	DHCC_SetElementData('StatusID',StatusRowId);
}
function ReasonList_change()
{
	var ReasonRowId=DHCC_GetComboValue(ComboReason);
	DHCC_SetElementData('ReasonID',ReasonRowId);
}
function BPrint_click()
{
	var Templatefilepath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")+'DHCRBApptScheduleQuery.xls'; // Ä£°åÎÄ¼þ
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.Add(Templatefilepath); 
	xlsheet = xlBook.WorkSheets("Sheet1");
	var eSrc=window.event.srcElement;
	var tbObj=document.getElementById('tDHCRBApptScheduleQuery');	
	var rowObj = tbObj.getElementsByTagName("tr");
	if(tbObj)
   	{
		var str = "" ,rowNumber,columnNumber;
		for(var rowNumber = 0;  rowNumber < rowObj.length;rowNumber ++ )
		{
      		for(var columnNumber = 1; columnNumber < rowObj[rowNumber].cells.length;columnNumber ++ )
			{
				str=rowObj[0].cells[columnNumber].innerText;
				//if (str==" ") break;
				str = rowObj[rowNumber].cells[columnNumber].innerText;
				xlsheet.cells(rowNumber+2, columnNumber).value = str;
			}
		}
	}
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;

	idTmr   =   window.setInterval("Cleanup();",1); 
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
}