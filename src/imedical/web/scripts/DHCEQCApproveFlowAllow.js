var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler()
{
	InitEvent();
	disabled(true);
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

function BAdd_Click() //���
{
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if(result<0)
	{
		alertShow("��ǰ��¼�Ѵ���,����ʧ��!");
		return
	}
	else
	{
		location.reload();	
	}
}
function BUpdate_Click() //�޸�
{
	var encmeth=GetElementValue("upd");
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if(result<0) 
	{
		alertShow("��ǰ��¼�Ѵ���,����ʧ��!");
		return;
	}
	else 
	{
		location.reload();
	}
}
function BDelete_Click() //ɾ��
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm("ȷ��ɾ���ü�¼?");
    if (!truthBeTold) return;
	var encmeth=GetElementValue("upd");
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result<0) 
	{
		alertShow("ɾ��ʧ��!");
		return ;
	}
	else 
	{
		location.reload();	
	}
}
function CombinData()
{
	var ApproveFlowAllowDR=GetElementValue("ApproveFlowAllowDR");
	if (ApproveFlowAllowDR=="")
	{
		alertShow("��ѡ����������!")
		return
	}
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("ApproveFlowDR");
	combindata=combindata+"^"+GetElementValue("ApproveFlowAllowDR");
	combindata=combindata+"^"+GetElementValue("Type");
  	return combindata;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}

///ѡ�����д����˷���
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCApproveFlowAllow');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();	
		disabled(true)//�һ�
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//���ú���
		disabled(false)//���һ�
	}
}

function Clear()
{
	SetElement("ApproveFlowAllowDR","");
	SetElement("ApproveFlowAllow","");
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"ת��Ϊ�س���
	//alertShow(gbldata)
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("ApproveFlowAllowDR",list[2]); 
	SetElement("ApproveFlowAllow",list[6]); 
	
}

function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)
	DisableBElement("BAdd",!value)
}

function GetApproveFlowRole(value)
{
	var val=value.split("^");	
	//alertShow(val)
	SetElement("ApproveFlowAllowDR",val[0])	
	SetElement("ApproveFlowAllow",val[2])	

}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
