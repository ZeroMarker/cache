
/// -------------------------------
/// �޸�:ZY  2009-07-06  BugNo.ZY0007
/// �޸�����:���Ӻ���MovType
/// ��������:�޸��豸ת�����͵�ʱ��?���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// --------------------------------
///modify by jyp 2018-08-16 Hisui���죺���initButtonWidth()�������ư�ť���ȣ�BFind�󶨵���¼�
function BodyLoadHandler(){
	initButtonWidth(); //add by jyp 2018-08-16
	InitUserInfo();	
	InitPage();	
	SetBEnable();
	SetStatus();
	SetElement("MoveType",GetElementValue("MoveTypeID"))
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	
	// add by ZX 2018-11-03 hisui����
	var obj=document.getElementById("BAddNew");
	if (obj) obj.onclick=BAdd_Clicked;
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("FromLoc^ToLoc");
	Muilt_LookUp("FromLoc^ToLoc");
	///zy 2009-07-15 BugNo.ZY0007
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;
	////////////////////

}
function GetFromLoc(value)
{
	GetLookUpID("FromLocDR",value);
}
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
}
/// ����:zy 2009-07-15 BugNo.ZY0007
/// ��������?MoveType
/// ����:�޸��豸ת�����͵�ʱ��?���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// -------------------------------
function MoveType()
{
	var value=GetElementValue("MoveType")
	if (value=="0")
	{
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0102");
	}else if (value=="3")
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0101");
	}else
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0102");
	}
}
//////////
// add by JYP 2018-08-09 hisui����
function BFind_Click()
{
	$("#DHCEQStoreMoveFind").datagrid("load");
   return ;	
}

// add by ZX 2018-11-03 hisui����
//modified by csj 2020-03-23 ����ţ�1217727
function BAdd_Clicked()
{
	if (!$(this).linkbutton('options').disabled){	
		var val="&RowID=&QXType=&WaitAD=off";
		url="dhceq.em.storemove.csp?"+val;
		showWindow(url,"ת�����뵥","","","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-04 UI
	}
}
document.body.onload = BodyLoadHandler;