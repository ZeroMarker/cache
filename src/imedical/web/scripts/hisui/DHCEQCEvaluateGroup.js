//�豸����
var SelectedRow = -1; //hisui���� add by kdf 2018-10-17
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
    initButtonWidth()  //hisui���� add by kdf 2018-10-17 ��ť��ʽ�޸�
	InitEvent();	
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

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	return combindata;
}

function BAdd_Click()
{
	BUpdate_Click() 
}

function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,"");
	if(result=="") 
	{
		messageShow("","","",t[-3001]);
		return
	}
	if (result>0)
	{
		messageShow("","","",t[0]);
		location.reload();
	}	
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		messageShow("","","",t[0]);
		location.reload();	
	}
}
///ѡ�����д����˷���
///modify by by kdf 2018-10-17
///������hisui���� ����ֵ��ȡ��ʽ ��������
///��Σ�index �к�
///      rowdata ��json����
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)	
	{
		Clear(); //add By  20150825  HHM00005
		disabled(true);//�һ�	
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		$('#tDHCEQCEvaluateGroup').datagrid('unselectAll');  
	}
	else
	{
		SelectedRow=index;
		//rowid=GetElementValue("TRowIDz"+SelectedRow);
		rowid=rowdata.TRowID;
		
		SetData(rowid);//���ú���
		disabled(false);//���һ�
	}
}

//add By 20150824 HHM0005
//���ѡ������
function Clear()
{
	SetElement("Code","");
	SetElement("Desc","")
	SetElement("Remark","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("Code",list[1]); 
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	
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
document.body.onload = BodyLoadHandler;
