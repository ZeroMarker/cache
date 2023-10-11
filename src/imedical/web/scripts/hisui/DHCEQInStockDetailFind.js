///修改: ZY 2009-11-17 ZY0017
///修改函数BPrint_Click
///描述:导出时保存路径的设置
/// -------------------------------
function BodyLoadHandler(){	
	initButtonWidth(); //HISUI改造-修改按钮展示样式	add by kdf 2018-09-04
	InitPage();
	SetStatus();
	Muilt_LookUp("Loc^Provider^Model^EquipType^IsPrint^Hospital");  //回车选择 Modied By QW20210629 BUG:QW0131 院区
	fillData();
	RefreshData();
	HiddenTableIcon("DHCEQInStockDetailFind","TRowID","TISNo");
	$('#tDHCEQInStockDetailFind').datagrid('options').view.onAfterRender = ReLoadGrid;
	//add by hyy 2023-02-03 ui改造
	initPanelHeaderStyle();
	initButtonColor();
}

function ReLoadGrid()
{
	creatToolbar();
	fixTGrid();		//czf 2783239 2022-09-05
}
function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"))
}
function InitPage()
{
	KeyUp("Loc^Provider^Model^EquipType^EquipCat^StatCat^IsPrint^Hospital");  //清空选择 Modied By QW20210629 BUG:QW0131 院区
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	//Add By QW20210629 BUG:QW0131 院区 begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 院区 end
}
function BPrint_Click()
{
	//2011-07-20 DJ begin
	//var ObjTJob=document.getElementById("TJobz1");
	//if (ObjTJob)  TJob=ObjTJob.value;
	/* czf 20210126 此段程序不实现任何功能，数据不能导出
	var Rows = $('#tDHCEQInStockDetailFind').datagrid('getRows');
	var RowCount=Rows.length;
	if(RowCount<=0){
		messageShow("","","","没有待处理数据!")
		return;
	}
	var Count=0
	var RowIDs=""
	for (var i=0;i<RowCount;i++)
	{
		$('#tDHCEQInStockDetailFind').datagrid('endEdit',i);	//modified by czf 20190116
		var TOperator=Rows[i].TOperator;
		if (TOperator=="1"||TOperator=="Y") //modified by csj 20191023
		{
			Count=Count+1
			if (RowIDs=="")
			{
				RowIDs=Rows[i].TRowID;
			}
			else
			{
				RowIDs=RowIDs+","+Rows[i].TRowID;
			}
		}
		$('#tDHCEQInStockDetailFind').datagrid('beginEdit',i); //add by zx 2019-09-16
	}
	if(Count==0){
		messageShow("","","","请勾选需要处理的数据!")
		return;
	}
	
	var arrRowId=RowIDs.split(",");
	var len=arrRowId.length;
	for (var i=0;i<=arrRowId.length-1;i++){
		alert(arrRowId[i])
		len--;
	}
	if(len=1)
	{
		alert("打印完毕")
	}
	return
	*/
	//HISUI改造-修改TJob取值获取不到的问题 begin add by kdf 2018-09-07
	var ObjTJob=$('#tDHCEQInStockDetailFind').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	//HISUI改造-修改TJob取值获取不到的问题  end add by kdf 2018-09-07
	
	if (TJob=="")  return;
	//Modefied by zc0093  润乾导出修改 2021-01-07 begin
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		// MZY0114	2446284		2022-01-27
		if (!CheckColset("InStockList"))
		{
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQInStockExport.raq&CurTableName=InStockList&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		PrintDHCEQEquipNew("InStockList",1,TJob,GetElementValue("vData"))
	}
	return
	//Modefied by zc0093  润乾导出修改 2021-01-07 end
	//2011-07-20 DJ end
	//0                1                 2          3          4         5          6          7             8            9                   10            11         12               13      14             15              16             17         18             19            20          21                 22      23            24 
	//TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TJob
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneInStockDetail");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	
	var PageRows=43 //每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQInStockDetailSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
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
			    var OneDetail=cspRunServerMethod(encmeth,l,TJob);
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
	    	//xlsheet.printout; //打印输出
			var savepath=GetFileName();  //Modified By ZY 2009-11-17 ZY0017
			xlBook.SaveAs(savepath);   //Modified By ZY 2009-11-17 ZY0017
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
} 
function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
}
function GetLoc(value)
{
	GetLookUpID("LocDR",value);
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

//Add By QW20210422 bug:QW0100
function GetIsPrint(value)
{
	GetLookUpID("IsPrintDR",value);
}

function BodyUnLoadHandler()
{
	var encmeth=GetElementValue("KillTempGlobal");
	cspRunServerMethod(encmeth,"InStockDetail");
}
function BFind_Click()
{
	
	var val="&vData="
	val=val+GetVData();
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQInStockDetailFind"+val; ////HISUI改造 更换csp modified by kdf 2018-09-04
}

function GetVData()
{
	var	val="^Type="+GetElementValue("Type");
	val=val+"^LocDR="+GetElementValue("LocDR");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^InvoiceNos="+GetElementValue("InvoiceNos");
	val=val+"^MinPrice="+GetElementValue("MinPrice");
	val=val+"^MaxPrice="+GetElementValue("MaxPrice");
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");
	val=val+"^ModelDR="+GetElementValue("ModelDR");	
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	//messageShow("","","",GetElementValue("StartDate"))
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^EquipCatDR="+GetElementValue("EquipCatDR");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^StatCatDR="+GetElementValue("StatCatDR");
	val=val+"^InStockNo="+GetElementValue("InStockNo");
	val=val+"^EquipNo="+GetElementValue("EquipNo");
	val=val+"^Flag="+GetElementValue("Flag");
	val=val+"^ContractNo="+GetElementValue("ContractNo");	//2014-07-21 DJ0125
	val=val+"^IsPrintDR="+GetElementValue("IsPrintDR");  //Add By QW20210422 bug:QW0100
	if(GetChkElementValue("ReduceFilter"))  //2015-07-24 zx
	{
		var ReduceFilter=1;
		}
	else{
		ReduceFilter=0;
		}
	val=val+"^ReduceFilter="+ReduceFilter;
	val=val+"^HospitalDR="+GetElementValue("HospitalDR");   //Add By QW20210629 BUG:QW0131 院区
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
				case "ReduceFilter":   //add by zx 2015-08-03
				    SetChkElement(Detail[0],Detail[1]);
				    break;
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"prov=Provider="+GetElementValue("ProviderDR")+"^";
	val=val+"dept=Loc="+GetElementValue("LocDR")+"^";
	val=val+"equipcat=EquipCat="+GetElementValue("EquipCatDR")+"^";
	val=val+"statcat=StatCat="+GetElementValue("StatCatDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	val=val+"isprint=IsPrint="+GetElementValue("IsPrintDR")+"^";  //Add By QW20210422 bug:QW0100
	val=val+"hos=Hospital="+GetElementValue("HospitalDR")+"^"; //Add By QW20210629 BUG:QW0131 院区
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
//Add By QW20210629 BUG:QW0131 院区
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}

//czf 2022-06-06
//显示入库明细合计行
function creatToolbar()
{
	var Node="InStockDetail";
	var currentobj=$("#tDHCEQInStockDetailFind").datagrid('getRows');
	if (currentobj.length>0)
	{
		var TJob=currentobj[0]['TJob'];
		if (TJob=="")  return;
		
        //modified by ZY 20221011 修改合计行取值位置
        //var Data = tkMakeServerCall("web.DHCEQInStockList","GetSumInfo",TJob); 
        var Data = tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalTotalInfo",'InStockDetail','',TJob,''); 
		$("#sumTotal").html(Data);
	} 
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
