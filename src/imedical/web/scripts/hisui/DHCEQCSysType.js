///--------------------------------------------
///Created By HZY 2011-7-21 . Bug HZY0002
///Description:�ڴ���ά���˵�������ϵͳ�����Ӳ˵�?ʵ�ֶ�ϵͳ������Ϣ�Ĺ���?
///--------------------------------------------
var SelectedRow = -1;  //modify by lmm 2018-10-11 hisui���죺��ʼ�к��޸�
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
	InitEvent();	
	disabled(true);//�һ�
	//initButtonWidth()  //hisui����:��ť����һ�� add by lmm 2018-08-20
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
}
function BFind_Click()
{
	var val="&Desc="+GetElementValue("Desc");
	val=val+"&Code="+GetElementValue("Code");
	val=val+"&ReplaceContent="+GetElementValue("ReplaceContent")
	val=val+"&Remark="+GetElementValue("Remark")
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCSysType"+val;  //modify by lmm 2018-10-11 hisui���죺����hisuiĬ��csp
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
 	combindata=combindata+"^"+GetElementValue("InvalidFlag") ; //
  	combindata=combindata+"^"+GetElementValue("ReplaceContent") ; //
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
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
		messageShow("","","",t[result]);
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
		messageShow("","","",t[-4001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("ɾ���ɹ�!")
		location.reload();
	}	
}
///ѡ�����д����˷���
///modify by lmm 2018-08-17
///������hisui���� ����ֵ��ȡ��ʽ ��������
///��Σ�selectrow �к�
///      rowdata ��json����
function SelectRowHandler(selectrow,rowdata)
{
	if (SelectedRow==selectrow)	
	{
		Clear();
		disabled(true);//�һ�	
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		$('#tDHCEQCSysType').datagrid('unselectAll');  //hisui����:ȡ��ѡ�� add by lmm 2018-10-10
	}
	else
	{
		SelectedRow=selectrow;
		rowid=rowdata.TRowID;
		SetData(rowid);//���ú���
		disabled(false);//���һ�
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("ReplaceContent","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",rowid); //rowid
	SetElement("Code",list[0]); //
	SetElement("Desc",list[1]); //
	SetElement("Remark",list[2]);//
	SetElement("InvalidFlag",list[3]);//
	SetElement("ReplaceContent",list[4]);//
	SetElement("Hold1",list[5]);//
	SetElement("Hold2",list[6]);//
	SetElement("Hold3",list[7]);//
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
