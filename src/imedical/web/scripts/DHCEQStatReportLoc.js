var Loc;

function BodyLoadHandler(){
	DisableBElement("BSave",true);
	
	InitPage();
	
	KeyUp("Loc","N");
	Loc=GetElementValue("Loc");
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
	MonthChange();	
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
	var LocDR=GetElementValue("LocDR");
	
	if (LocDR=="")
	{
		alertShow(t["06"]);
		return;
	}
	var lnk= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStatReportLoc&MonthStr='+MonthStr+'&StartDate='+StartDate+'&EndDate='+EndDate+'&Flag='+Flag+'&ValStatCat='+ValStatCat+'&LocDR='+LocDR;
	///alertShow(lnk);
	window.location.href= lnk;
}
function BSave_Clicked()
{
	MonthChange();
	var encmeth=GetElementValue("SaveStat");
	
	var MonthStr=GetElementValue("MonthStr");
	var StartDate=GetElementValue("StartDate");
	var EndDate=GetElementValue("EndDate");
	var StatCatVal=GetElementValue("ValStatCat");
	var Return=cspRunServerMethod(encmeth,StatCatVal,StartDate,EndDate,MonthStr)
	if (Return!=0)
	{
		alertShow("保存报表失败"+" "+Return);
		return;
	}
	alertShow("保存报表成功");
}
function BPrint_Clicked()	
{
	///alertShow(Loc);
	///MonthChange();
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQStatLoc.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    //xlsheet.PageSetup.RightMargin=0;
	    xlsheet.cells(2,1)="报表月份:"+GetElementValue("MonthStr");
	    var encmeth=GetElementValue("ChangeDateMask");
	    var StartDate=GetElementValue("StartDate");
	    var EndDate=GetElementValue("EndDate");
	    StartDate=cspRunServerMethod(encmeth,StartDate);
	    EndDate=cspRunServerMethod(encmeth,EndDate);
	    xlsheet.cells(2,5)="报表日期:"+StartDate+"---"+EndDate;
	    
	    var ValStatCat=GetElementValue("ValStatCat");
	    var StatCatIDs=ValStatCat.split(",");
	    var i=StatCatIDs.length;
	    var j=0;
	    var row=0;
	    
	    var StockBegin=0
		var StockIn=0
		var StockReturn=0
		var StockReduce=0
		var StockMoveOut=0
		var StockMoveIn=0
		var StockEnd=0
		var UsedBegin=0
		var UsedIn=0
		var UsedReturn=0
		var UsedMoveIn=0
		var UsedMoveOut=0
		var Disused=0
		var UsedEnd=0
		var ChangeAccount=0;
		var encmeth=GetElementValue("GetOneStatCatReport");
	    for (j=0;j<i;j++)
	    {		    
		    var StatCatID=StatCatIDs[j];
			
			var HadData=true;
		    var PreOrigin="";
			while (HadData)
			{
				var Return=cspRunServerMethod(encmeth,StatCatID,GetElementValue("MonthStr"),"",PreOrigin);
				///alertShow(StatCatID+" "+PreOrigin+" "+Return);
				if (Return=="")
				{ 
					HadData=false;
					PreOrigin="";
				}
				else
				{
					xlsheet.Rows(4+row).Insert();
					Return=Return.split("^");
			
					///xlsheet.cells(4+j,2)=Return[0];		///StockBegin
					///xlsheet.cells(4+j,3)=Return[1];		///StockIn
					///xlsheet.cells(4+j,4)=Return[2];		///StockReturn
					///xlsheet.cells(4+j,5)=Return[3];		///StockReduce
					///xlsheet.cells(4+j,5)=Return[4];		///StockMoveOut
					///xlsheet.cells(4+j,6)=Return[5];		///StockMoveIn
					///xlsheet.cells(4+j,8)=Return[6];		///StockEnd
					xlsheet.cells(4+row,3)=Return[7];		///UsedBegin
					xlsheet.cells(4+row,4)=Return[8];		///UsedIn
					xlsheet.cells(4+row,5)=Return[9];	///UsedReturn
					xlsheet.cells(4+row,8)=Return[10];	///UsedMoveIn
					xlsheet.cells(4+row,7)=Return[11];	///UsedMoveOut
					xlsheet.cells(4+row,6)=Return[12];	///Disused
					xlsheet.cells(4+row,9)=Return[13];	///UsedEnd
					///xlsheet.cells(4+j,1)=Return[14];	///ChangeAccount
					xlsheet.cells(4+row,1)=Return[15];	///StatCat
					
					PreOrigin=Return[16];	///Origin
					xlsheet.cells(4+row,2)=Return[17];	///OriginDesc
			
					StockBegin=parseFloat(StockBegin)+parseFloat(Return[0]);
					StockIn=parseFloat(StockIn)+parseFloat(Return[1]);
					StockReturn=parseFloat(StockReturn)+parseFloat(Return[2]);
					StockReduce=parseFloat(StockReduce)+parseFloat(Return[3]);
					StockMoveOut=parseFloat(StockMoveOut)+parseFloat(Return[4]);
					StockMoveIn=parseFloat(StockMoveIn)+parseFloat(Return[5]);
					StockEnd=parseFloat(StockEnd)+parseFloat(Return[6]);
					UsedBegin=parseFloat(UsedBegin)+parseFloat(Return[7]);
					UsedIn=parseFloat(UsedIn)+parseFloat(Return[8]);
					UsedReturn=parseFloat(UsedReturn)+parseFloat(Return[9]);
					UsedMoveIn=parseFloat(UsedMoveIn)+parseFloat(Return[10]);
					UsedMoveOut=parseFloat(UsedMoveOut)+parseFloat(Return[11]);
					Disused=parseFloat(Disused)+parseFloat(Return[12]);
					UsedEnd=parseFloat(UsedEnd)+parseFloat(Return[13]);
					ChangeAccount=parseFloat(ChangeAccount)+parseFloat(Return[14])
					row++;
				}
			}
	    }
	    /// xlsheet.cells(4+j,2)=StockBegin;
		///xlsheet.cells(4+j,3)=StockIn;
		///xlsheet.cells(4+j,4)=StockReturn;
		///xlsheet.cells(4+j,5)=StockReduce;
		///xlsheet.cells(4+j,5)=StockMoveOut;
		///xlsheet.cells(4+j,6)=StockMoveIn;
		///xlsheet.cells(4+j,8)=StockEnd;
		xlsheet.cells(4+row,3)=UsedBegin;
		xlsheet.cells(4+row,4)=UsedIn;
		xlsheet.cells(4+row,5)=UsedReturn;
		xlsheet.cells(4+row,8)=UsedMoveIn;
		xlsheet.cells(4+row,7)=UsedMoveOut;
		xlsheet.cells(4+row,6)=Disused;
		xlsheet.cells(4+row,9)=UsedEnd;
		xlsheet.cells(4+row,1)="总计:";
		row=row+1;
	    xlsheet.Rows(4+row).Delete();
	    xlsheet.cells(4+row,1)="负责人:"
	    xlsheet.cells(4+row,5)="制表人:"+curUserName;
	    xlsheet.printout;	// 打印输出
	    ///xlBook.SaveAs("D:\\DHCEQStatCatReport.xls");   //lgl+
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

function GetLoc (value)
{
    GetLookUpID("LocDR",value);
}

function BodyUnLoadHandler()
{
	var encmeth=GetElementValue("KillTempGlobal");
	cspRunServerMethod(encmeth,"StatMonth");
}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
