///Created By HZY 2011-08-03 . HZY0004 
///Description:设备验收明细查询
/// -------------------------------
function BodyLoadHandler()
{
	
	SetElement("ProviderCHeck",GetElementValue("ProviderCHeckID"));//Add By QW-2014-10-20
	InitPage();
	SetStatus();
	Muilt_LookUp("StoreLoc^EquipType^EquipCat^StatCat^Provider^Model^UseLoc","N");
	fillData();
	RefreshData();	
	HiddenTableIcon("DHCEQCheckDetailFind","TRowID","TOpenCheckRequest");   //add by czf 需求号：348761
}

function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"))
}

function InitPage()
{	
	KeyUp("StoreLoc^EquipType^EquipCat^StatCat^Provider^Model^UseLoc","N");
	
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
	
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

///Modified By HZY 2012-04-20
///Desc:改用最新的通用打印函数(当有'导出列设置'时使用):PrintDHCEQEquipNew .
function BPrint_Click()
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	//function  PrintDHCEQEquipNew(TableName,SaveOrPrint,job,vData,TempNode)
	PrintDHCEQEquipNew("OpenCheckList",1,TJob,GetElementValue("vData"),"CheckDetail");
	return;
	
	/*
	//0                1                 2          3          4         5          6          7             8            9                   10            11         12               13      14             15              16             17         18             19            20          21                 22      23            24 
	//TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TJob
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	
	var encmethList=GetElementValue("GetList");
	var encmethNum=GetElementValue("GetNum");
	var TotalRows=cspRunServerMethod(encmethNum,"CheckDetail",TJob);
	
	var PageRows=43 	//每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) 	//总页数-1  
	var ModRows=TotalRows%PageRows 		//最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQOpenCheckList.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows
		    	}
	    	}
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
			    var OneDetail=cspRunServerMethod(encmethList,"CheckDetail",TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[12];
		    	if (l==TotalRows) xlsheet.cells(j,1)=OneDetailList[19];
		    	var Provider=GetShortName(OneDetailList[2],"-");
		    	xlsheet.cells(j,2)=Provider;
		    	xlsheet.cells(j,3)=OneDetailList[14];
		    	xlsheet.cells(j,4)=OneDetailList[15];
		    	xlsheet.cells(j,5)=OneDetailList[16];
		    	xlsheet.cells(j,6)=OneDetailList[20];
		    	xlsheet.cells(j,7)=OneDetailList[19];
		    	if (l==TotalRows) xlsheet.cells(j,7)="";
			}
			
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,6)="制表人:"
			xlsheet.cells(j+1,7)=curUserName
			var savepath=GetFileName();  
			xlBook.SaveAs(savepath);   
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
	*/
} 

function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")		//设备分类树
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
	SetWindowSize(str,0,360,460,150,150);  //add By HHM 20150824 HHM0001
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
}

function GetLoc(value)
{
	GetLookUpID("StoreLocDR",value);
}

function GetUseLoc(value)
{
	GetLookUpID("UseLocDR",value);
}

function GetModel(value)
{
	GetLookUpID("ModelDR",value);
}

function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}

function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}

function GetStatCat(value)
{
	GetLookUpID("StatCatDR",value);
}

function GetEquipCat(value)
{
	GetLookUpID("EquipCatDR",value);
}

function BFind_Click()
{
	var val="&vData="
	val=val+GetVData();
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckDetailFind"+val;
}

function GetVData()
{
	var	val="^Type="+GetElementValue("Type");
	val=val+"^StoreLocDR="+GetElementValue("StoreLocDR");				//设备库房
	val=val+"^Status="+GetElementValue("Status");		//状态
	val=val+"^ModelDR="+GetElementValue("ModelDR");			//机型
	//val=val+"^InvoiceNos="+GetElementValue("InvoiceNos");	//发票号
	val=val+"^MinPrice="+GetElementValue("MinPrice");
	val=val+"^MaxPrice="+GetElementValue("MaxPrice");
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");	//供应商
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^EquipCatDR="+GetElementValue("EquipCatDR");	//设备分类
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");	//设备类组
	val=val+"^StatCatDR="+GetElementValue("StatCatDR");		//设备类型
	val=val+"^RequestNo="+GetElementValue("RequestNo");
	val=val+"^FileNo="+GetElementValue("FileNo");       //档案编号
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");   //使用科室
	//Add By QW-2014-10-20 供应商模糊查询
	val=val+"^ProviderQuery="+GetElementValue("ProviderQuery");   //增加供应商模糊查询
	val=val+"^ProviderCHeck="+GetElementValue("ProviderCHeck");   //模糊查询条件
	//End By QW-2014-10-20
	val=val+"^EquipNo="+GetElementValue("EquipNo");    //Modify By QW0004-2015-01-02 设备编号
	//val=val+"^ManuFactoryDR="+GetElementValue("ManuFactoryDR");	//生产商
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
	val=val+"dept=StoreLoc="+GetElementValue("StoreLocDR")+"^";
	val=val+"equipcat=EquipCat="+GetElementValue("EquipCatDR")+"^";
	val=val+"statcat=StatCat="+GetElementValue("StatCatDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	val=val+"model=Model="+GetElementValue("ModelDR")+"^";
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

function BodyUnLoadHandler()
{
	var encmeth=GetElementValue("KillTempGlobal");
	cspRunServerMethod(encmeth,"CheckDetail");
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
