
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
	var obj=document.getElementById("BDepre");
	if (obj) obj.onclick=BDepre_Clicked;
	
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
	var ValEquipType=GetElementValue("ValEquipType");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreMonthReport&MonthStr='+MonthStr+'&StartDate='+StartDate+'&EndDate='+EndDate+'&Flag='+Flag+"&ValEquipType="+ValEquipType;
}
function BSave_Clicked()
{
	var encmeth=GetElementValue("upd");
	var MonthStr=GetElementValue("MonthStr");
	var StartDate=GetElementValue("StartDate");
	var EndDate=GetElementValue("EndDate");
	var ValEquipType=GetElementValue("ValEquipType");
	var Return=cspRunServerMethod(encmeth,MonthStr,StartDate,EndDate,ValEquipType);
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
	    var Template=TemplatePath+"DHCEQDepreMonthReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    //xlsheet.PageSetup.RightMargin=0;
	    xlsheet.cells(2,1)="报表月份:"+GetElementValue("MonthStr");
	    xlsheet.cells(2,4)="制表人:"+curUserName
	    var UseTotalFee=GetCElementValue("TUseTotalFeez1");
	    xlsheet.cells(4,1)=UseTotalFee;
		xlsheet.cells(4,2)=GetCElementValue("TNewDepreFeez1");
		xlsheet.cells(4,3)=GetCElementValue("TDisDepreFeez1");
		xlsheet.cells(4,4)=GetCElementValue("TDepreTotalFeez1");
		//xlsheet.printout; 打印输出
		xlBook.SaveAs("D:\\DHCEQDepreMonthReport.xls");   //lgl+
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
	var ValEquipType=GetElementValue("ValEquipType");
	var StartDate=cspRunServerMethod(encmeth,MonthStr,"1",ValEquipType);
	var EndDate=cspRunServerMethod(encmeth,MonthStr,"2",ValEquipType);
	SetElement("StartDate",StartDate);
	SetElement("EndDate",EndDate);
	var encmeth=GetElementValue("HadFlag");
	var Flag=cspRunServerMethod(encmeth,MonthStr,ValEquipType);
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
	cspRunServerMethod(encmeth,"DepreMonthReport");
}

function BDepre_Clicked()
{
	var encmeth=GetElementValue("GetCurMonthDepre");
	var rtn=cspRunServerMethod(encmeth);
	if (rtn=="")
	{	alertShow(t['01']);}
	else
	{	alertShow(rtn)}
	
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;