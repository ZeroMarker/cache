function BodyLoadHandler(){
	InitUserInfo();		
	InitPage();
	SetBEnable();
	SetStatus();
	Muilt_LookUp("BuyLoc^Loc^Hospital"); //�س�ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	
	var CancelOper=GetElementValue("CancelOper")
	if (CancelOper=="Y")
	{
		SetElement("Status",2)
		DisableBElement("Status",true);
	}
	//initButtonWidth()  //hisui���� add by zy 2018-10-31
	initPanelHeaderStyle();	//czf ��ʼ��������������ʽ 2023-01-11
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("Loc^BuyLoc^Hospital"); //���ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	//Add By QW20210629 BUG:QW0131 Ժ�� begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 Ժ�� end
}
function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}

function GetBuyLoc(value)
{
	GetLookUpID("BuyLocDR",value);
}

//modified by czf 2017-03-23
//��������˽���������ťͼ��ɵ㿪�´��ڵ�����
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

///modified by zy 20180930  ZY0170
function BAddNew_Click() //GR0026 ����������´��ڴ�ģ̬����
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD"); 
	var QXType=GetElementValue("QXType");
	var flag=GetElementValue("flag");
	var val="&Status="+Status+"&WaitAD="+WaitAD+"&QXType="+QXType+"&flag="+flag;
	//url="dhceqinstocknew.csp?&DHCEQMWindow=1"+val
	url="dhceq.em.instock.csp?"+val
	///modefied by zy 20190111 ZY0184
	//websys_lu(url,false,'width=1080,height=650,left=130,top=3,hisui=true')
	//SetWindowSize(url,1,'','','','','��ⵥ');
	
	showWindow(url,"��ⵥ","","","icon-w-paper","modal","","","large")	//modified by lmm 2020-06-04 UI
	
}

//Add By QW20210629 BUG:QW0131 Ժ��
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}
document.body.onload = BodyLoadHandler;
