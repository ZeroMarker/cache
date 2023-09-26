///修改: ZY 2009-11-17 ZY0017
///修改函数BPrint_Click
///描述:导出时保存路径的设置
/// -------------------------------
function BodyLoadHandler()
{
	initButtonWidth();	/// Mozy		888605	2019-5-21	Hisui改造
	InitPage();
	SetStatus();
	Muilt_LookUp("Loc^Provider^AccessoryType^BuyUser");
	fillData();
	RefreshData();
	//SetTableRow();	/// Mozy		888605	2019-5-21	Hisui改造
}

function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"))
}
function InitPage()
{
	KeyUp("Loc^Provider^AccessoryType^BuyUser");
	var obj=document.getElementById("BExport"); //modified by sjh 2019-11-25 BUG00018
	if (obj) obj.onclick=BExport_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BClear");		//Mozy	984437	2019-8-5
	if (obj) obj.onclick=BClear_Click;
}

function BExport_Click()  //modified by sjh 2019-11-25 BUG00018
{
	///元素?GetRepPath?GetReportData
	///
	var templateName="DHCEQAStockStat.xls";
	var isSave=1;
	var savefilename=GetFileName();
	///locdesc_"^"_equiptypedesc_"^"_deprefee
	//var colset="1:1^2:2^3:0^4:3";///列x1:输出结果第y1位^列x2:输出结果第y2位.....
	//var colset="1:4^2:0^3:5^4:6^5:2^6:9^7:10^8:11^9:10^10:13^11:14";///列x1:输出结果第y1位^列x2:输出结果第y2位.....
	var colset="1:0^2:1^3:2^4:3^5:4^6:5^7:6^8:7";///列x1:输出结果第y1位^列x2:输出结果第y2位.....
	PrintEQReport(templateName,isSave,savefilename,colset);
}

function PrintEQReportHeader(xlsheet)
{
	var row=2;	
	xlsheet.cells(row,1)="开始日期:"+GetElementValue("StartDate");  //modify BY:GBX 2014-9-12 16:20:03
	xlsheet.cells(row,3)="结束日期:"+GetElementValue("EndDate");
	row=row+1;
	return row;
}

function GetReportData(num)
{
	//modified by sjh 2020-01-03 SJH00021 begin
/* 	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value; */
	var ObjTJob=$('#tDHCEQAStockStat').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	//modified by sjh 2020-01-03 SJH00021 end
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneInStockDetail");
	var rtn=cspRunServerMethod(encmeth,num,TJob);
	return rtn;
}

function PrintEQReportFooter(xlsheet,row)
{
	///最后一行添加代码
}

function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}

function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function GetAccessoryType(value)
{
	GetLookUpID("AccessoryTypeDR",value);
}
//201702-04	Mozy
function GetBuyUser(value)
{
	GetLookUpID("BuyUserDR",value);
}
function BodyUnLoadHandler()
{
	var encmeth=GetElementValue("KillTempGlobal");
	//cspRunServerMethod(encmeth,"InStockDetail");
}
function BFind_Click()
{
	var val="&vData="+GetVData();
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAStockStat"+val;
}
function GetVData()
{
	var	val="^LocDR="+GetElementValue("LocDR");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^InvoiceNos="+GetElementValue("InvoiceNos");
	val=val+"^MinPrice="+GetElementValue("MinPrice");
	val=val+"^MaxPrice="+GetElementValue("MaxPrice");
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^AccessoryTypeDR="+GetElementValue("AccessoryTypeDR");
	val=val+"^InStockNo="+GetElementValue("InStockNo");
	val=val+"^ShortDesc="+GetElementValue("ShortDesc");
	val=val+"^BuyUserDR="+GetElementValue("BuyUserDR");	//201702-04	Mozy
	val=val+"^ChkNoInvoice=";
	if (GetChkElementValue("ChkNoInvoice")==true) val=val+"Y";
	
	return val;
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
	val=val+"prov=Provider="+GetElementValue("ProviderDR")+"^";
	val=val+"dept=Loc="+GetElementValue("LocDR")+"^";
	val=val+"AccessoryType=AccessoryType="+GetElementValue("AccessoryTypeDR")+"^";
	val=val+"user=BuyUser="+GetElementValue("BuyUserDR")+"^";	//201702-04	Mozy
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function BodyUnLoadHandler()
{
	var encmeth=GetElementValue("KillTempGlobal");
	//cspRunServerMethod(encmeth,"InStockDetail");
}
function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Click();
}
/*// Mozy		888605	2019-5-21	Hisui改造
function SetTableRow()
{
	var objtbl=document.getElementById("tDHCEQAStockStat");
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQAStockStat");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (selectrow==1)  return;   //add by mwz 20180929 需求号666240
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&RowID="+GetElementValue("TRowIDz"+selectrow)+"&CurRole="+GetElementValue("ApproveRole")+"&Type="+GetElementValue("Type")+"&WaitAD="+GetElementValue("WaitAD");
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=400,left=100,top=10');
	//window.location.href=str;
}*/
function DblClickRowHandler(rowIndex,rowData)
{
	if (rowData.TRowID>0)
	{
		// Mozy		2019-10-18
		var url="dhceq.mp.instock.csp?&ReadOnly=1&RowID="+rowData.TRowID+"&Type="+GetElementValue("Type")+"&WaitAD="+GetElementValue("WaitAD");
		showWindow(url,"配件入库单","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
	}
}
//Mozy	984437	2019-8-5
function BClear_Click()
{
	SetElement("InStockNo","");
	SetElement("Name","");
	SetElement("StartDate","");
	SetElement("EndDate","");
	SetElement("InvoiceNos","");
	SetElement("ShortDesc","");
	SetElement("AccessoryType","");
	SetElement("AccessoryTypeDR","");
	SetChkElement("ChkNoInvoice","");
	SetElement("StatusDR","");
	SetElement("Status","");
	SetElement("Provider","");
	SetElement("ProviderDR","");
	SetElement("MinPrice","");
	SetElement("MaxPrice","");
	SetElement("BuyUser","");
	SetElement("BuyUserDR","");
	SetElement("Loc","");
	SetElement("LocDR","");
}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
