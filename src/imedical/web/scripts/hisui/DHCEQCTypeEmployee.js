/// ***************************************
/// �޸���?ZY  2009-05-20 
/// �޸�Ŀ��?������"�豸����"�ֶ���ʾ,����
/// �޸ĺ���?BFind_Click?CombinData?Clear? SetData
/// ���Ӻ���?GetEquipType
/// BugNo.?ZY0003
/// ***************************************
var SelectedRow = -1;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler()
{
	initButtonWidth();  //hisui���� add by kdf 2018-10-18
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Employee^EquipType");	//���ѡ��
	KeyUp("EmployeeType");
	disabled(true);//�һ�
	Muilt_LookUp("Employee^EquipType");
	Muilt_LookUp("EmployeeType");
}

function InitEvent() //��ʼ��
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
}

function BFind_Click()
{
	var flag = GetChkElementValue("InvalidFlag")
	if (flag==false)
	{
		flag=""
	}
	else
	{
		flag="on"
	}
	var val="&Employee="+GetElementValue("Employee");
	val=val+"&EmployeeDR="+GetElementValue("EmployeeDR");
	val=val+"&EmployeeType="+GetElementValue("EmployeeType")
	val=val+"&EmployeeTypeDR="+GetElementValue("EmployeeTypeDR")
	////Modified by ZY   2009-05-21  bdgin
	val=val+"&EquipType="+GetElementValue("EquipType")
	val=val+"&EquipTypeDR="+GetElementValue("EquipTypeDR")
	////Modified by ZY   2009-05-21 end
	val=val+"&InvalidFlag="+flag
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCTypeEmployee"+val;
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() //ɾ��
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	messageShow("","","",t["02"])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() //�޸�
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	messageShow("","","",t["03"]);
	return
	}
	if (result>0) location.reload();	
}
function BAdd_Click() //���
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t["03"])
		return
	}
	if (result>0)location.reload();	
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("EmployeeTypeDR") ;//Ա�����ͱ���
  	combindata=combindata+"^"+GetElementValue("EmployeeDR") ; //Ա������
  	var flag=GetChkElementValue("InvalidFlag")
  	if (flag==false)
  	{
	  	flag="N"
  	}
  	else
  	{
	  	flag="Y"
  	}
  	combindata=combindata+"^"+flag ; //��¼ʹ�ñ�ʶ
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע
  	////Modified by ZY   2009-05-21 
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ; //�豸����DR
  	return combindata;
}
///ѡ�����д����˷���
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)	{
		Clear();	
		disabled(true)//�һ�	
		SelectedRow=-1;
		$('#tDHCEQCTypeEmployee').datagrid('unselectAll');  //hisui���� add by kdf 2018-10-18
		SetElement("RowID","");
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID ;
		SetData(rowid);//���ú���
		disabled(false);//���һ�
		}
}

function Clear()
{
	SetElement("Rowid","");
	SetElement("Employee","");
	SetElement("EmployeeDR","")
	SetElement("EmployeeType","");
	SetElement("EmployeeTypeDR","");
	SetElement("Remark","");
	SetChkElement("InvalidFlag",0);
	////Modified by  ZY   2009-05-21 
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	var flag=list[6]
	if (flag=="Y")
	{
		flag=1
	}
	else
	{
		flag=0
	}	
	SetElement("RowID",list[0]); //rowid
	SetElement("EmployeeTypeDR",list[1]); //Ա������
	SetElement("EmployeeType",list[2]); //Ա������
	SetElement("EmployeeDR",list[3]);//Ա������
	SetElement("Employee",list[4]);//Ա���������Ա������
	SetElement("Remark",list[5]); //��ע
	SetChkElement("InvalidFlag",flag); //ͣ�ñ�ʶ
	////Modified by ZY   2009-05-21 
	SetElement("EquipType",list[8]);//�豸�������
	SetElement("EquipTypeDR",list[7]);//�豸�����������豸��������
}

function GetEmployee(value) {
	var user=value.split("^");
	var obj=document.getElementById("EmployeeDR");
	obj.value=user[1];
}
////Modified by ZY   2009-05-21  bdgin
function GetEquipType(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipTypeDR");
	obj.value=user[1];
}
////Modified by ZY   2009-05-21  end

function GetEmployeeType(value) {
	var type=value.split("^");
	var obj=document.getElementById("EmployeeTypeDR");
	obj.value=type[1];
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
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
