function BodyLoadHandler() 
{	
	initButtonWidth(); //HISUI改造 add by MWZ 2018-10-10
	setButtonText();	//HISUI改造 add by MWZ 2018-10-10
	initUserInfo();  // Modified By QW20181225 需求号:758421
	InitPage();
}

function InitPage()
{	
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Click;
}
function BExport_Click()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BExportChorme_Click()
	}
	else
	{
		BExportIE_Click()
	}
}
function BExportChorme_Click()
{
	var Row;
	var node="DHCEQInventory.ResultStat";
	var ObjTJob=$('#tDHCEQInventoryResultStat').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  job=ObjTJob.rows[0]["TJob"];
	var encmeth=GetElementValue("GetTempNum");
	if (job=="")
	{
		messageShow("","","",t['NoData']);
		return;
	}
	var num=cspRunServerMethod(encmeth,node,job);
	if (num<1)
	{
		messageShow("","","",t['NoData']);
		return;
	}
	var curDate=FormatDate(GetCurrentDate());
	var username=curUserName;
	encmeth=GetElementValue("GetRepPath");
	var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"DHCEQInventoryResultStat.xls";
	var FileName=GetFileName();
	if (FileName=="") {return;}
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)	
	encmeth=GetElementValue("GetTempList"); 
	var DataInfo=new Array();
	for (Row=1;Row<=num;Row++)
	{
		var rtn=cspRunServerMethod(encmeth,node,job,Row);
		rtn=filepath(rtn,",","、");
		DataInfo[Row-1]=rtn
	}
	var DataInfoStr=DataInfo.toString()
	
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="var Template='"+Template+"';";
	Str +="var xlApp = new ActiveXObject('Excel.Application');"
	Str +="xlBook = xlApp.Workbooks.Add(Template);"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="var firstRow=3;"
	Str +="var firstCol=2;"
	Str +="var Col;"
	Str +="var DataInfoStr='"+DataInfoStr+"';"
	Str +="var DataInfo=DataInfoStr.split(',');"
	Str +="for (var Row=1;Row<="+num+";Row++){"
	Str +="var OneInfo=DataInfo[Row-1];"
	Str +="var List=OneInfo.split('^');"
	Str +="if (Row<num) xlsheet.Rows(Row+firstRow).Insert();"
	Str +="Col=firstCol;"
	//TLocID_"^"_TLocName_"^"_TTotalQty_"^"_TAmount_"^"_TDiffQty_"^"_TDiffAmount_"^"_TLoseQty_"^"_TLoseAmount_"^"_TAccordQty_"^"_TAccordAmount_"^"_TJob
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[1];" //台帐科室
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[2];" //台帐数量
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[3];" //台帐金额
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[4];" //差异数量
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[5];" //差异金额
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[6];" //未盘数量
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[7];" //未盘金额
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[8];" //一致数量
	Str +="xlsheet.cells(Row+firstRow,Col++)=List[9];" //一致金额
	Str +="}"
    Str +="xlsheet.cells(Row+firstRow,3)='"+curDate+"';"
	Str +="xlsheet.cells(Row+firstRow,9)='"+username+"';"
	
	Str +="xlBook.SaveAs('"+NewFileName+"');"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlApp.Quit();"
	Str +="xlApp=null;"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;"
	Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
	if (rtn.rtn==1)
	{
	    alertShow("导出完成!");
	}	    
}
///modify by mwz 2018-10-10 Hisui改造：导出数据时无法取TJobz1的值
function BExportIE_Click()
{

	var Row;
	var node="DHCEQInventory.ResultStat";
	//HISUI改造 begin add by mwz 2018-10-10 
	var ObjTJob=$('#tDHCEQInventoryResultStat').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  job=ObjTJob.rows[0]["TJob"];
	//HISUI改造 end add by mwz 2018-10-10 
	var encmeth=GetElementValue("GetTempNum");
	if (job=="")
	{
		messageShow("","","",t['NoData']);
		return;
	}
	var num=cspRunServerMethod(encmeth,node,job);
	if (num<1)
	{
		messageShow("","","",t['NoData']);
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
	    messageShow("","","",t['ExportSuccess']);
}

document.body.onload = BodyLoadHandler;