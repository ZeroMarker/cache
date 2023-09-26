Class web.DHCEQ.Plat.LIBMessages Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// MZY0124	2654459		2022-05-23	增加时效业务单背景色出参:TBackColor
/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
///       RoleIDs：角色ids
/// Add By QW20200604 BUG:QW0065 增加参数DatePattern,StartDate,EndDate,LocPattern,UseLocDR,UserPattern,UserDR
/// Add By QW20200707 BUG:QW0069 增加参数
/// 参数类型：DatePattern 日期类型,StartDate开始日期,EndDate结束日期,LocPattern科室类型,UseLocDR科室,UserPattern人员类型,UserDR人员，
/// vActionDR动作，ManageTypeID管理类型，EmergencyFlag是否急单标记，ReminderFlag是否催单标记
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetBussDataByCode","31","85","1740","183","","8","","2022-08-30","","","","","2","^ManageTypeID=^EmergencyFlag=false^ReminderFlag=false")
/// Modefied by zc 2022-4-8 增加入参vData
Query GetBussDataByCode(BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "", EquipDR As %String = "", DatePattern As %String = "", StartDate As %String = "", EndDate As %String = "", LocPattern As %String = "", UseLocDR As %String = "", UserPattern As %String = "", UserDR As %String = "", vActionDR As %String = "", vData As %String = "") As %Query(ROWSPEC = "TBussType:%String,TBussID:%String,TMsgID:%String,TEquipTypeDR:%String,TEquipType:%String,TSendUser:%String,TSendDate:%String,TNo:%String,TName:%String,TRequestLoc:%String,TDate:%String,TUseLoc:%String,TFromLoc:%String,TToLoc:%String,TMoveType:%String,TOutType:%String,TContractNo:%String,TBStatus:%String,TRow:%String,TRoles:%String,TActionDesc:%String,TActionCode:%String,TLastOperate:%String,TModel:%String,TEquipNo:%String,TFileNo:%String,TWaringFlag:%String,TGuaranteeFlag:%String,TStartDate:%String,TPlanEndDate:%String,TApproveSetDR:%String,TBussTypeID:%String,TOriginalFee:%String,TFaultCase:%String,TEmergencyFlag:%String,TAcceptUser:%String,TSeverityFlag:%String,TTime:%String,TReplacementFlag:%String,TEquipDR:%String,TLocation:%String")
{
}

ClassMethod GetBussDataByCodeExecute(ByRef qHandle As %Binary, BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "", EquipDR As %String = "", DatePattern As %String = "", StartDate As %String = "", EndDate As %String = "", LocPattern As %String = "", UseLocDR As %String = "", UserPattern As %String = "", UserDR As %String = "", vActionDR As %String = "", vData As %String = "") As %Status
{
	new repid, index,rowid	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	new ApproveType,BussTypeID,ApproveInfo
 	new EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,LocDR,EquipID
 	// Modefied by zc 2022-4-8 begin
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set ManageTypeID=##class(web.DHCEQCommon).GetDataByName(vData,"ManageTypeID")
 	Set EmergencyFlag=##class(web.DHCEQCommon).GetDataByName(vData,"EmergencyFlag")
 	//Set ActionPattern=##class(web.DHCEQCommon).GetDataByName(vData,"ActionPattern")
 	Set ReminderFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ReminderFlag")
 	Set EmergencyFlag=##class(web.DHCEQCommon).TransValueFromPage(EmergencyFlag,"bool")
 	Set ReminderFlag=##class(web.DHCEQCommon).TransValueFromPage(ReminderFlag,"bool")
 	set KeyWord=##class(web.DHCEQCommon).GetDataByName(vData,"KeyWord")  //add by 2023-3-1 关键字查询3266967
 	set EquipTypeFindDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeFindDR") //add by zyq 2023-03-07
 	//Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	//Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	// Modefied by zc 2022-4-8 end
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurLocDR="" s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	//Add By QW20200604 BUG:QW0065 Begin 处理查询条件
 	if (DatePattern'="")
	{
			s DateStr=##Class(web.DHCEQ.Plat.LIBMessages).GetDateFilerInfo(DatePattern,StartDate,EndDate)
			s StartDate=$p(DateStr,"^",1)
			s EndDate=$p(DateStr,"^",2)
	}
	if (LocPattern="2")
	{
		//i CurLocDR'="" s UseLocDR=CurLocDR
		i UseLocDR="" s UseLocDR=CurLocDR  //##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	}
	if ((UserPattern="2")||(UserPattern="3"))
	{
		i UserDR="" s UserDR=UserID  //##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	}
	//Add By QW20200604 BUG:QW0065 End
 	s CurRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID) 
 	//Modify by zx 2020-11-26 BUG ZX0118
 	i (GroupID="")||(UserID="")||(CurRoleIDs="") Quit $$$OK
 	;i (GroupID="")||(UserID="")||(BussType="")||(CurRoleIDs="") Quit $$$OK
 	;s ApproveType=##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)  //add by zx 2016-12-28 根据业务类型获取审批类型 ZX0036
 	k ^DHCEQTemp("BussNumInfo",BussType,UserID)
 	s index=1
 	s TRow=0
 	s SortFlag=##Class(web.DHCEQCommon).GetSysInfo("503017") 
 	i SortFlag>0 
 	{
	 	s MsgID=""
 		f  s MsgID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID),-1) q:MsgID=""  d
 		.d BuildDataGetBussDataByCodeNew
 	}
 	else
 	{
 		s MsgID=0
 		f  s MsgID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID)) q:MsgID=""  d
 		.d BuildDataGetBussDataByCodeNew
 	}
 	Quit $$$OK
BuildDataGetBussDataByCodeNew
 	d ResetVariablesRowGetBussDataByCode
 	//判断消息的可处理角色和当前角色是否符合
 	s PassFlag=0
 	s ActionIDs=""
    s PassFlag=##Class(web.DHCEQMessages).CheckMessageRoles(GroupID,UserID,MsgID,CurRoleIDs) //Bug ZX0045
	q:$p(PassFlag,"^",1)=0
	s TActionDesc=$p(PassFlag,"^",3)
	s TActionCode=$p(PassFlag,"^",2)
	s ActionIDs=$p(PassFlag,"^",4)
	s Roles=$p(PassFlag,"^",5)
	s PDataList=$g(^DHCEQMessages(MsgID))
	q:(+vActionDR'=0)&&((","_ActionIDs_",")'[(","_vActionDR_","))  //Add By QW20200707 BUG:QW0069 增加动作id判断
 	q:$p(PDataList,"^",14)'="1"
 	;q:$p(PDataList,"^",21)="Y"
	s BussTypeID=$p(PDataList,"^",10)
    q:(BussType'="")&(BussTypeID'=BussType)
	s TBussID=$p(PDataList,"^",11)
    s BussTypePassFlag=1
	i BussType="31" d
	.i $p(PDataList,"^",21)="Y" s BussTypePassFlag=0
	.i $p($g(^DHCEQMMaintRequest(TBussID)),"^",41)=2
	..;q:MsgID'=$O(^DHCEQMessages(0,"MessageType",1,BussType,TBussID,""),-1) //只筛完成订单的筛选出最后一步
	..s TActionDesc=",已审核"
	..s BussTypePassFlag=1
	/*modified by wy 2023-4-14 屏蔽不能操作的单子
	.e  i ($p($g(^DHCEQMMaintRequest(TBussID)),"^",56)'="") d //存在取消标志 add by zyq 2022-11-22 begin 筛选被退回单据
	..s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	..s LastOperate=##Class(web.DHCEQApproveList).GetLastApproveListOpinion(ApproveType,TBussID)
	..i $p(LastOperate,"^",3)="" d ;上一步已取消
	...s TActionDesc=",被退回"
	...s BussTypePassFlag=1
	.e  i $p($g(^DHCEQMMaintRequest(TBussID)),"^",57)="Y" d //add by zyq begin 2022-11-20 已作废单
	..s TActionDesc=",已作废" 
	..s TActionCode=",Cancel" //add by zyq end 2022-11-20
	..s BussTypePassFlag=1*/
	e  d
	.i $p(PDataList,"^",21)="Y" s BussTypePassFlag=0  // 最后全部审批完的需要挑出来 //modify by zyq 2022-11-22 end
	q:BussTypePassFlag=0
	q:(ReminderFlag="Y")&&(##Class(web.DHCEQ.Plat.LIBMessages).CheckReminderBuss(BussType,TBussID)=0)
	q:(BussTypeID="31")&&(EmergencyFlag="Y")&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",61)="")  	// Modefied by zc 2022-4-8
	;q:(BussTypeID="31")&&(EmergencyFlag="N")&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",61)'="")	// Modefied by zc 2022-4-8
	q:(BussTypeID="31")&&(+EquipTypeFindDR>0)&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",3)'=EquipTypeFindDR) //add by zyq 2023-03-07 实际对照设备分类				
    //q:(BussTypeID="31")&&(##Class(web.DHCEQ.Plat.LIBMessages).GetActionStatusFilerInfo(ActionPattern,TActionCode,TBussID)=1)	
    q:(EquipDR'="")&&(##Class(web.DHCEQMessages).CheckEquipIsInBuss(BussTypeID,TBussID,EquipDR)=0)  //modified by czf
   
    s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussTypeID,TBussID)
    //Modify by zx 2020-11-26 BUG ZX0118
    s ApproveType=##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussTypeID)
    //modify by zx 
	;q:(($p(BussInfo,"^",3)'=CurLocDR)&&($p(BussInfo,"^",6)'=CurLocDR))&&(BussTypeID="64")      //add by jyp 355232
	;q:(($p(BussInfo,"^",29)-(+$h))>1)&&(BussTypeID="64")    //add by lmm 355232
	;q:($p(BussInfo,"^",12)'=2)&&(BussTypeID="64")
	;q:($p(BussInfo,"^",12)=2)&&(BussTypeID'="64")		//BussStatus  add by zx 2016-11-17 租赁审核状态处理 ZX0036
	q:$p(BussInfo,"^",13)="Y"		//BussInvalidFlag
	q:((StartDate'="")&&($p(BussInfo,"^",4)<StartDate)) //Add By QW20200604 BUG:QW0065 
	q:((EndDate'="")&&($p(BussInfo,"^",4)>EndDate)) //Add By QW20200604 BUG:QW0065
	q:((UseLocDR'="")&&($p(BussInfo,"^",5)'=UseLocDR)) //Add By QW20200604 BUG:QW0065
	q:(UserPattern="3")&&($p(BussInfo,"^",30)=UserDR) //Add By QW20200604 BUG:QW0065
	q:((UserPattern'="")&&(UserPattern'="3")&&(UserDR'="")&&($p(BussInfo,"^",30)'=UserDR)) //Add By QW20200604 BUG:QW0065  modified by wy 2022-1-27
	//取当前业务审批信息,获取限制条件,以便后面查看用户是否有权限收消息
	s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(BussType,TBussID,"")
	//EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR
	s EquipTypeDR=$p(ApproveInfo,"^",10)
	q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"","2")) //add by zx 2017-03-20 BUG ZX0036
	s StatCatDR=$p(ApproveInfo,"^",11)
	s EquipCatDR=$p(ApproveInfo,"^",12)
	s LocDR=$p(ApproveInfo,"^",9)
	s EquipID=$p(ApproveInfo,"^",14)
    	s TApproveSetDR=$p(ApproveInfo,"^",3)  //add by zx 2017-06-20 BUG ZX0045 微信端approveset获取
	s TNextStepID=$p(ApproveInfo,"^",5)	//czf 2021-09-01 begin
	s THospitalDR=$p(BussInfo,"^",32)
	s (AppFlowID,HospLimit)=""
	i (TApproveSetDR'="")&&(TNextStepID'="") d
	.s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",TApproveSetDR,TNextStepID,""))
	.i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	q:(THospitalDR'="")&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit)) //czf 2021-09-01 end
	i EquipID'="" d
	.s TEquipDR=EquipID //add by zyq 2023-1-11
	.s ModelID=$p($g(^DHCEQEquip(EquipID)),"^",3)
	.i ModelID'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",ModelID)),"^",2)
	.;s GuaranteeEndDate=$p($g(^DHCEQEquip(EquipID)),"^",51)  //add by zx 2017-01-05 增加保修内标志 ZX0036
	.;s TGuaranteeFlag=0
	.;i +GuaranteeEndDate>+$h s TGuaranteeFlag=1  
	s TGuaranteeFlag=$p(##class(web.DHCEQ.EM.BUSMMaintRequest).GetGuaranteeData(EquipID),"^",1)
	s ItemDR=$p(ApproveInfo,"^",13)
	s CancelToUser=$p(ApproveInfo,"^",19)
	s AssignDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Assign",0))_","			//派单动作DR	//Add By DJ  2016-05-25 begin
	s EvaluateDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Evaluate",0))_","		//组长审核动作DR
	s LeaderFlag=$D(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",1,UserID))		//是否维修组长
	s PersonelFlag=0  //add by jdl 2017-01-11
	s AuditFlag=0 //Add By QW20200907 BUG:QW0078
	if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Accept",0))_",")  d
	.s PersonelFlag=1
	else  if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Audit",0))_",")  d
	.s PersonelFlag=1
	.s AuditFlag=1 //Add By QW20200907 BUG:QW0078
	else  if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Finish",0))_",")  d
	.s PersonelFlag=1
	s CMLReturn=0
	i ('((LeaderFlag)&&(((","_ActionIDs_",")[AssignDR)||((","_ActionIDs_",")[EvaluateDR))))&&(PersonelFlag'=1)  d		//不满足既是维修组长并且消息动作权限包含派单或组长审核动作
	.s CMLReturn=##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)
 	q:CMLReturn'=0
 	q:(AuditFlag=1)&&(##Class(web.DHCEQCommon).ISPreLoc(LocDR,CurLocDR)=0) //Modified By QW20200922 BUG:QW0081 优化访问权限
	i (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","Move_Receive",0))_",")  d	//czf 2021-06-03 begin
	.s AuditFlag=1
	s ToLocDR=$p(BussInfo,"^",7)
	q:(AuditFlag=1)&&(ToLocDR'="")&&(##Class(web.DHCEQCommon).ISPreLoc(ToLocDR,CurLocDR)=0)		//czf 2021-06-03 end
	.i (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","BuyReq_Loc",0))_",")  d	//czf 2023-04-18 begin
	..s AuditFlag=1
	.s RequestLocDR=$p(BussInfo,"^",3)
	.q:(AuditFlag=1)&&(RequestLocDR'="")&&(##Class(web.DHCEQCommon).ISPreLoc(RequestLocDR,CurLocDR)=0)		//czf 2023-04-18 end
	d ##Class(web.DHCEQ.Plat.LIBMessages).BussNumInfo(BussType,ActionIDs,UserID)
	s TNo=$p(BussInfo,"^",1)
	s TName=$p(BussInfo,"^",2)
	s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",3))
	;日期格式统一调整
	s TDate=##Class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",4),"date")	;Mozy	2016-11-24
	s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",5))
	s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",6))
	s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",7))
	s TMoveType=$p(BussInfo,"^",8)
	s TOutType=$p(BussInfo,"^",9)
	s TContractNo=$p(BussInfo,"^",10)
	s TBStatus=$p(BussInfo,"^",14)
	s LastHandler=$p(BussInfo,"^",20)  //add by wsp 2016-3-22
	s TLastOperate=$p(BussInfo,"^",21) //add by wsp 2016-4-1 最后一次操作
	s TBStatus=LastHandler_$p(BussInfo,"^",14)  //Modify by zx 2020-11-26 BUG ZX0118
	s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	s SendUserDR=$p(PDataList,"^",9)
	s TSendUser= ##Class(web.DHCEQCommon).GetTrakNameByID("user",SendUserDR)
	s TSendDate=##class(web.DHCEQCommon).TransValueToPage($p(PDataList,"^",10),"date")
	s SendTime=##class(web.DHCEQCommon).TransValueToPage($p(PDataList,"^",11),"time")
	s TSendDate=TSendDate_" "_SendTime
	s TEquipNo=$p(BussInfo,"^",23)  //add by zx 2016-12-13 获取设备编号字段 ZX0036
	s TFileNo=$p(BussInfo,"^",24)
	s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",28),"date")  //add by lmm 355243
	s TPlanEndDate=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",29),"date")  //add by lmm 355243
	s TWaringFlag=+##Class(web.DHCEQPrescription).GetPrescriptionInfo(ApproveType,TBussID) //add by zx 2016-12-28  时效标志 ZX0036
	;s TPrescription=##Class(web.DHCEQPriorityRule).GetPrescriptionAlarm(ApproveType,TBussID,Roles)
	// MZY0124	2654459		2022-05-23
	i TWaringFlag=0 s TBackColor="#90EE90"
	i TWaringFlag=1 s TBackColor="#FFA500"
	i TWaringFlag=2 s TBackColor="#FF4500"
	s TBussType=BussType
	s TMsgID=MsgID
	s TEquipTypeDR=EquipTypeDR
	s TRoles=Roles
	s TBussTypeID=BussTypeID
	s TOriginalFee=$p(BussInfo,"^",31)  //add by wy 2020-8-25 1453205 增加原值串输出
	s TFaultCase=$p(BussInfo,"^",27)
    s TEmergencyFlag=$p(BussInfo,"^",33)
	s TAcceptUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(BussInfo,"^",30))		// Modefied by zc 2022-4-8
	//Modify by zx 2022-09-01 增加紧急标志和申请时间
    s TSeverityFlag=$p(BussInfo,"^",34)
    s TTime=##class(web.DHCEQCommon).TransValueToPage($p(BussInfo,"^",35),"time")
	s TReplacementFlag=$p(ApproveInfo,"^",20)  //回置标志
	q:(KeyWord'="")&&($ZCONVERT(TFaultCase,"U")'[KeyWord )&&($ZCONVERT(TAcceptUser ,"U")'[KeyWord)&&($ZCONVERT(TName ,"U")'[KeyWord)  //add by 2023-3-1 关键字查询3266967
	s TLocationDR =$p($g(^DHCEQMMaintRequest(TBussID)),"^",22)  //add by wy 2023-4-4 3417831 存放地点
	if TLocationDR'="" s TLocation=##Class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
	d OutputRowGetBussDataByCode
	Quit 
ResetVariablesRowGetBussDataByCode
	s (PDataList,SendUserDR,SendTime,BussInfo,ActionIDs,ModelID)=""
    s (TEquipTypeDR,TEquipType,TSendUser,TSendDate,TNo,TName,TRequestLoc,TDate,TUseLoc,TFromLoc,TToLoc,TMoveType,TOutType,TContractNo,TBStatus,TRoles,TActionDesc,TActionCode,TLastOperate,TModel,TEquipNo,TFileNo,TWaringFlag,TGuaranteeFlag,TStartDate,TPlanEndDate,TApproveSetDR,TBussTypeID,TOriginalFee,TFaultCase,TEmergencyFlag,TAcceptUser,TSeverityFlag,TTime,TReplacementFlag,TEquipDR,TLocation)=""
    quit
OutputRowGetBussDataByCode
    Set TRow=TRow+1
    set Data=$lb(TBussType,TBussID,TMsgID,TEquipTypeDR,TEquipType,TSendUser,TSendDate,TNo,TName,TRequestLoc,TDate,TUseLoc,TFromLoc,TToLoc,TMoveType,TOutType,TContractNo,TBStatus,TRow,TRoles,TActionDesc,TActionCode,TLastOperate,TModel,TEquipNo,TFileNo,TWaringFlag,TGuaranteeFlag,TStartDate,TPlanEndDate,TApproveSetDR,TBussTypeID,TOriginalFee,TFaultCase,TEmergencyFlag,TAcceptUser,TSeverityFlag,TTime,TReplacementFlag,TEquipDR,TLocation)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetBussDataByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussDataByCodeExecute ]
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

ClassMethod GetBussDataByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussDataByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZX
/// CreatDate：    2018-010-08
/// Description:   工作台展示信息
/// Input：        GroupID:安全组ID, LocID:科室ID, QXType:权限类型, UserID:用户ID
/// Return：       数据打包成json返回
ClassMethod GetManagementInfo(GroupID, LocID, QXType, UserID As %String = "")
{
	new Job,User,EquipID
	new DataList,EQStatus,EQStockStatus,StoreLocID,EquipTypeID,ABCType,MasterItem,OriginalFee,MaintInfo,MaintFlag,ActionID
	new TotalQty,TotalOriginalFee
	s (TotalQty,TotalOriginalFee)=0
	s Job=$j
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")))
	k ^DHCEQTemp("ManagementMain",UserID)

	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	
	//待办业务信息
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	i RoleIDs'="" s RoleIDs=","_RoleIDs_","
	s BRowID=0
	f  s BRowID=$o(^DHCEQCCode("DHCEQCBussType",BRowID))  quit:BRowID=""  d
	.s (CurBussTypeDR,CurBussCode,CurBussType)=""
	.q:($p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",4)="Y")
	.s CurBussTypeDR=BRowID
	.s CurBussCode=$p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",1)
	.s PreBussCode=$e(CurBussCode,1)
	.i (",1,2,3,4,9,A,"[PreBussCode) s MenuType="Buss"
	.i (",6,7,"[PreBussCode) s MenuType="Warning"
	.i ("8"=PreBussCode) s MenuType="Monitor"
	.i CurBussCode=64 s MenuType="Buss"
	.s CurBussType=$p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",2)
	.s (RRowID,CurFlag,WaitNum)=0
	.f  s RRowID=$o(^DHCEQCCode("DHCEQCRoleBuss",0,"BussType",BRowID,RRowID))  quit:RRowID=""  d
	..i (RoleIDs'="")&&(RoleIDs[(","_$p($g(^DHCEQCCode("DHCEQCRoleBuss",RRowID)),"^",1)_",")) s CurFlag=1
	.q:CurFlag=0
	.i (PreBussCode="6")||(PreBussCode="7")  d
	..i (CurBussCode="71")||(CurBussCode="72-1")||(CurBussCode="72-2")  d
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetMaintAlertNum(+$j,CurBussCode)
	..e  i (CurBussCode="63-1")||(CurBussCode="63-2")||(CurBussCode="63-3")  d
	...s WaitNum=+##Class(web.DHCEQMessages).GetCertificateAlertNum(CurBussCode,+$H)
	..e  i (CurBussCode="73")  d
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetGuaranteeAlertNum(CurBussCode,+$H,UserID,GroupID)
	..e  i (CurBussCode="75")  d
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetContractArriveAlertNum(CurBussCode,+$H,UserID,GroupID)
	..e  i (CurBussCode="76")  d
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetPayPlanAlertNum(CurBussCode,+$H,UserID,GroupID)
	..e  i (CurBussCode="64")  d
	...s WaitNum=+##Class(web.DHCEQMessages).GetRentAlertNum(GroupID,+$H,LocID)
	.e  i PreBussCode="8"  d
	..s WaitNum=+##Class(web.DHCEQMessages).GetMaintMonitorNum(GroupID,CurBussCode,UserID)
	.e  d
	..s WaitNum=+##Class(web.DHCEQMessages).GetBussAertNum(CurBussCode,GroupID,UserID,RoleIDs)
	.s ^DHCEQTemp("ManagementMain",UserID,Job,MenuType,CurBussTypeDR)=CurBussCode_":"_CurBussType_":"_WaitNum
	
	s MenuData=""
	s MenuType=0
	f  s MenuType=$o(^DHCEQTemp("ManagementMain",UserID,Job,MenuType)) quit:MenuType=""  d
	.s CurBussTypeDR=0
	.f  s CurBussTypeDR=$o(^DHCEQTemp("ManagementMain",UserID,Job,MenuType,CurBussTypeDR)) quit:CurBussTypeDR=""  d
	..s OneBussInfo=$g(^DHCEQTemp("ManagementMain",UserID,Job,MenuType,CurBussTypeDR))
	..
	..i MenuData=""  d
	...s MenuData=MenuType_":"_CurBussTypeDR_":"_OneBussInfo
	..e  d
	...s MenuData=MenuData_"^"_MenuType_":"_CurBussTypeDR_":"_OneBussInfo
	
	//资产信息
	s EquipID=0
	f  s EquipID=$o(^DHCEQEquip(EquipID))  quit:EquipID=""  d
	.s (DataList,EQStatus,EQStockStatus,StoreLocID,EquipTypeID,ABCType,MasterItem,OriginalFee,MaintInfo,MaintFlag,ActionID)=""
	.s DataList=$g(^DHCEQEquip(EquipID))
	.q:$p(DataList,"^", 59)="Y" 			//无效标识
	.s EQStatus=$p(DataList,"^", 38) 			//状态
	.q:EQStatus>2
	.s EQStockStatus=$p(DataList,"^", 60) 	//库房状态
	.q:EQStockStatus'=1
	.s StoreLocID=$p(DataList,"^", 67) 		//科室
	.//q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)))
	.s EquipTypeID=$p(DataList,"^", 63) 	//设备类组
	.q:(EquipTypeID'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeID,GroupID))
	.
	.//查看资产总体情况,按照ABC分类来统计
	.s MasterItem=$p(DataList,"^",7)   		//设备项
	.s OriginalFee=$p(DataList,"^", 27) 	//设备原值
	.s TotalQty=TotalQty+1					//设备总数
	.s TotalOriginalFee=TotalOriginalFee+OriginalFee			//设备总金额
	.s ABCType=$p(DataList,"^",2)   		//ABCType
	.i ABCType'="" d
	..s ^DHCEQTemp("ManagementMain",UserID,Job,"ABCTypeQty",ABCType)=$g(^DHCEQTemp("ManagementMain",UserID,Job,"ABCTypeQty",ABCType))+OriginalFee
	.
	.//查看维修情况
	.s MaintInfo=##Class(web.DHCEQMessages).GetOneObjMaintInfo(1,EquipID)
	.i MaintInfo'="" d
	..s MaintFlag=$p(MaintInfo,"^",1)
	..s ActionID=$p(MaintInfo,"^",2)
	..q:ActionID=""
	..i MaintFlag=1  d
	...s ^DHCEQTemp("ManagementMain",UserID,Job,"ActionQty",ActionID)=$g(^DHCEQTemp("ManagementMain",UserID,Job,"ActionQty",ActionID))+1
	
	//进半年内每月资产新增情况及月结情况
	s LastBeginTotalFee=0
	s LastInStockFee=0
	s LastEndTotalFee=TotalOriginalFee
	
	s YearMonthCount=0
	s CurYear=""
	f  s CurYear=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear),-1)  q:(CurYear="")||(YearMonthCount>=5)  d
	.s CurMonth=""
	.f  s CurMonth=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth),-1)  q:(CurMonth="")||(YearMonthCount>=5)  d
	..s YearMonthCount=YearMonthCount+1
	..s BeginTotalFee=0
	..s EndTotalFee=0
	..s InStockFee=0
	..s EquipTypeDR=0
	..f  s EquipTypeDR=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth,EquipTypeDR))  q:EquipTypeDR=""  d
	...q:("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	...s MRLRowID=0
	...f  s MRLRowID=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth,EquipTypeDR,MRLRowID))  q:MRLRowID=""  d
	....s BeginTotalFee=BeginTotalFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",6)+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",13)
	....s EndTotalFee=EndTotalFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",12)+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",19)
	....s InStockFee=InStockFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",7)
	..i YearMonthCount=1 s LastBeginTotalFee=EndTotalFee
	..s ^DHCEQTemp("ManagementMain",UserID,Job,"EmergencyControl",CurYear_"-"_CurMonth)=BeginTotalFee_"-"_InStockFee_"-"_EndTotalFee
	
	s StartDate=$ZDH(##Class(web.DHCEQReport).GetReportDate($E($ZD(+$H,3),1,7),"1","3"),3)
	s EndDate=$ZDH(##Class(web.DHCEQReport).GetReportDate($E($ZD(+$H,3),1,7),"2","3"),3)
	s EquipType=0
	f  s EquipType=$o(^DHCEQInStock(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,GroupID))
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")  d
	...s ISInvalidFlag=$p($g(^DHCEQInStock(rowid)),"^",25)
	...q:ISInvalidFlag="Y"
	...s ISStatus=$p($g(^DHCEQInStock(rowid)),"^",10)
	...q:ISStatus'=2
	...s ISNo=$p($g(^DHCEQInStock(rowid)),"^",14)
	...q:ISNo=""
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQInStockList(0,"InStock",rowid,ListRowID)) q:(ListRowID="")  d
	....s LastInStockFee=LastInStockFee+($p($g(^DHCEQInStockList(ListRowID)),"^",7)*$p($g(^DHCEQInStockList(ListRowID)),"^",8))
	s ^DHCEQTemp("ManagementMain",UserID,Job,"EmergencyControl",$E($ZD(+$H,3),1,4)_"-"_+$E($ZD(+$H,3),6,7))=LastBeginTotalFee_"-"_LastInStockFee_"-"_LastEndTotalFee
	
	
	//维修监控信息
	s MaintMonitorData=""
	s ActionID=0
	f  s ActionID=$o(^DHCEQTemp("ManagementMain",UserID,Job,"ActionQty",ActionID)) quit:ActionID=""  d
	.s ActionQty=+$g(^DHCEQTemp("ManagementMain",UserID,Job,"ActionQty",ActionID))
	.s ActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",2)
	.s ActionCode=$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",1)
	.i MaintMonitorData=""  d
	..s MaintMonitorData=ActionDesc_":"_ActionQty_":"_ActionCode
	.e  d
	..s MaintMonitorData=MaintMonitorData_"^"_ActionDesc_":"_ActionQty_":"_ActionCode
	
	s EmergencyControlData=""
	s YearMonth=""
	f  s YearMonth=$o(^DHCEQTemp("ManagementMain",UserID,Job,"EmergencyControl",YearMonth)) quit:YearMonth=""  d
	.s YearMonthInfo=$g(^DHCEQTemp("ManagementMain",UserID,Job,"EmergencyControl",YearMonth))
	.i EmergencyControlData'="" s EmergencyControlData=EmergencyControlData_"^"
	.s EmergencyControlData=EmergencyControlData_YearMonth_":"_YearMonthInfo
	
	//abc分类信息
	s ABCTypeData=""
	s ABCType=0
	f  s ABCType=$o(^DHCEQTemp("ManagementMain",UserID,Job,"ABCTypeQty",ABCType)) quit:ABCType=""  d
	.s ABCTypeQty=$g(^DHCEQTemp("ManagementMain",UserID,Job,"ABCTypeQty",ABCType))
	.i ABCTypeData=""  d
	..s ABCTypeData=ABCType_"类:"_ABCTypeQty
	.e  d
	..s ABCTypeData=ABCTypeData_"^"_ABCType_"类:"_ABCTypeQty
	
	k ^DHCEQTemp("ManagementMain",UserID)
	
	d Result.%Set("TotalQty",TotalQty)
	d Result.%Set("TotalOriginalFee",TotalOriginalFee)
	d Result.%Set("MaintMonitorData",MaintMonitorData)
	d Result.%Set("EmergencyControlData",EmergencyControlData)
	d Result.%Set("ABCTypeData",ABCTypeData)
	d Result.%Set("MenuData",MenuData)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Result)
}

/// Modified BY ZY0204  把审批的所有操作都记录下来
/// Add by wsp 2016-3-23
/// 根据业务类型和业务ID获取业务审批进度
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetApproveList",31,888)
/// GetApproveInfo名称改为GetApproveList modified by czf
/// Modify by zx 2022-12-01 增加动作代码
Query GetApproveList(BussType, SourceID) As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TApproveType:%String,TApproveDate:%String,TApproveRoleDR:%String,TApproveRole:%String,TApproveUserDR:%String,TApproveUser:%String,TOpinion:%String,TApproveTime:%String,TAction:%String,TTimeInfo:%String,TYear:%String,TOperateType:%String,TActionCode:%String")
{
}

ClassMethod GetApproveListExecute(ByRef qHandle As %Binary, BussType, SourceID) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	//modify by lmm 2020-02-25 1192719 折旧无数据时报错
	s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	i ApproveType="" Quit $$$OK   //add by lmm 2019-08-27 991779
	
	//新增状态不显示历史审批记录Add By DJ 2019-09-19
	s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussType,SourceID)
	s BussStatus=$p(BussInfo,"^",12)
	;i BussStatus=0 Quit $$$OK 
	s TRow=0
	//i ApproveType=13 s SourceID=$p($g(^DHCEQInStockList(SourceID)),"^",1)	//add by csj 20190522	入库与转移审批进度SourceID存放的是主表ID	//modified by CZF0088 2020-03-06 1217619 SourceID为主表ID
	//i ApproveType=14 s SourceID=$p($g(^DHCEQStoreMoveList(SourceID)),"^",1)	//add by csj 20190522	入库与转移审批进度SourceID存放的是主表ID
	s TPreDate=""
	s TPreTime=""
	s rowid=0
	f  s rowid=$O(^DHCEQApproveList(0,"Source",ApproveType,SourceID,rowid)) q:rowid=""  d
	.//q:$P(^DHCEQApproveList(rowid),"^",10)="Y"	///Modified BY ZY0204  把审批的所有操作都记录下来
	.d ResetVariable
	.s TRowID=rowid
	.s TApproveType=$P(^DHCEQCCode("DHCEQCApproveType",ApproveType),"^",2)
	.s TApproveDate=$P(^DHCEQApproveList(rowid),"^",7) ;审批日期		//Modify DJ 2016-04-20
	.i TApproveDate'="" s TYear=$p($zd(TApproveDate,3),"-",1)
	.s TApproveTime=$p($g(^DHCEQApproveList(rowid)),"^",8)   //add by zx 2016-12-27  获取审批时间 ZX0036
	.i TPreDate'="" s TTimeInfo=$p(##Class(web.DHCEQCommon).TimeDiff(TPreDate,TPreTime,TApproveDate,TApproveTime),",",2) 
	.s TPreDate=TApproveDate
	.s TPreTime=TApproveTime
	.///Modified BY ZY0204  把审批的所有操作都记录下来
	.s TOperateType=$p($g(^DHCEQApproveList(rowid)),"^",12)  
	.;s TApproveDate=$ZD(TApproveDate,3)
	.;日期格式统一调整
	.i TApproveDate'="" s TYear=$p($zd(TApproveDate,3),"-",1)		//czf 20181228
	.s TApproveDate=##Class(web.DHCEQCommon).TransValueToPage(TApproveDate,"date")
	.s TApproveRoleDR=$P(^DHCEQApproveList(rowid),"^",5)  ;审批角色
	.i TApproveRoleDR'="" s TApproveRole=$P(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)
	.s TApproveUserDR=$P(^DHCEQApproveList(rowid),"^",6)
	.i TApproveUserDR'="" s TApproveUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TApproveUserDR)
	.s TOpinion=$P(^DHCEQApproveList(rowid),"^",3)
	.;add by wy 2020-3-28 需求1248228 1248520,1247848 begin
	.i TOpinion="" d
	..i TOperateType=0 d
	...s TOpinion="同意(默认)"	
	..e  d
	...s TOpinion="拒绝"  //end
	.s TRow=TRow+1
	.s TApproveTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(rowid)),"^",8),"time") //add by zx 2016-05-11 begin
	.s TActionDR=$p($g(^DHCEQApproveList(rowid)),"^",11)
	.;Mozy	612287	2018-11-30
	.i TActionDR'="" d
	..i TActionDR=0 d
	...s TAction="提交"
	..e  d
	...s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",1)  //Modify by zx 2022-12-01 增加动作代码
	...s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
	.e  d
	..s TAction="审核"
	.i TOperateType=1 s TAction="拒绝"		//czf 1790015 2021-03-05
	.d OutputRowGetApproveInfo
	//add by czf 20191216 begin CZF0050
	s ApproveInfoDR=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,SourceID,0))
	//Modify by zx 2022-11-18 审批进度显示调整
	i ApproveInfoDR'="" d
	.s ApproveSetDR=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",3)
	.s NextStep=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",5)
	.i BussStatus=0 s NextStep="1"  //拒绝回新增状态的时候,默认从第一步开始执行
	.i NextStep'="" d
	..s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,NextStep,""))
	..i AFRowID'="" d
	...d ResetVariable
	...s TRow=TRow+1
	...s TApproveType=$P(^DHCEQCCode("DHCEQCApproveType",ApproveType),"^",2)
	...s TApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",2)
	...s TActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",9)
	...i TActionDR'="" d
	....s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",1)  //Modify by zx 2022-12-01 增加动作代码
	....s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
	...i TApproveRoleDR'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	...s TApproveUser=##Class(web.DHCEQ.Plat.LIBMessages).GetApproveFlowUsers(BussType, SourceID)
	...s TOpinion="待审核"
	...d OutputRowGetApproveInfo
	...d GetNextApproveInfo
	Quit $$$OK
	
GetNextApproveInfo
	//下一步审批流向类型
	q:AFRowID=""
	d ResetVariable
	s GotoType=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",11)
	s LastFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",4)
	i GotoType="0" d
	.s NextStep=+$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",3)+1
	.s NextToFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,NextStep,""))
	e  i GotoType="1" d
	.s NextToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",12)
	e  i GotoType="2" d
	.s NextToFlowDR=""
	.s DefaultNextFlag="N"  //增加DHCEQCApproveFlowAllow中Hold2字段标识为未处理默认进度
	.s NextToApproveDR=0
	.f  s NextToApproveDR=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",0,"SourceFlow","0",AFRowID,NextToApproveDR)) q:(NextToApproveDR="")||(DefaultNextFlag="Y")  d
	..s FlowAllowDR=0
	..f  s FlowAllowDR=$o(^DHCEQCCode("DHCEQCApproveFlowAllow",0,"SourceFlow","0",AFRowID,NextToApproveDR,FlowAllowDR)) q:(FlowAllowDR="")||(DefaultNextFlag="Y")  d
	...s DefaultNextFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlowAllow",FlowAllowDR)),"^",4)
	...i DefaultNextFlag="Y" s NextToFlowDR=NextToApproveDR
	i NextToFlowDR'="" d
	.s TRow=TRow+1
	.s TApproveType=$P(^DHCEQCCode("DHCEQCApproveType",ApproveType),"^",2)
	.s TApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",NextToFlowDR)),"^",2)
	.s TActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",NextToFlowDR)),"^",9)
	.i TActionDR'="" 
	..s TActionCode=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",1)  //Modify by zx 2022-12-01 增加动作代码
	..s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
	.i TApproveRoleDR'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	.s TOpinion="待审核"
	.d OutputRowGetApproveInfo
	;w TApproveRole_"^"_LastFlag,!
	i LastFlag'="Y" d
	.s AFRowID=NextToFlowDR
	.d GetNextApproveInfo
	
	quit
	/*
	s AIStatus=""
	s NextStep=""
	i ApproveInfoDR'=""
	{
		s ApproveSetDR=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",3)
		s NextStep=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",5)
		s AIStatus=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",8)
		s AFLastFlag=""
		s ApproveFlowIDs=""
		s AFStep=0
		f  s AFStep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,AFStep))  q:(AFStep="")||(AFLastFlag="Y")  d
		.s AFRowID=0
		.f  s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,AFStep,AFRowID))  q:(AFRowID="")||(AFLastFlag="Y")  d
		..q:(ApproveFlowIDs'="")&&((ApproveFlowIDs_",")[(","_AFRowID_","))
		..s AFLastFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",4)
		..s NextToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",12)
		..s ApproveFlowIDs=ApproveFlowIDs_","_AFRowID
		..i (AFLastFlag'="Y")&&(NextToFlowDR'="")  d
		...s ApproveFlowIDs=ApproveFlowIDs_","_NextToFlowDR
		s Flag=0
		s CurFlowID=0
		f CurFlowID=2:1:$L(ApproveFlowIDs,",")
		{
			s AFRowID=$p(ApproveFlowIDs,",",CurFlowID)
			s AFStep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",3)
			//Modify by zx 2020-07-10 Bug ZX0097 当前角色时获取当前操作人
			d ResetVariable  //初始化前置
			i NextStep=AFStep d
			.s Flag=1
			.s TApproveUser=##Class(web.DHCEQ.Plat.LIBMessages).GetApproveFlowUsers(BussType, SourceID)
			i Flag=1
			{
				s TRow=TRow+1
				s TApproveType=$P(^DHCEQCCode("DHCEQCApproveType",ApproveType),"^",2)
				s TApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",2)
				s TActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",9)
				i TActionDR'="" s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
				i TApproveRoleDR'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
				s TOpinion="待审核"
				d OutputRowGetApproveInfo
			}
		}
	}
	*/
	//add by czf 20191216 end CZF0050
	/*
 	Set HiddenFlag=##class(web.DHCEQCommon).GetSysInfo("990059")	//add by lmm 2017-09-27 458016
 	i BussType'=31 s HiddenFlag=0	;Mozy	612287	2018-11-30
 	if (HiddenFlag=1)||(HiddenFlag="") //add by lmm 2017-09-27 458016
 	{
		//add by zx 2017-09-05 BUG ZX0045 获取下一步待操作信息
		s TRow=TRow+1 //modify by lmm 2017-09-27 458016
    	s TApproveInfoID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,SourceID,0))
    	i TApproveInfoID'="" d
    	.d ResetVariable
    	.s TApproveSetDR=$p($g(^DHCEQApproveInfo(TApproveInfoID)),"^",3)
    	.s TNextFlowStep=$p($g(^DHCEQApproveInfo(TApproveInfoID)),"^",5)
    	.q:TNextFlowStep=""  //add by zx 2018-11-22 审批完成无下一步
    	.s TApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",TApproveSetDR,TNextFlowStep,0))
    	.i TApproveFlowDR'="" d
    	..s TActionDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowDR),"^",9)
    	..i TActionDR'="" s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
    	.s TApproveDate=""	//modify by lmm 2017-09-27 458016
    	.s TApproveTime=""	//modify by lmm 2017-09-27 458016
    	.s TApproveUser="下一步"
    	.s TOpinion="待处理"
    	.s TApproveType=$P(^DHCEQCCode("DHCEQCApproveType",ApproveType),"^",2)
    	.s TApproveRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlow",TApproveFlowDR),"^",2)  ;审批角色
    	.i TApproveRoleDR'="" s TApproveRole=$P(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)
    	.d OutputRowGetApproveInfo
 	}*/
	
	
ResetVariable
	s (TRowID,TApproveType,TApproveDate,TApproveRoleDR,TApproveRole,TApproveUserDR,TApproveUser,TOpinion,TApproveTime,TActionDR,TAction,TTimeInfo,TYear,TOperateType,TActionCode,NextToFlowDR)=""	// MZY0149	3158567		2023-01-09
	quit
	
OutputRowGetApproveInfo
	set Data=$lb(TRow,TRowID,TApproveType,TApproveDate,TApproveRoleDR,TApproveRole,TApproveUserDR,TApproveUser,TOpinion,TApproveTime,TAction,TTimeInfo,TYear,TOperateType,TActionCode)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetApproveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetApproveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveListExecute ]
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

/// modified by ZY 20221115  3073937  增加工作台数据的筛选
/// add by zy 2015-11-15
/// 描述：根据角色ID和提醒菜单种类取待办业务数据
/// 参数：BussType：业务类型代码
/// 	  RoleIDs：角色ids
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetCertificateData","63-1")
/// hisui改造 modifed by czf 20181019
Query GetCertificateData(BussType As %String = "", AvailableDaysType As %String = "2") As %Query(ROWSPEC = "TBussType:%String,TBussID:%String,TName:%String,TCertificateType:%String,TCertificateNo:%String,TCertificateDept:%String,TCertificateDate:%String,TAvailableDate:%String,TEquipNo:%String,TWarningFlag:%String")
{
}

ClassMethod GetCertificateDataExecute(ByRef qHandle As %Binary, BussType As %String = "", AvailableDaysType) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s GroupID=%session.Get("LOGON.GROUPID")
 	i (GroupID="")||(BussType="") Quit $$$OK
 	i (BussType'="63-1")&&(BussType'="63-2")&&(BussType'="63-3") Quit $$$OK
	s index=1
	if (BussType="63-1") s SourceType="5"		//modified by czf 2020-12-16 1493492 begin
	if (BussType="63-2") s SourceType="5"
	if (BussType="63-3") s SourceType="4"
	s OverDays=30
	i AvailableDaysType=1 s OverDays=0
	e  i AvailableDaysType=3 s OverDays=60
	e  i AvailableDaysType=4 s OverDays=90
	e  i AvailableDaysType=5 s OverDays=120
	
	s TBussType=BussType
	s SourceID=0
	f  s SourceID=$o(^DHCEQCertificateInfo(0,"Source",SourceType,SourceID)) quit:SourceID=""  d
	.i SourceType=5 d
	..s FirmType=""
	..i BussType="63-1" s FirmType=2
	..e  i BussType="63-2" s FirmType=3
	..s FCRowid=""
	..f  s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,SourceID,FCRowid)) q:FCRowid=""  d
	...q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"
	...s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",SourceID)),"^",19)
	...q:InvalidFlag="Y"
	...d GetCertificateInfo
	.e  d
	..d GetCertificateInfo
	
	Quit $$$OK
GetCertificateInfo	
	s rowid=0
	f  s rowid=$o(^DHCEQCertificateInfo(0,"Source",SourceType,SourceID,rowid)) quit:rowid=""  d
	.d ResetVariablesRowGetCertificateData
	.s DataList=$g(^DHCEQCertificateInfo(rowid))
	.s TBussID=rowid
	.q:$p(DataList,"^",10)="Y"
	.i SourceType="5" d
	..s TName=##Class(web.DHCEQCommon).GetTrakNameByID("prov",SourceID)	
	.e  i SourceType="4"  d
	..i SourceID'=""  d
	...s EQRowID=$p($g(^DHCEQMaint(SourceID)),"^",1)
	...i EQRowID'=""  d
	....s TName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	....s TEquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.s TCertificateType=$p(DataList,"^",3)
	.i TCertificateType'="" s TCertificateType=$p($g(^DHCEQCCode("DHCEQCCertificateType",TCertificateType)),"^",2)
	.s TCertificateNo=$p(DataList,"^",4)
	.s TCertificateDept=$p(DataList,"^",6)
	.s TCertificateDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",7),"date")
	.s AvailableDate=$p(DataList,"^",8)
	.i AvailableDate="" s AvailableDate=99999
	.i (AvailableDate<+$H) s WarningFlag=2 ;增加预警标志，用以处理前台背景色 0:不处理，1:预警 2:已到期
	.s NextDate=AvailableDate
	.s CurDate=+$H
	.q:(AvailableDaysType<6)&&(+(NextDate-CurDate)>OverDays)
	.q:(AvailableDaysType=6)&&(+(NextDate-CurDate)<0)
	.s TAvailableDate=##class(web.DHCEQCommon).TransValueToPage(AvailableDate,"date")
	.d OutputRowGetCertificateData
	quit			//modified by czf 2020-12-16 1493492 end
ResetVariablesRowGetCertificateData
	s (DataList,TBussID,TName,TCertificateType,TCertificateNo,TCertificateDept,TCertificateDate,TAvailableDate,TEquipNo,TWarningFlag)=""
	quit
OutputRowGetCertificateData
	set Data=$lb(TBussType,TBussID,TName,TCertificateType,TCertificateNo,TCertificateDept,TCertificateDate,TAvailableDate,TEquipNo,TWarningFlag)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetCertificateDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCertificateDataExecute ]
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

ClassMethod GetCertificateDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCertificateDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetMaintAlertData","72-1")
Query GetMaintAlertData(BussType As %String = "") As %Query(ROWSPEC = "TBussType:%String,TBussID:%String,TEquipID:%String,TName:%String,TEquipNo:%String,TEquipTypeDR:%String,TEquipType:%String,TUseLoc:%String,TLastDate:%String,TNextDate:%String,TMPName:%String,TWarningFlag:%String,TMaintType:%String")
{
}

ClassMethod GetMaintAlertDataExecute(ByRef qHandle As %Binary, BussType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s GroupID=%session.Get("LOGON.GROUPID")
 	i (GroupID="")||(BussType="") Quit $$$OK
 	i (BussType'="71")&&(BussType'="72-1")&&(BussType'="72-2") Quit $$$OK
	s Node=$j
	s index=1
	k ^DHCEQTemp("Msg","Alert",Node)
	d ##Class(web.DHCEQ.Plat.LIBMessages).SetMaintAlertData(Node,BussType)
	s EquipDR=0
	f  s EquipDR=$o(^DHCEQTemp("Msg","Alert",Node,BussType,EquipDR)) q:EquipDR=""   d
	.d ResetVariablesRowGetMaintAlertData
	.s DataList=$g(^DHCEQEquip(EquipDR))
	.s TBussType=BussType
	.s TEquipID=EquipDR
	.q:$p(DataList,"^",38)>"2"
	.q:($p(DataList,"^",60)="0")||($p(DataList,"^",60)>"2")
	.s TEquipTypeDR=$p(DataList,"^",63)
	.;modify by lmm 2019-06-06  begin  过滤简易台账范类设备
	.s TClassFlag=$p(DataList,"^",83)
	.quit:(TEquipTypeDR'="")&&("1"'=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,GroupID,"","1"))&&(TClassFlag="Y")  
	.;modify by lmm 2019-06-06 end
	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	.//quit:("0"=##Class(web.DHCEQCManageLimit).IsInManageLimit("",GroupID,EquipTypeDR,"","",""))
	.s TName=$p(DataList,"^",1)
	.s TEquipNo=$p(DataList,"^",71)
	.s EQModelDR=$p(DataList,"^",3)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",19))
	.s MaintPlanID=0
	.f  s MaintPlanID=$o(^DHCEQTemp("Msg","Alert",Node,BussType,EquipDR,MaintPlanID)) quit:MaintPlanID=""  d
	..s str=##Class(web.DHCEQ.EM.BUSMaintPlan).WarnDaysNum(MaintPlanID,EquipDR)  //modify by lmm 2019-02-17 824947 CZF0134
	..;modify by lmm 2019-05-30 begin 919308
	..s (TLastPlanExeID,TPlanExeStatus)=""
	..s TLastPlanExeID=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanID,""),-1)
	..i TLastPlanExeID'="" d
	...s TPlanExeStatus=$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",6)
	...i TPlanExeStatus=1 s TLastPlanExeID=""
	..q:TPlanExeStatus=1		//执行单已完成
	..q:(TLastPlanExeID="")&&($p(str,"^",1)=0)
	..s equipinfo=""
	..i TLastPlanExeID'="" s equipinfo=##Class(web.DHCEQ.Plat.LIBMessages).GetExeListEquipIds(TLastPlanExeID)
	..q:(equipinfo'="")&&((","_equipinfo_",")'[(","_EquipDR_","))
	..;modify by lmm 2019-05-30 end 919308
	..s TBussID=MaintPlanID
	..s TLastDate=##class(web.DHCEQCommon).TransValueToPage($p(str,"^",2),"date")
	..s TNextDate=##class(web.DHCEQCommon).TransValueToPage($p(str,"^",3),"date")
	..i (+$p(str,"^",3)<+$H) s TWarningFlag=2 ;增加预警标志，用以处理前台背景色 0:不处理，1:预警 2:已到期
	..s TMPName=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",1)
	..s TMaintType=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",9)		//Add By DJ 2017-02-18
	..s MPModelDR=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",5)
	..q:(MPModelDR'="")&&(EQModelDR'=MPModelDR)		//Add By DJ 2017-02-18
	..s MaintTypeDR=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",9)
	..s SourceType=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",3)
	..;modify by jyp 2019-09-01   设备属性相关调整
	..;q:(MaintTypeDR=5)&&((SourceType=1)||(SourceType=2))&&($p(DataList,"^",15)'="Y")   //过滤计量计划中来源为设备分类和设备项的非计量设备 modified by czf  需求号：336771
	..;q:(BussType="72-1")&&($p($g(^DHCEQMaintPlan(MaintPlanID)),"^",18)="Y")&&($p(DataList,"^",15)'="Y")    //过滤台账中的非计量设备  modified by czf 需求号：336771
	..S TComputerFlag=""
	..s TComputerFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(EquipDR)
	..q:(MaintTypeDR=5)&&((SourceType=1)||(SourceType=2))&&(TComputerFlag'="Y")   //过滤计量计划中来源为设备分类和设备项的非计量设备 modified by czf  需求号：336771
	..q:(BussType="72-1")&&($p($g(^DHCEQMaintPlan(MaintPlanID)),"^",18)="Y")&&(TComputerFlag'="Y")    //过滤台账中的非计量设备  modified by czf 需求号：336771
	..d OutputRowGetMaintAlertData
	..s ^DHCEQTemp("Msg","BWDAlert",Node,EquipDR)=""	; MZY0103	2306475		2021-12-06	记录输出设备ID
	k ^DHCEQTemp("Msg","Alert",Node)
	
	// MZY0103	2306475		2021-12-06	保修合同预警设置
	if (BussType="71")
	{
		s tmpCTLID=0
		f  s tmpCTLID=$o(^DHCEQBussWarnDays(0,"SourceType","N",71,"95-1",tmpCTLID)) q:tmpCTLID=""  d
		.q:$p($g(^DHCEQContract($p($g(^DHCEQContractList(tmpCTLID)),"^",1))),"^",24)'=2
		.q:$p($g(^DHCEQContract($p($g(^DHCEQContractList(tmpCTLID)),"^",1))),"^",39)'=1
		.s tmpBWDID=$o(^DHCEQBussWarnDays(0,"SourceType","N",71,"95-1",tmpCTLID,""))
		.q:tmpBWDID=""
		.
		.; 预警检测
		.q:($p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",7)'="")&&(+$H>$p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",7))	;优先结束预警日期
		.q:+$H<($p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",4)-$p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",5))
		.q:($p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",6)'="")&&(+$H>($p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",4)+$p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",6)))
		.q:$D(^DHCEQTemp("Msg","BWDAlert",Node,$p($g(^DHCEQContractList(tmpCTLID)),"^",17)))
		.
		.d ResetVariablesRowGetMaintAlertData
		.s TEquipID=$p($g(^DHCEQContractList(tmpCTLID)),"^",17)
		.s DataList=$g(^DHCEQEquip(TEquipID))
		.s TName=$p(DataList,"^",1)
		.s TEquipNo=$p(DataList,"^",71)
		.s EQModelDR=$p(DataList,"^",3)
		.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",19))
		.s TEquipTypeDR=$p(DataList,"^",63)
		.s TClassFlag=$p(DataList,"^",83)
		.quit:(TEquipTypeDR'="")&&("1"'=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,GroupID,"","1"))&&(TClassFlag="Y")  
		.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		.s TNextDate=$p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",4)
		.s TNextDate=##class(web.DHCEQCommon).TransValueToPage(TNextDate,"date")
		.s TMPName="保修合同:"_$p($g(^DHCEQContract($p($g(^DHCEQContractList(tmpCTLID)),"^",1))),"^",1)_"("_$p($g(^DHCEQContract($p($g(^DHCEQContractList(tmpCTLID)),"^",1))),"^",2)_")"
		.
		.d OutputRowGetMaintAlertData
		k ^DHCEQTemp("Msg","BWDAlert",Node)
	}
	
	Quit $$$OK
ResetVariablesRowGetMaintAlertData
	s (DataList,TBussID,TEquipID,TName,TEquipNo,TEquipTypeDR,TEquipType,TUseLoc,TLastDate,TNextDate,TMPName,TMaintType,TLastPlanExeID,TStatus)=""
	s WarningFlag=""
	quit
OutputRowGetMaintAlertData
	set Data=$lb(TBussType,TBussID,TEquipID,TName,TEquipNo,TEquipTypeDR,TEquipType,TUseLoc,TLastDate,TNextDate,TMPName,TWarningFlag,TMaintType)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMaintAlertDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintAlertDataExecute ]
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

ClassMethod GetMaintAlertDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGetMaintAlertDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2018-11-26
/// 参数说明:GroupID 安全组
/// 		 CurDate：与到期日期比较的日期
/// 			 WarnDaysNum:预警天数(默认30天)
/// 返回值  :Num
/// 工作台保修到期预警数据从台帐获取并且兼顾保修合同
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetGuaranteeAlertNum(73,+$H,72,85)
ClassMethod GetGuaranteeAlertNum(CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30")
{
	new BeginFlag,Num,Status,MonthNum,EquipID,DataList,StartDate,NextDate,rowid,ContractDR
	i (CurBussCode'=73) q 0
	i Date="" s Date=+$H
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s BeginFlag=##class(web.DHCEQCommon).GetSysInfo("990039")	//保修开始计算的时间点	0:验收日期  1:入库日期
	i BeginFlag="" s BeginFlag=1
	
	s Num=0
	s Status=""
	f  s Status=$o(^DHCEQEquip(0,"Guarantee",Status)) quit:(Status="")||(Status>2)  d
	.s MonthNum=""
	.f  s MonthNum=$o(^DHCEQEquip(0,"Guarantee",Status,MonthNum)) quit:MonthNum=""  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"Guarantee",Status,MonthNum,EquipID)) quit:EquipID=""  d
	...s (DataList,StartDate,NextDate)=""
	...s DataList=$g(^DHCEQEquip(EquipID))
	...q:($p(DataList,"^",59)="Y")	;Mozy	914928	2019-7-11
	...q:($p(DataList,"^",60)="0")||($p(DataList,"^",60)>"2")
	...quit:##Class(web.DHCEQCommon).EquipTypeIsIn($p(DataList,"^",63),GroupID)
	...Quit:##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,"",$p(DataList,"^",63),$p(DataList,"^",75),$p(DataList,"^",4),$p(DataList,"^",67),EquipID,$p(DataList,"^",7))
	...
	...s StartDate=$p(DataList,"^",13)	;修正保修开始日期为验收日期
	...i (BeginFlag=1)||(StartDate="") s StartDate=$p(DataList,"^",45)
	...s NextDate=$p(DataList,"^",51)	;修正保修结束日期为GuaranteeEndDate
	...i (NextDate="")&&(MonthNum>0) s NextDate=StartDate+30*MonthNum
	...;Mozy	914928	2019-7-11	不用取旧版保修数据
	...;s rowid=0
	...;f  s rowid=$o(^DHCEQServiceContract(0,"Equip",EquipID,rowid)) quit:rowid=""  d
	...;.s ContractDR=$P(^DHCEQServiceContract(rowid),"^",2)
	...;.i $p($g(^DHCEQContract(ContractDR)),"^",12)>NextDate d	;保修合同业务的保修截止日期
	...;..s LastDate=$p($g(^DHCEQContract(ContractDR)),"^",11)
	...;..s NextDate=$p($g(^DHCEQContract(ContractDR)),"^",12)
	...
	...;增加从保修合同业务获取设备的保修截止日期
	...s rowid=0
	...f  s rowid=$o(^DHCEQContractList(0,"SourceID",4,EquipID,rowid)) quit:rowid=""  d
	....s ContractDR=$P(^DHCEQContractList(rowid),"^",1)
	....q:($p($g(^DHCEQContract(ContractDR)),"^",24)'=2)		;过滤非审核状态合同记录
	....q:($p($g(^DHCEQContract(ContractDR)),"^",39)'=1)		;过滤非保修合同
	....i $p($g(^DHCEQContract(ContractDR)),"^",12)>NextDate d	;保修合同业务的保修截止日期
	.....s LastDate=$p($g(^DHCEQContract(ContractDR)),"^",11)
	.....s NextDate=$p($g(^DHCEQContract(ContractDR)),"^",12)
	...
	...q:NextDate<Date		;保修截止日期已经过期则不显示
	...q:(NextDate-Date)>WarnDaysNum
	...
	...s Num=Num+1
	
	quit Num
}

/// Mozy	2018-11-26
/// 参数：CurBussCode：业务类型代码
/// 			WarnDaysNum:预警天数(默认30天)
/// 工作台保修到期预警数据从台帐获取并且兼顾保修合同
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetGuaranteeData",73,+$h,72,85)
Query GetGuaranteeData(CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30") As %Query(ROWSPEC = "TBussType:%String,TBussID:%String,TEquipID:%String,TName:%String,TEquipTypeDR:%String,TEquipType:%String,TEquipNo:%String,TUseLoc:%String,TBeginDate:%String,TEndDate:%String,TWarningFlag:%String,TFileNo:%String,TContractName:%String,TContractNo:%String,TProvider:%String,TRemark:%String")
{
}

ClassMethod GetGuaranteeDataExecute(ByRef qHandle As %Binary, CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
 	i (CurBussCode'=73) Quit $$$OK
 	i Date="" s Date=+$H
 	i UserID="" s UserID=%session.Get("LOGON.USERID")
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	
	//保修开始计算的时间点	0:验收日期  1:入库日期
	s BeginFlag=##class(web.DHCEQCommon).GetSysInfo("990039")
	i BeginFlag="" s BeginFlag=1
	s BussType=##Class(web.DHCEQFind).GetBussTypeDesc(CurBussCode)
	s Status=""
	f  s Status=$o(^DHCEQEquip(0,"Guarantee",Status)) quit:(Status="")||(Status>2)  d
	.s MonthNum=""
	.f  s MonthNum=$o(^DHCEQEquip(0,"Guarantee",Status,MonthNum)) quit:MonthNum=""  d
	..s EquipDR=0
	..f  s EquipDR=$o(^DHCEQEquip(0,"Guarantee",Status,MonthNum,EquipDR)) quit:EquipDR=""  d
	...d ResetVariablesRowGetGuaranteeData
	...s DataList=$g(^DHCEQEquip(EquipDR))
	...q:($p(DataList,"^",59)="Y")	;Mozy	914928	2019-7-11
	...s EquipID=EquipDR
	...q:($p(DataList,"^",60)="0")||($p(DataList,"^",60)>"2")
	...s EquipTypeDR=$p(DataList,"^",63)
	...q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	...s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	...Quit:(##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,"",$p(DataList,"^",63),$p(DataList,"^",75),$p(DataList,"^",4),$p(DataList,"^",67),EquipID,$p(DataList,"^",7)))
	...s Name=$p(DataList,"^",1)
	...s EquipNo=$p(DataList,"^",71)
	...s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(DataList,"^",19))
	...s BeginDate=$p(DataList,"^",13)	;修正保修开始日期为验收日期
	...i (BeginFlag=1)||(BeginDate="") s BeginDate=$p(DataList,"^",45)
	...s EndDate=$p(DataList,"^",51)	;修正保修结束日期为GuaranteeEndDate
	...i (EndDate="")&&(MonthNum>0) s EndDate=BeginDate+30*MonthNum
	...s FileNo=$p(DataList,"^",85)		;增加档案号
	...s MaxContractDR=0
	...;Mozy	914928	2019-7-11	不用取旧版保修数据
	...;s rowid=0
	...;f  s rowid=$o(^DHCEQServiceContract(0,"Equip",EquipID,rowid))  quit:rowid=""  d
	...;.s ContractDR=$P(^DHCEQServiceContract(rowid),"^",2)
	...;.i $p($g(^DHCEQContract(ContractDR)),"^",12)'<EndDate d	;保修合同业务的保修截止日期		Mozy	2019-5-29
	...;..s MaxContractDR=ContractDR
	...;..s BeginDate=$p($g(^DHCEQContract(MaxContractDR)),"^",11)
	...;..s EndDate=$p($g(^DHCEQContract(MaxContractDR)),"^",12)
	...
	...;增加从保修合同业务获取设备的保修截止日期
	...s rowid=0
	...f  s rowid=$o(^DHCEQContractList(0,"SourceID",4,EquipID,rowid)) quit:rowid=""  d
	....s ContractDR=$P(^DHCEQContractList(rowid),"^",1)
	....q:($p($g(^DHCEQContract(ContractDR)),"^",24)'=2)		;过滤非审核状态合同记录
	....q:($p($g(^DHCEQContract(ContractDR)),"^",39)'=1)		;过滤非保修合同
	....
	....i $p($g(^DHCEQContract(ContractDR)),"^",12)'<EndDate d	;保修合同业务的保修截止日期		Mozy	2019-5-29
	.....s MaxContractDR=ContractDR
	.....s BeginDate=$p($g(^DHCEQContract(MaxContractDR)),"^",11)
	.....s EndDate=$p($g(^DHCEQContract(MaxContractDR)),"^",12)
	...
	...q:EndDate<Date		;保修截止日期已经过期则不显示
	...q:(EndDate-Date)>WarnDaysNum
	...i MaxContractDR>0 d
	....s BussID=MaxContractDR
	....s ContractName=$p($g(^DHCEQContract(MaxContractDR)),"^",1)
	....s ContractNo=$p($g(^DHCEQContract(MaxContractDR)),"^",2)
	....s Provider=##class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQContract(MaxContractDR)),"^",18))
	....s CTRemark=$p($g(^DHCEQContract(MaxContractDR)),"^",25)
	...
	...s BeginDate=##class(web.DHCEQCommon).TransValueToPage(BeginDate,"date")
	...i (EndDate<Date) s WarningFlag=2 ;增加预警标志用以处理前台背景色 0:不处理，1:预警 2:已到期
	...s EndDate=##class(web.DHCEQCommon).TransValueToPage(EndDate,"date")
	...d OutputRowGetGuaranteeData
	Quit $$$OK
ResetVariablesRowGetGuaranteeData
	Set (DataList,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,UseLoc,BeginDate,EndDate,WarningFlag,FileNo,ContractName,ContractNo,Provider,CTRemark)=""
	quit
OutputRowGetGuaranteeData
	Set Data=$lb(BussType,BussID,EquipID,Name,EquipTypeDR,EquipType,EquipNo,UseLoc,BeginDate,EndDate,WarningFlag,FileNo,ContractName,ContractNo,Provider,CTRemark)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetGuaranteeDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGuaranteeDataExecute ]
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

ClassMethod GetGuaranteeDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGuaranteeDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2018-11-26
/// 获取当前采购合同到货记录数
/// 	入参:WarnDaysNum:预警天数(默认30天)
/// 返回值  : Num
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetContractArriveAlertNum(75,+$H,72,85)
ClassMethod GetContractArriveAlertNum(CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30")
{
	new Num,ContractDR,ContractType,CTLRowID,ContractArriveDate,EquipTypeDR
	i (CurBussCode'=75) q 0
	s Num=0
	i Date="" s Date=+$H
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	
	s ContractDR=0
	f  s ContractDR=$o(^DHCEQContract(0,"Status",2,ContractDR)) quit:ContractDR=""  d
	.Set ContractType=$p($g(^DHCEQContract(ContractDR)),"^",39)
	.q:ContractType'=0        //0:采购合同  1：保修合同
	.
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",ContractDR,CTLRowID)) q:CTLRowID=""  d
	..// MZY0072	1798336		2021-04-19
	..s tmpRowID=+$o(^DHCEQBussWarnDays(0,"SourceType","N",CurBussCode,"94-1",CTLRowID, ""))
	..s ContractArriveDate=$p($g(^DHCEQBussWarnDays(tmpRowID)),"^",4)
	..i ContractArriveDate="" s ContractArriveDate = $p($g(^DHCEQContractList(CTLRowID)),"^",10)
	..q:ContractArriveDate=""
	..// MZY0026	1279490		2020-05-22
	..;q:(ContractArriveDate-Date)>WarnDaysNum
	..q:(##Class(web.DHCEQ.Plat.BussWarnDays).BussWarnDayIsIn(CurBussCode,"94-1",CTLRowID))
	..;q:(ContractArriveDate-Date)<(0-WarnDaysNum)
	..;q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	..s Num=Num+1
	
	quit Num
}

/// Mozy	2018-11-26
/// 描述：获取采购合同到货预警记录
/// 参数： CurBussCode: 业务类型代码
/// 		WarnDaysNum:预警天数(默认30天)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetContractArriveData",75,+$H,72,85)
Query GetContractArriveData(CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30") As %Query(ROWSPEC = "TBussType:%String,TBussID:%String,TSourceTypeDesc:%String,TBussDesc:%String,TNo:%String,TProvider:%String,TContractArriveDate:%String,TName:%String,TModel:%String,TManuFactory,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String")
{
}

ClassMethod GetContractArriveDataExecute(ByRef qHandle As %Binary, CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	i (CurBussCode'=75) Quit $$$OK
 	
 	new Num,ContractDR,ContractType,CTLRowID,ContractArriveDate
 	i Date="" s Date=+$H
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s BussType=##Class(web.DHCEQFind).GetBussTypeDesc(CurBussCode)
	
 	s ContractDR=0
	f  s ContractDR=$o(^DHCEQContract(0,"Status",2,ContractDR)) quit:ContractDR=""  d
	.Set ContractType=$p($g(^DHCEQContract(ContractDR)),"^",39)
	.q:ContractType'=0        //0:采购合同  1：保修合同
	.
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",ContractDR,CTLRowID)) q:CTLRowID=""  d
	..d ResetVariablesRowGetContractArriveData
	..// MZY0072	1798336		2021-04-19
	..s tmpRowID=+$o(^DHCEQBussWarnDays(0,"SourceType","N",CurBussCode,"94-1",CTLRowID, ""))
	..s ContractArriveDate=$p($g(^DHCEQBussWarnDays(tmpRowID)),"^",4)
	..i ContractArriveDate="" s ContractArriveDate = $p($g(^DHCEQContractList(CTLRowID)),"^",10)
	..q:ContractArriveDate=""
	..// MZY0026	1279490		2020-05-22
	..q:(##Class(web.DHCEQ.Plat.BussWarnDays).BussWarnDayIsIn(CurBussCode,"94-1",CTLRowID,WarnDaysNum))	// MZY0072	1798336		2021-04-19
	..;q:(ContractArriveDate-Date)>WarnDaysNum
	..;q:(ContractArriveDate-Date)<(0-WarnDaysNum)
	..;q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	..
	..s BussID = CTLRowID
	..s TSourceTypeDR = $p($g(^DHCEQContractList(BussID)),"^",5)
	..s SourceTypeDesc= $CASE(TSourceTypeDR,"1":"计划","2":"招标","3":"设备项","4":"设备","5":"入库明细","6":"配件项","7":"验收后补合同","":"")	// MZY0072	1798336		2021-04-19
	..;s TCommonName = $p($g(^DHCEQContractList(BussID)),"^",2)
	..;s TSourceIDDR = $p($g(^DHCEQContractList(BussID)),"^",17)
	..
	..s BussDesc=$p($g(^DHCEQContract(ContractDR)),"^",1)
	..s BussNo=$p($g(^DHCEQContract(ContractDR)),"^",2)
	..Set ProviderDR=$Piece(^DHCEQContract(ContractDR),"^",18)
	..Set Provider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	..Set ContractArriveDate=##Class(web.DHCEQCommon).TransValueToPage(ContractArriveDate,"date")	;Mozy	884926	2019-5-22
	..s Name = $p($g(^DHCEQContractList(BussID)),"^",2)
	..s ModelDR = $p($g(^DHCEQContractList(BussID)),"^",3)
	..s Model = ##Class(web.DHCEQCommon).GetTrakNameByID("model",ModelDR)
	..s ManuFactoryDR = $p($g(^DHCEQContractList(BussID)),"^",4)
	..s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR)	// MZY0125	2620365		2022-06-08
	..s PriceFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(BussID)),"^",6),"")
	..s QuantityNum = $p($g(^DHCEQContractList(BussID)),"^",7)
	..s TotalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(BussID)),"^",8),"")
	..d OutputRowGetContractArriveData
	
	Quit $$$OK
ResetVariablesRowGetContractArriveData
	Set (BussID,SourceTypeDesc,BussDesc,BussNo,Provider,ContractArriveDate,Name,Model,ManuFactory,PriceFee,QuantityNum,TotalFee)=""
	quit
OutputRowGetContractArriveData
	Set Data=$lb(BussType,BussID,SourceTypeDesc,BussDesc,BussNo,Provider,ContractArriveDate,Name,Model,ManuFactory,PriceFee,QuantityNum,TotalFee)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetContractArriveDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractArriveDataExecute ]
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

ClassMethod GetContractArriveDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractArriveDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2018-12-7	TSourceID为业务主单ID
/// 获取当前计量检查保养设备的数量
/// 入参:WarnDaysNum:预警天数(默认30天)
/// 返回值  : Num
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetPayPlanAlertNum(76,+$H,72,85)
ClassMethod GetPayPlanAlertNum(CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30")
{
	new flag,status,Num,TSourceType,TSourceID,TRowID,PlanPayDate,PayAmount,PayPercent,PayedAmount,clrowid,clItemDR
	i (CurBussCode'=76) q 0
	s Num=0
	i Date="" s Date=+$H
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	
	s TSourceType=0
	f  s TSourceType=$o(^DHCEQPayPlan(0,"Source",TSourceType)) quit:TSourceType=""  d
	.s TSourceID=0
	.f  s TSourceID=$o(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID)) quit:(TSourceID="")  d
	..i TSourceType=2 d
	...s status=$p($g(^DHCEQOpenCheckRequest(TSourceID)),"^",20)
	...s flag=$p($g(^DHCEQOpenCheckRequest(TSourceID)),"^",45)
	...s EquipTypeDR=$p($g(^DHCEQOpenCheckRequest(TSourceID)),"^",2)	;Mozy	884926	2019-5-22
	..e  d
	...s status=$p($g(^DHCEQContract(TSourceID)),"^",24)
	...s flag="N"
	...s clrowid=$o(^DHCEQContractList(0,"Contract",TSourceID,""))		;Mozy	884926	2019-5-22
	...s clItemDR= +$p($g(^DHCEQContractList(clrowid)),"^",18)
	...s EquipTypeDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",clItemDR)),"^",3)
	..
	..q:flag'="N"
	..q:status'=2
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	..
	..s TRowID=0
	..f  s TRowID=$o(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID,TRowID)) quit:(TRowID="")  d
	...;Mozy	884926	2019-5-22
	...s PlanPayDate=$p($g(^DHCEQPayPlan(TRowID)),"^",6)
	...;预警日期区间
	...q:(PlanPayDate-Date)>WarnDaysNum
	...;q:(PlanPayDate-Date)<(0-WarnDaysNum)
	...;Mozy	885601	2019-5-22
	...s PayAmount=$p($g(^DHCEQPayPlan(TRowID)),"^",10)
	...i PayAmount="" d
	....s PayPercent=0.01*$Piece($Get(^DHCEQPayPlan(TRowID)),"^",9)
	....i TSourceType=2 d
	.....s PayAmount=$p($g(^DHCEQOpenCheckList(+$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",TSourceID,0)))),"^",16)*$p($g(^DHCEQOpenCheckList(+$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",TSourceID,0)))),"^",17)*PayPercent
	....e  d
	.....s PayPercent=0.01*$Piece($Get(^DHCEQPayPlan(TRowID)),"^",9)
	.....s PayAmount=$Piece(^DHCEQContract(TSourceID),"^",4)*PayPercent
	...q:PayAmount'>0
	...s PayAmount=##Class(web.DHCEQCommon).FormatNumber(PayAmount,"")
	...;s PayedAmount=##Class(web.DHCEQPayRecord).GetPayOrOnWayAmount(TRowID,2,TSourceID,1)		;已付金额	//旧版付款完成判断
	...;q:PayAmount=PayedAmount
	...s PPAllAmount=$p($g(^DHCEQPayPlan(TRowID)),"^",10)
	...i PPAllAmount="" s PPAllAmount=PayAmount		// MZY0033	1370009		2020-06-15
	...s NPSourceType=11
	...i TSourceType=2 s NPSourceType=13
	...s PayedAmount=+##Class(web.DHCEQ.EM.BUSPayRequest).GetNotPayAmount(NPSourceType,TSourceID,TRowID,PPAllAmount)
	...q:PayedAmount=0
	...
	...s Num=Num+1
	
	quit Num
}

/// Mozy	2018-12-7	TSourceID为业务主单ID
/// 描述：获取计划付款预警记录
/// 参数： CurBussCode 业务类型代码
/// 		WarnDaysNum:预警天数(默认30天)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetPayPlanData",76,+$H,72,85)
Query GetPayPlanData(CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30") As %Query(ROWSPEC = "TBussType:%String,TBussID:%String,TSourceTypeDesc:%String,TBussDesc:%String,TNo:%String,TProvider:%String,TDesc:%String,TPayDate:%String,TPayAmount:%String,TUnPayAmount:%String")
{
}

ClassMethod GetPayPlanDataExecute(ByRef qHandle As %Binary, CurBussCode As %String = "", Date As %String = "", UserID As %String = "", GroupID As %String = "", WarnDaysNum As %String = "30") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i (CurBussCode'=76) Quit $$$OK
	s index=1
	i Date="" s Date=+$H
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s BussType=##Class(web.DHCEQFind).GetBussTypeDesc(CurBussCode)
	
	s SourceType=0
	f  s SourceType=$o(^DHCEQPayPlan(0,"Source",SourceType)) quit:SourceType=""  d
	.s SourceID=0
	.f  s SourceID=$o(^DHCEQPayPlan(0,"Source",SourceType,SourceID)) quit:(SourceID="")  d
	..d ResetVariablesRowGetPayPlanData
	..i SourceType=2 d
	...s SourceTypeDesc="验收单付款"
	...s BussDesc=$p($g(^DHCEQOpenCheckList(+$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",SourceID,0)))),"^",2)
	...s BussNo=$p($g(^DHCEQOpenCheckRequest(SourceID)),"^",37)
	...Set ProviderDR=$Piece(^DHCEQOpenCheckRequest(SourceID),"^",5)
	...s status=$p($g(^DHCEQOpenCheckRequest(SourceID)),"^",20)
	...s flag=$p($g(^DHCEQOpenCheckRequest(SourceID)),"^",45)
	...s EquipTypeDR=$p($g(^DHCEQOpenCheckRequest(SourceID)),"^",2)		;Mozy	884926	2019-5-22
	..e  d
	...s BussDesc=$p($g(^DHCEQContract(SourceID)),"^",1)
	...s SourceTypeDesc="采购合同付款"
	...s BussNo=$p($g(^DHCEQContract(SourceID)),"^",2)
	...Set ProviderDR=$Piece(^DHCEQContract(SourceID),"^",18)
	...i $p($g(^DHCEQContract(SourceID)),"^",39)=1 s SourceTypeDesc="保修合同付款"
	...s status=$p($g(^DHCEQContract(SourceID)),"^",24)
	...s flag="N"
	...s clrowid=$o(^DHCEQContractList(0,"Contract",SourceID,""))		;Mozy	884926	2019-5-22
	...s clItemDR= +$p($g(^DHCEQContractList(clrowid)),"^",18)
	...s EquipTypeDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",clItemDR)),"^",3)
	..
	..q:flag'="N"
	..q:status'=2
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID)
	..Set Provider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	..
	..s RowID=0
	..f  s RowID=$o(^DHCEQPayPlan(0,"Source",SourceType,SourceID,RowID)) quit:(RowID="")  d
	...s BussID=RowID
	...;Mozy	884926	2019-5-22
	...s PlanPayDate=$p($g(^DHCEQPayPlan(RowID)),"^",6)
	...;预警日期区间
	...q:(PlanPayDate-Date)>WarnDaysNum
	...;q:(PlanPayDate-Date)<(0-WarnDaysNum)
	...
	...s Desc=$p($g(^DHCEQPayPlan(RowID)),"^",1)
	...Set PayDate=##Class(web.DHCEQCommon).TransValueToPage(PlanPayDate,"date")	;Mozy	884926	2019-5-22
	...s PayAmount=$p($g(^DHCEQPayPlan(RowID)),"^",10)
	...i PayAmount="" d
	....s PayPercent=0.01*$Piece($Get(^DHCEQPayPlan(RowID)),"^",9)
	....i SourceType=2 d
	.....s PayAmount=$p($g(^DHCEQOpenCheckList(+$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",SourceID,0)))),"^",16)*$p($g(^DHCEQOpenCheckList(+$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",SourceID,0)))),"^",17)*PayPercent
	....e  d
	.....s PayAmount=$Piece(^DHCEQContract(SourceID),"^",4)*PayPercent
	...q:PayAmount'>0
	...s PayAmount=##Class(web.DHCEQCommon).FormatNumber(PayAmount,"")
	...
	...;s PayedAmount=##Class(web.DHCEQPayRecord).GetPayOrOnWayAmount(RowID,2,SourceID,1)		;已付金额 //旧版本已付款金额判断
	...;q:PayAmount=PayedAmount
	...;s UnPayAmount=PayAmount-PayedAmount
	...s PPAllAmount=$p($g(^DHCEQPayPlan(RowID)),"^",10)
	...i PPAllAmount="" s PPAllAmount=PayAmount		// MZY0033	1370009		2020-06-15
	...s NPSourceType=11
	...i SourceType=2 s NPSourceType=13
	...s PayedAmount=+##Class(web.DHCEQ.EM.BUSPayRequest).GetNotPayAmount(NPSourceType,SourceID,RowID,PPAllAmount)
	...q:PayedAmount=0
	...s UnPayAmount=PayedAmount
	...s UnPayAmount=##Class(web.DHCEQCommon).FormatNumber(UnPayAmount,"")
	...d OutputRowGetPayPlanData
	Quit $$$OK
ResetVariablesRowGetPayPlanData
	Set (BussID,SourceTypeDesc,BussDesc,BussNo,Provider,Desc,PayDate,PayAmount,UnPayAmount)=""
	quit
OutputRowGetPayPlanData
	Set Data=$lb(BussType,BussID,SourceTypeDesc,BussDesc,BussNo,Provider,Desc,PayDate,PayAmount,UnPayAmount)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetPayPlanDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayPlanDataExecute ]
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

ClassMethod GetPayPlanDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayPlanDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ////////////////////////////////////////
/// 获取当前安全组用户角色需操作的计量检查保养设备数量
/// 参数说明:Node  临时数据的存贮节点
/// 		 BussType：业务Code
/// 返回值  :Num
/// 利用d ##Class(web.DHCEQMessages).SetMaintAlertData(Node,Type)方法存的预警数据来统计数量
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetMaintAlertNum($j,"71")
ClassMethod GetMaintAlertNum(Node, BussType)
{
	new Num,EquipID,EquipData,MaintPlanID,str,Num
	d ##Class(web.DHCEQ.Plat.LIBMessages).SetMaintAlertData(Node,BussType)
	s Num=0
	s EquipID=0
	f  s EquipID=$o(^DHCEQTemp("Msg","Alert",Node,BussType,EquipID)) q:EquipID=""   d
	.s EquipData=$g(^DHCEQEquip(EquipID))
	.s EQModelDR=$p(EquipData,"^",3)
	.q:$p(EquipData,"^",38)>"2"
	.q:($p(EquipData,"^",60)="0")||($p(EquipData,"^",60)>"2")
	.;modify by lmm 2019-06-06  begin  过滤简易台账范类设备
	.;modify by lmm 2019-08-05
	.s TClassFlag=$p(EquipData,"^",83)
	.quit:($p(EquipData,"^",63)'="")&&("1"'=##Class(web.DHCEQCommon).EquipTypeIsIn($p(EquipData,"^",63),"","","1"))&&(TClassFlag="Y")  
	.;modify by lmm 2019-06-06 end
	.//quit:("0"=##Class(web.DHCEQCManageLimit).IsInManageLimit("",GroupID,$p(EquipData,"^",63),"","",""))
	.s MaintPlanID=0
	.f  s MaintPlanID=$o(^DHCEQTemp("Msg","Alert",Node,BussType,EquipID,MaintPlanID)) quit:MaintPlanID=""  d
	..s MPModelDR=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",5)
	..q:(MPModelDR'="")&&(EQModelDR'=MPModelDR)		//Add By DJ 2017-02-18	
	..s MaintTypeDR=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",9)
	..s SourceType=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",3)
	..q:(MaintTypeDR=5)&&((SourceType=1)||(SourceType=2))&&(##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(EquipID)'="Y")   //过滤计量计划中来源为设备分类和设备项的非计量设备 modified by czf 需求号：336771    //modify by jyp 2019-09-01    设备属性相关调整
	..;q:(MaintTypeDR=5)&&((SourceType=1)||(SourceType=2))&&($p(EquipData,"^",15)'="Y")   //过滤计量计划中来源为设备分类和设备项的非计量设备 modified by czf 需求号：336771
	..s str=##Class(web.DHCEQ.EM.BUSMaintPlan).WarnDaysNum(MaintPlanID,EquipID)  //modify by lmm 2019-02-17 824947 CZF0134
	..;q:$p(str,"^",1)=0
	..;modify by lmm 2019-05-30 begin 919308
	..s (TLastPlanExeID,TPlanExeStatus)=""
	..s TLastPlanExeID=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanID,""),-1)
	..i TLastPlanExeID'="" d
	...s TPlanExeStatus=$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",6)
	...i TPlanExeStatus=1 s TLastPlanExeID=""
	..q:TPlanExeStatus=1		//执行单已完成
	..q:(TLastPlanExeID="")&&($p(str,"^",1)=0)
	..s equipinfo=""
	..i TLastPlanExeID'="" s equipinfo=##Class(web.DHCEQ.Plat.LIBMessages).GetExeListEquipIds(TLastPlanExeID)
	..q:(equipinfo'="")&&((","_equipinfo_",")'[(","_EquipID_","))
	..;modify by lmm 2019-05-30 end 919308
	..q:(BussType="72-1")&&($p($g(^DHCEQMaintPlan(MaintPlanID)),"^",18)="Y")&&($p(EquipData,"^",15)'="Y")  //过滤台账中的计量设备 modified by czf 需求号：336771
	..s Num=Num+1
	..s ^DHCEQTemp("Msg","BWDAlert",Node,EquipID)=""	; MZY0103	2306475		2021-12-06	记录输出设备ID
	k ^DHCEQTemp("Msg","Alert",Node)
	// MZY0103	2306475		2021-12-06	保修合同预警设置
	if (BussType="71")
	{
		s tmpCTLID=0
		f  s tmpCTLID=$o(^DHCEQBussWarnDays(0,"SourceType","N",71,"95-1",tmpCTLID)) q:tmpCTLID=""  d
		.q:$p($g(^DHCEQContract($p($g(^DHCEQContractList(tmpCTLID)),"^",1))),"^",24)'=2
		.q:$p($g(^DHCEQContract($p($g(^DHCEQContractList(tmpCTLID)),"^",1))),"^",39)'=1
		.s tmpBWDID=$o(^DHCEQBussWarnDays(0,"SourceType","N",71,"95-1",tmpCTLID,""))
		.q:tmpBWDID=""
		.; 预警检测
		.q:($p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",7)'="")&&(+$H>$p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",7))	;优先结束预警日期
		.q:+$H<($p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",4)-$p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",5))
		.q:($p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",6)'="")&&(+$H>($p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",4)+$p($g(^DHCEQBussWarnDays(tmpBWDID)),"^",6)))
		.
		.q:$D(^DHCEQTemp("Msg","BWDAlert",Node,$p($g(^DHCEQContractList(tmpCTLID)),"^",17)))
		.
		.s Num=1+Num
		k ^DHCEQTemp("Msg","BWDAlert",Node)
	}
	
	quit Num
}

/// 取当前预警设备的总数量
/// 参数说明:node：临时golable存储的节点
/// 				BussType :1,保养;2,检查
/// 返回值  :""  
///      数据存在golable中:格式如下:^DHCEQTemp("Msg","Alert",node,BussType,EquipID,MaintPlanID)=""
/// w ##Class(web.DHCEQMessages).SetMaintAlertData("20204","71")
ClassMethod SetMaintAlertData(node, BussType)
{
	new SourceType,sourceid,rowid,DataList,Model,EquipID
	
	if (BussType="71") s MaintType="1"
	if ((BussType="72-1")||(BussType="72-2")) s MaintType="2"
	k ^DHCEQTemp("Msg","Alert",node)
	
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"Type",MaintType,rowid)) q:rowid=""  d
	.s DataList=$g(^DHCEQMaintPlan(rowid))
	.q:$p(DataList,"^",26)'="2"			//Add By DJ 2017-02-18
	.q:$p(DataList,"^",36)="Y"
	.s MaintTypeDR=$p(DataList,"^",9)		//Add By DJ 2015-12-28
	.i ((MaintType=2)&&(MaintTypeDR=5)) s BussType="72-1"
	.i ((MaintType=2)&&(MaintTypeDR=4)) s BussType="72-2"
	.s MPEquipIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips(2,rowid)
	.s Count=$l(MPEquipIDs,",")
	.s i=0
	.f i=1:1:Count  d
	..s EquipID=$p(MPEquipIDs,",",i)
	..q:EquipID="" // add by zx 2019-01-11
	..s ^DHCEQTemp("Msg","Alert",node,BussType,EquipID,rowid)=""
	quit ""
}

/// add by zx 2019-02-25 ZX0058
/// 描述:获取工作台代办及预警菜单信息,拆分原有方法,便于各模块异步调用
/// 参数:GroupID：当前登陆安全组id
/// 	  LocID：当前登陆科室id
/// 	  QXType：权限类型
/// 	  UserID：当前用户id
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetMainOfMenu("85","393","","4674")
ClassMethod GetMainOfMenu(GroupID, LocID, QXType, UserID As %String = "")
{
	s Job=$j
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("MainOfMenu",UserID)
	
	//待办业务信息
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	i RoleIDs'="" s RoleIDs=","_RoleIDs_","
	s BRowID=0
	f  s BRowID=$o(^DHCEQCCode("DHCEQCBussType",BRowID))  quit:BRowID=""  d
	.s (CurBussTypeDR,CurBussCode,CurBussType)=""
	.q:($p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",4)="Y")
	.s CurBussTypeDR=BRowID
	.s CurBussCode=$p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",1)
	.s PreBussCode=$e(CurBussCode,1)
	.i (",1,2,3,4,9,A,"[PreBussCode) s MenuType="Buss"
	.e  i (",6,7,"[PreBussCode) s MenuType="Warning"
	.e  i ("8"=PreBussCode) s MenuType="Monitor"
	.i CurBussCode="64" s MenuType="Buss"
	.i CurBussCode="55" s MenuType="Buss"	//czf 2014955 2021-07-04 设备拆分
	.s CurBussType=$p($g(^DHCEQCCode("DHCEQCBussType",BRowID)),"^",2)
	.s (RRowID,CurFlag,WaitNum)=0
	.f  s RRowID=$o(^DHCEQCCode("DHCEQCRoleBuss",0,"BussType",BRowID,RRowID))  quit:RRowID=""  d
	..i (RoleIDs'="")&&(RoleIDs[(","_$p($g(^DHCEQCCode("DHCEQCRoleBuss",RRowID)),"^",1)_",")) s CurFlag=1
	.q:CurFlag=0
	.i (PreBussCode="6")||(PreBussCode="7")  d
	..i (CurBussCode="71")||(CurBussCode="72-1")||(CurBussCode="72-2")  d
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetMaintAlertNum(+$j,CurBussCode)
	..e  i (CurBussCode="63-1")||(CurBussCode="63-2")||(CurBussCode="63-3")  d
	...s WaitNum=+##Class(web.DHCEQMessages).GetCertificateAlertNum(CurBussCode,+$H)
	..e  i (CurBussCode="73")  d
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetGuaranteeAlertNum(CurBussCode,+$H,UserID,GroupID)		;需求: 874484		Mozy	2019-4-20
	..e  i (CurBussCode="75")  d
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetContractArriveAlertNum(CurBussCode,+$H,UserID,GroupID)
	..e  i (CurBussCode="76")  d
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetPayPlanAlertNum(CurBussCode,+$H,UserID,GroupID)
	..e  i (CurBussCode="64")  d
	...///Modefied by zc0087 2020-11-30 租赁代办数量的取值 begin
	...;s WaitNum=+##Class(web.DHCEQMessages).GetRentAlertNum(GroupID,+$H,LocID)
	...s WaitNum=+##Class(web.DHCEQMessages).GetBussAertNum("64",GroupID,UserID,RoleIDs)
	...///Modefied by zc0087 2020-11-30 租赁代办数量的取值 begin
	..e  i (CurBussCode="77") d											    /// add by sjh SJH0046 2021-02-23
	...s WaitNum=+##Class(web.DHCEQ.Plat.LIBMessages).GetOverLimityears()  /// add by sjh SJH0046 2021-02-23
	.e  i PreBussCode="8"  d
	..s WaitNum=+##Class(web.DHCEQMessages).GetMaintMonitorNum(GroupID,CurBussCode,UserID)
	.e  d
	..s WaitNum=+##Class(web.DHCEQMessages).GetBussAertNum(CurBussCode,GroupID,UserID,RoleIDs)
	.s ^DHCEQTemp("MainOfMenu",UserID,Job,MenuType,CurBussTypeDR)=CurBussCode_":"_CurBussType_":"_WaitNum
	
	s MenuData=""
	s MenuType=0
	f  s MenuType=$o(^DHCEQTemp("MainOfMenu",UserID,Job,MenuType)) quit:MenuType=""  d
	.s CurBussTypeDR=0
	.f  s CurBussTypeDR=$o(^DHCEQTemp("MainOfMenu",UserID,Job,MenuType,CurBussTypeDR)) quit:CurBussTypeDR=""  d
	..s OneBussInfo=$g(^DHCEQTemp("MainOfMenu",UserID,Job,MenuType,CurBussTypeDR))
	..
	..i MenuData=""  d
	...s MenuData=MenuType_":"_CurBussTypeDR_":"_OneBussInfo
	..e  d
	...s MenuData=MenuData_"^"_MenuType_":"_CurBussTypeDR_":"_OneBussInfo
	
	q MenuData
}

/// add by sjh SJH0046 2021-02-23
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetOverLimityears()
ClassMethod GetOverLimityears()
{
	s count=0
	s months=0
	s RowID=0
 	f  s RowID=$o(^DHCEQEquip(RowID))  q:RowID=""  d
 	.q:$P($G(^DHCEQEquip(RowID)),"^",59)=""			//czf 2021-06-16 begin 1993529
	.q:$P($G(^DHCEQEquip(RowID)),"^",60)'=1
	.q:$P($G(^DHCEQEquip(RowID)),"^",38)>1
	.q:##class(web.DHCEQCommon).EquipTypeIsIn($P($G(^DHCEQEquip(RowID)),"^",63))	//czf 2021-06-16 end
 	.s EquipData=$g(^DHCEQEquip(RowID))
	.s TTransAssetDate=$p(EquipData,"^",45)	//转资日期
	.s TLimitYearsNum=$p(EquipData,"^",31)	//使用年限
	.i (TTransAssetDate'="")  d
	..s months=##Class(web.DHCEQCommon).DateDiffInt("m",TTransAssetDate,+$H)
	..i (months>=(TLimitYearsNum*12)) d		//czf 2021-06-16
	...s count=count+1 
	q count
}

/// add by zx 2019-02-25 ZX0058
/// 描述:获取维修监控和设备ABC分类,拆分原有方法,便于各模块异步调用
/// 参数:GroupID：当前登陆安全组id
/// 	  LocID：当前登陆科室id
/// 	  QXType：权限类型
/// 	  UserID：当前用户id
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetMainOfEquipRange("85","393","","4674")
ClassMethod GetMainOfEquipRange(GroupID, LocID, QXType, UserID As %String = "")
{
	s Job=$j
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Result=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	k ^DHCEQTemp("MainOfEquipRange",UserID)
	s TotalQty=0
	s TotalOriginalFee=0
	
	s EquipID=0
	f  s EquipID=$o(^DHCEQEquip(EquipID))  quit:EquipID=""  d
	.s (DataList,EQStatus,EQStockStatus,StoreLocID,EquipTypeID,ABCType,MasterItem,OriginalFee,MaintInfo,MaintFlag,ActionID)=""
	.s DataList=$g(^DHCEQEquip(EquipID))
	.q:$p(DataList,"^", 59)="Y" 			//无效标识
	.s EQStatus=$p(DataList,"^", 38) 			//状态
	.q:EQStatus>2
	.s EQStockStatus=$p(DataList,"^", 60) 	//库房状态
	.q:EQStockStatus'=1
	.s StoreLocID=$p(DataList,"^", 67) 		//科室
	.///modified by zy 20190906
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)))
	.s EquipTypeID=$p(DataList,"^", 63) 	//设备类组
	.q:(EquipTypeID'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeID,GroupID))
	.
	.//查看资产总体情况,按照ABC分类来统计
	.s MasterItem=$p(DataList,"^",7)   		//设备项
	.s OriginalFee=$p(DataList,"^", 27) 	//设备原值
	.s TotalQty=TotalQty+1					//设备总数
	.s TotalOriginalFee=TotalOriginalFee+OriginalFee			//设备总金额
	.s ABCType=$p(DataList,"^",2)   		//ABCType
	.i ABCType'="" d
	..s ^DHCEQTemp("MainOfEquipRange",UserID,Job,"ABCTypeQty",ABCType)=$g(^DHCEQTemp("MainOfEquipRange",UserID,Job,"ABCTypeQty",ABCType))+OriginalFee
	.
	.//查看维修情况
	.s MaintInfo=##Class(web.DHCEQMessages).GetOneObjMaintInfo(1,EquipID)
	.i MaintInfo'="" d
	..s MaintFlag=$p(MaintInfo,"^",1)
	..s ActionID=$p(MaintInfo,"^",2)
	..q:ActionID=""
	..i MaintFlag=1  d
	...s ^DHCEQTemp("MainOfEquipRange",UserID,Job,"ActionQty",ActionID)=+$g(^DHCEQTemp("MainOfEquipRange",UserID,Job,"ActionQty",ActionID))+1
	
	//维修监控信息
	s MaintMonitorData=""
	s ActionID=0
	f  s ActionID=$o(^DHCEQTemp("MainOfEquipRange",UserID,Job,"ActionQty",ActionID)) quit:ActionID=""  d
	.s ActionQty=+$g(^DHCEQTemp("MainOfEquipRange",UserID,Job,"ActionQty",ActionID))
	.s ActionDesc=$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",2)
	.
	.i MaintMonitorData=""  d
	..s MaintMonitorData=ActionDesc_":"_ActionQty
	.e  d
	..s MaintMonitorData=MaintMonitorData_"^"_ActionDesc_":"_ActionQty
	
	//abc分类信息
	s ABCTypeData=""
	s ABCType=0
	f  s ABCType=$o(^DHCEQTemp("MainOfEquipRange",UserID,Job,"ABCTypeQty",ABCType)) quit:ABCType=""  d
	.s ABCTypeQty=$g(^DHCEQTemp("MainOfEquipRange",UserID,Job,"ABCTypeQty",ABCType))
	.i ABCTypeData=""  d
	..s ABCTypeData=ABCType_"类:"_ABCTypeQty
	.e  d
	..s ABCTypeData=ABCTypeData_"^"_ABCType_"类:"_ABCTypeQty
	
	k ^DHCEQTemp("ManagementMain",UserID)
	
	d Result.%Set("TotalQty",TotalQty)
	d Result.%Set("TotalOriginalFee",TotalOriginalFee)
	d Result.%Set("MaintMonitorData",MaintMonitorData)
	d Result.%Set("ABCTypeData",ABCTypeData)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Result)
}

/// add by zx 2019-02-25 ZX0058
/// 描述:获取资产近半年原值期初,期末等变动,拆分原有方法,便于各模块异步调用
/// 参数:GroupID：当前登陆安全组id
/// 	  LocID：当前登陆科室id
/// 	  QXType：权限类型
/// 	  UserID：当前用户id
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetMainOfEmergency("85","393","","4674")
ClassMethod GetMainOfEmergency(GroupID, LocID, QXType, UserID As %String = "")
{
	s Job=$j
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("MainOfEmergency",UserID)
	
	//进半年内每月资产新增情况及月结情况
	s LastBeginTotalFee=0
	s LastInStockFee=0
	s LastEndTotalFee=0
	
	s YearMonthCount=0
	s CurYear=""
	f  s CurYear=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear),-1)  q:(CurYear="")||(YearMonthCount>=5)  d
	.s CurMonth=""
	.f  s CurMonth=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth),-1)  q:(CurMonth="")||(YearMonthCount>=5)  d
	..s YearMonthCount=YearMonthCount+1
	..s BeginTotalFee=0
	..s EndTotalFee=0
	..s InStockFee=0
	..s EquipTypeDR=0
	..f  s EquipTypeDR=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth,EquipTypeDR))  q:EquipTypeDR=""  d
	...q:("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID))
	...s MRLRowID=0
	...f  s MRLRowID=$o(^DHCEQMonthReportList(0,"YearMonth",CurYear,CurMonth,EquipTypeDR,MRLRowID))  q:MRLRowID=""  d
	....///modified by zy 20190906
	....s MRLLoc=$P($G(^DHCEQMonthReportList(MRLRowID)),"^",3)
	....q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,MRLLoc,LocID,GroupID)))
	....
	....s BeginTotalFee=BeginTotalFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",6)+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",13)
	....s EndTotalFee=EndTotalFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",12)+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",19)
	....s InStockFee=InStockFee+$P($G(^DHCEQMonthReportList(MRLRowID)),"^",7)
	..i YearMonthCount=1 s LastBeginTotalFee=EndTotalFee
	..i CurMonth<10  d
	...s ^DHCEQTemp("MainOfEmergency",UserID,Job,CurYear_"-0"_CurMonth)=BeginTotalFee_"-"_InStockFee_"-"_EndTotalFee
	..e  d
	...s ^DHCEQTemp("MainOfEmergency",UserID,Job,CurYear_"-"_CurMonth)=BeginTotalFee_"-"_InStockFee_"-"_EndTotalFee
	
	s StartDate=$ZDH(##Class(web.DHCEQReport).GetReportDate($E($ZD(+$H,3),1,7),"1","3"),3)
	s EndDate=$ZDH(##Class(web.DHCEQReport).GetReportDate($E($ZD(+$H,3),1,7),"2","3"),3)
	s EquipType=0
	f  s EquipType=$o(^DHCEQInStock(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,GroupID))
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")  d
	...s ISInvalidFlag=$p($g(^DHCEQInStock(rowid)),"^",25)
	...q:ISInvalidFlag="Y"
	...s ISStatus=$p($g(^DHCEQInStock(rowid)),"^",10)
	...q:ISStatus'=2
	...s ISNo=$p($g(^DHCEQInStock(rowid)),"^",14)
	...q:ISNo=""
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQInStockList(0,"InStock",rowid,ListRowID)) q:(ListRowID="")  d
	....s LastInStockFee=LastInStockFee+($p($g(^DHCEQInStockList(ListRowID)),"^",7)*$p($g(^DHCEQInStockList(ListRowID)),"^",8))
	s LastEndTotalFee=LastBeginTotalFee+LastInStockFee
	s ^DHCEQTemp("MainOfEmergency",UserID,Job,$E($ZD(+$H,3),1,4)_"-"_$E($ZD(+$H,3),6,7))=LastBeginTotalFee_"-"_LastInStockFee_"-"_LastEndTotalFee
	
	s EmergencyControlData=""
	s YearMonth=""
	f  s YearMonth=$o(^DHCEQTemp("MainOfEmergency",UserID,Job,YearMonth)) quit:YearMonth=""  d
	.s YearMonthInfo=$g(^DHCEQTemp("MainOfEmergency",UserID,Job,YearMonth))
	.i EmergencyControlData'="" s EmergencyControlData=EmergencyControlData_"^"
	.s EmergencyControlData=EmergencyControlData_YearMonth_":"_YearMonthInfo
	
	q EmergencyControlData
}

/// add by lmm 2019-05-30
/// 描述：根据计划执行id获取执行设备id串
/// 入参：LastPlanExeID 计划执行id
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetExeListEquipIds(72)
ClassMethod GetExeListEquipIds(LastPlanExeID)
{
	i (LastPlanExeID="") Quit $$$OK
	s equipinfo=""
	s TLastPlanExeListID=0
	f  s TLastPlanExeListID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",LastPlanExeID,TLastPlanExeListID))  quit:TLastPlanExeListID=""  d
	.s TExecuteFlag=""
	.s TExeListEquipID = $p($g(^DHCEQPlanExecuteList(TLastPlanExeListID)),"^",2)
	.s TExecuteFlag = $p($g(^DHCEQPlanExecuteList(TLastPlanExeListID)),"^",4)
	.q:(TExecuteFlag="Y")
	.i equipinfo=""  d
	..s equipinfo=TExeListEquipID
	.e  d
	..s equipinfo=equipinfo_","_TExeListEquipID
	q equipinfo
}

/// Add By QW20200604 BUG:QW0065 处理日期关系
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetDateFilerInfo("5","",EndDate)
ClassMethod GetDateFilerInfo(FilerDatePattern, FilerStartDate, FilerEndDate)
{
	new (FilerDatePattern,FilerStartDate,FilerEndDate)
	if (FilerDatePattern="8") ;指定时间
	{
		s FilerStartDate= ##Class(web.DHCEQCommon).TransValueFromPage(FilerStartDate,"date")
		s FilerEndDate= ##Class(web.DHCEQCommon).TransValueFromPage(FilerEndDate,"date")
		i FilerEndDate="" s FilerEndDate= +$H
	}elseif (FilerDatePattern="2")  ;近3天
	{
		s FilerStartDate= +$H-3
		s FilerEndDate= +$H
	}elseif (FilerDatePattern="3") ;近7天
	{
		s FilerStartDate= +$H-7
		s FilerEndDate= +$H
	}elseif (FilerDatePattern="4") ;近两周
	{
		s FilerStartDate= +$H-14
		s FilerEndDate= +$H
	}elseif (FilerDatePattern="5") ;近1月
	{
		s FilerStartDate= +$H-30
		s FilerEndDate= +$H
	}
	elseif (FilerDatePattern="6") ;超一周
	{
		s FilerEndDate= +$H-7
	}
	elseif (FilerDatePattern="7") ;超一月
	{
		s FilerEndDate= +$H-30
	}
	q FilerStartDate_"^"_FilerEndDate
}

/// Add By QW20200707 BUG:QW0069 根据业务类型获取动作信息
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetActionByBussType("31")
ClassMethod GetActionByBussType(BussType)
{
	if BussType="" q ""
	s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	if (ApproveType="") q ""
	s ApproveTypeID=##class(web.DHCEQApproveList).GetApproveType(ApproveType)
	s ActionInfo=""
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCAction", 0, "SourceType",ApproveTypeID,rowid)) quit:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",5)="Y"  //Add By zc2022-4-8
	.s id=rowid
	.s code=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
	.s text=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)
	.i ActionInfo'="" s ActionInfo=ActionInfo_"&"
	.s ActionInfo=ActionInfo_id_","_code_","_text
	
	q ActionInfo
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetBussMessages","23","","","","N","","","","","","","N","1")
/// Add By QW20200727 BUG:QW0070 获取消息
Query GetBussMessages(vBussTypeDR As %String, vBussNo As %String = "", vStartDate As %String = "", vEndDate As %String = "", vNotSendMessFlag As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "", InvalidMsgFlag As %String = "", CurHospID As %String = "", CurUserID As %String = "", vMessDealFlag As %String = "N", vBussID As %String = "") As %Query(ROWSPEC = "TBussType:%String,TBussNo:%String,TApproveRole:%String,TAction:%String,TMessDealFlag:%String,TMessDealUser:%String,TMessDealDate:%String,TMessDealTime:%String,TSendUser:%String,TSendDate:%String,TSendTime:%String,TMRowID:%String,TBussID:%String,TBussTypeDR:%String") [ SqlProc ]
{
}

ClassMethod GetBussMessagesExecute(ByRef qHandle As %Binary, vBussTypeDR As %String, vBussNo As %String = "", vStartDate As %String = "", vEndDate As %String = "", vNotSendMessFlag As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "", InvalidMsgFlag As %String = "", CurHospID As %String = "", CurUserID As %String = "", vMessDealFlag As %String = "N", vBussID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i vBussTypeDR="" Quit $$$OK
	Set vBussNo=##Class(web.DHCEQCommon).Trim(vBussNo)	;Mozy	2017-2-16	截掉两端空格
	Set vBussNo=$ZCONVERT(vBussNo,"U")
	s BeginDate=0
	s EndDate=+$H
	s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
	i vNotSendMessFlag="N"  d
	.s BeginDate=""
	.s EndDate=""
	s MMType=0
	f  s MMType=$o(^DHCEQMessages(0,"MessageType",MMType))  q:MMType=""  d
	.s MBussID=0
	.f  s MBussID=$o(^DHCEQMessages(0,"MessageType",MMType,vBussTypeDR,MBussID))  q:MBussID=""  d
	..q:(vBussID'="")&&(vBussID'=MBussID)
	..s MRowID=0
	..f  s MRowID=$o(^DHCEQMessages(0,"MessageType",MMType,vBussTypeDR,MBussID,MRowID))  q:MRowID=""  d
	...d ResetVariablesGetBussMessages
	...d GetBussMSGInfo
	...q:TBussInvalidFlag="Y"
	...q:(vBussNo'="")&&($ZCONVERT(TBussNo,"U")'[vBussNo)		;Mozy	2017-2-16	模糊查询
	...
	...s TMRowID=MRowID
	...s TApproveRole=$p($g(^DHCEQMessages(MRowID)),"^",12)
	...i TApproveRole'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRole)),"^",2)
	...i TApproveRole="" s TApproveRole="提交"
	...s TAction=$p($g(^DHCEQMessages(MRowID)),"^",26)
	...i TAction'="" s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TAction)),"^",2)
	...i TAction="" s TAction=TApproveRole_"["_MRowID_"]"
	...i TApproveRole="提交" s TAction="提交"
	...s TSendUser=$p($g(^DHCEQMessages(MRowID)),"^",15)
	...i TSendUser'="" s TSendUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TSendUser)
	...s TSendDate=$p($g(^DHCEQMessages(MRowID)),"^",16)
	...; 需求号:273279	Mozy	2016-10-19
	...q:(BeginDate'="")&&(TSendDate<BeginDate)
	...q:(EndDate'="")&&(TSendDate>EndDate)
	...;i TSendDate'="" s TSendDate=$ZD(TSendDate,3)
	...;日期格式统一调整
	...s TSendDate=##Class(web.DHCEQCommon).TransValueToPage(TSendDate,"date")
	...s TSendTime=$p($g(^DHCEQMessages(MRowID)),"^",17)
	...;日期格式统一调整
	...s TSendTime=##Class(web.DHCEQCommon).TransValueToPage(TSendTime,"time")
	...s TMessDealFlag=$p($g(^DHCEQMessages(MRowID)),"^",21)
	...s TMessDealUser=$p($g(^DHCEQMessages(MRowID)),"^",22)
	...i TMessDealUser'="" s TMessDealUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TMessDealUser)
	...s TMessDealDate=$p($g(^DHCEQMessages(MRowID)),"^",23)
	...q:(vMessDealFlag'="")&&(vMessDealFlag'=TMessDealFlag)
	...;日期格式统一调整
	...s TMessDealDate=##Class(web.DHCEQCommon).TransValueToPage(TMessDealDate,"date")
	...s TMessDealTime=$p($g(^DHCEQMessages(MRowID)),"^",24)
	...;日期格式统一调整
	...s TMessDealTime=##Class(web.DHCEQCommon).TransValueToPage(TMessDealTime,"time")
	...i TMessDealFlag="N" d
	....s MRIRowID=0
	....f  s MRIRowID=$o(^DHCEQMessagesRecInfo(0,"Message",MRowID,MRIRowID))  q:MRIRowID=""  d
	.....s TReceiveUser=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",2)
	.....i TReceiveUser'="" s TReceiveUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TReceiveUser)
	.....;Modified By QW20200819 BUG:QW0074增加消息信息角色串和动作串 begin
	.....s Actions=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",10)
	.....s Roles=$p($g(^DHCEQMessagesRecInfo(MRIRowID)),"^",4)
	.....s ActionLen=$L(Actions,",")
	.....s TReceiveAction=""
    .....f i=1:1:ActionLen  d
    ......s ReceiveAction=$p(Actions,",",i)
    ......s ReceiveRole=$p(Roles,",",i)
	......i ReceiveAction'="" s ReceiveAction=$p($g(^DHCEQCCode("DHCEQCAction",ReceiveAction)),"^",2)
	......i ReceiveRole'="" s ReceiveRole=$P(^DHCEQCCode("DHCEQCApproveRole",ReceiveRole),"^",2)
	......i TReceiveAction'="" s TReceiveAction=TReceiveAction_"&"
	......s TReceiveAction=TReceiveAction_ReceiveRole_"("_ReceiveAction_")"
	.....i TMessDealUser'="" s TMessDealUser=TMessDealUser_","
	.....s TMessDealUser=TMessDealUser_TReceiveUser_":"_TReceiveAction
	.....;Modified By QW20200804 BUG:QW0071增加消息信息角色串和动作串 begin
	.....s TMessDealDate=""
	.....s TMessDealTime=""
	...d OutputRowGetBussMessages
	
	Quit $$$OK
GetBussMSGInfo
	s TBussID=MBussID 
	s TBussTypeDR=vBussTypeDR
	s TBussType=##Class(web.DHCEQFind).GetBussTypeDesc(vBussTypeDR)		
	s TBussInfo=##Class(web.DHCEQMessages).GetBussInfo(vBussTypeDR,MBussID)

	s TBussNo=$p(TBussInfo,"^",1)
	s TBussInvalidFlag=$p(TBussInfo,"^",13)
	s TBussStatus=$p(TBussInfo,"^",12)
	s TBussAuditDate=$p(TBussInfo,"^",22)	
	quit
OutputRowGetBussMessages
	s Data=$lb(TBussType,TBussNo,TApproveRole,TAction,TMessDealFlag,TMessDealUser,TMessDealDate,TMessDealTime,TSendUser,TSendDate,TSendTime,TMRowID,TBussID,TBussTypeDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBussMessages
	s (TBussType,TBussNo,TApproveRole,TAction,TMessDealFlag,TMessDealUser,TMessDealDate,TMessDealTime,TSendUser,TSendDate,TSendTime,TMRowID,TBussID,TBussTypeDR)=""
	quit
}

ClassMethod GetBussMessagesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussMessagesExecute ]
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

ClassMethod GetBussMessagesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussMessagesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述:补发消息
/// 入参:vBussType业务类型, vBussID业务RowID
/// Add By QW20200727 BUG:QW0070 修改补发消息
ClassMethod MessageSendAgain(vBussType As %String = "", vBussID As %String = "")
{
	i ((vBussType="")||(vBussID="")) q "业务类型代码及业务ID不能为空!"
	s MRowID=$o(^DHCEQMessages(0,"MessageType",1,vBussType,vBussID,""),-1)
	i '$D(^DHCEQMessages(MRowID,"EX")) q "该业务单无法进行补发消息处理!"
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
	TSTART
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(vBussType, vBussID, User, ApproveFlowInfo, "N",CurRole,AuditFlag,GroupID,LimitActions,LimitUserDR,LimitLocActions,LimitLocDR)
	i SQLCODE
	{
		TROLLBACK
		q "补发消息失败:"_SQLCODE
	}
	TCOMMIT
	q "补发成功!"
}

/// Author ZX 2020-07-10
/// Description 获取消息表中未处理信息发送给哪些人
/// InPut AFUBussType 业务类型, AFUBussID 业务id
/// OutPut 操作人串
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetApproveFlowUsers("31","1")
ClassMethod GetApproveFlowUsers(AFUBussType, AFUBussID)
{
	//Add By QW20210629 审批人显示限制 BUG:QW0127 begin
	s ApproveLimit=##class(web.DHCEQCommon).GetSysInfo("990085") 
	s ApproveUsers=##class(web.DHCEQCommon).GetSysInfo("990084") 
	s ApproveNum=0
	i +ApproveLimit=9 q ""
	//Add By QW20210629 审批人显示限制 end
	s RstUser=""
	i (AFUBussType="")||(AFUBussID="") q ""
	s AFUMessageID=0
	f  s AFUMessageID=$o(^DHCEQMessages(0,"MessageType","1",AFUBussType,AFUBussID,AFUMessageID)) q:AFUMessageID=""  d
	.q:$p($g(^DHCEQMessages(AFUMessageID)),"^",21)="Y"
	.s AFUMessageRecInfoID=0
	.f  s AFUMessageRecInfoID=$o(^DHCEQMessagesRecInfo(0,"Message",AFUMessageID,AFUMessageRecInfoID)) q:AFUMessageRecInfoID=""  d
	..s MsgAcceptUserDR=$p($g(^DHCEQMessagesRecInfo(AFUMessageRecInfoID)),"^",2)
	..q:MsgAcceptUserDR=""
	..;Add By QW20210629 BUG:QW0127 审批人显示限制 begin
	..s ApproveUser=MsgAcceptUserDR
	..q:(ApproveUsers'="")&&((","_ApproveUsers_",")'[(","_ApproveUser_","))
	..i (0<+ApproveLimit) d
	...q:((ApproveLimit-ApproveNum)=0)
	...s ApproveNum=ApproveNum+1
	...i RstUser'="" s RstUser=RstUser_","
	...s RstUser=RstUser_##Class(web.DHCEQCommon).GetTrakNameByID("user", MsgAcceptUserDR)
	..e  d
	...i RstUser'="" s RstUser=RstUser_","
	...s RstUser=RstUser_##Class(web.DHCEQCommon).GetTrakNameByID("user", MsgAcceptUserDR)
	..;Add By QW20210629 审批人显示限制 end
	
	q RstUser
}

/// Author ZX 2020-07-10
/// Description 根据人员获取当前人参与业务单据
/// InPut ParamBussType 业务类型 , ParamStartDate 处理业务开始日期, ParamEndDate 处理业务结束日期, ParamUser 参与人
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetDetailByMessages","34","2019-12-01","2019-12-27","647")
Query GetDetailByMessages(ParamBussType As %String = "", ParamStartDate As %String = "", ParamEndDate As %String = "", ParamUser As %String = "") As %Query(ROWSPEC = "TBussID:%String,TBussType:%String,TBussNo:%String,TBussStatus:%String,TEquipName:%String,TDate:%String,TUseLoc:%String,TLastOperate:%String,TRequestUser:%String")
{
}

ClassMethod GetDetailByMessagesExecute(ByRef qHandle As %Binary, ParamBussType As %String = "", ParamStartDate As %String = "", ParamEndDate As %String = "", ParamUser As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	i ParamBussType="" Quit $$$OK
	i ((ParamStartDate="")&&(ParamEndDate=""))	Quit $$$OK
	i ParamUser="" s ParamUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(ParamStartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(ParamEndDate,"date")
	
	s MessageBussID=0
	;默认MessageType为"1",只取业务消息
	;Modify by zx 2021-05-07 循环输出导致同一个同一单据出现多条 BUG ZX0132
	f  s MessageBussID=$o(^DHCEQMessages(0,"MessageType","1",ParamBussType,MessageBussID))  q:MessageBussID=""  d
	.s Flag=0
	.s MessageRowID=0
	.f  s MessageRowID=$o(^DHCEQMessages(0,"MessageType","1",ParamBussType,MessageBussID,MessageRowID))  q:MessageRowID=""  d
	..s TApproveRole=$p($g(^DHCEQMessages(MessageRowID)),"^",12)
	..;s Flag=0
	..;当角色为空时,表示提交单据,要判断提交人和提交时间
	..i TApproveRole="" d
	...s SendUser=$p($g(^DHCEQMessages(MessageRowID)),"^",15)
	...q:(ParamUser'="")&&(ParamUser'=SendUser)
	...s SendDate=$p($g(^DHCEQMessages(MessageRowID)),"^",16)
	...q:(BeginDate'="")&&(SendDate<BeginDate)
	...q:(EndDate'="")&&(SendDate>EndDate)
	...s Flag=Flag+1
	..;提交信息不符合,判断处理人和处理时间
	..i Flag=0 d
	...s DealUser=$p($g(^DHCEQMessages(MessageRowID)),"^",22)
	...q:(ParamUser'="")&&(ParamUser'=DealUser)
	...s DealDate=$p($g(^DHCEQMessages(MessageRowID)),"^",23)
	...q:(BeginDate'="")&&(DealDate<BeginDate)
	...q:(EndDate'="")&&(DealDate>EndDate)
	...s Flag=Flag+1
	.q:Flag=0
	.d ResetVariablesGetDetailByMessages
	.s TBussType=##Class(web.DHCEQFind).GetBussTypeDesc(ParamBussType)		
	.s TBussInfo=##Class(web.DHCEQMessages).GetBussInfo(ParamBussType,MessageBussID)
	.s TBussID=MessageBussID
	.s TBussNo=$p(TBussInfo,"^",1)
	.s TBussInvalidFlag=$p(TBussInfo,"^",13)
	.q:TBussInvalidFlag="Y"
	.s TBussStatus=$p(TBussInfo,"^",12)
	.s TEquipName=$p(TBussInfo,"^",2)
	.s TDate=##Class(web.DHCEQCommon).TransValueToPage($p(TBussInfo,"^",4),"date")
	.s TUseLoc=$p(TBussInfo,"^",5)
	.i TUseLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	.s TLastOperate=$p(TBussInfo,"^",21)
	.s TRequestUser=$p(TBussInfo,"^",26)
	.i TRequestUser'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUser)
	.d OutputRowGetDetailByMessages
	
	Quit $$$OK
OutputRowGetDetailByMessages
	s Data=$lb(TBussID,TBussType,TBussNo,TBussStatus,TEquipName,TDate,TUseLoc,TLastOperate,TRequestUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDetailByMessages
	s (TBussID,TBussType,TBussInfo,TBussNo,TBussInvalidFlag,TBussStatus,TEquipName,TDate,TUseLoc,TLastOperate,TRequestUser)=""
	quit
}

ClassMethod GetDetailByMessagesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailByMessagesExecute ]
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

ClassMethod GetDetailByMessagesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailByMessagesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by sjh SJH0046 2021-02-23
/// TRowID,TEquip,TNo,TUseLoc,TModel,TUnit,TEquipType,TStatCat,TEquipCat,TOriginalFee,TProvider,TransAssetDate,TLimitYearsNum
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetOverYearLimitEquip") 
Query GetOverYearLimitEquip() As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TNo:%String,TUseLoc:%String,TModel:%String,TUnit:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TOriginalFee:%String,TProvider:%String,TTransAssetDate:%String,TLimitYearsNum:%String") [ SqlProc ]
{
}

ClassMethod GetOverYearLimitEquipExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s months=0
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d ResetVariablesGetOverYearLimitEquip
 	.q:$P($G(^DHCEQEquip(rowid)),"^",59)=""			//czf 2021-06-16 begin 1993529
	.q:$P($G(^DHCEQEquip(rowid)),"^",60)'=1
	.q:$P($G(^DHCEQEquip(rowid)),"^",38)>1
	.q:##class(web.DHCEQCommon).EquipTypeIsIn($P($G(^DHCEQEquip(rowid)),"^",63))	//czf 2021-06-16 end
	.s TRowID = rowid
	.s TEquip = $P($G(^DHCEQEquip(rowid)),"^",1)
	.s TNo = $P($G(^DHCEQEquip(rowid)),"^",71)
	.s TUseLocDR = $P($G(^DHCEQEquip(rowid)),"^",19)
	.i TUseLocDR'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TModelDR = $P($G(^DHCEQEquip(rowid)),"^",3)
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TUnitDR = $P($G(^DHCEQEquip(rowid)),"^",5)
	.i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TEquipTypeDR = $P($G(^DHCEQEquip(rowid)),"^",63)
	.i TEquipTypeDR'="" s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TStatCatDR = $P($G(^DHCEQEquip(rowid)),"^",75)
	.i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.s TEquipCatDR = $P($G(^DHCEQEquip(rowid)),"^",4)
	.i TEquipCatDR'="" s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	.s TOriginalFee = $P($G(^DHCEQEquip(rowid)),"^",27)
	.s TProviderDR = $P($G(^DHCEQEquip(rowid)),"^",25)
	.i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TTransAssetDate = $p($g(^DHCEQEquip(rowid)),"^",45) ; ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")
	.q:TTransAssetDate=""
	.s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")	// MZY0103	2306499		2021-12-06
	.s TLimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	.s months=##Class(web.DHCEQCommon).DateDiffInt("m",$p($g(^DHCEQEquip(rowid)),"^",45),+$H)
	.q:(months<(TLimitYearsNum*12))
	.d OutputRowGetOverYearLimitEquip
	
	Quit $$$OK
OutputRowGetOverYearLimitEquip
	s Data=$lb(TRowID,TEquip,TNo,TUseLoc,TModel,TUnit,TEquipType,TStatCat,TEquipCat,TOriginalFee,TProvider,TTransAssetDate,TLimitYearsNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOverYearLimitEquip
	s (TRowID,TEquip,TNo,TUseLoc,TModel,TUnit,TEquipType,TStatCat,TEquipCat,TOriginalFee,TProvider,TTransAssetDate,TLimitYearsNum)=""
	quit
}

ClassMethod GetOverYearLimitEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOverYearLimitEquipExecute ]
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

ClassMethod GetOverYearLimitEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOverYearLimitEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by zx 2021-05-10 Bug ZX0134
/// Desc 移动端获取待提交单据列表
/// Input GroupID:安全组id,  UserID:用户id
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetForSubmitBuss","2","14","","","4","","","","","","")
Query GetForSubmitBuss(GroupID As %String = "", UserID As %String = "") As %Query(ROWSPEC = "TAddUserID:%String,TAddUser:%String,TBussType:%String,TBussTypeDesc:%String,TBussID:%String,TRequestNo:%String,TAddDate:%String,TEquipName:%String,TEquipNo:%String")
{
}

ClassMethod GetForSubmitBussExecute(ByRef qHandle As %Binary, GroupID As %String = "", UserID As %String = "") As %Status
{

	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	i UserID="" Quit $$$OK
	s BussCode = ##class(web.DHCEQWChatUser).GetBussCodeByGroup(GroupID)
	i BussCode="" Quit $$$OK
	
	//维修
	i (","_BussCode_",")[(",31,") d
	.s MRRowID=0
	.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Status","0",MRRowID)) q:MRRowID=""  d
	..q:$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)'="N"  //无效标志
	..d ResetVariablesGetForSubmitBuss
	..s TAddUserID=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",42)
	..q:UserID'=TAddUserID
	..s TAddUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TAddUserID)
	..s TBussType="31"
	..s TBussTypeDesc="维修单"
	..s TBussID=MRRowID
	..s TRequestNo=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",1)
	..s TAddDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",43)
	..s TAddDate=##Class(web.DHCEQCommon).TransValueToPage(TAddDate,"date")
	..s TExObjDR=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",5)
	..i TExObjDR'="" d
	...s TEquipID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
	...i TEquipID'="" d
	....s TEquipName=$Piece($Get(^DHCEQEquip(TEquipID)),"^",1)
	....s TEquipNo=$Piece($Get(^DHCEQEquip(TEquipID)),"^",71)
	....d OutputRowGetForSubmitBuss
	
	//报废
	i (","_BussCode_",")[(",34,") d
	.s DRRowID=0
	.f  s DRRowID=$o(^DHCEQDisuseRequest(0,"Status","0",DRRowID)) q:DRRowID=""  d
	..q:$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)'="N"  //无效标志
	..d ResetVariablesGetForSubmitBuss
	..s TAddUserID=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",11)
	..q:UserID'=TAddUserID
	..s TAddUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TAddUserID)
	..s TBussType="34"
	..s TBussTypeDesc="报废单"
	..s TBussID=DRRowID
	..s TRequestNo=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",33)
	..s TAddDate=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",12)
	..s TAddDate=##Class(web.DHCEQCommon).TransValueToPage(TAddDate,"date")
	..s EquipIDs=+##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(DRRowID)
	..s MultStr=""
	..i $l(MultStr,",")>1 s MultStr="..."
	..s TEquipID=$p(EquipIDs,",",1)
	..i TEquipID'="" d
	...s TEquipName=$Piece($Get(^DHCEQEquip(TEquipID)),"^",1)_MultStr
	...s TEquipNo=$Piece($Get(^DHCEQEquip(TEquipID)),"^",71)_MultStr
	...d OutputRowGetForSubmitBuss
	
	//转移
	i (","_BussCode_",")[(",22,") d
	.s FromLocDR=0
	.f  s FromLocDR=$o(^DHCEQStoreMove(0,"StatusFromLoc","0",FromLocDR)) q:FromLocDR=""  d
	..s SMRowID=0
	..f  s SMRowID=$o(^DHCEQStoreMove(0,"StatusFromLoc","0",FromLocDR,SMRowID)) q:SMRowID=""  d
	...q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"  //无效标志
	...d ResetVariablesGetForSubmitBuss
	...s TAddUserID=$p($g(^DHCEQStoreMove(SMRowID)),"^",4)
	...q:UserID'=TAddUserID
	...s TAddUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TAddUserID)
	...s TBussType="22"
	...s TBussTypeDesc="转移单"
	...s TBussID=SMRowID
	...s TRequestNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	...s TAddDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
	...s TAddDate=##Class(web.DHCEQCommon).TransValueToPage(TAddDate,"date")
	...s TBussIDList=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,0))
	...s EquipIDs=^DHCEQStoreMoveList(TBussIDList,"EX","RowIDs")
	...s MultStr=""
	...i $l(MultStr,",")>1 s MultStr="..."
	...s TEquipID=$p(EquipIDs,",",1)
	...i TEquipID'="" d
	....s TEquipName=$Piece($Get(^DHCEQEquip(TEquipID)),"^",1)_MultStr
	....s TEquipNo=$Piece($Get(^DHCEQEquip(TEquipID)),"^",71)_MultStr
	....d OutputRowGetForSubmitBuss
	
	Quit $$$OK
	
OutputRowGetForSubmitBuss
	s Data=$lb(TAddUserID,TAddUser,TBussType,TBussTypeDesc,TBussID,TRequestNo,TAddDate,TEquipName,TEquipNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetForSubmitBuss
	s (TAddUserID,TAddUser,TBussType,TBussTypeDesc,TBussID,TRequestNo,TAddDate,TBussIDList,EquipIDs,TEquipID,TEquipName,TEquipNo)=""
	quit
}

ClassMethod GetForSubmitBussFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetForSubmitBussExecute ]
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

ClassMethod GetForSubmitBussClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetForSubmitBussExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by zx 2021-10-13
/// Desc 获取可登录安全组人员清单信息
/// Input ParamGroupID:安全组id, ParamLocID:登录科室ID, ParamUserID:用户id, ParamJob:进程号
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","UseLocManageUser","85","","1")
Query UseLocManageUser(ParamGroupID As %String = "", ParamLocID As %String = "", ParamUserID As %String = "", ParamJob As %String = "") As %Query(ROWSPEC = "TUserID:%String,TUserCode:%String,TUserName:%String,TUserGroupDR:%String,TGroupLocDR:%String,TLocName:%String,TBeginDate:%String,TEndDate:%String")
{
}

ClassMethod UseLocManageUserExecute(ByRef qHandle As %Binary, ParamGroupID As %String = "", ParamLocID As %String = "", ParamUserID As %String = "", ParamJob As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	Do ##Class(web.DHCEQCommon).KillTempGlobal("UseLocManageUser")
	s GNum=1
	i ParamJob="" s ParamJob=$Job
	
	s UserID=0
	f  s UserID=$o(^SSU("SSUSR",UserID))  q:UserID=""  d
	.s TUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",UserID)
	.q:TUserID=""
	.d ResetVariablesUseLocManageUser
	.q:(ParamUserID'="")&&(ParamUserID'=TUserID)
	.s TUserGroupDR=$p($g(^SSU("SSUSR",UserID)),"^",5)
	.s TGroupLocDR=$p($g(^SSU("SSUSR",UserID)),"^",4)
	.s TGroupLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",TGroupLocDR)
	.q:TGroupLocDR=""
	.s FindFlag=1
	.i (ParamGroupID'="")&&(ParamGroupID'=TUserGroupDR) s FindFlag=0
	.i (ParamLocID'="")&&(ParamLocID'=TGroupLocDR) s FindFlag=0
	.i FindFlag'=0 d
	..s TBeginDate=$p($g(^SSU("SSUSR",UserID)),"^",96)
	..s TEndDate=$p($g(^SSU("SSUSR",UserID)),"^",97)
	..d GetUseLocManageUser
	.s chl=0
	.f  s chl=$O(^SSU("SSUSR",UserID,"OTHLL",chl)) q:(chl="")  d
	..d ResetVariablesUseLocManageUser
	..s TUserGroupDR=$P(^SSU("SSUSR",UserID,"OTHLL",chl),"^",2)
	..s TGroupLocDR=$P(^SSU("SSUSR",UserID,"OTHLL",chl),"^",1)
	..s TGroupLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",TGroupLocDR)
	..q:TGroupLocDR=""
	..q:(ParamGroupID'="")&&(ParamGroupID'=TUserGroupDR)
	..q:(ParamLocID'="")&&(ParamLocID'=TGroupLocDR)
	..s TBeginDate=$P(^SSU("SSUSR",UserID,"OTHLL",chl),"^",4)
	..s TEndDate=$P(^SSU("SSUSR",UserID,"OTHLL",chl),"^",5)
	..d GetUseLocManageUser
	
	Quit $$$OK

GetUseLocManageUser
	s TUserCode=$p($g(^DHCEQCCode("DHCEQCUser",TUserID)),"^",1)
	s TUserName=$p($g(^DHCEQCCode("DHCEQCUser",TUserID)),"^",4)
	s TLocName=$p($g(^DHCEQCCode("DHCEQCDepartment",TGroupLocDR)),"^",2)
	s TBeginDate=##class(web.DHCEQCommon).TransValueToPage(TBeginDate,"date")
	s TEndDate=##class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")
	d OutputRowUseLocManageUser
	quit
	
OutputRowUseLocManageUser
	s Data=$lb(TUserID,TUserCode,TUserName,TUserGroupDR,TGroupLocDR,TLocName,TBeginDate,TEndDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^DHCEQTemp("UseLocManageUser",+$H,ParamJob,GNum)=TUserID_"^"_TUserCode_"^"_TUserName_"^"_TUserGroupDR_"^"_TGroupLocDR_"^"_TLocName_"^"_TBeginDate_"^"_TEndDate
	s GNum=GNum+1
	quit
ResetVariablesUseLocManageUser
	s (TUserCode,TUserName,TUserGroupDR,TGroupLocDR,TLocName,TBeginDate,TEndDate)=""
	quit
}

ClassMethod UseLocManageUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UseLocManageUserExecute ]
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

ClassMethod UseLocManageUserFetchClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UseLocManageUserFetchExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by czf 2021-06-26 begin
/// 获取业务审批信息
/// Input:	BussType:业务类型(11:开箱验收 21:入库、22:转移 23:减少 31:维修 34报废 55设备拆分 91采购申请 92采购计划 93采购招标 94采购合同)
/// 		vBussNo:业务单号
/// 		Status:单据状态 
/// 		RequestDateFrom:申请单开始日期
/// 		RequestDateTo:申请单结束日期
/// 		AuditDateFrom:审批开始日期
/// 		AuditDateTo:审批结束日期
/// 		QXType:0(按审批明细显示)，1(按单据显示)
/// 		BussTypeIDs:业务类型ID串，按配置筛选要显示的业务类型
/// 		APPStatus:审批状态(0:已审批,1:最近审批,2:待审批)
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetBussApproveList","","BF2021060003","1","","","","","12456","","","","0","11,21,22,23,31,34","")
Query GetBussApproveList(BussType As %String = "", vBussNo As %String = "", Status As %String = "", RequestDateFrom As %String = "", RequestDateTo As %String = "", AuditDateFrom As %String = "", AuditDateTo As %String = "", EJob As %String = "", vApproveUser As %String = "", vApproveRoleDR As %String = "", vApproveActionDR As %String = "", QXType As %String = "", BussTypeIDs As %String = "", APPStatus As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TApproveType:%String,TBussType:%String,TBussID:%String,TBussNo:%String,TStatusDesc:%String,TRequestDate:%String,TAuditDate:%String,TName:%String,TRequestLoc:%String,TAppTypeDesc:%String,TUseLoc:%String,TFromLoc:%String,TToLoc:%String,TOutType:%String,TApproveDate:%String,TApproveTime:%String,TApproveRole:%String,TApproveUser:%String,TOpinion:%String,TAction:%String,TOperateType:%String,TKindFlag:%String,TAppStatus:%String,TNextRole:%String,TRecentDateTime:%String,TRecentUser:%String,TRecentRole:%String,TRecentAction:%String,TRecentOpinion:%String")
{
}

ClassMethod GetBussApproveListExecute(ByRef qHandle As %Binary, BussType As %String = "", vBussNo As %String = "", Status As %String = "", RequestDateFrom As %String = "", RequestDateTo As %String = "", AuditDateFrom As %String = "", AuditDateTo As %String = "", EJob As %String = "", vApproveUser As %String = "", vApproveRoleDR As %String = "", vApproveActionDR As %String = "", QXType As %String = "", BussTypeIDs As %String = "", APPStatus As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Do ##Class(web.DHCEQCommon).KillTempGlobal("BussApproveList")
	s index=1
	s CurUserID=1	//##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	i RequestDateFrom="" s RequestDateFrom=0
	e  s RequestDateFrom=##Class(web.DHCEQCommon).TransValueFromPage(RequestDateFrom,"date")
	i RequestDateTo="" s RequestDateTo=+$h
	e  s RequestDateTo=##Class(web.DHCEQCommon).TransValueFromPage(RequestDateTo,"date")
	i AuditDateFrom="" s AuditDateFrom=0
	e  s AuditDateFrom=##Class(web.DHCEQCommon).TransValueFromPage(AuditDateFrom,"date")
	i AuditDateTo="" s AuditDateTo=+$h
	e  s AuditDateTo=##Class(web.DHCEQCommon).TransValueFromPage(AuditDateTo,"date")
	/*
	s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussType,SourceID)
	s BussStatus=$p(BussInfo,"^",12)
	i BussStatus=0 Quit $$$OK	//新增状态不显示历史审批记录
	*/
	s TRow=0
	s TPreDate=""
	s TPreTime=""
	s TApproveType=0
	f  s TApproveType=$O(^DHCEQApproveList(0,"Source",TApproveType))  q:TApproveType=""  d
	.q:(ApproveType'="")&&(ApproveType'=TApproveType)
	.s TBussType=##Class(web.DHCEQMessages).GetBussTypeByApproveType(TApproveType)
	.q:(BussTypeIDs'="")&&((","_BussTypeIDs_",")'[(","_TBussType_","))
	.s TSourceID=0
	.f  s TSourceID=$O(^DHCEQApproveList(0,"Source",TApproveType,TSourceID)) q:TSourceID=""  d
	..d GetBussDetail
	..q:pass=1
	..s (APPRoleFilter,APPUserFliter,APPActionFliter,APPStatusFliter)=0
	..s LateAppListID=$o(^DHCEQApproveList(0,"Source",TApproveType,TSourceID,""),-1)
	..s TRowID=0
	..f  s TRowID=$O(^DHCEQApproveList(0,"Source",TApproveType,TSourceID,TRowID)) q:TRowID=""  d
	...;q:$P(^DHCEQApproveList(TRowID),"^",10)="Y"	//把审批的所有操作都记录下来
	...d ResetGetBussApproveList
	...s TApproveDate=$P(^DHCEQApproveList(TRowID),"^",7) 		//审批日期
	...s TApproveTime=$p($g(^DHCEQApproveList(TRowID)),"^",8)   //审批时间
	...s TOperateType=$p($g(^DHCEQApproveList(TRowID)),"^",12)  
	...s TApproveDate=##Class(web.DHCEQCommon).TransValueToPage(TApproveDate,"date")
	...s TApproveTime=##Class(web.DHCEQCommon).TransValueToPage(TApproveTime,"time")
	...s TApproveRoleDR=$P(^DHCEQApproveList(TRowID),"^",5)  	//审批角色
	...q:(+QXType=0)&&(vApproveRoleDR'="")&&(vApproveRoleDR'=TApproveRoleDR)	//Add By QW20211110 BUG:QW0154 增加角色过滤
	...i (QXType=1) d
	....i vApproveRoleDR="" s APPRoleFilter=1
	....e  i (vApproveRoleDR=TApproveRoleDR) s APPRoleFilter=1
	...i TApproveRoleDR'="" s TApproveRole=$P(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)
	...s TApproveUserDR=$P(^DHCEQApproveList(TRowID),"^",6)
	...q:(+QXType=0)&&(vApproveUser'="")&&(vApproveUser'=TApproveUserDR)
	...i (QXType=1) d
	....i vApproveUser="" s APPUserFliter=1
	....e  i (vApproveUser=TApproveUserDR) s APPUserFliter=1
	...i TApproveUserDR'="" s TApproveUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TApproveUserDR)
	...s TOpinion=$P(^DHCEQApproveList(TRowID),"^",3)
	...i TOpinion="" d
	....i TOperateType=0 d
	.....s TOpinion="同意(默认)"	
	....e  d
	.....s TOpinion="拒绝"
	...s TActionDR=$p($g(^DHCEQApproveList(TRowID)),"^",11)
	...q:(+QXType=0)&&(vApproveActionDR'="")&&(vApproveActionDR'=TActionDR) //Add By QW20211110 BUG:QW0154 增加角色过滤
	...i QXType=1 d
	....i vApproveActionDR="" s APPActionFliter=1
	....e  i (vApproveActionDR=TActionDR) s APPActionFliter=1
	...i TActionDR'="" d
	....i TActionDR=0 d
	.....s TAction="提交"
	....e  d
	.....s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
	...e  d
	....s TAction="审核"
	...i TOperateType=1 s TAction="拒绝"
	...s TAppStatus=0	//"已审批"
	...i LateAppListID=TRowID s TAppStatus=1	//"最近审批"
	...q:(+QXType=0)&&(APPStatus="0")&&(TAppStatus=2)	//已审批单据包含：已审批和最近审批
	...q:(+QXType=0)&&(APPStatus="1")&&(TAppStatus'=1)	//最近审批
	...q:(+QXType=0)&&(APPStatus="2")&&(TAppStatus'=2)	//待审批
	...i (QXType=1) d
	....i APPStatus="" s APPStatusFliter=1
	....e  d
	.....i (APPStatus="1")&&(TAppStatus=1) s APPStatusFliter=1
	.....e  i (APPStatus="0")&&(TAppStatus'=2) s APPStatusFliter=1
	...i +QXType=0 d OutputRowGetBussApproveList	//按明细输出
	..s TRecentDateTime=TApproveDate_" "_TApproveTime	//最近审批时间
	..s TRecentUserDR=TApproveUserDR
	..s TRecentUser=TApproveUser
	..s TRecentRoleDR=TApproveRoleDR
	..s TRecentRole=TApproveRole
	..s TRecentActionDR=TActionDR
	..s TRecentAction=TAction		//最近审批动作
	..s TRecentOpinion=TOpinion
	..;待审批输出
	..s ApproveInfoDR=$o(^DHCEQApproveInfo(0,"SourceID",TApproveType,TSourceID,0))
	..s AIStatus=""
	..s NextStep=""
	..i ApproveInfoDR'="" d
	...s ApproveSetDR=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",3)
	...s TNextRoleDR=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",4)
	...s NextStep=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",5)
	...s AIStatus=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",8)
	...i TNextRoleDR'="" s TNextRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TNextRoleDR)),"^",2)
	...i (AIStatus=2)&&(TStatus=2) s TNextRoleDR="",TNextRole=""	//单据已审核，下一步角色为空
	...s AFLastFlag=""
	...s ApproveFlowIDs=""
	...s AFStep=0
	...f  s AFStep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,AFStep))  q:(AFStep="")||(AFLastFlag="Y")  d
	....s AFRowID=0
	....f  s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,AFStep,AFRowID))  q:(AFRowID="")||(AFLastFlag="Y")  d
	.....q:(ApproveFlowIDs'="")&&((ApproveFlowIDs_",")[(","_AFRowID_","))
	.....s AFLastFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",4)
	.....s NextToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",12)
	.....s ApproveFlowIDs=ApproveFlowIDs_","_AFRowID
	.....i (AFLastFlag'="Y")&&(NextToFlowDR'="")  d
	......s ApproveFlowIDs=ApproveFlowIDs_","_NextToFlowDR
	...s Flag=0
	...s CurFlowID=0
	...f CurFlowID=2:1:$L(ApproveFlowIDs,",") d
	....s AFRowID=$p(ApproveFlowIDs,",",CurFlowID)
	....s AFStep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",3)
	....i QXType'=1 d ResetGetBussApproveList
	....i NextStep=AFStep d
	.....s Flag=1
	.....s TApproveUser=##Class(web.DHCEQ.Plat.LIBMessages).GetApproveFlowUsers(TBussType, TSourceID)
	....i Flag=1 d
	.....s TApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",2)
	.....q:(+QXType=0)&&(vApproveRoleDR'="")&&(vApproveRoleDR'=TApproveRoleDR)
	.....i (QXType=1) d
	......i vApproveRoleDR="" s APPRoleFilter=1
	......e  i (vApproveRoleDR=TApproveRoleDR) s APPRoleFilter=1
	.....s TActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",9)
	.....q:(+QXType=0)&&(vApproveActionDR'="")&&(vApproveActionDR'=TActionDR)
	.....i (QXType=1) d
	......i vApproveActionDR="" s APPActionFliter=1
	......e  i (vApproveActionDR=TActionDR) s APPActionFliter=1
	.....i TActionDR'="" s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
	.....i TApproveRoleDR'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	.....;s TOpinion="待审核"
	.....s TAppStatus=2	//"待审批"
	.....q:(+QXType=0)&&(APPStatus'="")&&(APPStatus'=2)
	.....i QXType=1 d
	......i APPStatus="" s APPStatusFliter=1
	......e  i APPStatus=TAppStatus s APPStatusFliter=1
	.....i +QXType=0 d OutputRowGetBussApproveList	//按明细输出
	..i QXType=1 d
	...q:(APPRoleFilter'=1)||(APPActionFliter'=1)||(APPUserFliter'=1)||(APPStatusFliter'=1)
	...s (TApproveDate,TApproveRoleDR,TApproveRole,TApproveUserDR,TApproveUser,TOpinion,TApproveTime,TActionDR,TAction,TTimeInfo,TYear,TOperateType,TAppStatus)=""
	...d OutputRowGetBussApproveList	//按单据输出
	
	Quit $$$OK

GetBussDetail
	s (TBussInfo,TBussNo,TStatus,TRequestDate,TAuditDate,TName,TRequestLoc,TAppTypeDesc,TUseLoc,TFromLoc,TToLoc,TOutType,TBussType,TKindFlag)=""
	s pass=0
	s TBussInfo=##Class(web.DHCEQMessages).GetBussInfoByBussID(TApproveType,TSourceID)
	s TBussNo=$p(TBussInfo,"^",1)
	i TBussNo="" s pass=1 quit
	i (vBussNo'="")&&(vBussNo'=TBussNo) s pass=1 quit
	s TStatus=$p(TBussInfo,"^",12)
	i (TStatus=0)||(TStatus>2) s pass=1 quit
	i $p(TBussInfo,"^",13)="Y" s pass=1 quit		//过滤无效单据
	i (Status'="")&&(Status'=TStatus) s pass=1 quit
	s TRequestDate=$p(TBussInfo,"^",4)
	i (TRequestDate<RequestDateFrom)||(TRequestDate>RequestDateTo) s pass=1 quit
	s TAuditDate=$p(TBussInfo,"^",22)
	i (+TAuditDate<AuditDateFrom)||(+TAuditDate>AuditDateTo) s pass=1 quit
	s TEquipTypeDR=$p(TBussInfo,"^",15)
	;q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)=1
	s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	s TName=$p(TBussInfo,"^",2)
	s TRequestLoc=$p(TBussInfo,"^",3)
	s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TRequestLoc)
	s TAppTypeDesc=$p($g(^DHCEQCCode("DHCEQCApproveType",TApproveType)),"^",2)
	s TUseLoc=$p(TBussInfo,"^",5)
	s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLoc)
	s TFromLoc=$p(TBussInfo,"^",6)
	s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLoc)
	s TToLoc=$p(TBussInfo,"^",7)
	s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLoc)
	s TMoveType=$p(TBussInfo,"^",8)
	i (TApproveType="14")	d
	.i (TMoveType=0) s TAppTypeDesc="库房分配"
	.i (TMoveType=1) s TAppTypeDesc="科室调配"
	.i (TMoveType=2) s TAppTypeDesc="转报废库"
	.i (TMoveType=3) s TAppTypeDesc="科室退库"
	.i (TMoveType=4) s TAppTypeDesc="库房调拨"
	s TOutType=$p(TBussInfo,"^",9)
	s TBussType=$p(TBussInfo,"^",32)
	s TKindFlag=$p(TBussInfo,"^",33)
	quit	
ResetGetBussApproveList
	s (TApproveDate,TApproveRoleDR,TApproveRole,TApproveUserDR,TApproveUser,TOpinion,TApproveTime,TActionDR,TAction,TTimeInfo,TYear,TOperateType,TAppStatus,TNextRole)=""
	s (TRecentDateTime,TRecentUserDR,TRecentUser,TRecentRoleDR,TRecentRole,TRecentActionDR,TRecentAction,TRecentOpinion)=""
	quit
		
OutputRowGetBussApproveList
	set TRow=TRow+1
	set TAppStatus=$case(TAppStatus,"0":"已审批","1":"最近审批","2":"待审批",:"未审批")
	s TStatusDesc=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	set Data=$lb(TRow,TRowID,TApproveType,TBussType,TSourceID,TBussNo,TStatusDesc,TRequestDate,TAuditDate,TName,TRequestLoc,TAppTypeDesc,TUseLoc,TFromLoc,TToLoc,TOutType,TApproveDate,TApproveTime,TApproveRole,TApproveUser,TOpinion,TAction,TOperateType,TKindFlag,TAppStatus,TNextRole,TRecentDateTime,TRecentUser,TRecentRole,TRecentAction,TRecentOpinion)
 	Set ^CacheTemp(repid,index)=Data
 	Set ^DHCEQTemp("BussApproveList",+$H,EJob,CurUserID,index)=TRowID_"^"_TApproveType_"^"_TBussType_"^"_TSourceID_"^"_TBussNo_"^"_TStatusDesc_"^"_TRequestDate_"^"_TAuditDate_"^"_TName_"^"_TRequestLoc_"^"_TAppTypeDesc_"^"_TUseLoc_"^"_TFromLoc_"^"_TToLoc_"^"_TOutType_"^"_TApproveDate_"^"_TApproveTime_"^"_TApproveRole_"^"_TApproveUser_"^"_TOpinion_"^"_TAction_"^"_TOperateType_"^"_TKindFlag_"^"_TAppStatus_"^"_TNextRole_"^"_TRecentDateTime_"^"_TRecentUser_"^"_TRecentRole_"^"_TRecentAction_"^"_TRecentOpinion
	Set index=index+1
	quit
}

ClassMethod GetBussApproveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussApproveListExecute ]
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

ClassMethod GetBussApproveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussApproveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by czf 2021-06-26 begin
/// 获取业务审批信息数量
/// w ##class(web.DHCEQ.Plat.LIBMessages).GetNum("BussApproveList",28144)
ClassMethod GetNum(Node, Ejob)
{
	s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $o(^DHCEQTemp(Node,+$H,Ejob,CurUserID,""),-1)
}

/// Add by czf 2021-06-26 begin
/// 获取业务审批信息
ClassMethod GetList(Node, Ejob, index)
{
	s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $g(^DHCEQTemp(Node,+$H,Ejob,CurUserID,index))
}

/// Author zx 2021-07-30
/// Desc 获取消息发送到某一步骤时
/// Input BSCBussType:业务代码, BSCEquipTypeIDs:类组ID串, BSCHospitalID:院区ID, BSCActionID:动作ID
/// w ##Class(web.DHCEQ.Plat.LIBMessages).MessagesServerContral("","","","1")
ClassMethod MessagesServerContral(BSCBussType As %String = "", BSCEquipTypeIDs As %String = "", BSCHospitalID As %String = "", BSCActionID As %String = "")
{
	i BSCActionID="" q 0
	s TResultLength=""  //Modify by zx 2022-09-14 消息间隔默认为空
	s BSCRowID=0
	f  s BSCRowID=$o(^DHCEQMessagesServerContral(0,"Action",BSCActionID,BSCRowID)) q:(BSCRowID="")||(TResultLength>0)  d
	.s TBSCBussType=$p($g(^DHCEQMessagesServerContral(BSCRowID)),"^",1)
	.q:(BSCBussType'="")&&(BSCBussType'=TBSCBussType)
	.s TBSCEquipTypeIDs=$p($g(^DHCEQMessagesServerContral(BSCRowID)),"^",2)
	.q:(BSCEquipTypeIDs'="")&&(BSCEquipTypeIDs'=TBSCEquipTypeIDs)
	.s TBSCHospitalID=$p($g(^DHCEQMessagesServerContral(BSCRowID)),"^",3)
	.q:(BSCHospitalID'="")&&(BSCHospitalID'=TBSCHospitalID)
	.s TResultLength=$p($g(^DHCEQMessagesServerContral(BSCRowID)),"^",5)
	
	q TResultLength
}

/// add by wy 2023-3-1 批量作废单据
/// vBussType:		11-验收单	21-入库单	22-转移单	23-减少,退货	31-维修	34-报废	64-租赁	91-采购申请	92-采购招标	93-采购合同
/// vBussRowID:业务主单ID
/// w ##Class(web.DHCEQ.Plat.LIBMessages).CancellBuss("31","7,5","77")
ClassMethod CancellBuss(vBussType As %String = "", vBussIDs As %String = "", User As %Library.String = "")
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

/// MZY0115		2473605		2022-03-10
/// vBussType:		11-验收单	21-入库单	22-转移单	23-减少,退货	31-维修	34-报废	64-租赁	91-采购申请	92-采购招标	93-采购合同
/// vBussRowID:业务主单ID
/// 描述:无效单据处理
/// w ##Class(web.DHCEQ.Plat.LIBMessages).InvalidBuss(11, 5)
/// w ##Class(web.DHCEQ.Plat.LIBMessages).InvalidBuss(34, 6)
ClassMethod InvalidBuss(vBussType As %String = "", vBussRowID As %String = "", User As %String = "")
{
	i (vBussType="")||(vBussRowID="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9201, "业务类型代码及业务ID不能为空!")
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s SQLCODE=0
	;s ^DHCEQMozy("InvalidBuss")=vBussType _","_ vBussRowID
	
	TSTART
	s MRowID=$o(^DHCEQMessages(0,"MessageType",1,vBussType,vBussRowID,""),-1)
	&SQL(Update SQLUSER.DHC_EQMessages Set M_Status=2,M_DealUserDR=:User,M_DealDate=:Date,M_DealTime=:Time,M_DealFlag='Y' Where M_RowID=:MRowID)	;消息无效
	i SQLCODE=100 s SQLCODE=0  //modified by wy 2023-3-31 3402312 作废新增的单据时，无消息需要更新
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	; 处理单据为无效状态、部分业务导致的台账异常状态恢复
	// 验收
	i vBussType=11
	{
		// MZY0124	2473605		2022-05-23
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_Status=3,OCR_CancelUser=:User,OCR_CancelDate=:Date,OCR_CancelTime=:Time,OCR_InvalidFlag='Y' Where OCR_RowID=:vBussRowID)
		;s ^DHCEQOpenCheckRequest(vBussRowID,"InvalidInfo")=##Class(web.DHCEQCommon).GetTrakNameByID("user", User)_","_$zd(Date,3)_","_$zt(Time)
	}		
	// 入库
	i vBussType=21
	{
		&SQL(Update SQLUSER.DHC_EQInStock Set IS_Status=3,IS_CancelUser=:User,IS_CancelDate=:Date,IS_CancelTime=:Time,IS_InvalidFlag='Y' Where IS_RowID=:vBussRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	// 转移
	i vBussType=22
	{
		// MZY0124	2473605		2022-05-23
		&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_Status=3,SM_CancelUser=:User,SM_CancelDate=:Date,SM_CancelTime=:Time,SM_InvalidFlag='Y' Where SM_RowID=:vBussRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		;s ^DHCEQStoreMove(vBussRowID,"InvalidInfo")=##Class(web.DHCEQCommon).GetTrakNameByID("user", User)_","_$zd(Date,3)_","_$zt(Time)	MZY0124	2473605		2022-05-23
		
		s SMLRowID=0
		f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",vBussRowID,SMLRowID)) quit:(SMLRowID="")||(SQLCODE'=0)  d
		.s ListEquip=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
		.s ListCount=$L(ListEquip,",")
		.for j=1:1:ListCount quit:SQLCODE'=0  d
		..s EquipID=$p(ListEquip,",",j)
		..&SQL(Update SQLUSER.DHC_EQEquip set EQ_AdvanceDisFlag=null,EQ_Hold1=null Where EQ_RowID=:EquipID)
	}
	// 减少,退货
	i vBussType=23
	{
		///add by ZY0303 20220617 2685491
		&SQL(Update SQLUSER.DHC_EQReturn set R_Status=3,R_CancelUser=:User,R_CancelDate=:Date,R_CancelTime=:Time,R_InvalidFlag='Y' where R_RowID = :vBussRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	// 维修
	i vBussType=31
	{
		// MZY0124	2473605		2022-05-23
		&sql(Update sqluser.DHC_EQMMaintRequest Set MR_Status=3,MR_CancelUser=:User,MR_CancelDate=:Date,MR_CancelTime=:Time,MR_InvalidFlag='Y' where MR_RowID=:vBussRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		;s ^DHCEQMMaintRequest(vBussRowID,"InvalidInfo")=##Class(web.DHCEQCommon).GetTrakNameByID("user", User)_","_$zd(Date,3)_","_$zt(Time)	MZY0124	2473605		2022-05-23
		
		s EQClassFlag=""
		i $Piece($Get(^DHCEQMMaintRequest(vBussRowID)),"^",5)'=""		; ExObjDR
		{
			i ($Piece($Get(^DHCEQMMaintRequest(vBussRowID)),"^",63))||($Piece($Get(^DHCEQMMaintRequest(vBussRowID)),"^",63)=2)  d	; SourceTypeDR
			.s EquipID = $p($g(^DHCEQMExObj($Piece($Get(^DHCEQMMaintRequest(vBussRowID)),"^",5))),"^",5)
			.&SQL(Update SQLUSER.DHC_EQEquip set EQ_AdvanceDisFlag=null,EQ_Hold1=null Where EQ_RowID=:EquipID)
			.s EQClassFlag=$Piece($Get(^DHCEQEquip(EquipID)),"^",83)
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		
		if ((($Piece($Get(^DHCEQMMaintRequest(vBussRowID)),"^",63)'=2)||(EQClassFlag'="Y"))&&(##Class(web.DHCEQ.EM.BUSMMaintRequest).GetEQStopStartFlag(vBussType,vBussRowID,"",1)))
		{
			; ##class(web.DHCEQCommon).GetSysInfo("990036")
			s ChangeInfoReturn = ##Class(web.DHCEQ.Plat.BUSChangeInfo).StopEquipBySource(vBussType,vBussRowID, 0)	; 启用设备
			s ChangeInfoInfo=##Class(web.DHCEQ.Plat.JsonObject).FromJSON(ChangeInfoReturn)
			s SQLCODE=ChangeInfoInfo.SQLCODE
		}
	}
	// 报废
	i vBussType=34
	{
		//MZY0124	2473605		2022-05-23
		&SQL(Update SQLUSER.DHC_EQDisuseRequest set DR_Status=3,DR_InvalidFlag='Y',DR_CancelUser=:User,DR_CancelDate=:Date,DR_CancelTime=:Time where DR_RowID=:vBussRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		;s ^DHCEQDisuseRequest(vBussRowID,"InvalidInfo")=##Class(web.DHCEQCommon).GetTrakNameByID("user", User)_","_$zd(Date,3)_","_$zt(Time)	MZY0124	2473605		2022-05-23
		
		s ListEquip=""
		; KindFlag
		i $p($g(^DHCEQDisuseRequest(vBussRowID)),"^",44) ="0" s ListEquip = $p($g(^DHCEQDisuseRequest(vBussRowID)),"^",1)
		i $p($g(^DHCEQDisuseRequest(vBussRowID)),"^",44) ="1" s ListEquip = $Get(^DHCEQDisuseRequest(vBussRowID,"EX"))
		i $p($g(^DHCEQDisuseRequest(vBussRowID)),"^",44) ="2"
		{
			s DLLRowID=0
			f  s DLLRowID=$o(^DHCEQDisuseList(0,"Request",vBussRowID,DLLRowID)) quit:(DLLRowID="")  d
			.i ListEquip'="" s ListEquip=ListEquip_","
			.i $Piece($Get(^DHCEQDisuseList(DLLRowID)),"^",2)=0 d
			..s ListEquip=ListEquip_$Piece($Get(^DHCEQDisuseList(DLLRowID)),"^",3)
			.e  d
			..s ListEquip=ListEquip_$g(^DHCEQDisuseList(DLLRowID,"EX"))
		}
		s ListCount=$L(ListEquip,",")
		for j=1:1:ListCount quit:SQLCODE'=0  d
		.s EquipID=$p(ListEquip,",",j)
		.&SQL(Update SQLUSER.DHC_EQEquip set EQ_AdvanceDisFlag=null,EQ_Hold1=null Where EQ_RowID=:EquipID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		
		if (##Class(web.DHCEQChangeInfo).NeedChange(34,vBussRowID,0)=1)&&(##Class(web.DHCEQBatchDisuseRequest).CheckStoreLocDR($p($g(^DHCEQDisuseRequest(vBussRowID)),"^",34))'=1)
		{
			; ##class(web.DHCEQCommon).GetSysInfo("990037")
			s ChangeInfoReturn = ##Class(web.DHCEQ.Plat.BUSChangeInfo).StopEquipBySource(vBussType,vBussRowID, 0)	; 启用设备
			s ChangeInfoInfo=##Class(web.DHCEQ.Plat.JsonObject).FromJSON(ChangeInfoReturn)
			s SQLCODE=ChangeInfoInfo.SQLCODE
		}
	}
	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
	
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,vBussRowID)
}

/// Add By zc2022-4-8 根据动作与状态判断单据是否符合条件
/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetActionStatusFilerInfo("1",",WX_Assign",202)
ClassMethod GetActionStatusFilerInfo(FilerActionPattern, FilerActionCode, FilerBussID)
{
	new (FilerActionPattern,FilerActionCode,FilerBussID)
	s AcRFlag=0
	i FilerActionPattern=0  q AcRFlag
	if (FilerActionPattern="1") ;待维修
	{
		i FilerActionCode'["WX_Assign" s AcRFlag=1
		i FilerActionCode["WX_Maint" s AcRFlag=1
		i FilerActionCode["WX_Finish" s AcRFlag=1
	}elseif (FilerActionPattern="2")  ;维修中
	{
		if ($p($g(^DHCEQMMaintRequest(FilerBussID)),"^",26)'="")
		{
			i (FilerActionCode["WX_Maint")
			{
				i (FilerActionCode["WX_Finish") s AcRFlag=1
			}
			else
			{
				s AcRFlag=1
			}
		}
		else
		{
			s AcRFlag=1
		}
	}elseif (FilerActionPattern="3") ;待审核
	{
		if ($p($g(^DHCEQMMaintRequest(FilerBussID)),"^",16)'="")
		{
			i (FilerActionCode'["WX_Evaluate")
			{
				i (FilerActionCode'["WX_Finish")
				{
			 		s AcRFlag=1
				}
			}

		}
		else
		{
			s AcRFlag=1
			i (FilerActionCode["WX_Finish") s AcRFlag=0
		}
	}
	q AcRFlag
}

/// Add By zc2022-4-8 根据业务类型与业务ID判断单据是已催单
/// w ##Class(web.DHCEQ.Plat.LIBMessages).CheckReminderBuss("31",5)
ClassMethod CheckReminderBuss(ReminderBussType, ReminderBussID)
{
	new (ReminderBussType,ReminderBussID)
	s ReminderFlag=0
	i (ReminderBussType="")||(ReminderBussID="") q ReminderFlag
	s ReminderApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(ReminderBussType)
	s RCALRowID=0
	f  s RCALRowID=$o(^DHCEQApproveList(0,"Source",ReminderApproveType,ReminderBussID,RCALRowID))  q:(RCALRowID="")||(ReminderFlag'=0)  d
	.q:$p($g(^DHCEQApproveList(RCALRowID)),"^",10)="Y"
	.q:$p($g(^DHCEQApproveList(RCALRowID)),"^",12)="1"
	.q:$p($g(^DHCEQApproveList(RCALRowID)),"^",3)'="催单"
	.s ReminderFlag=1
	q ReminderFlag
}

/// d ##Class(web.DHCEQ.Plat.LIBMessages).BussNumInfo("31","19,20",1)
ClassMethod BussNumInfo(NBussType, NActionIDs, NUserID)
{
	s nLen=$l(NActionIDs,",")
	f n=1:1:nLen d
	.q:NUserID=""
	.s NActionID=$p(NActionIDs,",",n)
	.q:NActionID=""
	.s ^DHCEQTemp("BussNumInfo",NBussType,NUserID,NActionID)=$g(^DHCEQTemp("BussNumInfo",NBussType,NUserID,NActionID))+1
}

/// d ##Class(web.DHCEQ.Plat.LIBMessages).BussLocNumInfo("31","19,20",1)
ClassMethod BussLocNumInfo(LNBussType, LNLocID, LNUserID)
{
	i LNLocID'="" d
	.s ^DHCEQTemp("BussLocNumInfo",LNBussType,LNUserID,LNLocID)=$g(^DHCEQTemp("BussLocNumInfo",LNBussType,LNUserID,LNLocID))+1
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBMessages","GetActionNumByBussType","31","85","5313","409","","","","","2","","","","","^ActionPattern=^ManageTypeID=^EmergencyPattern=^GroupFlag=1")
Query GetActionNumByBussType(BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "", EquipDR As %String = "", DatePattern As %String = "", StartDate As %String = "", EndDate As %String = "", LocPattern As %String = "", UseLocDR As %String = "", UserPattern As %String = "", UserDR As %String = "", vActionDR As %String = "", vData As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TNum:%String") [ SqlProc ]
{
}

ClassMethod GetActionNumByBussTypeExecute(ByRef qHandle As %Binary, BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "", EquipDR As %String = "", DatePattern As %String = "", StartDate As %String = "", EndDate As %String = "", LocPattern As %String = "", UseLocDR As %String = "", UserPattern As %String = "", UserDR As %String = "", vActionDR As %String = "", vData As %String = "") As %Status
{
	
	new repid, index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	new ApproveType,BussTypeID,ApproveInfo
 	new EquipTypeDR,StatCatDR,EquipCatDR,ItemDR,LocDR,EquipID
 	// Modefied by zc 2022-4-8 begin
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set ManageTypeID=##class(web.DHCEQCommon).GetDataByName(vData,"ManageTypeID")
 	Set EmergencyFlag=##class(web.DHCEQCommon).GetDataByName(vData,"EmergencyFlag")
 	//Set ActionPattern=##class(web.DHCEQCommon).GetDataByName(vData,"ActionPattern")
 	Set ReminderFlag=##class(web.DHCEQCommon).GetDataByName(vData,"ReminderFlag")
 	
 	Set EmergencyFlag=##class(web.DHCEQCommon).TransValueFromPage(EmergencyFlag,"bool")
 	Set ReminderFlag=##class(web.DHCEQCommon).TransValueFromPage(ReminderFlag,"bool")
 	Set GroupFlag=##class(web.DHCEQCommon).GetDataByName(vData,"GroupFlag")
	//Modify by zx 2022-11-24
 	//Set limitActionIDs=##class(web.DHCEQCommon).GetDataByName(vData,"limitActionIDs")
 	// Modefied by zc 2022-4-8 end
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
 	Set limitActionIDs=##Class(web.DHCEQ.Plat.LIBMessages).GetActionsByBussType(GroupID,BussType)
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurLocDR="" s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	//Add By QW20200604 BUG:QW0065 Begin 处理查询条件
 	if (DatePattern'="")
	{
			s DateStr=##Class(web.DHCEQ.Plat.LIBMessages).GetDateFilerInfo(DatePattern,StartDate,EndDate)
			s StartDate=$p(DateStr,"^",1)
			s EndDate=$p(DateStr,"^",2)
	}
	if (LocPattern="2")
	{
		//i CurLocDR'="" s UseLocDR=CurLocDR
		i UseLocDR="" s UseLocDR=CurLocDR  //##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	}
	if ((UserPattern="2")||(UserPattern="3"))
	{
		i UserDR="" s UserDR=UserID  //##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	}
	//Add By QW20200604 BUG:QW0065 End
 	s CurRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID) 
 	//Modify by zx 2020-11-26 BUG ZX0118
 	i (GroupID="")||(UserID="")||(CurRoleIDs="") Quit $$$OK
 	;i (GroupID="")||(UserID="")||(BussType="")||(CurRoleIDs="") Quit $$$OK
 	;s ApproveType=##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)  //add by zx 2016-12-28 根据业务类型获取审批类型 ZX0036
 	k ^DHCEQTemp("BussNumInfo",BussType,UserID)
 	k ^DHCEQTemp("BussLocNumInfo",BussType,UserID)
 	s index=1
 	s TRow=0
 	s MsgID=0
 	f  s MsgID=$o(^DHCEQMessagesRecInfo(0,"UserStatusMessages",UserID,0,MsgID)) q:MsgID=""  d
 	.//判断消息的可处理角色和当前角色是否符合
 	.s PassFlag=0
 	.s ActionIDs=""
    .s PassFlag=##Class(web.DHCEQMessages).CheckMessageRoles(GroupID,UserID,MsgID,CurRoleIDs) //Bug ZX0045
	.q:$p(PassFlag,"^",1)=0
	.s TActionDesc=$p(PassFlag,"^",3)
	.s TActionCode=$p(PassFlag,"^",2)
	.s ActionIDs=$p(PassFlag,"^",4)
	.s Roles=$p(PassFlag,"^",5)
	.s PDataList=$g(^DHCEQMessages(MsgID))
	.q:(+vActionDR'=0)&&((","_ActionIDs_",")'[(","_vActionDR_","))  //Add By QW20200707 BUG:QW0069 增加动作id判断
 	.q:$p(PDataList,"^",14)'="1"
 	.q:$p(PDataList,"^",21)="Y"
	.s BussTypeID=$p(PDataList,"^",10)
    .q:(BussType'="")&(BussTypeID'=BussType)
	.s TBussID=$p(PDataList,"^",11)
	.q:(ReminderFlag="Y")&&(##Class(web.DHCEQ.Plat.LIBMessages).CheckReminderBuss(BussType,TBussID)=0)
	.q:(BussTypeID="31")&&(EmergencyFlag="Y")&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",61)="")  	// Modefied by zc 2022-4-8
	.;q:(BussTypeID="31")&&(EmergencyFlag="N")&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",61)'="")	// Modefied by zc 2022-4-8
	.q:(BussTypeID="31")&&(+ManageTypeID>0)&&($p($g(^DHCEQMMaintRequest(TBussID)),"^",2)'=ManageTypeID)							// Modefied by zc 2022-4-8
    .;q:(BussTypeID="31")&&(##Class(web.DHCEQ.Plat.LIBMessages).GetActionStatusFilerInfo(ActionPattern,TActionCode,TBussID)=1)	
    .q:(EquipDR'="")&&(##Class(web.DHCEQMessages).CheckEquipIsInBuss(BussTypeID,TBussID,EquipDR)=0)  //modified by czf
   
    .s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussTypeID,TBussID)
    .//Modify by zx 2020-11-26 BUG ZX0118
    .s ApproveType=##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussTypeID)
    .//modify by zx 
	.;q:(($p(BussInfo,"^",3)'=CurLocDR)&&($p(BussInfo,"^",6)'=CurLocDR))&&(BussTypeID="64")      //add by jyp 355232
	.;q:(($p(BussInfo,"^",29)-(+$h))>1)&&(BussTypeID="64")    //add by lmm 355232
	.;q:($p(BussInfo,"^",12)'=2)&&(BussTypeID="64")
	.q:($p(BussInfo,"^",12)=2)&&(BussTypeID'="64")		//BussStatus  add by zx 2016-11-17 租赁审核状态处理 ZX0036
	.q:$p(BussInfo,"^",13)="Y"		//BussInvalidFlag
	.q:((StartDate'="")&&($p(BussInfo,"^",4)<StartDate)) //Add By QW20200604 BUG:QW0065 
	.q:((EndDate'="")&&($p(BussInfo,"^",4)>EndDate)) //Add By QW20200604 BUG:QW0065
	.q:((UseLocDR'="")&&($p(BussInfo,"^",5)'=UseLocDR)) //Add By QW20200604 BUG:QW0065
	.q:(UserPattern="3")&&($p(BussInfo,"^",30)=UserDR) //Add By QW20200604 BUG:QW0065
	.q:((UserPattern'="")&&(UserPattern'="3")&&(UserDR'="")&&($p(BussInfo,"^",30)'=UserDR)) //Add By QW20200604 BUG:QW0065  modified by wy 2022-1-27
	.//取当前业务审批信息,获取限制条件,以便后面查看用户是否有权限收消息
	.s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(BussType,TBussID,"")
	.//EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR
	.s EquipTypeDR=$p(ApproveInfo,"^",10)
	.q:(EquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"","2")) //add by zx 2017-03-20 BUG ZX0036
	.s StatCatDR=$p(ApproveInfo,"^",11)
	.s EquipCatDR=$p(ApproveInfo,"^",12)
	.s LocDR=$p(ApproveInfo,"^",9)
	.s EquipID=$p(ApproveInfo,"^",14)
    .s TApproveSetDR=$p(ApproveInfo,"^",3)  //add by zx 2017-06-20 BUG ZX0045 微信端approveset获取
	.i EquipID'="" d
	..s ModelID=$p($g(^DHCEQEquip(EquipID)),"^",3)
	..i ModelID'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",ModelID)),"^",2)
	..;s GuaranteeEndDate=$p($g(^DHCEQEquip(EquipID)),"^",51)  //add by zx 2017-01-05 增加保修内标志 ZX0036
	..;s TGuaranteeFlag=0
	..;i +GuaranteeEndDate>+$h s TGuaranteeFlag=1  
	..s TGuaranteeFlag=$p(##class(web.DHCEQ.EM.BUSMMaintRequest).GetGuaranteeData(EquipID),"^",1)
	.s ItemDR=$p(ApproveInfo,"^",13)
	.s CancelToUser=$p(ApproveInfo,"^",19)
	.s AssignDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Assign",0))_","			//派单动作DR	//Add By DJ  2016-05-25 begin
	.s EvaluateDR=","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Evaluate",0))_","		//组长审核动作DR
	.s LeaderFlag=$D(^DHCEQCCode("DHCEQMCMaintGroup",0,"Leader",1,UserID))		//是否维修组长
	.s PersonelFlag=0  //add by jdl 2017-01-11
	.s AuditFlag=0 //Add By QW20200907 BUG:QW0078
	.if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Accept",0))_",")  d
	..s PersonelFlag=1
	.else  if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Audit",0))_",")  d
	..s PersonelFlag=1
	..s AuditFlag=1 //Add By QW20200907 BUG:QW0078
	.else  if (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Finish",0))_",")  d
	..s PersonelFlag=1
	.s CMLReturn=0
	.i ('((LeaderFlag)&&(((","_ActionIDs_",")[AssignDR)||((","_ActionIDs_",")[EvaluateDR))))&&(PersonelFlag'=1)  d		//不满足既是维修组长并且消息动作权限包含派单或组长审核动作
	..s CMLReturn=##Class(web.DHCEQCommon).CheckManageLimit(UserID,GroupID,Roles,EquipTypeDR,StatCatDR,EquipCatDR,LocDR,EquipID,ItemDR)
 	.q:CMLReturn'=0
 	.q:(AuditFlag=1)&&(##Class(web.DHCEQCommon).ISPreLoc(LocDR,CurLocDR)=0) //Modified By QW20200922 BUG:QW0081 优化访问权限
	.i (","_ActionIDs_",")[(","_$o(^DHCEQCCode("DHCEQCAction",0,"Code","Move_Receive",0))_",")  d	//czf 2021-06-03 begin
	..s AuditFlag=1
	.s ToLocDR=$p(BussInfo,"^",7)
	.q:(AuditFlag=1)&&(ToLocDR'="")&&(##Class(web.DHCEQCommon).ISPreLoc(ToLocDR,CurLocDR)=0)		//czf 2021-06-03 end
	.d ##Class(web.DHCEQ.Plat.LIBMessages).BussNumInfo(BussType,ActionIDs,UserID)
	.d ##Class(web.DHCEQ.Plat.LIBMessages).BussLocNumInfo(BussType,$p(BussInfo,"^",3),UserID)
 	
 	i GroupFlag=1 
 	{
	 	i limitActionIDs="" 
	 	{
 			s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
			if (ApproveType="") Quit $$$OK
			s ApproveTypeID=##class(web.DHCEQApproveList).GetApproveType(ApproveType)
			s rowid=0
			for  s rowid=$o(^DHCEQCCode("DHCEQCAction", 0, "SourceType",ApproveTypeID,rowid)) quit:rowid=""  d
			.;q:$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",5)="Y"
			.q:'$d(^DHCEQTemp("BussNumInfo",BussType,UserID,rowid))
			.d ResetVariablesGetActionNumByBussType
			.s TRowID=rowid
			.s TCode=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
			.s TDesc=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)
			.s TNum=$g(^DHCEQTemp("BussNumInfo",BussType,UserID,rowid))
			.d OutputRowGetActionNumByBussType
	 	}
	 	else
	 	{
		 	s count=$l(limitActionIDs,"$")
			For i=1:1:count Do
			.Set rowid=$Piece(limitActionIDs,"$",i)
			.d ResetVariablesGetActionNumByBussType
			.s TRowID=rowid
			.s TCode=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
			.s TDesc=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)
			.i '$d(^DHCEQTemp("BussNumInfo",BussType,UserID,rowid)) d
			..s TNum=0
			.e  d
			..s TNum=$g(^DHCEQTemp("BussNumInfo",BussType,UserID,rowid))
			.d OutputRowGetActionNumByBussType
		}
 	}
 	else
 	{
	 	s locid=0
		for  s locid=$o(^DHCEQTemp("BussLocNumInfo",BussType,UserID,locid)) quit:locid=""  d
		.d ResetVariablesGetActionNumByBussType
		.s TRowID=locid
		.s TCode=locid_##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",locid)
		.s TDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",locid)
		.s TNum=$g(^DHCEQTemp("BussLocNumInfo",BussType,UserID,locid))
		.d OutputRowGetActionNumByBussType
	}
	Quit $$$OK

OutputRowGetActionNumByBussType
	s Data=$lb(TRowID,TCode,TDesc,TNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetActionNumByBussType
	s (TRowID,TCode,TDesc,TNum)=""
	quit
}

ClassMethod GetActionNumByBussTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetActionNumByBussTypeExecute ]
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

ClassMethod GetActionNumByBussTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetActionNumByBussTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetActionByBussTypeNew("31","4$30$31$32",30)
ClassMethod GetActionByBussTypeNew(BussType, limitActionIDs, defaultActionID)
{
	i BussType="" q ""
 	;s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	;if (ApproveType="") q ""
	;s ApproveTypeID=##class(web.DHCEQApproveList).GetApproveType(ApproveType)
	;s Info=""
	;s rowid=0
	;for  s rowid=$o(^DHCEQCCode("DHCEQCAction", 0, "SourceType",ApproveTypeID,rowid)) quit:rowid=""  d
	;.q:$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",5)="Y"
	;.q:(limitActionIDs'="")&&((("$"_limitActionIDs_"$")'[("$"_rowid_"$")))
	s Info=""
	i limitActionIDs'="" d
	.s count=$l(limitActionIDs,"$")
	.For i=1:1:count Do
	..Set rowid=$Piece(limitActionIDs,"$",i)
	..s code=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
	..s desc="待"_$e($p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2),$l($p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2))-1,$l($p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)))
	..i defaultActionID=rowid d
	...i Info'="" d
	....s Info="<span class='eq-badge' datatype='single' datagroup='MaintActionStatus' fileName='"_rowid_"'>"_desc_"</span>"_Info
	...e  d
	....s Info="<span class='eq-badge' datatype='single' datagroup='MaintActionStatus' fileName='"_rowid_"'>"_desc_"</span>"
	..e  d
	...i Info'="" s Info=Info_" "
	...s Info=Info_"<span class='eq-badge' datatype='single' datagroup='MaintActionStatus' fileName='"_rowid_"'>"_desc_"</span>"
	e  d
	.s ApproveType= ##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType)
	.q:ApproveType=""
	.s ApproveTypeID=##class(web.DHCEQApproveList).GetApproveType(ApproveType)
	.s rowid=0
	.for  s rowid=$o(^DHCEQCCode("DHCEQCAction", 0, "SourceType",ApproveTypeID,rowid)) quit:rowid=""  d
	..q:$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",5)="Y"
	..s code=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
	..s desc="待"_$e($p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2),$l($p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2))-1,$l($p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)))
	..i Info'="" s Info=Info_" "
	..s Info=Info_"<span class='eq-badge' datatype='single' datagroup='MaintActionStatus' fileName='"_rowid_"'>"_desc_"</span>"
	q Info
}

/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetActionsByBussType("85","31",1)
/// Modefied by zc 2022-11-22 增加入参BTFlag
ClassMethod GetActionsByBussType(BTGroupID, BussType, BTFlag As %String = "")
{
	n BTActionDRs,CanUseRoleIDs,BTApproveType,BTApproveSetDR,BTApproveFlowDR,BTActionDR
	s (BTActionDRs,CanUseRoleIDs,BTApproveType,BTApproveSetDR,BTApproveFlowDR,BTActionDR)=""
	s SActionDRs=""
	s BTActionDRs=""		//Modefied by zc 2022-11-22
	i BTGroupID="" s BTGroupID=%session.Get("LOGON.GROUPID")
	s CanUseRoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(BTGroupID)
	s BTApproveType=##Class(web.DHCEQMessages).GetApproveTypeByBussType(BussType) 
	s BTApproveSetDR=0
	f  s BTApproveSetDR=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",BTApproveType,BTApproveSetDR)) q:BTApproveSetDR=""  d
	.s BTApproveFlowDR=0
	.f  s BTApproveFlowDR=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveSet",BTApproveSetDR,BTApproveFlowDR)) q:BTApproveFlowDR=""  d
	..s BTApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",BTApproveFlowDR)),"^",2)
	..q:(","_CanUseRoleIDs_",")'[(","_BTApproveRoleDR_",")
	..s BTActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",BTApproveFlowDR)),"^",9)
	..q:(BTFlag'="")&&(SActionDRs'="")&&(##Class(web.DHCEQCommon).IdInIds(BTActionDR,SActionDRs,1)=1)  //Modefied by zc 2022-11-22  
	..s SActionDRs=SActionDRs_","_BTActionDR   //Modefied by zc 2022-11-22
	..i BTActionDR'="" s BTAction=$p($g(^DHCEQCCode("DHCEQCAction",BTActionDR)),"^",3)
	..q:$p($g(^DHCEQCCode("DHCEQCAction",BTActionDR)),"^",5)="Y"  //add by wy 2022-9-23 过滤无效的动作
	..i (BTActionDR'="")&&(("$"_BTActionDRs_"$")'[("$"_BTActionDR_"$")) d
	...i BTActionDRs'="" s BTActionDRs=BTActionDRs_"$"
	...i BTFlag'="" d		//Modefied by zc 2022-11-22 begin
	....s BTActionDRs=BTActionDRs_BTActionDR_","_##Class(web.DHCEQCommon).GetTrakNameByID("Action",BTActionDR)
	...e  d
	....s BTActionDRs=BTActionDRs_BTActionDR  //Modefied by zc 2022-11-22 end
	
	q BTActionDRs
}

/// w ##Class(web.DHCEQ.Plat.LIBMessages).GetActionChooseBtn("31","4,5,31,32")
ClassMethod GetActionChooseBtn(BussType, DefaultActionIDs)
{
	i BussType="" q ""
	s Info=""
	i DefaultActionIDs'="" d
	.s count=$l(DefaultActionIDs,",")
	.f i=1:1:count d
	..s rowid=$p(DefaultActionIDs,",",i)
	..s code=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
	..s desc=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)
	..s Info=Info_"<li class='nav-item'><button class='btn btn-secondary'"
	..s Info=Info_" style='height: 35px;margin-right: 10px;line-height: 21px;font-size: 14px;' onclick='actionClick(this,&quot;"_rowid_"&quot;)'>"_desc_"</button></li>"
	
	q Info
}

}
