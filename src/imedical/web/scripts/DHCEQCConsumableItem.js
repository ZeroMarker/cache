var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Unit");
	disabled(true);//�һ�
	Muilt_LookUp("Unit");
	SetElement("ExType",GetElementValue("ExTypeDR"));
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
	var obj=document.getElementById("ExType");
	if (obj) obj.onchange=ExType_Change;
}

function ExType_Change()
{
	SetElement("ExTypeDR",GetElementValue("ExType"));
	SetElement("ExID","")
}

function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&ExTypeDR="+GetElementValue("ExTypeDR");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCConsumableItem"+val;
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
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("��������չID!")
	  	return
  	}
  	if (CheckInvalidData()) return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		alertShow(t["03"]);
		return
	}
	if (result>0) 
	{
		//add by HHM 20150910 HHM0013
		//��Ӳ����ɹ��Ƿ���ʾ
		ShowMessage();
		//****************************
		location.reload();	
	}
}
function BAdd_Click() //���
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("��������չID!")
	  	return
  	}
  	if (CheckInvalidData()) return;
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
	combindata=combindata+"^"+GetElementValue("Desc") ;//����
  	combindata=combindata+"^"+GetElementValue("Code") ; //����
  	combindata=combindata+"^"+GetElementValue("Price") ; //����
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //��λ
  	combindata=combindata+"^"+GetElementValue("ExTypeDR") ; //��չ����
  	combindata=combindata+"^"+GetElementValue("ExID") ; //��չID
	combindata=combindata+"^"+GetElementValue("ExDesc") ; //��չDesc
	combindata=combindata+"^"+GetElementValue("PayPrice") ; //�ۼ�

  	return combindata;
}
///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCConsumableItem');//+����� ������������ʾ Query ����Ĳ���
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
	SetElement("Code","");
	SetElement("Desc","");
	SetElement("Price","")
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("ExType","");
	SetElement("ExTypeDR","");
	SetElement("ExID","");
	SetElement("ExDesc","");
	SetElement("PayPrice","")
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Desc",list[1]);
	SetElement("Code",list[2]);
	SetElement("UnitDR",list[4])
	SetElement("Price",list[3]);
	SetElement("ExTypeDR",list[5]);
	SetElement("ExID",list[6]);
	SetElement("ExDesc",list[8]);
	SetElement("Unit",list[13]);
	SetElement("ExType",list[5]);
	SetElement("PayPrice",list[9]);
}

function GetUnit(value) {
	var type=value.split("^");
	var obj=document.getElementById("UnitDR");
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
//Mozy0049	2011-3-30
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("Price"),1,1,0,1)==0)
	{
		alertShow("�����쳣,������.");
		//SetElement("Price","");
		return true;
	}
	return false;
}
//add by ZY  20140915 ZY0117
function GetIncItmInfo(value)
{
	var list=value.split("^");
	SetElement("Desc",list[0]);
	SetElement("Code",list[1]);
	SetElement("UnitDR",list[2])
	SetElement("Unit",list[3]);
	SetElement("Price",list[4]);
	SetElement("ExType",list[5]);
	SetElement("ExID",list[6]);
	SetElement("ExDesc",list[7]);
	SetElement("ExTypeDR",list[5]);
	
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
