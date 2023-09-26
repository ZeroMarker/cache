///--------------------------------------------
///Created By ZC 2014-8-15 ZC0001
///Description:��ά������˵�������ά�������Ӳ˵�?ʵ�ֶ�ά��������Ϣ�Ĺ���?
///--------------------------------------------

var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{		
    InitUserInfo(); //ϵͳ����
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
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;	
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Code") ;//
  	combindata=combindata+"^"+GetElementValue("Desc") ; //
   	combindata=combindata+"^"+GetElementValue("Remark") ; //
 	//combindata=combindata+"^"+GetElementValue("InvalidFlag") ; //
  	combindata=combindata+"^"+GetElementValue("Type") ; //    	
  	return combindata;
}

function BAdd_Click() 
{	
	if (condition()) return;	
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var list=plist.split("^");
    var code=list[1];
    if(code=="") return;
    
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("�����ɹ�!") 
		location.reload();
		return;
	}
	else
	{
		alertShow(t[result]);
	}

}

function BUpdate_Click() 
{	
	if (condition()) return;	
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var list=plist.split("^");
    var code=list[1];
    if(code=="") return;
    
	var result=cspRunServerMethod(encmeth,plist);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("�����ɹ�")
		location.reload();
		return;
	}
	else
	{
		alertShow(t[result]);
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
		alertShow(t[-4001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	//alertShow(result);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("�����ɹ�")
		location.reload();
	}	
}
///ѡ�����д����˷���
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMCMaintItem');  //t+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	
	{
		Clear();
		disabled(true);//�һ�	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		disabled(false);//���һ�
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Type","");
	SetElement("Remark","");	
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	//alertShow(gbldata);
	var list=gbldata.split("^");
	SetElement("RowID",rowid); //rowid
	SetElement("Code",list[0]); //
	SetElement("Desc",list[1]); //
	SetElement("Remark",list[2]);//
	//SetElement("InvalidFlag",list[3]);//
	SetElement("Type",list[4]);//	
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