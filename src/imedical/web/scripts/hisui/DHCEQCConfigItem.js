//�豸������Ŀ
var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo();
    initButtonWidth()  //hisui���� add by kdf 2018-10-22
	InitEvent();	
	KeyUp("ConfigItemCat^ValueUnit")	//MZY0061	1610237		2020-12-2	���ѡ��
	Muilt_LookUp("ConfigItemCat^ValueUnit");
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

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")  return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
		result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("ɾ���ɹ�!")
		location.reload();
	}	
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
		result=result.replace(/\\n/g,"\n")
	if(result==""){messageShow("","","",t[-3001]);}
	if (result>0)
	{
		alertShow("���³ɹ�!")
		location.reload();
	}	
}
function BAdd_Click() //����
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result==""){messageShow("","","",t[-3001])}
	if (result>0)
	{
		alertShow("�����ɹ�!")
		location.reload();
	}
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Code") ;//����
  	combindata=combindata+"^"+GetElementValue("Desc") ; //����
  	combindata=combindata+"^"+GetElementValue("Remark") ; //��ע
  	combindata=combindata+"^"+GetElementValue("ConfigItemCatDR") ; //�������ͷ�����
  	combindata=combindata+"^"+GetElementValue("ValueUnitDR") ; //MZY0061	1610237		2020-12-2	��λ
  	/*
  	var obj=document.getElementById("InvalidFlag")
  	if (obj.checked){var MainFlag="Y"}
  		else( MainFlag="N")
  	combindata=combindata+"^"+MainFlag; //��Ч��־
  	  */	
  	return combindata;
}
///ѡ�����д����˷���
/// modified by kdf 2018-10-22 hisui-����
function SelectRowHandler(index ,rowdata)
{
	if (SelectedRow==index)	{
		Clear();
		disabled(true)//�һ�		
		SelectedRow=-1 ;
		$('#tDHCEQCConfigItem').datagrid('unselectAll');  //hisui���� add by kdf 2018-10-22
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
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("ConfigItemCat","");
	SetElement("ValueUnit","");
	SetElement("ValueUnitDR","");	// MZY0061	1610237		2020-12-2
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth==""){return;}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //rowid
	SetElement("Desc",list[2]); //��λ
	SetElement("Remark",list[3]);//����
	SetElement("ConfigItemCat",list[4]); //��λ����
	SetElement("ValueUnit",list[5]);
	SetElement("ConfigItemCatDR",list[6])
	SetElement("ValueUnitDR",list[7]);	// MZY0061	1610237		2020-12-2
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"Code")) return true;
	return false;
}
function ConfigItemCatDR(value) // ��λ
{
	//messageShow("","","",value);
	var obj=document.getElementById("ConfigItemCatDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//messageShow("","","",val[1]+"/"+val[2]);
}
function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
// MZY0061	1610237		2020-12-2
function ValueUnitDR(value) // ��λ
{
	var obj=document.getElementById("ValueUnitDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
document.body.onload = BodyLoadHandler;