///Creator: zy 2011-07-19 ZY0074
///Description:��������������ά��
var SelectedRow = 0;
function BodyLoadHandler() 
{
	KeyUp("Table^Format","N");	//���ѡ��
	Muilt_LookUp("Table^Format","N");
    InitUserInfo(); //ϵͳ����
	InitPage();	
	disabled(true);//�һ�
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
		alertShow(t[rtn]);
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
		alertShow(t[rtn]);
		return
	}
}
function BClear_Clicked()
{
	Clear();
	disabled(true);
}
function BFind_Click()
{
	var val="&TableDR="+GetElementValue("TableDR");
	val=val+"&Name="+GetElementValue("Name");
	val=val+"&Caption="+GetElementValue("Caption")
	val=val+"&Location="+GetElementValue("Location")
	val=val+"&Sort="+GetElementValue("Sort")
	val=val+"&FormatDR="+GetElementValue("FormatDR")
	val=val+"&Format="+GetElementValue("Format")   //Modefied by zc 2014-09-10 ZC0005
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCColumns"+val;	
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
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCColumns');//+����� ������������ʾ Query ����Ĳ���
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
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		SetData();//���ú���
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
function SetData()
{
	SetElement("RowID",GetElementValue("TRowIDz"+SelectedRow));
	SetElement("Table",GetElementValue("TTablez"+SelectedRow));
	//SetElement("TableDR",GetElementValue("TTableDRz"+SelectedRow));
	SetElement("Name",GetElementValue("TNamez"+SelectedRow));
	if (GetElementValue("THiddenFlagz"+SelectedRow)=="Y")
	{
		SetChkElement("HiddenFlag",1);
	}
	else
	{
		SetChkElement("HiddenFlag",0);
	}	
	SetElement("Caption",GetElementValue("TCaptionz"+SelectedRow));
	SetElement("Location",GetElementValue("TLocationz"+SelectedRow));
	SetElement("Remark",trim(GetElementValue("TRemarkz"+SelectedRow)));
	SetElement("Format",GetElementValue("TFormatz"+SelectedRow));
	SetElement("FormatDR",GetElementValue("TFormatDRz"+SelectedRow));
	SetElement("Sort",GetElementValue("TSortz"+SelectedRow));
	SetElement("Hold1",GetElementValue("THold1z"+SelectedRow));
	SetElement("Hold2",GetElementValue("THold2z"+SelectedRow));
	SetElement("Hold3",GetElementValue("THold3z"+SelectedRow));
	SetElement("Hold4",GetElementValue("THold4z"+SelectedRow));
	SetElement("Hold5",GetElementValue("THold5z"+SelectedRow));
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
document.body.onload = BodyLoadHandler;