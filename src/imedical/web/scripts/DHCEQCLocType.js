/// -------------------------------
/// ����:ZY  2009-07-06  BugNo.ZY0004
/// ����:������������
/// --------------------------------
var SelectedRow = 0;
var rowid=0;
var LocTypeStr="";	
var IDStr="";
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler()
{
	//document.body.scroll="no";	//2013-11-11 Mozy0112 �ָ�������
	LocTypeStr=GetElementValue("LocType");
	IDStr=GetElementValue("ID");
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Loc");	//���ѡ��
	disabled(true);//�һ�
	Muilt_LookUp("Loc");
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

function BAdd_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	var rtn=result.replace(/\\n/g,"\n")
	result=rtn.split("^")
	if(result[0]=="")
	{
		if (result[1]!="")
		{
			alertShow("����!["+result[1]+"]���Ѿ����ڸÿ��Ҽ�¼!����ʧ��!")
			return
		}
		alertShow(t[1])
		return
		}
	if (result[0]>0)
	{
		alertShow("�����ɹ�!")
		location.reload();
	}	
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	var rtn=result.replace(/\\n/g,"\n")
	result=rtn.split("^")
	if(result[0]=="") 
	{
		if (result[1]!="")
		{
			alertShow("����!["+result[1]+"]���Ѿ����ڸÿ��Ҽ�¼!����ʧ��!")
			return
		}
	alertShow(t[2]);
	return
	}
	if (result[0]>0)
	{
		alertShow("���³ɹ�!")
		location.reload();
	}	
}

function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t[3])
	return;
	}
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
	var val="&ID="+GetElementValue("ID");
	val=val+"&LocDR="+GetElementValue("LocDR");
	val=val+"&FromDate="+GetElementValue("FromDate")
	val=val+"&ToDate="+GetElementValue("ToDate")
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCLocType"+val;
}

function BClear_Click() 
{
	Clear();
	//location.reload();  //Modify by zc 2014-09-05 zc0004
	disabled(true);
}

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCLocType');//+����� ������������ʾ Query ����Ĳ���
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
	SetElement("RowID",list[0]); //rowid
	SetElement("LocType",list[1]); //��������
	SetElement("Loc",list[2]); //����
	SetElement("LocDR",list[3]); //����id	
	SetElement("FromDate",list[4]);//��ʼʱ��
	SetElement("ToDate",list[5]); //����ʱ��
	SetElement("Remark",list[6]); //��ע
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
	//SetElement("ID","");
	SetElement("Loc","");
	SetElement("LocDR","");
	SetElement("FromDate","");
	SetElement("ToDate","")
	SetElement("Remark","");
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("ID") ;//��������
  	combindata=combindata+"^"+GetElementValue("LocDR") ; //����
  	combindata=combindata+"^"+GetElementValue("FromDate") ; //��ʼʱ��
  	combindata=combindata+"^"+GetElementValue("ToDate") ; //����ʱ�䰴
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע
  	return combindata;
}

function GetLoc(value)
{
	var obj=document.getElementById("LocDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}

function condition()//����
{
	if (CheckMustItemNull()) return true;	
	return false;
}

document.body.onload = BodyLoadHandler;
