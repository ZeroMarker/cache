//��ȫ���������
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo();
	InitEvent();	
	KeyUp("Group^EquipType");	//���ѡ��
	Muilt_LookUp("Group^EquipType");
	disabled(true);//�һ�
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t[-3001])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	alertShow(t[-3001]);
	return
	}
	if (result>0) location.reload();	
}
function BAdd_Click() //����
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
		}
	if (result>0)location.reload();	
}	
	function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("GroupDR") ;//��ȫ��
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ; // �豸����
  	return combindata;
}
///ѡ�����д����˷���
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCGroupEquipType');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	//alertShow("selectrow"+selectrow)
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
	SetElement("Group",""); 
	SetElement("EquipType","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Group",list[2]); //
	SetElement("GroupDR",list[1]);//
	//alertShow("list[2]"+list[2])
	SetElement("EquipType",list[4]); //
	SetElement("EquipTypeDR",list[3]); //
}
function GroupDR(value) // ��ȫ��
{
	//alertShow(value);
	var obj=document.getElementById("GroupDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]+"/"+val[2]);
}
function EquipTypeDR(value) // �豸����
{
	//alertShow(value);
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]+"/"+val[2]);
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
	/*
	if (CheckItemNull(1,"Group")) return true;
	if (CheckItemNull(1,"EquipType")) return true;
	*/
	return false;
}
document.body.onload = BodyLoadHandler;