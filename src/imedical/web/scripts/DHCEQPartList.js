//�豸��λ�б�
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	InitUserInfo();
	InitEvent();
	KeyUp("Equip^Part")	;
	Muilt_LookUp("Equip^Part");
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

function BUpdate_Click() 
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if(!result)alertShow(t[-3001])
	if (result>0)location.reload();	
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("EquipDR") ;//�豸2
  	combindata=combindata+"^"+GetElementValue("PartDR") ; //��λ3
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע4
  	combindata=combindata+"^"+curUserID;//�����5
  	return combindata;
}
function BAdd_Click() 
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n");
	if(!result)alertShow(t[-3001])
	if (result>0)location.reload();	
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result>0)location.reload();
}	
///ѡ�����д����˷���
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQPartList');//+����� ������������ʾ Query ����Ĳ���
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
	SetElement("Equip",list[1]); //�豸
	SetElement("Part",list[2]); //��λ
	SetElement("Remark",list[3]);//��ע
	SetElement("EquipDR",list[4]); //�豸����
	SetElement("PartDR",list[5]); //��λ����
}
function Clear()
{
	SetElement("Equip",""); 
	SetElement("Part","");
	SetElement("Remark","");
	}	
function EquipDR(value)//�豸����
{
	//alertShow(value);
	var obj=document.getElementById("EquipDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}	
function PartDR(value)//�豸����
{
	//alertShow(value);
	var obj=document.getElementById("PartDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
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
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(1,"Part")) return true;
	*/
	return false;
}	
document.body.onload = BodyLoadHandler;