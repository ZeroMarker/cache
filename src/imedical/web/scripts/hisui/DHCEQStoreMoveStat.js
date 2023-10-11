///修改: ZY 2009-11-17 ZY0017
///修改函数BPrint_Click
///描述:导出时保存路径的设置
/// -------------------------------
/// 修改:ZY  2009-07-06  BugNo.ZY0007
/// 修改描述:增加函数MovType
/// 作用描述:修改设备转移类型的时候??给供给科室和接受科室传递不同的科室类型参数
/// --------------------------------
///modify by jyp 2018-08-16 Hisui改造：添加initButtonWidth()方法控制按钮长度
function BodyLoadHandler(){	
	initButtonWidth();
	InitPage();	
	SetStatus();
	Muilt_LookUp("FromLoc^ToLoc^Model^Provider^IsPrint^Hospital");  //回车选择 Modied By QW20210629 BUG:QW0131 院区
	SetElement("MoveType",GetElementValue("MoveTypeID"));
	fillData();
	RefreshData();
	//ui改造 add by hyy 2023-1-31
	creatToolbar();
	initPanelHeaderStyle();
	initButtonColor();
	$('#tDHCEQStoreMoveStat').datagrid('options').view.onAfterRender = ReLoadGrid;
}

function ReLoadGrid()
{
	hiddenTableIcon("DHCEQStoreMoveStat","TRowID","TDetail");
	creatToolbar();
	fixTGrid();		//czf 2783239 2022-09-05
}

///end add by jyp 2018-08-16 Hisui改造：原BodyLoadHandler()方法无法获取当前页行数
function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"))
}
function InitPage()
{
	KeyUp("FromLoc^ToLoc^Model^EquipType^EquipCat^Provider^IsPrint^Hospital","N");  //清空选择 Modied By QW20210629 BUG:QW0131 院区
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BBatprint");	// MZY0143	3084752		2022-11-16	批量打印条码
	if (obj) obj.onclick=BBatprint;
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;
	////////////////////
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

/// 创建:zy 2009-07-15 BugNo.ZY0007
/// 创建函数??oveType
/// 描述:修改设备转移类型的时候??给供给科室和接受科室传递不同的科室类型参数
/// -------------------------------
function MoveType()
{
	var value=GetElementValue("MoveType")
	if (value==0)
	{
		SetElement("FromLocType",1);
		SetElement("ToLocType","");
	}else if (value==3)
	{
		SetElement("FromLocType","");
		SetElement("ToLocType",1);
	}else
	{
		SetElement("FromLocType","");
		SetElement("ToLocType","");
	}
}
//////////
///modify by jyp 2018-08-16 Hisui改造：修改连接csp路径
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
function GetFromLoc(value)
{
	GetLookUpID("FromLocDR",value);
}

function GetModel(value)
{
	GetLookUpID("ModelDR",value);
}
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
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
 //Modify by zx 2020-08-20
function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
//Add By QW20210422 bug:QW0100
function GetIsPrint(value)
{
	GetLookUpID("IsPrintDR",value);
}

///modify by jyp 2018-08-16 Hisui改造：导出数据时无法取TJobz1的值
function BPrint_Click()
{
	//2011-07-20 DJ begin
	//var ObjTJob=document.getElementById("TJobz1");//modify by jyp 2018-08-16
	//if (ObjTJob)  TJob=ObjTJob.value;   //modify by jyp 2018-08-16
	//begin add by jyp 2018-08-16 
	var ObjTJob=$('#tDHCEQStoreMoveStat').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	//end add by jyp 2018-08-16
	if (TJob=="")  return;
	//Modefied by zc0093  润乾导出修改 2021-01-07 begin
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		// MZY0114	2446315		2022-01-27
		if (!CheckColset("StoreMoveList"))
		{
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQStoreMoveExport.raq&CurTableName=StoreMoveList&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		PrintDHCEQEquipNew("StoreMoveList",1,TJob,GetElementValue("vData"))
	}
	return
	//Modefied by zc0093  润乾导出修改 2021-01-07 end
	//2011-07-20 DJ end
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneStoreMoveStat");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	///messageShow("","","",TotalRows);
	
	var PageRows=43 //每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try {
		//   0            1             2            3             4         5          6             7               8             9              10            11          12         13             14           15                16             17          18         19            20              
		//TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat
		//TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat_"^"_TInStockNo_"^"_TOrigin_"^"_TEquipNo
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQStoreMoveStat.xls";
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
		    	
		    	xlsheet.cells(j,1)=OneDetailList[23];	///EquipNo
		    	if (l==TotalRows) 
		    	{
			    	xlsheet.cells(j,1)=OneDetailList[2];
			    }
		    	xlsheet.cells(j,2)=OneDetailList[12];	///EquipName
		    	
		    	var ToLocList=OneDetailList[4].split("-");
		    	if (ToLocList[1]!="")
		    	{
			    	var ToLoc=ToLocList[1];
		    	}
		    	else
		    	{
			    	var ToLoc=OneDetailList[4]
		    	}
		    	//Begin By ZY 2009-11-17 ZY0017
		    	var FromLocList=OneDetailList[2].split("-");
		    	if (FromLocList[1]!="")
		    	{
			    	var FromLoc=FromLocList[1];
		    	}
		    	else
		    	{
			    	var FromLoc=OneDetailList[4]
		    	}
		    	xlsheet.cells(j,3)=OneDetailList[14];	///Model
		    	xlsheet.cells(j,4)=OneDetailList[22];	///Origin
		    	xlsheet.cells(j,5)=OneDetailList[16];	///+OneDetailList[18];	///Qty;Unit
		    	xlsheet.cells(j,6)=OneDetailList[15];	///OriginalFee
		    	xlsheet.cells(j,7)=OneDetailList[19];	///TotalFee	
		    	xlsheet.cells(j,8)=OneDetailList[21];	///InStockNo	    	
		    	xlsheet.cells(j,9)=FromLoc;	    	
		    	xlsheet.cells(j,10)=ToLoc;
		    	//End By ZY 2009-11-17 ZY0017
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,10)=curUserName
			var savepath=GetFileName();  //Modified By ZY 2009-11-17 ZY0017
			xlBook.SaveAs(savepath);   //Modified By ZY 2009-11-17 ZY0017
	    	//xlsheet.printout; //打印输出
	    	//xlBook.SaveAs("D:\\DHCEQStoreMoveDetailSP"+i+".xls");   //lgl+
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
///modify by jyp 2018-08-16 Hisui改造：修改连接csp路径
function BFind_Click()
{
	var val="&vData="
	val=val+GetVData();
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveStat"+val;
}

function GetVData()
{
	var	val="^FromLocDR="+GetElementValue("FromLocDR");
	val=val+"^ToLocDR="+GetElementValue("ToLocDR");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^MoveType="+GetElementValue("MoveType");
	val=val+"^MinPrice="+GetElementValue("MinPrice");
	val=val+"^MaxPrice="+GetElementValue("MaxPrice");
	val=val+"^ModelDR="+GetElementValue("ModelDR");	
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^EquipCatDR="+GetElementValue("EquipCatDR");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^StatCatDR="+GetElementValue("StatCatDR");
	val=val+"^StoreMoveNo="+GetElementValue("StoreMoveNo");
	val=val+"^EquipNo="+GetElementValue("EquipNo");
	val=val+"^Flag="+GetElementValue("Flag");
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");  //Modify by zx 2020-08-20
	val=val+"^ContractNo="+GetElementValue("ContractNo");		//czf 20200818 1476413
	val=val+"^IsPrintDR="+GetElementValue("IsPrintDR");  //Add By QW20210422 bug:QW0100
	val=val+"^LeaveFactoryNo="+GetElementValue("LeaveFactoryNo");  //Modify by zx 2020-05-19 Bug 1880109
	val=val+"^HospitalDR="+GetElementValue("HospitalDR");   //Add By QW20210629 BUG:QW0131 院区
	val=val+"^SAuditDate="+GetElementValue("SAuditDate");	// MZY0157	3412819		2023-03-29
	val=val+"^EAuditDate="+GetElementValue("EAuditDate");
	val=val+"^QXType="+GetElementValue("QXType");
	val=val+"^ApproveRoleDR="+GetElementValue("ApproveRoleDR");
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
	val=val+"dept=FromLoc="+GetElementValue("FromLocDR")+"^";
	val=val+"dept=ToLoc="+GetElementValue("ToLocDR")+"^";
	val=val+"equipcat=EquipCat="+GetElementValue("EquipCatDR")+"^";
	val=val+"statcat=StatCat="+GetElementValue("StatCatDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	val=val+"prov=Provider="+GetElementValue("ProviderDR")+"^";  //Modify by zx 2020-08-20
	val=val+"isprint=IsPrint="+GetElementValue("IsPrintDR")+"^";  //Add By QW20210422 bug:QW0100
	val=val+"hos=Hospital="+GetElementValue("HospitalDR")+"^"; //Add By QW20210629 BUG:QW0131 院区
	val=val+"model=Model="+GetElementValue("ModelDR")+"^";		// MZY0144	3075104		2022-11-24
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
//显示转移明细合计行
function creatToolbar()
{
	var currentobj=$("#tDHCEQStoreMoveStat").datagrid('getRows');
	if (currentobj.length>0)
	{
		var TJob=currentobj[0]['TJob'];
		if (TJob=="")  return;
		
        //modified by ZY 20221011 修改合计行取值位置
        //var Data = tkMakeServerCall("web.DHCEQStoreMoveList","GetSumInfo",TJob); 
        var Data = tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalTotalInfo",'StoreMoveStat','',TJob,''); 
		$("#sumTotal").html(Data);
	}
}
// MZY0143	3084752		2022-11-16
function BBatprint()
{
	var TJob="";
	var ObjTJob=$('#tDHCEQStoreMoveStat').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"]) TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="") return;
	
	var TotalRows=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalData","StoreMoveStat","",TJob);
	//alert(TJob+":"+TotalRows)
	var SMRowIDs="";
	for (var i=1; i<TotalRows; i++)
	{
		var result=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalData","StoreMoveStat","",TJob,"",i);
		var Detail=result.split("^");
		//alert(TJob+":"+i+":"+Detail[11])
		// TStatus
		if (Detail[11]=="审核")
		{
			if (SMRowIDs=="")
			{
				SMRowIDs=","+Detail[0]+",";
			}
			else
			{
				if (SMRowIDs.indexOf(","+Detail[0]+",")==-1) SMRowIDs=SMRowIDs+Detail[0]+",";
			}
		}
	}
	//alert(SMRowIDs)
	if (SMRowIDs=="") return;
	var list=SMRowIDs.split(",");
	for (var i=1; i<list.length-1; i++)
	{
		printEquipBar(list[i],"StoreMove");
	}
}
document.body.onload = BodyLoadHandler;