//�豸ҽ������ձ�
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo();
	InitEvent();
	KeyUp("Equip^OrderItem");
	Muilt_LookUp("Equip^OrderItem");	
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
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)location.reload();	
}
function BUpdate_Click() 
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(!result)alertShow(t[-3001])
	if (result>0)location.reload();	
}
function BAdd_Click() //����
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(!result)alertShow(t[-3001])
	if (result>0)location.reload();	
}	
	function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("EquipDR") ;//���
  	combindata=combindata+"^"+GetElementValue("OrderItemDR") ; //����
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	combindata=combindata+"^"+curUserID;//�����5
  	return combindata;
}

///ѡ�����д����˷���
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQOrderItemMap');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		//document.all["BAdd"].style.display="inline";
		Clear();
		disabled(true)//�һ�		
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		//document.all["BAdd"].style.display="none";//����
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		//SetElement("RowID",rowid);
		SetData(rowid);//���ú���
		disabled(false)//���һ�
		}
}
function Clear()
{
	SetElement("Equip",""); //�豸
	SetElement("OrderItem","");//����
	SetElement("Remark","");//��ע
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	var sort=14
	SetElement("RowID",list[0]); //rowid
	SetElement("Equip",list[1]); //�豸1
	SetElement("OrderItem",list[2]);//����2
	SetElement("Remark",list[3]);//��ע3
	SetElement("EquipDR",list[4]); //�豸4
	SetElement("OrderItemDR",list[5]); //ҽ�������5
}
function EquipDR(value)//�豸����
{
	//alertShow(value);
	var obj=document.getElementById("EquipDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
function OrderItemDR(value)//�豸����
{
	//alertShow(value);
	var obj=document.getElementById("OrderItemDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
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
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(1,"OrderItem")) return true;
	*/
	return false;
}
document.body.onload = BodyLoadHandler;