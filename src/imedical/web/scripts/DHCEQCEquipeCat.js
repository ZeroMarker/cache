//modified by GR 2014-09-24 
//ȱ�ݺ�3037 ȡ��ѡ�񣬽����·�������Ϣδ���
//ȱ�ݺ�3038 ȡ��ѡ����ٴ�ѡ�������¼�������·�δ��ʾ������¼��Ϣ
//�޸�λ��SelectRowHandler()
//---------------------------------------------------------------------------------------
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	KeyUp("ParCat^SpecialType^DepreMethod","N"); //2009-08-12 ���� DJ0025
	Muilt_LookUp("ParCat^SpecialType^DepreMethod"); //2009-08-12 ���� DJ0025
	SetElement("YearsNum",GetElementValue("ParYeasNum"));
	SetElement("Remark",GetElementValue("ParRemark"));
}
function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BAdd_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;	
}
//�����������������,�������ƹ̶�
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQCEquipeCat'); //�õ����   t+�������
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //��ǰѡ����
	/*
	var obj=document.getElementById('RowID');
	var obj1=document.getElementById('Code');
	var obj2=document.getElementById('Desc');
	var obj3=document.getElementById('ParCatDR');
	var obj4=document.getElementById('ParCat');
	var obj5=document.getElementById('Remark');
	var obj6=document.getElementById('SpecialTypeDR');
	var obj7=document.getElementById('SpecialType');
	var obj8=document.getElementById('YearsNum');
	*/
	if (selectrow==SelectedRow){
		/*
		obj.value='';
		obj1.value='';
		obj2.value='';
		obj3.value='';//
		obj4.value='';//
		obj5.value='';
		obj6.value='';
		obj7.value='';
		obj8.value='';
		*/
		SetElement("Code",""); //modified by GR 2014-09-24 begin ȱ�ݺ�3037 3038
		SetElement("Desc","");
		//SetElement("ParCatDR","");
		//SetElement("ParCat","");
		SetElement("Remark","");
		SetElement("SpecialTypeDR","");
		SetElement("SpecialType","");
		SetElement("YearsNum","");
		SetChkElement("EquipNoFlag","");
		SetElement("DepreMethodDR",""); 
		SetElement("DepreMethod","");
		SetElement("Hold2","");
		SetElement("ExtendCode","");//modified by GR 2014-09-24 end ȱ�ݺ�3037 3038
		SetElement("RowID","");
		
		SelectedRow=0;
		ChangeStatus(false);
		return;}
	ChangeStatus(true);
	FillData(selectrow)
    SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	SetElement("Code",list[0]);
	SetElement("Desc",list[1]);
	SetElement("ParCatDR",list[2]);
	SetElement("ParCat",list[3]);
	SetElement("Remark",list[4]);
	SetElement("SpecialTypeDR",list[5]);
	SetElement("SpecialType",list[6]);
	SetElement("YearsNum",list[7]);
	SetChkElement("EquipNoFlag",list[8]);
	SetElement("DepreMethodDR",list[9]); //2009-08-12 ���� begin DJ0025
	SetElement("DepreMethod",list[10]);
	SetElement("Hold2",list[11]);
	SetElement("ExtendCode",list[12]); //2009-08-12 ���� end
}
//������ť�������
function BAdd_click()
{	
	if (CheckNull()) return;
	var Return=UpdateData("0");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		alertShow("�����ɹ�!")
		parent.frames["DHCEQCEquipCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		window.location.reload();
	}
	
}
//���°�ť�������
function BUpdate_click()
{
	if (CheckNull()) return;
	var Return=UpdateData("1");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		alertShow("�����ɹ�!")
		parent.frames["DHCEQCEquipCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		window.location.reload();
	}
}
//ɾ����ť�������
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	
	var Return=UpdateData("2");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		alertShow("ɾ���ɹ�!")
		parent.frames["DHCEQCEquipCatTree"].ReloadNode(GetElementValue("ParCatDR"));
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(2,"Desc")) return true;
	return false;
}
function UpdateData(AppType)
{
	var encmeth=GetElementValue("upd");
	var RowID=GetElementValue("RowID");
	var Code=GetElementValue("Code");
	var Desc=GetElementValue("Desc");
	var ParCat=GetElementValue("ParCatDR");
	var Remark=GetElementValue("Remark");
	var SpecialType=GetElementValue("SpecialTypeDR");
	var YearsNum=GetElementValue("YearsNum")
	var EquipNoFlag=GetChkElementValue("EquipNoFlag");
	var DepreMethod=GetElementValue("DepreMethodDR"); //2009-08-12 ���� begin DJ0025
	var Hold2=GetElementValue("Hold2");
	var ExtendCode=GetElementValue("ExtendCode");
	var Return=cspRunServerMethod(encmeth,"","",AppType,RowID,Code,Desc,ParCat,Remark,SpecialType,YearsNum,EquipNoFlag,DepreMethod,Hold2,ExtendCode); //2009-08-12 ���� end DJ0025
	return Return;
} 
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}
function GetSpecialType(value)
{
    GetLookUpID("SpecialTypeDR",value);
}
function GetDepreMethodID(value) //2009-08-12 ���� DJ0025
{
	GetLookUpID("DepreMethodDR",value);
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
