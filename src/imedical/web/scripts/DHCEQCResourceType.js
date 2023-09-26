var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Unit");
	disabled(true);//�һ�
	Muilt_LookUp("Unit");
	SetElement("Type",GetElementValue("TypeDR"));
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
	var obj=document.getElementById("Type");
	if (obj) obj.onchange=Type_Change;
}

function Type_Change()
{
	SetElement("TypeDR",GetElementValue("Type"));
}

function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&TypeDR="+GetElementValue("TypeDR");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCResourceType"+val;
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
	combindata=combindata+"^"+GetElementValue("Code") ;//����
  	combindata=combindata+"^"+GetElementValue("Desc") ; //����
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע
  	combindata=combindata+"^"+GetElementValue("Type") ; //����
  	combindata=combindata+"^"+GetElementValue("Price") ; //����
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //��λ

  	return combindata;
}
///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCResourceType');//+����� ������������ʾ Query ����Ĳ���
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
	SetElement("RowID","");// 263661 Add by BRB 2016-10-08
	SetElement("Code","");
	SetElement("Desc","");
	SetElement("Price","")
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("Type","");
	SetElement("Remark","");
	SetElement("TypeDR","");
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]);
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3])
	SetElement("Type",list[5]);
	SetElement("Price",list[6]);
	SetElement("UnitDR",list[7]);
	SetElement("Unit",list[10]);//263661 Modify by BRB 2016-10-08
	SetElement("TypeDR",list[5]);
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
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
