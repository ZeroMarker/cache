var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
    InitUserInfo(); //ϵͳ����
	InitEvent();	
	disabled(true);//�һ�
	//InitPageNumInfo("DHCEQMCEmergencyLevel.EmergencyLevel","DHCEQMCEmergencyLevel");
	
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	//alertShow("a");
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
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	//alertShow(encmeth);
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,plist,'2');
	
//Modified By HHM 20150828  HHM0006
//��Ӳ�������ֵ����
	if (result>0)
	{
		alertShow("�����ɹ�")
		location.reload();
	}
	else
	{
		alertShow(t[result]);
		return;
	}	
//**************************************
	//result=result.replace(/\\n/g,"\n")
	/*//alertShow("result:"+result)
	if(result=="")
	{
		alertShow(t[-3001]);
		return
	}
	else
	{
	   location.reload();
	}	*/
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Code") ;//
  	combindata=combindata+"^"+GetElementValue("Desc") ; //
  	combindata=combindata+"^"+GetElementValue("Level") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n");
//Modified By HHM 20150828  HHM0006
//��Ӳ�������ֵ����
	if (result>0)
	{
		alertShow("�����ɹ�")
		location.reload();
	}
	else
	{
		alertShow(t[result]);
		return;
	}	
//**************************************
	
	/*//alertShow("result"+result)
	if(result=="") 
	{
		alertShow(t[-3001]);
	return
	}
	else
	{
		location.reload();	
	}*/
}
function BDelete_Click() 
{
	var rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		alertShow(t[-4001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result>0)
	{
		alertShow("�����ɹ�")
		location.reload();
	}
//**************************************
	/*//alertShow(result);
	if (result==0) 
	{
		location.reload();	
	}*/
}
///ѡ�����д����˷���
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMCEmergencyLevel');//+����� ������������ʾ Query ����Ĳ���
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
	SetElement("RowID","");
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Level","");
	SetElement("Remark","");
	}
function SetData(rowid)
{
	//alertShow("rowid::::"+rowid)
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //
	SetElement("Desc",list[2]); //
	SetElement("Level",list[3]);
	SetElement("Remark",list[4]);//
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

