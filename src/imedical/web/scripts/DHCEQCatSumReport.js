function BodyLoadHandler() 
{
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_click;
	var obj=document.getElementById("MonthStr");
	if (obj) obj.onchange=MonthChange;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
}
function BFind_click()
{
	var MonthStr=GetElementValue("MonthStr");
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCatSumReport';
	lnk=lnk+'&MonthStr='+MonthStr;
	location.href=lnk;
			
}
function MonthChange()
{
	var encmeth=GetElementValue("IsMonth");
	var MonthStr=GetElementValue("MonthStr");
	var IsMonth=cspRunServerMethod(encmeth,MonthStr);
	if (IsMonth=="1")
	{
		alertShow(t["05"]);
		return;
	}
	var encmeth=GetElementValue("ChangeMonth");
	var MonthStr=cspRunServerMethod(encmeth,MonthStr);
	SetElement("MonthStr",MonthStr);
}
function BSave_click()
{
	var encmeth=GetElementValue("GetSaveClass");
	var MonthStr=GetElementValue("MonthStr");
	cspRunServerMethod(encmeth,MonthStr);
}
function BPrint_click()
{
	var encmeth=GetElementValue("GetPrintDataClass");
	if (encmeth=="") return;
	var MonthStr=GetElementValue("MonthStr");
	var PrintData=cspRunServerMethod(encmeth,MonthStr);
	if (PrintData=="") return;
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var Row=4;
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQCatSumReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    var DataArr=PrintData.split("&&");
	    var Rows=DataArr.length;
	    xlsheet.cells(2,3)=MonthStr;
	    for (var i=1;i<Rows;i++)
	    {
		    var OneData=DataArr[i];
		    var OneDataArr=OneData.split("^");
		    xlsheet.Rows(Row+i).Insert();
		    xlsheet.cells(Row+i,1)="'"+OneDataArr[0];
		    xlsheet.cells(Row+i,2)=OneDataArr[1];
		    xlsheet.cells(Row+i,3)=OneDataArr[2];
	    }
	    xlsheet.Rows(Row).Delete();
	    xlsheet.Rows(Row+i-1).Delete();
	    xlsheet.Rows(Row+i-1).Delete();
	    //xlsheet.printout; //打印输出
	    xlBook.SaveAs("D:\\CatSumReport"+MonthStr+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	    alertShow("已保存为D:\\CatSumReport"+MonthStr+".xls")
	}
	catch(e)
	{
		alertShow(e.message);
	}
}

document.body.onload = BodyLoadHandler;