// DHCEQCServiceDetails.js
var SelectedRow = -1; ///Modify By QW 2018-10-08 HISUI����
var SelectRow = 0;
var rowid=0;
var rows;

function BodyLoadHandler()
{
	initButtonWidth();///Add By QW 2018-10-10 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-10-10 HISUI����:��ť���ֹ淶
	InitUserInfo();
	InitButton(false);
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=Clear;
	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
}

function BAdd_Click()
{
	if (CheckSaveData()) return;
	SaveData(0);
}

function BUpdate_Click() 
{
	if (CheckSaveData()) return;
	SaveData(0);
}

function BDelete_Click() 
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t[-4003],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		messageShow("","","",t['04']);
		return;
	}
    SaveData(1);
}

function BClose_Click()
{
	window.close();
}
///Add By QW 2018-10-10 hisui�����������
function BFind_Click()
{
	var val="&ServiceItem="+GetElementValue("ServiceItem");
	val=val+"&ServDetItem="+GetElementValue("ServDetItem");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCServiceDetails"+val;
}

///ѡ�����д����˷���
//Modify By QW 2018-10-10 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		InitButton(false);	//�һ�
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQCServiceDetails').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//���ú���
	InitButton(true);
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var sort=5
	var list=gbldata.split("^");
	//messageShow("","","",gbldata);
	SetElement("RowID",list[0]); //rowid
	SetElement("ServiceItemDR",list[1]);
	SetElement("ServiceItem",list[sort+1]);
	SetElement("ServDetItemDR",list[2]);
	SetElement("ServDetItem",list[sort+2]);
	SetElement("Quantity",list[3]);
	SetElement("Remark",list[4]);
}
function SaveData(isDel)
{
	var encmeth=GetElementValue("GetUpdate");
	var plist=CombinData();	
	//messageShow("","","",plist);
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',plist,isDel);
	if (result>0)
	{	location.reload();	}
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("ServiceItemDR");
  	combindata=combindata+"^"+GetElementValue("ServDetItemDR");
  	combindata=combindata+"^"+GetElementValue("Quantity");
  	combindata=combindata+"^"+GetElementValue("Remark");
	
  	return combindata;
}
function Clear()
{
	SetElement("RowID","");
	SetElement("ServiceItemDR","");
	SetElement("ServiceItem","");
	SetElement("ServDetItemDR","");
	SetElement("ServDetItem","");
	SetElement("Quantity","");
	SetElement("Remark","");
	InitButton(false);
}
function GetServiceItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ServiceItemDR");
	obj.value=type[1];
}
function GetServDetItem(value)
{
	//messageShow("","","",value);
	var type=value.split("^");
	var obj=document.getElementById("ServDetItemDR");
	obj.value=type[1];
}
function CheckSaveData()
{
	if (CheckMustItemNull()) return true;

	//if (GetElementValue("ServiceItemDR")=="") return true;
	//if (GetElementValue("ServDetItemDR")=="") return true;
	//Mozy0049	2011-3-30
	if (IsValidateNumber(GetElementValue("Quantity"),1,0,0,1)==0)
	{
		alertShow("�����쳣,������.");
		//SetElement("Quantity","");
		return true;
	}
	return false;
}
document.body.onload = BodyLoadHandler;