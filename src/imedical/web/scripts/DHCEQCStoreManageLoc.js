/// -------------------------------
/// ����:ZY  2010-07-26  BugNo.ZY0025
/// ����:�����������ϸ
/// --------------------------------
var SelectedRow = 0;
function BodyLoadHandler()
{
	document.body.scroll="no";
	ID=GetElementValue("ID");
	InitUserInfo();
	InitEvent();
	KeyUp("Loc");
	//Muilt_LookUp("Loc");   //modified by kdf 2018-03-05 ����ţ�548421
	disabled(true);
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}

function BAdd_Click() //2010-07-01 ���� begin
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist);
	var rtn=result.replace(/\\n/g,"\n")
	result=rtn.split("^")
	if(result[0]=="")
	{
		alertShow(result[1])
		return
	}
	if (result[0]>0)
	{
		alertShow("�����ɹ�!")
		location.reload();
	}
	else
	{
		alertShow("����ʧ��!")
	}
}

function BUpdate_Click() //2010-07-01 ����
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist);
	var rtn=result.replace(/\\n/g,"\n")
	result=rtn.split("^")
	if(result[0]=="")
	{
		alertShow(result[1])
		return
	}
	if (result[0]>0)
	{
		alertShow("���³ɹ�!")
		location.reload();
	}
	else
	{
		alertShow("����ʧ��!")
	}
}

function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("ɾ���ɹ�!")
		location.reload();
	}
}

function BFind_Click()
{
	var val="&ID="+GetElementValue("ID");
	val=val+"&LocDR="+GetElementValue("LocDR");
	val=val+"&Loc="+GetElementValue("Loc");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCStoreManageLoc"+val;
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCStoreManageLoc');//+����� ������������ʾ Query ����Ĳ���
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

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	SetElement("StoreLocDR",list[0]); //����
	SetElement("StoreLoc",list[9]); //����
	SetElement("LocDR",list[1]); //����
	SetElement("Loc",list[10]); //����
	SetElement("Remark",list[2]); //��ע
	SetElement("Hold1",list[3]); //
	SetElement("Hold2",list[4]); //
	SetElement("Hold3",list[5]); //
	SetElement("Hold4",list[6]); //
	SetElement("Hold5",list[7]); //
}

function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Loc","");
	SetElement("LocDR","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("ID") ;//��������
  	combindata=combindata+"^"+GetElementValue("LocDR") ; //����
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	combindata=combindata+"^"+GetElementValue("Hold4") ; //
  	combindata=combindata+"^"+GetElementValue("Hold5") ; //
  	return combindata;
}

function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}

function condition()//����
{
	if (CheckMustItemNull()) return true;	
	return false;
}

document.body.onload = BodyLoadHandler;
