var SelectedRow = -1; ///Modify By QW 2018-08-31 HISUI����
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() 
{
	initButtonWidth();///Add By QW 2018-08-31 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-09-29 HISUI����:��ť���ֹ淶
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
	///add by QW 2019-08-31 �෽����
	obj=document.getElementById("BMultipeDefine");
	if (obj) obj.onclick=BMultipeDefine_click;
	///End by QW 2019-08-31 �෽����
	//hisui���� add by  By QW 2018-08-31 HISUI����
	$('#CancelFlag').checkbox({
		onCheckChange:function(e,vaule){
			CancelFlagChange();
		}	
	});
	$('#NextToFlow').lookup('options').onBeforeShowPanel= function(){
		return  BNextToFlow_Click();
	};
	$('#GotoType').combobox('options').onSelect=function(){
		GotoType_Click();
	}
	$('#CancelToStep').lookup('options').onBeforeShowPanel= function(){
		return  BCancelToStep_Click();
	};
	$('#CancelToType').combobox('options').onSelect=function(){
		CancelToType_Click();
	}
	$('#ChangeTypeFlag').checkbox({
		onCheckChange:function(e,vaule){
			ChangeTypeFlag_Change();
		}	
	});
	$('#CanChangeStep').lookup('options').onBeforeShowPanel= function(){
		return  BCanChangeStep_Click();
	};
	//End By QW 2018-08-31 HISUI����
	KeyUp("ApproveRole^CancelToStep^Action");		//20110224  Mozy0043
	Muilt_LookUp("ApproveRole^CancelToStep^Action");	//20110224  Mozy0043
}

//�����������������,�������ƹ̶�
///Modify By QW 2018-08-31 HISUI���죺���ѡ���к󣬽����޷������������
///�����������index,rowdata�������������޸��ж��߼�
function SelectRowHandler(index,rowdata)	
{
	if(index==SelectedRow)
    {
		SetElement("RowID","");
		Fill("^^^^^^^^^^^^^^^^^^^^^")
		SelectedRow=-1;
		ChangeStatus(false);
		$('#tDHCEQCApproveFlow').datagrid('unselectAll');
		return;
	 }
	ChangeStatus(true);
	FillData(rowdata.TRowID)
	SelectedRow = index
	CancelFlagChange();
	ChangeTypeFlag_Change();
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
	CancelFlagChange()
	ChangeTypeFlag_Change(); //add by zx 2016-02-29 ZX0039
}

function Fill(ReturnList)
{
	list=ReturnList.split("^");
	var sort=19;                                     ///Add By QW20200108 BUG:QW0035 �����ֶ�AF_ComponentSetID
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
	///add by QW 2019-08-31 �෽����
	SetElement("MultipleNum",list[16]);  // �෽��������
	SetElement("MultipleDefineDR",list[17]);  //�෽��������
	SetElement("MultipleDefine",list[sort+5]);  //�෽��������
	///End by QW 2019-08-31 �෽����
	//Add By QW20200108 BUG:QW0035 begin �������
	SetElement("ComponentSetID",list[18]);
	SetElement("ComponentSet",list[sort+6]);
	//Add By QW20200108 BUG:QW0035 end �������
	
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
		messageShow("","","",t[Return]+"  "+t["01"]);   //Modified BY QW20181025 �����:729018
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
  	combindata=combindata+"^"+GetChkElementValue("ChangeTypeFlag") 
  	///add by QW 2019-08-31 �෽���� ����MultipleNum,MultipleDefineDR
    combindata=combindata+"^"  //RepeatNum Ԥ��
  	combindata=combindata+"^"+GetElementValue("MultipleNum") ;
  	combindata=combindata+"^"+GetElementValue("MultipleDefineDR") ;
  	///End  by QW 2019-08-31 �෽����
  	combindata=combindata+"^"+GetElementValue("ComponentSetID") ; //Add By QW20200108 BUG:QW0035 �������
 	
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
///hisui���� modify By QW 2018-08-31 HISUI����:���ӷ���ֵ,ȡ��LookUp�ض���,�������õ���
///����ֵ:ָ�����費���б���true,���򷵻�true
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
		return true;
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
		var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCApproveFlowAllow&Type=1&ApproveFlowDR="+ApproveFlowID;
    	SetWindowSize(str,1,"","",0,120,""); 		
	}
	else if (value=="3") //3:����������ת����
	{
		//
	}
	return false;
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
///hisui���� modify By QW 2018-08-31 HISUI����:���ӷ���ֵ,ȡ��LookUp�ض���,�������õ���
///����ֵ:ָ�����費���б���true,���򷵻�true
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
		return true;
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
		var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCApproveFlowAllow&Type=0&ApproveFlowDR="+ApproveFlowID;
    	SetWindowSize(str,1,"","",0,120,""); 		
	}
	else if (value=="3") //3:����������ת����
	{
		//
	}
	 return false;
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

///add by zx 2016-02-29 ZX0039
///hisui���� modify By QW 2018-08-31 HISUI����:���ӷ���ֵ,ȡ��LookUp�ض���,�������õ���
///����ֵ:���򷵻�true
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
		return false;
	}
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCApproveFlowAllow&Type=2&ApproveFlowDR="+ApproveFlowID;
    SetWindowSize(str,1,"","",0,120,"");
    return false;
}


///add by QW 2018-09-06
///hisui���� ��ϸ��ť�е���
///��Σ�rowData �б�json����
///      rowIndex �����
function TMethodHandler(rowData,rowIndex)  
{
	var val="&StepRowID="+rowData.TRowID; //Modified BY QW20181026 �����:723812
    var LinkComponentName="DHCEQCApproveAction";
    var str= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val
    showWindow(str,"��������","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
	
	
}

///add by QW 2018-09-06
///hisui���� ��ϸ��ť�е���
///��Σ�rowData �б�json����
///      rowIndex �����
function TFieldsHandler(rowData,rowIndex)  
{
	var val="&ApproveFlowDR="+rowData.TRowID;
 	var LinkComponentName="DHCEQCRoleReqFields";
    var str= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val 
    showWindow(str,"�ɱ༭�ֶ�","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}
///add by QW 2019-08-31 �෽����
///�෽�������� MultipleDefine:LookUpJSfunction
function GetMultipleDefine(Value)
{
	var list=Value.split("^");
	SetElement("MultipleDefineDR",list[3]);
}
///add by QW 2019-08-31 �෽����
function BMultipeDefine_click()
{
 	url="dhceq.em.multipledefine.csp?&ApproveType="+GetElementValue("ApproveTypeDR");
	showWindow(url,"�෽��������","","","icon-w-paper","modal","","","large")	
}
 ///Add By QW20200108 BUG:QW0035 ������÷Ŵ󾵸�ֵ
function GetComponentSet(Value)
{
	var list=Value.split("^");
	SetElement("ComponentSet",list[10]);
	SetElement("ComponentSetID",list[0]);
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
