
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("UseLoc^MasterItem^EquipType^StatCat^EquipCat");	//���ѡ��	
	Muilt_LookUp("UseLoc^MasterItem^EquipType^StatCat^EquipCat");
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
}

function BClear_Click() //��հ�ť
{
	SetElement("MasterItem","");  
	SetElement("MasterItemDR","");
	SetElement("MinValue","");
	SetElement("MaxValue","");
	SetElement("StatCat","");
	SetElement("StatCatDR","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("BeginInStockDate","");
	SetElement("EndInStockDate","");
	SetElement("UseLoc","");
	SetElement("UseLocDR","");
	SetElement("EquipCat","");
	SetElement("EquipCatDR","");
	SetElement("IncludeFlag","");
}
///ȡ���豸��rowid
function GetMasterItem(value)
{
	GetLookUpID("MasterItemDR",value);
}
///ȡ���豸����rowid
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
///ȡ���豸����rowid
function GetStatCat(value) 
{
	GetLookUpID("StatCatDR",value);
}
function GetEquipCat(value)
{
	GetLookUpID("EquipCatDR",value);
}
///ȡ���豸ʹ�ÿ���rowid
function GetUseLoc(value)
{
	GetLookUpID("UseLocDR",value);
}
function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
