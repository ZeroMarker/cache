var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitEvent();	//��ʼ��
	KeyUp("Loc");
	Muilt_LookUp("Loc");
	ChangeStatus("")
}
function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}

function BUpdate_Click() //�޸�
{
	if (condition()) return;
	var RowID=GetElementValue("RowID");
	var val=CombinData();
	var encmeth=GetElementValue("UpdateData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,"1",val);
	if(result=="-1") 
	{
		alertShow("���·�̯�ɱ��Ѿ�¼��!");
		return
	}
	else
	{		
		location.reload();
	}
}

function BSubmit_Click()
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		alertShow("ѡ��Ҫ�ύ����Ϣ!")
		 return;
	}
	var encmeth=GetElementValue("SubmitData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result==0) location.reload();
}

function BDelete_Click() //ɾ��
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		alertShow("ѡ��Ҫɾ������Ϣ!")
		 return;
	}
	var truthBeTold = window.confirm("ȷ��Ҫɾ����?");
    if (!truthBeTold) return;
	var SubmitFlag=GetElementValue("SubmitFlag");
	var encmeth=GetElementValue("UpdateData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'0',rowid);
	if (result==0) location.reload();	
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID") ;//ID
    combindata=combindata+"^"+GetElementValue("LocDR") ;//����
  	combindata=combindata+"^"+GetElementValue("Year") ; //��
  	combindata=combindata+"^"+GetElementValue("Month") ; //��
  	combindata=combindata+"^"+GetElementValue("GYCost") ; //��Դ
  	combindata=combindata+"^"+GetElementValue("GLCost") ; //��Դ��
  	combindata=combindata+"^"+GetElementValue("YFCost") ; //��Դ
  	combindata=combindata+"^"+GetElementValue("ZJCost") ; //����
  	combindata=combindata+"^"+GetElementValue("Person") ; //��λ
  	combindata=combindata+"^"+GetElementValue("InCome") ; //����
  	combindata=combindata+"^"+GetElementValue("SubmitFlag") ; //�ύ��־
  	return combindata;
}
function Clear()
{
	SetElement("Year","");
	SetElement("Month","");
	SetElement("GYCost","");
	SetElement("GLCost","");
	SetElement("YFCost","");
	SetElement("ZJCost","");
	SetElement("InCome","");
	SetElement("Person","");
	SetElement("Loc","");
	SetElement("LocDR","");
}
///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQLocCost');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		SetElement("RowID",GetElementValue("TRowIDz"+SelectedRow));
		SetElement("Loc",GetElementValue("TLocz"+SelectedRow));
		SetElement("LocDR",GetElementValue("TLocDRz"+SelectedRow));
		SetElement("Year",GetElementValue("TYearz"+SelectedRow));
		SetElement("Month",GetElementValue("TMonthz"+SelectedRow));
		SetElement("GYCost",GetElementValue("TGYCostz"+SelectedRow));
		SetElement("GLCost",GetElementValue("TGLCostz"+SelectedRow));
		SetElement("YFCost",GetElementValue("TYFCostz"+SelectedRow));
		SetElement("ZJCost",GetElementValue("TZJCostz"+SelectedRow));
		SetElement("Person",GetElementValue("TPersonz"+SelectedRow));
		SetElement("InCome",GetElementValue("TInComez"+SelectedRow));
		}
	ChangeStatus(GetElementValue("RowID"))
	InitEvent()
}

function GetLocID(value) {
	var type=value.split("^");
	SetElement("LocDR",type[1]);
}
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
function ChangeStatus(rowid)
{
	if (rowid=="")
	{
		DisableBElement("BSubmit",true)
		DisableBElement("BDelete",true)	
		DisableBElement("BUpdate",false)		
		SetElement("SubmitFlag","")		
		return;
	} 
	var encmeth=GetElementValue("GetLocCostStatus");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid);
	if (result=="Y")
	{
		SetElement("SubmitFlag",result)
		DisableBElement("BUpdate",true)
		DisableBElement("BSubmit",true)
		DisableBElement("BDelete",false)	
		alertShow("���·�̯�ɱ��Ѿ��ύ!")
	}
	else
	{
		SetElement("SubmitFlag","")
		DisableBElement("BUpdate",false)
		DisableBElement("BSubmit",false)
		DisableBElement("BDelete",false)		
	}
	return;
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
