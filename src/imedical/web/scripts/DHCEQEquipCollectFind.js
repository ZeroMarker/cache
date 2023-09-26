///----------------------------------------
///Created By HZY 2011-09-20
///Description:设备汇总统计查询
///----------------------------------------

var readonly;
var BatchFlag="N";
function BodyLoadHandler() 
{
	InitPage();
}
///初始化页面
function InitPage()
{
	document.body.scroll="no";
	KeyUp("UseLoc^EquipType^PurposeType^Service^EquiCat^Provider^ManuFactory^PurchaseType^Origin^StatCat^FundsType^FundsRecord^StoreLoc^MasterItem","N")
	Muilt_LookUp("UseLoc^EquipType^PurposeType^Service^EquiCat^Provider^ManuFactory^PurchaseType^Origin^StatCat^FundsType^FundsRecord^StoreLoc^MasterItem^ServiceHandlerDesc");
	var obj=document.getElementById("StatusDisplay");
	if (obj) {obj.onchange=StatusDisplay_KeyUp;}
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Click;
	
	var obj=document.getElementById(GetLookupName("EquiCat"));
	if (obj) obj.onclick=EquiCat_Click;
}

function StatusDisplay_KeyUp()
{
	var obj=document.getElementById("Status");
	if (obj) obj.value=""
}

function BFind_Click()
{
	var lnk=GetLnk();
	parent.DHCEQEquipCollect.location.href=lnk;
}

function GetLnk()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipCollect";
	lnk=lnk+"&Data="
	lnk=lnk+"^No="+GetElementValue("No");
	lnk=lnk+"^Name="+GetElementValue("Name");
	lnk=lnk+"^Code="+GetElementValue("Code");
	lnk=lnk+"^UseLocDR="+GetElementValue("UseLocDR");
	lnk=lnk+"^ManageLocDR="+GetElementValue("ManageLocDR");
	lnk=lnk+"^StoreLocDR="+GetElementValue("StoreLocDR");
	lnk=lnk+"^ModelDR="+GetElementValue("ModelDR");
	lnk=lnk+"^Status="+GetElementValue("Status");
	lnk=lnk+"^MinValue="+GetElementValue("MinValue");
	lnk=lnk+"^MaxValue="+GetElementValue("MaxValue");
	lnk=lnk+"^ProviderDR="+GetElementValue("ProviderDR");
	lnk=lnk+"^ManuFactoryDR="+GetElementValue("ManuFactoryDR");
	lnk=lnk+"^ServiceDR="+GetElementValue("ServiceDR");
	lnk=lnk+"^EquipCatDR="+GetElementValue("EquiCatDR");	
	lnk=lnk+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	lnk=lnk+"^PurposeTypeDR="+GetElementValue("PurposeTypeDR");
	lnk=lnk+"^QXType="+GetElementValue("QXType");
	lnk=lnk+"^OriginDR="+GetElementValue("OriginDR");
	lnk=lnk+"^PurchaseTypeDR="+GetElementValue("PurchaseTypeDR");
	
	lnk=lnk+"^BeginInStockDate="+GetElementValue("BeginInStockDate");
	lnk=lnk+"^EndInStockDate="+GetElementValue("EndInStockDate");
	BatchFlag=GetChkElementValue("BatchFlag");
	if (BatchFlag==true) BatchFlag="Y";
	if (BatchFlag==false) BatchFlag="N";
	lnk=lnk+"^BatchFlag="+BatchFlag;
	var IncludeFlag="0";
	if (GetChkElementValue("IncludeFlag")==true)
	{
		var IncludeFlag="1"
	}
	lnk=lnk+"^IncludeFlag="+IncludeFlag;
	lnk=lnk+"^StatCatDR="+GetElementValue("StatCatDR")
	
	lnk=lnk+"^InvoiceNo="+GetElementValue("InvoiceNo")
	lnk=lnk+"^ContractNo="+GetElementValue("ContractNo")
	lnk=lnk+"^IsDisused="+GetElementValue("IsDisused")
	lnk=lnk+"^IsDisusing="+GetElementValue("IsDisusing")
	lnk=lnk+"^IsOut="+GetElementValue("IsOut")
	lnk=lnk+"^ComputerFlag="+GetElementValue("ComputerFlag")
	lnk=lnk+"^MemoryCode="+GetElementValue("MemoryCode")
	
	//add by JDL 2009-9-16 JDL0033
	lnk=lnk+"^BeginTransAssetDate="+GetElementValue("BeginTransAssetDate")
	lnk=lnk+"^EndTransAssetDate="+GetElementValue("EndTransAssetDate")
	//add by jdl 2010-3-30	JDL0045
	lnk=lnk+"^FundsTypeDR="+GetElementValue("FundsTypeDR")
	lnk=lnk+"^FundsRecordDR="+GetElementValue("FundsRecordDR")
	//add By DJ 2010-07-21
	lnk=lnk+"^BeginDisuseDate="+GetElementValue("BeginDisuseDate");
	lnk=lnk+"^EndDisuseDate="+GetElementValue("EndDisuseDate");
	//add by jdl 2010-8-25
	lnk=lnk+"^BeginOutDate="+GetElementValue("BeginOutDate");
	lnk=lnk+"^EndOutDate="+GetElementValue("EndOutDate");
	
	//add By ZY 2010-08-09
	lnk=lnk+"^MasterItemDR="+GetElementValue("MasterItemDR");
	//add By DJ 2010-10-27
	var LocIncludeFlag="0";
	if (GetChkElementValue("LocIncludeFlag")==true)
	{
		var LocIncludeFlag="1"
	}
	lnk=lnk+"^LocIncludeFlag="+LocIncludeFlag;
	
	// add by Mozy	2011-3-7
	lnk=lnk+"^InStockNo="+GetElementValue("InStockNo");			//入库单号
	lnk=lnk+"^LeaveFactoryNo="+GetElementValue("LeaveFactoryNo");
	lnk=lnk+"^StoreMoveNo="+GetElementValue("StoreMoveNo");
	
	//add by jdl 2010-12-09 JDL0063
	lnk=lnk+"^TreeNo="+GetElementValue("TreeNo");
	
	//20150827  Mozy0163	存放地点
	lnk=lnk+"^LocationDR="+GetElementValue("LocationDR");
	//add by zy 2011-02-22 ZY0061
	lnk=lnk+"^PreDisuseFlag="+GetElementValue("PreDisuseFlag");
	
	lnk=lnk+"&ReadOnly="+readonly;
	
	return lnk;
}

function BSaveExcel_Click()
{
	var templateName="DHCEQEquipCollect.xls";
	var isSave=1;
	var savefilename=GetFileName();
	if (savefilename=="") return;
	//var colset="1:1^2:2^3:0^4:3";///列x1:输出结果第y1位^列x2:输出结果第y2位.....
	var colset="1:4^2:0^3:6^4:7^5:1^6:2^7:5^8:3^9:8^10:9^11:11^12:10";
	//TEquipType_"^"_TName_"^"_TModel_"^"_TOriginalFee_"^"_TStoreLoc_"^"_TOrigin_"^"_TStatCat_"^"_TEquipCat_"^"_TQuantity_"^"_TTotalFee_"^"_TTotalNet_"^"_TTotalDepre
	//var colset="1:5^2:1^3:7^4:8^5:2^6:3^7:6^8:4^9:9^10:9^10:12^12:11";
	//PrintEQReport(templateName,isSave,savefilename,colset)
	
	var TemplatePath=GetElementValue("GetRepPath");
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+templateName; 
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
 
	    var HadData=true;		
		var num=1;
		var row=2;
		while (HadData)
		{
			var rtn=GetReportData(num)			
			if (rtn=="")
			{
				HadData=false;
			}
			else
			{
				row=row+1;
				fillRowData(xlsheet,row,rtn,colset);
				num=num+1;
			}
		}    

	    if (isSave==1)
	    {	
	    	xlBook.SaveAs(savefilename);
	    	alertShow('保存成功,保存路径:'+savefilename);
	    }
	    else
	    {	
	    	xlsheet.printout;	
	    }	// 打印输出
	    
	    xlBook.Close(savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function GetReportData(num)
{
	var encmeth=GetElementValue("GetReportData");
	var rtn=cspRunServerMethod(encmeth,num);
	return rtn;
}

function GetService(value)
{
    GetLookUpID("ServiceDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetPurposeType (value)
{
    GetLookUpID("PurposeTypeDR",value);
}
function GetOrigin (value)
{
    GetLookUpID("OriginDR",value);
}
function GetStatCat(value)
{
	GetLookUpID("StatCatDR",value);
}
function EquiCat_Click()
{
	var CatName=GetElementValue("EquiCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquiCat",text);
	SetElement("EquiCatDR",id);
}

function GetStoreLocID(value)
{
	GetLookUpID("StoreLocDR",value);
}

//add by jdl 2010-3-30	JDL0045
function GetFundsType(value)
{
	GetLookUpID("FundsTypeDR",value);
}

function GetFundsRecord(value)
{
	GetLookUpID("FundsRecordDR",value);
}

//add by ZY 2010-08-09
function GetMasterItemID(value)
{
	GetLookUpID("MasterItemDR",value);
}

///20150827  Mozy0163	存放地点
function SetLocation(value)
{
	list=value.split("^");
	SetElement("LocationDR",list[0]);
	SetElement("Location",list[2]);
}

document.body.onload = BodyLoadHandler;