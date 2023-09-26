// DHCEQCLocation.js
// Mozy0034
// 2010-12-2
var SelectedRow = -1;  //hisui���죺�޸Ŀ�ʼ�к�  add by wy 2018-09-01
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler()
{
	$("body").parent().css("overflow-y","hidden");  //add by wy 2018-10-11 hiui-���� ȥ��y�� ������
	$("#tDHCEQCLocation").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //add by wy 2018-10-12 hisui���죺���ط�ҳ������
	InitUserInfo(); //ϵͳ����
	InitEvent();
	disabled(true);
	initButtonWidth();  //hisui���� add by wy 2018-09-01
	KeyUp("Equip^PurposeType^ManageLoc^ManageUser");
	Muilt_LookUp("Equip^PurposeType^ManageLoc^ManageUser^Hold1Desc^Hold2Desc");
}

function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	//Add by ZY 2015-4-9 ZY0125
	var obj=document.getElementById("Hold1Desc");
	if (obj) obj.onkeyup=Hold1Desc_KeyUp;
	var obj=document.getElementById("Hold2Desc");
	if (obj) obj.onkeyup=Hold2Desc_KeyUp;
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("Code");
  	combindata=combindata+"^"+GetElementValue("Desc");
  	combindata=combindata+"^"+GetElementValue("Type");
  	combindata=combindata+"^"+GetElementValue("Area");
  	combindata=combindata+"^"+GetElementValue("Address");
  	combindata=combindata+"^"+GetElementValue("ManageLocDR");
  	combindata=combindata+"^"+GetElementValue("ManageUserDR");
  	combindata=combindata+"^"+GetElementValue("PurposeTypeDR");
  	combindata=combindata+"^"+GetElementValue("EquipDR");
  	combindata=combindata+"^"+GetElementValue("Floor");
  	combindata=combindata+"^"+GetElementValue("DateActiveFrom");
  	combindata=combindata+"^"+GetElementValue("DateActiveTo");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	
  	return combindata;
}
function BAdd_Click() //���
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n");
	if(result=="")
	{
		alertShow("��ǰ��¼�Ѵ���,����ʧ��!");
		return
	}
	if (result>0)
	{
		alertShow("�����ɹ�!")
		location.reload();
	}	
}
function BUpdate_Click() //�޸�
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n");
	if(result=="") 
	{
		alertShow("��ǰ��¼�Ѵ���,����ʧ��!");
		return;
	}
	if (result>0)
	{
		alertShow("���³ɹ�!")
		location.reload();
	}
}
function BDelete_Click() //ɾ��
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm("ȷ��ɾ���ü�¼?");
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("ɾ���ɹ�!")
		location.reload();
	}	
}
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCLocation" +val;
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}


///hisui���죺 add by wy 2018-09-01
function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		disabled(true); 
		$('#tDHCEQCLocation').datagrid('unselectAll'); 
		return;
		}
		
	SetData(rowdata.TRowID); 
	disabled(false)  
    SelectedRow = index;
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Code","");
	SetElement("Desc","");
	SetElement("Type","");
	SetElement("Area","")
	SetElement("Address","");
	SetElement("ManageLocDR","");
	SetElement("ManageLoc","");
	SetElement("ManageUserDR","");
	SetElement("ManageUser","");
	SetElement("PurposeTypeDR","");
	SetElement("PurposeType","");
	SetElement("EquipDR","");
	SetElement("Equip","");
	SetElement("Floor","");
	SetElement("DateActiveFrom","");
	SetElement("DateActiveTo","");
	SetElement("Remark","");
	
	//Add by ZY 2015-4-27 ZY0125
	SetElement("Hold1Desc","");
	SetElement("Hold1","");
	SetElement("Hold2Desc","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}

function SetData(RowID)
{
	SetElement("RowID",RowID);  //hisui���죺RowID��ֵ add by wy  2018-09-01
	var sort=20
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',RowID);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	//messageShow("","","",gbldata)
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]);
	SetElement("Desc",list[2]);
	SetElement("Type",list[3]);
	SetElement("Area",list[4])
	SetElement("Address",list[5]);
	SetElement("ManageLocDR",list[6]);
	SetElement("ManageLoc",list[sort+1]);
	SetElement("ManageUserDR",list[7]);
	SetElement("ManageUser",list[sort+2]);
	SetElement("PurposeTypeDR",list[8]);
	SetElement("PurposeType",list[sort+3]);
	SetElement("EquipDR",list[9]);
	SetElement("Equip",list[sort+4]);
	SetElement("Floor",list[10]);
	SetElement("DateActiveFrom",list[11]);
	SetElement("DateActiveTo",list[12]);
	SetElement("Remark",list[15]);
	//Add by ZY 2015-4-27 ZY0125
	SetElement("Hold1Desc",list[sort+5]);
	SetElement("Hold1",list[16]);
	SetElement("Hold2Desc",list[sort+6]);
	SetElement("Hold2",list[17]);
	SetElement("Hold3",list[18]);
	SetElement("Hold4",list[19]);
	SetElement("Hold5",list[20]);
}

function GetPurposeType (value)
{
    GetLookUpID("PurposeTypeDR",value);
}
function GetManageUser (value)
{
    GetLookUpID("ManageUserDR",value);
}
function GetEquip(value)
{
	var list=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=list[1];
}
function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)
	DisableBElement("BAdd",!value)
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
	//Add by ZY 2015-4-27 ZY0125
function GetHospital(value)
{
	var obj=document.getElementById("Hold1");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}

function Hold1Desc_KeyUp()
{
	var obj=document.getElementById("Hold1");	
	if (obj) obj.value="";
}
function GetLocID(value)
{
	var obj=document.getElementById("Hold2");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}

function Hold2Desc_KeyUp()
{
	var obj=document.getElementById("Hold2");	
	if (obj) obj.value="";
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
