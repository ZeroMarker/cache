function BodyLoadHandler() 
{	
	InitPage();
}

function InitPage()
{	
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Click;
}

function BExport_Click()
{
	//var testab = new ActiveXObject("LibMessage.MessageFactory");
	//var dataInfos = "asdfas^ADSF^werw^1231^fds^eeter^23ds^sdfe4^45tfd";
        //testab.FillMessage("DT^JQ^EQUIP", "DHCEQBuy", "3", dataInfos);
	//return;
	
	
	var Row;
	var node="DHCEQInventory.ResultStat";
	var job=GetElementValue("TJobz1");	
	var encmeth=GetElementValue("GetTempNum");
	if (job=="")
	{
		alertShow(t['NoData']);
		return;
	}
	var num=cspRunServerMethod(encmeth,node,job);
	if (num<1)
	{
		alertShow(t['NoData']);
		return;
	}
	
	encmeth=GetElementValue("GetRepPath");
	var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"DHCEQInventoryResultStat.xls";
	
	var FileName=GetFileName();
	if (FileName=="") {return;}
	
	encmeth=GetElementValue("GetTempList"); 
        var xlApp,xlsheet,xlBook;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var firstRow=3;
	var firstCol=2;
	var Col;
	//num=1000;
	for (Row=1;Row<=num;Row++)
	    { 
	   		var str=cspRunServerMethod(encmeth,node,job,Row);
			var List=str.split("^");
			if (Row<num) xlsheet.Rows(Row+firstRow).Insert();
			Col=firstCol;
			//TLocID_"^"_TLocName_"^"_TTotalQty_"^"_TAmount_"^"_TDiffQty_"^"_TDiffAmount_"^"_TLoseQty_"^"_TLoseAmount_"^"_TAccordQty_"^"_TAccordAmount_"^"_TJob
			xlsheet.cells(Row+firstRow,Col++)=List[1]; //台帐科室
			xlsheet.cells(Row+firstRow,Col++)=List[2]; //台帐数量
			xlsheet.cells(Row+firstRow,Col++)=List[3]; //台帐金额
			xlsheet.cells(Row+firstRow,Col++)=List[4]; //差异数量
			xlsheet.cells(Row+firstRow,Col++)=List[5]; //差异金额
			xlsheet.cells(Row+firstRow,Col++)=List[6]; //未盘数量
			xlsheet.cells(Row+firstRow,Col++)=List[7]; //未盘金额
			xlsheet.cells(Row+firstRow,Col++)=List[8]; //一致数量
			xlsheet.cells(Row+firstRow,Col++)=List[9]; //一致金额
	     }
	
	var curDate=GetCurrentDate();
	var username=curUserName;
	xlsheet.cells(Row+firstRow,3)=FormatDate(curDate);
	xlsheet.cells(Row+firstRow,9)=username;
	    xlBook.SaveAs(FileName);
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    alertShow(t['ExportSuccess']);
}

document.body.onload = BodyLoadHandler;