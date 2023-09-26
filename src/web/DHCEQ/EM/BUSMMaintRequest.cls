/// Add By DJ 2018-07-13
/// 描述:HISUI维修功能类
Class web.DHCEQ.EM.BUSMMaintRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-09
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).GetOneMaintRequest(147,"","",0)
ClassMethod GetOneMaintRequest(rowid As %Library.String, ApproveRoleDR As %Library.String, action As %Library.String = "", step As %Library.String = "")
{
	s $ZT="ERRORGetOneMaintRequest"
	s ObjMaintRequest=##Class(User.DHCEQMMaintRequest).%OpenId(rowid)
	s MaintRequestInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjMaintRequest)
	d MaintRequestInfo.%Set("MRPackageState",ObjMaintRequest.MRPackageState)  //modified By CZF0072 2020-02-25
	d MaintRequestInfo.%Set("MRManageTypeDR_MTDesc",ObjMaintRequest.MRManageTypeDR.MTDesc)
	d MaintRequestInfo.%Set("MREquipTypeDR_ETDesc",ObjMaintRequest.MREquipTypeDR.ETDesc)
	d MaintRequestInfo.%Set("MRFaultCaseDR_FCDesc",ObjMaintRequest.MRFaultCaseDR.FCDesc)
	d MaintRequestInfo.%Set("MRFaultReasonDR_FRDesc",ObjMaintRequest.MRFaultReasonDR.FRDesc)
	d MaintRequestInfo.%Set("MRDealMethodDR_DMDesc",ObjMaintRequest.MRDealMethodDR.DMDesc)
	d MaintRequestInfo.%Set("MRFaultTypeDR_FTDesc",ObjMaintRequest.MRFaultTypeDR.FTDesc)
	d MaintRequestInfo.%Set("MRMaintModeDR_MMDesc",ObjMaintRequest.MRMaintModeDR.MMDesc)
	d MaintRequestInfo.%Set("MRContractDR_CTContractName",ObjMaintRequest.MRContractDR.CTContractName)
	d MaintRequestInfo.%Set("MRServiceDR_SVName",ObjMaintRequest.MRServiceDR.VName)		//modified by CZF0103 20200408
	//s MRServiceDR=ObjMaintRequest.MRServiceDRGetObjectId()
	//d MaintRequestInfo.%Set("MRServiceDR_SVName",##class(web.DHCEQCommon).GetTrakNameByID("cservice",MRServiceDR))	//modified by CZF0093 2020-03-
	d MaintRequestInfo.%Set("MRMaintRequestDR_MRRequestNo",ObjMaintRequest.MRMaintRequestDR.MRRequestNo)
	d MaintRequestInfo.%Set("MREmergencyLevelDR_ELDesc",ObjMaintRequest.MREmergencyLevelDR.ELDesc)
	d MaintRequestInfo.%Set("MRSeverityLevelDR_SLDesc",ObjMaintRequest.MRSeverityLevelDR.SLDesc)
	d MaintRequestInfo.%Set("MRMaintResultsDR_MRDesc",ObjMaintRequest.MRMaintResultsDR.MRDesc)
	d MaintRequestInfo.%Set("MREquipStatusDR_ESDesc",ObjMaintRequest.MREquipStatusDR.ESDesc)
	d MaintRequestInfo.%Set("MRMaintGroupDR_MGDesc",ObjMaintRequest.MRMaintGroupDR.MGDesc)
	d MaintRequestInfo.%Set("MRMaintProcessDR_MPDesc",ObjMaintRequest.MRMaintProcessDR.MPDesc)
	d MaintRequestInfo.%Set("MRRequestUserDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRRequestUserDR))
	d MaintRequestInfo.%Set("MRAcceptUserDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRAcceptUserDR))
	d MaintRequestInfo.%Set("MRAcceptUserDR_Initials",##class(web.DHCEQCommon).GetTrakNameByID("Initials",ObjMaintRequest.MRAcceptUserDR))
	d MaintRequestInfo.%Set("MRAssignDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRAssignDR))
	d MaintRequestInfo.%Set("MRUserSignDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRUserSignDR))
	d MaintRequestInfo.%Set("MRAddUserDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRAddUserDR))
	d MaintRequestInfo.%Set("MRUpdateUserDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRUpdateUserDR))
	d MaintRequestInfo.%Set("MRSubmitUserDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRSubmitUserDR))
	d MaintRequestInfo.%Set("MRAuditUserDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRAuditUserDR))
	d MaintRequestInfo.%Set("MRCancelUserDR_UserName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRCancelUser))
	d MaintRequestInfo.%Set("MRObjLocDR_LocDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjMaintRequest.MRObjLocDR))
	d MaintRequestInfo.%Set("MRRequestLocDR_LocDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjMaintRequest.MRRequestLocDR))
	d MaintRequestInfo.%Set("MRRequestLocTel",##class(web.DHCEQCommon).GetTrakNameByID("depttel",ObjMaintRequest.MRRequestLocDR)) //Modify by zx 2022-08-26
	d MaintRequestInfo.%Set("MRMaintLocDR_LocDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjMaintRequest.MRMaintLocDR))
	d MaintRequestInfo.%Set("MRManageLocDR_LocDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjMaintRequest.MRManageLocDR))
	d MaintRequestInfo.%Set("MRMaintFee",##class(web.DHCEQCommon).FormatNumber(ObjMaintRequest.MRMaintFee,""))
	// MZY0080	1943263		2021-06-03
	i ObjMaintRequest.MROtherFee="" d
	.d MaintRequestInfo.%Set("MROtherFee",##class(web.DHCEQCommon).FormatNumber(##Class(web.DHCEQM.DHCEQMMaintRequest).GetTotalFee(rowid,1),""))
	e  d
	.d MaintRequestInfo.%Set("MROtherFee",##class(web.DHCEQCommon).FormatNumber(ObjMaintRequest.MROtherFee,""))
	d MaintRequestInfo.%Set("MRAssignDate",##Class(web.DHCEQCommon).TransValueToPage(ObjMaintRequest.MRAssignDate,"date")) //modified By CZF0072 2020-02-25
	d MaintRequestInfo.%Set("MRSourceType",ObjMaintRequest.MRSourceType)		//Modify DJ 2019-06-06 //modified By CZF0072 2020-02-25 begin
	d MaintRequestInfo.%Set("MRGuaranteePeriod",ObjMaintRequest.MRGuaranteePeriod)
	d MaintRequestInfo.%Set("MRAccountDate",##Class(web.DHCEQCommon).TransValueToPage(ObjMaintRequest.MRAccountDate,"date"))
	d MaintRequestInfo.%Set("MRAssessment",ObjMaintRequest.MRAssessment)		//modified By CZF0072 2020-02-25 end
	d MaintRequestInfo.%Set("MRMaintType",ObjMaintRequest.MRMaintType)			//modified By CZF0075 2020-02-25
	d MaintRequestInfo.%Set("MRAssignDate",##Class(web.DHCEQCommon).TransValueToPage(ObjMaintRequest.MRAssignDate,"date"))			//modified By CZF0075 2020-02-25
	
	s SourceTypeDR=ObjMaintRequest.MRSourceType
	//d MaintRequestInfo.%Set("MRAccessoryOriginalDR_AODesc",ObjMaintRequest.MRAccessoryOriginalDR.AODesc)       //Modify by zx 2020-02-25 BUG ZX0078 表结构改变
	d MaintRequestInfo.%Set("MRAccessoryOriginalDR_AODesc",ObjMaintRequest.MRAccessoryOriginalDR.AFPartSpec)       //Modified By QW20211224
	
	//Modify by zx 2022-08-21
	d MaintRequestInfo.%Set("MRExObjDR_GuaranteeFlag","0")
	d MaintRequestInfo.%Set("MRExObjDR_GuaranteeDays","")
	d MaintRequestInfo.%Set("MRExObjDR_GuaranteeHours","")
	//modified by wy 2022-4-12 SourceTypeDR类行
	i ((SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3))  d
	.s EQObjInfo=##Class(User.DHCEQEquip).%OpenId(ObjMaintRequest.MRExObjDR.EOExID)
	.d MaintRequestInfo.%Set("MRExObjDR_EQRowID",ObjMaintRequest.MRExObjDR.EOExID)
	.d MaintRequestInfo.%Set("MRObjTypeDR_Desc",EQObjInfo.EQStatCatDR.SCDesc)
	.d MaintRequestInfo.%Set("MRExObjDR_ExObj",EQObjInfo.EQName)
	.d MaintRequestInfo.%Set("MRExObjDR_EQNo",EQObjInfo.EQNo)
	.d MaintRequestInfo.%Set("MRExObjDR_EQModel",EQObjInfo.EQModelDR.MDesc)
	.d MaintRequestInfo.%Set("MRExObjDR_EQOriginalFee",##Class(web.DHCEQCommon).FormatNumber(EQObjInfo.EQOriginalFee,""))
	.d MaintRequestInfo.%Set("MRExObjDR_EQFileNo",EQObjInfo.EQFileNo)
	.d MaintRequestInfo.%Set("MRExObjDR_EQStartDate",##Class(web.DHCEQCommon).TransValueToPage(EQObjInfo.EQStartDate,"date"))
	.d MaintRequestInfo.%Set("MRExObjDR_EQClassFlag",EQObjInfo.EQClassFlag)		//Modify DJ 2019-06-27
	.s GuaranteeInfo=##class(web.DHCEQ.EM.BUSMMaintRequest).GetGuaranteeData(ObjMaintRequest.MRExObjDR.EOExID)
	.//Modify by zx 2022-08-21
	.d MaintRequestInfo.%Set("MRExObjDR_GuaranteeFlag",$p(GuaranteeInfo,"^",1))
	.d MaintRequestInfo.%Set("MRExObjDR_GuaranteeDays",$p(GuaranteeInfo,"^",4))
	.d MaintRequestInfo.%Set("MRExObjDR_GuaranteeHours",$p(GuaranteeInfo,"^",5))
	.d MaintRequestInfo.%Set("MRExObjDR_GuaranteeBeginDate",$p(GuaranteeInfo,"^",6))
	.d MaintRequestInfo.%Set("MRExObjDR_GuaranteeEndDate",$p(GuaranteeInfo,"^",2))
	e  d
	.d MaintRequestInfo.%Set("MRObjTypeDR_Desc",ObjMaintRequest.MRObjTypeDR.OTDesc)
	.d MaintRequestInfo.%Set("MRExObjDR_ExObj",ObjMaintRequest.MRExObjDR.EOName)
	.d MaintRequestInfo.%Set("MRExObjDR_EQNo",ObjMaintRequest.MRExObjDR.EONo)
	//Modefied by zc 2022-4-8
	//Modefied by WY 2022-9-26 2952668是否急单标志
	i (+$Piece($G(^DHCEQMMaintRequest(rowid)),"^",61)>1) d
	.d MaintRequestInfo.%Set("EmergencyFlag","Y")
	e  d
	.d MaintRequestInfo.%Set("EmergencyFlag","N")
	i ObjMaintRequest.MRSeverityLevelDR'="" d
	.d MaintRequestInfo.%Set("SeverityLevelFlag","Y")
	e  d
	.d MaintRequestInfo.%Set("SeverityLevelFlag","N")
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("25",rowid,ApproveRoleDR)
	d MaintRequestInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d MaintRequestInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d MaintRequestInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d MaintRequestInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d MaintRequestInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d MaintRequestInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d MaintRequestInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d MaintRequestInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d MaintRequestInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d MaintRequestInfo.%Set("NextRole",$p(AppInfo,"^",10))
	s Evaluate=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneEvaluate(1,rowid,"")
	s CanChangeValue=""
	i action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("25",action,rowid,2)
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_step_",")) d
	.s MultipleRoleFlag=1
	
	d MaintRequestInfo.%Set("EvalueateInfo",Evaluate)
	d MaintRequestInfo.%Set("MultipleRoleFlag",MultipleRoleFlag)
	s ReasonList=##Class(web.DHCEQApproveList).GetRejectReasonList("25",rowid) //add by wy 2022-7-22 2767477 拒绝意见
	s Length=$l(ReasonList,",")
	s Opinion=$p($p(ReasonList,",",Length),":",2)
	d MaintRequestInfo.%Set("RejectReason",Opinion)
	//Modify by zx 2022-08-21
	s PicNum=##class(web.DHCEQ.Process.DHCEQPictureList).GetPictureNumBySourceID(31,rowid,"")
	d MaintRequestInfo.%Set("MRPicNum",PicNum)
	i (action'="")&&($p(AppInfo,"^",2)'="")&&(action'="Submit") d  ;当为退回时动作流没有StepInfo modify by zyq 2022-11-20
	.s StepInfo=##class(web.DHCEQCApproveSet).GetRoleByAction($p(AppInfo,"^",2),action)
	.d MaintRequestInfo.%Set("CurRoleDR",$p(StepInfo,"^",1))
	.d MaintRequestInfo.%Set("CurFlowStep",$p(StepInfo,"^",2))
	e  d
	.d MaintRequestInfo.%Set("CurRoleDR","")
	.d MaintRequestInfo.%Set("CurFlowStep","")
	
	d MaintRequestInfo.%Set("MREquipDR",ObjMaintRequest.MRExObjDR.EOExID)
    d MaintRequestInfo.%Set("MREquipDR_EQName",ObjMaintRequest.MRExObjDR.EOName)
     //add by wy 2022-8-31 保存地点
    s MRLocationDRLDesc=""
    i ObjMaintRequest.MRLocationDR'="" s MRLocationDRLDesc=$p($g(^DHCEQCCode("DHCEQCLocation",ObjMaintRequest.MRLocationDR)),"^",2)
    d MaintRequestInfo.%Set("MRLocationDR_LDesc",MRLocationDRLDesc)
    //add by wy 2022-9-1取回人 MRRetrieveUserDR_UserName 归还人MRReturnUserDR_UserName
	s MoveID=0
	f  s MoveID=$o(^DHCEQMove(0,"Source","31",rowid,MoveID)) q:MoveID=""  d 
    .s TEventType=$p($g(^DHCEQMove(MoveID)),"^",6)
    .i TEventType="1" d
    ..s MRRetrieveUserDR=$p($g(^DHCEQMove(MoveID)),"^",19)
    ..s MRRetrieveUserDRUserName=##class(web.DHCEQCommon).GetTrakNameByID("user",MRRetrieveUserDR)
    ..d MaintRequestInfo.%Set("MRRetrieveUserDR",MRRetrieveUserDR)
    ..d MaintRequestInfo.%Set("MRRetrieveUserDR_UserName",MRRetrieveUserDRUserName)
    .i TEventType="2" d
    ..s MRReturnUserDR=$p($g(^DHCEQMove(MoveID)),"^",19)
    ..s MRReturnUserDRUserName=##class(web.DHCEQCommon).GetTrakNameByID("user",MRReturnUserDR)
    ..d MaintRequestInfo.%Set("MRReturnUserDR",MRReturnUserDR)
    ..d MaintRequestInfo.%Set("MRReturnUserDR_UserName",MRReturnUserDRUserName)
    i ObjMaintRequest.MRMaintGroupDR="" d
	.s MGRowID=0 
	.f  s MGRowID=$o(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID))  quit:MGRowID=""  d
	..q:$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)="Y"
	..s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",12)  //默认访问类组
	..s MGDesc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",2)
    ..q:(TEquipTypeDR="")||(TEquipTypeDR'=$p($g(^DHCEQMMaintRequest(rowid)),"^",3))  //modified by wy 2022-11-17
    ..d MaintRequestInfo.%Set("MRMaintGroupDR",MGRowID)
    ..d MaintRequestInfo.%Set("MRMaintGroupDR_MGDesc",MGDesc)
    //Modify by zx 2022-09-15 界面默认维修结果
    i (ObjMaintRequest.MRMaintResultsDR="")&&((action="WX_Appearance")||(action="WX_Maint")) d
    .s MRResultFlag=0
    .s MRResultID=0
    .f  s MRResultID=$o(^DHCEQCCode("DHCEQMCMaintResults",MRResultID)) q:(MRResultID="")||(MRResultFlag=1)  d
    ..q:$p($g(^DHCEQCCode("DHCEQMCMaintResults",MRResultID)),"^",4)="Y"
    ..s MRResultFlag=1
    ..d MaintRequestInfo.%Set("MRMaintResultsDR",MRResultID)
    ..d MaintRequestInfo.%Set("MRMaintResultsDR_MRDesc",$p($g(^DHCEQCCode("DHCEQMCMaintResults",MRResultID)),"^",2))
    
	Set Opinion=##Class(web.DHCEQApproveList).GetApproveListOpinion("25", rowid)
	d MaintRequestInfo.%Set("OpinionRecords",Opinion)
	//modified by ZY20230215 bug:3267279、3267280
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("25", rowid,"WX_Accept")
	s ApproveOpinon1=$p(result,"^",3)
	i ApproveOpinon1="" s ApproveOpinon1="同意(默认)"
	d MaintRequestInfo.%Set("ApproveOpinon1",ApproveOpinon1_"  "_$p(result,"^",13))		///modified by ZY20230414 bug:3431217
	s ApproveUser1=$p(result,"^",6)
	s ApproveUser1Img=""
	i ApproveUser1'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser1)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser1)),"^",19)
	.s ApproveUser1Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser1Img'="" s ApproveUser1Img="data:image/png;base64,"_ApproveUser1Img
	d MaintRequestInfo.%Set("ApproveUser1",ApproveUser1Img)
	
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("25", rowid,"WX_ManageLocAudit")	
	s ApproveOpinon2=$p(result,"^",3)
	i ApproveOpinon2="" s ApproveOpinon2="同意(默认)"
	d MaintRequestInfo.%Set("ApproveOpinon2",ApproveOpinon2_"  "_$p(result,"^",13))			///modified by ZY20230414 bug:3431217
	s ApproveUser2=$p(result,"^",6)
	s ApproveUser2Img=""
	i ApproveUser2'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser2)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser2)),"^",19)
	.s ApproveUser2Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser2Img'="" s ApproveUser2Img="data:image/png;base64,"_ApproveUser2Img
	
	d MaintRequestInfo.%Set("ApproveUser2",ApproveUser2Img)
	
	Set result=##Class(web.DHCEQApproveList).GetApproveInfoByActionCode("25", rowid,"WX_Audit")	
	s ApproveOpinon3=$p(result,"^",3)
	i ApproveOpinon3="" s ApproveOpinon3="同意(默认)"
	d MaintRequestInfo.%Set("ApproveOpinon3",ApproveOpinon3_"  "_$p(result,"^",13))			///modified by ZY20230414 bug:3431217
	s ApproveUser3=$p(result,"^",6)
	s ApproveUser3Img=""
	i ApproveUser3'="" d
	.s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser3)),"^",18)
	.q:(DeptExType'=1)		//"1":"DHC-HIS"
	.s UserID = $p($g(^DHCEQCCode("DHCEQCUser",ApproveUser3)),"^",19)
	.s ApproveUser3Img=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
	.i ApproveUser3Img'="" s ApproveUser3Img="data:image/png;base64,"_ApproveUser3Img
	d MaintRequestInfo.%Set("ApproveUser3",ApproveUser3Img)
	
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,MaintRequestInfo)
ERRORGetOneMaintRequest
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

ClassMethod DeleteMaintRequest(RowID As %Library.String, User As %Library.String = "")
{
	Set $ZT="ERRORDelete"
	//add by zx 2020-01-14 微信端删除处理
	i User'="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	
	// MZY0069	1706576		2021-02-18	增加提交配件管理控制
	Set Flag=""
	Set MMPRowID=0
	For  Set MMPRowID=$Order(^DHCEQMMaintPart(0,"MaintRequest",RowID,MMPRowID)) Quit:(MMPRowID="")||(Flag'="")  Do
	.If $Piece($Get(^DHCEQMMaintPart(MMPRowID)),"^",12)="Y" Do
	..;待购配件处理生成的入库单
	..Set AISLRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",18)
	..Quit:AISLRowID=""
	..Set listDR=$Piece($Get(^DHCEQAInStockList(AISLRowID)),"^",1)
	..If ($Piece($Get(^DHCEQAInStock(listDR)),"^",16)'=3) Set Flag="请与配件管理员联系处理入库单:"_$Piece($Get(^DHCEQAInStock(listDR)),"^",6)
	.Else  Do
	..Set ASMLRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",11)
	..Quit:ASMLRowID=""
	..Set listDR=$Piece($Get(^DHCEQAMoveStockList(ASMLRowID)),"^",1)
	..If ($Piece($Get(^DHCEQAMoveStock(listDR)),"^",28)'=3) Set Flag="请与配件管理员联系处理转移单:"_$Piece($Get(^DHCEQAMoveStock(listDR)),"^",1)
	If Flag'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000, Flag)
	
	TSTART
	&sql(Update sqluser.DHC_EQMMaintRequest Set MR_InvalidFlag='Y',MR_CancelUser=:User,MR_CancelDate=:Date,MR_CancelTime=:Time where MR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
 	s EquipID=""
	s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
	i ObjSourceTypeDR=1
	{
		s ObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
		i ObjDR'= "" s EquipID=$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)

 		s ReturnJsonStr=##Class(web.DHCEQ.Plat.BUSChangeInfo).UpdateEquipUnusualStatus(EquipID,"","")
 		s ReturnJsonObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(ReturnJsonStr)		//CZF0131 2020-01-20
		i ReturnJsonObj.SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9040,ReturnJsonObj.Data)
		}	
	}
	 
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
ERRORDelete
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息
}

/// Add By DJ 2018-07-13
ClassMethod AutoSaveExObj(vEQRowID)
{
	s Find=""
	&SQL(Select EO_RowID Into :Find From SQLUSER.DHC_EQMExObj Where EO_ExType='1' and EO_ExID=:vEQRowID and EO_InvalidFlag='N')
	i Find'="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Find)
	K EOPLIST
	s EOPLIST(2)=$p($g(^DHCEQEquip(vEQRowID)),"^",1)	//EQName
	s EOPLIST(3)=$p($g(^DHCEQEquip(vEQRowID)),"^",71)	//EQNo
	s EOPLIST(4)=$p($g(^DHCEQEquip(vEQRowID)),"^",67)	//StoreLocDR
	s EOPLIST(5)="1"
	s EOPLIST(6)=vEQRowID
	s EOPLIST(15)="N"
	&SQL(insert into SQLUSER.DHC_EQMExObj values:EOPLIST())
	i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	s EORowID=$Get(%ROWID)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,EORowID)
}

/// Add By DJ 2018-07-13
ClassMethod SetContrat(ExObjDR)
{
	//保修开始计算的时间点	0:验收日期  1:入库日期
	s BeginData=##class(web.DHCEQCommon).GetSysInfo("990039")
	i ExObjDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"0^^")
	s Flag="0"
	s SignDate=0
	s MaxDate=0
	s StartDate=""
	s EndDate=""
	s rowid=0
	s MaxContractDR=0
	s ExType = $p($g(^DHCEQMExObj(ExObjDR)),"^",4)
	i ExType=1 d
	.s EquipDR=$p(^DHCEQMExObj(ExObjDR),"^",5)
	.s StartDate=$P($g(^DHCEQEquip(EquipDR)),"^",12)
	.i BeginData=1 s StartDate=$P($g(^DHCEQEquip(EquipDR)),"^",45)
	.;日期格式统一调整
	.s StartDate=##Class(web.DHCEQCommon).TransValueToPage(StartDate,"date")
	.s MonthNum=$P(^DHCEQEquip(EquipDR),"^",73)
	.s EndDate=##class(web.DHCEQCommon).DateAdd("M",MonthNum,StartDate)
	.f  s rowid=$o(^DHCEQServiceContract(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	..s ContractDR=$P(^DHCEQServiceContract(rowid),"^",2)
	..s SignDate=$P(^DHCEQContract(ContractDR),"^",7)
	..s Flag="1"
	..s StartDate=""
	..s EndDate=""
	..i SignDate>MaxDate d
	...s MaxContractDR=ContractDR
	...s MaxDate=SignDate
	
	i MaxContractDR>0 s StartDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQContract(MaxContractDR)),"^",11),"date")
	i MaxContractDR>0 s EndDate=##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQContract(MaxContractDR)),"^",12),"date")
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Flag_"^"_StartDate_"^"_EndDate)
}

/// Add By DJ 2018-07-13
ClassMethod GetMaintNumForAffix(RowID As %Library.String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	s EquipDR=""
	s ExObjDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)			//ExObjDR
	s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)		//MRHold3
	i SourceTypeDR=1 s EquipDR=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
	i EquipDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	
	s strinfo=""
	s job=$j
	k ^TempDHCEQ("GetMaintNumForAffix",job)
	s MMRowID=0
	f  s MMRowID=$o(^DHCEQMMaintRequest(MMRowID)) q:(MMRowID="")  d
	.q:$p($g(^DHCEQMMaintRequest(MMRowID)),"^",57)'="N"		;无效单据
	.s MRAuditDate=$p($g(^DHCEQMMaintRequest(MMRowID)),"^",52)
	.q:MRAuditDate=""		;未完成业务
	.
	.;是否同一设备的维修业务单
	.s tmpEquipDR=""
	.s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(MMRowID)),"^",63)
	.i SourceTypeDR=1 s tmpEquipDR=$Piece($Get(^DHCEQMExObj($Piece($Get(^DHCEQMMaintRequest(MMRowID)),"^",5))),"^",5)
	.q:tmpEquipDR'=EquipDR
	.
	.s affixsInfo = ##Class(web.DHCEQAffix).GetAffixsInfoByEquip(EquipDR)
	.s len= $l(affixsInfo,"&")
	.for i=1:1:len d
	..s str= $Piece(affixsInfo,"&",i)
	..s BeginDate=$p(str,"^",25)
	..;日期格式统一调整
	..s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")
	..q:MRAuditDate<BeginDate
	..s EndDate=$p(str,"^",26)
	..;日期格式统一调整
	..s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	..q:MRAuditDate>EndDate
	..
	..s ^TempDHCEQ("GetMaintNumForAffix",job,EquipDR,i)=1+$g(^TempDHCEQ("GetMaintNumForAffix",job,EquipDR,i))
	..
	
	s i=""
	f  s i=$o(^TempDHCEQ("GetMaintNumForAffix",job,EquipDR,i)) q:(i="")  d
	.s str= $Piece(affixsInfo,"&",i)
	.s affixname=$p(str,"^",4)
	.i strinfo'="" s strinfo=strinfo_","
	.s strinfo=strinfo_affixname_"^"_$g(^TempDHCEQ("GetMaintNumForAffix",job,EquipDR,i))
	.
	k ^TempDHCEQ("GetMaintNumForAffix",job)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,strinfo)
}

/// Add By DJ 2018-07-13
/// Modify by zx 2022-10-11 参数ExObjID维修对象ID改为设备ID
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).CheckMaintProcess("1","502","")
ClassMethod CheckMaintProcess(SourceType, ExEquipID, RowID As %String = "")
{
	n ReturnInfo,TRequestNo,TRequestUser,TRequestDate,ReturnFlag,TEquipType	
	s (ReturnInfo,TRequestNo,TRequestUser,TRequestDate,ReturnFlag,TEquipType)=""	//modified by csj 2020-02-11
	s ReturnFlag=0
	//s ReturnInfo={"ReturnFlag":0}		//CZF0131 2021-01-20
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	d ReturnInfo.%Set("ReturnFlag",0)
	i (SourceType="")||(ExEquipID="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnFlag)
	s ExObjID=$o(^DHCEQMExObj(0,"ExID","1",ExEquipID,""))
	i (ExObjID="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnFlag)
	s MaintRequestID=0
	f  s MaintRequestID=$o(^DHCEQMMaintRequest(0,"Source",SourceType,ExObjID,MaintRequestID)) q:(MaintRequestID="")||(ReturnFlag=1)  d
	.;是否同一设备的维修业务单
	.q:(RowID'="")&&(RowID=MaintRequestID)
	.s TInvalidFlag=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",57)
	.q:TInvalidFlag="Y"
	.s TEquipType=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",3)	//add by csj 2020-02-11 标准版-简易台账不判断重复
	.s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") 
	.q:(","_FacilityEquipType_",")[(","_TEquipType_",")	//end by csj 2020-02-11
	.s TStatus=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",41)
	.q:TStatus=3  //Modefied by zc0094 2021-1-14 维修单作废过滤
	.i TStatus'="2" s ReturnFlag=1
	.s TRequestNo=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",1)
	.s TRequestUserDR=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",20)
	.i TRequestUserDR'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	.s TRequestDate=$P($G(^DHCEQMMaintRequest(MaintRequestID)),"^",18)
	.;日期格式统一调整
	.s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	d ReturnInfo.%Set("ReturnFlag",ReturnFlag)
	d ReturnInfo.%Set("RequestNo",TRequestNo)
	d ReturnInfo.%Set("RequestUser",TRequestUser)
	d ReturnInfo.%Set("RequestDate",TRequestDate)
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnInfo)
}

/// d ##class(web.DHCEQM.DHCEQMMaintRequest).UpdateMaintRequest("","","^^2^3^2^2^2^2")
/// add by zx 2014-03-26
/// 在更新数据时,生成维修表,维修明细,维修换件,维修评价信息表
/// add by lmm 2021-03-08 MREquipStatusFlag:设备异常状态更新
ClassMethod UpdateMaintRequest(val As %Library.String, Evaluate As %Library.String, MREquipStatusFlag As %Library.String = "")
{
	Set $ZT="ERRORUpdateMMaintRequest"
	k PLIST,IRowID,RowID,PLI,LI,MTIRowID,CheckFlag,FacilityEquipType
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))  //Modefied by zc0100 2021-3-15 初始化User
	s IRowID=$p(val,"^",1)
	
	s PLIST(1) = $p(val,"^",1) //MR_RowID
	//s PLIST(2) =  $p(val,"^",2) //MR_RequestNO
	s PLIST(3) = $p(val,"^",3) //MR_ManageTypeDR
	s PLIST(4) = $p(val,"^",4) //MR_EquipTypeDR
	s PLIST(5) = $p(val,"^",5) //MR_ObjTypeDR
	s PLIST(6) = $p(val,"^",6) //MR_ExObjDR
	s PLIST(7) = $p(val,"^",7) //MR_ObjLocDR
	s PLIST(8) = $p(val,"^",8) //MR_RequestLocDR
	s PLIST(9) = $p(val,"^",9) //MR_StartDate
	i $p(val,"^",9)'=""  s PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date")	;StartDate
	s PLIST(10) = $p(val,"^",10) //MR_StartTime
	s PLIST(11) = $p(val,"^",11) //MR_FaultCaseDR
	s PLIST(12) = $p(val,"^",12) //MR_FaultCaseRemark
	s FaultCaseRemark= $p(val,"^",12)	//czf 2022-03-15 begin
	i PLIST(11) = ""
	{
		s RtnResult=##Class(web.DHCEQM.DHCEQMCFaultCase).UpdFaultCase("^"_FaultCaseRemark)
		i RtnResult<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000,"故障现象保存字典失败")
		s PLIST(11)=RtnResult
	}
	s PLIST(13) = $p(val,"^",13) //MR_FaultReasonDR
	s PLIST(14) = $p(val,"^",14) //MR_FaultReasonRemark
	s FaultReasonRemark=$p(val,"^",14)
	i PLIST(13) = ""
	{
		s RtnResult=##Class(web.DHCEQCFaultReason).UpdFaultReason("^"_FaultReasonRemark)
		i RtnResult<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000,"故障原因保存字典失败")
		s PLIST(13)=RtnResult
	}
	s PLIST(15) = $p(val,"^",15) //MR_DealMethodDR
	s PLIST(16) = $p(val,"^",16) //MR_DealMethodRemark
	s DealMethodRemark=$p(val,"^",16)
	i PLIST(15) = "" 
	{
		s RtnResult=##Class(web.DHCEQCDealMethod).UpdDealMethod("^"_DealMethodRemark)
		i RtnResult<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000,"解决方法保存字典失败")
		s PLIST(15)=RtnResult
	}		//czf 2022-03-15 end
	s PLIST(17) = $p(val,"^",17) //MR_EndDate
	i $p(val,"^",17)'=""  s PLIST(17) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")
	s PLIST(18) = $p(val,"^",18) //MR_EndTime
	s PLIST(19) = $p(val,"^",19) //MR_RequestDate
	i $p(val,"^",19)'=""  s PLIST(19) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"date")
	i PLIST(19)="" s PLIST(19)=$p($h,",",1)		//Modefied by zc0100 2021-3-15 信息为空，取系统日期值
	s PLIST(20) = $p(val,"^",20) //MR_RequestTime
	i PLIST(20)="" s PLIST(20)=$p($h,",",2)		//Modefied by zc0100 2021-3-15 信息为空，取系统时间值
	s PLIST(21) = $p(val,"^",21) //MR_RequestUserDR
	i PLIST(21)="" s PLIST(21)=User  			//Modefied by zc0100 2021-3-15 信息为空，取操作人员值
	s PLIST(22) = $p(val,"^",22) //MR_RequestTel
	s PLIST(23) = $p(val,"^",23) //MR_LocationDR modify by zyq 2023-03-01
	s PLIST(24) = $p(val,"^",24) //MR_FaultTypeDR
	s PLIST(25) = $p(val,"^",25) //MR_AcceptDate
	i $p(val,"^",25)'=""  s PLIST(25) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",25),"date")
	s PLIST(26) = $p(val,"^",26) //MR_AcceptTime
	i $p(val,"^",26)'=""  s PLIST(26) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",26),"time")
	s PLIST(27) = $p(val,"^",27) //MR_AcceptUserDR
	s PLIST(28) = $p(val,"^",28) //MR_AssignDR
	s PLIST(29) = $p(val,"^",29) //MR_MaintModeDR
	s PLIST(30) = $p(val,"^",30) //MR_MaintLocDR
	s PLIST(31) = $p(val,"^",31) //MR_ContractDR
	s PLIST(32) = $p(val,"^",32) //MR_ServiceDR
	s PLIST(33) = $p(val,"^",33) //MR_UserSignDR
	s PLIST(34) = $p(val,"^",34) //MR_UserOpinion
	s PLIST(35) = $p(val,"^",35) //MR_ManageLocDR
	s PLIST(36) = $p(val,"^",36) //MR_ReturnFlag
	s PLIST(37) = $p(val,"^",37) //MR_MaintRequestDR
	s PLIST(38) = $p(val,"^",38) //MR_MaintRemark
	s PLIST(39) = $p(val,"^",39) //MR_EstimateWorkHour
	s PLIST(40) = $p(val,"^",40) //MR_WorkHour
	s PLIST(41) = $p(val,"^",41) //MR_Remark
	s PLIST(42) = $p(val,"^",42) //MR_Status
	If PLIST(42)="" Set PLIST(42)=0
	s PLIST(58) = "N"            //MR_InvalidFlag
	s PLIST(59) = $p(val,"^",45) //MR_MaintFee
	s PLIST(60) = $p(val,"^",46) //MR_OtherFee
	s PLIST(61) = $p(val,"^",47) //MR_TotalFee
	s PLIST(62) = $p(val,"^",48) //MR_EmergencyLevelDR
	s PLIST(63) = $p(val,"^",49) //MR_SeverityLevelDR
	s PLIST(64) = $p(val,"^",50) //MR_Hold3
	;Modified By QW20211229 注视掉 范类的sourcetype为3
	;s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") //add by zx 2017-03-30 未在帐微信报修来源处理
	;i ((","_FacilityEquipType_",")[(","_$p(val,"^",4)_",")) s PLIST(64) ="2"
	i $p(val,"^",51)'="" s PLIST(65) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",51),"date") //MR_Hold4
	s PLIST(66) = $p(val,"^",52) //MR_Hold5
	s PLIST(67) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",53),"bool")            //MR_InsurFlag		//20200318
	s PLIST(68) = $p(val,"^",54) //MR_MaintResultsDR
	s PLIST(69) = $p(val,"^",55) //MR_EquipStatusDR
	s PLIST(70) = $p(val,"^",56) //MR_MaintProcess
	s PLIST(74) = $p(val,"^",57) //MR_GuranteePeriod	//add by CZF0072 2020-02-25 begin
	s PLIST(84) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",58),"date") //MR_AccountDate
	s PLIST(83) = $p(val,"^",59) //MR_Assessment 		//add by CZF0072 2020-02-25 end
	s PLIST(77) = $p(val,"^",60) //MR_MaintType			//add by CZF0075 2020-02-25
	s PLIST(71)=$p(val,"^",61)		//MRMaintGroupDR
	s PLIST(32)=$p(val,"^",62)		//MRServiceDR
	s PLIST(72)=$p(val,"^",63)		//MRSaveCostFee
	s PLIST(88)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",64),"bool") // MRRetrieveFlag add by zyq 2022-11-06 begin
	s PLIST(89)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",65),"bool") //MRReplaceFlag
	s PLIST(90)=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",66),"bool") //MRDisuesdFlag add by zyq 2022-11-06 end
	s PLIST(87)=$p(val,"^",64)		//MRHold17 Modified By QW20211224 增加保存ip地址
	s PLIST(80)=$p(val,"^",65)		//Modified By QW20211224 增加保存附件id
	
	
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EEvaluateTypeDR")=1 Set LI(4) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EEvaluateTypeDR")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EScore")=1 Set LI(5) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EScore")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EContent")=1 Set LI(6) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EContent")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"ERemark")=1 Set LI(7) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"ERemark")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EUserDR")=1 Set LI(8) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EUserDR")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"EDate")=1 Set LI(9) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"EDate")
	If ##Class(web.DHCEQCommon).ExistsElement(Evaluate,"ETime")=1 Set LI(10) = ##Class(web.DHCEQCommon).GetDataByName(Evaluate,"ETime")
	k PLIST(1)
	
	i IRowID'="" 
	{
		s InvalidFlag=$p($g(^DHCEQMMaintRequest(IRowID)),"^",57)
		i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)
	}
	
	TStart
	
	If IRowID'=""
	{
		If $Piece(val,"^",43)'="" Set PLIST(46) = $Piece(val,"^",43)
		Set PLIST(47)=+$H
		Set PLIST(48)=$Piece($H,",",2)
		&sql(Update sqluser.DHC_EQMMaintRequest Values :PLIST() where MR_RowID=:IRowID)
		Set RowID=$Get(%ROWID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		/*		//Modify DJ 2014-09-25
		&sql(Update sqluser.DHC_EQMEvaluate Values :LI() where E_SourceID=:RowID and E_SourceType=1)   
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		*/    
	}
	Else
	{
		//if $p(val,"^",6)'="" s locdr=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",5)
		If $Piece(val,"^",43)'="" Set PLIST(43) = $Piece(val,"^",43)
		Set PLIST(44)=+$H
		Set PLIST(45)=$Piece($H,",",2)
		s EquipTypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",PLIST(4))),"^",1)
		//If PLIST(2)=""    //add by zx 2016-11-24 申请单号处理 ZX0036
		Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMMaintRequest",+$H,PLIST(8),EquipTypeCode) //Modify DJ 2016-04-19
		&sql(Insert Into SQLUser.DHC_EQMMaintRequest Values :PLIST())
		
		Set RowID=$Get(%ROWID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		/*		//Modify DJ 2014-09-25
		Set LI(2)=1
		Set LI(3)=RowID
		&sql(Insert Into SQLUser.DHC_EQMEvaluate Values :LI())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		*/
 	}
 	//维修停用设备Add By DJ 2018-03-18
 	//MODIFY BY LMM 2021-03-08 改为设备工作状态异常时修改设备状态
 	/*s MStartStopFlag=$p(val,"^",55)
 	if (+MStartStopFlag>=1)&&(MREquipStatusFlag="Y")
 	{
		s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
		s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
		If TExObjDR'=""
		{
			//modified by wy 2022-4-12 SourceTypeDR类行
			i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)
			{
				new ChangeInfoDR   ;add by kdf 需求号573050
				s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
				s EQClassFlag=$Piece($Get(^DHCEQEquip(EQRowID)),"^",83)
				if ((SourceTypeDR'=2)||(EQClassFlag'="Y"))		//Modify DJ 2019-06-27 除简易台账范类外处理
				{
					;检测是否已存停用记录
					K PL
					s PL(2)=EQRowID
					s PL(4)=2
					s PL(5)=+$H
					s PL(6)=31
					s PL(7)=RowID
					s PL(8)=2
					s PL(9)=1
					s PL(10)=2
					s PL(14)="维修停用"
					s PL(16)="N"
					s PL(18)=+$H             ;add by kdf 2018-03-27 需求号573023
		            s PL(19)=$P($H,",",2)    ;add by kdf 2018-03-27 需求号573023
					s PL(23)=+$H
					s PL(24)=$P($H,",",2)
					s PL(25)=$Piece(val,"^",43)
					s CIRowID=$o(^DHCEQChangeInfo(0,"EquipChangeType",EQRowID,2,31,RowID,0))
					i CIRowID=""
					{
						&SQL(Insert Into SQLUSER.DHC_EQChangeInfo Values :PL())
						i SQLCODE
						{
							TROLLBACK
							q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
						}
						//add by kdf 需求号573050 begin********
						s ChangeInfoDR=$G(%ROWID)
						k LI
						s LI(2)=EQRowID  //设备
						s LI(4)=$p($g(^DHCEQEquip(EQRowID)),"^",19)   	//原使用科室
						s LI(5)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//原管理科室
						s LI(6)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//原库房
						s LI(7)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//原值
						s LI(8)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//原净值
						s LI(9)=$p($g(^DHCEQEquip(EQRowID)),"^",19)  	//变动后使用科室
		 				s LI(10)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//变动后管理科室
		 				s LI(11)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//变动后库房
		 				s LI(12)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//变动后原值
		 				s LI(13)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//变动后净值
						s LI(14)="停用"
						s LI(16)=+$H	//变动日期
						s LI(17)=$P($H,",",2)	//变动时间
						;s LI(18)=depreFee //折旧费用
						s LI(19)="C"	//生命周期类型
						s LI(20)=41		//来源类型
						s LI(21)=ChangeInfoDR	//来源ID
						s LI(27)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//更新人
						s LI(28)=+$H	//更新日期
						s LI(29)=$P($H,",",2)	//更新时间
						&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
						//add by kdf 需求号573050 end ********
					}
					i SQLCODE
					{
						TROLLBACK
						q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
					}
					&SQL(Update SQLUser.DHC_EQEquip set EQ_Status=2 where EQ_RowID=:EQRowID)
				}
			}
		}
 	}
  	If SQLCODE
	{
		TRollBack
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}*/
	//start by csj 20200209 生成租赁维修对照
	s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
	s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
	If TExObjDR'=""
	{
		//modified by wy 2022-4-12 SourceTypeDR类行
		i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)
		{
			s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
			s SQLCODE=##class("web.DHCEQ.RM.BUSShareResource").CreateRentMaintMap(EQRowID,1,RowID)
			i SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
	}
	//维修申请人的电话维护到人员表 add by wy 2022-3-31
	s RequestTel= $p(val,"^",22) 
	s UserDR= $p(val,"^",21) 
	i UserDR="" s UserDR=User  			
	if RequestTel'=""
	{
		&SQL(Update SQLUser.DHC_EQCUser set U_MobilePhone=:RequestTel where U_RowID=:UserDR)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	//end by csj 20200209 
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORUpdateMMaintRequest
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息
}

/// w ##class(web.DHCEQ.EM.BUSMMaintRequest).SubmitMaintRequest("","",1,1,1)
ClassMethod SubmitMaintRequest(MRRowID As %Library.String, MRStatus As %Library.String, User As %Library.String, GroupID As %Library.String = "")
{
	n UnusualStatus,UnusualRemark,FacilityEquipType
	s UnusualStatus="3"
	s UnusualRemark="报修"
	Set $ZT="ERRORSubmit"
	k PLISTINFO
	
	i MRRowID'="" 
	{
		s InvalidFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
		i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)
	}
	s EquipTypeDR=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",3)
	s Status=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",41)
	
	if Status'="0" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002)   //该记录状态不符合,不能执行操作!
	
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))		//add by CZF0075 2020-02-26 begin
	s PLISTINFO(42)=MRStatus	;MR_Status
	s PLISTINFO(49)=User		;MR_SubmitUser
	s PLISTINFO(50)=+$H			;MR_SubmitDate
	s PLISTINFO(51)=$Piece($H,",",2)		;MR_SubmitTime
	s PLISTINFO(17)=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",16)
	s PLISTINFO(18)=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",17)
	s PLISTINFO(25)=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",24)
	s PLISTINFO(26)=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",25)
	s PLISTINFO(27)=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",26)
	
	s MaintType=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",76)  	//维修类型 1:工程师申请 "":科室申请
	s ManageTypeDR =$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",2)  //add by wy 2022-4-7管理类型 1：设备维修2：软件问题3：软件需求4：信息设备
	s MaintModeDR=$Piece($G(^DHCEQMMaintRequest(MRRowID)),"^",28)   //add by wy 2022-5-5 维修方式1:自修；2:保修合同3:委外维修
	s ApproveCondition="MaintType,DHCEQMMaintRequest,"_MaintType_"^ManageType,DHCEQMMaintRequest,"_ManageTypeDR_"^MaintMode,DHCEQMMaintRequest,"_MaintModeDR
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "", "",ApproveCondition)	//modified by CZF0075 2020-02-26 end
	If ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9020)
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, MRRowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;AppInfoStatus
	
	Set AuditFlag=0
	If (AutoAuditFlag="Y")&&(NextStep="")
	{
		Set AuditFlag=1
		Set AppInfoStatus="2"			;AppInfoStatus
		s PLISTINFO(42)=2										//add by CZF0075 2020-02-25 begin
		i PLISTINFO(17)="" Set PLISTINFO(17)=+$H				; MR_EndDate
		i PLISTINFO(18)="" Set PLISTINFO(18)=$Piece($H,",",2)	; MR_EndTime
		//i PLISTINFO(25)="" Set PLISTINFO(25)=+$H				; MR_AcceptDate
		//i PLISTINFO(26)="" Set PLISTINFO(26)=$Piece($H,",",2)	; MR_AcceptTime
		i PLISTINFO(27)="" Set PLISTINFO(27)=User				; MR_AcceptUser //add by CZF0075 2020-02-25 end
	}

	
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")  //add by zx 2016-04-19 移动端session值问题
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,MRRowID,"25",User)
	If SQLCODE
	{
		TROLLBACK
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,MRRowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	&sql(Update sqluser.DHC_EQMMaintRequest Values:PLISTINFO()  where MR_RowID=:MRRowID)	//modified by CZF0075 2020-02-25
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//维修部位登记	Add By DJ 2014-09-23
	s MIRowID=$o(^DHCEQMMaintItem(0,"MaintRequest",MRRowID,0))
	k MIPLIST
	i MIRowID=""
	{
		s MIPLIST(3)=1
		s MIPLIST(8)=MRRowID
		&SQL(insert into SQLUSER.DHC_EQMMaintItem values :MIPIST())
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	i AuditFlag=1
	{
		Set SQLCODE= ##Class(web.DHCEQM.DHCEQMMaintRequest).LastAuditAction(MRRowID,User)	//modified by CZF0075 2020-02-25
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		//midified by zy 2015-7-1 ZY0134
		s (UnusualStatus,UnusualRemark)=""
	}	
 	else
 	{
	 	//Modify by zx 2020-08-04 BUG ZX0099 提交为非最终审核时修改共享资源状态
		s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource("31",MRRowID,"1")
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
 	//Mozy	900363	2019-5-24	修改设备显示状态信息,过滤简易台账泛类设备
 	s EquipID=""
	s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",63)
	//modified by wy 2022-4-12 SourceTypeDR类行
	i ((ObjSourceTypeDR=1)||(ObjSourceTypeDR=2)||(ObjSourceTypeDR=3))   
	{
		s ObjDR = $Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",5)
		i ObjDR'= ""
		{
			s EquipID=+$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)
			s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") // 简易台账类组
			i (((","_FacilityEquipType_",")[(","_$p($g(^DHCEQEquip(EquipID)),"^",63)_","))&&($p($g(^DHCEQEquip(EquipID)),"^",83)="Y"))
			{
				// 简易台账泛类设备不处理更新异常状态信息
			}
			else
			{
	 			s ReturnInfo=##Class(web.DHCEQ.Plat.BUSChangeInfo).UpdateEquipUnusualStatus(EquipID,UnusualStatus,UnusualRemark)
				s ReturnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(ReturnInfo)		//CZF0131 2020-01-20
				s SQLCODE=ReturnObj.SQLCODE
				i SQLCODE
				{
					TROLLBACK
					q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9040,ReturnObj.Data)
				}
			}
		}
	}
	
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", MRRowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag,GroupID)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//Modefied by zc0094 2021-1-14 修正工程师报修完成后设备状态不更新  begin
	/*
	;Mozy		2020-1-19	设置共享资源设备故障状态
	s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource("31",MRRowID,"1") //Modify by zx 2020-05-28 BUG ZX0090 状态为1表示故障
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}*/
	//Modefied by zc0094 2021-1-14 修正工程师报修完成后设备状态不更新  end
	//add by wy 2022-4-12 维修人存在的情况下直接受理进行维修 存在维修组也直接受理
	
	s AcceptUser=$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",26) //add by zyq 2022-11-23
	s MaintGroupDR=$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",70)
	s MaintType=$Piece($Get(^DHCEQMMaintRequest(MRRowID)),"^",76)
	if (AcceptUser'="")||(MaintGroupDR'="")
	{
		s LIst= MRRowID_"^"_User_"^^^"_GroupID
		if (MaintType=1) //modify by zyq 2022-11-23 begin
		{
			s CurActionCode="WX_Accept" 
		}
		else  
		{
			s CurActionCode="WX_Assign" 
		} //modify by zyq 2022-11-23 end
		s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,CurActionCode)
		s CurRole=$p(RoleInfo,"^",1)
		s CurRoleStep=$p(RoleInfo,"^",2)
		s CurApproveFlowID=$p(RoleInfo,"^",3)
		s SQLCODE=##Class(web.DHCEQ.EM.BUSMMaintRequest).AuditData(LIst, CurRole, CurRoleStep,"", CurApproveFlowID, "", CurActionCode, "")
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}

	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
ERRORSubmit 
	TROLLBACK	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息
}

/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).AuditData("1^77^^^^","","","DHC_EQMMaintRequest&1^,35^,96","","","WX_Accept","")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo, ApproveFlowID As %Library.String = "", ApproveOpinion As %Library.String = "", ActionCode As %Library.String = "", vEvaluatInfo As %Library.String = "")
{
	New EquipType,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	New User,Date,RowID,result,MaintDR,vStatus
	n UnusualStatus,UnusualRemark,UnusualFlag,FacilityEquipType
	n UnusualFlag,ObjSourceTypeDR,ObjDR,EquipID,FacilityEquipType
	s UnusualFlag=0
	s ApproveOpinion=$g(ApproveOpinion)
	Set $ZT="ERRORAudit"
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9003)
	s vStatus=$Piece($G(^DHCEQMMaintRequest(RowID)),"^",41)
	if vStatus'="1" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002)   //该记录状态不符合,不能执行操作!
	
	Set User=$Piece(val,"^",2)
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set GroupID=$Piece(val,"^",5)
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("25", RowID)
	If ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9020)
	//add by zx 2017-06-20 BUG ZX0038 传动作时 根据动作获取角色和步骤
	i ActionCode'="" d
	.s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode)
	.s CurRole=$p(RoleInfo,"^",1)
	.s RoleStep=$p(RoleInfo,"^",2)
	e  d
	.s ALRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,RoleStep,0))  // add by wy 2022-8-29
	.s CurAction=$p($g(^DHCEQCCode("DHCEQCApproveFlow",ALRowID)),"^",9)
	.s ActionCode=$p($g(^DHCEQCCode("DHCEQCAction",CurAction)),"^",9)
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole, ApproveFlowID)
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)

	Set AppInfoStatus="1"			;AppInfoStatus	

	s AuditFlag=0
	
	TSTART
	//评价信息	
	i vEvaluatInfo'=""
	{
		Set SQLCODE=##class(web.DHCEQEvaluate).SaveData($p(vEvaluatInfo,"@",2),$p(vEvaluatInfo,"@",3),"","N")
		If SQLCODE<0
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	If editFieldsInfo'=""
	{
		
		Set SQLCODE=##class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)	//编辑要修改的字段
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""					//执行当前角色要执行的动作
	{	  
	    
        	Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,"","",ActionCode)  // add by wy 2022-8-29
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}

		//midified by zy 2015-7-1 ZY0132
		if Actions["UpdateUnusualStatus"
		{
			s UnusualFlag=1
			s UnusualStatus="4"
			s UnusualRemark="维修受理"
		}
	}
	i $Piece($G(^DHCEQMMaintRequest(RowID)),"^",89)="Y" s LastFlag="Y"  //Modefied by zc 2022-4-8
	// 最终审核操作
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set SQLCODE= ##Class(web.DHCEQM.DHCEQMMaintRequest).LastAuditAction(RowID,User)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		Set AppInfoStatus="2"			;AppInfoStatus
		;Modified by jdl 2011-3-9  jdl0073
		Set AuditFlag=1
		//midified by zy 2015-7-1 ZY0132
		s UnusualFlag=1
		s (UnusualStatus,UnusualRemark)=""
	}
	//2015-10-08 ZY0146  表增加一个审批标记:统一/拒绝 
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,ApproveOpinion,"",CurRole,RoleStep,User,"0")  ;HHM
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
 	//midified by zy 2015-7-1 ZY0132 
 	//修改设备显示状态信息
 	if UnusualFlag=1
 	{
	 	//Modefied by zc 2022-4-8 begin
	 	i $Piece($G(^DHCEQMMaintRequest(RowID)),"^",89)="Y" d
	 	.s UnusualStatus="6"
	 	.s UnusualRemark="无价值维修,建议报废"
	 	//Modefied by zc 2022-4-8 end
	 	s EquipID=""
		s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
		//modified by wy 2022-4-12 SourceTypeDR类行
		i ((ObjSourceTypeDR=1)||(ObjSourceTypeDR=2)||(ObjSourceTypeDR=3))
		{
			s ObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
			i ObjDR'= ""
			{
				s EquipID=+$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)
				s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") // 简易台账类组
				i (((","_FacilityEquipType_",")[(","_$p($g(^DHCEQEquip(EquipID)),"^",63)_","))&&($p($g(^DHCEQEquip(EquipID)),"^",83)="Y"))
				{
					// 简易台账泛类设备不处理更新异常状态信息
				}
				else
				{
		 			s ReturnInfo=##Class(web.DHCEQ.Plat.BUSChangeInfo).UpdateEquipUnusualStatus(EquipID,UnusualStatus,UnusualRemark)
					s ReturnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(ReturnInfo)	//CZF0131 2020-01-20
					s SQLCODE=ReturnObj.SQLCODE
					i SQLCODE
					{
						TROLLBACK
						q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9040,ReturnObj.Data)
					}
				}
			}
		}
	}
	
	;Modified by jdl 2011-3-9  jdl0073
	s vLimitActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Accept",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Maint",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Finish",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Appearance",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_BeRetrieved",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Retrieve",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Return",0))
	s vLimitUserDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",26)
	s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Audit",0))_","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_LocAudit",0)) //add by zx 2017-01-09 科室最后一步审核 ZX0036
	s LimitLocDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",6)		//StoreLocDR
	s RequestLocDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",7)
	s vLimitLocDR=LimitLocDR
	s MTPInputType=##class(web.DHCEQCommon).GetSysInfo("503006")
	i MTPInputType="DHC-STM" s vLimitLocDR=LimitLocDR_","_RequestLocDR		//申请科室和使用科室都有权限modified by czf 2020-09-25 CZF0091
	s LinkLocFlag=##class(web.DHCEQCommon).GetSysInfo("992011")
	i LinkLocFlag="1" s vLimitLocDR=LimitLocDR_","_RequestLocDR

	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag,GroupID,vLimitActions,vLimitUserDR,vLimitLocActions,vLimitLocDR)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;;;;;;;;;特殊审批流设置:配件确认默认该步骤通过时确认全部配件数量	Mozy	2015-12-7
	/*
	s ContrastID=$o(^DHCEQCCode("DHCEQCContrastInfo",0,"SYSID",1,RequestLocDR,""))		//modified by czf 2020-09-25 科室确认配件时提交至被对照科室 CZF0091
	i ContrastID'=""
	{
		s ExID=$p($g(^DHCEQCCode("DHCEQCContrastInfo",ContrastID)),"^",5)
		i ExID=LimitLocDR s LimitLocDR=RequestLocDR
	}
	*/
	s INRequestID=""
	if ((RoleStep=3)&&(ApproveSet=37)) s INRequestID=##class(web.DHCEQM.DHCEQMMaintPart).ConfirmMaintPart(RowID,1,User,LimitLocDR)
	i INRequestID<0
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(INRequestID)
	}
	//保存物资申领单ID至维修表 modified by czf 2020-09-25 CZF0091
	&SQL(Update SQLUSER.DHC_EQMMaintRequest set MR_Hold15=:INRequestID where MR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	//维修完成启用设备Add By DJ 2018-03-18
 	s MStartStopFlag=$p(val,"^",5)
 	if +MStartStopFlag>=1
 	{
		s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
		s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
		If TExObjDR'=""
		{
			//modified by wy 2022-4-12 SourceTypeDR类行
			i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)
			{
				new ChangeInfoDR   ;add by kdf 需求号573050
				s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
				;检测是否已存停用记录
				K PL
				s PL(2)=EQRowID
				s PL(4)=1
				s PL(5)=+$H
				s PL(6)=31
				s PL(7)=RowID
				s PL(8)=2
				s PL(9)=2
				s PL(10)=1
				s PL(14)="维修启用"
				s PL(16)="N"
				s PL(23)=+$H
				s PL(24)=$P($H,",",2)
				s PL(25)=User
				s CIRowID=$o(^DHCEQChangeInfo(0,"EquipChangeType",EQRowID,1,31,RowID,0))
				i CIRowID=""
				{
					&SQL(Insert Into SQLUSER.DHC_EQChangeInfo Values :PL())
					i SQLCODE
					{
						TROLLBACK
						q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
					}
					//add by kdf 需求号573050 begin********
					s ChangeInfoDR=$G(%ROWID)
					k LI
					s LI(2)=EQRowID  //设备
					s LI(4)=$p($g(^DHCEQEquip(EQRowID)),"^",19)   	//原使用科室
					s LI(5)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//原管理科室
					s LI(6)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//原库房
					s LI(7)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//原值
					s LI(8)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//原净值
					s LI(9)=$p($g(^DHCEQEquip(EQRowID)),"^",19)  	//变动后使用科室
	 				s LI(10)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//变动后管理科室
	 				s LI(11)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//变动后库房
	 				s LI(12)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//变动后原值
	 				s LI(13)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//变动后净值
					s LI(14)="启用"
					s LI(16)=+$H	//变动日期
					s LI(17)=$P($H,",",2)	//变动时间
					s LI(19)="C"	//生命周期类型
					s LI(20)=41		//来源类型
					s LI(21)=ChangeInfoDR	//来源ID
					s LI(27)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//更新人
					s LI(28)=+$H	//更新日期
					s LI(29)=$P($H,",",2)	//更新时间
					&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
					//add by kdf 需求号573050 end ********
				}
				i SQLCODE
				{
					TROLLBACK
					q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
				}
				&SQL(Update SQLUser.DHC_EQEquip set EQ_Status=1 where EQ_RowID=:EQRowID)
			}
		}
 	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE				//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)		//返回错误消息
}

/// Modify by zx 2022-08-15 增加动作参数
/// Modify by zx 2022-09-06 增加参数  取消到哪一动作所在审批流 ToFlowActionCode
/// Modify by WY 2022-09-09 取消到哪一动作时
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).CancelSubmitData("401^77^^^85^","","WX_LocAudit","")
ClassMethod CancelSubmitData(val, CurRole, ActionCode As %Library.String = "", ToFlowActionCode As %Library.String = "")
{
	n UnusualFlag,ObjSourceTypeDR,ObjDR,EquipID,FacilityEquipType
	s UnusualFlag=0
	s CanceToFlowlFlag=""
	Set $ZT="ERRORCancel"
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9003)

	Set User=$Piece(val,"^",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	s Opinion=$P(val,"^",6)		;Add By QW20211224
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
		//midified by zy 2015-7-1 ZY0134 
		s ApproveSetDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",1)
		Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSetDR, Step, ApproveRoleDR)
		if Actions["UpdateUnusualStatus"
		{
			s UnusualStatus="4"
			s UnusualRemark="维修受理"
		}
		else
		{
			s UnusualStatus="3"
			s UnusualRemark="报修"
		}
		s UnusualFlag=1
	}
	//midified by zy 2015-7-1 ZY0134
	else
	{
		s (UnusualStatus,UnusualRemark)=""
		s UnusualFlag=1
	}
	//Modify by zx 2022-09-06 取消到某一动作所在审批流
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("25", RowID)
	if (ApproveSet'="")&&(ToFlowActionCode'="")
	{
		s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code",ToFlowActionCode,0))
    	s ApproveFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionID,0))
    	s CancelToFlowDR=ApproveFlowID
    	Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
		set CanceToFlowlFlag="Y" //add by wy 2022-9-9  取消到某一动作所记录标记
		Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, Step, ApproveRoleDR)
		if Actions["UpdateUnusualStatus"
		{
			s UnusualStatus="4"
			s UnusualRemark="维修受理"
		}
		else
		{
			s UnusualStatus="3"
			s UnusualRemark="报修"
		}
		s UnusualFlag=1
	}
	TSTART
	;Set PLIST(4)=RejectReasonDR
	//Set PLIST(9)=User		;RejectUserDR
	//Set PLIST(10)=Date		;RejectDate
	Set PLIST(11)=Status
	;Set PLIST(12)=Remark
	
	//2015-10-08 ZY0146   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	//Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("25", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	//Modify by zx 2022-08-15
	i ActionCode'="" d
	.s CurRole=$p(##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode),"^",1)
	.s RoleStep=$p(##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode),"^",2)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,"",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y",CanceToFlowlFlag) //modified by WY 2022-9-14 传回置标记给ApproveInfo
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}

	&sql(Update sqluser.DHC_EQMMaintRequest set MR_Status=:Status,MR_CancelUser=:User,MR_CancelDate=:Date,MR_CancelTime=:Time where MR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	else
	{
		s ApproveFlow="^^^^^^^^"_ApproveSet	//Add By DJ 2016-05-23
	}
	
 	//midified by zy 2015-7-1 ZY0134 
 	//修改设备显示状态信息
 	if UnusualFlag=1
 	{
	 	//Mozy	900363	2019-5-24	修改设备显示状态信息,过滤简易台账泛类设备
	 	s EquipID=""
		s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
		//modified by wy 2022-4-12 SourceTypeDR类行
		i ((ObjSourceTypeDR=1)||(ObjSourceTypeDR=2)||(ObjSourceTypeDR=3))
		{
			s ObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
			i ObjDR'= ""
			{
				s EquipID=+$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)
				s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") // 简易台账类组
				i (((","_FacilityEquipType_",")[(","_$p($g(^DHCEQEquip(EquipID)),"^",63)_","))&&($p($g(^DHCEQEquip(EquipID)),"^",83)="Y"))
				{
					// 简易台账泛类设备不处理更新异常状态信息
				}
				else
				{
					//同一设备存在多条有效的未完成维修记录时不更新异常状态Add By DJ 2019-09-19
					s NewStatusCount=0
					s NMRRowID=""
					f  s NMRRowID=$o(^DHCEQMMaintRequest(0,"Source",ObjSourceTypeDR,ObjDR,NMRRowID),-1)  q:(NMRRowID="")||(NewStatusCount'=0)  d
					.q:NMRRowID=RowID
					.s NMRInvalidFlag=$p($g(^DHCEQMMaintRequest(NMRRowID)),"^",57)
					.q:NMRInvalidFlag="Y"
					.s NMRStatus=$p($g(^DHCEQMMaintRequest(NMRRowID)),"^",41)
					.q:NMRStatus=2
					.s NewStatusCount=NewStatusCount+1
					
					i NewStatusCount=0
					{
			 			s ReturnInfo=##Class(web.DHCEQ.Plat.BUSChangeInfo).UpdateEquipUnusualStatus(EquipID,UnusualStatus,UnusualRemark)
						s ReturnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(ReturnInfo)		//CZF0131 2020-01-20
						s SQLCODE=ReturnObj.SQLCODE
						i SQLCODE
						{
							TROLLBACK
							q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9040,ReturnObj.Data)
						}
						//Modify by zx 2020-08-04 取消提交时修改共享资源状态 BUG ZX0099
						s SQLCODE=##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource("31",RowID,"0")
						i SQLCODE
						{
							TROLLBACK
							q SQLCODE
						}
					}
				}
			}
		}
	}
	
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	TCOMMIT

 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
 	
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息
}

ClassMethod GetMaintHistory(vEQRowID As %String = "")
{
	i vEQRowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	s vEQRowID=$o(^DHCEQMExObj(0,"ExID",1,vEQRowID,0))
	k ^temp($J,"mainthistory")
	s SourceType=0
	f  s SourceType=$o(^DHCEQMMaintRequest(0,"Source",SourceType))  q:SourceType=""  d
	.q:((SourceType'=1)&&(SourceType'=2))
	.s MRRowID=0
	.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Source",SourceType,vEQRowID,MRRowID))  q:MRRowID=""  d
	..s ObjMaintRequest=##Class(User.DHCEQMMaintRequest).%OpenId(MRRowID)
	..q:ObjMaintRequest.MRInvalidFlag="Y"
	..q:ObjMaintRequest.MRStatus'="2"
	..s ^temp($J,"mainthistory",MRRowID)=1
	
	s MaintHistory=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s MRRowID=0
	f  s MRRowID=$o(^temp($J,"mainthistory",MRRowID))  q:MRRowID=""  d
	.s ObjMaintRequest=##Class(User.DHCEQMMaintRequest).%OpenId(MRRowID)
	.s MaintRequestInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjMaintRequest)
	.s OneMaintHistory=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	.d OneMaintHistory.%Set("RequestDate",MaintRequestInfo.%Get("MRRequestDate"))
	.d OneMaintHistory.%Set("RequestUser",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRRequestUserDR))
	.d OneMaintHistory.%Set("FaultCaseDR",MaintRequestInfo.%Get("MRFaultCaseDR"))
	.d OneMaintHistory.%Set("DealMethodDR",MaintRequestInfo.%Get("MRDealMethodDR"))
	.d OneMaintHistory.%Set("FaultReasonDR",MaintRequestInfo.%Get("MRFaultReasonDR"))
	.d OneMaintHistory.%Set("FaultCase",ObjMaintRequest.MRFaultCaseDR.FCDesc)
	.d OneMaintHistory.%Set("FaultReason",ObjMaintRequest.MRFaultReasonDR.FRDesc)
	.d OneMaintHistory.%Set("DealMethod",ObjMaintRequest.MRDealMethodDR.DMDesc)
	.d OneMaintHistory.%Set("AcceptUser",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaintRequest.MRAcceptUserDR))
	.d MaintHistory.%Set(MRRowID,OneMaintHistory)

	k ^temp($J,"mainthistory")
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,MaintHistory)
}

/// Add By DJ 2019-07-29
/// 根据设备当前状态判断是否可以停用启用
/// 入参:vBussType 业务类型
/// 		vBussRowID 业务RowID
/// 		vEQRowID 设备RowID
/// 		vStopStartFlag 计划停启用标志  1表示启用  2表示停用
/// 返回值:0表示不操作,1表示可操作
ClassMethod GetEQStopStartFlag(vBussType As %String = "", vBussRowID As %String = "", vEQRowID As %String = "", vStopStartFlag As %String = "")
{
	i ((vBussRowID="")&&(vEQRowID="")) q 0
	i vStopStartFlag="" q 0
	i vBussType="31"
	{
		s SourceTypeDR=$p($g(^DHCEQMMaintRequest(vBussRowID)),"^",63)
		//modified by wy 2022-4-12 SourceTypeDR类行
		i ((SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3))
		{
			s EXObjDR=$p($g(^DHCEQMMaintRequest(vBussRowID)),"^",5)
			s vEQRowID=$p($g(^DHCEQMExObj(EXObjDR)),"^",5)
		}
	}
	i vEQRowID=""  q 0
	s EQStatus=$p($g(^DHCEQEquip(vEQRowID)),"^",38)		//0在库,1启用,2停用
	i ((EQStatus=0)||(EQStatus=vStopStartFlag)) q 0
	q 1
}

///  add by sjh 2019-11-29 维修单润乾打印  BUG00018
///  d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMMaintRequest","MaintRequestPrint","16")
///  RequestNO,RequestDate,ObjLoc,EquipName,EquipNo,Model,LeaveFactoryNo,EquipStatus,FaultCase,StartDate,RequestUser,RequestTel,FaultCaseRemark,UserOpinion,UserSign,Remark,AcceptDate,AcceptUser,FaultType,MaintMode,FaultReason,FaultReasonRemark,DealMethod,EndDate,MainFee,OtherFee,TotalFee,MaintResults,MaintRemark
Query MaintRequestPrint(RowID As %String) As %Query(ROWSPEC = "RequestNo:%String,RequestDate:%String,ObjLoc:%String,EquipName:%String,EquipNo:%String,Model:%String,LeaveFactoryNo:%String,EquipStatus:%String,FaultCase:%String,StartDate:%String,RequestUser:%String,RequestTel:%String,FaultCaseRemark:%String,UserOpinion:%String,UserSign:%String,Remark:%String,AcceptDate:%String,AcceptUser:%String,FaultType:%String,MaintMode:%String,FaultReason:%String,FaultReasonRemark:%String,DealMethod:%String,EndDate:%String,MainFee:%String,OtherFee:%String,TotalFee:%String,MaintResults:%String,MaintRemark:%String,MaintCompany:%String") [ SqlProc ]
{
}

ClassMethod MaintRequestPrintExecute(ByRef qHandle As %Binary, RowID As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s EquipRowID=0
	
	q:RowID=""
	d ResetVariablesMaintRequestPrint
	s RequestNO=$p($g(^DHCEQMMaintRequest(RowID)),"^",1)
	s RequestDate=$p($g(^DHCEQMMaintRequest(RowID)),"^",18)
	s RequestDate=##class(web.DHCEQCommon).TransValueToPage(RequestDate,"date")
	s ObjLocDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",6)
	i ObjLocDR'="" s ObjLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjLocDR)
	s ExObjDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",5)
	i ExObjDR'="" s EquipName=$p($g(^DHCEQMExObj(ExObjDR)),"^",1)
	s EquipNo=$p($g(^DHCEQMExObj(ExObjDR)),"^",2)
	i EquipNo'="" s EquipRowID=$O(^DHCEQEquip(0,"No",EquipNo,EquipRowID))
	i EquipRowID="" q ""
	s ModelDR=$p($g(^DHCEQEquip(EquipRowID)),"^",3)
	i ModelDR'="" s Model=##class(web.DHCEQCommon).GetTrakNameByID("model",ModelDR)
	s LeaveFactoryNo=$p($g(^DHCEQEquip(EquipRowID)),"^",10)
	s EquipStatusDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",68)
	i EquipStatusDR'="" s EquipStatus=$p($g(^DHCEQCCode("DHCEQEquipStatus",EquipStatusDR)),"^",2) ;$p($g(^DHCEQEquipStatus(EquipStatusDR)),"^",2) 
	s FaultCaseDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",10) 
	i FaultCaseDR'="" s FaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",FaultCaseDR)),"^",2) ;$p($g(^DHCEQMCFaultCase(FaultCaseDR)),"^",2)
	s StartDate=$p($g(^DHCEQMMaintRequest(RowID)),"^",8)
	s StartDate=##class(web.DHCEQCommon).TransValueToPage(StartDate,"date")
	s RequestUserDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",20)
	i RequestUserDR'="" s RequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",RequestUserDR)
	s RequestTel=$p($g(^DHCEQMMaintRequest(RowID)),"^",21)		//modified by fx 2022-12-01 修改参数RequestTel
	s FaultCaseRemark=$p($g(^DHCEQMMaintRequest(RowID)),"^",11)
	s UserOpinion=$p($g(^DHCEQMMaintRequest(RowID)),"^",33)
	s UserSignDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",32)
	i UserSignDR'="" s UserSign=##class(web.DHCEQCommon).GetTrakNameByID("user",UserSignDR)
	s Remark=$p($g(^DHCEQMMaintRequest(RowID)),"^",40)
	s AcceptDate=$p($g(^DHCEQMMaintRequest(RowID)),"^",24)
	s AcceptDate=##class(web.DHCEQCommon).TransValueToPage(AcceptDate,"date")
	s AcceptUserDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",26)
	i AcceptUserDR'="" s AcceptUser=##class(web.DHCEQCommon).GetTrakNameByID("user",AcceptUserDR)
	s FaultTypeDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",23)
	i FaultTypeDR'="" s FaultType=$p($g(^DHCEQCCode("DHCEQMCFaultType",FaultTypeDR)),"^",2) ;$p($g(^DHCEQMCFaultType(FaultTypeDR)),"^",2)
	s MaintModeDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",28)
	i MaintModeDR'="" s MaintMode=$p($g(^DHCEQCCode("DHCEQMCMaintMode",MaintModeDR)),"^",2) 
	s FaultReasonDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",12)
	i FaultReasonDR'="" s FaultReason=$p($g(^DHCEQCCode("DHCEQMCFaultReason",FaultReasonDR)),"^",2) ;$p($g(^DHCEQMCFaultReason(FaultReasonDR)),"^",2)
	s FaultReasonRemark=$p($g(^DHCEQMMaintRequest(RowID)),"^",13)
	s DealMethodDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",14)
	i DealMethodDR'="" s DealMethod=$p($g(^DHCEQCCode("DHCEQMCDealMethod",DealMethodDR)),"^",2) ;$p($g(^DHCEQMCDealMethod(DealMethodDR)),"^",2)
	s EndDate=$p($g(^DHCEQMMaintRequest(RowID)),"^",16)
	s EndDate=##class(web.DHCEQCommon).TransValueToPage(EndDate,"date")
	s MainFee=$fn($p($g(^DHCEQMMaintRequest(RowID)),"^",58),"",2)
	s OtherFee=$fn($p($g(^DHCEQMMaintRequest(RowID)),"^",59),"",2)
	s TotalFee=$fn($p($g(^DHCEQMMaintRequest(RowID)),"^",60),"",2)
	s MaintResultsDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",67)
	i MaintResultsDR'="" s MaintResults=$p($g(^DHCEQCCode("DHCEQMCMaintResults",MaintResultsDR)),"^",2) ;$p($g(^DHCEQMCMaintResults(MaintResultsDR)),"^",2)
	s MaintRemark=$p($g(^DHCEQMMaintRequest(RowID)),"^",37)
	s ServiceDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",31) //add by zyq 2022-12-06
	i ServiceDR'="" s MaintCompany=$p($g(^DHCEQCCode("DHCEQCVendor",ServiceDR)),"^",2) //add by zyq 2022-12-06
	d OutputRowMaintRequestPrint
	quit $$$OK
OutputRowMaintRequestPrint
	Set Data=$lb(RequestNO,RequestDate,ObjLoc,EquipName,EquipNo,Model,LeaveFactoryNo,EquipStatus,FaultCase,StartDate,RequestUser,RequestTel,FaultCaseRemark,UserOpinion,UserSign,Remark,AcceptDate,AcceptUser,FaultType,MaintMode,FaultReason,FaultReasonRemark,DealMethod,EndDate,MainFee,OtherFee,TotalFee,MaintResults,MaintRemark,MaintCompany)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMaintRequestPrint
	Set (RequestNO,RequestDate,ObjLoc,EquipName,EquipNo,Model,LeaveFactoryNo,EquipStatus,FaultCase,StartDate,RequestUser,RequestTel,FaultCaseRemark,UserOpinion,UserSign,Remark,AcceptDate,AcceptUser,FaultType,MaintMode,FaultReason,FaultReasonRemark,DealMethod,EndDate,MainFee,OtherFee,TotalFee,MaintResults,MaintRemark,MaintCompany)=""
	quit
}

ClassMethod MaintRequestPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintRequestPrintExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MaintRequestPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintRequestPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ----------------------------------
/// 创建:JYP  2020-03-12  JYP0023
/// 描述：作废按钮功能
ClassMethod CancelMaintRequest(RowID As %Library.String)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	//Moidefied by zc0066 2020-4-11 初始化SQLCODE以及事件开始 begin
	s SQLCODE=0
	TSTART
	//Moidefied by zc0066 2020-4-11 初始化SQLCODE以及事件开始 end
	&sql(Update sqluser.DHC_EQMMaintRequest Set MR_Status=3,MR_CancelUser=:User,MR_CancelDate=:Date,MR_CancelTime=:Time where MR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK  //Moidefied by zc0066 2020-4-11 事务回滚
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//Moidefied by zc0066 2020-4-11 作废维修单同时作废其生命周期信息  begin
	&SQL(Update SQLUSER.DHC_EQLifeInfo Set LI_UpdateUserDR=:User,LI_UpdateDate=:Date,LI_UpdateTime=:Time,LI_Hold2='Y' Where LI_SourceType=31 and LI_SourceID=:RowID)	
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	//Moidefied by zc0066 2020-4-11 作废维修单同时作废其生命周期信息  end
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
}

/// 创建:MWZ 2021-01-18
/// 描述:当前人取消提交
/// 入参 val:维修单rowid，CurRole ：当前菜单ApproveRole
/// 返回值：SQLCODE  RowID
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).SelfCancelSubmitData("11^","")
ClassMethod SelfCancelSubmitData(val As %Library.String = "", CurRole)
{
	s UnusualFlag=0 
	s RowID=$Piece(val,"^",1)
	q:RowID="" ""
	/// Modify by mwz 20210529 MWZ0050  BEGIN 
	s APLRowID="",CurStep=0,ActionDR="",CurActionDR="",CancelToFlowDR=""
	s $ZT="ERRORSelfCancelSubmitData"
	s Action=$Piece(val,"^",3)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s updDate=+$H
 	s updTime=$Piece($H,",",2)
 	s MRStatus=$P($G(^DHCEQMMaintRequest(RowID)),"^",41)
 	i MRStatus>1 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9006") //单据审核完成无法撤回
 	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("25", RowID)
 	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	s RejectReason="自发撤回"
	s Status="0"     
	s ApproveRoleDR=""
	s Step="1"
	i Action'="" d
	.s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,Action)
	.s CancelToFlowDR=$p(RoleInfo,"^",3)
	.s ActionDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code",Action,0))
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s APLRowID=$o(^DHCEQApproveList(0,"Source",ApproveType,RowID,""),-1)
		i APLRowID'="" d 
		.s CurStep=$p($g(^DHCEQApproveList(APLRowID)),"^",9)
		.s CurActionDR=$p($g(^DHCEQApproveList(APLRowID)),"^",11)
		/// Modify by mwz 20210529 MWZ0050  END
		s Status="1"		
		s ApproveSetDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",1)
		s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSetDR, Step, ApproveRoleDR)
		if Actions["UpdateUnusualStatus"
		{
			s UnusualStatus="4"
			s UnusualRemark="维修受理"
		}
		else
		{
			s UnusualStatus="3"
			s UnusualRemark="报修"
		}
		s UnusualFlag=1
	}
	else
	{
		s (UnusualStatus,UnusualRemark)=""
		s UnusualFlag=1
	}
	i (CurActionDR'=ActionDR)&&(ActionDR'="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9022") /// Modify by mwz 20210529 MWZ0050
	TSTART
	
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,CurStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s PLIST(42)=	Status	// MR_Status
	&sql(Update SQLUSER.DHC_EQMMaintRequest Values :PLIST() where MR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1603",SQLCODE)
	}
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	 //修改设备显示状态信息
 	if UnusualFlag=1
 	{
	 	s EquipID=""
		s ObjSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)	
		i ObjSourceTypeDR=1    
		{
			s ObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
			i ObjDR'= "" s EquipID=$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)
		 	
	 		s SQLCODE=##Class(web.DHCEQChangeInfo).UpdateEquipUnusualStatus(EquipID,UnusualStatus,UnusualRemark)
			i SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9004",SQLCODE)
			} 
		}
		
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("31", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9005",SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORSelfCancelSubmitData 
	TRollBack	
	s ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit "ERRORSelfCancelSubmitData"_ErrorMsg   //返回错误消息
}

/// add by czf 2021-09-20
/// 根据设备ID获取设备维修历史记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMMaintRequest","GetEQMaintHistory","1")
Query GetEQMaintHistory(EquipDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %Query(ROWSPEC = "TRowID:%String,TMaintRequestNo:%String,TMaintRequestDate:%String,TRequestUser:%String,TFaultCase:%String,TFaultReason:%String,TDealMethod:%String,TAcceptUser:%String,TWorkHour:%String,TEndDate:%String,TMaintFee:%String,TOtherFee:%String,TTotalFee:%String") [ SqlProc ]
{
}

ClassMethod GetEQMaintHistoryExecute(ByRef qHandle As %Binary, EquipDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %Status
{
	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
	i EquipDR="" Quit $$$OK
	s vEQRowID=$o(^DHCEQMExObj(0,"ExID",1,EquipDR,0))
	i vEQRowID="" Quit $$$OK
 	i StartMonth'="" Set PStartDate=$zdh(StartMonth_"-01",3)
 	e  s PStartDate=0
 	i EndMonth'="" Set PEndDate=##Class(web.DHCEQCommon).DateAddInt("M",1,$zdh(EndMonth_"-01",3))-1
	e  s PEndDate=+$h

	s SourceType=0
	f  s SourceType=$o(^DHCEQMMaintRequest(0,"Source",SourceType))  q:SourceType=""  d
	.q:((SourceType'=1)&&(SourceType'=2))
	.s MRRowID=0
	.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Source",SourceType,vEQRowID,MRRowID))  q:MRRowID=""  d
	..d ResetGetEQMaintHistory
	..s TRowID=MRRowID
	..s MaintRequestInfo=$g(^DHCEQMMaintRequest(TRowID))
	..q:$p(MaintRequestInfo,"^",57)="Y"
	..q:$p(MaintRequestInfo,"^",41)'="2"
	..s TEndDate=$p(MaintRequestInfo,"^",16)
	..q:(TEndDate<PStartDate)||(TEndDate>PEndDate)
	..s TMaintRequestNo=$p(MaintRequestInfo,"^",1)
	..s TMaintRequestDate=##class(web.DHCEQCommon).TransValueToPage($p(MaintRequestInfo,"^",18),"date")
	..s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",$p(MaintRequestInfo,"^",20))
	..s TFaultCaseDR=$p(MaintRequestInfo,"^",10)
	..i TFaultCaseDR'="" s TFaultCase=$p($g(^DHCEQCCode("DHCEQMCFaultCase",TFaultCaseDR)),"^",2)		//2270598 czf
	..i TFaultCase="" s TFaultCase=$p(MaintRequestInfo,"^",11)
	..s TFaultReasonDR=$p(MaintRequestInfo,"^",12)
	..i TFaultReasonDR'="" s TFaultReason=$p($g(^DHCEQCCode("DHCEQMCFaultReason",TFaultReasonDR)),"^",2)
	..i TFaultReason="" s TFaultReason=$p(MaintRequestInfo,"^",13)
	..s TDealMethodDR=$p(MaintRequestInfo,"^",14)
	..i TDealMethodDR'="" s TDealMethod=$p($g(^DHCEQCCode("DHCEQMCDealMethod",TDealMethodDR)),"^",2)
	..i TDealMethod="" s TDealMethod=$p(MaintRequestInfo,"^",15)
	..s TAcceptUser=##class(web.DHCEQCommon).GetTrakNameByID("user",$p(MaintRequestInfo,"^",26))
	..s TWorkHour=$p(MaintRequestInfo,"^",39)
	..s TEndDate=##class(web.DHCEQCommon).TransValueToPage($p(MaintRequestInfo,"^",16),"date")
	..s TMaintFee=##class(web.DHCEQCommon).FormatNumber($p(MaintRequestInfo,"^",58),"",2)
	..s TOtherFee=##class(web.DHCEQCommon).FormatNumber($p(MaintRequestInfo,"^",59),"",2)
	..s TTotalFee=##class(web.DHCEQCommon).FormatNumber($p(MaintRequestInfo,"^",60),"",2)
	..d OutPutEQMaintHistory
	Quit $$$OK

OutPutEQMaintHistory
	Set Data=$lb(TRowID,TMaintRequestNo,TMaintRequestDate,TRequestUser,TFaultCase,TFaultReason,TDealMethod,TAcceptUser,TWorkHour,TEndDate,TMaintFee,TOtherFee,TTotalFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetEQMaintHistory
	s (TRowID,MaintRequestInfo,TMaintRequestNo,TMaintRequestDate,TRequestUser,TFaultCaseDR,TFaultCase,TFaultReasonDR,TFaultReason,TDealMethodDR,TDealMethod,TAcceptUser,TWorkHour,TEndDate,TMaintFee,TOtherFee,TTotalFee)=""
	quit
}

ClassMethod GetEQMaintHistoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEQMaintHistoryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEQMaintHistoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEQMaintHistoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by czf
/// 获取设备总维修次数
/// w ##class(web.DHCEQ.EM.BUSMMaintRequest).GetEQMaintRequestNum(13318,"2019-01","2019-12")
ClassMethod GetEQMaintRequestNum(EquipDR, StartMonth As %String = "", EndMonth As %String = "")
{
	n (EquipDR,StartMonth,EndMonth)
	n SourceType,vEQRowID,MRRowID,MaintNum,PStartDate,PEndDate
	i StartMonth'="" Set PStartDate=$zdh(StartMonth_"-01",3)
 	e  s PStartDate=0
 	i EndMonth'="" Set PEndDate=##Class(web.DHCEQCommon).DateAddInt("M",1,$zdh(EndMonth_"-01",3))-1
	e  s PEndDate=+$h
	s MaintNum=0
	
	s vEQRowID=$o(^DHCEQMExObj(0,"ExID",1,EquipDR,0))
	i vEQRowID'=""
	{
		s SourceType=0
		f  s SourceType=$o(^DHCEQMMaintRequest(0,"Source",SourceType))  q:SourceType=""  d
		.q:((SourceType'=1)&&(SourceType'=2))
		.s MRRowID=0
		.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Source",SourceType,vEQRowID,MRRowID))  q:MRRowID=""  d
		..s TRowID=MRRowID
		..s MaintRequestInfo=$g(^DHCEQMMaintRequest(TRowID))
		..q:$p(MaintRequestInfo,"^",57)="Y"
		..q:$p(MaintRequestInfo,"^",41)'="2"
		..s TEndDate=$p(MaintRequestInfo,"^",16)
		..q:(TEndDate<PStartDate)||(TEndDate>PEndDate)
		..s MaintNum=MaintNum+1
	}
	q MaintNum
}

/// Creator:add WY 2021-11-15
/// 获取设备是否在保标志和保修结束日期
/// w ##class(web.DHCEQ.EM.BUSMMaintRequest).GetGuaranteeData("2410")
/// output:InsurFlag保修标志 0 否;1 是 ，EndDate保修截止时间，MonthNum保修月份，Days剩余保修天数
ClassMethod GetGuaranteeData(nEquipDR As %String = "") As %String
{
	s InsurFlag=0
	s Days=0
	s Date=$H
	s Time=$p($h,",",2)
	if nEquipDR="" q ""
	//保修开始计算的时间点	0:验收日期  1:入库日期
	s BeginFlag=##class(web.DHCEQCommon).GetSysInfo("990039")
	i BeginFlag="" s BeginFlag=1
	s EDataList=$g(^DHCEQEquip(nEquipDR))
	i $p(EDataList,"^",59)="Y" q ""
	i ($p(EDataList,"^",60)="0")||($p(EDataList,"^",60)>"2") q ""
	s nEquipTypeDR=$p(EDataList,"^",63)
	;q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	s nEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",nEquipTypeDR)
	;Quit:(##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,"",$p(DataList,"^",63),$p(DataList,"^",75),$p(DataList,"^",4),$p(DataList,"^",67),EquipID,$p(DataList,"^",7)))
	s Name=$p(EDataList,"^",1)
	s EquipNo=$p(EDataList,"^",71)
	s MonthNum=$p(EDataList,"^",73)   ;保修月份
	s BeginDate=$p(EDataList,"^",13)	;修正保修开始日期为验收日期
	i (BeginFlag=1)||(BeginDate="") s BeginDate=$p(EDataList,"^",45)
	s CEndDate=$p(EDataList,"^",51)	;修正保修结束日期为GuaranteeEndDate
	i (CEndDate="")&&(MonthNum>0) s CEndDate=BeginDate+(30*MonthNum)
	s MaxContractDR=0
	;增加从保修合同业务获取设备的保修截止日期
	s CLRowID=0
	f  s CLRowID=$o(^DHCEQContractList(0,"SourceID",4,nEquipDR,CLRowID)) quit:CLRowID=""  d
	.s ContractDR=$P(^DHCEQContractList(CLRowID),"^",1)
	.q:($p($g(^DHCEQContract(ContractDR)),"^",24)'=2)		;过滤非审核状态合同记录
	.q:($p($g(^DHCEQContract(ContractDR)),"^",39)'=1)		;过滤非保修合同
	.i $p($g(^DHCEQContract(ContractDR)),"^",12)'<CEndDate d	;保修合同业务的保修截止日期		Mozy	2019-5-29
	..s MaxContractDR=ContractDR
	..s BeginDate=$p($g(^DHCEQContract(MaxContractDR)),"^",11)
	..s CEndDate=$p($g(^DHCEQContract(MaxContractDR)),"^",12)
	i (CEndDate>Date) s InsurFlag=1 
	s BeginDate=##class(web.DHCEQCommon).TransValueToPage(BeginDate,"date")
    ;s Days=##Class(web.DHCEQCommon).DateDiff("d",$zd(Date),$zd(CEndDate))
    ;if Days<0 s Days=0
    s TimeDiff=##Class(web.DHCEQCommon).TimeDiff(Date,Time,CEndDate,"86399") //Modify by zx 2022-08-22 截止24点
    s TotalHours=$fn(TimeDiff/3600,"",2)
    s Days=$fn(TotalHours/24,"",0)
    s Hours=TotalHours#24
	if Days<0 s Days=0
	s CEndDate=##class(web.DHCEQCommon).TransValueToPage(CEndDate,"date")
   q InsurFlag_"^"_CEndDate_"^"_MonthNum_"^"_Days_"^"_Hours_"^"_BeginDate
}

/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMMaintRequest","MaintRequestForAnaly","2021-11-30","2021-12-15","1")
Query MaintRequestForAnaly(StartDate As %String = "", EndDate As %String = "", Status As %String = "", GroupID As %String = "") As %Query(ROWSPEC = "TMaintRequestDR:%String,TObjLocDR:%String,TObjLoc:%String,TExObjDR:%String,TEquipName:%String,TEquipNo:%String,TEquipRowID:%String,TMasterItemID:%String,TRequestDate:%String,TRequestUserDR:%String,TRequestUser:%String,TAcceptDate:%String,TAcceptUserDR:%String,TAcceptUser:%String,TApproveListID:%String,TActionID:%String,TActionDesc:%String,TActionCode:%String,TStatus:%String,TMaintGroupDR:%String,TMaintGroup:%String,TTotalFee:%String") [ SqlProc ]
{
}

ClassMethod MaintRequestForAnalyExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", Status As %String = "", GroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
    if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	
	s rowid=0
	i Status'="" d
	.f  s rowid=$o(^DHCEQMMaintRequest(0,"Status",Status,rowid)) q:rowid=""  d
	..d GetMaintRequestForAnalyInfo
	e  d
	.f  s rowid=$o(^DHCEQMMaintRequest(rowid)) q:rowid=""  d
	..d GetMaintRequestForAnalyInfo
	
	quit $$$OK
GetMaintRequestForAnalyInfo
	q:$p($g(^DHCEQMMaintRequest(rowid)),"^",41)=0  //过滤新增状态
	q:$p($g(^DHCEQMMaintRequest(rowid)),"^",57)="Y"  //过滤无效状态
	s SubmitDate=$p($g(^DHCEQMMaintRequest(rowid)),"^",49)
	q:(StartDate>SubmitDate)||(EndDate<SubmitDate)
	d ResetVariablesMaintRequestForAnaly
	s TMaintRequestDR=rowid
	s EquipTypeDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",3)
	q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","2")) //add by wy 2021-12-15 增加安全组可访问类组
	s TObjLocDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",6)
	i TObjLocDR'="" s TObjLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TObjLocDR)
	s TExObjDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",5)
	i TExObjDR'="" s TEquipName=$p($g(^DHCEQMExObj(TExObjDR)),"^",1)
	s TEquipNo=$p($g(^DHCEQMExObj(TExObjDR)),"^",2)
	i TEquipNo'="" s TEquipRowID=$O(^DHCEQEquip(0,"No",TEquipNo,""))
	i TEquipRowID="" q ""
	s TMasterItemID=$p($g(^DHCEQEquip(TEquipRowID)),"^",7)
	s TRequestDate=$p($g(^DHCEQMMaintRequest(rowid)),"^",18)
	s TRequestDate=##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	s TRequestUserDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",20)
	i TRequestUserDR'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	s TAcceptDate=$p($g(^DHCEQMMaintRequest(rowid)),"^",24)
	s TAcceptDate=##class(web.DHCEQCommon).TransValueToPage(TAcceptDate,"date")
	s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",26)
	i TAcceptUserDR'="" s TAcceptUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TAcceptUserDR)
	//Modify by zx 2023-02-15
	s TMaintGroupDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",70)
	i TMaintGroupDR'="" s TMaintGroup=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",TMaintGroupDR)),"^",2)
	s TTotalFee=$p($g(^DHCEQMMaintRequest(rowid)),"^",60)
	s TApproveListID=$o(^DHCEQApproveList(0,"Source","25",rowid,""),-1)
	q:TApproveListID=""
	s TActionID=$p($g(^DHCEQApproveList(TApproveListID)),"^",11)
	i TActionID'="0" d
	.s TActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",2)
	.s TActionDesc=$e(TActionDesc,1,4) //取前四位
	.s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",1)
	e  d
	.s TActionDesc="报修申请"
	.s TActionCode=""
	s TStatus=$p($g(^DHCEQMMaintRequest(rowid)),"^",41)
	d OutputRowMaintRequestForAnaly
	quit
OutputRowMaintRequestForAnaly
	Set Data=$lb(TMaintRequestDR,TObjLocDR,TObjLoc,TExObjDR,TEquipName,TEquipNo,TEquipRowID,TMasterItemID,TRequestDate,TRequestUserDR,TRequestUser,TAcceptDate,TAcceptUserDR,TAcceptUser,TApproveListID,TActionID,TActionDesc,TActionCode,TStatus,TMaintGroupDR,TMaintGroup,TTotalFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMaintRequestForAnaly
	Set (TMaintRequestDR,TObjLocDR,TObjLoc,TExObjDR,TEquipName,TEquipNo,TEquipRowID,TMasterItemID,TRequestDate,TRequestUserDR,TRequestUser,TAcceptDate,TAcceptUserDR,TAcceptUser,TApproveListID,TActionID,TActionDesc,TActionCode,TStatus,TMaintGroupDR,TMaintGroup,TTotalFee)=""
	quit
}

ClassMethod MaintRequestForAnalyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintRequestForAnalyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MaintRequestForAnalyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintRequestForAnalyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCEQ.EM.BUSMMaintRequest).MaintHomePageInfo("2021-03-13","2022-03-28","21248","85")
ClassMethod MaintHomePageInfo(StartDate As %String = "", EndDate As %String = "", ParamJob, GroupID As %String = "")
{
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	Do ##Class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("MaintHomeStatus",ParamJob)
	Do ##Class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("MaintHomeEngineer",ParamJob)
	Do ##Class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("MaintHomeMasterItem",ParamJob)
	
	s (TotalRequestNum,TotalMaintNum)=0
	s ds =##class(%Library.ResultSet).%New("web.DHCEQ.EM.BUSMMaintRequest:MaintRequestForAnaly")
	d ds.Execute(StartDate,EndDate,"",GroupID)  //modified by wy 2021-12-16 增加入参GroupID，移动端使用需要
	f  q:'ds.Next()  d
	.i $D(ds.Data("TMaintRequestDR"))  d
	..s TotalRequestNum=TotalRequestNum+1
	..s InfoAcceptUserDR=ds.Data("TAcceptUserDR")
	..s InfoActionID=ds.Data("TActionID")
	..s InfoStatus=ds.Data("TStatus")
	..s TMaintGroupDR=ds.Data("TMaintGroupDR")
	..//状态分布
	..i InfoStatus="1" d
	...s TotalMaintNum=TotalMaintNum+1
	...s MaintStatusNum=+$g(^TempDHCEQ("MaintHomeStatus",+$H,ParamJob,InfoActionID))
	...s ^TempDHCEQ("MaintHomeStatus",+$H,ParamJob,InfoActionID)=MaintStatusNum+1
	..//工程师状态分布
	..i InfoAcceptUserDR'="" d
	...s EngineerStatusNum=+$g(^TempDHCEQ("MaintHomeEngineer",+$H,ParamJob,InfoAcceptUserDR,InfoActionID))
	...s ^TempDHCEQ("MaintHomeEngineer",+$H,ParamJob,InfoAcceptUserDR,InfoActionID)=EngineerStatusNum+1
	...s MaintGroupStatusNum=+$g(^TempDHCEQ("MaintHomeMaintGroup",+$H,ParamJob,TMaintGroupDR,InfoActionID))
	...s ^TempDHCEQ("MaintHomeMaintGroup",+$H,ParamJob,TMaintGroupDR,InfoActionID)=MaintGroupStatusNum+1
	..//设备项所有维修设备
	..s InfoMasterItemID=ds.Data("TMasterItemID")
	..s AllMasterItemNum=+$g(^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,InfoMasterItemID,"2"))
	..s ^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,InfoMasterItemID,"2")=AllMasterItemNum+1
	..//Mofidy by zx 2023-02-16 增加总费用统计
	..s AllMasterItemFee=+$g(^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,InfoMasterItemID,"3"))
	..s ^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,InfoMasterItemID,"3")=+ds.Data("TTotalFee")+AllMasterItemFee
	..//设备项维修中设备
	..i InfoStatus="1" d
	...s MaintMasterItemNum=+$g(^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,InfoMasterItemID,"1"))
	...s ^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,InfoMasterItemID,"1")=MaintMasterItemNum+1
	
	s Res=##class(web.DHCEQ.Plat.JsonObject).%New()
	d Res.%Set("TotalRequestNum",TotalRequestNum)  //总申请数量
	d Res.%Set("TotalMaintNum",TotalMaintNum)  //总在修数量
	//状态分布
	s ResAction=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ActionDescs=""
	s ActionStatusNums=""
	s ActionID=""
	f  s ActionID=$o(^TempDHCEQ("MaintHomeStatus",+$H,ParamJob,ActionID)) q:ActionID=""  d
	.s ActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",2)
	.i ActionID="0" s ActionDesc="报修申请"
	.i ActionDescs'="" s ActionDescs=ActionDescs_","
	.s ActionDescs=ActionDescs_ActionDesc
	.s ActionStatusNum=+$g(^TempDHCEQ("MaintHomeStatus",+$H,ParamJob,ActionID))
	.s CurActionStatusInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	.d CurActionStatusInfo.%Set("value",ActionStatusNum)
	.d CurActionStatusInfo.%Set("name",ActionDesc)
	.i ActionStatusNums'="" s ActionStatusNums=ActionStatusNums_"^"
	.s ActionStatusNums=ActionStatusNums_CurActionStatusInfo.%ToJSON()
	d ResAction.%Set("ActionDescs",ActionDescs)
	d ResAction.%Set("ActionStatusNums",ActionStatusNums)
	d Res.%Set("ResAction",ResAction)
	
	//工程师分布
	//获取所有动作,根据动作汇总
	//按总量前7输出
	s AccUseDR=0
	f  s AccUseDR=$o(^TempDHCEQ("MaintHomeEngineer",+$H,ParamJob,AccUseDR)) q:AccUseDR=""  d
	.s TotalNum=0
	.s AccActionID=""
	.f  s AccActionID=$o(^TempDHCEQ("MaintHomeEngineer",+$H,ParamJob,AccUseDR,AccActionID)) q:AccActionID=""  d
	..s TotalNum=+$g(^TempDHCEQ("MaintHomeEngineer",+$H,ParamJob,AccUseDR,AccActionID))+TotalNum
	.s ^TempDHCEQ("MaintHomeEngineer","TempNum",+$H,ParamJob,TotalNum,AccUseDR)=AccUseDR
	
	//只取 受理,维修,维修完成,其它 4种状态
	// 取受理、维修、维修完成三种情况 modify by zx 2023-02-22
	s ResEngineer=##class(web.DHCEQ.Plat.JsonObject).%New()
	s AcceptUsers=""
	s TotalAccs=0
	s TotalInfo=""
	s (AcceptNums,MaintNums,MaintFinishNums,OtherNums)=""
	f  s TotalInfo=$o(^TempDHCEQ("MaintHomeEngineer","TempNum",+$H,ParamJob,TotalInfo)) q:(TotalInfo="")||(TotalAccs>7)  d
	.s AcceptUserDR=0
	.f  s AcceptUserDR=$o(^TempDHCEQ("MaintHomeEngineer","TempNum",+$H,ParamJob,TotalInfo,AcceptUserDR)) q:(AcceptUserDR="")||(TotalAccs>7)  d
	..s TotalAccs=TotalAccs+1
	..i AcceptUsers'="" s AcceptUsers=AcceptUsers_","
	..s AcceptUsers=AcceptUsers_##class(web.DHCEQCommon).GetTrakNameByID("user",AcceptUserDR)
	..s AcceptActionID=""
	..s (AcceptNum,MaintNum,MaintFinishNum,OtherNum)=0
	..f  s AcceptActionID=$o(^TempDHCEQ("MaintHomeEngineer",+$H,ParamJob,AcceptUserDR,AcceptActionID)) q:AcceptActionID=""  d
	...s CurNum=+$g(^TempDHCEQ("MaintHomeEngineer",+$H,ParamJob,AcceptUserDR,AcceptActionID))
	...s AcceptActionCode=$p($g(^DHCEQCCode("DHCEQCAction",AcceptActionID)),"^",1)
	...i ((",WX_Accept,")[(","_AcceptActionCode_",")) d
	....s AcceptNum=CurNum+AcceptNum
	...else  if ((",WX_Maint,WX_Appearance,WX_Group,WX_Retrieve,")[(","_AcceptActionCode_",")) d
	....s MaintNum=CurNum+MaintNum
	...else  d
	....s MaintFinishNum=CurNum+MaintFinishNum
	..i AcceptNums'="" s AcceptNums=AcceptNums_","
	..s AcceptNums=AcceptNums_AcceptNum
	..i MaintNums'="" s MaintNums=MaintNums_","
	..s MaintNums=MaintNums_MaintNum
	..i MaintFinishNums'="" s MaintFinishNums=MaintFinishNums_","
	..s MaintFinishNums=MaintFinishNums_MaintFinishNum
	d ResEngineer.%Set("AcceptUsers",AcceptUsers)
	d ResEngineer.%Set("AcceptNums",AcceptNums)
	d ResEngineer.%Set("MaintNums",MaintNums)
	d ResEngineer.%Set("MaintFinishNums",MaintFinishNums)
	d Res.%Set("ResEngineer",ResEngineer)
	
	//维修组数据
	s ResMaintGroup=##class(web.DHCEQ.Plat.JsonObject).%New()
	s MaintGroups=""
	s (AcceptNums,MaintNums,MaintFinishNums)=""
	s CurMaintGroupDR=""
	f  s CurMaintGroupDR=$o(^TempDHCEQ("MaintHomeMaintGroup",+$H,ParamJob,CurMaintGroupDR)) q:CurMaintGroupDR=""  d
	.i MaintGroups'="" s MaintGroups=MaintGroups_","
	.s MaintGroups=MaintGroups_$p($g(^DHCEQCCode("DHCEQMCMaintGroup",CurMaintGroupDR)),"^",2)
	.s AcceptActionID=""
	.s (AcceptNum,MaintNum,MaintFinishNum,OtherNum)=0
	.f  s AcceptActionID=$o(^TempDHCEQ("MaintHomeMaintGroup",+$H,ParamJob,CurMaintGroupDR,AcceptActionID)) q:AcceptActionID=""  d
	..s CurNum=+$g(^TempDHCEQ("MaintHomeMaintGroup",+$H,ParamJob,CurMaintGroupDR,AcceptActionID))
	..s AcceptActionCode=$p($g(^DHCEQCCode("DHCEQCAction",AcceptActionID)),"^",1)
	..i ((",WX_Accept,")[(","_AcceptActionCode_",")) d
	...s AcceptNum=CurNum+AcceptNum
	..else  if ((",WX_Maint,WX_Appearance,WX_Group,WX_Retrieve,")[(","_AcceptActionCode_",")) d
	...s MaintNum=CurNum+MaintNum
	..else  d
	...s MaintFinishNum=CurNum+MaintFinishNum
	.i AcceptNums'="" s AcceptNums=AcceptNums_","
	.s AcceptNums=AcceptNums_AcceptNum
	.i MaintNums'="" s MaintNums=MaintNums_","
	.s MaintNums=MaintNums_MaintNum
	.i MaintFinishNums'="" s MaintFinishNums=MaintFinishNums_","
	.s MaintFinishNums=MaintFinishNums_MaintFinishNum
	d ResMaintGroup.%Set("MaintGroups",MaintGroups)
	d ResMaintGroup.%Set("AcceptNums",AcceptNums)
	d ResMaintGroup.%Set("MaintNums",MaintNums)
	d ResMaintGroup.%Set("MaintFinishNums",MaintFinishNums)
	d Res.%Set("ResMaintGroup",ResMaintGroup)
	
	//设备项
	s ItemInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ItemNames=""
	s AllItemNums=""
	s MaintItems=""
	s AllItemTotalFee=""
	s MasterItemID=0
	f  s MasterItemID=$o(^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,MasterItemID)) q:MasterItemID=""  d
	.s ItemName=$p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItemID)),"^",1)
	.s ItemName=$e(ItemName,1,9)
	.i ItemNames'="" s ItemNames=ItemNames_","
	.s ItemNames=ItemNames_ItemName
	.s AllItemNum=+$g(^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,MasterItemID,"2"))
	.i AllItemNums'="" s AllItemNums=AllItemNums_","
	.s AllItemNums=AllItemNums_AllItemNum
	.s MaintItemNum=+$g(^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,MasterItemID,"1"))
	.i MaintItems'="" s MaintItems=MaintItems_","
	.s MaintItems=MaintItems_MaintItemNum
	.s AllItemFee=+$g(^TempDHCEQ("MaintHomeMasterItem",+$H,ParamJob,MasterItemID,"3"))
	.i AllItemTotalFee'="" s AllItemTotalFee=AllItemTotalFee_","
	.s AllItemTotalFee=AllItemTotalFee_AllItemFee
	d ItemInfo.%Set("ItemNames",ItemNames)
	d ItemInfo.%Set("AllItemNums",AllItemNums)
	d ItemInfo.%Set("MaintItems",MaintItems)
	d ItemInfo.%Set("AllItemTotalFee",AllItemTotalFee)
	d Res.%Set("ItemInfo",ItemInfo)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Res)
}

/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMMaintRequest","MaintRequestItemStat","","","1")
Query MaintRequestItemStat(StartDate As %String = "", EndDate As %String = "", ParamJob, GroupID As %String = "") As %Query(ROWSPEC = "TItemName:%String,TAllItemNum:%String,TMaintItemNum:%String") [ SqlProc ]
{
}

ClassMethod MaintRequestItemStatExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", ParamJob, GroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	Do ##Class(web.DHCEQCommon).KillTempGlobal("MaintRequestItemStat",ParamJob)
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	
	s (AllMasterItemNum,MaintMasterItemNum)=0
	s rowid=0
	f  s rowid=$o(^DHCEQMMaintRequest(rowid)) q:rowid=""  d
	.q:$p($g(^DHCEQMMaintRequest(rowid)),"^",41)=0  //过滤新增状态
	.q:$p($g(^DHCEQMMaintRequest(rowid)),"^",57)="Y"  //过滤无效状态
	.s EquipTypeDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",3)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","2")) //add by wy 2021-12-15 增加安全组可访问类组
	.s SubmitDate=$p($g(^DHCEQMMaintRequest(rowid)),"^",49)
	.q:(StartDate>SubmitDate)||(EndDate<SubmitDate)
	.s (TExObjDR,TEquipNo,TEquipRowID,TMasterItemID,TStatus)=""
	.s TExObjDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",5)
	.i TExObjDR'="" s TEquipNo=$p($g(^DHCEQMExObj(TExObjDR)),"^",2)
	.i TEquipNo'="" s TEquipRowID=$O(^DHCEQEquip(0,"No",TEquipNo,""))
	.q:TEquipRowID=""
	.s TMasterItemID=$p($g(^DHCEQEquip(TEquipRowID)),"^",7)
	.s TStatus=$p($g(^DHCEQMMaintRequest(rowid)),"^",41)
	.s AllMasterItemNum=+$g(^TempDHCEQ("MaintRequestItemStat",+$H,ParamJob,TMasterItemID,"2"))
	.s ^TempDHCEQ("MaintRequestItemStat",+$H,ParamJob,TMasterItemID,"2")=AllMasterItemNum+1
	.//设备项维修中设备
	.i TStatus="1" d
	..s MaintMasterItemNum=+$g(^TempDHCEQ("MaintRequestItemStat",+$H,ParamJob,TMasterItemID,"1"))
	..s ^TempDHCEQ("MaintRequestItemStat",+$H,ParamJob,TMasterItemID,"1")=MaintMasterItemNum+1
	
	s MasterItemID=0
	f  s MasterItemID=$o(^TempDHCEQ("MaintRequestItemStat",+$H,ParamJob,MasterItemID)) q:MasterItemID=""  d
	.d ResetVariablesMaintRequestItemStat
	.s TItemName=$p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItemID)),"^",1)
	.s TAllItemNum=+$g(^TempDHCEQ("MaintRequestItemStat",+$H,ParamJob,MasterItemID,"2"))
	.s TMaintItemNum=+$g(^TempDHCEQ("MaintRequestItemStat",+$H,ParamJob,MasterItemID,"1"))
	.d OutputRowMaintRequestItemStat
	
	quit $$$OK
OutputRowMaintRequestItemStat
	Set Data=$lb(TItemName,TAllItemNum,TMaintItemNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMaintRequestItemStat
	Set (TItemName,TAllItemNum,TMaintItemNum)=""
	quit
}

ClassMethod MaintRequestItemStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintRequestItemStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MaintRequestItemStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintRequestItemStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMMaintRequest","MaintRequestEngineerStat","2021-11-07","2021-11-22","23812")
Query MaintRequestEngineerStat(StartDate As %String = "", EndDate As %String = "", ParamJob, GroupID As %String = "") As %Query(ROWSPEC = "TAcceptUser:%String,TAcceptNum:%String,TMaintNum:%String,TMaintFinishNum:%String,TOtherNum:%String") [ SqlProc ]
{
}

ClassMethod MaintRequestEngineerStatExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", ParamJob, GroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	Do ##Class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("MaintRequestEngineerStat",ParamJob)
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	
	s rowid=0
	f  s rowid=$o(^DHCEQMMaintRequest(rowid)) q:rowid=""  d
	.q:$p($g(^DHCEQMMaintRequest(rowid)),"^",41)'=1  //过滤状态
	.q:$p($g(^DHCEQMMaintRequest(rowid)),"^",57)="Y"  //过滤无效状态
	.s EquipTypeDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",3)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","2")) //add by wy 2021-12-15 增加安全组可访问类组
	.s SubmitDate=$p($g(^DHCEQMMaintRequest(rowid)),"^",49)
	.q:(StartDate>SubmitDate)||(EndDate<SubmitDate)
	.s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",26)
	.q:TAcceptUserDR=""
	.s TApproveListID=$o(^DHCEQApproveList(0,"Source","25",rowid,""),-1)
	.q:TApproveListID=""
	.s TActionID=$p($g(^DHCEQApproveList(TApproveListID)),"^",11)
	.i TActionID'="0" d
	..s TActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",2)
	..s TActionDesc=$e(TActionDesc,1,4) //取前四位
	..s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionID)),"^",1)
	.e  d
	..s TActionDesc="报修申请"
	..s TActionCode=""
	.s TEngineerStatusNum=+$g(^TempDHCEQ("MaintRequestEngineerStat",+$H,ParamJob,TAcceptUserDR,TActionID))
	.s ^TempDHCEQ("MaintRequestEngineerStat",+$H,ParamJob,TAcceptUserDR,TActionID)=TEngineerStatusNum+1
	
	s AcceptUserDR=0
	f  s AcceptUserDR=$o(^TempDHCEQ("MaintRequestEngineerStat",+$H,ParamJob,AcceptUserDR)) q:AcceptUserDR=""  d
	.d ResetVariablesMaintRequestEngineerStat
	.s TAcceptUser=##class(web.DHCEQCommon).GetTrakNameByID("user",AcceptUserDR)
	.s TAcceptActionID=""
	.s (TAcceptNum,TMaintNum,TMaintFinishNum,TOtherNum)=0
	.f  s TAcceptActionID=$o(^TempDHCEQ("MaintRequestEngineerStat",+$H,ParamJob,AcceptUserDR,TAcceptActionID)) q:TAcceptActionID=""  d
	..s TCurNum=+$g(^TempDHCEQ("MaintRequestEngineerStat",+$H,ParamJob,AcceptUserDR,TAcceptActionID))
	..i (TAcceptActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Accept",0))) d
	...s TAcceptNum=TCurNum+TAcceptNum
	..else  if (TAcceptActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Maint",0))) d
	...s TMaintNum=TCurNum+TMaintNum
	..else  if (TAcceptActionID=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Finish",0))) d
	...s TMaintFinishNum=TCurNum+TMaintFinishNum
	..else  d
	...s TOtherNum=TCurNum+TOtherNum
	.d OutputRowMaintRequestEngineerStat
	
	quit $$$OK
OutputRowMaintRequestEngineerStat
	Set Data=$lb(TAcceptUser,TAcceptNum,TMaintNum,TMaintFinishNum,TOtherNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMaintRequestEngineerStat
	Set (TAcceptUser,TAcceptNum,TMaintNum,TMaintFinishNum,TOtherNum)=""
	quit
}

ClassMethod MaintRequestEngineerStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintRequestEngineerStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MaintRequestEngineerStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintRequestEngineerStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCEQ.EM.BUSMMaintRequest).MessageSendInfo("2021-09-17")
/// Add by wy 2021-12-17 定时获取消息并插入DHC_EQMessageSendInfo
/// output:TotalNum维修总数,FinishNum已完成数量,FaultNum总未完成数量	,AcceptUsers受理人,AcceptNums受理数量,ItemNames维修设备,AllItemNums维修数量
ClassMethod MessageSendInfo()
{
	s GroupID=%session.Get("LOGON.GROUPID")
	s UserID=""
	s MaintGroupDR=0
    f  s MaintGroupDR=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",MaintGroupDR)) q:MaintGroupDR=""  d
    .s MLRowID=0
    .f  s MLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",MaintGroupDR,MLRowID)) q:MLRowID=""  d
    ..s ManagerFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MLRowID)),"^",5)
    ..s UserID=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MLRowID)),"^",2)
    ..s Rnt=##class(web.DHCEQ.EM.BUSMMaintRequest).GetMaintRequestList(+$H,GroupID,UserID,ManagerFlag)
	..s MsgInfo="维修总数"_Rnt.TotalNum_",完成数量:"_Rnt.FinishNum_",未完成数量"_Rnt.FaultNum_",受理人"_Rnt.AcceptUsers_",受理数量"_Rnt.AcceptNums_",维修设备"_Rnt.ItemNames_",维修数量"_Rnt.AllItemNums
	
	..s PLIST(2)="3"		;MessagesType
	..;s PLIST(3) = $p(val,"^",2)		;MessagesDR
	..;s PLIST(4) = $p(val,"^",3)		;MessagesRecInfoDR
	..s PLIST(5) =##class(web.DHCEQCommon).GetTrakNameByID("user",UserID)		;ReceiveUser
	..s PLIST(6)= Rnt		             ;MsgInfo
	..s WChatUserID=##Class(web.DHCEQMessages).GetWChatUserID(UserID)
	..q:WChatUserID=""
	..s PLIST(7)=WChatUserID		    ;ToAddress
	..;s PLIST(8) = $p(val,"^",7)		;Remark
	..s PLIST(9) = 0					;Status
 	..s PLIST(10) = 0					;Times
	..;Set ID=$Order(^DHCEQMessageSendInfo(0,"Type",PLIST(2),PLIST(3),PLIST(7),""),-1)
 	..;If ID'="" Set PLIST(10) = 1 + $Piece($Get(^DHCEQMessageSendInfo(ID)),"^",9)
	..;s PLIST(11) = +$H				;SendDate
 	..;s PLIST(12) = $P($H,",",2)		;SendTime
 	..;s PLIST(13) = $p(val,"^",9)	;ErrInfo
 	..;s PLIST(14) = $p(val,"^",8)		;Hold1
 	..;s PLIST(15) = $p(val,"^",9)		;Hold2
 	..;s PLIST(16) = $p(val,"^",10)	;Hold3
 	..&SQL(insert into sqluser.DHC_EQMessageSendInfo values :PLIST())
}

/// w ##class(web.DHCEQ.EM.BUSMMaintRequest).GetMaintRequestList("2021-09-17")
/// Add by wy 2021-12-07 获取当天维修信息
/// output:TotalNum维修总数,FinishNum已完成数量,FaultNum总未完成数量	,AcceptUsers受理人,AcceptNums受理数量,ItemNames维修设备,AllItemNums维修数量
ClassMethod GetMaintRequestList(RequestDate As %String = "", GroupID As %String = "", UserID As %String = "", ManagerFlag As %String = "")
{
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	Do ##Class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("MaintHomeEngineer")
	Do ##Class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("MaintHomeMasterItem")
	s Job=$j
	q:RequestDate=""
	s RequestDate=##Class(web.DHCEQCommon).TransValueFromPage(RequestDate,"date")
	s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s (TotalNum,FinishNum,FaultNum)=0
	s RowID=0
	f  s RowID=$o(^DHCEQMMaintRequest(RowID)) q:(RowID="")  d
	.s TInvalidFlag=$P($G(^DHCEQMMaintRequest(RowID)),"^",57)
	.q:TInvalidFlag="Y"
	.s TStatus=$P($G(^DHCEQMMaintRequest(RowID)),"^",41)
	.q:TStatus=3  // 维修单作废过滤
	.s EquipTypeDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",3)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","2")) //add by wy 2021-12-15 增加安全组可访问类组
	.s TRequestDate=$p($g(^DHCEQMMaintRequest(RowID)),"^",18)
	.q:(RequestDate'="")&&(TRequestDate'=RequestDate)
	.s TRequestDate=##class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	.s TotalNum=TotalNum+1  //总数量
	.s AcceptUserDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",26)
	.q:(ManagerFlag="N")&&(UserID'=AcceptUserDR)
	.s TExObjDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",5)
	.s TEquipNo=$p($g(^DHCEQMExObj(TExObjDR)),"^",2)
	.i TEquipNo'="" s TEquipRowID=$O(^DHCEQEquip(0,"No",TEquipNo,""))
	.q:TEquipRowID="" 
	.s MasterItemID=$p($g(^DHCEQEquip(TEquipRowID)),"^",7)
	.;状态分布
	.i TStatus="2" s FinishNum=FinishNum+1  //已完成数量
	.i TStatus'="2" s FaultNum=FaultNum+1   //未完成数量
	.//工程师受理分布
	.i (AcceptUserDR'="") d
	..s EngineerStatusNum=+$g(^TempDHCEQ("MaintHomeEngineer",RequestDate,UserID,Job,AcceptUserDR))
	..s ^TempDHCEQ("MaintHomeEngineer",RequestDate,UserID,Job,AcceptUserDR)=1+EngineerStatusNum
	.//设备项所有维修设备
	.s AllMasterItemNum=+$g(^TempDHCEQ("MaintHomeMasterItem",RequestDate,UserID,Job,MasterItemID))
	.s ^TempDHCEQ("MaintHomeMasterItem",RequestDate,UserID,Job,MasterItemID)=AllMasterItemNum+1
	s Res=##class(web.DHCEQ.Plat.JsonObject).%New()
	d Res.%Set("TotalNum",TotalNum)  //总申请数量
	d Res.%Set("FinishNum",FinishNum)  //总已完成数量
	d Res.%Set("FaultNum",FaultNum)  //总未完成数量	
	//工程师受理分布
	s AcceptUserDR=""
	f  s AcceptUserDR=$o(^TempDHCEQ("MaintHomeEngineer",RequestDate,UserID,Job,AcceptUserDR)) q:AcceptUserDR=""  d
	.s AccTotalNum=0
	.s AccTotalNum=+$g(^TempDHCEQ("MaintHomeEngineer",RequestDate,UserID,Job,AcceptUserDR))
	.s ^TempDHCEQ("MaintHomeEngineer","TempNum",RequestDate,UserID,Job,AccTotalNum,AcceptUserDR)=AcceptUserDR
	//只取完成和未完成两种状态
	s ResEngineer=##class(web.DHCEQ.Plat.JsonObject).%New()
	s AcceptUsers=""
	s TotalInfo=""
	s AcceptNums=0
	f  s TotalInfo=$o(^TempDHCEQ("MaintHomeEngineer","TempNum",RequestDate,UserID,Job,TotalInfo)) q:TotalInfo=""  d
	.s AcceptUserDR=0
	.f  s AcceptUserDR=$o(^TempDHCEQ("MaintHomeEngineer","TempNum",RequestDate,UserID,Job,TotalInfo,AcceptUserDR)) q:AcceptUserDR=""  d
	..i AcceptUsers'="" s AcceptUsers=AcceptUsers_","
	..s AcceptUsers=AcceptUsers_##class(web.DHCEQCommon).GetTrakNameByID("user",AcceptUserDR)
	..s AcceptNum=$g(^TempDHCEQ("MaintHomeEngineer",RequestDate,UserID,Job,AcceptUserDR))
	..i AcceptNums'="" s AcceptNums=AcceptNums_","
	..s AcceptNums=AcceptNums_AcceptNum
	d ResEngineer.%Set("AcceptUsers",AcceptUsers)
	d ResEngineer.%Set("AcceptNums",AcceptNums)
	d Res.%Set("ResEngineer",ResEngineer)
	//设备项
	s ItemInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ItemNames=""
	s AllItemNums=""
	s MasterItemID=0
	f  s MasterItemID=$o(^TempDHCEQ("MaintHomeMasterItem",RequestDate,UserID,Job,MasterItemID)) q:MasterItemID=""  d
	.s ItemName=$p($g(^DHCEQCCode("DHCEQCMasterItem",MasterItemID)),"^",1)
	.i ItemNames'="" s ItemNames=ItemNames_","
	.s ItemNames=ItemNames_ItemName
	.s AllItemNum=+$g(^TempDHCEQ("MaintHomeMasterItem",RequestDate,UserID,Job,MasterItemID))
	.i AllItemNums'="" s AllItemNums=AllItemNums_","
	.s AllItemNums=AllItemNums_AllItemNum
	d ItemInfo.%Set("ItemNames",ItemNames)
	d ItemInfo.%Set("AllItemNums",AllItemNums)
	d Res.%Set("ItemInfo",ItemInfo)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Res)
}

ClassMethod UpdMaintProcess(RowID, MaintProcess)
{
	s SQLCODE=0
	&SQL(update SQLUSER.DHC_EQMMaintRequest set MR_Hold15=:MaintProcess  where MR_RowID=:RowID)
	q SQLCODE
}

/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).ReturnJsonManageType()
ClassMethod ReturnJsonManageType()
{

	s ReturnInfo=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQMCManageType",rowid)) quit:rowid=""  d
	.q:($p($g(^DHCEQCCode("DHCEQMCManageType",rowid)),"^",4)="Y")
	.s id=rowid
	.s code=$p($g(^DHCEQCCode("DHCEQMCManageType",rowid)),"^",1)
	.s text=$p($g(^DHCEQCCode("DHCEQMCManageType",rowid)),"^",2)
	.i ReturnInfo'="" s ReturnInfo=ReturnInfo_"&"
	.s ReturnInfo=ReturnInfo_id_","_code_","_text
	q ReturnInfo
}

// Modefied by zc 2022-4-8

ClassMethod ReturnJsonEmergency()
{
	s ReturnInfo="1,是&2,否"
	q ReturnInfo
}

// Modefied by zc 2022-4-8

ClassMethod ReturnJsonAction()
{
	s ReturnInfo="1,待维修&2,维修中&3,待审核"
	q ReturnInfo
}

// Modefied by zc 2022-4-8

/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).ReminderBuss("31","7,5","77")
ClassMethod ReminderBuss(vBussType As %String = "", vBussIDs As %String = "", User As %Library.String = "")
{
	new (vBussType,vBussIDs,User)
 	Set $ZT="ERRORReminderBuss"
 	s Flag=0
 	s SQLCODE=0
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	TStart
	s Length=$l(vBussIDs,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s vBussID=$p(vBussIDs,",",i)
		i (vBussID'="") 
		{
			Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25") 
			s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,vBussID,"催单","催单","","1",User,"0")
		}
		if SQLCODE  
		{	 
			TRollBack
			Set Flag=SQLCODE 
		}
		i $p($g(^DHCEQMMaintRequest(vBussID)),"^",26)'=""
		{
			s SQLCODE=##Class(web.DHCEQMessages).CreatMessageSend(vBussType, vBussID, "12", "0", "", $p($g(^DHCEQMMaintRequest(vBussID)),"^",26), "", "","")
		}
		else
		{
			s MRowID=$o(^DHCEQMessages(0,"MessageType",1,vBussType,vBussID,""),-1)
			i '$D(^DHCEQMessages(MRowID,"EX")) s Flag=-1
			q:Flag'=0
			s User=$p($g(^DHCEQMessages(MRowID)),"^",15)		//SendUserDR
			s ApproveFlowInfo=$g(^DHCEQMessages(MRowID,"EX","ApproveFlowInfo"))
			s RefuseFlag=$g(^DHCEQMessages(MRowID,"EX","RefuseFlag"))
			s CurRole=$g(^DHCEQMessages(MRowID,"EX","CurRole"))
			s AuditFlag=$g(^DHCEQMessages(MRowID,"EX","AuditFlag"))
			s GroupID=$g(^DHCEQMessages(MRowID,"EX","GroupID"))
			s LimitActions=$g(^DHCEQMessages(MRowID,"EX","LimitActions"))
			s LimitUserDR=$g(^DHCEQMessages(MRowID,"EX","LimitUserDR"))
			s LimitLocActions=$g(^DHCEQMessages(MRowID,"EX","LimitLocActions"))
			s LimitLocDR=$g(^DHCEQMessages(MRowID,"EX","LimitLocDR"))
			s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(vBussType, vBussID, User, ApproveFlowInfo, "N",CurRole,AuditFlag,GroupID,LimitActions,LimitUserDR,LimitLocActions,LimitLocDR)
		}
		if SQLCODE  
		{	 
			TRollBack
			Set Flag=SQLCODE 
		}
	}
	TCommit
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Flag)
 
ERRORReminderBuss 
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORReminderBuss"_ErrorMsg     //返回错误消息 ;
}

/// add By WY 2023-02-21 3319089
/// 描述: 批量作废在进程中的单据 
/// 入参：vBussType单据类型，vBussIDs单据ID
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).CancellRequest("31","7,5","77")
ClassMethod CancellRequest(vBussType As %String = "", vBussIDs As %String = "", User As %Library.String = "")
{
	new (vBussType,vBussIDs,User)
 	s Flag=0
 	s SQLCODE=0
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Length=$l(vBussIDs,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s vBussID=$p(vBussIDs,",",i)
		i (vBussID'="") 
		{	
			s SQLCODE=##Class(web.DHCEQ.Plat.LIBMessages).InvalidBuss(vBussType,vBussID,User)
		}
		if SQLCODE   Set Flag=SQLCODE 
			
	}
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Flag)
}

/// add by wy 2022-4-24
/// modified by WY 2022-9-8 
/// 泛类维修时，维护设备名称自动生成设备项，泛类台帐
/// 返回设备ID EQRowID
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).SaveExObj("刷卡器","9","","")
ClassMethod SaveExObj(ExObj As %Library.String = "", EquipTypeDR As %Library.String = "", SSLocID As %Library.String = "", SSUserID As %Library.String = "")
{
	new plist,EORowID
 	Set $ZT="ERRORExObj"
 	s Flag=0
 	s ItemDR=""
 	s SQLCODE=0
 	if ExObj=""  Quit $$$OK
 	if ExObj'="" s code=##class(web.DHCEQCHanZiEncoding).GetEncoding(ExObj,4,"","U")
	s EquipStr=##class(web.DHCEQCommon).GetSysInfo("503015")
	s length=$p(EquipStr,";")
	f i=1:1:length q:Flag=1  d
	.s EQEquipTypeDR=$p($p(EquipStr,";",i),",",1)
	.s EQEqupcatDR=$p($p(EquipStr,";",i),",",3)
	.s EQStatCatDR=$p($p(EquipStr,";",i),",",2)
	.i (EquipTypeDR'="")&&(EquipTypeDR=EQEquipTypeDR) s Flag=1
 	if ((EQEquipTypeDR="")||(EQEqupcatDR="")||(EQStatCatDR="")) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9040","简易设备的类组,类型,分类串有为空!")
	s Rowid=""
	&SQL(select MI_RowID into :Rowid from SQLUSER.DHC_EQCMasterItem where MI_Code=:code and MI_Desc=:ExObj and MI_EquipTypeDR=:EQEquipTypeDR  and MI_InvalidFlag='N') 
	s plist=Rowid_"^"_ExObj_"^"_code_"^"_EQEquipTypeDR_"^"_EQEqupcatDR_"^"_EQStatCatDR_"^^1^N^N^^^N^N^^"
	TSTART
	    if Rowid=""
	    {
		    s ItemDR=##Class(web.DHCEQCMasterItem).SaveData("","",plist,"2","",SSUserID)
			if (ItemDR="")||(ItemDR<1)
			{	
			   TRollBack
		      Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1604")
			}
	    }
	    else{
		      s ItemDR=Rowid
		    }
		s data=##class(web.DHCEQ.Plat.JsonObject).%New()
		d data.%Set("EQName",$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1))
		d data.%Set("EQCode",$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2))
		d data.%Set("EQItemDR_MIDesc",$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1))
		d data.%Set("EQItemDR",ItemDR)
		d data.%Set("EQEquipTypeDR",$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3))
		d data.%Set("EQStatCatDR",$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5))
		d data.%Set("EQUnitDR",$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7))
		d data.%Set("EQEquiCatDR",$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4))
		d data.%Set("EQClassFlag","Y")
		d data.%Set("EQStatus","1")
		d data.%Set("EQStockStatus","1")
		d data.%Set("EQInvalidFlag","N")
		d data.%Set("EQLocationDR","")
		d data.%Set("EQNo","")
	    s data=data.%ToJSON()
	    s return=##Class(web.DHCEQ.EM.BUSEquip).SaveData(data,"",SSUserID,SSLocID)
	    s JsonData =##class(web.DHCEQ.Plat.JsonObject).FromJSON(return)
		if JsonData.SQLCODE  
		{	 
			TRollBack
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(JsonData.SQLCODE,JsonData.Data) //modify by zyq 2023-04-23
		}
		Set EQRowID=JsonData.Data 
		/*s return=##Class(web.DHCEQ.EM.BUSMMaintRequest).AutoSaveExObj(EQRowID)
	    s PJsonData =##class(web.DHCEQ.Plat.JsonObject).FromJSON(return)
		if PJsonData.SQLCODE  
		{	 
			TRollBack
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	    Set EORowID=PJsonData.Data */
	TCommit
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,EQRowID)
 
ERRORExObj
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORExObj"_ErrorMsg     //返回错误消息 ;
}

/// add by wy 2022-4-24 
/// 根据当前工程师取维修组所有维修工程师
/// 返回维修组所有工程师ID串
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).GetMaintGroupList("5313")
ClassMethod GetMaintGroupList(CurUserID As %Library.String = "")
{
	s index=1
	s (UserID,MGroupDR)=""
	i CurUserID'="" d
	.s curRowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",CurUserID,0))
	.i curRowid'="" d
	..s MGroupDR=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",curRowid)),"^",1) 	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",rowid))  quit:rowid=""  d
	.s InvalidFlag =$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",6)
	.q:InvalidFlag="Y"
    .s userdr=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2)
	.s MaintGroupDR=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",1)
	.q:(MGroupDR'="")&&(MaintGroupDR'=MGroupDR)
	.if UserID'="" s UserID=UserID_","
	.s UserID=UserID_userdr
	q UserID
}

/// add by zx 2017-05-31
/// 获取未完成维修单列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMMaintRequest","GetMaintControlList","1")
Query GetMaintControlList(ActionDR As %Library.String = "", LocDR As %Library.String = "", Equip As %Library.String = "", Model As %Library.String = "") As %Query(ROWSPEC = "TMaintRequestDR:%String,TExObj:%String,TExObjNo:%String,TExObjModel:%String,TExObjLoc:%String,TRequestUser:%String,TAcceptUser:%String,TRequestDate:%String,TAcceptDate:%String")
{
}

ClassMethod GetMaintControlListExecute(ByRef qHandle As %Binary, ActionDR As %Library.String = "", LocDR As %Library.String = "", Equip As %Library.String = "", Model As %Library.String = "") As %Status
{
 	new repid, index, rowid
 	New ApproveType,ApproveInfoID,ApproveRoleDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s TMaintRequestDR=0
	f  s TMaintRequestDR=$o(^DHCEQMMaintRequest(0,"Status","1",TMaintRequestDR)) q:TMaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",57))="Y"
	.d ResetVariablesGetMaintControlList
	.s TExObjDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",5)
	.i TExObjDR'="" s TEquipDR=$p($g(^DHCEQMExObj(TExObjDR)),"^",5)
	.i TEquipDR'="" d 
	..s TExObj=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TExObjNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	..s TExObjModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	..i TExObjModelDR'="" s TExObjModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model", TExObjModelDR)
	.s TExObjLocDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",6)
	.q:(LocDR'="")&&(LocDR'=TExObjLocDR)
	.i TExObjLocDR '="" s TExObjLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TExObjLocDR)
	.s TRequestUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",20)
	.i TRequestUserDR '="" s TRequestUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TRequestUserDR)
	.s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",26)
	.i TAcceptUserDR '="" s TAcceptUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAcceptUserDR)
	.s TRequestDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",18)
	.i TRequestDate'="" s TRequestDate=$zd(TRequestDate,3)
	.s TAcceptDate=$p($g(^DHCEQMMaintRequest(TMaintRequestDR)),"^",24)
	.i TAcceptDate'="" s TAcceptDate=$zd(TAcceptDate,3)
	.s TApproveListID=$o(^DHCEQApproveList(0,"Source","25",TMaintRequestDR,""),-1)
	.q:TApproveListID=""
	.s TActionID=$p($g(^DHCEQApproveList(TApproveListID)),"^",11)
	.q:(ActionDR'="")&&(ActionDR'=TActionID)
	.d OutputRowGetMaintControlList
	
	Quit $$$OK
OutputRowGetMaintControlList
	Set Data=$lb(TMaintRequestDR,TExObj,TExObjNo,TExObjModel,TExObjLoc,TRequestUser,TAcceptUser,TRequestDate,TAcceptDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMaintControlList
	Set (TExObjDR,TExObj,TExObjNo,TExObjLocDR,TExObjModelDR,TExObjModel,TExObjLoc,TRequestUserDR,TRequestUser,TAcceptUserDR,TAcceptUser,TRequestDate,TAcceptDate,TApproveListID,TActionID)=""
	Quit
}

ClassMethod GetMaintControlListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintControlListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintControlListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintControlListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCEQ.EM.BUSMMaintRequest).SaveData("{""MRRequestNo"":"""",""MRRequestDate"":""2022-09-19"",""MREquipName"":""医用冷藏箱"",""MRRequestLocDR_LocDesc"":""ZYKMZ-中医科门诊"",""MRRequestLocTel"":""18997897468"",""MRRequestUserDR_UserName"":""Demo Group"",""MRRequestTel"":""1567898765"",""MRLocationDR_LDesc"":""中医科门诊诊室"",""MRFaultCaseDR_FCDesc"":""电源板烧"",""QXType"":""0"",""MRRowID"":"""",""MRExObjDR"":"""",""MRStatus"":""0"",""CurRole"":"""",""MenuApproveRole"":"""",""EvaluateFlag"":"""",""EvaluateGroup"":"""",""ApproveRoleDR"":"""",""Action"":"""",""MRExObjDR_EQOriginalFee"":"""",""MRLocationDR"":""1033"",""MRExObjDR_EQFileNo"":"""",""RoleStep"":""0"",""NextFlowStep"":"""",""GetFaultCaseOperMethod"":""2"",""GetFaultReasonOperMethod"":""2"",""GetDealMethodOperMethod"":""2"",""GetFaultTypeOperMethod"":"""",""SimpleFlag"":""1"",""ApproveSetDR"":"""",""NextRoleDR"":"""",""CancelFlag"":"""",""CancelToFlowDR"":"""",""ApproveStatus"":"""",""GetStopEquipFlag"":""1"",""ApproveTypeCode"":"""",""Type"":"""",""MRObjLocDR"":"""",""MRObjLocDR_LocDesc"":"""",""MREquipDR"":"""",""MREquipTypeDR"":"""",""MRObjTypeDR"":"""",""MREquipStatusDR"":"""",""MRRequestUserDR"":""1"",""MRRequestLocDR"":""161"",""MRFaultCaseDR"":""8"",""MREmergencyLevelDR"":"""",""MRSeverityLevelDR"":"""",""MRAcceptUserDR"":"""",""MRMaintGroupDR"":"""",""MRMaintModeDR"":"""",""MRServiceDR"":"""",""MRServiceDR_SVName"":"""",""MRFaultTypeDR"":"""",""MRFaultReasonDR"":"""",""MRDealMethodDR"":"""",""MRMaintResultsDR"":"""",""MRSourceTypeDR"":"""",""MRExObjDR_EQClassFlag"":"""",""ReadOnly"":"""",""FacilityFlag"":""0"",""MRExObjDR_EQRowID"":"""",""MRMaintType"":""0"",""MRManageTypeDR"":""1"",""MRSourceType"":"""",""MRFaultCaseRemark"":""cs""}","","N","0","")
ClassMethod SaveData(data, Evaluate As %Library.String = "", MREquipStatusFlag As %Library.String = "", DelIs As %Library.String = "", User As %Library.String = "")
{
	s $ZT="ERRORMaintRequest"
	k PLIST,RowID
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($h,",",2)
	TSTART
	if DelIs=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQMMaintRequest set MR_InvalidFlag='Y' where MR_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQMMaintRequest",JsonData,.PLIST)
		s RowID = JsonData.MRRowID
		s MRExObjDR = JsonData.MRExObjDR
	 	s PLIST(43) = User	;AddUserDR
	 	s PLIST(44) = Date	;AddDate
	 	s PLIST(45) = Time	;AddTime
		s PLIST(42) = "0"	;Status
		s PLIST(58) = "N"
	    if RowID'=""
	    {
		    if (MRExObjDR'=""){
			    &SQL(Update SQLUSER.DHC_EQMMaintRequest Values :PLIST() where MR_RowID = :RowID)
		    }
		    else{   //add by txr 20230423
			    //add by wy 2022-8-13当设备不存在维修对象时生成维修对象
				s PJsonData=""
				s EQRowID=JsonData.MREquipDR
				s MRExObjDR= JsonData.MRExObjDR
				if (MRExObjDR="")&&(EQRowID'="")
				{
					s return=##Class(web.DHCEQ.EM.BUSMMaintRequest).AutoSaveExObj(EQRowID)
					s PJsonData =##class(web.DHCEQ.Plat.JsonObject).FromJSON(return)
					if PJsonData.SQLCODE  
					{	 
						TRollBack
						Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
					}
				}
				//add by wy 2022-8-19根据设备来确定维修单设备的SourceType
				s EQClassFlag=$p($g(^DHCEQEquip(EQRowID)),"^",83)
				s RequestLocDR=JsonData.MRRequestLocDR
				s ret=##Class(web.DHCEQCommon).GetSysInfo("990053")
				i (JsonData.MRSourceType="")
			 	{
				 	s PLIST(64)="1"
				 	s PLIST(7)=$p($g(^DHCEQEquip(EQRowID)),"^",19)
				 	if (ret'="")&&(ret[JsonData.MREquipTypeDR)
				 	{
					 	if (EQClassFlag="Y")
					 	{
							 s PLIST(64)="3"
						 	 s PLIST(7)=RequestLocDR
						 }
					 	else{
						   	s PLIST(64)="2"
						 }
				 	}
			 	}
			 	else 
			 	{
			    	s PLIST(64)=JsonData.MRSourceType
			    	s PLIST(7)=$p($g(^DHCEQEquip(EQRowID)),"^",19)
			    	if (EQClassFlag="Y")
					 {
						 s PLIST(7)=RequestLocDR
					 }
			 	}
			 	s PLIST(6)=PJsonData.Data
				&SQL(Update SQLUSER.DHC_EQMMaintRequest Values :PLIST() where MR_RowID = :RowID)
			}
		    
		}
		else
		{
			//add by wy 2022-8-13当设备不存在维修对象时生成维修对象
			s PJsonData=""
			s EQRowID=JsonData.MREquipDR
			s MRExObjDR= JsonData.MRExObjDR
			if (MRExObjDR="")&&(EQRowID'="")
			{
				s return=##Class(web.DHCEQ.EM.BUSMMaintRequest).AutoSaveExObj(EQRowID)
				s PJsonData =##class(web.DHCEQ.Plat.JsonObject).FromJSON(return)
				if PJsonData.SQLCODE  
				{	 
					TRollBack
					Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
				}
			}
			//add by wy 2022-8-19根据设备来确定维修单设备的SourceType
			s EQClassFlag=$p($g(^DHCEQEquip(EQRowID)),"^",83)
			s RequestLocDR=JsonData.MRRequestLocDR
			s ret=##Class(web.DHCEQCommon).GetSysInfo("990053")
			i (JsonData.MRSourceType="")
			 {
				 s PLIST(64)="1"
				 s PLIST(7)=$p($g(^DHCEQEquip(EQRowID)),"^",19)
				 if (ret'="")&&(ret[JsonData.MREquipTypeDR)
				 {
					 if (EQClassFlag="Y")
					 {
						 s PLIST(64)="3"
						 s PLIST(7)=RequestLocDR
						 }
					 else{
						   s PLIST(64)="2"
						 }
				 }
			 }
			 else 
			 {
			    s PLIST(64)=JsonData.MRSourceType
			    s PLIST(7)=$p($g(^DHCEQEquip(EQRowID)),"^",19)
			    if (EQClassFlag="Y")
					 {
						 s PLIST(7)=RequestLocDR
					 }
			 }
			s PLIST(20) = Time	//申请时间
			s PLIST(6)=PJsonData.Data
			s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMMaintRequest",Date,JsonData.MRRequestLocDR,JsonData.MREquipTypeDR)
			&SQL(insert into SQLUSER.DHC_EQMMaintRequest Values :PLIST())
			s RowID=$g(%ROWID)
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
  /*	if (+JsonData.MREquipStatusDR>=1)&&(MREquipStatusFlag="Y")
 	{
		s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
		s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
		If TExObjDR'=""
		{
			//modified by wy 2022-4-12 SourceTypeDR类行
			i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)
			{
				new ChangeInfoDR   ;add by kdf 需求号573050
				s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
				s EQClassFlag=$Piece($Get(^DHCEQEquip(EQRowID)),"^",83)
				if ((SourceTypeDR'=2)||(EQClassFlag'="Y"))		//Modify DJ 2019-06-27 除简易台账范类外处理
				{
					;检测是否已存停用记录
					K PL
					s PL(2)=EQRowID
					s PL(4)=2
					s PL(5)=+$H
					s PL(6)=31
					s PL(7)=RowID
					s PL(8)=2
					s PL(9)=1
					s PL(10)=2
					s PL(14)="维修停用"
					s PL(16)="N"
					s PL(18)=+$H             ;add by kdf 2018-03-27 需求号573023
		            s PL(19)=$P($H,",",2)    ;add by kdf 2018-03-27 需求号573023
					s PL(23)=+$H
					s PL(24)=$P($H,",",2)
					s PL(25)=$Piece(val,"^",43)
					s CIRowID=$o(^DHCEQChangeInfo(0,"EquipChangeType",EQRowID,2,31,RowID,0))
					i CIRowID=""
					{
						&SQL(Insert Into SQLUSER.DHC_EQChangeInfo Values :PL())
						i SQLCODE
						{
							TROLLBACK
							q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
						}
						//add by kdf 需求号573050 begin********
						s ChangeInfoDR=$G(%ROWID)
						k LI
						s LI(2)=EQRowID  //设备
						s LI(4)=$p($g(^DHCEQEquip(EQRowID)),"^",19)   	//原使用科室
						s LI(5)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//原管理科室
						s LI(6)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//原库房
						s LI(7)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//原值
						s LI(8)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//原净值
						s LI(9)=$p($g(^DHCEQEquip(EQRowID)),"^",19)  	//变动后使用科室
		 				s LI(10)=$p($g(^DHCEQEquip(EQRowID)),"^",17) 	//变动后管理科室
		 				s LI(11)=$p($g(^DHCEQEquip(EQRowID)),"^",67)  	//变动后库房
		 				s LI(12)=$p($g(^DHCEQEquip(EQRowID)),"^",27)  	//变动后原值
		 				s LI(13)=$p($g(^DHCEQEquip(EQRowID)),"^",28)  	//变动后净值
						s LI(14)="停用"
						s LI(16)=+$H	//变动日期
						s LI(17)=$P($H,",",2)	//变动时间
						;s LI(18)=depreFee //折旧费用
						s LI(19)="C"	//生命周期类型
						s LI(20)=41		//来源类型
						s LI(21)=ChangeInfoDR	//来源ID
						s LI(27)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//更新人
						s LI(28)=+$H	//更新日期
						s LI(29)=$P($H,",",2)	//更新时间
						&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
						//add by kdf 需求号573050 end ********
					}
					i SQLCODE
					{
						TROLLBACK
						q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
					}
					&SQL(Update SQLUser.DHC_EQEquip set EQ_Status=2 where EQ_RowID=:EQRowID)
				}
			}
		}
 	}
  	If SQLCODE
	{
		TRollBack
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}*/
	//start by csj 20200209 生成租赁维修对照
	s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
	s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)
	If TExObjDR'=""
	{
		//modified by wy 2022-4-12 SourceTypeDR类行
			i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)
		{
			s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
			s SQLCODE=##class("web.DHCEQ.RM.BUSShareResource").CreateRentMaintMap(EQRowID,1,RowID,User)
			i SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
	}
	//维修申请人的电话维护到人员表 add by wy 2022-3-31
	s RequestTel= JsonData.MRRequestTel
	s UserDR= JsonData.MRRequestUserDR
	i UserDR="" s UserDR=User  			
	if RequestTel'=""
	{
		&SQL(Update SQLUser.DHC_EQCUser set U_MobilePhone=:RequestTel where U_RowID=:UserDR)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}

	//维修申请科室的电话维护到科室表中 add by wy 2022-8-13
	s RequestLocTel=JsonData.MRRequestLocTel
	s RequestLocDR= JsonData.MRRequestLocDR
	if (RequestTel'="")&&(RequestLocDR'="")
	{
		&SQL(Update SQLUser.DHC_EQCDepartment set Dept_Telephone=:RequestLocTel where Dept_RowID=:RequestLocDR)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
    }
    //Modified BY WY 2022-4-19 生成设备与故障现象对照
    s MRFaultCaseDR=JsonData.MRFaultCaseDR
    s EQRowID=JsonData.MREquipDR
	if (MRFaultCaseDR'="") 
	{				
		s ItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
	   	s valList="^1^"_MRFaultCaseDR_"^2^"_ItemDR_"^^^Y^^^^^"
	   	//modified by wy 2023-2-8 3266916判断对照是否存在
	   	s vetmpid=""
	   	&SQL(select FEM_RowID into :vetmpid from sqluser.DHC_EQMCFaultEquipMap where FEM_MapType=1 and FEM_FaultID=:MRFaultCaseDR and FEM_ESourceID=:ItemDR and  FEM_ESourceType=2)
		if vetmpid=""
		{
			s Reslut=##class(web.DHCEQ.EM.KNMaint).SaveFaultEquipMapData(valList)
			s Reslut =##class(web.DHCEQ.Plat.JsonObject).FromJSON(Reslut)
			i Reslut.SQLCODE
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Reslut.SQLCODE)  //modified by wy 2023-2-8 3266917
			}
		}

	}
	//add by wy 2023-3-1 3327281 生成科室与存放地点对照
	s MRRequestLocDR=JsonData.MRRequestLocDR
	s MRLocationDR=JsonData.MRLocationDR
	if (MRLocationDR'="") &&(MRRequestLocDR'="")
	{
	  	s HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(MRRequestLocDR)
		&SQL(Update SQLUSER.DHC_EQCLocation set L_HospitalDR=:HospitalDR,L_LocDR=:MRRequestLocDR where L_RowID = :MRLocationDR)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}

	}

	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORMaintRequest
	TRollBack
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// add by wy 2022-8-14
/// 珠海人民--简易类组和泛类设备层级关系
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).GetBaseItem("","85")
ClassMethod GetBaseItem(Desc As %String = "", GroupID As %String = "")
{

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s Desc=$ZCONVERT(Desc ,"U")
	s root=##class(%Library.DynamicObject).%New()		//json对象
 	s List=##class(%Library.DynamicArray).%New()
	s rowid=0 
	f  s rowid=$o(^DHCEQCCode("DHCEQCEquipType",rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",4)="Y"
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(rowid,GroupID,"","1")'=0   
	.s EQuipTypeIDs=##class(web.DHCEQCommon).GetSysInfo("503018")
	.q:(EQuipTypeIDs'="")&&((","_EQuipTypeIDs_",")'[(","_rowid_","))
	.s ETDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",2)
	.s ETCode=$p($g(^DHCEQCCode("DHCEQCEquipType",rowid)),"^",1)
	.s Data=##class(%Library.DynamicObject).%New()		//json对象
 	.d Data.%Set("id",rowid)
 	.d Data.%Set("text",ETDesc)
 	.d Data.%Set("ETCode",ETCode)
 	.s arr=##class(%Library.DynamicArray).%New()			//json数组	
	.s MIRowID=0
	.f  s MIRowID=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",rowid,MIRowID))  quit:MIRowID=""  d
	..s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",MIRowID)),"^",8)
	..q:LTInvalidFlag="Y"
	..s EQRowID=0
	..s InvalidFlag="N"
	..f  s EQRowID=$o(^DHCEQEquip(0,"Item",MIRowID,InvalidFlag,EQRowID))  quit:EQRowID=""  d
	...q:$p($g(^DHCEQEquip(EQRowID)),"^",83)'="Y"  //过滤非泛类设备
	...s EQCode=$p($g(^DHCEQEquip(EQRowID)),"^",6) //代码
	...s EQName=$p($g(^DHCEQEquip(EQRowID)),"^",1) //描述
	...s EquipTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",63) //类组
	...q:($ZCONVERT(EQName,"U")'[Desc)&(Desc'="")
   	...s obj=##class(%Library.DynamicObject).%New()	//json对象
 	...d obj.%Set("id",EQRowID)
 	...d obj.%Set("text",EQName)
 	...d obj.%Set("EQCode",EQCode)
 	...d obj.%Set("EquipTypeDR",EquipTypeDR)
 	...d arr.%Push(obj)
 	.d Data.%Set("children",arr)
 	.d List.%Push(Data)
	d root.%Set("EquipType",List)							//json对象作为外层json对象的属性data
	//s InputStream=##class(%GlobalCharacterStream).%New()
    //s tsc=root.%ToJSON(.InputStream)					//json数组或对象转成json流
	//b ;d InputStream.OutputToDevice()
	q root.%ToJSON()
}

/// add by wy 2022-8-14
/// 珠海人民--楼宇,楼层,科室.存放地点层级关系
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).GetBaseLocItem("")
ClassMethod GetBaseLocItem(Desc As %String = "")
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc,"U")
 	s index=1
	s root=##class(%Library.DynamicObject).%New()		//json对象
    s ret=##class(%Library.DynamicArray).%New()		//json数组	
	s rowid=0 
	f  s rowid=$o(^DHCDT3DBuilding(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCDT3DBuilding(rowid)),"^",19)'="Y"
	.s BCode=$p($g(^DHCDT3DBuilding(rowid)),"^",1)
	.s BName=$p($g(^DHCDT3DBuilding(rowid)),"^",2)
	.s Data=##class(%Library.DynamicObject).%New()		//json对象
 	.d Data.%Set("id",rowid)
 	.d Data.%Set("BCode",BCode)
 	.d Data.%Set("text",BName)
 	.d Data.%Set("clickFlag","0")
 	.d Data.%Set("state","closed")
 	.s arr=##class(%Library.DynamicArray).%New()			//json数组	
	.if $d(^DHCDT3DBuildingLocMap(0,"Floor",rowid,0))  d
	..s FLMRowID=0  //楼宇对照科室表
	..f  s FLMRowID=$o(^DHCDT3DBuildingLocMap(0,"Building",rowid,FLMRowID))  quit:FLMRowID=""  d
	...s FLMLocDR=$p($g(^DHCDT3DBuildingLocMap(FLMRowID)),"^",3)  //科室ID
    ...s DeptCode=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",1) //
    ...s DeptDesc=$p($g(^DHCEQCCode("DHCEQCDepartment",rowid)),"^",2) //
    ...q:(DeptDesc'="")&&(DeptDesc'[Desc)
   	...s obj=##class(%Library.DynamicObject).%New()	//json对象
 	...d obj.%Set("id",FLMLocDR)
 	...d obj.%Set("DeptCode",DeptCode)
 	...d obj.%Set("text",DeptDesc)
 	...d obj.%Set("clickFlag","1")
 	...d obj.%Set("DeptBID",rowid)
 	...d obj.%Set("DeptFID","")
 	...s List=##class(%Library.DynamicArray).%New()			//json数组	
	...s LRowID=0  //存放地点表
	...f  s LRowID=$o(^DHCEQCCode("DHCEQCLocation",0,"Loc",FLMLocDR,LRowID))  quit:LRowID=""  d
	....s LCode=$p($g(^DHCEQCCode("DHCEQCLocation",LRowID)),"^",1) 
	....s LDesc=$p($g(^DHCEQCCode("DHCEQCLocation",LRowID)),"^",2)
   	....s vData=##class(%Library.DynamicObject).%New()	//json对象
 	....d vData.%Set("id",LRowID)
 	....d vData.%Set("LCode",LCode)
 	....d vData.%Set("text",LDesc)
 	....d vData.%Set("clickFlag","0")
 	....d List.%Push(vData)	
 	...d obj.%Set("children",List)
 	...d arr.%Push(obj)
	.e  d
	..s FRowID=0  //楼层表d ##Class(User.DHCDT3DFloor).%BuildIndices()
	..f  s FRowID=$o(^DHCDT3DFloor(0,"Building",rowid,FRowID))  quit:FRowID=""  d
	...s FloorIndex=$p($g(^DHCDT3DFloor(FRowID)),"^",4)  //楼层描述
   	...s com=##class(%Library.DynamicObject).%New()	//json对象
 	...d com.%Set("id",FRowID)
 	...d com.%Set("text",FloorIndex)
 	...d com.%Set("clickFlag","0")
 	...d com.%Set("state","closed")
	...s varr=##class(%Library.DynamicArray).%New()			//json数组	   
	...s FLMRowID=0  //科室表 d ##Class(User.DHCEQCLocation).%BuildIndices()
	...f  s FLMRowID=$o(^DHCDT3DBuildingLocMap(0,"Floor",rowid,FRowID,FLMRowID))  quit:FLMRowID=""  d
	....s FLMLocDR=$p($g(^DHCDT3DBuildingLocMap(FLMRowID)),"^",3)  //科室ID
    ....s DeptCode=$p($g(^DHCEQCCode("DHCEQCDepartment",FLMLocDR)),"^",1)
    ....s DeptDesc=$p($g(^DHCEQCCode("DHCEQCDepartment",FLMLocDR)),"^",2)
    ....s DeptDesc=##class(web.DHCEQCommon).GetSplitDataByFlag(DeptDesc,"-")  //add by wy 2023-2-10 3266878
    ....s DeptTel=$p($g(^DHCEQCCode("DHCEQCDepartment",FLMLocDR)),"^",5)
    ....q:(DeptDesc'="")&&(DeptDesc'[Desc)
   	....s obj=##class(%Library.DynamicObject).%New()	//json对象
 	....d obj.%Set("id",FLMLocDR)
 	....d obj.%Set("DeptCode",DeptCode)
 	....d obj.%Set("text",DeptDesc)
 	....d obj.%Set("DeptTel",DeptTel)
 	....d obj.%Set("clickFlag","1")
 	....d obj.%Set("DeptBID",rowid)
 	....d obj.%Set("DeptFID",FRowID)
 	....d obj.%Set("state","closed")
 	....s List=##class(%Library.DynamicArray).%New()			//json数组	
	....s LRowID=0  //存放地点表
	....f  s LRowID=$o(^DHCEQCCode("DHCEQCLocation",0,"Loc",FLMLocDR,LRowID))  quit:LRowID=""  d
	.....s LCode=$p($g(^DHCEQCCode("DHCEQCLocation",LRowID)),"^",1) 
	.....s LDesc=$p($g(^DHCEQCCode("DHCEQCLocation",LRowID)),"^",2)
   	.....s vData=##class(%Library.DynamicObject).%New()	//json对象
 	.....d vData.%Set("id",LRowID)
 	.....d vData.%Set("LCode",LCode)
 	.....d vData.%Set("text",LDesc)
 	.....d vData.%Set("clickFlag","0")
 	.....d List.%Push(vData)
 	....i List.%Size()>0 d 
 	.....d obj.%Set("children",List)
    ....d varr.%Push(obj)
 	...i varr.%Size()>0 d 
 	....d com.%Set("children",varr)
 	....d arr.%Push(com) 	
 	.i arr.%Size()>0 d
 	..d Data.%Set("children",arr)
 	..d ret.%Push(Data)
	i ret'="" d root.%Set("Building",ret)							//json对象作为外层json对象的属性data	
	//s InputStream=##class(%GlobalCharacterStream).%New()
    //s tsc=root.%ToJSON(.InputStream)					//json数组或对象转成json流
	//b ;d InputStream.OutputToDevice()
	q root.%ToJSON()
}

/// add by wy 2022-8-22取回，归还时保存配送信息
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).SaveMove("393","WX_Retrieve","1740")
ClassMethod SaveMove(RowID, ActionCode, User)
{
        s (vData,FromDeptID,vMRowID)=""
        s SQLCODE=0
	    s ObjDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)
	    i ObjDR'="" s MObjID=+$Piece($Get(^DHCEQMExObj(ObjDR)),"^",5)
	    s MaintGroupDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",70)
		s MSourceType="31"
		s MSourceID=RowID
		s MEventType="1"			
		if ActionCode="WX_Return" s MEventType="2"
		s FromDeptType="2"
		s FromDeptID=$Piece($Get(^DHCEQCCode("DHCEQMCMaintGroup",MaintGroupDR)),"^",11)
		s AcceptUserDR=User
		s vData=vMRowID_"^^"_MObjID_"^"_MSourceType_"^"_MSourceID_"^"_MEventType_"^^"_FromDeptType_"^"_FromDeptID_"^^^^^^^^^^"_AcceptUserDR_"^^"
		Set vMRowID=##Class(web.DHCEQMoveNew).SaveData(vData,User,"","")
		i vMRowID>0 d
		.s SQLCODE=0
		e  d
		.s SQLCODE=1
		q SQLCODE
}

/// add by wy 2022-8-29
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).ChangAction("418","WX_Finish")
/// 判断下一指定步骤是否符合审批流程
ClassMethod ChangAction(RowID, ActionCode)
{
	i (RowID="" )||(ActionCode="") Quit $$$OK
	s TApproveFlowDR=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("25")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("25", RowID)
	s MaintGroupDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",70)
	s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode)
	s RoleStep=$p(RoleInfo,"^",2)
	s ApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,RoleStep,0))  //下一步审批ApproveFlowDR
	s AllowFlowDR=0
	f  s AllowFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",0,"SourceFlow","0",ApproveFlowDR,AllowFlowDR))  q:AllowFlowDR=""  d
	.s vFlag=0
    .s TAction=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AllowFlowDR)),"^",9)						//Add By DJ 2016-04-20
    .s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TAction)),"^",1)
    .if ActionCode="WX_Accept" d
	..s TActions= $Piece($Get(^DHCEQCCode("DHCEQMCMaintGroup",MaintGroupDR)),"^",10) 
	..i ((TActions'="")&&((","_TActions_",")'[(","_TAction_","))) s vFlag=1  
    .if ActionCode="WX_Finish" d 
    ..s approvelistid=$o(^DHCEQApproveList(0,"Step",ApproveType,RowID,RoleStep,0))
    ..s result=##Class(web.DHCEQMoveNew).CheckMoveReturn("31",RowID)
    ..i result="0" d
    ...i (TActionCode="WX_Return") s vFlag=1
    ..e  d
	...i (TActionCode'="WX_Return") s vFlag=1
	.q:vFlag=1
	.if TApproveFlowDR'="" s TApproveFlowDR=TApproveFlowDR_","
    .s TApproveFlowDR=TApproveFlowDR_AllowFlowDR
    q TApproveFlowDR
}

/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).AuditStepsByActions("WX_Appearance","WX_Retrieve","427^77^^^85","","")
/// 多部审批同时操作
/// modified by wy 2023-3-29 3418008 判断最后一步流程走向
ClassMethod AuditStepsByActions(FromActionCodes, ToActionCode, CombinData As %Library.String = "", EditFields As %Library.String = "", Opinion As %Library.String = "", ApproveFlowDR As %Library.String = "")
{
	n FromActionLength,CurActionCode,ReturnInfo
	s (FromActionLength,CurActionCode,ReturnInfo)=""
	s ReturnInfo=##class(%Library.DynamicObject).%New()
	d ReturnInfo.%Set("SQLCODE","0")
	
	s FromActionLength=$l(FromActionCodes,",")
	f i=1:1:FromActionLength d
	.q:ReturnInfo.%Get("SQLCODE")'=0
	.s CurActionCode=$p(FromActionCodes,",",i)
	.s ReturnInfo=##Class(web.DHCEQ.EM.BUSMMaintRequest).AuditData(CombinData,"","","","","默认同步审核",CurActionCode,"")
	.s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(ReturnInfo)
	
	i ReturnInfo.%Get("SQLCODE")'=0 q ReturnInfo.%ToJSON()
	s ReturnInfo=##Class(web.DHCEQ.EM.BUSMMaintRequest).AuditData(CombinData,"","",EditFields,ApproveFlowDR,Opinion,ToActionCode,"")
	
	q ReturnInfo
}

/// add by wy 2022-9-14 生成故障原因，类型，解决方法跟设备项对照
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).UpdFaultEquipMap("")
/// modified by wy 2023-2-29 3327273 维修完成时判断是已否存在对照，存在则调保存对照方法
/// modifed by wy 2023-4-17 3450428故障原因，类型，解决方法为空的时候，不生成对照
ClassMethod UpdFaultEquipMap(RowID)
{
	    n FaultReasonDR,DealMethodDR,EXObjDR,ItemDR,Reslut,LReslut,DReslut
	    s (FaultReasonDR,DealMethodDR,EXObjDR,ItemDR,Reslut,LReslut,DReslut)=""
	    s SQLCODE=0
		s FaultReasonDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",12)
		s DealMethodDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",14)
		s FaultTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",23)
		s ExObjDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",5)     //modified by wy 2022-9-22
		s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(RowID)),"^",63)		//MRHold3
	    s EquipDR=$Piece($Get(^DHCEQMExObj(ExObjDR)),"^",5)
        i EquipDR'="" s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	   	
	   	s val="^2^"_FaultReasonDR_"^2^"_ItemDR_"^^^Y^^^^^"
	   	s List="^3^"_DealMethodDR_"^2^"_ItemDR_"^^^Y^^^^^"
		s Data="^4^"_FaultTypeDR_"^2^"_ItemDR_"^^^Y^^^^^"
		s tmpid="" 
		S Vtmpid=""
		S Ptmpid=""
		if FaultReasonDR'=""
		{
			&SQL(select FEM_RowID into :tmpid from sqluser.DHC_EQMCFaultEquipMap where FEM_MapType=2 and FEM_FaultID=:FaultReasonDR and FEM_ESourceID=:ItemDR and  FEM_ESourceType=2)
			if tmpid="" 
			 {
					s Reslut=##class(web.DHCEQ.EM.KNMaint).SaveFaultEquipMapData(val)
					s Reslut =##class(web.DHCEQ.Plat.JsonObject).FromJSON(Reslut)
			        s SQLCODE=Reslut.SQLCODE
			 }
		}
		i SQLCODE q SQLCODE
		if DealMethodDR'=""
		{
			&SQL(select FEM_RowID into :Vtmpid from sqluser.DHC_EQMCFaultEquipMap where FEM_MapType=3 and FEM_FaultID=:DealMethodDR and FEM_ESourceID=:ItemDR and  FEM_ESourceType=2)
			if Vtmpid="" 
			 {
					s LReslut=##class(web.DHCEQ.EM.KNMaint).SaveFaultEquipMapData(List)
					s LReslut =##class(web.DHCEQ.Plat.JsonObject).FromJSON(LReslut)
			        s SQLCODE=LReslut.SQLCODE
			 }
		}
		i SQLCODE q SQLCODE
		if FaultTypeDR'=""
		{
			&SQL(select FEM_RowID into :Ptmpid from sqluser.DHC_EQMCFaultEquipMap where FEM_MapType=4 and FEM_FaultID=:FaultTypeDR and FEM_ESourceID=:ItemDR and  FEM_ESourceType=2)
			if Ptmpid="" 
			 {
					s DReslut=##class(web.DHCEQ.EM.KNMaint).SaveFaultEquipMapData(Data)
					s DReslut =##class(web.DHCEQ.Plat.JsonObject).FromJSON(DReslut)
			        s SQLCODE=DReslut.SQLCODE
			 }
		}
		i SQLCODE q SQLCODE
		q SQLCODE
}

/// w ##class(web.DHCEQ.EM.BUSMMaintRequest).MaintQuantityAnalysis(85)
/// modified by wy 2023-4-4 移动端增加GroupID,对移动端维修首页数据进行过滤
ClassMethod MaintQuantityAnalysis(GroupID As %String = "")
{
	s (RequestQuantity,FinishQuantity,LatestRequestQuantity,LatestFinishQuantity,TotalFee)=0
	s LatestDate=+$h-1
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s MaintRequestDR=0
	f  s MaintRequestDR=$o(^DHCEQMMaintRequest(MaintRequestDR)) q:MaintRequestDR=""  d
	.q:($p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",57))="Y"
	.q:($p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",41))="0"
	.q:($p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",41))="3" //过滤作废的单据
	.s EquipTypeDR=$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",3)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"0","2")) //add by wy 2023-4-3 增加安全组可访问类组
	.s RequestQuantity=RequestQuantity+1
	.s RequestDate=($p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",18))
	.s FinishDate=($p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",16))
	.i FinishDate'="" s FinishQuantity=FinishQuantity+1
	.i RequestDate=LatestDate s LatestRequestQuantity=LatestRequestQuantity+1
	.i FinishDate=LatestDate s LatestFinishQuantity=LatestFinishQuantity+1
	.s TotalFee=TotalFee+$p($g(^DHCEQMMaintRequest(MaintRequestDR)),"^",60)
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
	
	q RequestQuantity_"^"_FinishQuantity_"^"_LatestRequestQuantity_"^"_LatestFinishQuantity_"^"_TotalFee
}

/// add By WY 2023-02-21
/// 描述: 输出维修列表，即要求能够查询，又要求可以操作在权限内的单据
/// 访问表：DHC_EQCGroupEquipType
/// 参数：DatePattern 日期类型,StartDate开始日期,EndDate结束日期,LocPattern科室类型,UseLocDR科室,UserPattern人员类型,UserDR人员，vActionDR动作
/// vData包含 MREquipTypeDR维修大类，EmergencyFlag是否急单标记，ReminderFlag是否催单标记，KeyWord关键字
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMMaintRequest","GetMaintRequestDetail","31","","","","","8","","2023-03-08","3","","4","","0","^MREquipTypeDR=^EmergencyFlag=^ReminderFlag=false^ManageTypeID=1^EquipTypeFindDR=^KeyWord=")
Query GetMaintRequestDetail(BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "", EquipDR As %String = "", DatePattern As %String = "", StartDate As %String = "", EndDate As %String = "", LocPattern As %String = "", UseLocDR As %String = "", UserPattern As %String = "", UserDR As %String = "", vActionDR As %String = "", vData As %String = "") As %Query(ROWSPEC = "TBussType:%String,TBussID:%String,TMsgID:%String,TEquipTypeDR:%String,TEquipType:%String,TSendUser:%String,TSendDate:%String,TNo:%String,TName:%String,TRequestLoc:%String,TDate:%String,TUseLoc:%String,TFromLoc:%String,TToLoc:%String,TMoveType:%String,TOutType:%String,TContractNo:%String,TBStatus:%String,TRow:%String,TRoles:%String,TActionDesc:%String,TActionCode:%String,TLastOperate:%String,TModel:%String,TEquipNo:%String,TFileNo:%String,TWaringFlag:%String,TGuaranteeFlag:%String,TStartDate:%String,TPlanEndDate:%String,TApproveSetDR:%String,TBussTypeID:%String,TOriginalFee:%String,TFaultCase:%String,TEmergencyFlag:%String,TAcceptUser:%String,TSeverityFlag:%String,TTime:%String,TReplacementFlag:%String,TStatus:%String")
{
}

ClassMethod GetMaintRequestDetailExecute(ByRef qHandle As %Binary, BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "", EquipDR As %String = "", DatePattern As %String = "", StartDate As %String = "", EndDate As %String = "", LocPattern As %String = "", UseLocDR As %String = "", UserPattern As %String = "", UserDR As %String = "", vActionDR As %String = "", vData As %String = "") As %Status
{
    
	new repid, index,rowid	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	new ApproveType,BussTypeID,ApproveInfo
 	new EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,LocDR,EquipID
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set ManageTypeID=##class(web.DHCEQCommon).GetDataByName(vData,"ManageTypeID")
 	Set EmergencyFlag=##class(web.DHCEQCommon).GetDataByName(vData,"EmergencyFlag")
 	Set ReminderFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ReminderFlag")
 	set KeyWord=##class(web.DHCEQCommon).GetDataByName(vData,"KeyWord")
 	set KeyWord=$ZCONVERT(KeyWord ,"U")
 	Set EmergencyFlag=##class(web.DHCEQCommon).TransValueFromPage(EmergencyFlag,"bool")
 	Set ReminderFlag=##class(web.DHCEQCommon).TransValueFromPage(ReminderFlag,"bool")
 	set EquipTypeFindDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeFindDR")
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurLocDR="" s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	if (DatePattern'="")
	{
			s DateStr=##Class(web.DHCEQ.Plat.LIBMessages).GetDateFilerInfo(DatePattern,StartDate,EndDate)
			s StartDate=$p(DateStr,"^",1)
			s EndDate=$p(DateStr,"^",2)
	}
	if (LocPattern="2")
	{
		i UseLocDR="" s UseLocDR=CurLocDR  
	}
	if ((UserPattern="2")||(UserPattern="3"))
	{
		i UserDR="" s UserDR=UserID  
	}
 	s CurRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID) 
 	i (GroupID="")||(UserID="")||(CurRoleIDs="") Quit $$$OK
 	k ^TempDHCEQ("BussNumInfo",BussType,UserID)
 	s index=1
 	s TRow=0
	Set RowID=0
	For  Set RowID=$Order(^DHCEQMMaintRequest(RowID))  Quit:RowID=""  Do
	.q:$p($g(^DHCEQMMaintRequest(RowID)),"^",57)="Y" // 维修单无效标记
	.d BuildDataGetMMaintRequestDetail
	Quit $$$OK
BuildDataGetMMaintRequestDetail		
    Do ResetVariablesGetMMaintRequestDetail
    s (TRoles,TActionDesc,TActionCode,ActionIDs,TSendUser,TSendDate)=""
	s BussTypeID="31"
	s TBussType=BussTypeID	 
	s TBussID = RowID    
	s TEquipTypeDR=$p($g(^DHCEQMMaintRequest(RowID)),"^",3) //4	
	q:(TEquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,GroupID,"","2")) 
	s EquipTypeDRs=##class(web.DHCEQCommon).GetSysInfo("503018")   //add by wy 2023-3-29增加可做维修类组过滤
	q:(TEquipTypeDR'="")&&((","_EquipTypeDRs_",")'[(","_TEquipTypeDR_","))
	i TEquipTypeDR'="" s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR) //5
	q:(ReminderFlag="Y")&&(##Class(web.DHCEQ.Plat.LIBMessages).CheckReminderBuss(BussType,TBussID)=0) //催单过滤
	q:(BussTypeID="31")&&(EmergencyFlag="Y")&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",61)="")  	// 紧急级别过滤
	q:(BussTypeID="31")&&(+ManageTypeID>0)&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",2)'=ManageTypeID)	//	维修大类过滤
    q:(BussTypeID="31")&&(+EquipTypeFindDR>0)&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",3)'=EquipTypeFindDR) // add by zyq 2023-03-07	实际对照EquipType类别
    q:(EquipDR'="")&&(##Class(web.DHCEQMessages).CheckEquipIsInBuss(BussTypeID,TBussID,EquipDR)=0)  //设备过滤
	s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussTypeID,TBussID)
	q:((StartDate'="")&&($p(BussInfo,"^",4)<StartDate)) 
	q:((EndDate'="")&&($p(BussInfo,"^",4)>EndDate)) 
	q:((UseLocDR'="")&&($p(BussInfo,"^",5)'=UseLocDR)) 
	q:(UserPattern="3")&&($p(BussInfo,"^",30)=UserDR)
	q:((UserPattern'="")&&(UserPattern'="3")&&(UserDR'="")&&($p(BussInfo,"^",30)'=UserDR)) 
	s TMsgID=$o(^DHCEQMessages(0,"MessageType",1,BussTypeID,RowID,""),-1)
	s CurRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
 	if TMsgID'="" d
 	.q:($p($g(^DHCEQMessages(TMsgID)),"^",21)="Y")
 	.s SendUserDR=$p($g(^DHCEQMessages(TMsgID)),"^",9)
	.s TSendUser= ##Class(web.DHCEQCommon).GetTrakNameByID("user",SendUserDR)
	.s TSendDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMessages(TMsgID)),"^",10),"date")
	.s SendTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMessages(TMsgID)),"^",11),"time")
	.s TSendDate=TSendDate_" "_SendTime
    .s PassFlag=##Class(web.DHCEQMessages).CheckMessageRoles(GroupID,UserID,TMsgID,CurRoleIDs)
	.q:$p(PassFlag,"^",1)=0 
	.s TActionDesc=$p(PassFlag,"^",3)
	.s TActionCode=$p(PassFlag,"^",2)
	.s ActionIDs=$p(PassFlag,"^",4)
	.s TRoles=$p(PassFlag,"^",5)	
	q:(vActionDR="Aduit")&&($p($g(^DHCEQMMaintRequest(RowID)),"^",41)'=2)  //过滤完结的单子
	q:(vActionDR'="")&&(vActionDR'="Aduit")&&((","_ActionIDs_",")'[(","_vActionDR_","))  //Add By QW20200707 BUG:QW0069 增加动作id判断
	s TNo=$p(BussInfo,"^",1)    //8
	s TName=$p(BussInfo,"^",2)  //9
	s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",3)) //10
	s TDate=##Class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",4),"date") //11	
	s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",5))  //12
    s TLocationDR =$p($g(^DHCEQMMaintRequest(TBussID)),"^",22)  //add by wy 2023-4-4 3428542
	if TLocationDR'="" s TUseLoc=TUseLoc_"("_##Class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)_")"
	s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",6))
	s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",7))
	s TMoveType=$p(BussInfo,"^",8)
	s TOutType=$p(BussInfo,"^",9)
	s TContractNo=$p(BussInfo,"^",10)
	s TBStatus=$p(BussInfo,"^",14)   //18
	s LastHandler=$p(BussInfo,"^",20)  
	s TLastOperate=$p(BussInfo,"^",21) // 最后一次操作23
	s TEquipNo=$p(BussInfo,"^",23)  // 获取设备编号字段
	s TFileNo=$p(BussInfo,"^",24)
	s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",28),"date")  
	s TPlanEndDate=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",29),"date")  
	s TWaringFlag=+##Class(web.DHCEQPrescription).GetPrescriptionInfo(ApproveType,TBussID) //时效标志 
	s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(BussType,TBussID,"")
	s StatCatDR=$p(ApproveInfo,"^",11)
	s EquipCatDR=$p(ApproveInfo,"^",12)
	s LocDR=$p(ApproveInfo,"^",9)
	s EquipID=$p(ApproveInfo,"^",14)
    s TApproveSetDR=$p(ApproveInfo,"^",3)  
	i EquipID'="" d
	.s ModelID=$p($g(^DHCEQEquip(EquipID)),"^",3)
	.i ModelID'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",ModelID)),"^",2)
	.;s GuaranteeEndDate=$p($g(^DHCEQEquip(EquipID)),"^",51)  
	.;s TGuaranteeFlag=0
	.;i +GuaranteeEndDate>+$h s TGuaranteeFlag=1  
	s TGuaranteeFlag=$p(##class(web.DHCEQ.EM.BUSMMaintRequest).GetGuaranteeData(EquipID),"^",1)
	s ItemDR=$p(ApproveInfo,"^",13)
	s CancelToUser=$p(ApproveInfo,"^",19)
	s AssignDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Assign",0))_","			//派单动作DR	
	s EvaluateDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Evaluate",0))_","		//组长审核动作DR
	s LeaderFlag=$D(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",1,UserID))		//是否维修组长
	s TOriginalFee=$p(BussInfo,"^",31)  
	s TFaultCase=$p(BussInfo,"^",27)
    s TEmergencyFlag=$p(BussInfo,"^",33)
	s TAcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(BussInfo,"^",30))	
    s TSeverityFlag=$p(BussInfo,"^",34) //紧急标志
    s TTime=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",35),"time")  //申请时间
	s TReplacementFlag=$p(ApproveInfo,"^",20)  //回置标志
	q:(KeyWord'="")&&($ZCONVERT(TFaultCase,"U")'[KeyWord )&&($ZCONVERT(TAcceptUser ,"U")'[KeyWord)&&($ZCONVERT(TName ,"U")'[KeyWord)
	s TStatus=$p($g(^DHCEQMMaintRequest(RowID)),"^",41)
	s TDate=TDate_" "_TTime  //modified by wy 2023-4-4 3428540
	Do OutputRowGetMMaintRequestDetail
	Quit
OutputRowGetMMaintRequestDetail
	Set TRow=TRow+1  //19
	Set Data=$lb(TBussType,TBussID,TMsgID,TEquipTypeDR,TEquipType,TSendUser,TSendDate,TNo,TName,TRequestLoc,TDate,TUseLoc,TFromLoc,TToLoc,TMoveType,TOutType,TContractNo,TBStatus,TRow,TRoles,TActionDesc,TActionCode,TLastOperate,TModel,TEquipNo,TFileNo,TWaringFlag,TGuaranteeFlag,TStartDate,TPlanEndDate,TApproveSetDR,TBussTypeID,TOriginalFee,TFaultCase,TEmergencyFlag,TAcceptUser,TSeverityFlag,TTime,TReplacementFlag,TStatus)	
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetMMaintRequestDetail
	Set (TBussType,TBussID,TMsgID,TEquipTypeDR,TEquipType,TSendUser,TSendDate,TNo,TName,TRequestLoc,TDate,TUseLoc,TFromLoc,TToLoc,TMoveType,TOutType,TContractNo,TBStatus,TRoles,TActionDesc,TActionCode,TLastOperate,TModel,TEquipNo,TFileNo,TWaringFlag,TGuaranteeFlag,TStartDate,TPlanEndDate,TApproveSetDR,TBussTypeID,TOriginalFee,TFaultCase,TEmergencyFlag,TAcceptUser,TSeverityFlag,TTime,TReplacementFlag,TStatus)=""	
	Quit
}

ClassMethod GetMaintRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add By zyq 2023-03-07
/// 描述: 输出维修类组
/// 访问表：DHC_EQCGroupEquipType
/// 返回值:维修组json对象
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).MaintType(85)
/// 入参:当前安全组CurGroupID 
/// modified by wy 2023-4-6 修改类组过滤
ClassMethod MaintType(Group As %String = "")
{
	new results,Data
	s erowid=0
	s results=""
	s Info=##Class(web.DHCEQCommon).GetSysInfo(503018)
	if Group="" s Group=%session.Get("LOGON.GROUPID")
	f  s erowid=$o(^DHCEQCCode("DHCEQCEquipType",erowid))  quit:erowid=""  d
	.d ResetVariablesGroupEquipType
	.q:($p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",4)="Y")
	.s TEquipTypeDR=erowid
	.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",erowid)),"^",2)
	.i $D(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",Group,erowid)) d
	..s TRowid=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",Group,erowid,0))
	.q:TRowid=""
	.q:((","_Info_",")'[(","_TEquipTypeDR_","))
	.s Data=TEquipTypeDR_"^"_TEquipType
	.if results="" d
	..s results=Data
	.e  d
	..s results=results_","_Data
	Quit results
ResetVariablesGroupEquipType
	Set (TEquipTypeDR,TEquipType,TRowid)=""
	Quit
}

/// add by wy 2023-4-17
/// 入参：ApproveSetDR审批设置，EquipTypeDR管理类组 Group安全组
/// w ##Class(web.DHCEQ.EM.BUSMMaintRequest).GetApproveSetActionMap("39","14","77")
/// 获取审批设置，类组可以访问的动作
ClassMethod GetApproveSetActionMap(ApproveSetDR As %String = "", EquipTypeDR As %String = "", Group As %String = "")
{
	if Group="" s Group=%session.Get("LOGON.GROUPID")
    s TActionCodes=""
	i (ApproveSetDR="" )&&(EquipTypeDR="") Quit $$$OK
    s ApproveSet=0
	f  s ApproveSet=$o(^DHCEQApproveSetActionMap(0,"Equip",ApproveSet))  q:ApproveSet=""  d
	.q:(ApproveSetDR'="")&&(ApproveSetDR'=ApproveSet)
	.s ACAEquipTypeDR=0
	. f  s ACAEquipTypeDR=$o(^DHCEQApproveSetActionMap(0,"Equip",ApproveSet,ACAEquipTypeDR))  q:ACAEquipTypeDR=""  d
	..q:(EquipTypeDR'="")&&(EquipTypeDR'=ACAEquipTypeDR)
    ..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(ACAEquipTypeDR,Group,"0","2")) 
    ..s ACARowID=0
	..f  s ACARowID=$o(^DHCEQApproveSetActionMap(0,"Equip",ApproveSet,ACAEquipTypeDR,ACARowID))  q:ACARowID=""  d
	...q:$p($g(^DHCEQApproveSetActionMap(ACARowID)),"^",5)="Y"
    ...s TAction=$p($g(^DHCEQApproveSetActionMap(ACARowID)),"^",4)
    ...i TAction'="" s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TAction)),"^",1)
	...if TActionCodes'="" s TActionCodes=TActionCodes_","
    ...s TActionCodes=TActionCodes_TActionCode
    q TActionCodes
}

}
