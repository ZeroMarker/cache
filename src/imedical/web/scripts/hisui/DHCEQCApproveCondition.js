//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	hidePanelTitle(); //added by LMH 20230211 UI ����������浯������������
	initPanelHeaderStyle(); //added by LMH 20230211 UI ���������������ʽ
	showBtnIcon('BAdd^BUpdate^BDelete',false); //modified by LMH 20230211 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	initButtonColor(); //added by LMH 20230211 UI ��ʼ����ť��ɫ
	initButtonWidth();///Add By QW 2018-08-31 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-09-29 HISUI����:��ť���ֹ淶
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	// MZY0094	2094508		2021-09-13
	var ApproveSet=tkMakeServerCall("web.DHCEQCApproveSet","GetOneApproveSet",GetElementValue("ApproveSetDR"));
	var Detail=ApproveSet.split("^");
	document.getElementById("cEQTitle").innerHTML = "�豸������: "+Detail[1];
}

function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var BDobj=document.getElementById("BClose");
	if (BDobj) BDobj.onclick=BClose_click;
	KeyUp("ConditionFields");
	Muilt_LookUp("ConditionFields");	
}
//�����������������,�������ƹ̶�
///Modify By QW 2018-08-31 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
var SelectedRow = -1;
function SelectRowHandler(index,rowdata)	{
    if(index==SelectedRow)
    {
		SetElement("RowID","");
		Fill("^^^^^^^^^^^")
		SelectedRow=-1;
		ChangeStatus(false);
		$('#tDHCEQCApproveCondition').datagrid('unselectAll');
		return;
	 }
	ChangeStatus(true);
	FillData(rowdata.TRowID)
	SelectedRow = index
}
///Modify By QW 2018-08-31 HISUI���죺���ѡ���к󣬽����޷������������
///�޸�FillData�����Ĵ������
function FillData(RowID)
{
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	Fill(ReturnList)
}
function Fill(ReturnList)
{
	list=ReturnList.split("^");
	SetElement("ApproveSetDR",list[0]);
	SetElement("ConditionFieldsDR",list[1]);
	SetElement("Value",list[2]);
	SetElement("ToValue",list[3]);
	SetElement("ConditionFields",list[9]);
	SetElement("TableName",list[10]);
	SetElement("Type",list[11]);
	//Add By QW20210607 BUG:QW0119 �����:1944805 begin
	if (GetElementValue("Type")=="0")
	{
		ReadOnlyElement("ToValue",true)
	}
	else
	{
		ReadOnlyElement("ToValue",false)
	}
	//Add By QW20210607 BUG:QW0119 end
}
function BClose_click()
{
	//Modified By QW20181026 �����:723859 �ر�ģ̬����,window.close()��������;
	websys_showModal("close");  
}
//���°�ť�������
function BUpdate_click()
{
	if (CheckNull()) return;
	var val=GetValue();
	var Return=UpdateData(val,"0");
	if (Return!=0)
	{
		window.location.reload();
	}
	else
	{
		messageShow("","","",Return+"  "+t["01"]);
	}
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("ConditionFieldsDR") ;
  	combindata=combindata+"^"+GetElementValue("Value") ;
  	combindata=combindata+"^"+GetElementValue("ToValue") ;
  	return combindata;
}
//ɾ����ť�������
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var Return=UpdateData(RowID,"1");
	if (Return<0)
	{
		messageShow("","","",Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function UpdateData(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,val,AppType);
	return Return;
}

function GetConditionFields(value) 
{
	var list=value.split("^");
	SetElement("ConditionFieldsDR",list[0]);
	SetElement("ConditionFields",list[1]);
	SetElement("TableName",list[2]);  //Add By QW20210607 BUG:QW0119 �����:1944805
	SetElement("Type",list[3]);
	if (GetElementValue("Type")==0)
	{
		ReadOnlyElement("ToValue",true)
	}
	else
	{
		ReadOnlyElement("ToValue",false)
	}
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
