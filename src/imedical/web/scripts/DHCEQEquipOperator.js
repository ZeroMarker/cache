var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Equip^User");
	disabled(true);//�һ�
	Muilt_LookUp("Equip^User");
	fillData();
}

function fillData()
{
	var val="";
	val=val+"equip=Equip="+GetElementValue("EquipDR")+"^";
	val=val+"user=User="+GetElementValue("UserDR");
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
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
	var val="&EquipDR="+GetElementValue("EquipDR");
	val=val+"&UserDR="+GetElementValue("UserDR");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipOperator"+val;
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
	alertShow(t["02"])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() //�޸�
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		alertShow(t["03"]);
		return
	}
	if (result>0) location.reload();	
}
function BAdd_Click() //���
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t["03"])
		return
	}
	if (result>0)location.reload();	
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("EquipDR") ;//����
  	combindata=combindata+"^"+GetElementValue("UserDR") ; //����
  	combindata=combindata+"^"+GetElementValue("Percent") ; //����
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��λ
  	combindata=combindata+"^"+GetElementValue("FromDate") ; //��չ����
  	combindata=combindata+"^"+GetElementValue("ToDate") ; //��չID
  	return combindata;
}
///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQEquipOperator');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();	
		disabled(true)//�һ�	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		disabled(false)//���һ�
		}
}

function Clear()
{
	SetElement("EquipDR","");
	SetElement("Equip","");
	SetElement("User","")
	SetElement("UserDR","");
	SetElement("Percent","");
	SetElement("Remark","");
	SetElement("FromDate","");
	SetElement("ToDate","");
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("EquipDR",list[1]);
	SetElement("UserDR",list[2]);
	SetElement("Percent",list[3])
	SetElement("Remark",list[4]);
	SetElement("FromDate",list[5]);
	SetElement("ToDate",list[6]);
	SetElement("Equip",list[7]);
	SetElement("User",list[8]);
}

function GetEquip(value) {
	var type=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=type[1];
}

function GetUser(value) {
	var type=value.split("^");
	var obj=document.getElementById("UserDR");
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
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("Percent"),1,1,0,1)==0)
	{
		alertShow("ռ��(%)�����쳣,������.");
		//SetElement("Price","");
		return true;
	}
	
	return false;
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
