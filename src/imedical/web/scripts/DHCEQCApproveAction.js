/// -------------------------------
/// ����:ZY  2009-09-10   BugNo.:ZY0012
/// ����:��������
/// --------------------------------
var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();	//��ʼ��
	disabled(true);//�һ�
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}

function BAdd_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		alertShow(t[-1000])
		return
	}
	if (result==0)location.reload();
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		alertShow(t[-1000])
		return
	}
	if (result==0)location.reload();	
}

function BDelete_Click()
{
	var plist=CombinData(); //��������
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',plist,'1');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		alertShow(t[-1000])
		return
	}
	if (result==0)location.reload();			
}

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCApproveAction');//+����� ������������ʾ Query ����Ĳ���
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
	SetElement("Desc",list[0]);
	SetElement("ClassName",list[1]);
	SetElement("Method",list[2])
}

function disabled(value)//�һ�
{
	InitEvent();	
	DisableBElement("BAdd",!value)
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("ClassName") ;
  	combindata=combindata+"^"+GetElementValue("Method") ;
  	combindata=combindata+"^"+GetElementValue("StepRowID") ;
  	return combindata;
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Desc","");
	SetElement("ClassName","");
	SetElement("Method","");
}
function condition()//����
{
	if (CheckMustItemNull()) return true;	
	return false;
}

document.body.onload = BodyLoadHandler;
