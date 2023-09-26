var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Equip^DeviceDesc");
	disabled(true);//�һ�
	Muilt_LookUp("Equip^DeviceDesc");
	SetElement("DeviceSource",GetElementValue("DeviceSourceDR"));
	fillData();
}

function fillData()
{
	var val="";
	val=val+"equip=Equip="+GetElementValue("EquipDR");
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
	var obj=document.getElementById("DeviceSource");
	if (obj) obj.onchange=DeviceSource_Change;
}

function DeviceSource_Change()
{
	SetElement("DeviceSourceDR",GetElementValue("DeviceSource"));
	SetElement("DeviceDesc","");
	SetElement("DeviceID","")
	
}

function BFind_Click()
{
	var val="&EquipDR="+GetElementValue("EquipDR");
	val=val+"&DeviceSourceDR="+GetElementValue("DeviceSourceDR");
	val=val+"&DeviceID="+GetElementValue("DeviceID");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDeviceMap"+val;
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
	//�����豸�����������һ�Զ�����ʾ
	var CheckEQDevResult=GetEQDevCheckFlag()
	if (CheckEQDevResult!=0) return
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
///Add By DJ 2018-04-25
///����:����豸��������������չ�ϵ,����һ�Զ��ϵʱ��ʾ
function GetEQDevCheckFlag()
{
	var encmeth=GetElementValue("CheckEQSource");
	if (encmeth=="") return;
	var DMRowID=GetElementValue("RowID")
	var DMSourceType=GetElementValue("DeviceSourceDR")
	var DMSourceID=GetElementValue("DeviceID")
	var DMEQRowID=GetElementValue("EquipDR")
	var CheckResult=cspRunServerMethod(encmeth,DMRowID,DMSourceType,DMSourceID,DMEQRowID);
	if (CheckResult=="-2001")
	{
		alertShow("�豸����������Ϊ��!")
	}
	if (CheckResult=="-2002")
	{
		alertShow("�������Ѵ��ڶ��չ�ϵ!")
	}
	if (CheckResult=="-2003")
	{
		alertShow("ͬһ�豸����������������������")
	}
	if (CheckResult=="-2004")
	{
		var truthBeTold = window.confirm("��ǰ�豸���ڴ���һ�Զ��ϵ.�Ƿ����?");
		if (truthBeTold) return 0;
		return -1
	}
	return CheckResult
}
function BAdd_Click() //���
{
	var DeviceID=GetElementValue("DeviceID");   //add by czf 386560 begin
	if(DeviceID=="")
	{
		alertShow("��������Ϊ��");
		return;
	}                                           //add by czf 386560 end
	if (condition()) return;
	//�����豸�����������һ�Զ�����ʾ
	var CheckEQDevResult=GetEQDevCheckFlag()
	if (CheckEQDevResult!=0) return
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
	combindata=combindata+"^"+GetElementValue("EquipDR") ;//�豸DR
  	combindata=combindata+"^"+GetElementValue("DeviceID") ; //����ID
  	combindata=combindata+"^"+GetElementValue("DeviceSourceDR") ; //������Դ
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע
  	combindata=combindata+"^"+GetElementValue("DeviceDesc") ; //��������

  	return combindata;
}
///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQDeviceMap');//+����� ������������ʾ Query ����Ĳ���
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
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("DeviceSource","")
	SetElement("DeviceSourceDR","");
	SetElement("DeviceID","");
	SetElement("Remark","");
	SetElement("DeviceDesc","");
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
	SetElement("DeviceSourceDR",list[2]);
	SetElement("DeviceID",list[3]);
	SetElement("Remark",list[4]);
	SetElement("DeviceDesc",list[6]);
	SetElement("Equip",list[7]);
	SetElement("DeviceSource",list[2]);
}

function GetEquip(value)
{
	var type=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=type[1];
}

function GetDeviceDesc(value)
{
	var type=value.split("^");
	var obj=document.getElementById("DeviceID");
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
