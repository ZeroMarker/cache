///�޸�: ZY 2009-11-17 ZY0017
///�޸ĺ���BPrint_Click
///����:����ʱ����·��������
var Component="DHCEQReturnDetailFind"
///modify by jyp 2018-08-16 Hisui���죺���initButtonWidth()�������ư�ť����
function BodyLoadHandler(){	
	initPanelHeaderStyle(); //added by LMH 20230201 UI����
	InitPage();	
	SetStatus();
	//showBtnIcon("BFind^BPrint^BColSet",false); // added by LMH 20230201 UI���� ��̬��ʾ�����ذ�ťͼ��
	//initButtonWidth(); ///modify by jyp 2018-08-16 Hisui���죺���initButtonWidth()�������ư�ť����	//modified by LMH 20230302 UI
	if($('#cEQTitle').text()=== '�˻���ϸ��ѯ') initButtonWidth(); //added by LMH 20230406 UI �˻���ϸ�ͼ�����ϸ��ť�������
	Muilt_LookUp("Loc^Provider^Model^StatCat^EquipType^OutType^Hospital");  //�س�ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��	
	fillData();	
	if (GetElementValue("OutTypeDR")!=1) Component="DHCEQOutStockDetailFind"
	RefreshData();	
	$("#t"+Component).datagrid('options').view.onAfterRender = ReLoadGrid;
}

function ReLoadGrid()
{
	HiddenTableIcon(Component,"TRowID","TDetail");
	creatToolbar();
	fixTGrid();		//czf 2783239 2022-09-05
}

///end add by jyp 2018-08-16 Hisui���죺ԭBodyLoadHandler()�����޷���ȡ��ǰҳ����
function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"))
}
function InitPage()
{
	KeyUp("Loc^Provider^Model^EquipType^EquipCat^StatCat^OutType^Hospital","N");  //���ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	//Add By QW20210629 BUG:QW0131 Ժ�� begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 Ժ�� end
}
///modify by jyp 2018-08-16 Hisui���죺��������ʱ�޷�ȡTJobz1��ֵ
function BPrint_Click()
{
	
	//2011-07-20 DJ begin
	//var ObjTJob=document.getElementById("TJobz1");
	//if (ObjTJob)  TJob=ObjTJob.value;
	//begin add by jyp 2018-08-16 
	// modify by wl 2019-12-17 WL0031 ��������������
	var ObjTJob=$('#t'+Component).datagrid('getData');	//add by yh 20211208 ����豸������ϸ����ʱ��������������������
	
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	//end add by jyp 2018-08-16
	if (TJob=="")  return;
	//Modefied by zc0093  ��Ǭ�����޸� 2021-01-07 begin
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		// MZY0114	2446322,2446325		2022-01-27
		if (!CheckColset("ReturnList"))
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQReturnExport.raq&CurTableName=ReturnList&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		PrintDHCEQEquipNew("ReturnList",1,TJob,GetElementValue("vData"))
	}
	return		// MZY0114	2446322,2446325		2022-01-27
	//Modefied by zc0093  ��Ǭ�����޸� 2021-01-07 end
	//0                1                 2          3          4         5          6          7             8            9                   10            11         12               13      14             15              16             17         18             19            20          21                 22      23             
	//TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneReturnDetail");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	var PageRows=43 //ÿҳ�̶�����
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQReturnDetailSP.xls";
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
		    	if (l==TotalRows) xlsheet.cells(j,1)="�ܼ�:";
		    	var Provider=GetShortName(OneDetailList[2],"-")
		    	xlsheet.cells(j,2)=Provider;
		    	xlsheet.cells(j,3)=OneDetailList[14];
		    	xlsheet.cells(j,4)=OneDetailList[15];
		    	xlsheet.cells(j,5)=OneDetailList[16];
		    	xlsheet.cells(j,6)=OneDetailList[20];
			}
			
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,5)="�Ʊ���:"
			xlsheet.cells(j+1,6)=session['LOGON.USERNAME']
			var savepath=GetFileName();  //Modified By ZY 2009-11-17 ZY0017
			xlBook.SaveAs(savepath);   //Modified By ZY 2009-11-17 ZY0017
	    	//xlsheet.printout; //��ӡ���
	    	//xlBook.SaveAs("D:\\DHCEQReturnDetailSP"+i+".xls");   //lgl+
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
///modify by jyp 2018-08-16 Hisui���죺�޸�����csp·��
function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;  ///modify by jyp 2018-08-16 Hisui���죺�޸�����csp·��
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
function GetOutType(value)
{
	GetLookUpID("OutTypeDR",value);
}

function BodyUnLoadHandler()
{
	var encmeth=GetElementValue("KillTempGlobal");
	//cspRunServerMethod(encmeth,"ReturnDetail");
}
///modify by jyp 2018-08-16 Hisui���죺�޸�����csp·��
function BFind_Click()
{
	var val="&vData="
	val=val+GetVData();
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+val;   ///modify by jyp 2018-08-16 Hisui���죺�޸�����csp·��
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
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^EquipCatDR="+GetElementValue("EquipCatDR");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^StatCatDR="+GetElementValue("StatCatDR");
	val=val+"^ReturnNo="+GetElementValue("ReturnNo");
	val=val+"^EquipNo="+GetElementValue("EquipNo");
	val=val+"^OutTypeDR="+GetElementValue("OutTypeDR");
	val=val+"^ToDeptDR="+GetElementValue("ToDeptDR");
	val=val+"^Flag="+GetElementValue("Flag");
	val=val+"^HospitalDR="+GetElementValue("HospitalDR");   //Add By QW20210629 BUG:QW0131 Ժ��
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
	val=val+"equipcat=EquipCat="+GetElementValue("EquipCatDR")+"^";
	val=val+"statcat=StatCat="+GetElementValue("StatCatDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	val=val+"outtype=OutType="+GetElementValue("OutTypeDR")+"^";
	val=val+"hos=Hospital="+GetElementValue("HospitalDR")+"^"; //Add By QW20210629 BUG:QW0131 Ժ��
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
//Add By QW20210629 BUG:QW0131 Ժ��
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}

//czf 2022-06-06
//��ʾ�ϼ���
function creatToolbar()
{
	var currentobj=$("#t"+Component).datagrid('getRows');
	if (currentobj.length>0)
	{
		var TJob=currentobj[0]['TJob'];
		if (TJob=="")  return;
		
        //modified by ZY 20221011 �޸ĺϼ���ȡֵλ��
        //var Data = tkMakeServerCall("web.DHCEQInStockList","GetSumInfo",TJob); 
        var Data = tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalTotalInfo",'ReturnDetail','',TJob,''); 
        $("#sumTotal").html(Data);
	}
}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
