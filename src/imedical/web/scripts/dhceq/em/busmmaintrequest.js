var tableList=new Array();
var tEvaluate=new Array();
var CurApproveFlowID="";
//�������
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);

function initDocument()
{
	initUserInfo();
	initMessage("Maint");
	initPage();			//�Ŵ󾵼���ť��ʼ��
	initMRSourceTypeData();
	var AssignDate=getElementValue("MRAssignDate");
	//ˢ������
	fillData()
	totalFee_Change()
	//��ť����
	setEnabled()
	initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"),getElementValue("Action"));
	setElementEnabled();
	initApproveButton();
	initButtonWidth()
	muilt_Tab()  //add by lmm 2020-06-29 �س���һ�����
	var HiddenCostAllot=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503007")		//modified by czf 1251797 begin
	if ((HiddenCostAllot==0)||(HiddenCostAllot==""))
	{
		hiddenTab("tMaintTabs","tCostAllot");		//modified by czf 1251797 end
	}
	//���ά�����Ҳǩˢ��
	$HUI.tabs("#tMaintTabs",{
		onSelect:function(title)
		{
			if (title=="ά�����")
			{
				var AccessorySrc="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR="+getElementValue("RowID")+"&MaintItemDR="+getElementValue("MaintItemDR")+"&Status="+getElementValue("MRStatus")+"&MaintType="+getElementValue("MRMaintType");	//modified by CZF0075 2020-02-25
				if ((getElementValue("Action")!="")&&(getElementValue("Action")!="WX_Maint"))
				{
					AccessorySrc="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR="+getElementValue("RowID")+"&MaintItemDR="+getElementValue("MaintItemDR")+"&Status=0"+"&MaintType="+getElementValue("MRMaintType");		//modified by CZF0075 2020-02-25
				}
				$('#Accessory').attr('src', AccessorySrc);
			}
			if(title=="ά��ͼƬ")
			{
				$('#MaintPic').attr('src', 'dhceq.plat.picturemenu.csp?&CurrentSourceType=31&CurrentSourceID='+getElementValue("RowID")+'&Status='+getElementValue("MRStatus")+'&Action='+getElementValue("Action")+"&MaintType="+getElementValue("MRMaintType")+'&ReadOnly=');
			}
			if (title=="ά�޷��÷�̯")
			{
				var CostAllotSrc="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCostAllotNew&SourceID="+getElementValue("RowID")+"&Types=2"+"&EquipDR="+getElementValue("MRExObjDR_EQRowID")+"&Status="+getElementValue("MRStatus")+"&MaintType="+getElementValue("MRMaintType");	//addd by CZF0076 2020-02-26
				if ((getElementValue("Action")!="")&&(getElementValue("Action")!="WX_Maint"))
				{
					CostAllotSrc="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCostAllotNew&SourceID="+getElementValue("RowID")+"&Types=2"+"&EquipDR="+getElementValue("MRExObjDR_EQRowID")+"&Status=0"+"&MaintType="+getElementValue("MRMaintType");	
				}
				$('#CostAllot').attr('src', CostAllotSrc);
			}
		}
	});
	//����Ƿ���Ҫ����
	if (jQuery("#CheckEvaluate").length>0)
	{
		var EvaluateFlag=getElementValue("CheckEvaluate")
		var EvaluateFlagObj=JSON.parse(EvaluateFlag)
		if (EvaluateFlagObj.SQLCODE==0)
		{
			if (EvaluateFlagObj.Data.EvaluateStatus>=0)
			{
				//�������۴���
				var EReadOnly=false
				if (EvaluateFlagObj.Data.EvaluateStatus==1)
				{
					EReadOnly=true
				}
				createEvaluateWin("tEvaluateWin",EvaluateFlagObj.Data.EvaluationID,EReadOnly);
			}
		}
		else
		{
			hiddenTab("tOtherTabs","tEvaluate")
		}
	}
	//������������
	createApproveSchedule("ApproveSchedule","25",getElementValue("RowID"))
	//����ά����ʷ,֪ʶ��
	if ($("#tMaintHistorytree")){createMaintHistory(getElementValue("MRExObjDR_EQRowID"))}
	jQuery(window).resize(function(){window.location.reload()})
	var MaintType=getElementValue("MRMaintType")		//add by CZF0075 2020-02-25
	var Status=getElementValue("MRStatus");
	if (MaintType==1)
	{
		if ((Status=="")||(Status==0))
		{
			setDisableElements("MRRequestDate^MRAssignDR_UserName^MRAssignDate^MREmergencyLevelDR_ELDesc^MRSeverityLevelDR_SLDesc^MRMaintGroupDR_MGDesc^MRAcceptUserDR_UserName^MREstimateWorkHour^MRAcceptDate^MRMaintModeDR_MMDesc^MRServiceDR_SVName^MRFaultTypeDR_FTDesc^MRInsurFlag^MRFaultReasonDR_FRDesc^MRDealMethodDR_DMDesc^MREndDate^MRMaintResultsDR_MRDesc^MRFaultReasonRemark^MRDealMethodRemark^MRWorkHour^MRMaintFee^MROtherFee^MRSaveCostFee^MRGuaranteePeriod^MRAccountDate^MRAssessment",false)
			singlelookup("MRAssignDR_UserName","PLAT.L.EQUser","","")		//20200318
		}
		setRequiredElements("MRAcceptUserDR_UserName^MRAcceptDate^MRWorkHour^MREndDate^MRDealMethodRemark^MRFaultReasonRemark^MRMaintModeDR_MMDesc^MRFaultTypeDR_FTDesc^MRMaintFee")
	}
}

function initMRSourceTypeData()
{
	var MRSourceType = $HUI.combobox('#MRSourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '1',
				text: '�豸'
			},{
				id: '2',
				text: '����̨��'
			}],
		onSelect : function(){
			setElement("MRSourceTypeDR",getElementValue("MRSourceType")-1)
			setElement("MRExObjDR_ExObj","")		//Modify DJ 2019-06-06
			clearData("MRExObjDR_ExObj")			//Modify DJ 2019-06-06
			}
	});
	setElement("MRSourceType","1");  // '1'Ϊ�豸
	setElement("MRSourceTypeDR",0);
}
function initPage()
{
	initLookUp();		//��ʼ���Ŵ�
	defindTitleStyle();
	//�豸���ƷŴ���ʾǰ�¼�
	$("#MRExObjDR_ExObj").lookup({onBeforeShowPanel:function(){ return onBeforeShowPanel("MRExObjDR_ExObj");}})
	initButton();
	if (jQuery("#BMaintUser").length>0)
	{
		jQuery("#BMaintUser").linkbutton({iconCls: 'icon-w-other'});  ///Modefidy by zc 2018-10-29 ZC0041  ����Э��
		jQuery("#BMaintUser").click(function(){BMaintUser_Click()});  ///Modefidy by zc 2018-10-29 ZC0041  ����Э��
	}
	setElement("MRSourceType","1")
	setRequiredElements("MRObjLocDR_LocDesc^MRSourceType^MRExObjDR_ExObj^MRFaultCaseRemark")
	// Mozy0256		1221190		2020-3-13	��ʼ��ά�޷�ʽ������Ĭ�ϲ���Type
	var paramsFrom=[{"name":"MaintMode","type":"1","value":"MRMaintModeDR_MMDesc"},{"name":"Type","type":"2","value":"3"}];
    singlelookup("MRMaintModeDR_MMDesc","EM.L.MaintMode",paramsFrom,"");
	if (jQuery("#MRMaintFee").length>0)
	{
		jQuery("#MRMaintFee").change(function(){totalFee_Change()});
	}
	if (jQuery("#MROtherFee").length>0)
	{
		jQuery("#MROtherFee").change(function(){totalFee_Change()});
	}
}

function setSelectValue(vElementID,rowData)
{
	if (vElementID=="MRObjLocDR_LocDesc")
	{
		setElement("MRObjLocDR",rowData.TRowID)
		setElement("MRRequestTel",rowData.TTel)
	}
	else if (vElementID=="MRExObjDR_ExObj")
	{
		rowData.TExType=1
		setElement("MRExObjDR_ExObj",rowData.TName);			//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQNo",rowData.TNo);
		setElement("MRExObjDR_EQModel",rowData.TModel);
		//setElement("MRObjLocDR_LocDesc",rowData.TUseLoc);		//Modify DJ 2019-06-06
		//setElement("MRObjLocDR",rowData.TUseLocDR);			//Modify DJ 2019-06-06
		//setElement("MRSourceType",rowData.TExType);			//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQOriginalFee",rowData.TOriginalFee);
		setElement("MRPlace",rowData.TLocation);
		setElement("MRExObjDR_EQFileNo",rowData.TFileNo);
		setElement("MRExObjDR_EQRowID",rowData.TRowID);
		setElement("MRObjTypeDR",rowData.TTypeDR);
		setElement("MREquipTypeDR",rowData.TEquipTypeDR);
		setElement("MRExObjDR_EQClassFlag",rowData.TClassFlag);		//Modify DJ 2019-06-27
		//�����豸ʱ�Զ�����ά������[������]
		if ((getElementValue("MRSourceType")=="1")||(getElementValue("MRSourceType")=="2"))			//Modify DJ 2019-06-06
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AutoSaveExObj",rowData.TRowID)
			var jsonObj=JSON.parse(jsonData)
			if (jsonObj.SQLCODE<0) {messageShow("","","",jsonObj.Data);return;}
			setElement("MRExObjDR",jsonObj.Data)
		}
		var obj=document.getElementById("Banner");
		if (obj){$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+rowData.TRowID)}
	}
	else if (vElementID=="MRAcceptUserDR_UserName")
	{
		setElement("MRAcceptUserDR",rowData.TUserdr)
		setElement("MRAcceptUserDR_Initials",rowData.TInitials)
		setElement("MRMaintGroupDR",rowData.TMaintGroupDR);
		setElement("MRMaintGroupDR_MGDesc",rowData.TMaintGroup);
	}
	else if (vElementID=="MRAssignDR_UserName"){setElement("MRAssignDR",rowData.TRowID)}		//20200318
	else if (vElementID=="MRRequestUserDR_UserName"){setElement("MRRequestUserDR",rowData.TRowID)}
	else if (vElementID=="MREquipStatusDR_ESDesc"){setElement("MREquipStatusDR",rowData.TRowID)}
	else if (vElementID=="MRMaintModeDR_MMDesc"){setElement("MRMaintModeDR",rowData.TRowID)}
	else if (vElementID=="MRServiceDR_SVName"){setElement("MRServiceDR",rowData.TRowID)}
	else if (vElementID=="MRFaultTypeDR_FTDesc"){setElement("MRFaultTypeDR",rowData.TRowID)}
	else if (vElementID=="MRFaultReasonDR_FRDesc"){setElement("MRFaultReasonDR",rowData.TRowID)}
	else if (vElementID=="MRDealMethodDR_DMDesc"){setElement("MRDealMethodDR",rowData.TRowID)}
	else if (vElementID=="MRMaintResultsDR_MRDesc"){setElement("MRMaintResultsDR",rowData.TRowID)}
	else if (vElementID=="MRMaintGroupDR_MGDesc"){setElement("MRMaintGroupDR",rowData.TRowID)}
	else if (vElementID=="MREmergencyLevelDR_ELDesc"){setElement("MREmergencyLevelDR",rowData.TRowID)}
	else if (vElementID=="MRSeverityLevelDR_SLDesc"){setElement("MRSeverityLevelDR",rowData.TRowID)}
	else if (vElementID=="MRFaultCaseDR_FCDesc"){setElement("MRFaultCaseDR",rowData.TRowID)}
	else if (vElementID=="MRAccessoryOriginalDR_AODesc"){setElement("MRAccessoryOriginalDR",rowData.TRowID)}  //Modify by zx BUG ZX0077
}

function clearData(vElementID)
{
	var DRElementName=vElementID.split("_")[0]
	setElement(DRElementName,"")
	if (vElementID=="MRObjLocDR_LocDesc") 
	{
		setElement("MRRequestTel","")
		setElement("MRExObjDR_ExObj","");
		setElement("MRExObjDR","");
		clearData("MRExObjDR_ExObj")
	}
	else if (vElementID=="MRExObjDR_ExObj") 
	{
		//setElement("MRExObjDR_EQNo","");		//Modify DJ 2019-06-06
		//setElement("MRExObjDR_EQModel","");	//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQOriginalFee","");
		//setElement("MRPlace","");				//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQFileNo","");
		setElement("MRExObjDR_EQRowID","");
		setElement("MRObjTypeDR","");
		setElement("MREquipTypeDR","");
		setElement("MRExObjDR_EQClassFlag","");		//Modify DJ 2019-06-27
	}
	else if (vElementID=="MRAcceptUserDR_UserName")	
	{
		setElement("MRAcceptUserDR_Initials","");
	}
	else if (vElementID=="MRMaintGroupDR_MGDesc")	
	{
		setElement("MRAcceptUserDR_Initials","")
		setElement("MRAcceptUserDR_UserName","");
		setElement("MRAcceptUserDR","");
	}
}

function fillData()
{
	//start by csj 20190125 ̨����������豸������
	var EquipDR=getElementValue("MRExObjDR");
	var RowID=getElementValue("RowID");
	if ((EquipDR!="")&&(RowID==""))
	{
		$cm({
			ClassName:"web.DHCEQ.EM.BUSEquip",
			MethodName:"GetOneEquip",
			RowID:EquipDR
		},function(jsonData){
			if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
    			setElement("MRExObjDR_ExObj",jsonData.Data["EQName"]);
				setElement("MRObjLocDR",jsonData.Data["EQUseLocDR"]);
				setElement("MRObjLocDR_LocDesc",jsonData.Data["EQUseLocDR_CTLOCDesc"]);
				// add by zx 2019-02-19 ZX0057 ̨�˱��ޱ���ʧ�ܴ���
				setElement("MRExObjDR_EQNo",jsonData.Data["EQNo"]);
				setElement("MRExObjDR_EQModel",jsonData.Data["EQModelDR_MDesc"]);
				setElement("MRSourceType","1");  // '1'Ϊ�豸
				setElement("MRExObjDR_EQOriginalFee",jsonData.Data["EQOriginalFee"]);
				setElement("MRPlace",jsonData.Data["EQLocationDR_LDesc"]);
				setElement("MRExObjDR_EQFileNo",jsonData.Data["EQFileNo"]);
				setElement("MRExObjDR_EQRowID",EquipDR);
				setElement("MRObjTypeDR","1");  // '1'Ϊ�豸
				setElement("MREquipTypeDR",jsonData.Data["EQEquipTypeDR"]);
				setElement("MRExObjDR_EQClassFlag",jsonData.Data["EQClassFlag"]);		//Modify DJ 2019-06-27
				//�����豸ʱ�Զ�����ά������[������]
				var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AutoSaveExObj",EquipDR);
				var jsonObj=JSON.parse(jsonData);
				if (jsonObj.SQLCODE<0) {messageShow("","","",jsonObj.Data);return;};
				setElement("MRExObjDR",jsonObj.Data);
		});
	}
	//end by csj 20190125 
	var obj=document.getElementById("RowID");
	if (obj) var RowID=getElementValue("RowID");
	if (RowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetOneMaintRequest",RowID,ApproveRoleDR,Action,Step)
	var jsonObj=jQuery.parseJSON(jsonData)
	if (jsonObj.SQLCODE<0) {messageShow("","","",jsonObj.Data);return;}
	setElementByJson(jsonObj.Data)
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+getElementValue("MRExObjDR_EQRowID"))
	setContratByEquip(jsonObj.Data["MRExObjDR"])
    if (jsonObj.Data["MultipleRoleFlag"]=="1")
    {
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
}

function setContratByEquip(ExObjDR)
{
	var ContractInfo=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SetContrat",ExObjDR)
	var ContractObj=jQuery.parseJSON(ContractInfo)
	if (ContractObj.SQLCODE<0) {messageShow("","","",ContractObj.Data);return;} 
	var ValueList=ContractObj.Data
	var Value=ValueList.split("^");
	setSerContract(Value[0],Value[1],Value[2]);
}
function setSerContract(Type,StartDate,EndDate)
{
	if (Type=="0")  //û�б���
	{
		disableElement("BSerContract",true);
	}
	else
	{
		disableElement("BSerContract",false);
		var obj=document.getElementById("BSerContract");
		if (obj)
		{
			jQuery("#BSerContract").on("click", BSerContract_Click);
		}
	}
	setElement("MRMaintStartDate",StartDate);
	setElement("MRMaintEndDate",EndDate);
}


function setEnabled()
{
	var Status=getElementValue("MRStatus");
	var curRole=getElementValue("RoleStep");
	var nextRole=getElementValue("NextFlowStep");
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	if (ReadOnly=="Y")
	{
		disableElement("BSave",true)
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		disableElement("BPicture",true)
	}
	if(RowID=="")
	{
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		disableElement("BPicture",true)
	}
	if ((Status!=0)||((curRole!=0)&&(curRole!=nextRole)))
	{
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		disableElement("BSave",true)
	}
	var Action=getElementValue("Action")
	if ((Action=="WX_Assign")||(Action=="WX_Accept"))        //�ɵ�������ʱά�������ť������
	{
		disableElement("BMaintDetail",true)
		disableElement("BMaintUser",true)  ///Modefidy by zc 2018-10-29 ZC0041  ����Э��
	}
	if (Status>0)
	{
		hiddenObj("BSave",1)
		hiddenObj("BSubmit",1)
		disableAllElements()
	}
	else
	{
		disableAllElements("MRObjLocDR_LocDesc^MRSourceType^MRExObjDR_ExObj^MREquipStatusDR_ESDesc^MRFaultCaseDR_FCDesc^MRFaultCaseRemark^MRStartDate^MRRequestUserDR_UserName^MRRequestTel^MRPlace^MRPackageState")  //modify by lmm 2019-08-28 989278
	}
		if (Status!=2)
	{
		disableElement("BCancel",true)  //add by jyp 2020-03-12 JYP0023
		disableElement("BPrint",true)
	} 
	//Moidefied by zc0066 2020-4-11  �����������Ӱ�ť�һ� begin
	if (ReadOnly=="1")
	{
		disableElement("BCancel",true)
		disableElement("BPrint",true)
	}
	//Moidefied by zc0066 2020-4-11  �����������Ӱ�ť�һ� end
}

function setElementEnabled()
{
	var Status=getElementValue("MRStatus");
	var RoleStep=getElementValue("RoleStep");
	var Action=getElementValue("Action");
	var MaintType=getElementValue("MRMaintType")
	if (Status>0)	//�ύ֮��
	{
		if (Action=="WX_Assign")
		{
			if (MaintType!="1")
			{
				setElement("MRAssignDR_UserName",curUserName);
				setElement("MRAssignDR",curUserID);
				setElement("MRAssignDate",getElementValue("CurDate"));
			}
			disableElement("MRAssignDR_UserName",true)
			disableElement("MRAssignDate",true)
			disableElement("MRAcceptUserDR_Initials",true)
		}
		if ((Action=="WX_Accept")||(Action=="WX_Maint")||(Action=="WX_Finish"))
		{
			disableElement("MROtherFee",true)
			disableElement("MRTotalFee",true)
//			var result=getMaintNumForAffix();	//�Ϸ�ҽԺ��������
//			if (result!="")
//			{
//				result=result.replace("^","ά��");
//				result=result.replace(",","��,");
//				result=result+"��."
//				messageShow("","","",t[-600199]+"\n"+result);
//			}
			if (Action=="WX_Accept")	//(getElementValue("MRAcceptDate")=="")
			{
				disableElement("MRAcceptDate",true)
				setElement("MRAcceptDate",getElementValue("CurDate"));
			}
			if ((Action=="WX_Finish")&&(getElementValue("EndDate")==""))
			{
				disableElement("MREndDate",true)
				setElement("MREndDate",getElementValue("CurDate"));
			}
		}
	}
	else
	{
		if (MaintType!="1")
		{
			setElement("MRAssignDR_UserName","");
			setElement("MRAssignDR","");
			setElement("MRAssignDate","");
		}
	}
}

function getMaintNumForAffix()
{
	var AffixMaintInfo=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetMaintNumForAffix",getElementValue("RowID"))
	var AffixMaintObj=JSON.parse(AffixMaintInfo)
	if (AffixMaintObj.SQLCODE<0) {messageShow("","","",AffixMaintObj.Data);return;}
	return AffixMaintObj.Data
}

function totalFee_Change()
{
	var MaintFee=getElementValue("MRMaintFee")
	if (MaintFee=="") MaintFee=0
	MaintFee=parseFloat(MaintFee);
	var OtherFee=getElementValue("MROtherFee")
	if (OtherFee=="") OtherFee=0
	OtherFee=parseFloat(OtherFee);
	var tmpValue=(MaintFee.toFixed(2)*1)+(OtherFee.toFixed(2)*1);
	tmpValue=parseFloat(tmpValue);
	setElement("MRTotalFee",tmpValue.toFixed(2))
}

//////////////////////////////////ҵ������/////////////////////////////////////////////
function BSave_Clicked()
{
	if (checkMustItemNull()) return
	var ExObjDR=getElementValue("MRExObjDR")
	var SourceTypeDR=getElementValue("MRSourceType")
	//�洢����
	var RowID=getElementValue("RowID")
	var CheckValue=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CheckMaintProcess",SourceTypeDR,ExObjDR,RowID)
	var CheckObj=JSON.parse(CheckValue)
	if (CheckObj.SQLCODE<0) {messageShow("","","",CheckObj.Data);return;}
	if (CheckObj.Data["ReturnFlag"]=="1")
	{
		var CheckInfo=t[-5600]
		CheckInfo=CheckInfo.replace("[RequestUser]",CheckObj.Data["RequestUser"]);
		CheckInfo=CheckInfo.replace("[RequestDate]",CheckObj.Data["RequestDate"]);
		CheckInfo=CheckInfo.replace("[RequestNo]",CheckObj.Data["RequestNo"]);
		messageShow("confirm","info","��ʾ",CheckInfo,"",bsavechecktrue,"");
	}
	else
	{
		bsavechecktrue()
	}
}
function bsavechecktrue()
{
	var combindata=getDataList();
	var Evaluate=""	
	var ReturnValue=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","UpdateMaintRequest",combindata,Evaluate)
	var ReturnObj=JSON.parse(ReturnValue)
	if (ReturnObj.SQLCODE<0) 
	{
		messageShow("","","",ReturnObj.Data);
		return;
	}
	else
	{
		messageShow("","","",t[0])
	}
	//ˢ�½���
	//modifiedd by CZF0075 2020-02-25 begin
	var MaintType=getElementValue("MRMaintType");
	var src="dhceq.em.mmaintrequestsimple.csp?";
	if (MaintType==1)
	{
		src="dhceq.em.mmaintrequest.csp?";
	}
	window.setTimeout(function(){window.location.href=src+"&RowID="+ReturnObj.Data+"&CurRole="+getElementValue("CurRole")+"&ApproveRoleDR="+getElementValue("ApproveRoleDR")+"&QXType="+getElementValue("QXType")+"&MaintType="+MaintType},50); 
	//modifiedd by CZF0075 2020-02-25 end
}
function BSubmit_Clicked()
{
	if (checkMustItemNull()) return
	var IRowID=getElementValue("RowID");
	if (IRowID=="")	{messageShow("","","",t[-9205]);return 0;}
	var SourceTypeDR=getElementValue("MRSourceType")		//Modify DJ 2019-06-27
	var EQClassFlag=getElementValue("MRExObjDR_EQClassFlag")
	var GetStopEquipFlag=getElementValue("GetStopEquipFlag")
	var GetEQStopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","31",IRowID,"","2");
	if (((SourceTypeDR!=2)||(EQClassFlag!="Y"))&&(GetEQStopStartFlag==1))		//������̨�˷����⴦��ͣ������ Modify DJ 2019-06-27
	{
		if (GetStopEquipFlag==1)
		{
			messageShow("confirm","info","��ʾ",t[-9260],"",bstopstartture,bsubmit)
		}
		else if (GetStopEquipFlag==2)
		{
			bstopstartture()
		}
		else
		{
			bsubmit()
		}
	}
	else
	{
		bsubmit()
	}
}
function bstopstartture()
{
	var IRowID=getElementValue("RowID");
	var result=tkMakeServerCall("web.DHCEQ.Plat.BUSChangeInfo","StopEquipBySource","31",IRowID,"1");
	var resultObj=JSON.parse(result)
	if (resultObj.SQLCODE<0)	{messageShow("","","",t[-9200]+resultObj.Data);return;}
	bsubmit()
}
function bsubmit()
{
	var IRowID=getElementValue("RowID");
	var Ret=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SubmitMaintRequest",IRowID,"1",curUserID);
	var RetObj=JSON.parse(Ret)
	if (RetObj.SQLCODE<0) 
	{
		messageShow("","","",RetObj.Data)
		return 0;
	}
	messageShow("","","",t[0])
	var SimpleFlag=getElementValue("SimpleFlag");
	//modifiedd by CZF0075 2020-02-25 begin
	var MaintType=getElementValue("MRMaintType");
	var src="dhceq.em.mmaintrequestsimple.csp?";
	if ((MaintType==1)||(SimpleFlag==""))
	{
		src="dhceq.em.mmaintrequest.csp?";
	}
	window.setTimeout(function(){window.location.href=src+"&RowID="+IRowID+"&CurRole="+getElementValue("CurRole")+"&MaintType="+MaintType},50); 
	//modifiedd by CZF0075 2020-02-25 end
}
function BDelete_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")	{messageShow("","","",t[-9205]);	return;	}
	messageShow("confirm","info","��ʾ",t[-9203],"",bdeletetrue,"")
}
function bdeletetrue()
{
	var RowID=getElementValue("RowID")
	var Ret=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","DeleteMaintRequest",RowID)
	var RetObj=jQuery.parseJSON(Ret)
	if (RetObj.SQLCODE<0)
	{
		messageShow("","","",RetObj.Data)
		return;
	}
	messageShow("","","",t[0]);
	//modifiedd by CZF0075 2020-02-25 begin
	var MaintType=getElementValue("MRMaintType");
	var src="dhceq.em.mmaintrequestsimple.csp?";
	if (MaintType==1)
	{
		src="dhceq.em.mmaintrequest.csp?";
	}
	window.setTimeout(function(){window.location.href=src+"&RowID=&Status=0&MaintType="+MaintType},50); 
	//modifiedd by CZF0075 2020-02-25 end
}

function BCancelSubmit_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	var SourceTypeDR=getElementValue("MRSourceType")		//Modify DJ 2019-06-27
	var EQClassFlag=getElementValue("MRExObjDR_EQClassFlag")
	var GetStopEquipFlag=getElementValue("GetStopEquipFlag")
	var GetEQStopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","31",RowID,"","1");
	if (((SourceTypeDR!=2)||(EQClassFlag!="Y"))&&(GetEQStopStartFlag==1))		//������̨�˷����⴦��ͣ������ Modify DJ 2019-06-27
	{
		if (GetStopEquipFlag==1)
		{
			messageShow("confirm","info","��ʾ",t[-9261],"",bcancelstopstarttrue,bcancelsubmit)
		}
		else if (GetStopEquipFlag==2)
		{
			bcancelstopstarttrue()
		}
		else
		{
			bcancelsubmit()
		}
	}
	else
	{
		bcancelsubmit()
	}
}
function bcancelstopstarttrue()
{
	var RowID=getElementValue("RowID")
	var result=tkMakeServerCall("web.DHCEQ.Plat.BUSChangeInfo","StopEquipBySource","31",RowID,"0");
	var resultObj=JSON.parse(result)
	if (resultObj.SQLCODE<0)
	{
		messageShow("","","",t[-9200]+resultObj.Data)
		return;
	}
	bcancelsubmit()
}
function bcancelsubmit()
{
	var RowID=getElementValue("RowID")
	var CurRole=getElementValue("CurRole")
	var RoleStep=getElementValue("RoleStep")
	var RowID=getElementValue("RowID");
	var ApproveTypeCode="25";
	var Type="1";
	var GotoType=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveFlow","GetApproveFlowType",RowID,CurRole,ApproveTypeCode,Type,RoleStep)
	var GotoTypeObj=JSON.parse(GotoType)
	setElement("ApproveTypeCode","25");
	setElement("Type","1")
	if (GotoTypeObj.Data==2)
	{
		var vParams={
			ClassName:"web.DHCEQCApproveFlow",
			QueryName:"GetUserApproves",
			Arg1:getElementValue("RowID"),
			Arg2:getElementValue("CurRole"),
			Arg3:getElementValue("ApproveTypeCode"),
			Arg4:getElementValue("Type"),
			Arg5:getElementValue("RoleStep"),
			ArgCnt:5
			};
		var vcolumns=[[
		{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
		{field:'TRoleDR',title:'TRoleDR',width:50,align:'center',hidden:true},
		{field:'TRole',title:'TRole',width:50,align:'center',hidden:true},
		{field:'TStep',title:'TStep',width:50,align:'center',hidden:true},
		{field:'TAction',title:'����',width:200,align:'center'},
		]];
		initApproveFlowGrid("ApproveFlowWin","tApproveFlowGrid",vParams,vcolumns,1)
		jQuery('#ApproveFlowWin').window('open');
		return ;	
	}

	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
	    window.setTimeout(function(){window.location.href="dhceq.em.mmaintrequest.csp?&RowID="+RtnObj.Data+"&CurRole="+getElementValue("CurRole")},50); 
    }
}

function BApprove_Clicked()
{
	if (checkMustItemNull()) return
	var RowID=getElementValue("RowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	var MRWorkHour=getElementValue("MRWorkHour")
	if ((MRWorkHour!="")&&(MRWorkHour<0))	{messageShow("","","","ʵ�ʹ�ʱС��0");	return;	}
	var MRMaintFee=getElementValue("MRMaintFee")
	if ((MRMaintFee!="")&&(MRMaintFee<0))	{messageShow("","","","�˹���С��0");	return;	}
	var GetFaultReasonOperMethod=getElementValue("GetFaultReasonOperMethod");
  	var FaultReasonDR=getFaultReasonRowID(GetFaultReasonOperMethod);
  	if (FaultReasonDR<0) return;
  	setElement("MRFaultReasonDR",FaultReasonDR);
  	var GetDealMethodOperMethod=getElementValue("GetDealMethodOperMethod");
  	var DealMethodDR=getDealMethodRowID(GetDealMethodOperMethod);
  	if (DealMethodDR<0) return;
  	setElement("MRDealMethodDR",DealMethodDR);
  	var GetFaultTypeOperMethod=getElementValue("GetFaultTypeOperMethod");
  	var FaultTypeDR=getFaultTypeRowID(GetFaultTypeOperMethod);
  	if (FaultTypeDR<0) return;
  	setElement("MRFaultTypeDR",FaultTypeDR);
	//����������Ϣ Modify DJ 2015-08-28 DJ0159
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
	var Action=getElementValue("Action")
	var RowID=getElementValue("RowID");
	var ApproveTypeCode="25";
	var Type="0";
	var GotoType=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveFlow","GetApproveFlowType",RowID,CurRole,ApproveTypeCode,Type,RoleStep)
	var GotoTypeObj=JSON.parse(GotoType)
	setElement("ApproveTypeCode","25");
	setElement("Type","0");
	if (GotoTypeObj.Data==2)
	{
		var vParams={
			ClassName:"web.DHCEQCApproveFlow",
			QueryName:"GetUserApproves",
			Arg1:getElementValue("RowID"),
			Arg2:getElementValue("CurRole"),
			Arg3:getElementValue("ApproveTypeCode"),
			Arg4:getElementValue("Type"),
			Arg5:getElementValue("RoleStep"),
			ArgCnt:5
			};
		var vcolumns=[[
		{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
		{field:'TRoleDR',title:'TRoleDR',width:50,align:'center',hidden:true},
		{field:'TRole',title:'TRole',width:50,align:'center',hidden:true},
		{field:'TStep',title:'TStep',width:50,align:'center',hidden:true},
		{field:'TAction',title:'����',width:200,align:'center'},
		]];
		initApproveFlowGrid("ApproveFlowWin","tApproveFlowGrid",vParams,vcolumns,0)
		jQuery('#ApproveFlowWin').window('open');
		return;	
	}
	var EvaluatInfo=""
	var GetCheckEvaluate=checkEvaluate("31",RowID,CurRole,"","","",Action)
	setElement("CheckEvaluate",GetCheckEvaluate)
	var GetCheckEvaluateObj=JSON.parse(GetCheckEvaluate)
	if (GetCheckEvaluateObj.SQLCODE==0)
	{
		EvaluatInfo=getEvaluateInfo();
		var EvaluatScore=EvaluatInfo.split("@")
		if ((GetCheckEvaluateObj.Data.EvaluateStatus==0)&&(EvaluatScore[0]==0))
		{
			//�������۴���
			selectTab("tOtherTabs","tEvaluate")
			if (GetCheckEvaluateObj.Data.EIndependentFlag=="Y")
			{
				messageShow("confirm","info","��ʾ",t[-9230],"","",bapprovestartstop)
			}
			else
			{
				messageShow("confirm","info","��ʾ",t[-9231],"","",bapprovestartstop)
			}
		}
		else
		{
			bapprovestartstop()
		}
	}
	else
	{
		if (GetCheckEvaluateObj.SQLCODE==-9031)
		{
			messageShow("","","",GetCheckEvaluateObj.Data)
			return
		}
		else
		{
			bapprovestartstop()
		}
	}
}
function bapprovestartstop()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	var SourceTypeDR=getElementValue("MRSourceType")
	var EQClassFlag=getElementValue("MRExObjDR_EQClassFlag")
	var GetStopEquipFlag=getElementValue("GetStopEquipFlag")
	var Action=getElementValue("Action")
	var GetEQStopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","31",RowID,"","1");
	if (((SourceTypeDR!=2)||(EQClassFlag!="Y"))&&(GetEQStopStartFlag==1)&&(Action=="WX_Finish"))		//������̨�˷����⴦��ͣ������ Modify DJ 2019-06-27
	{
		if (GetStopEquipFlag==1)
		{
			messageShow("confirm","info","��ʾ",t[-9261],"",bapprovestartstoptrue,bapprove)
		}
		else if (GetStopEquipFlag==2)
		{
			bapprovestartstoptrue()
		}
		else
		{
			bapprove()
		}
	}
	else
	{
		bapprove()
	}
}
function bapprovestartstoptrue()
{
	var RowID=getElementValue("RowID")
	var result=tkMakeServerCall("web.DHCEQ.Plat.BUSChangeInfo","StopEquipBySource","31",RowID,"0");
	var resultObj=JSON.parse(result)
	if (resultObj.SQLCODE<0)
	{
		messageShow("","","",t[-9200]+resultObj.Data)
		return;
	}
	bapprove()
}
function bapprove()
{
	var CurRole=getElementValue("CurRole")
	var RoleStep=getElementValue("RoleStep")
	var EvaluatInfo=getEvaluateInfo();
	var objtbl=getParentTable("MRRequestNo")
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	var combindata=getValueList();
  	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo,"","","",EvaluatInfo);
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	    window.setTimeout(function(){window.location.reload()},50); 
    }
}

function getDataList()
{
	var FaultCaseDR=getFaultCaseRowID(getElementValue("GetFaultCaseOperMethod"))
	if (FaultCaseDR<0){FaultCaseDR=""}
	var FaultReasonDR=getFaultReasonRowID(getElementValue("GetFaultReasonOperMethod"))
	if (FaultReasonDR<0){FaultReasonDR=""}
	var DealMethodDR=getDealMethodRowID(getElementValue("GetDealMethodOperMethod"))
	if (DealMethodDR<0){DealMethodDR=""}
	var FaultTypeDR=getFaultTypeRowID(getElementValue("GetFaultTypeOperMethod"))
	if (FaultTypeDR<0){FaultTypeDR=""}
	var combindata="";
  	combindata=getElementValue("RowID") ;
	combindata=combindata+"^"+getElementValue("MRRequestNo") ;
	combindata=combindata+"^"+getElementValue("MRManageTypeDR") ;
	combindata=combindata+"^"+getElementValue("MREquipTypeDR") ;
	combindata=combindata+"^"+getElementValue("MRObjTypeDR") ;
	combindata=combindata+"^"+getElementValue("MRExObjDR") ;
	combindata=combindata+"^"+getElementValue("MRObjLocDR") ;
	combindata=combindata+"^"+getElementValue("MRRequestLocDR") ;
	combindata=combindata+"^"+getElementValue("MRStartDate") ;
	combindata=combindata+"^"+getElementValue("MRStartTime") ;	//10
	combindata=combindata+"^"+FaultCaseDR;
	combindata=combindata+"^"+getElementValue("MRFaultCaseRemark") ;
	combindata=combindata+"^"+FaultReasonDR;
	combindata=combindata+"^"+getElementValue("MRFaultReasonRemark") ;
	combindata=combindata+"^"+DealMethodDR;
	combindata=combindata+"^"+getElementValue("MRDealMethodRemark") ;
	combindata=combindata+"^"+getElementValue("MREndDate") ;
	combindata=combindata+"^"+getElementValue("MREndTime") ;
	combindata=combindata+"^"+getElementValue("MRRequestDate") ;
	combindata=combindata+"^"+getElementValue("MRRequestTime") ;	//20
	combindata=combindata+"^"+getElementValue("MRRequestUserDR") ;
	combindata=combindata+"^"+getElementValue("MRRequestTel") ;
	combindata=combindata+"^"+getElementValue("MRPlace") ;
	combindata=combindata+"^"+FaultTypeDR;
	combindata=combindata+"^"+getElementValue("MRAcceptDate") ;
	combindata=combindata+"^"+getElementValue("MRAcceptTime") ;
	combindata=combindata+"^"+getElementValue("MRAcceptUserDR") ;
	combindata=combindata+"^"+getElementValue("MRAssignDR") ;
	combindata=combindata+"^"+getElementValue("MRMaintModeDR") ;	//29
	if (getElementValue("MRMaintModeDR")==3)
	{
	    combindata=combindata+"^"+"^"+getElementValue("MRMaintModeWayDR")+"^" ;
	}
    else if (getElementValue("MRMaintModeDR")==2)
    {
        combindata=combindata+"^"+"^"+"^"+getElementValue("MRMaintModeWayDR") ;
    }
    else
    {
        combindata=combindata+"^"+getElementValue("MRMaintModeWayDR")+"^"+"^" ;
    }
	combindata=combindata+"^"+getElementValue("MRUserSignDR") ;
	combindata=combindata+"^"+getElementValue("MRUserOpinion") ;
	combindata=combindata+"^"+getElementValue("MRManageLocDR") ;
	var obj = document.getElementById("ReturnFlag") ;
	if (obj){combindata=combindata+"^"+getElementValue("ReturnFlag");}
	else combindata=combindata+"^"+"N" ;
	combindata=combindata+"^"+getElementValue("MRMaintRequestDR") ;
	combindata=combindata+"^"+getElementValue("MRMaintRemark") ;
	combindata=combindata+"^"+getElementValue("MREstimateWorkHour") ;
	combindata=combindata+"^"+getElementValue("MRWorkHour") ;	//40
	combindata=combindata+"^"+getElementValue("MRRemark") ;
	combindata=combindata+"^"+getElementValue("MRStatus") ;
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+getElementValue("MRInvalidFlag") ;
	combindata=combindata+"^"+getElementValue("MRMaintFee") ;
	combindata=combindata+"^"+getElementValue("MROtherFee") ;
	combindata=combindata+"^"+getElementValue("MRTotalFee") ;
	combindata=combindata+"^"+getElementValue("MREmergencyLevelDR") ;
	combindata=combindata+"^"+getElementValue("MRSeverityLevelDR") ;
	combindata=combindata+"^"+getElementValue("MRSourceType") ;
	combindata=combindata+"^"+getElementValue("MRAssignDate") ;
	combindata=combindata+"^"+getElementValue("MRPackageState") ;
	combindata=combindata+"^"+getElementValue("MRInsurFlag") ;
	combindata=combindata+"^"+getElementValue("MRMaintResultsDR") ;
	combindata=combindata+"^"+getElementValue("MREquipStatusDR") ;
	combindata=combindata+"^"+getElementValue("MRMaintProcessDR") ;
	combindata=combindata+"^"+getElementValue("MRGuaranteePeriod") ;	//add by CZF0072 2020-02-25 begin
	combindata=combindata+"^"+getElementValue("MRAccountDate") ;
	combindata=combindata+"^"+getElementValue("MRAssessment") ;		//add by CZF0072 2020-02-25 end
	combindata=combindata+"^"+getElementValue("MRMaintType") ;		//add by CZF0075 2020-02-25
	combindata=combindata+"^"+getElementValue("MRMaintGroupDR") ;	//20200318
	combindata=combindata+"^"+getElementValue("MRServiceDR") ;		//20200318
	combindata=combindata+"^"+getElementValue("MRSaveCostFee") ;		//20200328
	
    return combindata;
}

function dataGridSelect(vType,vRowData)
{
	if (vType==0)
	{
		var vDataStr=vRowData.TRowID+"^"+vRowData.TRoleDR+"^"+vRowData.TRole+"^"+vRowData.TStep+"^"+vRowData.TAction
		getUserApprove(vDataStr)
	}
	if (vType==1)
	{
		var vDataStr=vRowData.TRowID+"^"+vRowData.TRoleDR+"^"+vRowData.TRole+"^"+vRowData.TStep+"^"+vRowData.TAction
		getUserCancelApprove(vDataStr)
	}
}

function getUserApprove(Value)
{
	var list=Value.split("^");
	var ApproveFlowID=list[0];
	CurApproveFlowID=list[0];
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
	var Action=getElementValue("Action")
	var RowID=getElementValue("RowID")
	var objtbl=getParentTable("MRRequestNo")
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	var EvaluatInfo=""
	var GetCheckEvaluate=checkEvaluate("31",RowID,CurRole,"","","",Action)
	setElement("CheckEvaluate",GetCheckEvaluate)
	var GetCheckEvaluateObj=JSON.parse(GetCheckEvaluate)
	if (GetCheckEvaluateObj.SQLCODE==0)
	{
		EvaluatInfo=getEvaluateInfo();
		var EvaluatScore=EvaluatInfo.split("@")
		if ((GetCheckEvaluateObj.Data.EvaluateStatus==0)&&(EvaluatScore[0]==0))
		{
			selectTab("tOtherTabs","tEvaluate")
			if (GetCheckEvaluateObj.Data.EIndependentFlag=="Y")
			{
				messageShow("confirm","info","��ʾ",t[-9230],"",buserapprove,"")
			}
			else
			{
				messageShow("confirm","info","��ʾ",t[-9231],"",buserapprove,"")
			}
		}
		else
		{
			buserapprove()
		}
	}
	else
	{
		if (GetCheckEvaluateObj.SQLCODE==-9031)
		{
			messageShow("","","",GetCheckEvaluateObj.Data)
			return
		}
		else
		{
			buserapprove()
		}
	}
}
function buserapprove()
{
	var CurRole=getElementValue("CurRole")
	var RoleStep=getElementValue("RoleStep")
	var objtbl=getParentTable("MRRequestNo")
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	var EvaluatInfo=getEvaluateInfo();
	var combindata=getValueList();
	var MaintProcess=getElementValue("MaintProcess");
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo,CurApproveFlowID,MaintProcess,"",EvaluatInfo);
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	    window.setTimeout(function(){window.location.reload()},50);
    }
}

function getUserCancelApprove(Value)
{
	var list=Value.split("^");
	setElement("CancelToFlowDR",list[0]);
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	    window.setTimeout(function(){window.location.href="dhceq.em.mmaintrequest.csp?&RowID="+RtnObj.Data+"&CurRole="+getElementValue("CurRole")},50);
    }
}
function getValueList()
{
	var ValueList="";
	ValueList=getElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+getElementValue("EvaluateGroup");
	
	return ValueList;
}

function getEvaluateInfo()
{
	//����
	var EInfo=""
	var GetEvaInfo=getElementValue("CheckEvaluate")
	var GetEvaInfoObj=JSON.parse(GetEvaInfo)
	if (GetEvaInfoObj.SQLCODE<0) return ""
	if (GetEvaInfoObj.Data.EvaluateStatus!=0) return ""
	var EvaluationDR=GetEvaInfoObj.Data.EvaluationID
	var RowID=getElementValue("RowID")
	var CurRole=getElementValue("CurRole")
	var Action=getElementValue("Action")
	var User=curUserID
	var EInfo="^31^"+RowID+"^^"+CurRole+"^^^^^^^"+Action+"^^"+EvaluationDR
	//��ϸ
	var EListInfo=""
	var EvaScoreSum=0
	var EvaCount=tEvaluate.length
	for (var i=0;i<EvaCount;i++)
	{
		var EvaInfo=tEvaluate[i].split("^")
		var EvaElement=EvaInfo[0]
		var ELRowID=EvaInfo[1]
		var EvaTypeDR=EvaInfo[2]
		var EvaGroupDR=EvaInfo[3]
		var EvaScore=jQuery("#"+EvaElement).raty("score")
		if (EvaScore==undefined) EvaScore=0
		EvaScoreSum=EvaScoreSum+EvaScore
		if (EListInfo!="")
		{
			EListInfo=EListInfo+"*"+"^"+ELRowID+"^"+EvaTypeDR+"^"+EvaScore+"^^"+EvaGroupDR
		}
		else
		{
			EListInfo="^"+ELRowID+"^"+EvaTypeDR+"^"+EvaScore+"^^"+EvaGroupDR
		}
	}
	return EvaScoreSum+"@"+EInfo+"@"+EListInfo
}

//////////////////////////////////////���ܴ�����///////////////////////////////////
///ͼƬ
function BPicture_Clicked()
{
	var Status=getElementValue("MRStatus");
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=31&CurrentSourceID='+getElementValue("RowID")+'&Status='+Status;
	if (Status==2) str=str+"&ReadOnly=1";
	var title="ͼƬ��Ϣ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(str,title,width,height,icon,showtype,"","","middle"); //modify by lmm 2020-06-05 UI
}
///ά�����
function BMaintDetail_Click()
{
	var BRLRowID=getElementValue("RowID");
	if (BRLRowID=="")
	{
		messageShow("","","",t[-9205]);
		return;
	}
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+getElementValue("RowID")+'&MaintItemDR='+getElementValue("MaintItemDR")+'&Status='+getElementValue("Status");
    if (getElementValue("RoleStep")!=6) var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+getElementValue("RowID")+'&MaintItemDR='+getElementValue("MaintItemDR")+'&Status=0';		//��ά��ѡ���������
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=500,left=80,top=0')
}
///����
function BSerContract_Click()
{
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&EquipDR="+getElementValue("MREXObjDR")+"&ReadOnly=1"
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
///�豸��Ϣ
function BEquipInfo_Click()
{
	if (getElementValue("EQNo")=="") return;
  	var EQNo=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",getElementValue("EQNo"));
	if (EQNo=="") return;
	var str="dhceqequiplistnew.csp?&ReadOnly=1&RowID="+EQNo;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=980,height=800,left=200,top=10');
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function createEvaluateWin(vElementID,vEvaluationDR,vEReadOnly)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		//����DIVǰ�����ԭ������
		jQuery("#"+vElementID).empty();
		if (vEReadOnly==false)
		{
			var GetEvaluateInfo=tkMakeServerCall("web.DHCEQ.EM.BUSEvaluate","GetEvaluateInfo",vEvaluationDR);
		}
		else
		{
			var GetEvaluateInfo=tkMakeServerCall("web.DHCEQ.EM.BUSEvaluate","GetUserEvaluateInfo",vEvaluationDR);
		}
		var GetEvaluateObj=JSON.parse(GetEvaluateInfo)
		var MLEvaluateInfo=GetEvaluateObj.Data.split("&")
		var GetEvaluateMaster=MLEvaluateInfo[0]
		var GetEvaluateList=MLEvaluateInfo[1]
		var EvaluateInfo=GetEvaluateList.split("@")
		var table=jQuery("<table>");
	 	table.appendTo(jQuery("#"+vElementID));
		for (var i=0;i<EvaluateInfo.length;i++)
		{
			var OneEvaluateInfo=EvaluateInfo[i].split("^")
			var caption=OneEvaluateInfo[2]+":"
			var id="StarEvaluate"+(i+1)
			var starnum=OneEvaluateInfo[3]
			var escore=OneEvaluateInfo[6]
			var tHints=new Array();
			if (OneEvaluateInfo[4]!="")
			{
				var HintsInfo=OneEvaluateInfo[4].split(",")
				for (var j=0;j<HintsInfo.length;j++)
				{
					tHints.push(HintsInfo[j])
				}
			}
			var tr=jQuery("<tr height=\"30px\">")
			tr.appendTo(table);
			var td="<td align=\"right\">"+caption+"</td>"
			td=td+"<td><div id=\""+id+"\" style=\"margin-left:5px;\"></div></td>"
			//td=td+"<td><lable id=\""+id+"Score\"></lable></td>"
			td=jQuery(td)
			td.appendTo(tr);
			var trend=jQuery("</tr>")
			trend.appendTo(table);
			//�����Ǻ����۲��
			fStarEvaluate(id,1,starnum,true,escore,tHints,vEReadOnly);
//			if (escore>starnum)
//			{
//				jQuery("#"+id+"Score").text(starnum+"��")
//			}
//			else
//			{
//				jQuery("#"+id+"Score").text(escore+"��")
//			}
			tEvaluate[i]=id+"^"+OneEvaluateInfo[0]+"^"+OneEvaluateInfo[1]+"^"+OneEvaluateInfo[5];
		}
		jQuery("#"+vElementID).append("</table>");
	}
}

function linkClick()
{
	selectTab("tOtherTabs","tMaintBuss")
}
function createMaintHistory(vEQRowID)
{
	if (vEQRowID=="") return
	var MaintHistory=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetMaintHistory",vEQRowID)
	var MaintHistoryObj=jQuery.parseJSON(MaintHistory)
	if (MaintHistoryObj.SQLCODE<0) return
	var MaxKey=""
	for (var key in MaintHistoryObj.Data){MaxKey=key}
	for (var key in MaintHistoryObj.Data)
	{
		var RowID="MaintHistoryID"+key
		var OntMaintInfo=MaintHistoryObj.Data[key]
		var RequestDate=OntMaintInfo["RequestDate"]
		var RequestUser=OntMaintInfo["RequestUser"]
		var FaultCaseDR=OntMaintInfo["FaultCaseDR"]
		var FaultCase=OntMaintInfo["FaultCase"]
		var FaultReasonDR=OntMaintInfo["FaultReasonDR"]
		var FaultReason=OntMaintInfo["FaultReason"]
		var DealMethodDR=OntMaintInfo["DealMethodDR"]
		var DealMethod=OntMaintInfo["DealMethod"]
		var AcceptUser=OntMaintInfo["AcceptUser"]
//		//��ʷά�޼�¼
//		var treeObj=$("#tMaintHistorytree").tree("find",RowID)
//		if (!treeObj)
//		{
//			var childdata=[{"id":RowID+"_U","text":RequestUser},{"id":RowID+"_F","text":FaultCase}]
//			var treedata=[{"id":RowID,"text":RequestDate,"children":childdata}]
//			$("#tMaintHistorytree").tree('append', {data:treedata});
//			
//			$("#tMaintHistory").find("span").removeClass("tree-folder")
//			var spanobj=$("#tMaintHistory").find("span.tree-icon")
//			spanobj.eq(0).attr("class","")
//			spanobj.eq(1).prev().attr("class","")
//			spanobj.eq(1).attr("class","tree-file")
//			spanobj.eq(2).prev().attr("class","")
//			spanobj.eq(2).attr("class","tree-file")
//		}
		//��ʷά�޼�¼
		var flag=""
		if (key==MaxKey) flag=1
		var options={id:'tMaintHistorytree',section:'',item:'^^'+RequestDate+'%eq-user.png^^'+AcceptUser+'%eq-faultcase.png^^'+FaultCase,lastFlag:flag}
		createTimeLine(options)
		//֪ʶ��
		if (FaultCaseDR!="")
		{
			var KnowledgeF="Knowledge_"+FaultCaseDR
			var FaultCaseObj=appendTree("tKnowledgetree","Knowledge_"+FaultCaseDR,FaultCase,"")
			if ((FaultCaseObj!=null)&&(FaultReasonDR!=""))
			{
				var KnowledgeR=KnowledgeF+"_"+FaultReasonDR
				var FaultReasonObj=appendTree("tKnowledgetree",KnowledgeR,FaultReason,KnowledgeF)
				if ((FaultReasonObj!=null)&&(DealMethodDR!=""))
				{
					var KnowledgeD=KnowledgeR+"_"+DealMethodDR
					appendTree("tKnowledgetree",KnowledgeD,DealMethod,KnowledgeR)
				}
			}
			//$("#tKnowledge").find("span").removeClass("tree-folder tree-file")
		}
	}
}
function onBeforeShowPanel(vElementID)
{
	if (vElementID=="MRExObjDR_ExObj")
	{
		setElement("MRSourceTypeDR",0)
		if (getElementValue("MRSourceType")!="1"){setElement("MRSourceTypeDR",1)}
		if (getElementValue("MRObjLocDR")=="")
		{
			var Info=t[-9202]
			Info=Info.replace("[Caption]",getElementValue("cMRObjLocDR_LocDesc"));
			messageShow("","","",Info)
			return false
		}
	}
	return true
}
// add by sjh 2019-12-03 BUG00018 
//modify by wl 2019-12-16 WL0027 ɾ������Ҫ��ֵ,����UserName,�ý������ֱ�Ӵ�ӡ��������
function BPrint_Clicked()
{
	var PreviewRptFlag=getElementValue("PreviewRptFlag");
	var RowID=getElementValue("RowID")
	var fileName=""	
	var HOSPDESC = getElementValue("GetHospitalDesc");
	if(PreviewRptFlag==1)
	{
		var fileName="DHCEQMMaintRequestPrint.raq&RowID="+RowID
			+"&HOSPDESC="+HOSPDESC
			+"&USERNAME="+curUserName
			DHCCPM_RQPrint(fileName);
	}
	if(PreviewRptFlag==0)
	{
		var fileName="{DHCEQMMaintRequestPrint.raq(RowID="+RowID
			+";HOSPDESC="+HOSPDESC
			+";USERNAME="+curUserName
			+")}";
			DHCCPM_RQDirectPrint(fileName);
	}	
}

function BEvaluate_Clicked()
{
	alertShow("������")
}
///Modefidy by zc 2018-10-29 ZC0041  ����Э��
function BMaintUser_Click()
{
	var SourceID=getElementValue("RowID");
	if (SourceID=="")
	{
		alertShow("���豸ά��������Ϣ!");
		return;
	}
	var para="SourceType=31&SourceID="+SourceID+"&Action="+getElementValue("Action")
    var url='dhceq.em.maintuserlist.csp?'+para;
    openModelDlg(url,"1200","650","ά��Э����Ա","")
}
///add by jyp 2020-03-12 JYP0023
function BCancel_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")	{messageShow("","","",t[-9205]);	return;	}
	messageShow("confirm","info","��ʾ",t[-9206],"",bcanceltrue,"")
}
function bcanceltrue()
{
	var RowID=getElementValue("RowID")
	var Ret=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelMaintRequest",RowID)
	var RetObj=jQuery.parseJSON(Ret)
	if (RetObj.SQLCODE<0)
	{
		messageShow("","","",RetObj.Data)
		return;
	}
	messageShow("","","",RetObj.Data);
	window.setTimeout(function(){window.location.href= "dhceq.em.mmaintrequestsimple.csp?&RowID=&Status=0"},50); 
}
function confirmselect(confirminfo)
{
	return messageShow("confirm","info","��ʾ",confirminfo,"",selecttrue,selectfalse)
}