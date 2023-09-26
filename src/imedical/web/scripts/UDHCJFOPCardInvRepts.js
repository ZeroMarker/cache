document.body.onload = DocumentLoadHandler;
function DocumentLoadHandler()
{
	var obj=document.getElementById("BImportData");
	if (obj) obj.onclick=BImportData_click;
}
function BImportData_click()
{
	var prnpath=obj.value;
	var Templatefilepath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")+'UDHCJFOPCardInvRepts.xls'; // 模板文件
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.Add(Templatefilepath); 
	xlsheet = xlBook.WorkSheets("Sheet1");
	var eSrc=window.event.srcElement;
	var tbObj=document.getElementById('tUDHCJFOPCardInvRepts');	
	var rowObj = tbObj.getElementsByTagName("tr");
	if(tbObj)
   	{
		var str = "" ,rowNumber,columnNumber;
		for(var rowNumber = 0;  rowNumber < rowObj.length;rowNumber ++ )
		{
      		for(var columnNumber = 1; columnNumber < rowObj[rowNumber].cells.length;columnNumber ++ )
			{
				str=rowObj[0].cells[columnNumber].innerText;
				if (str==" ") break;
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