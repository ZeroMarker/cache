/// DHCEQDisuseRequestListDetail.js
/// Mozy0074 2011-12-21
function BodyLoadHandler()
{		
	InitPage();
	SetStatus();
	fillData();
	RefreshData();
	HiddenTableIcon("DHCEQDisuseRequestListDetail","TDRRowID","TDetail");
	HiddenTableIcon("DHCEQDisuseRequestListDetail","TDRRowID","TApprovals");		//add by czf CZF0020
}

function InitPage()
{
	Muilt_LookUp("RequestLoc^UserLoc^EquipType^ApproveRole");
	KeyUp("RequestLoc^UserLoc^EquipType^ApproveRole");
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Click;
}

function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"));
}
function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"dept=RequestLoc="+GetElementValue("RequestLocDR")+"^";
	val=val+"dept=UserLoc="+GetElementValue("UserLocDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}
function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Click();
}

function BFind_Click()
{
	var val="&vData="+GetVData();
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestListDetail"+val;
}

function GetVData()
{
	var	val="^RequestNo="+GetElementValue("RequestNo");
	val=val+"^InStockNo="+GetElementValue("InStockNo");
	val=val+"^Equip="+GetElementValue("Equip");
	val=val+"^No="+GetElementValue("No");
	val=val+"^MinPrice="+GetElementValue("MinPrice");
	val=val+"^MaxPrice="+GetElementValue("MaxPrice");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^RequestLoc="+GetElementValue("RequestLoc");	
	val=val+"^RequestLocDR="+GetElementValue("RequestLocDR");
	val=val+"^UserLoc="+GetElementValue("UserLoc");
	val=val+"^UserLocDR="+GetElementValue("UserLocDR");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^EquipType="+GetElementValue("EquipType");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^ApproveRole="+GetElementValue("ApproveRole");
	val=val+"^ApproveRoleDR="+GetElementValue("ApproveRoleDR");
	val=val+"^ApproveDate="+GetElementValue("ApproveDate");
	val=val+"^ApproveEndDate="+GetElementValue("ApproveEndDate");
	
	return val;
}

function GetRequestLoc(value)
{
	GetLookUpID("RequestLocDR",value);
}
function GetUserLoc(value)
{
	GetLookUpID("UserLocDR",value);
}
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}
// 20140409  Mozy0125
function GetApproveRole(value)
{
	GetLookUpID("ApproveRoleDR",value);
}
function BSaveExcel_Click()
{
	var Node="DisuseRequestDetail";
	var encmeth=GetElementValue("GetTempDataRows");
	var TJob=GetElementValue("TJobz1");
	if (TJob=="")  return;
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
        var encmeth=GetElementValue("GetRepPath");
		if (encmeth=="") return;
		var TemplatePath=cspRunServerMethod(encmeth);
	    var Template=TemplatePath+"DHCEQRequestListDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	//xlsheet.cells(2,1)=xlsheet.cells(2,1) //+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
				//	0				1					2			3			4		   5			6				7				8			 9			10			 11
				//TRequestNo_"^"_TRequestDate_"^"_TRequestLoc_"^"_TUserLoc_"^"_TEquip_"^"_TNo_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TEquipType_"^"_TStatus_"^"_TUnit_"^"_TInStockNo
		    	xlsheet.cells(j,col++)=OneDetailList[0];
		    	xlsheet.cells(j,col++)=OneDetailList[1];
		    	xlsheet.cells(j,col++)=OneDetailList[2];
		    	xlsheet.cells(j,col++)=OneDetailList[3];
		    	xlsheet.cells(j,col++)=OneDetailList[4];
		    	xlsheet.cells(j,col++)=OneDetailList[5];
		    	xlsheet.cells(j,col++)=OneDetailList[6];
		    	xlsheet.cells(j,col++)=OneDetailList[7];
		    	xlsheet.cells(j,col++)=OneDetailList[8];
		    	xlsheet.cells(j,col++)=OneDetailList[9];
		    	xlsheet.cells(j,col++)=OneDetailList[10];
		    	xlsheet.cells(j,col++)=OneDetailList[11];
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			//xlsheet.cells(2,1)="时间范围:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="制表人:"+curUserName

			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("导出完成!");
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function BodyUnLoadHandler()
{
	//var encmeth=GetElementValue("KillTempGlobal");
	//cspRunServerMethod(encmeth,"DisuseRequestDetail");
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
