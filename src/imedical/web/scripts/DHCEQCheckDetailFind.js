///Created By HZY 2011-08-03 . HZY0004 
///Description:�豸������ϸ��ѯ
/// -------------------------------
function BodyLoadHandler()
{
	SetElement("ProviderCHeck",GetElementValue("ProviderCHeckID"));//Add By QW-2014-10-20
	InitPage();
	SetStatus();
	KeyUp("StoreLoc^EquipType^EquipCat^StatCat^Provider^Model^UseLoc^Hospital^MakeUser","N"); //Modied By QW20210629 BUG:QW0131 Ժ��
	Muilt_LookUp("StoreLoc^EquipType^EquipCat^StatCat^Provider^Model^UseLoc^Hospital^MakeUser","N"); //Modied By QW20210629 BUG:QW0131 Ժ��
	fillData();
	//RefreshData();	
	HiddenTableIcon("DHCEQCheckDetailFind","TRowID","TOpenCheckRequest");   //add by czf ����ţ�348761
	initButtonWidth()  //hisui���� add by czf 20180929
	$('#tDHCEQCheckDetailFind').datagrid('options').view.onAfterRender = ReLoadGrid;
	initButtonColor();//cjc 2023-01-18 ���ü��������ť��ɫ
	initPanelHeaderStyle();//cjc 2023-01-17 ��ʼ�����������ʽ
}

function ReLoadGrid()
{
	creatToolbar();
	fixTGrid();
}

function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"))
}

function InitPage()
{
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

///Modified By HZY 2012-04-20
///Desc:�������µ�ͨ�ô�ӡ����(����'����������'ʱʹ��):PrintDHCEQEquipNew .
function BPrint_Click()
{
	//modify by lmm 2020-02-25 LMM0060
	var objtbl=$("#tDHCEQCheckDetailFind").datagrid('getRows');
	var rows=objtbl.length;
	var TJob=objtbl[1].TJob 
	if (TJob=="")  return;
	//Modefied by zc0093  ��Ǭ�����޸� 2021-01-07 begin
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		// MZY0114	2446191		2022-01-27
		if (!CheckColset("OpenCheckList"))
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQOpenCheckExport.raq&CurTableName=OpenCheckList&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		PrintDHCEQEquipNew("OpenCheckList",1,TJob,GetElementValue("vData"),"CheckDetail");
	}
	return;
	//Modefied by zc0093  ��Ǭ�����޸� 2021-01-07 end
	
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
	
	var PageRows=43 	//ÿҳ�̶�����
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) 	//��ҳ��-1  
	var ModRows=TotalRows%PageRows 		//���һҳ����
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
			xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,6)="�Ʊ���:"
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
		messageShow("","","",e.message);
	}
	*/
} 

function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")		//�豸������
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
	val=val+"&QXType="+GetElementValue("QXType")
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCheckDetailFind"+val;
}

function GetVData()
{
	var	val="^Type="+GetElementValue("Type");
	val=val+"^StoreLocDR="+GetElementValue("StoreLocDR");				//�豸�ⷿ
	val=val+"^Status="+GetElementValue("Status");		//״̬
	val=val+"^ModelDR="+GetElementValue("ModelDR");			//����
	//val=val+"^InvoiceNos="+GetElementValue("InvoiceNos");	//��Ʊ��
	val=val+"^MinPrice="+GetElementValue("MinPrice");
	val=val+"^MaxPrice="+GetElementValue("MaxPrice");
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");	//��Ӧ��
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^EquipCatDR="+GetElementValue("EquipCatDR");	//�豸����
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");	//�豸����
	val=val+"^StatCatDR="+GetElementValue("StatCatDR");		//�豸����
	val=val+"^RequestNo="+GetElementValue("RequestNo");
	val=val+"^FileNo="+GetElementValue("FileNo");       //�������
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");   //ʹ�ÿ���
	//Add By QW-2014-10-20 ��Ӧ��ģ����ѯ
	val=val+"^ProviderQuery="+GetElementValue("ProviderQuery");   //���ӹ�Ӧ��ģ����ѯ
	val=val+"^ProviderCHeck="+GetElementValue("ProviderCHeck");   //ģ����ѯ����
	//End By QW-2014-10-20
	val=val+"^EquipNo="+GetElementValue("EquipNo");    //Modify By QW0004-2015-01-02 �豸���
	//val=val+"^ManuFactoryDR="+GetElementValue("ManuFactoryDR");	//������
	val=val+"^HospitalDR="+GetElementValue("HospitalDR"); //Add By QW20210629 BUG:QW0131 Ժ��
	val=val+"^MakeUserDR="+GetElementValue("MakeUserDR");
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");
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
	val=val+"hos=Hospital="+GetElementValue("HospitalDR")+"^"; //Add By QW20210629 BUG:QW0131 Ժ��
	val=val+"user=MakeUser="+GetElementValue("MakeUserDR")+"^";
	val=val+"dept=UseLoc="+GetElementValue("UseLocDR")+"^";
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
//Add By QW20210629 BUG:QW0131 Ժ��
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}

//czf 2022-06-06
//��ʾ�ϼ���
function creatToolbar()
{
	var currentobj=$("#tDHCEQCheckDetailFind").datagrid('getRows');
	if (currentobj.length>0)
	{
		var TJob=currentobj[0]['TJob'];
		if (TJob=="")  return;
        //modified by ZY 20221011 �޸ĺϼ���ȡֵλ��
        //var Data = tkMakeServerCall("web.DHCEQOpenCheckRequest","GetSumInfo",TJob); 
        var Data = tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalTotalInfo",'CheckDetail','',TJob,''); 
		$("#sumTotal").html(Data);
	} 
}

function GetMakeUser(value)
{
	var user=value.split("^");
	var obj=document.getElementById("MakeUserDR");
	obj.value=user[1];
}

function GetUseLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("UseLocDR");
	obj.value=user[1];
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
