var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
	InitEvent();	
	disabled(true);//�һ�
	//InitPageNumInfo("DHCEQMCManageType.ManageType","DHCEQMCManageType");	
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
function BAdd_Click() //����
{
	//�޸� by GR0006 2014-09-04  begin ��������Ϊ�յ��жϹ���
	if(""==GetElementValue("Code")){alertShow("���������");return;}
	if(""==GetElementValue("Desc")){alertShow("����������");return;}
	//�޸� by GR0006 2014-09-04 end
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow("�����Ѵ���")//�޸� by GR0006 2014-09-04 ���alertShow(t[3001])����������
		return
	}
	else
	{
		alertShow("�����ɹ�!")
		location.reload();
	}	
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Code") ;//
  	combindata=combindata+"^"+GetElementValue("Desc") ; //
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	return combindata;
}
function BUpdate_Click() 
{
	//�޸� by GR0006 2014-09-04  begin ��������Ϊ�յ��жϹ���
	if(""==GetElementValue("Code")){alertShow("���������");return;}
	if(""==GetElementValue("Desc")){alertShow("����������");return;}
	//�޸� by GR0006 2014-09-04  end
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		alertShow("�����Ѵ���");//�޸� by GR0006 2014-09-04 ���alertShow(t[3001])����������
		return
	}
	else 
	{
		alertShow("���³ɹ�!")
		location.reload();	
	}
}
function BDelete_Click() 
{
	var rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);      //add by czf 2016-11-01 ����ţ�279864
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t[-2201]);////�޸� by GR0006 2014-09-04 t[3001]�����ڣ�t[-2201]������ʧ��
	return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n");
	
	 if (result>0) //262532 Modify by BRB 2016-09-27 
	{
		alertShow("ɾ���ɹ�!")
		location.reload();	
	}
}
///ѡ�����д����˷���
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMCManageType');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	//alertShow("selectrow"+selectrow)
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();
		disabled(true);//�һ�	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
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
	SetElement("Remark","");
	}
// add by zx 2015-08-20 Bug ZX0029
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //
	SetElement("Desc",list[2]); //
	SetElement("Remark",list[3]);//
}
function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)	//	Mozy	20161012	�����:269686
}	
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
document.body.onload = BodyLoadHandler;


