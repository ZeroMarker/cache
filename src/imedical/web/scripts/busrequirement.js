var tableList=new Array();
var tEvaluate=new Array();
var CurApproveFlowID="";
//界面入口
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
	initPage();			//放大镜及按钮初始化
	var AssignDate=getElementValue("MRAssignDate");
	//刷新数据
	fillData()
	totalFee_Change()
	//按钮控制
	setEnabled()
	initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"),getElementValue("Action"));
	setElementEnabled();
	initApproveButton();
	//initButtonWidth()
	muilt_Tab()  //add by lmm 2020-06-29 回车下一输入框
	//点击维修配件也签刷新
	$HUI.tabs("#tMaintTabs",{
		onSelect:function(title)
		{
			if(title=="需求图片")
			{
				// MZY0080	1891466		2021-06-03
				var url='dhceq.plat.picturemenu.csp?&CurrentSourceType=31&CurrentSourceID='+getElementValue("RowID")+'&Status='+getElementValue("MRStatus")+'&Action='+getElementValue("Action")+"&MaintType="+getElementValue("MRMaintType")+'&ReadOnly=';
				if (getElementValue("ReadOnly")=="Y") url=url+"1";
				$('#MaintPic').attr('src', url);
			}
		}
	});
	//检测是否需要评价
	if (jQuery("#CheckEvaluate").length>0)
	{
		var EvaluateFlag=getElementValue("CheckEvaluate")
		var EvaluateFlagObj=JSON.parse(EvaluateFlag)
		if (EvaluateFlagObj.SQLCODE==0)
		{
			if (EvaluateFlagObj.Data.EvaluateStatus>=0)
			{
				//生成评价窗口
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
	//加载审批进度
	createApproveSchedule("ApproveSchedule","25",getElementValue("RowID"))
	//加载维修历史,知识库
	if ($("#tMaintHistorytree")){createMaintHistory(getElementValue("MRExObjDR_EQRowID"))}
	jQuery(window).resize(function(){window.location.reload()})
	var MaintType=getElementValue("MRMaintType")		//add by CZF0075 2020-02-25
	var Status=getElementValue("MRStatus");
	if (MaintType==1)
	{
		if ((Status=="")||(Status==0))
		{
			// MZY0080	1943263		2021-06-03	配件费不能编辑
			setDisableElements("MRRequestDate^MRAssignDR_UserName^MRAssignDate^MREmergencyLevelDR_ELDesc^MRSeverityLevelDR_SLDesc^MRMaintGroupDR_MGDesc^MRAcceptUserDR_UserName^MREstimateWorkHour^MRAcceptDate^MRMaintModeDR_MMDesc^MRServiceDR_SVName^MRFaultTypeDR_FTDesc^MRInsurFlag^MRFaultReasonDR_FRDesc^MRDealMethodDR_DMDesc^MREndDate^MRMaintResultsDR_MRDesc^MRFaultReasonRemark^MRDealMethodRemark^MRWorkHour^MRMaintFee^MRSaveCostFee^MRGuaranteePeriod^MRAccountDate^MRAssessment",false)
			singlelookup("MRAssignDR_UserName","PLAT.L.EQUser","","")		//20200318
		}
		setRequiredElements("MRAcceptUserDR_UserName^MRAcceptDate^MRWorkHour^MREndDate^MRDealMethodRemark^MRFaultReasonRemark^MRMaintModeDR_MMDesc^MRFaultTypeDR_FTDesc^MRMaintFee")
	}

	var observer = new MutationObserver(function(mutations) {
	    mutations.forEach(function(mutationRecord) {
	        $("#tMaintTabs>div").width($("#tMaintTabs").width()-2)
	    });    
	});
	setElement("MRMaintModeDR","1")
	setElement("MRMaintModeDR_MMDesc","保修")
	setElement("MRFaultReasonRemark","需求修改")
	setElement("MRDealMethodRemark","需求修改")
	var target = document.getElementById('tMaintTabs');
	//observer.observe(target, { attributes : true, attributeFilter : ['style'] });
}
function initPage()
{
	initLookUp();		//初始化放大镜
	defindTitleStyle();
	//设备名称放大镜显示前事件
	$("#MRExObjDR_ExObj").lookup({onBeforeShowPanel:function(){ return onBeforeShowPanel("MRExObjDR_ExObj");}})
	initButton(); 
	hiddenTab("#BSave^#BSubmit^#BDelete^#BPicture");///Modefidy by txr 2023-01-09 2807806
	if (jQuery("#BMaintUser").length>0)
	{
		jQuery("#BMaintUser").linkbutton({iconCls: 'icon-w-other'});  ///Modefidy by zc 2018-10-29 ZC0041  多人协助
		jQuery("#BMaintUser").click(function(){BMaintUser_Click()});  ///Modefidy by zc 2018-10-29 ZC0041  多人协助
	}
	//jQuery("#BSelfCancelSubmit").linkbutton({iconCls: 'icon-w-back'}); //Add By QW20210916 BUG:QW0150 增加图标  ///Modefidy by txr 2023-01-09 2807806 去图标
	var obj=document.getElementById("BSelfCancelSubmit");  //add by mwz 2021-01-18 MWZ0048
    if (obj) obj.onclick=BSelfCancelSubmit_Clicked;
	setElement("MRSourceType","1")
	setRequiredElements("MRExObjDR_ExObj^MRFaultCaseRemark^MRFaultTypeDR_FTDesc^MRRequestUserDR_UserName^MRRequestLocDR_LocDesc^MRRequestDate^MRRequestTel^MRMaintRemark")
	if (jQuery("#MRMaintFee").length>0)
	{
		jQuery("#MRMaintFee").change(function(){totalFee_Change()});
	}
	if (jQuery("#MROtherFee").length>0)
	{
		jQuery("#MROtherFee").change(function(){totalFee_Change()});
	}
	if (jQuery("#showOpinion").length>0)
	{
		jQuery("#showOpinion").on("click", BShowOpinion_Clicked);
	}
}

function setSelectValue(vElementID,rowData)
{
	if (vElementID=="MRObjLocDR_LocDesc")
	{
		setElement("MRObjLocDR",rowData.TRowID)
		setElement("MRRequestTel",rowData.TTel)
		setElement("MRExObjDR_ExObj","")	// MZY0063	1580308		2020-12-11
	}
	else if (vElementID=="MRExObjDR_ExObj")
	{
		rowData.TExType=1
		setElement("MRExObjDR_ExObj",rowData.TName);			//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQNo",rowData.TNo);
		setElement("MRExObjDR_EQModel",rowData.TModel);
		setElement("MRObjLocDR_LocDesc",rowData.TUseLoc);		//Modify DJ 2019-06-06  modified by wy 2021-5-6 1904435 选择设备带出使用科室
		setElement("MRObjLocDR",rowData.TUseLocDR);			//Modify DJ 2019-06-06
		//setElement("MRSourceType",rowData.TExType);			//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQOriginalFee",rowData.TOriginalFee);
		setElement("MRPlace",rowData.TLocation);
		setElement("MRExObjDR_EQFileNo",rowData.TFileNo);
		setElement("MRExObjDR_EQRowID",rowData.TRowID);
		setElement("MRObjTypeDR",rowData.TTypeDR);
		setElement("MREquipTypeDR",rowData.TEquipTypeDR);
		setElement("MRExObjDR_EQClassFlag",rowData.TClassFlag);		//Modify DJ 2019-06-27
		//来自设备时自动保存维护对象[待屏蔽]
		if ((getElementValue("MRSourceType")=="1")||(getElementValue("MRSourceType")=="2"))			//Modify DJ 2019-06-06
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AutoSaveExObj",rowData.TRowID)
			var jsonObj=JSON.parse(jsonData)
			if (jsonObj.SQLCODE<0) {messageShow("","","",jsonObj.Data);return;}
			setElement("MRExObjDR",jsonObj.Data)
		}
	}
	else if (vElementID=="MRAcceptUserDR_UserName")
	{
		setElement("MRAcceptUserDR",rowData.TUserdr)
		setElement("MRAcceptUserDR_Initials",rowData.TInitials)
		setElement("MRMaintGroupDR",rowData.TMaintGroupDR);
		setElement("MRMaintGroupDR_MGDesc",rowData.TMaintGroup);
	}
	else if (vElementID=="MRAssignDR_UserName"){setElement("MRAssignDR",rowData.TRowID)}		//20200318
	else if (vElementID=="MRRequestUserDR_UserName"){
		setElement("MRRequestUserDR",rowData.TRowID)
		setElement("MRRequestLocDR",rowData.TUserLocDR)
		setElement("MRRequestLocDR_LocDesc",rowData.TUserLoc)
		setElement("MRRequestTel",rowData.TMobilePhone)
	}
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
		setElement("MRAccessoryOriginalDR_AODesc","");
		setElement("MRAccessoryOriginalDR","");	
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
	//start by csj 20190125 台账链接填充设备及科室
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
				// add by zx 2019-02-19 ZX0057 台账报修保存失败处理
				setElement("MRExObjDR_EQNo",jsonData.Data["EQNo"]);
				setElement("MRExObjDR_EQModel",jsonData.Data["EQModelDR_MDesc"]);
				setElement("MRSourceType","1");  // '1'为设备
				setElement("MRExObjDR_EQOriginalFee",jsonData.Data["EQOriginalFee"]);
				setElement("MRPlace",jsonData.Data["EQLocationDR_LDesc"]);
				setElement("MRExObjDR_EQFileNo",jsonData.Data["EQFileNo"]);
				setElement("MRExObjDR_EQRowID",EquipDR);
				setElement("MRObjTypeDR","1");  // '1'为设备
				setElement("MREquipTypeDR",jsonData.Data["EQEquipTypeDR"]);
				setElement("MRExObjDR_EQClassFlag",jsonData.Data["EQClassFlag"]);		//Modify DJ 2019-06-27
				//来自设备时自动保存维护对象[待屏蔽]
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
	
	var ApproveListInfo=tkMakeServerCall("web.DHCEQApproveList","GetApproveByRource","25",RowID)
	FillEditOpinion(ApproveListInfo,"EditOpinion")
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
	if (Type=="0")  //没有保修
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
		//disableElement("BPicture",true)	// MZY0063	1580653		2020-12-11
		disableElement("BSelfCancelSubmit",true)   // add by mwz 2021-01-18 MWZ0048
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
	if ((Action=="WX_Assign")||(Action=="WX_Accept"))        //派单和受理时维修配件按钮不可用
	{
		disableElement("BMaintDetail",true)
		disableElement("BMaintUser",true)  ///Modefidy by zc 2018-10-29 ZC0041  多人协助
	}
	if (Status>0)
	{
		hiddenObj("BSave",1)
		hiddenObj("BSubmit",1)
		disableAllElements()
	}
	else
	{
		disableElement("BSelfCancelSubmit",true)   // add by mwz 2021-01-18 MWZ0048
		disableAllElements("MRObjLocDR_LocDesc^MRSourceType^MRExObjDR_ExObj^MREquipStatusDR_ESDesc^MRFaultCaseDR_FCDesc^MRFaultCaseRemark^MRStartDate^MRRequestUserDR_UserName^MRRequestTel^MRRequestDate^MRRequestLocDR_LocDesc^MRAccessoryOriginalDR_AODesc^MRRemark^MRFaultTypeDR_FTDesc^MRMaintRemark^MRAcceptUserDR_UserName")  //modify by lmm 2019-08-28 989278
	}
		if (Status!=2)
	{
		disableElement("BCancel",true)  //add by jyp 2020-03-12 JYP0023
		disableElement("BPrint",true)
	} 
	//Moidefied by zc0066 2020-4-11  生命周期链接按钮灰化 begin
	if (ReadOnly=="1")
	{
		disableElement("BCancel",true)
		disableElement("BPrint",true)
	}
	if (Status=="2")
	{
		disableElement("BSelfCancelSubmit",true)   // add by mwz 2021-01-18 MWZ0048
	}
	
	//Moidefied by zc0066 2020-4-11  生命周期链接按钮灰化 end
}

function setElementEnabled()
{
	var Status=getElementValue("MRStatus");
	var RoleStep=getElementValue("RoleStep");
	var Action=getElementValue("Action");
	var MaintType=getElementValue("MRMaintType")
	if (Status>0)	//提交之后
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

//////////////////////////////////业务处理函数/////////////////////////////////////////////
function BSave_Clicked()
{
	if (checkMustItemNull()) return

	var ExObjDR=getElementValue("MRExObjDR")
	if (ExObjDR=="")
	{
		messageShow("","","","设备名称不能为空,请选择设备!")
		return
	}
	bsavechecktrue("N")
}
function bsavechecktrue(MREquipStatusFlag)
{
	var combindata=getDataList();
	var Evaluate=""	
	var ReturnValue=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","UpdateMaintRequest",combindata,Evaluate,MREquipStatusFlag)
	var ReturnObj=JSON.parse(ReturnValue)
	if (ReturnObj.SQLCODE<0) 
	{
		messageShow("","","",ReturnObj.Data);
		return;
	}
	else
	{
		var data={"URowID":getElementValue("MRRequestUserDR"),"UMobilePhone":getElementValue("MRRequestTel"),"UActiveFlag":"Y"}
		data=JSON.stringify(data);
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTUser","SaveData",data,"");
		messageShow("","","",t[0])
	}
	//刷新界面
	//modifiedd by CZF0075 2020-02-25 begin
	var MaintType=getElementValue("MRMaintType");
	var src="dhceq.em.requirementsimple.csp?";
	if (MaintType==1)
	{
		src="dhceq.em.requirement.csp?";
	}
	var url=src+"&RowID="+ReturnObj.Data+"&CurRole="+getElementValue("CurRole")+"&ApproveRoleDR="+getElementValue("ApproveRoleDR")+"&QXType="+getElementValue("QXType")+"&MaintType="+MaintType;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url},50); 
	//modifiedd by CZF0075 2020-02-25 end
}
function BSubmit_Clicked()
{
	if (checkMustItemNull()) return
	var IRowID=getElementValue("RowID");
	if (IRowID=="")	{messageShow("","","",t[-9205]);return 0;}
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
	var src="dhceq.em.requirementsimple.csp?";
	if ((MaintType==1)||(SimpleFlag==""))
	{
		src="dhceq.em.requirement.csp?";
	}
	var url=src+"&RowID="+IRowID+"&CurRole="+getElementValue("CurRole")+"&MaintType="+MaintType;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url},50); 
	//modifiedd by CZF0075 2020-02-25 end
}
function BDelete_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")	{messageShow("","","",t[-9205]);	return;	}
	messageShow("confirm","info","提示",t[-9203],"",bdeletetrue,"")
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
	var src="dhceq.em.requirementsimple.csp?";
	if (MaintType==1)
	{
		src="dhceq.em.requirement.csp?";
	}
	var url=src+"&RowID=&Status=0&MaintType="+MaintType;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url},50); 
	//modifiedd by CZF0075 2020-02-25 end
}

function BCancelSubmit_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	if (getElementValue("RejectReason")=="")	
	{
		setFocus("RejectReason");
		messageShow('alert','error','提示',t[-9234])	
		return
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
		{field:'TAction',title:'动作',width:200,align:'center'},
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
	    var url="dhceq.em.requirement.csp?&RowID="+RtnObj.Data+"&CurRole="+getElementValue("CurRole");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}

function BApprove_Clicked()
{
	if (getElementValue("EditOpinion")=="")		
	{
		setFocus("EditOpinion");
		messageShow('alert','error','提示',t[-9233])	
		return
	}
	if (checkMustItemNull()) return
	var RowID=getElementValue("RowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	var MRWorkHour=getElementValue("MRWorkHour")
	if ((MRWorkHour!="")&&(MRWorkHour<0))	{messageShow("","","","实际工时小于0");	return;	}
	var MRMaintFee=getElementValue("MRMaintFee")
	if ((MRMaintFee!="")&&(MRMaintFee<0))	{messageShow("","","","人工费小于0");	return;	}
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
	//保存评价信息 Modify DJ 2015-08-28 DJ0159
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
		{field:'TAction',title:'动作',width:200,align:'center'},
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
			//激活评价窗口
			selectTab("tOtherTabs","tEvaluate")
			if (GetCheckEvaluateObj.Data.EIndependentFlag=="Y")
			{
				messageShow("confirm","info","提示",t[-9230],"","",bapprovestartstop)
			}
			else
			{
				messageShow("confirm","info","提示",t[-9231],"","",bapprovestartstop)
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
	var EditOpinion=getElementValue("EditOpinion")
  	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo,"",EditOpinion,"",EvaluatInfo);
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
	combindata=combindata+"^"+getElementValue("MRHold17") ;
	combindata=combindata+"^"+getElementValue("MRAccessoryOriginalDR") ;
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
				messageShow("confirm","info","提示",t[-9230],"",buserapprove,"")
			}
			else
			{
				messageShow("confirm","info","提示",t[-9231],"",buserapprove,"")
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
	var EditOpinion=getElementValue("EditOpinion")
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo,CurApproveFlowID,EditOpinion,"",EvaluatInfo);
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
		var url="dhceq.em.requirement.csp?&RowID="+RtnObj.Data+"&CurRole="+getElementValue("CurRole");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
    }
}
function getValueList()
{
	var ValueList="";
	ValueList=getElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+getElementValue("EvaluateGroup");
	ValueList=ValueList+"^^"+getElementValue("RejectReason");
	return ValueList;
}

function getEvaluateInfo()
{
	//主表
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
	//明细
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

//////////////////////////////////////功能处理函数///////////////////////////////////
///图片
function BPicture_Clicked()
{
	var Status=getElementValue("MRStatus");
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=31&CurrentSourceID='+getElementValue("RowID")+'&Status='+Status;
	if ((Status==2)||(getElementValue("ReadOnly")=="Y")) str=str+"&ReadOnly=1";		// MZY0063	1580653		2020-12-11
	var title="图片信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(str,title,width,height,icon,showtype,"","","middle"); //modify by lmm 2020-06-05 UI
}
///维修配件
function BMaintDetail_Click()
{
	var BRLRowID=getElementValue("RowID");
	if (BRLRowID=="")
	{
		messageShow("","","",t[-9205]);
		return;
	}
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+getElementValue("RowID")+'&MaintItemDR='+getElementValue("MaintItemDR")+'&Status='+getElementValue("Status");
    if (getElementValue("RoleStep")!=6) var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+getElementValue("RowID")+'&MaintItemDR='+getElementValue("MaintItemDR")+'&Status=0';		//非维修选择配件步骤
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=500,left=80,top=0')
}
///保修
function BSerContract_Click()
{
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&EquipDR="+getElementValue("MREXObjDR")+"&ReadOnly=1"
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
///设备信息
function BEquipInfo_Click()
{
	if (getElementValue("EQNo")=="") return;
  	var EQNo=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",getElementValue("EQNo"));
	if (EQNo=="") return;
	var str="dhceqequiplistnew.csp?&ReadOnly=1&RowID="+EQNo;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=980,height=800,left=200,top=10');
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function createEvaluateWin(vElementID,vEvaluationDR,vEReadOnly)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		//生成DIV前先清空原有内容
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
			//生成星号评价插件
			fStarEvaluate(id,1,starnum,true,escore,tHints,vEReadOnly);
//			if (escore>starnum)
//			{
//				jQuery("#"+id+"Score").text(starnum+"分")
//			}
//			else
//			{
//				jQuery("#"+id+"Score").text(escore+"分")
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
//		//历史维修记录
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
		//历史维修记录
		var flag=""
		if (key==MaxKey) flag=1
		var options={id:'tMaintHistorytree',section:'',item:'^^'+RequestDate+'%eq-user.png^^'+AcceptUser+'%eq-faultcase.png^^'+FaultCase,lastFlag:flag}
		createTimeLine(options)
		//知识库
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
//modify by wl 2019-12-16 WL0027 删除不必要的值,修正UserName,该界面加上直接打印方法报错
function BPrint_Clicked()
{
	var PreviewRptFlag=getElementValue("PreviewRptFlag");
	var RowID=getElementValue("RowID")
	var fileName=""	
	var HOSPDESC = getElementValue("GetHospitalDesc");
	//Add By QW20210913 BUG:QW0147 标题增加补打标记	begin
	var EQTitle="";
	var PrintNumFlag=getElementValue("PrintNumFlag");
	if(PrintNumFlag==1)  
	{
		var num=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","GetOperateTimes","31",RowID)
		if(num>0) EQTitle="(补打)";
	}
	if(PreviewRptFlag==1)
	{
		var fileName="DHCEQMMaintRequestPrint.raq&RowID="+RowID
			+"&HOSPDESC="+HOSPDESC
			+"&USERNAME="+curUserName+"&EQTitle="+EQTitle
			DHCCPM_RQPrint(fileName);
	}
	if(PreviewRptFlag==0)
	{
		var fileName="{DHCEQMMaintRequestPrint.raq(RowID="+RowID
			+";HOSPDESC="+HOSPDESC
			+";USERNAME="+curUserName
			+";EQTitle="+EQTitle+")}"; 
			DHCCPM_RQDirectPrint(fileName);
	}	
	var MaintRequestPrintOperateInfo="^31^"+RowID+"^^维修打印操作^0"
	var PrintFlag=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","SaveData",MaintRequestPrintOperateInfo)
	//Modified By QW20210913 BUG:QW0147 修改打印次数  end
}

function BEvaluate_Clicked()
{
	alertShow("待开发")
}
///Modefidy by zc 2018-10-29 ZC0041  多人协助
function BMaintUser_Click()
{
	var SourceID=getElementValue("RowID");
	if (SourceID=="")
	{
		alertShow("无设备维修申请信息!");
		return;
	}
	var para="SourceType=31&SourceID="+SourceID+"&Action="+getElementValue("Action")
    var url='dhceq.em.maintuserlist.csp?'+para;
    openModelDlg(url,"1200","650","维修协助人员","")
}
///add by jyp 2020-03-12 JYP0023
function BCancel_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")	{messageShow("","","",t[-9205]);	return;	}
	messageShow("confirm","info","提示",t[-9206],"",bcanceltrue,"")
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
	//Modeied by zc0094 2021-1-14 修正维修单作废页面问题 begin
	window.setTimeout(function()
	{	
		var url="";
		if (getElementValue("MRMaintType")!="1")
		{
			url= "dhceq.em.requirementsimple.csp?&RowID=&Status=0"
		}
		else
		{
			 url="dhceq.em.requirement.csp?&RowID=&Status=0&MaintType=1"
		}
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	},50); 
	//Modeied by zc0094 2021-1-14 修正维修单作废页面问题 end
}
function confirmselect(confirminfo)
{
	return messageShow("confirm","info","提示",confirminfo,"",selecttrue,selectfalse)
}

//add by mwz 2021-01-18 MWZ0048
function BSelfCancelSubmit_Clicked()
{
	var RowID=getElementValue("RowID");
	var Status=getElementValue("Status")
	
	if (Status>1)
	{
		messageShow('alert','error','提示',"该单据已审核完成,无法撤消");
		return;
		}
	var combindata=RowID+"^"+getElementValue("RoleStep")+"^"+getElementValue("Action")   /// Modify by mwz 20210529 MWZ0050
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SelfCancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
	  	messageShow("alert","info","提示","撤回成功");
		var val="&RowID="+RowID+"&QXType="+QXType+"&CurRole="+getElementValue("CurRole");
		var url=""
		if (getElementValue("CurRole")=="")
		{
			url="dhceq.em.requirementsimple.csp?"+val;	
		}
		else
		{
			url="dhceq.em.requirement.csp?"+val;	
		}
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
    else
    {
	     messageShow("alert","error","错误提示","错误信息:"+RtnObj.Data);
    }
}
function BShowOpinion_Clicked()
{
	url="dhceq.plat.approvelist.csp?&BussType=31&BussID="+getElementValue("RowID");
	showWindow(url,"维修审批进度","","","icon-w-paper","modal","","","middle");
}
function FillEditOpinion(value,ename)
{
	if (!value) return

	var list=value.split("^");
	var len=list.length;
	if (len<1) return;
	var CurRole=getElementValue("CurRole");
	if (CurRole=="")
	{
		var EditOpinion=list[len-1].split(",");
		setElement("EditOpinion",EditOpinion[2]);
	}
	else
	{
		for (var i=len-1;i>=0;i--)
		{
			var EditOpinion=list[i].split(",");
			if (CurRole==EditOpinion[0])
			{
				setElement("EditOpinion",EditOpinion[2])
				i=0;
			}
			else
			{
				setElement("EditOpinion","")
			}
		}
	}
}
