
function BodyLoadHandler(){
	InitUserInfo();	
	initButtonWidth();	
	InitPage();
	SetBEnable();
	SetStatus();
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
	KeyUp("Loc^OutType^ToDept","N");
	Muilt_LookUp("Loc^OutType^ToDept");
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
	var val="&OutTypeDR="+OutTypeDR+"&WaitAD="+WaitAD+"&QXType="+QXType;
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
document.body.onload = BodyLoadHandler;