var SelectedRow = 0;

//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() 
{
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
}

function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_click;
	obj=document.getElementById("CancelFlag");
	if (obj) obj.onclick=CancelFlagChange;
	
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iNextToFlow");
	if (obj) obj.onclick=BNextToFlow_Click;
	var obj=document.getElementById("GotoType");
	if (obj) obj.onchange=GotoType_Click;

	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iCancelToStep");
	if (obj) obj.onclick=BCancelToStep_Click;
	var obj=document.getElementById("CancelToType");
	if (obj) obj.onchange=CancelToType_Click;
	
	obj=document.getElementById("ChangeTypeFlag");  //add by zx 2016-02-29
	if (obj) obj.onclick=ChangeTypeFlag_Change;
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iCanChangeStep");
	if (obj) obj.onclick=BCanChangeStep_Click;
	KeyUp("ApproveRole^CancelToStep^Action");		//20110224  Mozy0043
	Muilt_LookUp("ApproveRole^CancelToStep^Action");	//20110224  Mozy0043
	
	var obj=document.getElementById("CanRepeatFlag");  //add by zx 2018-07-12
	if (obj) obj.onchange=CanRepeatFlag_Click;
}

//�����������������,�������ƹ̶�
function SelectRowHandler()	
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQCApproveFlow'); //�õ����   t+�������
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //��ǰѡ����
	if (selectrow==SelectedRow){
		SetElement("RowID","");
		Fill("^^^^^^^^^^^^^^^^^^^^^")		/// modify by GBX 2015-12-16�����������ֶ�  GBX0037
		SelectedRow=0;
		ChangeStatus(false);
		return;}
	ChangeStatus(true);
	FillData(selectrow)
    SelectedRow = selectrow;
	CancelFlagChange();
	ChangeTypeFlag_Change(); //add by zx 2016-02-29 ZX0039
}

function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	Fill(ReturnList)
	CancelFlagChange()
	ChangeTypeFlag_Change(); //add by zx 2016-02-29 ZX0039
}

function Fill(ReturnList)
{
	list=ReturnList.split("^");
	var sort=17;                                      //modify by GBX 2015-12-14
	//SetElement("ApproveSetDR",list[0]);
	SetElement("ApproveRoleDR",list[1]);
	SetElement("Step",list[2]);
	SetChkElement("LastFlag",list[3]);
	SetChkElement("CancelFlag",list[4]);
	SetElement("ApproveRole",list[sort+0]);
	SetElement("CancelToStepDR",list[sort+1]);
	SetElement("CancelToStep",list[sort+2]);
	//Modified by jdl 2011-3-2 JDL0072
	SetElement("Hold1",list[6]);
	SetElement("Hold2",list[7]);
	SetElement("ActionDR",list[8]);
	//SetElement("Hold4",list[9]);
	SetChkElement("Hold4",list[9]); //add by zx 2015-08-19  ZX0028	
	SetElement("Hold5",list[10]);
	SetElement("Action",list[sort+3]);
	
	//add by GBX 2015-12-16  GBX0037
	SetElement("GotoType",list[10]);  //������������
	SetElement("NextToFlowDR",list[11]);  //��������
	SetElement("CancelToType",list[12]);  //ȡ��������������
	SetChkElement("CanRepeatFlag",list[13]);  //���ظ���־
	SetElement("NextToFlow",list[sort+4]);  //��������
	
	//add by zx 2016-02-29 ZX0039
	SetChkElement("ChangeTypeFlag",list[14]);  //���жϱ�־
	
	SetElement("RepeatNum",list[15]);  //add by zx 2018-07-12
	
}

function BClose_click()
{
	window.close();
}

//���°�ť�������
function BUpdate_click()
{
	if (CheckNull()) return;
	var val=GetValue();
	var Return=UpdateData(val,"0");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("ApproveRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("Step") ;
  	combindata=combindata+"^"+GetChkElementValue("LastFlag") ;
  	combindata=combindata+"^"+GetChkElementValue("CancelFlag") ;
  	combindata=combindata+"^"+GetElementValue("CancelToStepDR") ;
  	//Modified by jdl 2011-3-2 JDL0072
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("ActionDR") ;
  	//combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetChkElementValue("Hold4") ;  //add by zx 2015-08-19  ZX0028	
  	//combindata=combindata+"^"+GetElementValue("Hold5") ;  //modify by GBX 2015-12-16  GBX0037
  	
  	//modify by GBX 2015-12-16  GBX0037
  	combindata=combindata+"^"+GetElementValue("GotoType") ;
  	combindata=combindata+"^"+GetElementValue("NextToFlowDR") ; 
  	combindata=combindata+"^"+GetElementValue("CancelToType") ;
  	combindata=combindata+"^"+GetChkElementValue("CanRepeatFlag") ;
  	
  	//add by zx 2016-02-29 ZX0039
  	combindata=combindata+"^"+GetChkElementValue("ChangeTypeFlag");
 	//add by zx 2018-07-10 
 	combindata=combindata+"^"+GetElementValue("RepeatNum");
 	
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
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(2,"ApproveRole")) return true;
	return false;
}

function UpdateData(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,val,AppType);
	return Return;
}

function GetApproveRole(value)
{
	var user=value.split("^");
	var obj=document.getElementById("ApproveRoleDR");
	obj.value=user[1];
}

function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}
//add by GBX 2015-12-16  GBX0037
function CancelToType_Click()
{
	SetElement('CancelToStep',"");
	SetElement('CancelToStepDR',"");
	
	var value=GetElementValue("CancelToType");
	if ((value=="0")||(value=="")) //0:Ĭ����һ��
	{
		DisableElement("CancelToStep",true);
		DisableElement(GetLookupName("CancelToStep"),true);
	}
	else
	{
		DisableElement("CancelToStep",false);
		DisableElement(GetLookupName("CancelToStep"),false);

	}
}
function BCancelToStep_Click()
{
	var value=GetElementValue("CancelToType");
	var ApproveSetDR=GetElementValue("ApproveSetDR")
	var Step=GetElementValue("Step")
	if ((value=="0")||(value=="")) //1:Ĭ����һ��
	{
		
		//LookUp("","web.DHCEQCApproveFlow:GetGoToApproveStep","GetGoToApproveStepValue","ApproveSetDR","Step");
	}
	else if (value=="1") //2:ָ������
	{
		LookUp("","web.DHCEQCApproveFlow:GetApproveStep","GetApproveStepValue","ApproveSetDR,Step");	
	}
	else if (value=="2") //3:��Ϊָ������
	{
		var ApproveFlowID=GetElementValue("RowID")
		var Type=1
		if (ApproveFlowID=="")
		{
			alertShow("���ȸ��»�ѡ��һ��!");
			return ;
		}
		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCApproveFlowAllow&Type=1&ApproveFlowDR="+ApproveFlowID;
		//alertShow(str);
    	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=500,left=150,top=150')

		//LookUp("","web.DHCEQEquip:GetShortEquip","GetEquipID","SourceID");		
	}
	else if (value=="3") //3:����������ת����
	{
		//
	}
	
}
function GetApproveStepValue(Value)
{
	var list=Value.split("^");
	SetElement("CancelToStepDR",list[0]);
	SetElement("CancelToStep",list[1]);
}

//add by GBX 2015-12-16  GBX0037
function GotoType_Click()
{
	SetElement('NextToFlow',"");
	SetElement('NextToFlowDR',"");
	
	var value=GetElementValue("GotoType");
	if ((value=="0")||(value=="")) //0:Ĭ����һ��
	{
		DisableElement("NextToFlow",true);
		DisableElement(GetLookupName("NextToFlow"),true);
	}
	else
	{
		DisableElement("NextToFlow",false);
		DisableElement(GetLookupName("NextToFlow"),false);

	}
}
function BNextToFlow_Click()
{
	var value=GetElementValue("GotoType");
	var ApproveSetDR=GetElementValue("ApproveSetDR")
	var Step=GetElementValue("Step")
	if ((value=="0")||(value=="")) //1:Ĭ����һ��
	{
		
		//LookUp("","web.DHCEQCApproveFlow:GetGoToApproveStep","GetGoToApproveStepValue","ApproveSetDR","Step");
	}
	else if (value=="1") //2:ָ������
	{
		LookUp("","web.DHCEQCApproveFlow:GetGoToApproveStep","GetGoToApproveStepValue","ApproveSetDR,Step");	
	}
	else if (value=="2") //3:��Ϊָ������
	{
		var ApproveFlowID=GetElementValue("RowID")
		var Type=0
		if (ApproveFlowID=="")
		{
			alertShow("���ȸ��»�ѡ��һ��!");
			return ;
		}
		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCApproveFlowAllow&Type=0&ApproveFlowDR="+ApproveFlowID;
    	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=500,left=150,top=150')
		//LookUp("","web.DHCEQEquip:GetShortEquip","GetEquipID","SourceID");		
	}
	else if (value=="3") //3:����������ת����
	{
		//
	}
	
}
function GetGoToApproveStepValue(Value)
{
	var list=Value.split("^");
	SetElement("NextToFlowDR",list[0]);
	SetElement("NextToFlow",list[1]);
}

function CancelFlagChange()
{
	var CancelFlag=GetChkElementValue("CancelFlag")
	if (CancelFlag==true)
	{
		ReadOnlyElement("CancelToStep",false)
	}
	else
	{
		SetElement("CancelToStepDR","");
		SetElement("CancelToStep","");
		ReadOnlyElement("CancelToStep",true)
	}
}

function GetAction(Value)
{
	var list=Value.split("^");
	SetElement("ActionDR",list[1]);
}
//add by zx 2016-02-29 ZX0039
function ChangeTypeFlag_Change()
{
	var ChangeTypeFlag=GetChkElementValue("ChangeTypeFlag");
	if (ChangeTypeFlag==true)
	{
		DisableElement("CanChangeStep",false);
		DisableElement(GetLookupName("CanChangeStep"),false);
	}
	else
	{
		SetElement("CanChangeStepDR","");
		SetElement("CanChangeStep","");
		DisableElement("CanChangeStep",true);
		DisableElement(GetLookupName("CanChangeStep"),true);
	}
}

//add by zx 2016-02-29 ZX0039
function BCanChangeStep_Click()
{
	var value=GetElementValue("CancelToType");
	var ApproveSetDR=GetElementValue("ApproveSetDR")
	var Step=GetElementValue("Step")
	
	var ApproveFlowID=GetElementValue("RowID")
	var Type=2; //�ɱ��жϲ���
	if (ApproveFlowID=="")
	{
		alertShow("���ȸ��»�ѡ��һ��!");
		return ;
	}
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCApproveFlowAllow&Type=2&ApproveFlowDR="+ApproveFlowID;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=500,left=150,top=150')
	
}

function CanRepeatFlag_Click()
{
	var ChangeTypeFlag=GetChkElementValue("CanRepeatFlag");
	if (ChangeTypeFlag==true)
	{
		DisableElement("RepeatNum",false);
	}
	else
	{
		SetElement("RepeatNum","");
		DisableElement("RepeatNum",true);
	}
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
