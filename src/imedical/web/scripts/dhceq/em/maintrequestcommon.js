/**
 * 维修单据信息加载
 * @param {String} 无
 * @returns 无
 * @author zx 2022-08-11
 */
function fillData()
{
	var mrRowID=getElementValue("MRRowID");
	if(mrRowID=="") return;
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	var actionCode=getElementValue("ActionCode");
	var step=getElementValue("RoleStep")  //modified by wy 2023-4-6 3418652流程可中断时未取到对应按钮
	if(actionCode=="Cancel") //modify by zyq 2022-11-20
	{
	 	var jsonObj=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest", "GetOneMaintRequest",mrRowID,"","","");
	}
	else //modify by zyq 2022-11-20
	{
		var jsonObj=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest", "GetOneMaintRequest",mrRowID,"",actionCode,step);
	}
	jsonObj=jQuery.parseJSON(jsonObj);
	if (jsonObj.SQLCODE<0) {messageShow("","","",jsonObj.Data);return;}
	var jsonData = jsonObj.Data;
	//modified by ZY20230215 bug:3267279
	ObjData=jsonData;
	setElementByJson(jsonData);
	//申请时长
	var requestLength="已申请"+daysBetween(jsonData["MRRequestDate"], jsonData["MRRequestTime"]);
	//故障现象
	var faultCaseInfo="";
	if(jsonData["MRFaultCaseDR_FCDesc"]!="") faultCaseInfo=jsonData["MRFaultCaseDR_FCDesc"];
	if(jsonData["MRFaultCaseRemark"]!="")
	{
		if (faultCaseInfo!="") faultCaseInfo=faultCaseInfo+"，";
		faultCaseInfo=faultCaseInfo+jsonData["MRFaultCaseRemark"];
	}
	if (jsonData["MRExObjDR_EQClassFlag"]=="Y")
	{
		setElement("MRExObjDR_EQNo","");
	}
	if(actionCode==""){
		if(getElementValue("MRStatus")=="0"){
			$("#savebutton").css('display','flex');
			$("#submitbutton").css('display','none');
		}
	}else if(actionCode=="WX_Assign"){
		if(jsonData["MRExObjDR_GuaranteeDays"]=="0"){
			$("#GuaranteeFlag").css('display','none');
		}else{
			setElement("MRGuaranteeDays",jsonData["MRExObjDR_GuaranteeDays"]);
			setElement("MRGuaranteeHours",jsonData["MRExObjDR_GuaranteeHours"]);
			setElement("MRGuaranteePeriod",jsonData["MRExObjDR_GuaranteeBeginDate"]+"~"+jsonData["MRExObjDR_GuaranteeEndDate"]);
		}
		setElement("MRRequestLength",requestLength);
		if(jsonData["MRExObjDR_EQClassFlag"]!="Y"){
			setElement("#MRExObjDR_ExObjInfo",jsonData["MRExObjDR_ExObj"]+"["+jsonData["MRExObjDR_EQNo"]+"]");
		}
		setElement("MRFaultCaseInfo",faultCaseInfo);
		var requestUser=(jsonData["MRRequestUserDR_UserName"]=="")?"":jsonData["MRRequestUserDR_UserName"]+"("+jsonData["MRRequestTel"]+")";
		setElement("MRRequestUser",requestUser);
		var requestDateInfo=jsonData["MRRequestDate"]+" "+jsonData["MRRequestTime"];
		setElement("MRRequestDateInfo",requestDateInfo);
		setElement("MRPicNum",jsonData["MRPicNum"]);
		var location=(jsonData["MRLocationDR_LDesc"]=="")?jsonData["MRRequestLocDR_LocDesc"]:jsonData["MRRequestLocDR_LocDesc"]+"-"+jsonData["MRLocationDR_LDesc"];
		setElement("MRLocationDR_LDesc",location);
	}else if((actionCode=="WX_Maint")||(actionCode=="WX_Appearance")||(actionCode=="WX_Finish")){
		if(jsonData["MRMaintModeDR"]==""){
			setElement("MRMaintModeDR","10");
			setElement("MRMaintModeDR_MMDesc","自修");
		}
		if(jsonData["MRExObjDR_EQClassFlag"]=="Y"){
			$("#ServiceEquipInfo").hide();
		}
		setElement("MRExObjDR_ExObjInfo",jsonData["MRExObjDR_ExObj"]);
		setElement("MRFaultCaseInfo",faultCaseInfo);
		var requestUser=(jsonData["MRRequestUserDR_UserName"]=="")?"":jsonData["MRRequestUserDR_UserName"]+"("+jsonData["MRRequestTel"]+")";
		setElement("MRRequestUser",requestUser);
		var requestDateInfo=jsonData["MRRequestDate"]+" "+jsonData["MRRequestTime"];
		setElement("MRRequestDateInfo",requestDateInfo);
		setElement("MRPicNum",jsonData["MRPicNum"]);
	}else if(actionCode=="WX_Evaluate"){
		setElement("MRRequestLength",requestLength);
	}else if((actionCode=="WX_LocAudit")||(actionCode=="WX_ManageLocAudit")){
		setElement("MRRequestLength",requestLength);
		setElement("MRFaultCaseInfo",faultCaseInfo);
		var requestUser=(jsonData["MRRequestUserDR_UserName"]=="")?"":jsonData["MRRequestUserDR_UserName"]+"("+jsonData["MRRequestTel"]+")";
		setElement("MRRequestUser",requestUser);
		var requestDateInfo=jsonData["MRRequestDate"]+" "+jsonData["MRRequestTime"];
		setElement("MRRequestDateInfo",requestDateInfo);
		setElement("MREndDateTime",jsonData["MREndDate"]+" "+jsonData["MREndTime"]);
		if(isPc){
			setElement("MROtherFee",jsonData["MROtherFee"]);
			setElement("MRMaintFee",jsonData["MRMaintFee"]);
			setElement("MRSaveCostFee",jsonData["MRSaveCostFee"]);
		}else{
			setElement("MROtherFee",jsonData["MROtherFee"]);  //modified by wy 2023-3-3 3327266 总费用显示为“NAN”
			setElement("MRMaintFee",jsonData["MRMaintFee"]);
			setElement("MRSaveCostFee","节省费用："+jsonData["MRSaveCostFee"]);
		}
	}else if(actionCode=="WX_Retrieve"){
		setElement("MRRequestLength",requestLength);
		setElement("MRFaultCaseInfo",faultCaseInfo);
		var requestUser=(jsonData["MRRequestUserDR_UserName"]=="")?"":jsonData["MRRequestUserDR_UserName"]+"  "+jsonData["MRRequestTel"];
		setElement("MRRequestUser",requestUser);
		var requestDateInfo=jsonData["MRRequestDate"]+" "+jsonData["MRRequestTime"];
		setElement("MRRequestDateInfo",requestDateInfo);
	}else if(actionCode=="WX_Return"){
		setElement("MRRequestLength",requestLength);
		setElement("MRFaultCaseInfo",faultCaseInfo);
		var requestUser=(jsonData["MRRequestUserDR_UserName"]=="")?"":jsonData["MRRequestUserDR_UserName"]+"("+jsonData["MRRequestTel"]+")";
		setElement("MRRequestUser",requestUser);
		var requestDateInfo=jsonData["MRRequestDate"]+" "+jsonData["MRRequestTime"];
		setElement("MRRequestDateInfo",requestDateInfo);
		setElement("MREndDateTime",jsonData["MREndDate"]+" "+jsonData["MREndTime"]);
		setElement("MROtherFee",jsonData["MROtherFee"]); //modified by wy 2023-3-3 3327266 总费用显示为“NAN”
		setElement("MRMaintFee",jsonData["MRMaintFee"]);
		setElement("MRSaveCostFee","节省费用："+jsonData["MRSaveCostFee"]);
	}// add by zyq begin 2022-11-20
	else if((actionCode=="Submit")||(actionCode=="Cancel")){
		disableAllElements()
		initApproveButton()
		//initApproveList()
		//createMaintHistory(mrRowID)
	}// add by zyq end 2022-11-20
	if(isPc){
		/*if (getElementValue("MRSourceType")=="3")
		{
			$('#MREquipDR_EQName').combotree('setValue',jsonObj.Data["MREquipDR_EQName"]);
		}else{
			setElement("MREquipDR_EQName",jsonObj.Data["MREquipDR_EQName"])
		}*/
		setElement("MREquipDR_EQName",jsonObj.Data["MREquipDR_EQName"]);
		//$('#MRRequestLocDR_LocDesc').combotree('setValue',jsonObj.Data["MRRequestLocDR_LocDesc"]);
		if(jsonObj.Data["MRStatus"]!=""){
		    $("#StatusText").text("修");
		}
	}
	if (jsonObj.Data["MultipleRoleFlag"]=="1")
    {	
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
}
/**
 * 维修保存事件响应方法
 * @param {String} 无
 * @returns 无
 * @author zx 2022-08-11
 */
function BSave_Clicked()
{
	if (checkMustItemNull()) return
	//判断控制费用不能包含非数字类型字符串
	var maintFee=Number(getElementValue("MRMaintFee"))
	var otherFee=Number(getElementValue("MROtherFee"))
	var saveCostFee=Number(getElementValue("MRSaveCostFee"))
	var maintType=getElementValue("MRMaintType");
	if(((isNaN(maintFee))||(isNaN(otherFee))||(isNaN(saveCostFee)))&&(maintType=="1"))
	{
		messageShow("","","","费用类型要为数值类型！")
		return
	} 
	//存储数据
	var sourceTypeDR=getElementValue("MRSourceType")
	var equipDR=getElementValue("MREquipDR")
	var rowID=getElementValue("MRRowID")
	// 泛类设备时不判断是否占用
	if (sourceTypeDR!="3")
	{
		var checkValue=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CheckMaintProcess",sourceTypeDR,equipDR,rowID);
		var checkObj=JSON.parse(checkValue)
		if (checkObj.SQLCODE<0) {messageShow("","","",checkObj.Data);return;}
		if (checkObj.Data["ReturnFlag"]=="1")
		{
			var checkInfo=t[-5600]
			checkInfo=checkInfo.replace("[RequestUser]",checkObj.Data["RequestUser"]);
			checkInfo=checkInfo.replace("[RequestDate]",checkObj.Data["RequestDate"]);
			checkInfo=checkInfo.replace("[RequestNo]",checkObj.Data["RequestNo"]);
			messageShow("confirm","info","提示",checkInfo,"",checkEquipStatus,"");
		}
		else
		{
			checkEquipStatus()
		}
	}
	else 
	{
		checkEquipStatus()
	}
}

function checkEquipStatus()
{
	var equipStatus=getElementValue("MREquipStatusDR");
	//设备状态异常停用设备，先判断设备是否已停用
	var equipDR=getElementValue("MREquipDR");
	var classFlag=getElementValue("MRExObjDR_EQClassFlag");
	var stopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","","",equipDR,"2");
	if ( (equipStatus>1)&&(stopStartFlag==1)&&(classFlag!="Y"))
	{
		messageShow("confirm","info","提示","设备状态异常是否停用设备？","",function(){
			isCheckEquipStatus("Y")
		},function(){
			isCheckEquipStatus("N")
		})
	}
	else
	{
		isCheckEquipStatus("N")
	}
}
function isCheckEquipStatus(equipStatusFlag)
{
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	if(isPc){
		var faultCaseDR=getFaultCaseRowID(getElementValue("GetFaultCaseOperMethod"))
		if (faultCaseDR<0){faultCaseDR=""}
		setElement("MRFaultCaseDR",faultCaseDR);
		var faultReasonDR=getFaultReasonRowID(getElementValue("GetFaultReasonOperMethod"))
		if (faultReasonDR<0){faultReasonDR=""};
		setElement("MRFaultReasonDR",faultReasonDR);
		var dealMethodDR=getDealMethodRowID(getElementValue("GetDealMethodOperMethod"))
		if (dealMethodDR<0){dealMethodDR=""}
		setElement("MRDealMethodDR",dealMethodDR);
		var faultTypeDR=getFaultTypeRowID(getElementValue("GetFaultTypeOperMethod"))
		if (faultTypeDR<0){faultTypeDR=""}
		setElement("MRFaultTypeDR",faultTypeDR);
		var serviceDR=""
	  	var type=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","201006")
		var serviceDR=getServiceRowID(type,"MRServiceDR","MRServiceDR_SVName");
		if (serviceDR<0){serviceDR=""}
		setElement("MRServiceDR",serviceDR);
		var LocationDR=getLocationRowID(getElementValue("GetLocationOperMethod"))  //add by wy 2023-2-21 3316395
		if (LocationDR<0){LocationDR=""}
		setElement("MRLocationDR",LocationDR);

	}
	// add by zyq 2022-11-30 begin 添加派单人信息
	MRAssignDR =getElementValue("MRAssignDR")
	MRAssignDRUserName=getElementValue("MRAssignDR_UserName")
	ActionCode=getElementValue("ActionCode")
	if((MRAssignDR=="")&&(MRAssignDRUserName=="")&&(ActionCode=="")){
		setElement("MRAssignDR",curUserID);
		setElement("MRAssignDR_UserName",curUserName);
	}//// add by zyq 2022-11-30 end
	
	var data=getInputList();
	
	data=JSON.stringify(data);
	var returnValue=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SaveData",data,"",equipStatusFlag,'0',"");
	var returnObj=JSON.parse(returnValue);
	if (returnObj.SQLCODE<0)
	{
		messageShow("","","",returnObj.Data);
		return;
	}
	if(!SubmitFlag)
	{
		if(isPc){
			//刷新界面
			var maintType=getElementValue("MRMaintType"); //0或空：科室报修，1：工程师报修
			var qxType=getElementValue("QXType")  //0：值班员,2：科室
			var src="dhceq.em.mainttabsnew.csp?";
			if(qxType==0)
			{
				if((maintType==1)) src="dhceq.em.maintrequestengineer.csp?";  //工程师
				else src="dhceq.em.mainttabsnew.csp?";  //值班员
			}else{
				src="dhceq.em.mainttabsnew.csp?"; //临床科室
			}
			src += "&RowID="+returnObj.Data+"&CurRole="+getElementValue("CurRole")+"&ApproveRoleDR="+getElementValue("ApproveRoleDR")+"&QXType="+qxType+"&MaintType="+maintType;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				src += "&MWToken="+websys_getMWToken()
			}
			window.setTimeout(function(){window.location.href=src},50);
		}else{
			location.reload();
		}
	}
	else{
		setElement("MRRowID",returnObj.Data);
		BSubmit_Clicked();
	}
}
/**
 * 维修提交事件响应方法
 * @param {String} 无
 * @returns 无
 * @author zx 2022-08-11
 */
function BSubmit_Clicked()
{ 
	if (checkMustItemNull()) return;
	var rowID=getElementValue("MRRowID");
	//rowid为空时先保存数据
    if (rowID==""){
    	SubmitFlag=true;
		BSave_Clicked();
		return;
	}
	//if (IRowID=="")	{messageShow("","","",t[-9205]);return 0;}
	var sourceTypeDR=getElementValue("MRSourceType");
	var classFlag=getElementValue("MRExObjDR_EQClassFlag");
	var stopEquipFlag=getElementValue("GetStopEquipFlag");
	var stopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","31",rowID,"","2");
	if (((sourceTypeDR==1)&&(classFlag!="Y"))&&(stopStartFlag==1))		//除简易台账范类外处理停用启用
	{
		if (stopEquipFlag==1)
		{
			messageShow("confirm","info","提示",t[-9260],"",stopStartTrue,doSubmit);
		}
		else if (stopEquipFlag==2)
		{
			stopStartTrue();
		}
		else
		{
			doSubmit();
		}
	}
	else
	{
		doSubmit();
	}

}
function stopStartTrue()
{
	var rowID=getElementValue("MRRowID");
	var result=tkMakeServerCall("web.DHCEQ.Plat.BUSChangeInfo","StopEquipBySource","31",rowID,"1");
	var resultObj=JSON.parse(result);
	if (resultObj.SQLCODE<0)	{messageShow("","","",t[-9200]+resultObj.Data);return;}
	doSubmit();
}
function doSubmit()
{
	var rowID=getElementValue("MRRowID");
	var resultObj=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SubmitMaintRequest",rowID,"1",curUserID);
	resultObj=JSON.parse(resultObj);
	if (resultObj.SQLCODE<0) 
	{
		messageShow("","","",resultObj.Data);
		return 0;
	}
	messageShow("","","",t[0]);
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	if(isPc)
	{
		var maintType=getElementValue("MRMaintType");
		var src="dhceq.em.mainttabsnew.csp?";
		var qxType=getElementValue("QXType");
		if(qxType==0)
		{
			if((maintType==1)) src="dhceq.em.maintrequestengineer.csp?";  //工程师
			else src="dhceq.em.mainttabsnew.csp?";  //值班员
		}else{
			src="dhceq.em.mainttabsnew.csp?"; //临床科室
		}
		src += "&CurRole="+getElementValue("CurRole")+"&MaintType="+maintType+"&QXType="+qxType
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			src += "&MWToken="+websys_getMWToken()
		}
		window.setTimeout(function(){window.location.href=src},50);  //modified by wy 2022-11-30
	}
	else{
		//messageShow("","","提示",'单据提交成功!');
		var jsonData=resultObj.Data;
		var storage=window.localStorage;
		var requestImgFlag=storage.getItem("ImgFlag31");
		requestImgFlag=(requestImgFlag==""||requestImgFlag==undefined||requestImgFlag==null)?"":requestImgFlag;
		if(requestImgFlag=="1")
		{
			//更新图片来源id
			var imgIDs=storage.getItem("ImgIDs31");
			imgIDs=(imgIDs==""||imgIDs==undefined||imgIDs==null)?"":imgIDs;
			if(imgIDs!="")
			{
				bindImg(imgIDs,"0","提交",rowID);
			}
		}else{
			var src=getCookieValue("domainName")+getCookieValue("project")+"/director/main";
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				src += "&MWToken="+websys_getMWToken()
			}
			window.location.href=src;
		}
	}
}
/**
 * 维修删除事件响应方法
 * @param {String} 无
 * @returns 无
 * @author zx 2022-08-11
 */
function BDelete_Clicked()
{
	var rowID=getElementValue("MRRowID");
	if (rowID=="")
	{
		messageShow("","","",t[-9205]);
		return;
	}
	messageShow("confirm","info","提示",t[-9203],"",doDelete,"");
}
function doDelete()
{
	var rowId=getElementValue("MRRowID");
	var resultObj=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","DeleteMaintRequest",rowId);
	resultObj=jQuery.parseJSON(resultObj);
	if (resultObj.SQLCODE<0)
	{
		messageShow("","","",resultObj.Data);
		return;
	}
	messageShow("","","",t[0]);
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	if(isPc){
		var maintType=getElementValue("MRMaintType");
		var src="dhceq.em.mainttabsnew.csp?";  
		var qxType=getElementValue("QXType");
		if(qxType==0)
		{
			if((maintType==1)) src="dhceq.em.maintrequestengineer.csp?";  //工程师
			else src="dhceq.em.mainttabsnew.csp?";  //值班员
		}else{
			src="dhceq.em.mainttabsnew.csp?"; //临床科室
		}
		src += "&RowID=&Status=0&MaintType="+maintType
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			src += "&MWToken="+websys_getMWToken()
		}
		window.setTimeout(function(){window.location.href=src},50);
	}else{
		var src = getCookieValue("domainName")+getCookieValue("project")+"/director/main"
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			src += "&MWToken="+websys_getMWToken()
		}
		window.location.href=src;
	}
}

/**
 * 维修审核事件响应方法
 * @param {String} 无
 * @returns 无
 * @author zx 2022-08-11
 */
function BApprove_Clicked()
{
	if (checkMustItemNull()) return
	var rowID=getElementValue("MRRowID")
	if (rowID=="")  {messageShow("","","",t[-9205]);	return;	}
	var workHour=getElementValue("MRWorkHour")
	if ((workHour!="")&&(workHour<0))	{messageShow("","","","实际工时小于0");	return;	}
	var maintFee=getElementValue("MRMaintFee")
	if ((maintFee!="")&&(maintFee<0))	{messageShow("","","","人工费小于0");	return;	}
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	if(isPc){
		var getFaultReasonOperMethod=getElementValue("GetFaultReasonOperMethod");
	  	var faultReasonDR=getFaultReasonRowID(getFaultReasonOperMethod);
	  	if (faultReasonDR<0) return;
	  	setElement("MRFaultReasonDR",faultReasonDR);
	  	var getDealMethodOperMethod=getElementValue("GetDealMethodOperMethod");
	  	var dealMethodDR=getDealMethodRowID(getDealMethodOperMethod);
	  	if (dealMethodDR<0) return;
	  	setElement("MRDealMethodDR",dealMethodDR);
	  	var getFaultTypeOperMethod=getElementValue("GetFaultTypeOperMethod");
	  	var faultTypeDR=getFaultTypeRowID(getFaultTypeOperMethod);
	  	if (faultTypeDR<0) return;
	  	setElement("MRFaultTypeDR",faultTypeDR);
	  	var type=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","201006");
		var serviceDR=getServiceRowID(type,"MRServiceDR","MRServiceDR_SVName");
		if (serviceDR<0){serviceDR=""}
	}
	var toActionCode=getElementValue("ToActionCode");
	if(toActionCode!=""){
		approveEquipStop();
	}else{
		var action=getElementValue("ActionCode")
	  	if (action=="") return;
		var rowId=getElementValue("MRRowID");
		var approveTypeCode="25";
		var type="0";
		if (getElementValue("MRDisuesdFlag")!=true) 
		{
			var gotoType=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveFlow","GetApproveFlowType",rowId,"",approveTypeCode,type,"",action);
			var gotoTypeObj=JSON.parse(gotoType);
			if(isPc){
				setElement("ApproveTypeCode","25");
				setElement("Type","0");
				if (gotoTypeObj.Data==2)
				{
					var vParams={
						ClassName:"web.DHCEQCApproveFlow",
						QueryName:"GetUserApproves",
						Arg1:getElementValue("MRRowID"),
						Arg2:getElementValue("CurRole"),
						Arg3:getElementValue("ApproveTypeCode"),
						Arg4:getElementValue("Type"),
						Arg5:getElementValue("RoleStep"),
						Arg6:getElementValue("ActionCode"),
						ArgCnt:6
					};
					var vcolumns=[[
						{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
						{field:'TRoleDR',title:'TRoleDR',width:50,align:'center',hidden:true},
						{field:'TRole',title:'TRole',width:50,align:'center',hidden:true},
						{field:'TStep',title:'TStep',width:50,align:'center',hidden:true},
						{field:'TAction',title:'动作',width:200,align:'center'}
					]];
					var ApproveFlowData=$cm({
						ClassName:"web.DHCEQCApproveFlow",
						QueryName:"GetUserApproves",
						SourceID:getElementValue("RowID"),
						CurRoleDR:getElementValue("CurRole"),
						ApproveTypeCode:getElementValue("ApproveTypeCode"),
						Type:getElementValue("Type"),
						CurStep:getElementValue("RoleStep"),
						Action:getElementValue("ActionCode")
					},false);
					if (ApproveFlowData.total==0){
						messageShow('alert','error','提示',"无可指定操作步骤！");
						return;
					}
					else if (ApproveFlowData.total==1){
						setElement("ApproveFlowID",ApproveFlowData.rows[0]["TRowID"]);
						approveEquipStop();
						return;
					}
					else{
						initApproveFlowGrid("ApproveFlowWin","tApproveFlowGrid",vParams,vcolumns,0)
						jQuery('#ApproveFlowWin').window('open');
						return;
					}
		            
				}
			}else{
				if (gotoTypeObj.Data=="2"){
					judgeApproveFlows();
					return;
				}
			}
		}
		approveEquipStop();
	}
}
function approveEquipStop()
{
	var RowID=getElementValue("MRRowID")
	if (RowID=="")
	{
		messageShow("","","",t[-9205]);
		return;
	}
	var SourceTypeDR=getElementValue("MRSourceType");
	var EQClassFlag=getElementValue("MRExObjDR_EQClassFlag");
	var GetStopEquipFlag=getElementValue("GetStopEquipFlag");
	var Action=getElementValue("ToActionCode");
	if(Action=="") Action=getElementValue("ActionCode");
	var GetEQStopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","31",RowID,"","1");
	if (((SourceTypeDR!=2)||(EQClassFlag!="Y"))&&(GetEQStopStartFlag==1)&&(Action=="WX_Finish"))		//除简易台账范类外处理停用启用
	{
		if (GetStopEquipFlag==1)
		{
			messageShow("confirm","info","提示",t[-9261],"",doApproveEquipStop,doApprove)
		}
		else if (GetStopEquipFlag==2)
		{
			doApproveEquipStop()
		}
		else
		{
			doApprove()
		}
	}
	else
	{
		doApprove()
	}
}
function doApproveEquipStop()
{
	var rowId=getElementValue("MRRowID")
	var result=tkMakeServerCall("web.DHCEQ.Plat.BUSChangeInfo","StopEquipBySource","31",rowId,"0");
	var resultObj=JSON.parse(result)
	if (resultObj.SQLCODE<0)
	{
		messageShow("","","",t[-9200]+resultObj.Data)
		return;
	}
	doApprove()
}
function doApprove()
{
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	var objtbl="";
	if(isPc) objtbl=getParentTable("MRRequestNo");
	var editFieldsInfo=approveEditFieldsInfo(objtbl);
	if (editFieldsInfo=="-1") return;
	var combindata=getValueList();
	var approveOpinion=getElementValue("EditOpinion");
	if (getElementValue("EditOpinion")=="WX_Maint") approveOpinion=getElementValue("MRMaintProcessDR_MPDesc");
	var approveFlowID=getElementValue("ApproveFlowID");
	var actionCode=getElementValue("ActionCode");
	var toAction=getElementValue("ToActionCode");
	if(toAction!=""){
		var fromActinCode=getElementValue("FromActinCode");
		var rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AuditStepsByActions",fromActinCode,toAction,combindata,editFieldsInfo,approveOpinion,approveFlowID);  // modified by wy 2023-3-29 3418008 判断最后一步流程走向
	}else{
		
		var rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AuditData",combindata,"","",editFieldsInfo,approveFlowID,approveOpinion,actionCode,"");
	}
    var rtnObj=JSON.parse(rtn);
  	if(isPc){
	    if (rtnObj.SQLCODE<0)
	    {
		    messageShow("","","",rtnObj.Data);
	    }
	    else
	    {
		    messageShow("","","",t[0]);
			websys_showModal("options").mth("31");
		    window.setTimeout(function(){window.location.reload()},50); 
	    }
  	}else{
  		if(toAction!="") actionCode=toAction;
  		if(rtnObj.SQLCODE=="0"){
  			if($('#ActionCode').val()==="WX_Accept"){
  				messageShow("","","","受理成功!","",function(){location.reload();});
  			}else{
  				//wx.closeWindow();
  				messageShow("","","","审核成功!","",function(){window.top.location.href=getCookieValue("domainName")+getCookieValue("project")+"/director/main";});
  			}
  		}else{
  			messageShow("","","",'审核失败!  '+rtnObj.Data);
	 	}
  	}
}
function getValueList()
{
	var ValueList="";
	ValueList=getElementValue("MRRowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+getElementValue("EvaluateGroup");
	ValueList=ValueList+"^";
	ValueList=ValueList+"^"+getElementValue("RejectReason");
	
	return ValueList;
}
/**
 * 根据下一步指定步骤可选择步骤,提供用户选择或者直接执行
 * @param 无
 * @returns 无
 * @author zx 2022-09-06
 */
function judgeApproveFlows()
{
	var option=[{"valuetype":"const","value":$('#MRRowID').val()},{"valuetype":"const","value":""},{"valuetype":"const","value":"25"},{"valuetype":"const","value":"0"},{"valuetype":"const","value":""},{"valuetype":"const","value":$('#ActionCode').val()}];
	var queryParas=parasJsonData(option);
	var data="<Request><classname>web.DHCEQCApproveFlow</classname><queryname>GetUserApproves</queryname><queryparas>"+queryParas+"</queryparas></Request>";
	data=encodeURIComponent(data);
	$.ajax({
		url: getCookieValue("domainName")+"DHCEQWechat/director/getServiceDataSoap",
		data:{Code:"2999",XMLStr:data},
		type: "get",
		dataType:"json",
		async: false,
		success: function (data) {
			endLoad();
			if(data=="-1"){
				endLoad();
				$.alert({title:'提示',content:'暂无权限!',confirmText:'确定'});
			}else{
				if(data.length==0)
				{
					$.alert({title:'提示',content:'无可指定操作步骤!',confirmText:'确定'});
				}else if(data.length==1){
					setElement("ApproveFlowID",data[0]["TRowID"]);
					approveEquipStop();
				}else{
					openStaticPopup(document.getElementById("ApproveFlowID"), "请指定下一步审核人",  data, "approveFlowsItemClick", "createApproveFlows", "");
				}
			}
		},
		error : function() {
			endLoad();
			$.alert({title:'提示',content:'数据请求异常!',confirmText:'确定'});
		}
	});
}
/**
 * 人为指定审批流列表数生成
 * @param {String} i 点击行号
 * @param {Object} item 点击行数据
 * @returns 无
 * @author zx 2022-08-11
 */
function approveFlowsItemClick(item)
{
	//$("#ApproveFlowID").val(item["TRowID"]);
	setElement("ApproveFlowID",item["TRowID"]);
	approveEquipStop();
}
/**
 * 人为指定审批流列表点击
 * @param {Object} item 业务单id
 * @returns 无
 * @author zx 2022-08-11
 */
function createApproveFlows(i, item)
{
	return '<li class="list-group-item" >'+item["TRole"]+'</li>';
}

/**
 * 维修退回事件响应方法
 * @param {String} 无
 * @returns 无
 * @author zx 2022-08-11
 */
function BCancelSubmit_Clicked()
{
	var rowId=getElementValue("MRRowID");
	if (rowId=="")	{messageShow("","","",t[-9205]);	return;	}
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	if(isPc){
		messageShow("prompt","info","退回理由","请填写拒绝理由","",doCancel,"");
	}else{
		var html = '<textarea type="text" class="control noneinput" rows="2" placeholder="请填写拒绝理由" style="font-size:14px;width:90%;border-color#ccc;" id="RejectReason"></textarea>';
		messageShow("confirm","","退回理由",html,function(){var rejectReason = getElementValue("RejectReason");if(!rejectReason) {$.toast('理由不能为空!'); return false;}else{doCancel(rejectReason)}});
	}
}
function doCancel(rejectReason)
{
	var rowId=getElementValue("MRRowID");
	var ret=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelSubmitData",rowId,"","",getElementValue("ToFlowActionCode"));    //zc 2022-11-17
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	var retObj=jQuery.parseJSON(ret)
	if(isPc){
		if (retObj.SQLCODE<0)
		{
			messageShow("","","",retObj.Data)
			return;
		}
		messageShow("","","",retObj.Data);
		websys_showModal("options").mth("31");
		window.setTimeout(function()
		{	
			var src="";
			if (getElementValue("MRMaintType")!="1"){
				if (getElementValue("QXType")==2){
					src= "dhceq.em.maintrequest.csp?&RowID="+rowId+"&Status=1&MaintType=0&QXType=2"+"&CurRole="+getElementValue("CurRole") //modify by zyq 2022-12-06 begin
				}else{
					src= "dhceq.em.maintrequest.csp?&RowID="+rowId+"&Status=1&MaintType=0&QXType=0"+"&CurRole="+getElementValue("CurRole")
				}
			}else{
				src= "dhceq.em.hardwaremaintsimple.csp?&RowID=&Status=1&MaintType=1&QXType=0"//modify by zyq 2022-12-06 end 将status值从0修改为1
			}
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				src += "&MWToken="+websys_getMWToken()
			}
			window.location.href=src;
		},50); 
	}else{
    	if(retObj.SQLCODE=="0"){
    		messageShow("","","","退回成功!","",function(){window.top.location.href=getCookieValue("domainName")+getCookieValue("project")+"/director/main";});
    	}else{
    		messageShow("","","",'退回失败!  '+resCode);
    	}
	}
}
/**
 * 出现场检修情况按钮点击
 * @param {String} panelId 面板标记
 * @returns 无
 * @author myf 2022-08-18
 */
 function panelBtnClick(panelId)
 {
	hiddenAllPanel();
	var isPc=getTermType();
	isPc=((isPc=="0")||(isPc=="1")||(isPc=="2"))?false:true;
	//移除必填项信息
	if(isPc){
		$("input").each(function(){
			var objID=$(this)[0].id;
			$("#"+objID).attr("data-required",false);
			$("#c"+objID+">span").remove();
		});
		$("textarea").each(function(){
			var objID=$(this)[0].id;
			$("#"+objID).attr("data-required",false);
			$("#c"+objID+">span").remove();
		});
	}else{
		$("#finishPanel .bi-asterisk").each(function(){
			$(this).removeClass("eq-label-required");
		})
		$("#changeGroupPanel .bi-asterisk").each(function(){
			$(this).removeClass("eq-label-required");
		})
	}
	setElement("MREquipDR","");
	setElement("MREquipTypeDR","");
	setElement("MRAcceptUserDR","");
	setElement("MRMaintGroupDR","");
	setElement("ToFlowActionCode","");
	setElement("ToActionCode","");
	//$("#MRRetrieveFlag").prop("checked", false);
	setElement("MRRetrieveFlag", false);
	setElement("VGroupType","")  ///zc 2022-11-17
	$("#audit").unbind();
	if(!$('#' + panelId + 'Btn').hasClass('eq-choose-btn-checked')) {
		$('#' + panelId + 'Btn').addClass('eq-choose-btn-checked');
	}
	if (panelId === 'toRetrieve') {
		//$("#MRRetrieveFlag").prop("checked", true);
		if($('#toRetrievePanel').hasClass('eq-hidden')) {
			$('#toRetrievePanel').removeClass('eq-hidden');
		}
		setElement("MRRetrieveFlag", true);
		setElement("ActionCode","WX_Appearance");
		setElement("ToActionCode","");
		$("#audit").bind('click',function() {BApprove_Clicked();});
	}else if (panelId === 'retrieve') {
		if($('#retrievePanel').hasClass('eq-hidden')) {
			$('#retrievePanel').removeClass('eq-hidden');
		}
		setElement("FromActinCode","WX_Appearance");
		setElement("ToActionCode","WX_Retrieve");
		$("#audit").bind('click',function() {BApprove_Clicked();});
	}else if(panelId === 'finish'){
		if($('#finishPanel').hasClass('eq-hidden')) {
			$('#finishPanel').removeClass('eq-hidden');
		}
		setElement("FromActinCode","WX_Appearance,WX_Maint");
		setElement("ToActionCode","WX_Finish");
		$("#finishPanel .bi-asterisk").each(function(){
			$(this).addClass("eq-label-required");
		})
		$("#audit").bind('click',function() {BApprove_Clicked();});
	}else if(panelId === 'maint'){
		if($('#finishPanel').hasClass('eq-hidden')) {
			$('#finishPanel').removeClass('eq-hidden');
		}
		setElement("FromActinCode","WX_Appearance");
		setElement("ToActionCode","WX_Maint");
		$("#finishPanel .bi-asterisk").each(function(){
			$(this).addClass("eq-label-required");
		})
		$("#audit").bind('click',function() {BApprove_Clicked();});
	}else if(panelId === 'changeGroup'){
		setElement("VGroupType","1")
		if($('#changeGroupPanel').hasClass('eq-hidden')) {
			$('#changeGroupPanel').removeClass('eq-hidden');
		}
		setElement("FromActinCode","WX_Appearance");
		setElement("ToActionCode","WX_Assign");
		$("#changeGroupPanel .bi-asterisk").each(function(){
			$(this).addClass("eq-label-required");
		})
		$("#audit").bind('click',function() {BApprove_Clicked();});
	}else if(panelId === 'cancel'){
		if($('#cancelPanel').hasClass('eq-hidden')) {
			$('#cancelPanel').removeClass('eq-hidden');
		}
		setElement("ToFlowActionCode","WX_Assign");
		if(isPc)   ///zc 2022-11-17 begin
		{
			$("#BApprove3").unbind();
			$("#BApprove3").bind('click',function() {BCancelSubmit_Clicked();});
			return ;
		}
		else
		{
			$("#audit").bind('click',function() {BCancelSubmit_Clicked();});
		}		///zc 2022-11-17 end
	}
	//根据最新动作重新加载可编辑字段信息
	var editFieldsAction = getElementValue("ToActionCode");
	if (panelId === 'toRetrieve'){
		editFieldsAction = "WX_Appearance";
	}
	ObjEditFields=[];
	initEditFields(getElementValue("ApproveSetDR"),"",editFieldsAction);
	initLookUp();
 }
 /**
 * 隐藏所有面板
 * @returns 无 
 * @author myf 2022-08-18
 */
  function hiddenAllPanel()
  {
	var panelArr = ['finishPanel','changeGroupPanel','cancelPanel','toRetrievePanel','retrievePanel'];
	var btnArr = ['finishBtn','toRetrieveBtn','retrieveBtn','changeGroupBtn','cancelBtn','maintBtn'];
	panelArr.forEach(function(panel){
		if(!$('#' + panel).hasClass('eq-hidden')) {
			$('#' + panel).addClass('eq-hidden');
		}
	});
	btnArr.forEach(function(btn){
		if($('#' + btn).hasClass('eq-choose-btn-checked')) {
			$('#' + btn).removeClass('eq-choose-btn-checked');
		}
	});
  }
/**
 * 界面收起展开按钮事件方法
 * @param {String} 无
 * @returns 无
 * @author zx 2022-08-11
 */
function BCollapse_Clicked()
{
	var collapseFlag=$("#panelcollapse").attr("aria-expanded");
	if(collapseFlag=="false"){
		$("#panelcollapse").html('收起<i class="bi bi-chevron-up"></i>');
	}else{
		$("#panelcollapse").html('展开<i class="bi bi-chevron-down"></i>');
	}
}
function ValueClear()
{
	setElement("MRExObjDR","");
}