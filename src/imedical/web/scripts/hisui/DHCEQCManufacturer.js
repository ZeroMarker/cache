//modified by GR 2014-09-24 ȱ�ݺ�2995 ɾ�����̼�¼�����ֲ�ѯ����δ�Զ����
//�޸�λ�ã�BDelete_Click()��BDelete_Click()��BUpdate_Click()
//-------------------------------------------------------------------------
//�豸��������
function BodyLoadHandler() 
{
	InitUserInfo();
	InitEvent();
	disabled(true)//�һ�
	initButtonWidth()  //hisui���� add by czf 20180905
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
	var val="&Name="+GetElementValue("Name");
	val=val+"&Code="+GetElementValue("Code");
	val=val+"&Address="+GetElementValue("Address")
	val=val+"&Tel="+GetElementValue("Tel")
	val=val+"&Zip="+GetElementValue("Zip")
	val=val+"&Fax="+GetElementValue("Fax")
	val=val+"&Contperson="+GetElementValue("Contperson")
	val=val+"&Shname="+GetElementValue("Shname")
	val=val+"&Grading="+GetElementValue("Grading")
	val=val+"&Hold1="+GetElementValue("Hold1")             //modified by czf ����ţ�335916
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer"+val;	//HISUI���� modified by czf 20180831
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")	{return;}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	//alertShow("result"+result);
	//if (result>0) {location.reload();}
	//HISUI���� modified by czf 20180831
	if (result>0) { window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer";} //modified by GR 2014-09-24 ȱ�ݺ�2995 ɾ�����̼�¼�����ֲ�ѯ����δ�Զ���� 	
}
function BUpdate_Click() 
{
	if (condition()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("�����ʼ���ַ����,����ȷ����!")
		return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")	return;	
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result==-2001)messageShow("","","",t[-3002])
	//if (result>0)	location.reload();
	if (result>0)
	{
		alertShow("����ɹ�!");
		//HISUI���� modified by czf 20180831
		window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer";	//modified by GR 2014-09-24 ȱ�ݺ�2995 ɾ�����̼�¼�����ֲ�ѯ����δ�Զ����
	}
}
function BAdd_Click() //����
{
	if (condition()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("�����ʼ���ַ����,����ȷ����!")
		return
	}
var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n");
	if (result==-2001)messageShow("","","",t[-3001])
	//if (result>0)	location.reload();
	if (result>0)
	{
		alertShow("���ӳɹ�!");
		//HISUI���� modified by czf 20180831
		window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer";	//modified by GR 2014-09-24 ȱ�ݺ�2995 ɾ�����̼�¼�����ֲ�ѯ����δ�Զ����
	}
}	
	function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Name") ;//����2
  	combindata=combindata+"^"+GetElementValue("Code") ; //����3
	if (GetElementValue("Code")=="") combindata=combindata+GetPYCode(GetElementValue("Name"));
  	combindata=combindata+"^"+GetElementValue("Address") ; //��ַ4
  	combindata=combindata+"^"+GetElementValue("Tel") ; //�绰5
  	combindata=combindata+"^"+GetElementValue("Zip") ; //�ʱ�6
  	combindata=combindata+"^"+GetElementValue("Fax") ; //����7
  	combindata=combindata+"^"+GetElementValue("Contperson") ; //��ϵ��8
  	combindata=combindata+"^"+GetElementValue("Shname") ; //������9
	if (GetElementValue("Shname")=="") combindata=combindata+GetPYCode(GetElementValue("Name"));   //modified by czf ����ţ�335979
  	combindata=combindata+"^"+GetElementValue("Grading") ; //�ȼ�10
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	combindata=combindata+"^"+GetElementValue("Hold4") ; //
  	combindata=combindata+"^"+GetElementValue("Hold5") ; //
  	return combindata;
}
///ѡ�����д����˷���
///HISUI���� modified by czf 20180830
var SelectedRow = -1;
var rowid=0;
function SelectRowHandler(index,rowdata)	{
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		disabled(true)//�һ�
		$('#tDHCEQCManufacturer').datagrid('unselectAll'); 
		return;
		}
		
	SetData(rowdata.TRowID); 
	disabled(false)//���һ�  
    SelectedRow = index;
}
/*
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCManufacturer');//+����� ������������ʾ Query ����Ĳ���
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
		SetData(rowid);//���ú���
		disabled(false)//���һ�
		}
}*/
function Clear()
{
	SetElement("RowID","");
	SetElement("Name",""); //����1
	SetElement("Code","");//����2
	SetElement("Address","");//��ַ3
	SetElement("Tel","");//�绰4
	SetElement("Zip","");//�ʱ�
	SetElement("Fax","");//����
	SetElement("Contperson","");//��ϵ��
	SetElement("Shname","");//������
	SetElement("Grading","");//�ȼ�
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
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
	SetElement("Name",list[1]); //����1
	SetElement("Code",list[2]);//����2
	SetElement("Address",list[3]);//��ַ3
	SetElement("Tel",list[4]);//�绰4
	SetElement("Zip",list[5]);//�ʱ�
	SetElement("Fax",list[6]);//����
	SetElement("Contperson",list[7]);//��ϵ��
	SetElement("Shname",list[8]);//������
	SetElement("Grading",list[9]);//�ȼ�
	SetElement("Hold1",list[10]);//
	SetElement("Hold2",list[11]);//
	SetElement("Hold3",list[12]);//
	SetElement("Hold4",list[13]);//
	SetElement("Hold5",list[14]);//
}
/*
function disabledt()//�һ�
{
	DisableBElement("BUpdate",true)
	DisableBElement("BDelete",true)
	DisableBElement("BAdd",false)
	//document.all["BUpdate"].style.display="none";
	//document.all["BDelete"].style.display="inline";
}
*/
function disabled(value)//���һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//����Code
{
	if (CheckMustItemNull()) return true;
	/*if (CheckItemNull(0,"Name")) return true;
	if (CheckItemNull(0,"Code")) return true;*/
	return false;
}
document.body.onload = BodyLoadHandler; //�������� ����