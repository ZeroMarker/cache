
function BodyLoadHandler(){
	InitUserInfo();	
	initPanelHeaderStyle(); //added by LMH 20230201 UI����
	//showBtnIcon("BFind^BAddNew",false); //added by LMH UI���춯̬��ʾ��رհ�ťͼ��  //modified by LMH 20230302 ȥ��
	//initButtonWidth();	//modified by LMH 20230302 UI
	initButtonColor();
	InitPage();
	SetBEnable();
	SetStatus();
	/// Modfied by zc0126 2022-12-26 2162208 ״̬�̶� begin
	var CancelOper=GetElementValue("CancelOper")
	if (CancelOper=="Y")
	{
		SetElement("Status",2)
		DisableBElement("Status",true);
	}
	/// Modfied by zc0126 2022-12-26 2162208 ״̬�̶� end
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	//messageShow("","","",document.title);
	//document.title="-adsfa"
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("Loc^OutType^ToDept^Hospital","N"); //���ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	Muilt_LookUp("Loc^OutType^ToDept^Hospital");  //�س�ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	//Add By QW20210629 BUG:QW0131 Ժ�� begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 Ժ�� end
}
function LocDR(value)
{
	GetLookUpID("LocDR",value);
}

function GetToDept(value)
{
	GetLookUpID("ToDeptDR",value);
}

function GetOutType(value)
{
	GetLookUpID("OutTypeDR",value);
}

function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
	else
	{
		var obj=document.getElementById("BAddNew");//GR0026 ����������´��ڴ�ģ̬����
		if (obj) obj.onclick=BAddNew_Click;
	}
}
//////////
// add by JYP 2018-08-09 hisui����
function BFind_Click()
{
	$("#DHCEQReturnFind").datagrid("load");
	$("#DHCEQOutStockFind").datagrid("load");
   return ;	
}
///modified by ZY0227 20200508
///modified by jyp 201810301 ZY0170
function BAddNew_Click()
{
	var OutTypeDR=GetElementValue("OutTypeDR");
	var WaitAD=GetElementValue("WaitAD");
	var QXType=GetElementValue("QXType");
	var val="&ROutTypeDR="+OutTypeDR+"&WaitAD="+WaitAD+"&QXType="+QXType;		//czf 2021-01-26 1750655
	if(OutTypeDR=="1")
	{
		url="dhceq.em.return.csp?"+val
		title="�豸�˻���"
	}
	else
	{
		url="dhceq.em.outstock.csp?"+val
		title="�豸���ٵ�"
	}
	showWindow(url,title,"","","icon-w-paper","modal","","","large");	  //modify by lmm 2020-06-04 UI
}

//Add By QW20210629 BUG:QW0131 Ժ��
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}
document.body.onload = BodyLoadHandler;
