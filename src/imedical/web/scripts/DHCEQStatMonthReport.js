
function BodyLoadHandler(){		
	DisableBElement("BSave",true);
	InitPage();
}
function InitPage()
{
	var obj=document.getElementById("MonthStr");
	if (obj) obj.onchange=MonthChange;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Clicked;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
	var Flag=GetElementValue("Flag");
	if (Flag=="2")
	{
		DisableLookup("StartDate",true);
		DisableLookup("EndDate",true);
		DisableBElement("BSave",true);
	}
	if (Flag=="1")
	{
		DisableLookup("StartDate",true);
		DisableLookup("EndDate",false);
		DisableBElement("BSave",false);
	}
	if (Flag=="0")
	{
		DisableLookup("StartDate",false);
		DisableLookup("EndDate",false);
		DisableBElement("BSave",false);
	}
}
function BFind_Clicked()
{
	var encmeth=GetElementValue("IsMonth");
	var MonthStr=GetElementValue("MonthStr");
	var IsMonth=cspRunServerMethod(encmeth,MonthStr);
	if (IsMonth=="1")
	{
		alertShow(t["05"]);
		return;
	}
	var Flag=GetElementValue("Flag");
	var MonthStr=GetElementValue("MonthStr");
	var StartDate=GetElementValue("StartDate");
	var EndDate=GetElementValue("EndDate");
	var ValStatCat=GetElementValue("ValStatCat");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStatMonthReport&MonthStr='+MonthStr+'&StartDate='+StartDate+'&EndDate='+EndDate+'&Flag='+Flag+'&ValStatCat='+ValStatCat;
}
function BSave_Clicked()
{
	var encmeth=GetElementValue("upd");
	var MonthStr=GetElementValue("MonthStr");
	var StartDate=GetElementValue("StartDate");
	var EndDate=GetElementValue("EndDate");
	var StatCatVal=GetElementValue("ValStatCat");
	alertShow(StatCatVal)
	var Return=cspRunServerMethod(encmeth,MonthStr,StartDate,EndDate,StatCatVal)
	alertShow(Return)
	if (Return<0)
	{
		alertShow("保存报表失败");
		return;
	}
	alertShow("保存报表成功");
}
function BPrint_Clicked()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQStatCatReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    //xlsheet.PageSetup.RightMargin=0;
	    //医院名称替换 Add By DJ 2011-07-14
	    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    xlsheet.cells(2,1)="报表月份:"+GetElementValue("MonthStr");
	    var encmeth=GetElementValue("ChangeDateMask");
	    var StartDate=GetElementValue("StartDate");
	    var EndDate=GetElementValue("EndDate");
	    StartDate=cspRunServerMethod(encmeth,StartDate);
	    EndDate=cspRunServerMethod(encmeth,EndDate);
	    xlsheet.cells(2,5)="报表日期:"+StartDate+"---"+EndDate;
	    xlsheet.cells(2,11)="制表人:"+curUserName;
	    var ValStatCat=GetElementValue("ValStatCat");
	    ValStatCat=ValStatCat+"^0";
	    var StatCatIDs=ValStatCat.split("^");
	    var i=StatCatIDs.length;
	    var j=0
	    for (j=0;j<i;j++)
	    {
		    var StatCatID=StatCatIDs[j];
			var encmeth=GetElementValue("GetOneStatCatReport");
			var Return=cspRunServerMethod(encmeth,StatCatID);
			xlsheet.Rows(4+j).Insert();
			Return=Return.split("^");
			xlsheet.cells(4+j,1)=Return[0];
			xlsheet.cells(4+j,2)=Return[1];
			xlsheet.cells(4+j,3)=Return[2];
			xlsheet.cells(4+j,4)=Return[3];
			xlsheet.cells(4+j,5)=Return[4];
			xlsheet.cells(4+j,6)=Return[5];
			xlsheet.cells(4+j,7)=Return[6];
			xlsheet.cells(4+j,8)=Return[7];
			xlsheet.cells(4+j,9)=Return[8];
			xlsheet.cells(4+j,10)=Return[9];
			xlsheet.cells(4+j,11)=Return[10];
			xlsheet.cells(4+j,12)=Return[11];
			xlsheet.cells(4+j,13)=Return[12];
	    }
	    xlsheet.Rows(4+j).Delete();
	    xlsheet.cells(4+j,1)="负责人:"
	    //xlsheet.printout 打印输出
	    xlBook.SaveAs("D:\\DHCEQStatCatReport.xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
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
	var ValStatCat=GetElementValue("ValStatCat");
	var MonthStr=GetElementValue("MonthStr");
	var StartDate=cspRunServerMethod(encmeth,MonthStr,"1",ValStatCat);
	var EndDate=cspRunServerMethod(encmeth,MonthStr,"2",ValStatCat);
	SetElement("StartDate",StartDate);
	SetElement("EndDate",EndDate);
	var encmeth=GetElementValue("HadFlag");
	var Flag=cspRunServerMethod(encmeth,MonthStr,ValStatCat);
	SetElement("Flag",Flag);
	if (Flag=="2")
	{
		DisableLookup("StartDate",true);
		DisableLookup("EndDate",true);
	}
	if (Flag=="1")
	{
		DisableLookup("StartDate",true);
		DisableLookup("EndDate",false);
	}
	if (Flag=="0")
	{
		DisableLookup("StartDate",false);
		DisableLookup("EndDate",false);
	}
	DisableBElement("BPrint",true);
	DisableBElement("BSave",true);
}
function BodyUnLoadHandler()
{
	var encmeth=GetElementValue("KillTempGlobal");
	cspRunServerMethod(encmeth,"StatMonth");
}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;