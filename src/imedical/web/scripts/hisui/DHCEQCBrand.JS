var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
    initButtonWidth()  //hisui���� add by kdf 2018-10-18
	InitEvent();	
	//KeyUp("ManuFactory");	//���ѡ��
	//Muilt_LookUp("ManuFactory");
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
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
}
function BFind_Click()
{
	var val="&Desc="+GetElementValue("Desc");
	val=val+"&Code="+GetElementValue("Code");
	val=val+"&ManuFactoryDR="+GetElementValue("ManuFactoryDR");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCBrand"+val;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BAdd_Click() //����
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)location.reload();	
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Code") ;//
  	combindata=combindata+"^"+GetElementValue("Desc") ; //
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	combindata=combindata+"^"+GetElementValue("ManuFactoryDR") ; //
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	combindata=combindata+"^"+GetElementValue("Hold4") ; //
  	combindata=combindata+"^"+GetElementValue("Hold5") ; //
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	messageShow("","","",t[-3001]);
	return
	}
	if (result>0) location.reload();	
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
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
///ѡ������д����˷���
/// modified by kdf 2018-10-18 hisui-����
function SelectRowHandler(index,rowdata)
	{
	if (SelectedRow==index)	{
		Clear();
		disabled(true);//�һ�	
		SelectedRow=-1;
		$('#tDHCEQCBrand').datagrid('unselectAll');  //hisui���� add by kdf 2018-10-18
		SetElement("RowID","");
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID ;
		SetData(rowid);//���ú���
		disabled(false);//���һ�
		}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("ManuFactoryDR","");
	SetElement("ManuFactory","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //
	SetElement("Desc",list[2]); //
	SetElement("Remark",list[3]);//
	SetElement("ManuFactoryDR",list[4]);//
	SetElement("ManuFactory",list[5]);//
	SetElement("Hold1",list[6]);//
	SetElement("Hold2",list[7]);//
	SetElement("Hold3",list[8]);//
	SetElement("Hold4",list[9]);//
	SetElement("Hold5",list[10]);//
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