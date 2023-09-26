///Creator: zy 2011-07-19 ZY0074
///Description:��������������ά��
var SelectedRow = -1;  //modify by lmm 2018-10-11 hisui���죺��ʼ�к��޸�
function BodyLoadHandler() 
{
	KeyUp("Table^Format","N");	//���ѡ��
	Muilt_LookUp("Table^Format","N");
    InitUserInfo(); //ϵͳ����
	InitPage();	
	disabled(true);//�һ�
	initButtonWidth()  //hisui����:��ť����һ�� add by lmm 2018-08-20
}

function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BUpdate_Clicked()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var rtn=cspRunServerMethod(encmeth,plist,"1");
	if(rtn==0) 
	{
		alertShow("�����ɹ�!")
		location.reload();	
	}
	else
	{		
		messageShow("","","",t[rtn]);
		return
	}
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,RowID,"0");
	if(rtn==0) 
	{
		alertShow("ɾ���ɹ�!")
		location.reload();	
	}
	else
	{		
		messageShow("","","",t[rtn]);
		return
	}
}
function BClear_Clicked()
{
	Clear();
	disabled(true);
}

//modified by csj 20190524
function BFind_Click()
{
	if (!$(this).linkbutton('options').disabled){
		$('#tDHCEQCColumns').datagrid('load',{ComponentID:getValueById("GetComponentID"),TableDR:getValueById("TableDR"),Name:getValueById("Name"),Caption:getValueById("Caption"),Location:getValueById("Location"),Sort:getValueById("Sort"),FormatDR:getValueById("FormatDR"),HiddenFlag:getValueById("HiddenFlag")?"Y":""})
	}
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");//1
	combindata=combindata+"^"+GetElementValue("TableDR");//
  	combindata=combindata+"^"+GetElementValue("Name"); //
  	combindata=combindata+"^"+GetElementValue("HiddenFlag"); //
  	combindata=combindata+"^"+GetElementValue("Caption"); //
  	combindata=combindata+"^"+GetElementValue("Location"); //
  	combindata=combindata+"^"+GetElementValue("Remark"); //
  	combindata=combindata+"^"+GetElementValue("FormatDR"); //
  	combindata=combindata+"^"+GetElementValue("Sort"); //
  	combindata=combindata+"^"+GetElementValue("Hold1"); //
  	combindata=combindata+"^"+GetElementValue("Hold2"); //
  	combindata=combindata+"^"+GetElementValue("Hold3"); //
  	combindata=combindata+"^"+GetElementValue("Hold4"); //
  	combindata=combindata+"^"+GetElementValue("Hold5"); //
  	return combindata;
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
		SetElement("RowID","");
		$('#tDHCEQCColumns').datagrid('unselectAll');  //hisui����:ȡ��ѡ�� add by lmm 2018-10-10
	}
	else
	{
		SelectedRow=selectrow;
		SetData(selectrow,rowdata);//���ú���
		disabled(false);//���һ�
	}
}

function Clear()
{
	SetElement("RowID","")
	SetElement("Table",""); 
	//SetElement("TableDR","");
	SetElement("Name","");
	SetChkElement("HiddenFlag","");
	SetElement("Caption","");
	SetElement("Location","");
	SetElement("Remark","");
	SetElement("Format","");
	SetElement("FormatDR","");
	SetElement("Sort","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
///ѡ�����д����˷���
///modify by lmm 2018-08-17
///������hisui���� ����ֵ��ȡ��ʽ ��������
///��Σ�selectrow �к�
///      rowdata ��json����
function SetData(selectrow , rowdata)
{
	SetElement("RowID",rowdata.TRowID);
	SetElement("Table",rowdata.TTable);
	//SetElement("TableDR",rowdata.TTableDR);
	SetElement("Name",rowdata.TName);
	if (rowdata.THiddenFlag=="Y")
	{
		SetChkElement("HiddenFlag",1);
	}
	else
	{
		SetChkElement("HiddenFlag",0);
	}	
	SetElement("Caption",rowdata.TCaption);
	SetElement("Location",rowdata.TLocation);
	SetElement("Remark",trim(rowdata.TRemark));
	SetElement("Format",rowdata.TFormat);
	SetElement("FormatDR",rowdata.TFormatDR);
	SetElement("Sort",rowdata.TSort);
	SetElement("Hold1",rowdata.THold1);
	SetElement("Hold2",rowdata.THold2);
	SetElement("Hold3",rowdata.THold3);
	SetElement("Hold4",rowdata.THold4);
	SetElement("Hold5",rowdata.THold5);
}
function disabled(value)//�һ�
{
	InitPage();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetTableID(value)
{
	GetLookUpID("TableDR",value);
}
function GetFormatID(value)
{
	GetLookUpID("FormatDR",value);
}
document.body.style.padding="10px 10px 10px 5px"  // add by lmm 2019-01-18 
document.body.onload = BodyLoadHandler;