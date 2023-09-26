var selectedRow=0
function BodyLoadHandler()
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_click;
}
function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPEPreAudit_List');	
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=selectedRow)
	{
		selectedRow=selectrow
	}
	else
	{
		selectedRow=0
	}
	var RowID="";
	if (selectedRow!="")
	{
		var obj=document.getElementById("RowIDz"+selectedRow);
		if (obj) RowID=obj.value;
	}
	var myFrame=parent.frames['PreAudit.Edit'];
	myFrame.fillData(RowID);
}

function BPrint_click()
{
	var ADMID="",type="",obj;
	obj=document.getElementById("CRMADM");
	if (obj) ADMID=obj.value;
	obj=document.getElementById("ADMType");
	if (obj) type=obj.value;
	var info=tkMakeServerCall("web.DHCPE.PreAudit","GetPayAmountInfo",type,ADMID);
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEJKD.xls';
	//alert(Templatefilepath)
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.cells(2,2).Value=info;
	//xlsheet.saveas("d:\\aa.xls")
	//xlsheet.printout;
	//xlBook.Close (savechanges=false);
	xlApp.Visible = true;
   	xlApp.UserControl = true;
	
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}

document.body.onload = BodyLoadHandler;