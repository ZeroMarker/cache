//ά�޷�ʽ
function BodyLoadHandler() 
{
   InitUserInfo();
	InitEvent();
	//KeyUp("Omdr")	//���ѡ��
   disabled(true)//�һ�
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
	function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result>0){location.reload();}	
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;//�豸2
  	combindata=combindata+"^"+GetElementValue("Desc") ; //��λ3
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע4
  	combindata=combindata+"^"+GetElementValue("Type") ; //��ע4
  	combindata=combindata+"^"+GetElementValue("InvalidFlag") ; //��ע4
  	return combindata;
}
function BAdd_Click() 
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	rresult=result.replace(/\\n/g,"\n");
	if (result>0){location.reload();}
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4003]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	//alertShow("result"+result);
	if (result>0)	location.reload();		
}	
///ѡ�����д����˷���
var SelectedRow = 0;
var rowid=0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCMaintMode');//+����� ������������ʾ Query ����Ĳ���
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
		SetElement("RowID",rowid);
		SetData(rowid);//���ú���
		disabled(false)//���һ�
		}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("Code",list[1]); //�豸
	SetElement("Desc",list[2]); //��λ
	SetElement("Remark",list[3]);//��ע
	SetElement("Type",list[4]); //�豸����
	SetElement("InvalidFlag",list[5]); //��λ����
}
function Clear()
{
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("Type","");
	SetElement("InvalidFlag","");
	}	
function disabled(value)//���һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//����
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"Code")) return true;
	return false;
}
	document.body.onload = BodyLoadHandler