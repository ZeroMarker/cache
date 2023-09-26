//2009-12-23 LiYang

function WindowOnload()
{
	MakeComboBox("cboMrType");
	MakeComboBox("cboDep");
	MakeComboBox("cboReason");
	var arry = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "MrType", "Y");
	var objItm = null;
	AddListItem("cboMrType", "All", "");
	for(var i = 0; i < arry.length; i ++)
	{
		objItm = arry[i];
		AddListItem("cboMrType", objItm.Description, objItm.RowID);
	}
	
	arry = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "LendAim", "Y");
	AddListItem("cboReason", "All", "");
	for(var i = 0; i < arry.length; i ++)
	{
		objItm = arry[i];
		AddListItem("cboReason", objItm.Description, objItm.RowID);
	}	
	arry = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag", "MRLocation", "Y");
	AddListItem("cboDep", "All", "");
	for(var i = 0; i < arry.length; i ++)
	{
		objItm = arry[i];
		AddListItem("cboDep", objItm.Description, objItm.RowID);
	}		
	
	document.getElementById("cmdQuery").onclick = cmdQueryOnclick;
	document.getElementById("cmdPrint").onclick = cmdPrintOnclick;
	document.getElementById("cmdExport").onclick = cmdExportOnclick;
	
	//window.alert(window.parent.location);
}

function cmdQueryOnclick()
{
	var strURL = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.LendOut.History.List" +
	"&MrType=" + getElementValue("cboMrType") +
	"&FromDate=" + getElementValue("txtFromDate") + 
	"&ToDate=" + getElementValue("txtToDate") +
	"&LendStatusID=" + GetParam(window.parent, "LendStatus") +
	"&MRLocation=" + getElementValue("cboDep") +
	"&Reason=" + getElementValue("cboReason") +
	"&LendUser=" + getElementValue("txtLendUser") 
	;
	
	window.parent.frames["RPbottom"].location.href = strURL;
	
}

function cmdPrintOnclick()
{
	var objExcelApp = OutPutToExcel(window.parent.frames["RPbottom"].document.getElementById("tDHC_WMR_LendOut_History_List"), true);
}

function cmdExportOnclick()
{
	OutPutToExcel(window.parent.frames["RPbottom"].document.getElementById("tDHC_WMR_LendOut_History_List"));
}

function OutPutToExcel(objTable, NeedPrint)
{
	var objExcelApp = new ActiveXObject("Excel.Application");
	var objWorkBook = objExcelApp.Workbooks.Add();
	var objSheet = objWorkBook.Worksheets.Add();
	var objRow = "";
	var arryField = null;
	/*if(Row == null)
		Row = 1;
	if(Col == null)
		Col = 1;*/
	for(var row = 0; row < objTable.rows.length; row ++)
	{
		objRow = objTable.rows[row];
		for(var col = 0; col < objRow.cells.length; col ++)
		{
			objSheet.Cells(row+1,col+1).Value = objRow.cells[col].innerText;
		}
	}
	objExcelApp.Visible = true;
	if(NeedPrint)
		objSheet.PrintOut();
	return objExcelApp;
}

window.onload = WindowOnload;