
function BodyLoadHandler(){
	InitPage();
}


function InitPage()
{
	var obj=document.getElementById("MonthStr");
	if (obj) obj.onchange=MonthChange;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
}
function BPrint_Clicked()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var xlApp,xlsheet,xlBook;
	var Template=TemplatePath+"DHCEQUsedDetailSP.xls";
	xlApp = new ActiveXObject("Excel.Application");
	var encmeth=GetElementValue("GetLocIDs");
	var LocIDs=cspRunServerMethod(encmeth);
	var LocID=LocIDs.split("^");
	var TotalRows=LocID.length;
	var encmeth=GetElementValue("ChangeDateMask");
	var StartDate=GetElementValue("StartDate");
	var EndDate=GetElementValue("EndDate");
	StartDate=cspRunServerMethod(encmeth,StartDate);
	EndDate=cspRunServerMethod(encmeth,EndDate);
	var PageRows=43; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows); //总页数-1  
	var ModRows=TotalRows%PageRows; //最后一页行数
	if (ModRows==0) Pages=Pages-1;
	var encmeth=GetElementValue("GetOneDetail");
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQUsedDetailSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    //分页打印
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0;
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows;
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows;
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows;
		    	}
	    	}
	    	//每页明细
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k-1
		    	var Loc=LocID[l];
				//if (l>123)
				//{alertShow(Loc+"^"+l)
				//break}
				var Return=cspRunServerMethod(encmeth,Loc);
				var j=k+3
				xlsheet.Rows(j).Insert();
				Return=Return.split("^");
				xlsheet.cells(j,1)=GetShortName(Return[0],"-");
				if (l==TotalRows-1) xlsheet.cells(j,1)="总计:";
				var StatCatValue=Return[1].split(",");
				xlsheet.cells(j,2)=StatCatValue[0];
				xlsheet.cells(j,3)=StatCatValue[1];
				xlsheet.cells(j,4)=Return[2];
				xlsheet.cells(j,5)=Return[3];
				xlsheet.cells(j,6)=Return[4];
	    	}
	    	xlsheet.Rows(1+j).Delete();
	    	xlsheet.cells(1+j,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
	    	xlsheet.cells(1+j,5)="制表人:"+curUserName;
	    	xlsheet.cells(2,1)="报表月份:"+GetElementValue("MonthStr");
	    	xlsheet.cells(2,3)="报表日期:"+StartDate+"--"+EndDate;
	    	//xlsheet.printout 打印输出
	    	xlBook.SaveAs("D:\\DHCEQUsedDetailSP"+i+".xls");   //lgl+
	    	xlBook.Close (savechanges=false);
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
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
	var encmeth=GetElementValue("GetReportDate");
	var MonthStr=GetElementValue("MonthStr");
	var StartDate=cspRunServerMethod(encmeth,MonthStr,"1");
	var EndDate=cspRunServerMethod(encmeth,MonthStr,"2");
	SetElement("StartDate",StartDate);
	SetElement("EndDate",EndDate);
}
function BodyUnLoadHandler()
{
	var encmeth=GetElementValue("KillTempGlobal");
	cspRunServerMethod(encmeth,"UsedDetail");
}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;