Import sqluser

Class web.DHCSTMHUI.DHCINIsTrf Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTTRANSFERM";

ClassMethod jsSave(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,Detail)
	q RtnObj.Json()
}

/// Descript:	保存库存转移单
/// Creator:	wangjiabin
/// CreateDate:	2018-05-30
/// Table:		DHC_InIsTrf,DHC_InIsTrfItm
/// Input:		出库主表id;
/// 	供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注^入库单id,
/// 	明细id^批次id^数量^单位^请求明细id^备注^高值条码^关联initi(退库用到)_$c(1)_...
/// Output:     
/// Return：成功：出库主表id；
/// 失败：ErrCode:ErrInfo
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).Save(^bintmp(1),^bintmp(2))
ClassMethod Save(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("InitFrLoc")
	s InitType=PJObj.%Get("InitType")
	
	s ToLoc=PJObj.%Get("InitToLoc")
	
	ts
	s RtnObj=..Update(Main)
	i RtnObj.success<0 tro  q RtnObj
	
	s Init=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrfItm).Save(Init,Detail)
	i RtnObj.success<0 tro  q RtnObj
	
	s ErrInfo=""
	i InitType="T" d
	.s ErrInfo=..CheckDataExp(Init)
	i ErrInfo'="" tro  d RtnObj.Err(-1,"","保存失败:"_ErrInfo) q RtnObj
	//保存时自动完成
	s Param=GroupId_"^"_LocId_"^"_UserId
	s AppName=..%GetParameter("AppName")
	s AutoCompAfterSaveOUT=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoCompAfterSaveOUT",Param)
	s State=$p($g(^DHCINIT(Init)),"^",14)
	i (AutoCompAfterSaveOUT="Y")&&(State="10") d
	.s RtnObj=..SetCompleted(Init,"",GroupId)
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=Init
	q RtnObj
}

/// Descript:	插入或更新转移主表记录
/// Creator:	wangjiabin
/// CreateDate:	2018-05-30
/// Table:		DHC_InIsTrf
/// Input:		Main("{RowId:**,InitFrLoc:**,...}"格式的串)
/// OutPut:		RtnObj
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main,%session)
	s RtnObj=##class(RtnObj).%New()	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d
	.d RtnObj.Err(-1,"","Update入参解析失败!")
	q:RtnObj.success<0 RtnObj
	
	s Init=PJObj.%Get("RowId")
	s CompFlag=$s(Init'="":$p(^DHCINIT(Init),"^",12),1:"")
	i CompFlag="Y" d RtnObj.Err(-3,"","单据已完成!","",0)
	q:RtnObj.success<0 RtnObj

	s InitFrLoc=PJObj.%Get("InitFrLoc")		//供应科室RowId
	s InitToLoc=PJObj.%Get("InitToLoc")		//请求科室RowId
	s ReqId=PJObj.%Get("ReqId")				//库存转移请求单RowId
	s OperateType=PJObj.%Get("OperateType")	//出库类型RowId
	s InitComp=PJObj.%Get("InitComp")		//"完成"标志
	s InitState=PJObj.%Get("InitState")		//单据状态
	s InitUser=PJObj.%Get("InitUser")		//制单人RowId
	s:InitUser="" InitUser=PJObj.%Get("gUserId")
	s InitScg=PJObj.%Get("InitScg")			//类组RowId
	s InitRemarks=PJObj.%Get("InitRemarks")
	s MemoDelim=..sssMemoDelim()
	s InitRemarks=$lfs(InitRemarks,MemoDelim)
	s InitIngr=PJObj.%Get("InitIngr")		//入库单id,依入库单转移时用到
	s InitReqUser=PJObj.%Get("InitReqUser")	//请求科室人员id
	s gHospId=PJObj.%Get("gHospId")
	s HospId=PJObj.%Get("Hospital")
	i HospId'="" s gHospId=HospId	//使用选择的医院ID

	i OperateType="" d
	.s OperDesc="正常出库",OperStkType="OM"
	.s OperateType=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",OperDesc,"DHC_OperateType",gHospId,OperStkType)

	i (InitScg="")&&(InitIngr'="") d
	.s InitScg=$p(^DHCINGR(InitIngr),"^",28)		;依入库单转移时用到

	i (InitScg="")&&(ReqId'="") d
	.&sql(select INRQ_RowId into :inrq from DHC_INRequest where INRQ_INRQ_DR=:ReqId)
	.q:inrq=""
	.s InitScg=$p(^DHCINRQ(inrq),"^",10)
	
	s Date=+$h
	s Time=$p($h,",",2)
	s StkType=..sssCode()
	s AppName=..%GetParameter("AppName")
	
	i Init="" d
	.s TrNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,InitScg,InitFrLoc)
	.i (TrNo<0)||(TrNo="") d
	..d RtnObj.Err(-2,"","单号生成失败:"_TrNo)
	.q:RtnObj.success<0
	.
	.s obj=##class(User.DHCInIsTrf).%New()
	.s obj.INITNo=TrNo
	.s obj.INITDate=Date
	.s obj.INITTime=Time
	.d obj.INITINGRDrSetObjectId(InitIngr)
	.d obj.INITINRQDRSetObjectId(ReqId)
	.s obj.INITStkType=StkType
	e  d
	.s obj=##class(User.DHCInIsTrf).%OpenId(Init)
	q:RtnObj.success'=0 RtnObj
	
	d obj.INITFrLocDRSetObjectId(InitFrLoc)
	d obj.INITToLocDRSetObjectId(InitToLoc)
	d obj.INITOperateTypeSetObjectId(OperateType)
	s obj.INITState=InitState
	d obj.INITSCGDRSetObjectId(InitScg)
	d obj.INITSSUSRDRSetObjectId(InitUser)
	s obj.INITUserCompleted=InitComp
	d obj.INITRemarks.Clear()
	d obj.INITRemarks.InsertList(InitRemarks)
	d obj.INITReqUserDRSetObjectId(InitReqUser)
	s sc=obj.%Save()
	i $$$ISERR(sc) q RtnObj.Err(-1,"","库存转移单保存失败:"_sc)
	
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// 取库存转移主表记录数据串
/// Creator:	wangjiabin
/// Date:2012-07-13
/// Argu:
///   init - 库存转移主表 RowId
/// Return:
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).Select(35)
ClassMethod Select(Init As %String) As %String
{
	n (Init)
	s result=""
	&sql(select INIT_RowId,INIT_AckDate,INIT_AcknowCompleted,INIT_AckTime,INIT_AckUser_DR,
		INIT_Date,INIT_FrLoc_DR,INIT_INRQ_DR,INIT_No,INIT_Remarks,
		INIT_SSUSR_DR,INIT_Time,INIT_ToLoc_DR,INIT_Type,INIT_UserCompleted,
		INIT_State,INIT_InAckDate,INIT_InAckTime,INIT_InAckUser_DR,INIT_IsTrf_DR,
		INIT_OperationRemark,INIT_OperateType,INIT_INGR_Dr,INIT_PrintFlag,INIT_SCG_DR,
		INIT_StkType,INIT_SCG_DR->SCG_Desc,INIT_FrLoc_DR->CTLoc_Desc,INIT_ToLoc_DR->CTLoc_Desc,INIT_AckUser_DR->SSUSR_Name,
		INIT_SSUSR_DR->SSUSR_Name
	into
		INITRowId,INITAckDate,INITAcknowCompleted,INITAckTime,INITAckUserDR,
		INITDate,FrLocId,ReqId,INITNo,INITRemarks,
		INITUser,INITTime,ToLocId,INITType,INITUserCompleted,
		INITState,INITInAckDate,INITInAckTime,INITInAckUserDR,INITIsTrfDR,
		INITOperationRemark,OperateType,INITINGRDr,INITPrintFlag,INITSCGDR,
		INITStkType,ScgDesc,FrLocDesc,ToLocDesc,INITAckUserName,
		INITUserName
	from dhc_inistrf where %id=:Init)
	q:SQLCODE'=0 "{}"
	s INITRemarks=$lts(INITRemarks,..sssMemoDelim())

	s INITDate=..DL2H(INITDate)
	s INITTime=..TL2H(INITTime)
	s FrLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocDesc)
	s ToLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ToLocDesc)
	
	s (ReqNo,ReqUser,ReqUserName,ReqRemark)=""
	i +ReqId'=0 d
	.s ReqNo=$p(^INRQ(ReqId),"^",1)
	.s ReqUser=$p(^INRQ(ReqId),"^",4)
	.s:ReqUser'="" ReqUserName=$p(^SSU("SSUSR",ReqUser),"^",2)
	.
	.&sql(SELECT INRQ_Remarks into:ReqRemark FROM IN_Request WHERE INRQ_RowId=:ReqId)
	.s ReqRemark=$LTS(ReqRemark,..sssMemoDelim())
	
	s OperateTypeDesc=""
	s:OperateType'="" OperateTypeDesc=$p(^DHCOPTYPE(OperateType),"^",2)
	
	s INITReqUserDR=$p(^DHCINIT(Init),"^",28),INITReqUserName=""
	i INITReqUserDR'="" d
	.s INITReqUserName=$p(^SSU("SSUSR",INITReqUserDR),"^",2)_"["_$p(^SSU("SSUSR",INITReqUserDR),"^",1)_"]"
	
	s FrLoc=..sssComboStr(FrLocId,FrLocDesc)
	s ToLoc=..sssComboStr(ToLocId,ToLocDesc)
	s OperateType=..sssComboStr(OperateType,OperateTypeDesc)
	s INITUser=..sssComboStr(INITUser,INITUserName)
	s InitReqUser=..sssComboStr(INITReqUserDR,INITReqUserName)
	s InitScg=..sssComboStr(INITSCGDR,ScgDesc)
	s DataStr=INITRowId_"^"_INITAckDate_"^"_INITAcknowCompleted_"^"_INITAckTime_"^"_INITAckUserDR
		_"^"_INITDate_"^"_FrLoc_"^"_ReqId_"^"_INITNo_"^"_INITRemarks
		_"^"_INITUser_"^"_INITTime_"^"_ToLoc_"^"_INITType_"^"_INITUserCompleted
		_"^"_INITState_"^"_INITInAckDate_"^"_INITInAckTime_"^"_INITInAckUserDR_"^"_INITIsTrfDR
		_"^"_INITOperationRemark_"^"_OperateType_"^"_INITINGRDr_"^"_INITPrintFlag_"^"_INITSCGDR
		_"^"_INITStkType_"^"_ReqNo_"^"_ReqId_"^"_ReqRemark_"^"_ScgDesc
		_"^"_INITAckUserName_"^"_InitReqUser
	
	s TitleStr="RowId^InitAckDate^InitAcknowCompleted^InitAckTime^InitAckUserDR"
		_"^InitDate^InitFrLoc^ReqId^InitNo^InitRemarks"
		_"^InitUser^InitTime^InitToLoc^InitType^InitComp"
		_"^InitState^InitInAckDate^InitInAckTime^InitInAckUserDR^InitIsTrfDR"
		_"^InitOperationRemark^OperateType^InitINGRDr^InitPrintFlag^InitScg"
		_"^InitStkType^ReqNo^ReqId^ReqRemark^ScgDesc"
		_"^InitAckUserName^InitReqUser"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

/// w ##class(web.DHCSTMHUI.DHCINIsTrf).jsDelete("{""RowId"":229}")
ClassMethod jsDelete(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".jsDelete"
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败").Json()
	s RowId=PJObj.%Get("RowId")
	s RtnObj=..Delete(RowId)
	q RtnObj.Json()
}

/// Return:		RtnObj.Json()
/// Description:删除库存转移主表记录
/// Creator:	wangjiabin
/// Date:		2018-09-04
/// Input:		Init
/// Output:		RtnObj
ClassMethod Delete(Init As %String) As RtnObj
{
	n (Init)
	
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	
	i Init="" q RtnObj.Err(-1,"",MethodName_"参数错误!")
	
	i ..lock(Init)<0 d RtnObj.Err(-99,Init,MethodName_":加锁失败")
	q:RtnObj.success<0 RtnObj
	
	s AllowDel=..AllowDel(Init)	;<0:不可删除, 0:物理删除, 1:逻辑删除(init_state置为99)
	i AllowDel<0 d RtnObj.Err(-2,Init,"不可删除","",0)
	i RtnObj.success<0 d ..uLock(Init) q RtnObj
	
	ts
	;先删除相关的高值跟踪信息
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).DelByPointer("T",Init)
	i RtnObj.success<0 tro  d ..uLock(Init)  q RtnObj

	;减去占用数量处理
	s ret=..HandleTransDirtyQty(Init,0)
	i ret'=0 d RtnObj.Err(-3,Init,MethodName_":处理占用数量错误")
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	;加回请求单在途
	s ret=..HandleTransResQty(Init,1)
	i ret'=0 d RtnObj.Err(-3,Init,MethodName_":处理请求在途数量错误")
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj

	;AllowDel="1 逻辑删除
	i AllowDel="1" d
	.&sql(update DHC_InIsTrfItm set INITI_INRQI_DR=null,INITI_INGRI_DR=null where INITI_INIT_ParRef=:Init)
	.i SQLCODE<0 d RtnObj.Err(-4,Init,MethodName_":处理DHC_InIsTrfItm单据失败,SQLOCDE:"_SQLCODE) q
	.&sql(update DHC_InIsTrf set INIT_State='99',INIT_INGR_Dr=null,INIT_INRQ_DR=null where %id=:Init)
	.i SQLCODE'=0 d RtnObj.Err(-5,Init,MethodName_":逻辑删除处理DHC_InIsTrf单据失败,SQLOCDE:"_SQLCODE) q
	e  d
	.&sql(delete from dhc_inistrf where %ID=:Init)
	.i SQLCODE'=0 d RtnObj.Err(-6,Init,MethodName_":处理DHC_InIsTrf单据失败,SQLOCDE:"_SQLCODE) q
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	
	tc
	d ..uLock(Init)
	q RtnObj
}

/// 是否允许删除
/// Author:zhwh
/// Date:2012-07-13
/// Argu:
///   init - 库存转移主表 RowId
/// Return:
///    >=0 - 可以, 其中: 0:物理删除,1:逻辑删除(废除单据,init_state置为99)
///    <0 - 不可以
/// 
ClassMethod AllowDel(init As %String) As %String
{
	n (init)
	s obj=##class(User.DHCInIsTrf).%OpenId(init)
	q:obj="" -3
	Do obj.%Reload()
	;
	s comp=obj.INITUserCompleted
	s status=obj.INITState
	s printFlag=obj.INITPrintFlag
	s frLoc=obj.INITFrLocDR.%Id()
	i comp="Y" q -1
	i (+status=11)!(+status=21)!(status=31)!(status=99) q -2

	s HospId=$p(^CTLOC(frLoc),"^",22)
	s Param="^"_frLoc_"^^"_HospId
	s AppName=..%GetParameter("AppName")
	s LogicalDelete=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"LogicalDelete",Param)
	;返回1, 逻辑删除
	q:(LogicalDelete="Y")&&((printFlag="Y")||(status'="10")) 1
	;返回0, 物理删除
	q 0
}

ClassMethod jsSetCompleted(Params As %String, AutoAuditFlag As %String) As %String
{
	n (Params,AutoAuditFlag)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".jsSetCompleted"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	s InitId=PJObj.%Get("RowId")
	s gGroupId=PJObj.%Get("gGroupId")
	
	s RtnObj=..SetCompleted(InitId,AutoAuditFlag,gGroupId)
	i RtnObj.success<0 q RtnObj.Json()
	
	s RtnObj.rowid=InitId
	q RtnObj.Json()
}

/// Description:设置库存转移单"完成"状态
/// Creator:	wangjiabin
/// Date:		2018-06-01
/// Input:		Init, AutoAuditFlag(自动审核标记 Y:自动审核,N:不自动审核,"":按参数设置), GroupId:安全组id
/// Output:		0 - SUccess, <0 -failure
ClassMethod SetCompleted(Init As %String, AutoAuditFlag As %String = "", GroupId As %String = "") As RtnObj
{
	n (Init,AutoAuditFlag,GroupId)
	s MethodName=$CLASSNAME()_".SetCompleted"
	s Err=0
	s RtnObj=##class(RtnObj).%New()
	i ..lock(Init)<0 q RtnObj.Err(-99,Init,"加锁失败")
	s State=$p(^DHCINIT(Init),"^",14)
	i (State=11) d ..uLock(Init) q RtnObj.Err(-1,Init,"已完成,不允许修改状态","",0)
	//已经审核，不允许再设置状态 //回退的单子,置为"未完成"状态
	i (State=21)||(State=31) d ..uLock(Init) q RtnObj.Err(-1,Init,"已审核,不允许修改状态","",0)
	s ErrInfo=..CheckDataValid(Init)
	i ErrInfo'="" d ..uLock(Init) q RtnObj.Err(-5,Init,MethodName_":"_ErrInfo)
	
	ts
	&sql(UPDATE dhc_inistrf set init_usercompleted='Y',init_state='11' where %ID=:Init)
	i SQLCODE'=0 d RtnObj.Err(-2,Init,MethodName_":设置状态失败,SQLCODE:"_SQLCODE_",msg:"_%msg)
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	
	s LocId=$p(^DHCINIT(Init),"^",5)		;出库科室
	s UserId=$p(^DHCINIT(Init),"^",8)
	s HospId=$p(^CTLOC(LocId),"^",22)
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Init,"ID",UserId,"T")
	
	//处理物流状态记录()
	s Req=$p($G(^DHCINIT(Init)),"^",7)
	i (Req'="") d
	.s MoveStatus="ID"  //init done
	.s Err=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(Req,MoveStatus,$zn,UserId)
	.i Err<0 d ..uLock(Init) d RtnObj.Err(-4,Init,MethodName_":物流状态处理失败")
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
		
	//是否进行出库审核
	s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s AppName=..%GetParameter("AppName")
	s AutoAckOut=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAckOutAfterCompleted",Params)
	i (AutoAuditFlag="Y")||((AutoAuditFlag="")&&(AutoAckOut="Y"))  d
	.s UseItmTrack=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName"),"UseItmTrack",Params)
	.s Label=""
	.i UseItmTrack="Y" d
	..s Label=##class(web.DHCSTMHUI.DHCItmTrack).CheckLabelsByPointer("T",Init)
	.i Label'="" d RtnObj.Err(-5,Init,Label_"没有录入条码或录入的条码数与入库数量不符!","",0)
	.q:RtnObj.success'=0
	.s RtnObj=..TransOutAuditYes(Init,UserId)
	.i RtnObj.success'=0 d RtnObj.Err(-3,Init,MethodName_":自动审核失败")
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	tc
	d ..uLock(Init)
	q RtnObj
}

ClassMethod jsCancelComplete(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".jsCancelComplete"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	s InitId=PJObj.%Get("RowId")
	
	s RtnObj=..CancelComplete(InitId)
	i RtnObj.success<0 q RtnObj.Json()
	
	s RtnObj.rowid=InitId
	q RtnObj.Json()
}

ClassMethod CancelComplete(Init As %String) As RtnObj
{
	n (Init)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".CancelComplete"
	i ..lock(Init)<0 q RtnObj.Err(-99,Init,"加锁失败")

	s State=$p(^DHCINIT(Init),"^",14)
	//已经审核，不允许再设置状态 //回退的单子,置为"未完成"状态
	i (State=21)||(State=31) d ..uLock(Init) q RtnObj.Err(-1,Init,"单据已审核,不允许修改状态!","",0)
	
	ts
	&sql(UPDATE dhc_inistrf set init_usercompleted='N',init_state='10' where %ID=:Init)
	i SQLCODE'=0 d RtnObj.Err(-2,Init,MethodName_":设置状态失败,SQLCODE:"_SQLCODE_",msg:"_%msg)
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(Init,"ID","T")
	tc
	
	d ..uLock(Init)
	q RtnObj
}

/// 对象类型数据
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).jsCreateTransferByReq(^tempxj(1),^tempxj(2))
ClassMethod jsCreateTransferByReq(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".jsCreateTransferByReq"
	s PJMainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJMainObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析失败")
	s LocId=PJMainObj.%Get("FrLocId")
	s GroupId=PJMainObj.%Get("gGroupId")
	s UserId=PJMainObj.%Get("gUserId")
	s HospId=PJMainObj.%Get("gHospId")
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s AppName=..%GetParameter("AppName")
	s IfMergeReq=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"IfMergeReq",Params)
	i IfMergeReq="Y" d
	.s RtnObj=..CreateTransferByReqNew(Main,Detail)
	e  d 
	.s RtnObj=..CreateTransferByReqOld(Main,Detail)
	q RtnObj.Json()
}

ClassMethod CreateTransferByReqOld(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".CreateTransferByReqOld"	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析失败")	
	ts
	s InitStrAll=""
	While(RtnObj.success=0)
	{
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s ReqId=Obj.%Get("RowId")
		s RtnObj=..CreateTransferByReq(Main,ReqId)
		continue:RtnObj.success<0
		s InitStr=RtnObj.rowid
		i InitStrAll="" d
		.s InitStrAll=InitStr
		e  d
		.s InitStrAll=InitStrAll_","_InitStr
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	s RtnObj.rowid=InitStrAll
	q RtnObj
}

ClassMethod CreateTransferByReqNew(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".CreateTransferByReqNew"	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析失败")
	s Pid=..NewPid()
	k ^TMPDHCSTM("ReqLoc",Pid)
	ts
	s InitStrAll=""
	While(RtnObj.success=0)
	{
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s ReqId=Obj.%Get("RowId")
		s ReqLoc=$p(^INRQ(ReqId),"^",6)
		continue:ReqLoc=""
		i $d(^TMPDHCSTM("ReqLoc",Pid,ReqLoc)) d
		.s ^TMPDHCSTM("ReqLoc",Pid,ReqLoc)=^TMPDHCSTM("ReqLoc",Pid,ReqLoc)_","_ReqId
		e  d
		.s ^TMPDHCSTM("ReqLoc",Pid,ReqLoc)=ReqId
	}
	s reqloc="",InitStrAll=""
	f  s reqloc=$o(^TMPDHCSTM("ReqLoc",Pid,reqloc)) q:((reqloc="")||(RtnObj.success<0))  d
	.s ReqIdstr=$g(^TMPDHCSTM("ReqLoc",Pid,reqloc))
	.s RtnObj=..CreateTransferByReqStr(Main,ReqIdstr,reqloc)
	.q:RtnObj.success<0
	.s InitStr=RtnObj.rowid
	.i InitStrAll="" d
	..s InitStrAll=InitStr
	.e  d
	..s InitStrAll=InitStrAll_","_InitStr
	i RtnObj.success<0 tro  q RtnObj
	tc
	s RtnObj.rowid=InitStrAll
	q RtnObj
}

/// Descript:	根据请求单生成出库单
/// Creator:	wangjiabin
/// CreateDate:	2018-06-19
/// Input:		Params({FrLocId:***,gUserId:***}), 请求单rowid, InrqiInfo([{InrqiId:"100||1",Qty:10},{InrqiId:"100||2",Qty:15}])
/// Output:		RtnObj
ClassMethod CreateTransferByReqStr(Params As %String, ReqIdstr As %String, ToLocId As %String) As RtnObj
{
	n (Params,ReqIdstr,ToLocId)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".CreateTransferByReqStr"
	i ReqIdstr="" q RtnObj.Err(-12,"",MethodName_"请求单ID不能为空","",0)
	s Pid=..NewPid()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析失败")
	s FrLocId=PJObj.%Get("FrLocId")
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s IsSplit="N"		//是否启动分流功能Y
	q:FrLocId="" RtnObj.Err(-10,"","供应科室不能为空","",0)
	q:ToLocId="" RtnObj.Err(-11,"","接收科室不能为空","",0)
	s HospId=$p(^CTLOC(FrLocId),"^",22)
	s AppName=..%GetParameter("AppName")
	s Param=GroupId_"^"_FrLocId_"^"_UserId
	s SeekBatMethod=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"SeekBatMethod",Param)
	//拆分类组的模式: 1-底层类组; 0-顶层类组; 其他-不区分类组
	s SplitReqScgMode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"SplitReqScgMode",Param)
	s StkGrpList=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),FrLocId,"",HospId)
	s OpTypeId=""
	&sql(select %id into :OpTypeId FROM dhc_operatetype
		WHERE IPT_Type ='OM' AND nvl(IPT_Default,'N')='Y'
	)
	s (xtype)=""
	&sql(select inrq_type into :xtype from DHC_INRequest where INRQ_INRQ_DR=:ReqId)
	k InReqScgArray
	s Len=$l(ReqIdstr,",")
	f i=1:1:Len  d
	.s ReqId=$p(ReqIdstr,",",i)
	.q:ReqId=""
	.s ReqComp=$p(^INRQ(ReqId),"^",8)
	.i ReqComp'="Y" d RtnObj.Err(-101,ReqId,"请求单未完成","",0)
	.q:RtnObj.success'=0
	.;1.这里根据请求单明细组织临时Array, 记录InReqScgArray(scg)=inrqi^inrqi^...
	.s Chl=0
	.f  s Chl=$o(^INRQ(ReqId,"RQI",Chl)) q:Chl=""  d
	..s Inrqi=ReqId_"||"_Chl
	..
	..s ReqStr=^INRQ(ReqId,"RQI",Chl)
	..s Inci=$p(ReqStr,"^",4)
	..
	..;根据个人授权过滤(按底层类组)
	..s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	..s ScgId=$p(ScgInfo,"^",5)
	..q:(StkGrpList'="")&&(("^"_StkGrpList_"^")'[("^"_ScgId_"^"))
	..
	..i SplitReqScgMode="1" d
	...s Scg=ScgId
	..e  i SplitReqScgMode="0" d
	...s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci,..sssCode(),0)
	...s Scg=$p(ScgInfo,"^",5)
	..e  d
	...s Scg="AllScg"
	..
	..i '$d(InReqScgArray(Scg)) d
	...s InReqScgArray(Scg)=Inrqi
	..e  d
	...s InReqScgArray(Scg)=InReqScgArray(Scg)_"^"_Inrqi
	q:RtnObj.success'=0 RtnObj
	tstart
	;2.根据临时数组内容拆分单据
	s Count=0
	s MainIdStr=""
	k ^TMPDHCSTM("ReqId",Pid)
	s ScgSub=""
	f  s ScgSub=$o(InReqScgArray(ScgSub)) q:(ScgSub="")||(RtnObj.success<0)  d
	.s StkGrpId=$s(+ScgSub>0:ScgSub,1:"")		//不按类组拆分时,将类组置空
	.s ReqId=""  ; 将出库主表的请求单rowid置空DHC_InIsTrfINRequestRelations取关联关系
    .s ReqUser=""
	.s Complete="N",Status="10",InitRemark=""
	.s MainData=FrLocId_"^"_ToLocId_"^"_ReqId_"^"_OpTypeId_"^"_Complete_"^"_Status_"^"_UserId_"^"_StkGrpId_"^"_InitRemark_"^"_ReqUser
	.s MainTitleStr="InitFrLoc^InitToLoc^ReqId^OperateType^InitComp^InitState^InitUser^InitScg^InitRemarks^InitReqUser"
	.s MainDataStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitleStr)
	.
	.s MainId=""		;这里先将主表rowid置空
	.s tmpScg=StkGrpId
	.if tmpScg="" s tmpScg="AllScg"
	.s InrqiStr=InReqScgArray(tmpScg)
	.s InrqiStrLen=$l(InrqiStr,"^")
	.f n=1:1:InrqiStrLen q:(RtnObj.success<0)  d
	..s Inrqi=$p(InrqiStr,"^",n)
	..s ReqId=+Inrqi,Chl=$p(Inrqi,"||",2)
	..s ^TMPDHCSTM("ReqId",Pid,ReqId)=""
	..s ReqStr=^INRQ(ReqId,"RQI",Chl)
	..s ReqQty=+$p(ReqStr,"^",3)
	..s InciDr=$p(ReqStr,"^",4) q:InciDr=""
	..s UomDr=+$p(ReqStr,"^",5)
	..s refuse=$P(ReqStr,"^",6) q:refuse="Y"	//排除掉"拒绝"的请求明细
	..s (INRQIType,INRQICanceled,qtyApproved,SpecDesc)=""
	..s dhcinrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,""))
	..i dhcinrqi'="" d
	...s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
	...s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
	...s qtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
	...s:qtyApproved="" qtyApproved=ReqQty
	...s SpecDesc=$p(^DHCINRQI(dhcinrqi),"^",6)
	..q:(IsSplit="Y")&&(INRQIType'=0)&&(xtype="C")  ;分流处理时候 去掉明细标志不是O的 O代表出库 C 计划
	..q:INRQICanceled="Y"
	..
	..s TransQty=##class(web.DHCSTMHUI.DHCINIsTrf).TransQty(Inrqi)   ;已转移数量
	..s BUomDr=$p(^INCI(InciDr,1),"^",10)
	..s PurUomDr=$p(^INCI(InciDr,3),"^",6)
	..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(+PurUomDr,+BUomDr)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomDr,BUomDr)
	..s NotTrQty=qtyApproved*Fac-TransQty    ;未转移数量(基本单位),按批准数量计算
	..q:NotTrQty'>0		;全部转移的明细过滤掉
	..
	..;如果请求单明细不为空时,按传入的量进行出库
	..i $d(TMPInrqiArray(Inrqi)) d
	...s NotTrQty=$p(TMPInrqiArray(Inrqi),"^",1)
	..
	..s pid=##class(web.DHCSTMHUI.DHCINIsTrfItm).GetInclbForTransfer(FrLocId,InciDr,NotTrQty,SeekBatMethod,SpecDesc)
	..i pid'="" d
	...;i '$d(^TMPGETINCLB(pid)) d RtnObj.Err(-6,"","没有满足出库条件的批次","",0) q
	...i '$d(^TMPGETINCLB(pid)) q
	...s Inclb=""
	...f  s Inclb=$o(^TMPGETINCLB(pid,Inclb)) q:(Inclb="")||(RtnObj.success<0)  d
	....s IncInfo=^TMPGETINCLB(pid,Inclb)
	....s Qty=$p(IncInfo,"^",7)
	....s Qty=Qty/Fac
	....s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomDr,HospId)
	....s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomDr,HospId)
	....s SpAmt=Sp*Qty
	....s RpAmt=Rp*Qty
	....s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	....s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	....s Remark=""
	....s Detail="^"_Inclb_"^"_Qty_"^"_UomDr_"^"_Inrqi_"^"_Remark_"^^"_SpecDesc_"^"_Sp
	....s DetailTitle="RowId^Inclb^Qty^UomId^Inrqi^Remark^Ingri^SpecDesc^Sp"
	....s DetailStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Detail,DetailTitle)
	....
	....;若MainId="",先保存主表(之前放在前面,可能有明细为空的情况)
	....i MainId="" d
	.....s RtnObj=..Update(MainDataStr)
	.....s MainId=RtnObj.rowid
	....q:RtnObj.success<0		;若主表保存失败,退出
	....
	....;保存明细
	....s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrfItm).Update(MainId,DetailStr)
	....q:RtnObj.success<0
	....s Initi=RtnObj.rowid
	....;增加新占用库存
	....s Ret=##class(web.DHCSTMHUI.DHCINIsTrf).HandleTransItmDirtyQty(Initi,1)  ;增加新占用库存
	....i Ret'=0 d RtnObj.Err(-6,Initi,"增加占用数量失败") q
	....
	....;清除请求单对应在途数
	....s Ret=##class(web.DHCSTMHUI.DHCINIsTrfItm).HandleTransItmResQty(Initi,0)
	....i Ret'=0 d RtnObj.Err(-7,Initi,"清除物资在途数失败") q
	....s Count=Count+1
	...k ^TMPGETINCLB(pid)
	.
	.;这里拼接根据类组生成的出库单rowid
	.q:MainId=""
	.s InTrReq=..UpdateInitReqRelation(MainId)
	.i InTrReq'=0  d RtnObj.Err(-101,Initi,"清除物资在途数失败") q
	.i MainIdStr="" d
	..s MainIdStr=MainId
	.e  d
	..s MainIdStr=MainIdStr_","_MainId
	i RtnObj.success<0 tro  q RtnObj
	
	i Count=0 d
	.d RtnObj.Err(-8,"","没有满足出库条件的批次","",0)
	i RtnObj.success<0 tro  q RtnObj
	i MainIdStr="" tro  q RtnObj.Err(-7,"","生成出库单失败")
 	s ReqId="" 
	//处理物流状态记录(portal)
	f  s ReqId=$o(^TMPDHCSTM("ReqId",Pid,ReqId)) q:((ReqId="")||(RtnObj.success'=0))  d
	.s MoveStatus="IS"		//init doneRtnObj.success'=0
	.s err=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(ReqId,MoveStatus,$zn,UserId)
	.i err<0 d RtnObj.Err(-8,"",MethodName_"处理物流状态失败")
	.q:RtnObj.success<0
	i RtnObj.success<0 tro  q RtnObj.Err(-8,"",MethodName_"处理物流状态失败")
	tc
	s RtnObj.rowid=MainIdStr
	q RtnObj
}

ClassMethod UpdateInitReqRelation(MainId As %String) As %String
{
	n (MainId)
	s ReqId="" 
	s err=0
    f  s ReqId=$o(^TMPREQID("ReqId",ReqId)) q:(ReqId="")  d
    .s ch=$o(^DHCITIR(MainId,"IR",""),-1)+1
    .&sql(insert  into DHC_InIsTrfINRequestRelations (ITIR_ISTR_Parref,ITIR_RequsetDR,ITIR_Childsub) values (:MainId,:ReqId,:ch))
	.i SQLCODE'=0  d
	..s err=-1
	q:err'=0 -2
	q 0
}

/// Descript:	根据请求单生成出库单
/// Creator:	wangjiabin
/// CreateDate:	2018-06-19
/// Input:		Params({FrLocId:***,gUserId:***}), 请求单rowid, InrqiInfo([{InrqiId:"100||1",Qty:10},{InrqiId:"100||2",Qty:15}])
/// Output:		RtnObj
ClassMethod CreateTransferByReq(Params As %String, ReqId As %String, InrqiInfo = "") As RtnObj
{
	n (Params,ReqId,InrqiInfo)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".CreateTransferByReq"
	i ReqId="" q RtnObj.Err(-12,"",MethodName_"参数错误")
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,ReqId,MethodName_"参数解析失败")
	s FrLocId=PJObj.%Get("FrLocId")
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s IsSplit="N"		//是否启动分流功能Y
	
	s PJItmObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJItmObj.%FromJSON(InrqiInfo)
	i Sc'=0 q RtnObj.Err(-1,ReqId,MethodName_" InrqiInfo参数解析失败")
	While(RtnObj.success=0)
	{
		s Obj=PJItmObj.%Pop()
		q:Obj=""
		s InrqiId=Obj.%Get("InrqiId")
		s Qty=Obj.%Get("Qty")
		continue:InrqiId=""
		s TMPInrqiArray(InrqiId)=Qty
	}
	
	s AppName=..%GetParameter("AppName")
	s Param=GroupId_"^"_FrLocId_"^"_UserId
	s SeekBatMethod=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"SeekBatMethod",Param)
	//拆分类组的模式: 1-底层类组; 0-顶层类组; 其他-不区分类组
	s SplitReqScgMode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"SplitReqScgMode",Param)

	s ReqUser=$p(^INRQ(ReqId),"^",4)
	s ToLocId=$p(^INRQ(ReqId),"^",6)
	s ReqComp=$p(^INRQ(ReqId),"^",8)
	q:ReqComp'="Y" RtnObj.Err(-101,ReqId,"请求单未完成","",0)
	q:FrLocId="" RtnObj.Err(-10,ReqId,"供应科室不能为空","",0)
	q:ToLocId="" RtnObj.Err(-11,ReqId,"接收科室不能为空","",0)
	s HospId=$p(^CTLOC(FrLocId),"^",22)
	s StkGrpList=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),FrLocId,"",HospId)
	
	s OpTypeId=""
	&sql(select %id into :OpTypeId FROM dhc_operatetype
		WHERE IPT_Type ='OM' AND nvl(IPT_Default,'N')='Y'
	)
	s (xtype)=""
	&sql(select inrq_type into :xtype from DHC_INRequest where INRQ_INRQ_DR=:ReqId)

	tstart
	k InReqScgArray
	;1.这里根据请求单明细组织临时Array, 记录InReqScgArray(scg)=inrqi^inrqi^...
	s Chl=0
	f  s Chl=$o(^INRQ(ReqId,"RQI",Chl)) q:Chl=""  d
	.s Inrqi=ReqId_"||"_Chl
	.q:(InrqiInfo'="")&&'$d(TMPInrqiArray(Inrqi))		;按请求单明细过滤
	.
	.s ReqStr=^INRQ(ReqId,"RQI",Chl)
	.s Inci=$p(ReqStr,"^",4)
	.
	.;根据个人授权过滤(按底层类组)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgId=$p(ScgInfo,"^",5)
	.q:(StkGrpList'="")&&(("^"_StkGrpList_"^")'[("^"_ScgId_"^"))
	.
	.i SplitReqScgMode="1" d
	..s Scg=ScgId
	.e  i SplitReqScgMode="0" d
	..s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci,..sssCode(),0)
	..s Scg=$p(ScgInfo,"^",5)
	.e  d
	..s Scg="AllScg"
	.
	.i '$d(InReqScgArray(Scg)) d
	..s InReqScgArray(Scg)=Inrqi
	.e  d
	..s InReqScgArray(Scg)=InReqScgArray(Scg)_"^"_Inrqi
	
	;2.根据临时数组内容拆分单据
	s Count=0
	s MainIdStr=""
	s ScgSub=""
	f  s ScgSub=$o(InReqScgArray(ScgSub)) q:(ScgSub="")||(RtnObj.success<0)  d
	.s StkGrpId=$s(+ScgSub>0:ScgSub,1:"")		//不按类组拆分时,将类组置空
	.s Complete="N",Status="10",InitRemark=""
	.s MainData=FrLocId_"^"_ToLocId_"^"_ReqId_"^"_OpTypeId_"^"_Complete_"^"_Status_"^"_UserId_"^"_StkGrpId_"^"_InitRemark_"^"_ReqUser
	.s MainTitleStr="InitFrLoc^InitToLoc^ReqId^OperateType^InitComp^InitState^InitUser^InitScg^InitRemarks^InitReqUser"
	.s MainDataStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitleStr)
	.
	.s MainId=""		;这里先将主表rowid置空
	.;s Ret=..Update("",MainData)		;将主表的保存,放在处理明细的地方
	.s tmpScg=StkGrpId
	.if tmpScg="" s tmpScg="AllScg"
	.s InrqiStr=InReqScgArray(tmpScg)
	.s InrqiStrLen=$l(InrqiStr,"^")
	.f n=1:1:InrqiStrLen q:(RtnObj.success<0)  d
	..s Inrqi=$p(InrqiStr,"^",n)
	..s ReqId=+Inrqi,Chl=$p(Inrqi,"||",2)
	..s ReqStr=^INRQ(ReqId,"RQI",Chl)
	..s ReqQty=+$p(ReqStr,"^",3)
	..s InciDr=$p(ReqStr,"^",4) q:InciDr=""
	..s UomDr=+$p(ReqStr,"^",5)
	..s refuse=$P(ReqStr,"^",6) q:refuse="Y"	//排除掉"拒绝"的请求明细
	..s (INRQIType,INRQICanceled,qtyApproved,SpecDesc)=""
	..s dhcinrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,""))
	..i dhcinrqi'="" d
	...s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
	...s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
	...s qtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
	...s:qtyApproved="" qtyApproved=ReqQty
	...s SpecDesc=$p(^DHCINRQI(dhcinrqi),"^",6)
	..q:(IsSplit="Y")&&(INRQIType'=0)&&(xtype="C")  ;分流处理时候 去掉明细标志不是O的 O代表出库 C 计划
	..q:INRQICanceled="Y"
	..
	..s TransQty=##class(web.DHCSTMHUI.DHCINIsTrf).TransQty(Inrqi)   ;已转移数量
	..s BUomDr=$p(^INCI(InciDr,1),"^",10)
	..s PurUomDr=$p(^INCI(InciDr,3),"^",6)
	..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(+PurUomDr,+BUomDr)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomDr,BUomDr)
	..s NotTrQty=qtyApproved*Fac-TransQty    ;未转移数量(基本单位),按批准数量计算
	..q:NotTrQty'>0		;全部转移的明细过滤掉
	..
	..;如果请求单明细不为空时,按传入的量进行出库
	..i $d(TMPInrqiArray(Inrqi)) d
	...s NotTrQty=$p(TMPInrqiArray(Inrqi),"^",1)
	..
	..s pid=##class(web.DHCSTMHUI.DHCINIsTrfItm).GetInclbForTransfer(FrLocId,InciDr,NotTrQty,SeekBatMethod,SpecDesc)
	..i pid'="" d
	...;i '$d(^TMPGETINCLB(pid)) d RtnObj.Err(-6,"","没有满足出库条件的批次") q
	...i '$d(^TMPGETINCLB(pid)) q
	...s Inclb=""
	...f  s Inclb=$o(^TMPGETINCLB(pid,Inclb)) q:(Inclb="")||(RtnObj.success<0)  d
	....s IncInfo=^TMPGETINCLB(pid,Inclb)
	....s Qty=$p(IncInfo,"^",7)
	....s Qty=Qty/Fac
	....s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomDr,HospId)
	....s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomDr,HospId)
	....s SpAmt=Sp*Qty
	....s RpAmt=Rp*Qty
	....s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	....s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	....s Remark=""
	....s Detail="^"_Inclb_"^"_Qty_"^"_UomDr_"^"_Inrqi_"^"_Remark_"^^"_SpecDesc_"^"_Sp
	....s DetailTitle="RowId^Inclb^Qty^UomId^Inrqi^Remark^Ingri^SpecDesc^Sp"
	....s DetailStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Detail,DetailTitle)
	....
	....;若MainId="",先保存主表(之前放在前面,可能有明细为空的情况)
	....i MainId="" d
	.....s RtnObj=..Update(MainDataStr)
	.....s MainId=RtnObj.rowid
	....q:RtnObj.success<0		;若主表保存失败,退出
	....
	....;保存明细
	....s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrfItm).Update(MainId,DetailStr)
	....q:RtnObj.success<0
	....s Initi=RtnObj.rowid
	....;增加新占用库存
	....s Ret=##class(web.DHCSTMHUI.DHCINIsTrf).HandleTransItmDirtyQty(Initi,1)  ;增加新占用库存
	....i Ret'=0 d RtnObj.Err(-6,Initi,"增加占用数量失败") q
	....
	....;清除请求单对应在途数
	....s Ret=##class(web.DHCSTMHUI.DHCINIsTrfItm).HandleTransItmResQty(Initi,0)
	....i Ret'=0 d RtnObj.Err(-7,Initi,"清除物资在途数失败") q
	....s Count=Count+1
	...k ^TMPGETINCLB(pid)
	.
	.;这里拼接根据类组生成的出库单rowid
	.q:MainId=""
	.i MainIdStr="" d
	..s MainIdStr=MainId
	.e  d
	..s MainIdStr=MainIdStr_","_MainId
	i RtnObj.success<0 tro  q RtnObj
	
	i Count=0 d
	.d RtnObj.Err(-8,"","没有满足出库条件的批次","",0)

	i RtnObj.success<0 tro  q RtnObj
	i MainIdStr="" tro  q RtnObj.Err(-7,"","生成出库单失败")

	//处理物流状态记录(portal)
	s MoveStatus="IS"		//init done
	s err=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(ReqId,MoveStatus,$zn,UserId)
	i err<0 tro  q RtnObj.Err(-8,"",MethodName_"处理物流状态失败")
	
	tc
	s RtnObj.rowid=MainIdStr
	q RtnObj
}

/// 批量审核
/// Author:XuChao
/// Date: 2015-0720
/// Return:	总数量 成功数量
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).jsTransOutAuditYesStr("31","6423","277","")
ClassMethod jsTransOutAuditYesStr(InitStr As %String, UserId As %String, GroupId As %String, AutoAuditInFlag As %String) As %String
{
	n (InitStr,UserId,GroupId,AutoAuditInFlag)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s del="^"
	s success=0
	s RetInitStr="",ErrMsg=""
	s len=$l(InitStr,del)
	f i=1:1:len  d
	.s Init=$p(InitStr,del,i)
	.s RtnObj=..TransOutAuditYes(Init,UserId,GroupId,AutoAuditInFlag)
	.i RtnObj.success=0 d
	..s success=success+1
	..i RetInitStr="" d
	...s RetInitStr=Init
	..e  d
	...s RetInitStr=RetInitStr_"^"_Init
	.e  d
	..s msginfo=Init_":"_RtnObj.msg
	..i ErrMsg="" d
	...s ErrMsg= msginfo
	..e  d
	...s ErrMsg=ErrMsg_"#"_msginfo
	s RtnObj.success=0
	s RtnObj.msg=RetInitStr_","_len_","_success_","_ErrMsg
	q RtnObj.Json()
}

/// Descript:	设置库存转移单“出库审核通过”状态
/// Creator:	wanajiabin
/// CreateDate:	2018-06-01
/// Input:		Init, UserId, GroupId, AutoAuditInFlag(自动审核标志,Y:自动接收,N:不自动接收,"":按参数设置)
/// Output:		RtnObj信息串
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes("13","6423","277","").Json()
ClassMethod TransOutAuditYes(Init As %String, UserId As %String, GroupId As %String = "", AutoAuditInFlag As %String = "") As RtnObj
{
	n (Init,UserId,GroupId,AutoAuditInFlag)
	s AppName=..%GetParameter("AppName")
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".TransOutAuditYes"
	i ..lock(Init)<0 q RtnObj.Err(-99,Init,MethodName_":加锁失败")
	
	s State=""
	&sql(select init_state into :State from dhc_inistrf where %ID=:Init)
	i State'="11" d ..uLock(Init) q RtnObj.Err(-100,Init,MethodName_":状态不符")
	
	s ErrInfo=..CheckDataValid(Init)
	i ErrInfo'="" d ..uLock(Init) q RtnObj.Err(-101,Init,MethodName_":"_ErrInfo)
	
	s FrLoc=$p(^DHCINIT(Init),"^",5)	;出库科室
	s ToLoc=$p(^DHCINIT(Init),"^",6)	;接收科室
	
	s newStatus="21"
	s d=+$h,t=$p($h,",",2)
	ts
	&sql(UPDATE dhc_inistrf
		set init_state=:newStatus,init_ackdate=:d,init_acktime=:t,init_ackuser_dr=:UserId 
		where %ID=:Init)
	i SQLCODE'=0 tro  d ..uLock(Init) q RtnObj.Err(-1,Init,MethodName_",SQLCODE:"_SQLCODE_",%msg:"_$g(%msg))
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Init,"IO",UserId,"T")

	//处理库存(转出), 台账, 占用数
	s InitNo=$p(^DHCINIT(Init),"^",1)
	s Ch=0
	f  s Ch=$o(^DHCINIT(Init,"ITI",Ch)) q:(Ch="")!(RtnObj.success<0)  d
	.s Initi=Init_"||"_Ch
	.s InitiInfo=^DHCINIT(Init,"ITI",Ch)
	.s initiStatus=$p(InitiInfo,"^",23)
	.q:(initiStatus="21")||(initiStatus="31")
	.
	.s inclb=$p(InitiInfo,"^",3)
	.s qty=$p(InitiInfo,"^",1)
	.s trqty=qty
	.s uom=$p(InitiInfo,"^",7)
	.s inci=+inclb
	.s buom=$P(^INCI(inci,1),"^",10)
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s qty=qty*fac
	.s rp=$p(InitiInfo,"^",15)
	.s rpAmt=$p(InitiInfo,"^",16)
	.s sp=$p(InitiInfo,"^",17)
	.s spAmt=$p(InitiInfo,"^",18)
	.//处理库存
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,-qty)
	.i ret<0 d RtnObj.Err(-3,Initi,MethodName_":处理库存失败") q 
	.
	.s trData="T"_"^"_InitNo_"^"_inclb_"^"_-trqty_"^"_uom
	.s trData=trData_"^"_sp_"^"_UserId_"^"_Initi_"^"_rp_"^"_-rpAmt
	.s trData=trData_"^"_-spAmt
	.//插入台账
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(trData)
	.i RtnObj.success'=0 d RtnObj.Err(-4,Initi,MethodName_":插入台帐失败") q 
	.
	.//更新子表记录状态
	.&sql(update dhc_inistrfitm set dhciti_state=:newStatus where %ID=:Initi)
	.i SQLCODE'=0 d RtnObj.Err(-5,Initi,MethodName_":更新子表状态失败") q
	.
	.//处理批次dirtyQty
	.s ret=..HandleTransItmDirtyQty(Initi,0)
	.i ret<0 d RtnObj.Err(-6,Initi,MethodName_":处理占用数失败") q 
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	
	s Params=GroupId_"^"_FrLoc_"^"_UserId
	
	s LocId=$p(^DHCINIT(Init),"^",6)			;接收科室
	s AckInUserId=$p(^DHCINIT(Init),"^",17)		;接收人
	s Params="^"_LocId_"^"_AckInUserId
	s AutoAckIn=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAckInAfterAckOut",Params)
	//被服类出库审核后是否自动入库审核
	s Params="^"_FrLoc		//AutoAckInByOut针对于出库方，推荐按照科室配置
	s AutoAckInByOut=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAckInByOut",Params)
	i (AutoAuditInFlag="Y")||((AutoAuditInFlag="")&&((AutoAckIn="Y")||(AutoAckInByOut="Y"))) d
	.s RtnObj=..TransInAuditYes(Init,UserId)
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj

	//处理请求单的物流状态记录
	s ReqId=$p($G(^DHCINIT(Init)),"^",7)
	i ReqId'="" d
	.s MoveStatus="IO"  //init out audit
	.s ret=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(ReqId,MoveStatus,$zn,UserId)
	.i ret<0 d RtnObj.Err(-8,Init,MethodName_":请求单物流状态记录错误")
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj

	tc
	d ..uLock(Init)
	q RtnObj
}

/// Descript:	转移出库审核不通过
/// Creator:	wanajiabin
/// CreateDate:	2018-06-07
/// Input:		Init, UserId
/// Output:		RtnObj信息串
ClassMethod jsTransOutAuditNoStr(InitStr As %String, UserId As %String) As %String
{
	n (InitStr,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s del="^"
	s sucess=0
	s ret=""
	s len=$l(InitStr,del)
	f i=1:1:len  d
	.s Init=$p(InitStr,del,i)
	.s RtnObj=..TransOutAuditNo(Init,UserId)
	.i RtnObj.success=0 d
	..s sucess=sucess+1
	..i ret="" d
	...s ret=Init
	..e  d
	...s ret=ret_"^"_Init
	s RtnObj.msg=ret_","_len_","_sucess

	q RtnObj.Json()
}

/// Descript:	转移出库审核不通过
/// Creator:	wanajiabin
/// CreateDate:	2018-06-07
/// Input:		Init, UserId
/// Output:		RtnObj信息串
ClassMethod TransOutAuditNo(Init As %String, UserId As %String) As RtnObj
{
	n (Init,UserId)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".TransOutAuditNo"
	i ..lock(Init)<0 q RtnObj.Err(-99,Init,"加锁失败")

	//检查状态
	s State=""
	&sql(select init_state into :State from dhc_inistrf where %ID=:Init)
	i (State'="11")&&(State'="30") d ..uLock(Init) q RtnObj.Err(-100,Init,MethodName_":单据状态有误")
	
	ts
	s NewState="20"
	s d=+$h,t=$p($h,",",2)
	&sql(UPDATE dhc_inistrf
		set init_state=:NewState,init_usercompleted='N', init_ackdate=:d,init_acktime=:t,init_ackuser_dr=:UserId 
		where %ID=:Init)
	i SQLCODE'=0 tro  d ..uLock(Init) q RtnObj.Err(-1,Init,MethodName_":修改dhc_inistrf状态失败,SQLCODE:"_SQLCODE)
	&sql(update dhc_inistrfitm
		set dhciti_state=:NewState
		where initi_init_parref=:Init)
	i SQLCODE'=0 tro  d ..uLock(Init) q RtnObj.Err(-2,Init,MethodName_":修改dhc_inistrfitm状态失败,SQLCODE:"_SQLCODE)

	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(Init,"ID","T")

	//处理请求单的物流状态记录(portal)
	s ReqId=$p($G(^DHCINIT(Init)),"^",7)
	i ReqId'="" d
	.s MoveStatus="IIR"		//init out audit
	.s ret=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(ReqId,MoveStatus,$zn,UserId)
	.i ret<0 d RtnObj.Err(-8,Init,MethodName_":处理物流状态失败")
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	
	tc
	d ..uLock(Init)
	q RtnObj
}

/// 批量入库接收
/// Author:zhangxiao
/// Date: 20201009
/// Return:	总数量 成功数量
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).jsTransInAuditYesStr(197,4642,264,"Y")
ClassMethod jsTransInAuditYesStr(InitStr As %String, UserId As %String) As %String
{
	n (InitStr,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()

	s del="^"
	s success=0
	s RetInitStr=""
	s len=$l(InitStr,del)
	f i=1:1:len  d
	.s Init=$p(InitStr,del,i)
	.s RtnObj=..TransInAuditYes(Init,UserId)
	.i RtnObj.success=0 d
	..s success=success+1
	..i RetInitStr="" d
	...s RetInitStr=Init
	..e  d
	...s RetInitStr=RetInitStr_"^"_Init
	;仅显示成功条数,暂不提示具体信息
	s RtnObj.success=0
	s RtnObj.msg=RetInitStr_","_len_","_success
	q RtnObj.Json()
}

/// Descript:	转移入库审核
/// Creator:	wanajiabin
/// CreateDate:	2018-06-05
/// Input:		Init, UserId
/// Output:		RtnObj信息串
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).jsTransInAuditYes(177,4642)
ClassMethod jsTransInAuditYes(Init As %String, UserId As %String) As %String
{
	n (Init,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..TransInAuditYes(Init,UserId)
	q RtnObj.Json()
}

/// Descript:	转移入库审核
/// Creator:	wanajiabin
/// CreateDate:	2018-06-05
/// Input:		Init, UserId
/// Output:		RtnObj信息串
ClassMethod TransInAuditYes(Init As %String, UserId As %String) As RtnObj
{
	n (Init,UserId)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".TransInAuditYes"
	i ..lock(Init)<0 q RtnObj.Err(-99,Init,"加锁失败")  

	//检查状态
	s status=""
	&sql(select init_state into :status from dhc_inistrf where %ID=:Init)
	i status'="21" d ..uLock(Init) q RtnObj.Err(-100,Init,"单据状态错误")
	
	ts
	s newStatus="31"
	s d=+$h,t=$p($h,",",2)
	&sql(UPDATE dhc_inistrf
		set init_state=:newStatus,init_inackdate=:d,init_inacktime=:t,init_inackuser_dr=:UserId 
		where %ID=:Init)
	i SQLCODE'=0 tro  d ..uLock(Init) q RtnObj.Err(-1,Init,MethodName_":修改dhc_inistrf失败,SQLCODE:"_SQLCODE_",%msg:"_$g(%msg))
	&sql(update dhc_inistrfitm set dhciti_state=:newStatus where initi_init_parref=:Init)
	i SQLCODE'=0 tro  d ..uLock(Init) q RtnObj.Err(-2,Init,MethodName_":修改dhc_inistrfitm失败,SQLCODE:"_SQLCODE_",%msg:"_$g(%msg))

	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Init,"II",UserId,"T")
	
	//处理库存,台账记录
	s InitNo=$p(^DHCINIT(Init),"^",1)
	s Ch=0
	f  s Ch=$o(^DHCINIT(Init,"ITI",Ch)) q:(Ch="")||(RtnObj.success<0)  d
	.s Initi=Init_"||"_Ch
	.s InitiInfo=^DHCINIT(Init,"ITI",Ch)
	.s inclb=$p(InitiInfo,"^",3)
	.s toInclb=..GetToLocINCLB(Initi)			//取入方科室的库存批次rowid
	.s qty=$p(InitiInfo,"^",1)
	.s trqty=qty
	.s uom=$p(InitiInfo,"^",7)
	.s inci=+inclb
	.s buom=$p(^INCI(inci,1),"^",10)
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s qty=qty*fac
	.s rp=$p(InitiInfo,"^",15)
	.s rpAmt=$p(InitiInfo,"^",16)
	.s sp=$p(InitiInfo,"^",17)
	.s spAmt=$p(InitiInfo,"^",18)
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(toInclb,qty)
	.i ret<0 d RtnObj.Err(-3,Initi,MethodName_":处理库存失败") q 
	.
	.s trData="K"_"^"_InitNo_"^"_toInclb_"^"_+trqty_"^"_uom
	.s trData=trData_"^"_+sp_"^"_UserId_"^"_Initi_"^"_+rp_"^"_+rpAmt
	.s trData=trData_"^"_+spAmt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(trData)
	.i RtnObj.success'=0 d RtnObj.Err(-4,Initi,MethodName_":处理台帐失败") q 
	.
	.;处理高值条码
	.s barcode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("T",Initi)
	.i (barcode'="") d
	..s loc=$p(^DHCINIT(Init),"^",6)
	..s operData=loc_"^"_UserId_"^^^^"_toInclb
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("K",Initi,barcode,operData)
	.q:RtnObj.success<0
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	
	//处理请求单的物流状态记录(portal)
	s ReqId=$p($G(^DHCINIT(Init)),"^",7)
	i ReqId'="" d
	.s MoveStatus="II"  //init in audit
	.s ret=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(ReqId,MoveStatus,$zn,UserId)
	.i ret<0 d RtnObj.Err(-6,Init,MethodName_":处理物流信息失败")
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj
	
	//处理科室额度
	s RtnObj=##class(web.DHCSTMHUI.LocLimitAmt).UpLocUsedAmt(Init)
	i RtnObj.success'=0 tro  d ..uLock(Init) q RtnObj
	
	;2018-08-26 add 高值出库接收时特殊处理
	s ret=..HandleHVByInit(Init)
	i ret'="" d RtnObj.Err(-8,Init,ret_":高值条码科室处理失败")
	i RtnObj.success'=0 tro  d ..uLock(Init) q RtnObj

	d ..uLock(Init)
	tc
	s LocId=$p(^DHCINIT(Init),"^",6)
	s HospId=..sssHospId(LocId)
	job ##class(web.DHCSTMHUI.ServiceForLis).CreateLisBarCode(Init,HospId)
	
	q RtnObj
}

/// CreatDate:	2018-08-26
/// Description:转移入库接收时,针对暂存库调拨的特殊处理
/// Input:		主表rowid
/// Return:		"":不需处理或处理成功, 非空:错误信息
ClassMethod HandleHVByInit(Init)
{
	n (Init)
	q:Init="" ""
	s InitToLoc=$p(^DHCINIT(Init),"^",6)
	/*
	&sql(select dhcloc_mainloc_dr into :MainLoc From SQLUser.DHCST_CtLoc
		where dhcloc_ctloc_dr=:InitToLoc
	)
	q:(SQLCODE=100)||($g(MainLoc)="") ""		;不是暂存库的,不做处理
	*/
	s LocGrp=##class(web.DHCSTMHUI.Common.UtilCommon).GetLocGrpItm(InitToLoc)
	q:LocGrp'="高值暂存库" ""					;不是暂存库的,不做处理
	
	
	s Ret=""
	s Ch=0
	f  s Ch=$o(^DHCINIT(Init,"ITI",Ch)) q:(Ch="")||(Ret'="")  d
	.s Initi=Init_"||"_Ch
	.s DHCIT=$o(^DHCITD(0,"Type","K","Pointer",Initi,0))
	.q:DHCIT=""
	.s Obj=##class(User.DHCItmTrack).%OpenId(DHCIT)
	.d Obj.DHCITCurrentLocSetObjectId(InitToLoc)
	.s Sc=Obj.%Save()
	.i $$$ISERR(Sc) s Ret=Initi_"处理失败" q
	q Ret
}

/// Descript:	转移入库接收不通过
/// Creator:	zhangxiao
/// CreateDate:	20201009
/// Input:		InitStr, UserId
/// Output:		RtnObj信息串
ClassMethod jsTransInAuditNoStr(InitStr As %String, UserId As %String) As %String
{
	n (InitStr,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	
	s del="^"
	s sucess=0
	s ret=""
	s len=$l(InitStr,del)
	f i=1:1:len  d
	.s Init=$p(InitStr,del,i)
	.s RtnObj=..TransInAuditNo(Init,UserId)
	.i RtnObj.success=0 d
	..s sucess=sucess+1
	..i ret="" d
	...s ret=Init
	..e  d
	...s ret=ret_"^"_Init
	;仅显示成功条数,暂不提示具体信息
	s RtnObj.success=0
	s RtnObj.msg=ret_","_len_","_sucess

	q RtnObj.Json()
}

/// Descript:	转移入库 - 拒绝单据
/// Creator:	wanajiabin
/// CreateDate:	2018-06-07
/// Input:		Init, UserId
/// Output:		RtnObj信息串
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).jsTransInAuditNo(177,4642)
ClassMethod jsTransInAuditNo(Init As %String, UserId As %String) As %String
{
	n (Init,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..TransInAuditNo(Init,UserId)
	q RtnObj.Json()
}

/// Descript:	转移入库 - 拒绝单据
/// Creator:	wanajiabin
/// CreateDate:	2018-06-07
/// Input:		Init, UserId
/// Output:		RtnObj
ClassMethod TransInAuditNo(Init As %String, UserId As %String) As RtnObj
{
	n (Init,UserId)
	s RtnObj=##class(RtnObj).%New()
	s AppName=..%GetParameter("AppName")
	s MethodName=$CLASSNAME()_".TransInAuditNo"
	i ..lock(Init)<0 q RtnObj.Err(-99,Init,"加锁失败")  

	//检查状态
	s (status,frloc)=""
	&sql(select init_state,INIT_FrLoc_DR,INIT_AckDate
		into :status,:frloc,:ackDate
		from dhc_inistrf where %ID=:Init)
	i status'="21" d ..uLock(Init) q RtnObj.Err(-100,Init,"单据状态不符","",0)
	i (+$h)-ackDate>30 d ..uLock(Init) q RtnObj.Err(-101,Init,"单据超期,不允许拒绝","",0)
	s isMon=..IfMakeMon(Init)
	i isMon=1 d ..uLock(Init) q RtnObj.Err(-102,Init,"出库方已做月报,不允许拒绝","",0)
	s Param="^"_frloc_"^"
	s CrossMonInAuditNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"CrossMonInAuditNo",Param)
	s CrossMonFlag=..IfCrossMon(Init)
	i (CrossMonInAuditNo="Y")&&(CrossMonFlag=1) d ..uLock(Init) q RtnObj.Err(-103,Init,"单据已跨月,不允许拒绝","",0)
	ts
	s newStatus="30"
	s d=+$h,t=$p($h,",",2),Completed="N"
	&sql(UPDATE dhc_inistrf
		set init_state=:newStatus,INIT_UserCompleted=:Completed,init_inackdate=:d,init_inacktime=:t,init_inackuser_dr=:UserId
		where %ID=:Init)
	i SQLCODE'=0 tro  d ..uLock(Init) q -1
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Init,"IIR",UserId,"T")

	//回退出方的库存和台账
	s type="T"
	s Ch=0
	f  s Ch=$o(^DHCINIT(Init,"ITI",Ch)) q:(Ch="")||(RtnObj.success<0)  d
	.s Initi=Init_"||"_Ch
	.s status=$p(^DHCINIT(Init,"ITI",Ch),"^",23)
	.q:status'="21"
	.//恢复库存，清除台账
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs(type,Initi)
	.i ret<0 d RtnObj.Err(-3,Initi,MethodName_":清除台帐失败") q
	.//恢复占用数量
	.s ret=..HandleTransItmDirtyQty(Initi,1)
	.i ret<0 d RtnObj.Err(-4,Initi,MethodName_":恢复占用数据失败")  q 
	.&sql(update dhc_inistrfitm set dhciti_state=:newStatus where %ID=:Initi)
	.i SQLCODE'=0 d RtnObj.Err(-5,Initi,MethodName_":修改dhc_inistrfitm状态失败") q
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj

	//处理请求单的物流状态记录(protal)
	s ReqId=$p($G(^DHCINIT(Init)),"^",7)
	i ReqId'="" d
	.s MoveStatus="IIR"  //Init In Refused
	.s ret=##class(web.DHCSTMHUI.Common.Logistics).CreateReqMoveStatus(ReqId,MoveStatus,$zn,UserId)
	.i ret<0 d RtnObj.Err(-8,Init,MethodName_":请求单物流状态处理失败") q
	i RtnObj.success<0 tro  d ..uLock(Init) q RtnObj

	tc
	d ..uLock(Init)
	q RtnObj
}

/// 库存转移单解锁
/// Date:2012-07-13
/// Argu:
///   init - 库存转移主表 RowId
/// Return:
///   0 - success
///   <0 - failure
ClassMethod lock(init As %String) As %String
{
	q:init="" 0
	s AppName=..%GetParameter("AppName")
	q ##class(web.DHCSTMHUI.Common.AppCommon).Lock(AppName_init)
}

/// 库存转移单解锁
/// Date:2012-07-13
/// Argu:
///   init - 库存转移主表 RowId
ClassMethod uLock(init As %String)
{
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_init)
	q
}

/// 处理占用数量(整单)
/// Date:2012-07-13
/// Argu:
///   init - 库存转移主表 RowId
///   sign - 处理符号
/// Return:
///  0 - success
///  <0 -failure
ClassMethod HandleTransDirtyQty(init As %String, sign As %String) As %String
{
	s err=0
	//tstart
	s ch=0
	;
	f  s ch=$o(^DHCINIT(init,"ITI",ch))  q:(ch="")!(err<0)  d
	.s initi=init_"||"_ch
	.
	.s err=..HandleTransItmDirtyQty(initi,sign)
	.
	//i err<0 trollback
	//tcommit
	q err
}

/// 处理请求单在途数量(整单)
/// Date:2017-03-27
/// Argu:
///   init - 库存转移主表 RowId
///   sign - 处理符号(1:加, 0:减)
/// Return:
///  0 - success
///  <0 -failure
ClassMethod HandleTransResQty(init As %String, sign As %String) As %String
{
	n (init,sign)
	s err=0
	s ch=0
	f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:(ch="")!(err'=0)  d
	.s initi=init_"||"_ch
	.s err=##class(web.DHCSTMHUI.DHCINIsTrfItm).HandleTransItmResQty(initi,sign)
	.q:err'=0
	q err
}

/// 处理库存转移明细记录的占用数量
/// Date:2012-07-13
/// Argu:
///   initi - 库存转移子表 RowId
///   sign- 处理符号(1 - 加  0 - 减)
/// Return:
///  0 - success
///  <0 -failure
ClassMethod HandleTransItmDirtyQty(initi As %String, sign As %String) As %String
{
	n (initi,sign)
	s obj=##class(User.DHCInIsTrfItm).%OpenId(initi)
	d obj.%Reload()
	s inclb=obj.INITIINCLBDR.%Id()
	s qty=obj.INITIQty
	s uom=obj.INITICTUOMDR.%Id()
	s buom=$p(^INCI(+inclb,1),"^",10)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	s qty=qty*fac    ;基本单位对应的数量
	i sign="0" s qty=-qty  //回退
	s err=##class(web.DHCSTMHUI.Common.StockHandle).UpdateDirtyQty(inclb,qty)
	q err
}

/// 根据库存转移单明细得出入方的批次
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///  initi  - 库存转移单明细rowid
/// Return:
///  入方的批次rowid
///  
ClassMethod GetToLocINCLB(initi As %String) As %String
{
	n (initi)
	s init=+initi
	s ch=$P(initi,"||",2)
	s toLocDR= $p(^DHCINIT(init),"^",6)
	s ProvLocInclb=$P(^DHCINIT(init,"ITI",ch),"^",3)
	q:ProvLocInclb="" -1
	s inci="",incilsub="",inclbsub="",incib=""
	s ibsub="",batno="",expdate="",inclb=""
	s inci=$p(ProvLocInclb,"||",1)  q:inci="" -1
	s incilsub=$p(ProvLocInclb,"||",2) q:incilsub="" -1
	s inclbsub=$p(ProvLocInclb,"||",3) q:inclbsub="" -1
	q:'$d(^INCI(inci,"IL",incilsub,"LB",inclbsub)) -1
	s incib=$p(^INCI(inci,"IL",incilsub,"LB",inclbsub),"^",1) q:incib="" -1
	s ibsub=$p(incib,"||",2) q:ibsub="" -1
	q:($d(^INCI(inci,"IB",ibsub))=0)!($d(^INCI(inci,"IB",ibsub))=10) -1
	;
	l +^DBLock($zn,inci_"^"_toLocDR):20 e  q ""
	s incil="",inclb=""
	s ilch=$O(^INCI("IL_LOC",toLocDR,inci,""))
	i ilch="" d
	.&sql(insert into inc_itmloc(incil_Inci_parref,incil_ctloc_dr)
		values (:inci,:toLocDR) )
	.i SQLCODE=0 s incil=%ROWID  
	.s ilch=$P(incil,"||",2)
	e  d
	.s incil=inci_"||"_ilch
	s lb=$O(^INCI("LB_IB",incib,inci,ilch,"")  )
	i lb="" d
	.&sql(insert into INC_ItmLcBt (inclb_incil_parref,inclb_incib_dr)
		values(:incil,:incib) )
	.i SQLCODE=0 s inclb=%ROWID
	e  d
	.s inclb=inci_"||"_ilch_"||"_lb

	l -^DBLock($zn,inci_"^"_toLocDR)
	Q inclb
}

/// Descript:	检索库存转移主表信息
/// Creator:	wanajiabin
/// CreateDate:	2018-05-20
/// Input:		Params: {}格式字符串
/// 			StartDate:开始日期,EndDate:结束日期,FrLoc:供给部门rowid,ToLoc:接收部门rowid,Comp:完成标记(Y/N),
/// 			Status:状态,InitNo:出库单号,ScgStr:类组串(^隔开),Inci:库存项rowid,
/// 			ConfirmFlag:确认标记,InciDesc:库存项描述,CreateUser:制单人
/// Output:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrf","DHCINIsTrfM","{""StartDate"":""12/06/2018"",""gUserId"":""4642"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""FrLoc"":"""",""EndDate"":""12/07/2018"",""Status"":""10,11,20"",""InitNo"":"""",""ToLoc"":""392""}")
Query DHCINIsTrfM(Params As %String) As Query(ROWSPEC = "RowId:%Integer,InitNo,FrLocId,FrLocDesc,ToLocId,ToLocDesc,InitDate,InitTime,UserName,Comp,Status,ReqId,ReqNo,RpAmt:%Float,SpAmt:%Float,MarginAmt:%Float,Remark,StatusCode,ScgId,ScgDesc,InAckDate,InAckTime,InAckUser,ConfirmFlag,OperateTypeDesc,IsHVFlag,InitDateTime,PrintFlag,ConfirmFlag,AckDateTime") [ SqlProc ]
{
}

ClassMethod DHCINIsTrfMExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PFrLoc=PJObj.%Get("FrLoc")
	s PToLoc=PJObj.%Get("ToLoc")
	s PComp=PJObj.%Get("Comp")
	s PStatus=PJObj.%Get("Status")
	s PInitNo=PJObj.%Get("InitNo")
	s PReqNo=PJObj.%Get("ReqNo")
	s PScgId=PJObj.%Get("ScgId")
	s PInci=PJObj.%Get("Inci")
	s PConfirmFlag=PJObj.%Get("ConfirmFlag")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PCreateUser=PJObj.%Get("CreateUser")
	s PPrintFlag=PJObj.%Get("PrintFlag")
	s PDateType=PJObj.%Get("DateType")			//日期类型(1-制单日期,2-审核日期)
	s PHVPro=PJObj.%Get("HVPro")
	s PHVFlag=PJObj.%Get("HVFlag")
	s FVendorBox=PJObj.%Get("FVendorBox")
	
	s ULocId=PJObj.%Get("gLocId")
	s UserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s ToReturnFlag=PJObj.%Get("ToReturnFlag")
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),ULocId,PScgId,gHospId)
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)

	s sql="select %ID RowId,"
		_"INIT_AckDate AckDate,INIT_AckTime AckTime,"
		_"init_no InitNo,"
		_"init_frloc_dr FrLocId,"
		_"init_frloc_dr->ctloc_desc FrLocDesc,"
		_"init_toloc_dr ToLocId,"
		_"init_toloc_dr->ctloc_desc ToLocDesc,"
		_"init_date InitDate,"
		_"init_time InitTime,"
		_"init_date||','||init_time InitDateTime,"
		_"init_ssusr_dr InitUser,"
		_"init_ssusr_dr->ssusr_name UserName,"
		_"init_usercompleted Comp,"
		_"init_state Status,"
		_"init_inrq_dr ReqId,"
		_"init_inrq_dr->inrq_no ReqNo,"
		_"INIT_StkType StkType,"
		_"INIT_Remarks Remark,"
		_"INIT_SCG_DR ScgId,"
		_"INIT_SCG_DR->SCG_Desc ScgDesc,"
		_"INIT_InAckDate InAckDate,"
		_"INIT_InAckTime InAckTime,"
		_"INIT_InAckUser_DR->SSUSR_Name InAckUser,"
		_"INIT_OperateType->IPT_Desc OperateTypeDesc,"
		_"INIT_PrintFlag PrintFlag,"
		_"INIT_AcknowCompleted ConfirmFlag,"
		_"(CASE init_state"
			_" WHEN '10' THEN '未完成' WHEN '11' THEN '已完成'"
			_" WHEN '20' THEN '审核不通过' WHEN '21' THEN '审核通过'"
			_" WHEN '30' THEN '拒绝接收' WHEN '31' THEN '已接收'"
			_" WHEN '99' THEN '逻辑删除'"
			_" ELSE init_state"
			_" END) StatusCode,"
		_"(select sum(DHCITI_RPAmount) from DHC_InIsTrfItm where INITI_INIT_ParRef=INIT_RowId) RpAmt,"
		_"(select sum(DHCITI_SPAmount) from DHC_InIsTrfItm where INITI_INIT_ParRef=INIT_RowId) SpAmt,"
		_"(select sum(DHCITI_SPAmount-DHCITI_RPAmount) from DHC_InIsTrfItm where INITI_INIT_ParRef=INIT_RowId) MarginAmt"
		_" from dhc_inistrf"
	i PDateType=2 d
	.s sql=sql_" where INIT_AckDate between ? and ?"
	e  d
	.s sql=sql_" where init_date between ? and ?"
	
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute(PStartDate,PEndDate)
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		continue:(..FilterVen(RowId,FVendorBox)'="Y")
		s FrLocId=xrs.Data("FrLocId")		//供应科室RowId
		i PFrLoc'="" continue:FrLocId'=PFrLoc
		s ToLocId=xrs.Data("ToLocId")		//请求科室RowId
		i PToLoc'="" continue:ToLocId'=PToLoc
		s Comp=xrs.Data("Comp")				//完成标志
		i PComp'="" continue:Comp'=PComp
		s Status=xrs.Data("Status")			//状态
		i PStatus'="" continue:((Status="")||'$f(PStatus,Status))
		i PStatus="" continue:Status="99"	;若传值为"",此时过滤掉作废状态(99)
		s Type=xrs.Data("StkType")
		continue:Type'=..sssCode()
		s ScgId=xrs.Data("ScgId")
		continue:(ScgId'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
		s ScgDesc=xrs.Data("ScgDesc")
		
		;2017-03-23 个人权限类组过滤
		s IsInclude=""
		;科室不授权时,不过滤
		i (ScgId="")&&(ScgStr'="") d
		.s DetailScg=..GetInsTrfDetailScg(RowId)
		.s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,DetailScg,"^")
		continue:IsInclude=0				//明细过滤
		
		s Chl=""
		s:PInci'="" Chl=$o(^DHCINIT(0,"OutsINCI",PInci,RowId,0))
		continue:(PInci'="")&(Chl="")
		s Ret=0
		s:PInciDesc'="" Ret=..CheckInciDesc(RowId,PInciDesc)
		continue:(PInciDesc'="")&&(Ret'=0)
		
		;高值退库时,过滤不可操作的空单
		i PHVPro="Y" d
		.s HVEnableFlag=..GetInitHVEnableFlag(RowId)
		continue:(PHVPro="Y")&&(HVEnableFlag'="Y")
		
		s InitNo=xrs.Data("InitNo")
		i PInitNo'="" continue:InitNo'[PInitNo
		s FrLocDesc=xrs.Data("FrLocDesc")
		s FrLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocDesc)
		s ToLocDesc=xrs.Data("ToLocDesc")
		s ToLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ToLocDesc)
		s InitDate=xrs.Data("InitDate")
		s InitDate=..DL2H(InitDate)
		s InitTime=xrs.Data("InitTime")
		s InitTime=..TL2H(InitTime)
		s InitDateTime=InitDate_" "_InitTime
		s PrintFlag=xrs.Data("PrintFlag")
		s:PrintFlag="" PrintFlag="N"
		continue:(PPrintFlag'="")&(PrintFlag'=PPrintFlag)
		s InitUser=xrs.Data("InitUser")
		continue:(PCreateUser'="")&&(InitUser'=PCreateUser)
		s UserName=xrs.Data("UserName")
		s ConfirmFlag=xrs.Data("ConfirmFlag")	//确认标志
		s:ConfirmFlag="" ConfirmFlag="N"
		continue:(PConfirmFlag'="")&&(ConfirmFlag'=PConfirmFlag)
		s ReqId=xrs.Data("ReqId")
		s ReqNo=xrs.Data("ReqNo")
		i PReqNo'="" continue:ReqNo'=PReqNo
		s Remark=xrs.Data("Remark") 
		s Remark=$LTS(Remark)
		s StatusCode=xrs.Data("StatusCode")
		s RpAmt=xrs.Data("RpAmt")
		s SpAmt=xrs.Data("SpAmt")
		s MarginAmt=xrs.Data("MarginAmt")
		s InAckDate=xrs.Data("InAckDate")	//入库确认日期
		s InAckDate=..DL2H(InAckDate)
		s InAckTime=xrs.Data("InAckTime")	//入库确认时间
		s InAckTime=..TL2H(InAckTime)
		s InAckUser=xrs.Data("InAckUser")	//入库确认人
		s OperateTypeDesc=xrs.Data("OperateTypeDesc")
		s IsHVFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(RowId,"T")
		CONTINUE:(PHVFlag'="")&&(PHVFlag'=IsHVFlag)
		s AllReturnFlag=..IfAllReturn(RowId)
		CONTINUE:(ToReturnFlag'="")&&(AllReturnFlag=0)
		s AckDate=xrs.Data("AckDate")
		s AckDate=..DL2H(AckDate)
		s AckTime=xrs.Data("AckTime")
		s AckTime=..TL2H(AckTime)
		s AckDateTime=AckDate_" "_AckTime  //出库制单审核时间
		d OutPutRow1
	}
	q $$$OK

OutPutRow1
	s Data=$lb(RowId,InitNo,FrLocId,FrLocDesc,ToLocId,
		ToLocDesc,InitDate,InitTime,UserName,Comp,
		Status,ReqId,ReqNo,RpAmt,SpAmt,
		MarginAmt,Remark,StatusCode,ScgId,ScgDesc,
		InAckDate,InAckTime,InAckUser,ConfirmFlag,OperateTypeDesc,
		IsHVFlag,InitDateTime,PrintFlag,ConfirmFlag,AckDateTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrf","QueryTrans","204,205")
Query QueryTrans(InitStr As %String) As Query(ROWSPEC = "RowId:%Integer,InitNo,FrLocId,FrLocDesc,ToLocId,ToLocDesc,InitDate,InitTime,UserName,Comp,Status,ReqId,ReqNo,RpAmt:%Float,SpAmt:%Float,MarginAmt:%Float,Remark,StatusCode,ScgId,ScgDesc,InAckDate,InAckTime,InAckUser,ConfirmFlag,OperateTypeDesc,IsHVFlag,InitDateTime") [ SqlProc ]
{
}

ClassMethod QueryTransExecute(ByRef qHandle As %Binary, InitStr As %String) As %Status
{
	n (qHandle,InitStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s sql="select %ID RowId,"
		_"init_no InitNo,"
		_"init_frloc_dr FrLocId,"
		_"init_frloc_dr->ctloc_desc FrLocDesc,"
		_"init_toloc_dr ToLocId,"
		_"init_toloc_dr->ctloc_desc ToLocDesc,"
		_"init_date InitDate,"
		_"init_time InitTime,"
		_"init_date||','||init_time InitDateTime,"
		_"init_ssusr_dr InitUser,"
		_"init_ssusr_dr->ssusr_name UserName,"
		_"init_usercompleted Comp,"
		_"init_state Status,"
		_"init_inrq_dr ReqId,"
		_"init_inrq_dr->inrq_no ReqNo,"
		_"INIT_StkType StkType,"
		_"INIT_Remarks Remark,"
		_"INIT_SCG_DR ScgId,"
		_"INIT_SCG_DR->SCG_Desc ScgDesc,"
		_"INIT_InAckDate InAckDate,"
		_"INIT_InAckTime InAckTime,"
		_"INIT_InAckUser_DR->SSUSR_Name InAckUser,"
		_"INIT_OperateType->IPT_Desc OperateTypeDesc,"
		_"INIT_PrintFlag PrintFlag,"
		_"INIT_AcknowCompleted ConfirmFlag,"
		_"(CASE init_state"
			_" WHEN '10' THEN '未完成' WHEN '11' THEN '已完成'"
			_" WHEN '20' THEN '审核不通过' WHEN '21' THEN '审核通过'"
			_" WHEN '30' THEN '拒绝接收' WHEN '31' THEN '已接收'"
			_" WHEN '99' THEN '逻辑删除'"
			_" ELSE init_state"
			_" END) StatusCode,"
		_"(select sum(DHCITI_RPAmount) from DHC_InIsTrfItm where INITI_INIT_ParRef=INIT_RowId) RpAmt,"
		_"(select sum(DHCITI_SPAmount) from DHC_InIsTrfItm where INITI_INIT_ParRef=INIT_RowId) SpAmt,"
		_"(select sum(DHCITI_SPAmount-DHCITI_RPAmount) from DHC_InIsTrfItm where INITI_INIT_ParRef=INIT_RowId) MarginAmt"
		_" from dhc_inistrf"
	s sql=sql_" where INIT_RowId in ("_InitStr_")"
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s FrLocId=xrs.Data("FrLocId")		//供应科室RowId
		s ToLocId=xrs.Data("ToLocId")		//请求科室RowId
		s Comp=xrs.Data("Comp")				//完成标志
		s Status=xrs.Data("Status")			//状态
		s Type=xrs.Data("StkType")
		;continue:Type'=..sssCode()
		s ScgId=xrs.Data("ScgId")
		s ScgDesc=xrs.Data("ScgDesc")
		
		s InitNo=xrs.Data("InitNo")
		s FrLocDesc=xrs.Data("FrLocDesc")
		s FrLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocDesc)
		s ToLocDesc=xrs.Data("ToLocDesc")
		s ToLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ToLocDesc)
		s InitDate=xrs.Data("InitDate")
		s InitDate=..DL2H(InitDate)
		s InitTime=xrs.Data("InitTime")
		s InitTime=..TL2H(InitTime)
		s InitDateTime=InitDate_" "_InitTime
		s PrintFlag=xrs.Data("PrintFlag")
		s:PrintFlag="" PrintFlag="N"
		s InitUser=xrs.Data("InitUser")
		s UserName=xrs.Data("UserName")
		s ConfirmFlag=xrs.Data("ConfirmFlag")	//确认标志
		s:ConfirmFlag="" ConfirmFlag="N"
		s ReqId=xrs.Data("ReqId")
		s ReqNo=xrs.Data("ReqNo")
		s Remark=xrs.Data("Remark") 
		s Remark=$LTS(Remark)
		s StatusCode=xrs.Data("StatusCode")
		s RpAmt=xrs.Data("RpAmt")
		s SpAmt=xrs.Data("SpAmt")
		s MarginAmt=xrs.Data("MarginAmt")
		s InAckDate=xrs.Data("InAckDate")	//入库确认日期
		s InAckDate=..DL2H(InAckDate)
		s InAckTime=xrs.Data("InAckTime")	//入库确认时间
		s InAckTime=..TL2H(InAckTime)
		s InAckUser=xrs.Data("InAckUser")	//入库确认人
		s OperateTypeDesc=xrs.Data("OperateTypeDesc")
		s IsHVFlag=""
		s Ch=$o(^DHCINIT(RowId,"ITI",0))
		i Ch'="" d
		.s Inclb=$p(^DHCINIT(RowId,"ITI",Ch),"^",3)
		.s IsHVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(+Inclb)
		
		d OutPutRowTrans
	}
	q $$$OK

OutPutRowTrans
	s Data=$lb(RowId,InitNo,FrLocId,FrLocDesc,ToLocId,
		ToLocDesc,InitDate,InitTime,UserName,Comp,
		Status,ReqId,ReqNo,RpAmt,SpAmt,
		MarginAmt,Remark,StatusCode,ScgId,ScgDesc,
		InAckDate,InAckTime,InAckUser,ConfirmFlag,OperateTypeDesc,
		IsHVFlag,InitDateTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	检索库存转移主表信息
/// Creator:	wanajiabin
/// CreateDate:	2018-06-14
/// Input:		Params: {}格式字符串
/// 			StartDate:开始日期,EndDate:结束日期,FrLoc:库房rowid,ToLoc:请求科室rowid,PartlyTransfer:部分出库,
/// 			Transfered:全部出库,ReqType:请求单类型,PInciDesc:物资描述,HVFlag:高值标记,
/// 			IncludeDefLoc:是否包含支配科室,ReqHos:医院rowid
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrf","INReqForTransfer","{""StartDate"":""01/06/2018"",""EndDate"":""14/05/2018"",""FrLoc"":392}")
Query INReqForTransfer(Params As %String) As Query(ROWSPEC = "RowId:%Integer,ToLoc,ToLocDesc,FrLoc,FrLocDesc,ReqUser,UserName,ReqDate,ReqTime,Status,TransStatus,ReqNo,HVFlag,ReqScg,ReqScgDesc,Remarks,ReqDateTime,SumQty:%Float") [ SqlProc ]
{
}

ClassMethod INReqForTransferExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s ReqPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PFrLoc=PJObj.%Get("FrLoc")
	s PToLoc=PJObj.%Get("ToLoc")
	s PPartlyTransfer=PJObj.%Get("PartlyTransfer")
	s PTransfered=PJObj.%Get("Transfered")
	s PReqType=PJObj.%Get("ReqType")				//请求类型 OC 全部, O 临时请领, C 请求计划 
	s:PReqType="" PReqType="OC"
	s IsSplit=""		//是否启动分流功能
	s PInciId=PJObj.%Get("InciId")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PHVFlag=PJObj.%Get("HVFlag")
	s PIncludeDefLoc=PJObj.%Get("IncludeDefLoc")
	s PReqHosp=PJObj.%Get("ReqHosp")
	
	s PUserId=PJObj.%Get("gUserId")
	
	
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	q:PFrLoc="" $$$OK
	
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s StkType=..sssCode()
	
	s LocStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetDominLoc(PFrLoc)
	i (PIncludeDefLoc="Y")&&(LocStr'="") d
	.s LocStr=PFrLoc_","_LocStr
	e  d
	.s LocStr=PFrLoc
	s HospId=..sssHospId(PFrLoc)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(PUserId,..sssCode(),PFrLoc,"",HospId)

	s sql="select %ID RowId,"
		_"inrq_recloc_dr ToLoc,"
		_"inrq_recloc_dr->ctloc_Desc ToLocDesc,"
		_"inrq_reqloc_dr FrLoc,"
		_"inrq_reqloc_dr->ctloc_desc FrLocDesc,"
		_"inrq_ssusr_dr ReqUser,"
		_"inrq_ssusr_dr->ssusr_name UserName,"
		_"inrq_date ReqDate,"
		_"inrq_time ReqTime,"
		_"inrq_date||','||inrq_time ReqDateTime,"
		_"inrq_status ReqStatus,"
		_"inrq_usercompleted Comp,"
		_"INRQ_No ReqNo,"
		_"INRQ_Remarks Remarks"
		_" from in_request"
		_" where inrq_date between "_PStartDate_" and "_PEndDate
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Comp=xrs.Data("Comp")
		continue:Comp'="Y"		//未"完成"者滤除
		
		s ReqId=xrs.Data("RowId")
		s FrLoc=xrs.Data("FrLoc")
		continue:(","_LocStr_",")'[(","_FrLoc_",")
		s FrLocDesc=xrs.Data("FrLocDesc")
		s FrLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocDesc)
		s ToLoc=xrs.Data("ToLoc")
		continue:FrLoc=ToLoc
		i PToLoc'="" continue:ToLoc'=PToLoc
		s ToLocHosp=$P(^CTLOC(ToLoc),"^",22)
		i PReqHosp'="" continue:PReqHosp'=ToLocHosp
		s ToLocDesc=xrs.Data("ToLocDesc")
		s ToLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ToLocDesc)
		
		s (Status,AuditDateProv,Template,ReqScg,ReqStkType)=""
		&sql(select INRQ_Type,INRQ_AuditDate_Prov,inrq_template,INRQ_SCG_DR,INRQ_StkType
			into :Status,:AuditDateProv,:Template,:ReqScg,:ReqStkType
			from DHC_INRequest
			where INRQ_INRQ_DR=:ReqId
		)
		continue:ReqStkType'=StkType
		continue:PReqType'[Status
		continue:AuditDateProv=""		//根据供应方审核日期判断
		continue:Template="Y"			//过滤掉请求模板
		
		s ReqScgDesc=$s(ReqScg'="":$p(^DHCSCG(ReqScg),"^",2),1:"")
		continue:(ReqScg'="")&&(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ReqScg_"^"))
		
		s IsInclude=""
		i ReqScg="" d
		.s ReqDetailScg=..GetDetailScg(ReqId)
		.;检查个人权限是否包含请求单类组中的类组
		.s IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(ScgStr,ReqDetailScg,"^")
		continue:IsInclude=0
		
		s CheckRet=..CheckInciDescbyreq(ReqId,PInciDesc)
		continue:CheckRet'="Y"						;不包含的,过滤
		s TransStatus=..TransferStatus(ReqId,IsSplit,ScgStr)
		i PTransfered'="Y" continue:TransStatus="2"		//已经转移
		i PPartlyTransfer'="Y" continue:TransStatus="1"	//不包括部分转移
		
		s HVFlag=..GetReqHVFlag(ReqId)
		continue:(PHVFlag'="")&&(HVFlag'=PHVFlag)
		
		s ReqUser=xrs.Data("ReqUser")
		s UserName=xrs.Data("UserName")
		s ReqDate=xrs.Data("ReqDate")
		i ReqDate'="" s ReqDate=..DL2H(ReqDate)
		s ReqTime=xrs.Data("ReqTime")
		i ReqTime'="" s ReqTime=..TL2H(ReqTime)
		s ReqDateTime=ReqDate_" "_ReqTime
		s ReqNo=xrs.Data("ReqNo")
		s Remarks=xrs.Data("Remarks")
		s Remarks=$LTS(Remarks,..sssMemoDelim())
		
		s ReqData=##class(web.DHCSTMHUI.INRequest).GetReqData(ReqId)
		d ReqPJObj.%FromJSON(ReqData)
		s SumQty=ReqPJObj.%Get("SumQty")
		
		d OutPutINRequest
	}
	Quit $$$OK

OutPutINRequest
	s Data=$lb(ReqId,ToLoc,ToLocDesc,FrLoc,FrLocDesc,
		ReqUser,UserName,ReqDate,ReqTime,Status,
		TransStatus,ReqNo,HVFlag,ReqScg,ReqScgDesc,
		Remarks,ReqDateTime,SumQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 取库存转移请求单的转移状态
/// Author:zhwh
/// Date:2012-07-18
/// Argu:
///  req - 请求单主表RowId,
///  IsSplit - 分流标记,
///  StkGrpList - (类组串,^隔开)缺省为空,非空时过滤
/// Return:
///      0 - 未完成
///      1 - 部分完成
///  2 - 完成
ClassMethod TransferStatus(req As %String, IsSplit As %String = "", StkGrpList As %String = "") As %String
{
	n (req,IsSplit,StkGrpList)

	s dhcReq=$o(^DHCINRQ(0,"INRQ",req,""))
	i dhcReq'="" d
	.s INRQType=$p(^DHCINRQ(dhcReq),"^",1)
	e  d
	.s INRQType=$p(^INRQ(req),"^",7)

	s InrqiTrans=0
	s ch=0
	f  s ch=$o(^INRQ(req,"RQI",ch)) q:(ch="")!(InrqiTrans=1)  d
	.s inci=$P(^INRQ(req,"RQI",ch),"^",4)
	.s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s scgId=$p(scgInfo,"^",5)
	.;根据类组权限过滤
	.q:(StkGrpList'="")&&(##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(StkGrpList,scgId,"^")=0)
	.s INRQI=req_"||"_ch
	.s refuseflag=$P(^INRQ(req,"RQI",ch),"^",6)
	.q:refuseflag="Y"
	.s INRQIType="",INRQICanceled=""
	.s dhcinrqi=$o(^DHCINRQI(0,"INRQI",INRQI,""))
	.i dhcinrqi'="" d
	..s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
	..s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
	.q:(INRQType="C")&(IsSplit="Y")&(INRQIType'=0)  ;分流处理时候 去掉明细标志不是O的 O代表出库 C 计划
	.q:INRQICanceled="Y"
	.s init=$O(^DHCINIT(0,"RQI",INRQI,0))
	.s:init'="" InrqiTrans=1 
	i InrqiTrans=0 q 0		;若每个请求明细均没有^DHCINIT索引,返回0(未转移)

	s ret=2  ;默认转移完成
	s ch=0
	f  s ch=$o(^INRQ(req,"RQI",ch)) q:(ch="")!(ret=1)  d
	.s INRQI=req_"||"_ch
	.s inci=$P(^INRQ(req,"RQI",ch),"^",4)
	.s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s scgId=$p(scgInfo,"^",5)
	.;根据类组权限过滤
	.q:(StkGrpList'="")&&(##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(StkGrpList,scgId,"^")=0)
	.s reqQty=$P(^INRQ(req,"RQI",ch),"^",3)
	.s uom=$P(^INRQ(req,"RQI",ch),"^",5)
	.s refuseflag=$P(^INRQ(req,"RQI",ch),"^",6)
	.q:refuseflag="Y"
	.s INRQIType="",INRQICanceled="",qtyApproved=""
	.s dhcinrqi=$o(^DHCINRQI(0,"INRQI",INRQI,""))
	.i dhcinrqi'="" d
	..s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
	..s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
	..s qtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
	.q:(INRQType="C")&(IsSplit="Y")&(INRQIType'=0)  ;分流处理时候 去掉明细标志不是O的 O代表出库 C 计划
	.q:INRQICanceled="Y"
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,$p(^INCI(inci,1),"^",10))
	.s qtyApproved=qtyApproved*fac
	.s transQty=..TransQty(INRQI)
	.i transQty<qtyApproved s ret=1  q  //部分完成
	q ret
}

/// 查找请求单明细的转移数
/// Author:zhwh
/// Date:2012-07-18
/// Argu:
///  INRQI - 请求单明细rowid
/// Return:
///  转移数
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).TransQty("3591||1")
ClassMethod TransQty(INRQI As %String) As %String
{
	n (INRQI)
	s sumQty=0
	s init=""
	f  s init=$O(^DHCINIT(0,"RQI",INRQI,init)) q:init=""  d
	.s ch=0
	.f  s ch=$O(^DHCINIT(0,"RQI",INRQI,init,ch)) q:ch=""  d
	..s inclb=$P(^DHCINIT(init,"ITI",ch),"^",3)
	..s qty=$P(^DHCINIT(init,"ITI",ch),"^",1)
	..s uom=$P(^DHCINIT(init,"ITI",ch),"^",7)
	..s buom=$P(^INCI(+inclb,1),"^",10)
	..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	..s qty=qty*fac
	..s sumQty=sumQty+qty
	q sumQty
}

/// Descript:验证库存转移单数据是否正确(出库单完成、审核调用)
/// Creater:ZhangDongmei
/// CreateDate: 2012-10-19
/// Table:DHC_InIsTrf,DHC_InIsTrfItm
/// Input:转移主表id
/// Output:
/// Return:		"": 数据验证通过, 非空: 错误信息
ClassMethod CheckDataValid(Init) As %Library.String
{
	n (Init)
	q:Init="" 0
	s AppCode=..%GetParameter("AppName")
	s KeyValue=$p(^DHCINIT(Init),"^",1)   ;转移单号
	s ErrInfo=""
	s FrLoc=$p(^DHCINIT(Init),"^",5)
	i FrLoc=""  d
	.s ErrInfo="出库科室为空"
	q:ErrInfo'="" ErrInfo

	s ToLoc=$p(^DHCINIT(Init),"^",6)
	i ToLoc=""  d
	.s ErrInfo="接收科室为空"
	q:ErrInfo'="" ErrInfo    ;接收科室验证不通过

	s Type="T"
	s DirtyQty=0
	s InitItmCount=0
	s Chl=0
	f  s Chl=$o(^DHCINIT(Init,"ITI",Chl)) q:(Chl="")!(ErrInfo'="")  d
	.s Inclb=$p(^DHCINIT(Init,"ITI",Chl),"^",3)
	.s Qty=$p(^DHCINIT(Init,"ITI",Chl),"^",1)
	.s UomId=$p(^DHCINIT(Init,"ITI",Chl),"^",7)
	.s Rp=$p(^DHCINIT(Init,"ITI",Chl),"^",15)
	.s Sp=$p(^DHCINIT(Init,"ITI",Chl),"^",17)
	.s Status=$p(^DHCINIT(Init,"ITI",Chl),"^",23)
	.i (Status'=21)&(Status'=31)  d    ;本张单据的占用数量
	..s DirtyQty=Qty
	.s ErrInfo=##class(web.DHCSTMHUI.Common.UtilCommon).CheckDetail(AppCode,Inclb,Qty,Rp,Sp,UomId,Type,DirtyQty)
	.q:ErrInfo'=""
	.s InitItmCount=InitItmCount+1
	q:ErrInfo'="" ErrInfo    ;明细验证不通过
	i InitItmCount=0 s ErrInfo="出库单明细为空"
	q:ErrInfo'="" ErrInfo
	q ""
}

/// w ##class(web.DHCSTMHUI.DHCINIsTrf).jsCreateInIsTrf("{""Init"":""115"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
ClassMethod jsCreateInIsTrf(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CreateInIsTrf(Params)
	q RtnObj.Json()
}

/// Descript:	依据转入单制转出单
/// Creator:	lxt
/// CreateDate:	2019-04-8
/// Table:		DHC_inistrf
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod CreateInIsTrf(Params As %String) As %String
{
	n (Params)
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s Init=PJObj.%Get("Init")
	i Init="" s Sc=RtnObj.Err(-2,"","Init不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s Status=$p(^DHCINIT(Init),"^",14)
	i Status'=31 d RtnObj.Err(-3,"","单据未接收!","",0)
	q:RtnObj.success<0 RtnObj
	
	s InitToLoc=$p(^DHCINIT(Init),"^",5) //出库科室作为接收科室
	s InitFrLoc=$p(^DHCINIT(Init),"^",6)
	s InitScg=$p(^DHCINIT(Init),"^",23)
	s OperateType=$p(^DHCINIT(Init),"^",20)
	s InitComp="N"
	s InitState="10"
	s InitUser=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s pDetailId=PJObj.%Get("DetailId")
	s Main="{""InitFrLoc"":"""_InitFrLoc_""",""InitToLoc"":"""_InitToLoc_""",""InitScg"":"""_InitScg_""",""OperateType"":"""_OperateType_""",""InitComp"":"""_InitComp_""",""InitState"":"""_InitState_""",""InitUser"":"""_InitUser_""",""gGroupId"":"""_gGroupId_""",""gLocId"":"""_gLocId_""",""gUserId"":"""_gUserId_"""}"
	
	s chl=0
	s Detail=""
	f  s chl=$o(^DHCINIT(Init,"ITI",chl)) q:chl=""  d
	.s Initi=Init_"||"_chl
	.q:(pDetailId'="")&&(("^"_pDetailId_"^")'[("^"_Initi_"^"))
	.s Inclb=$p(^DHCINIT(Init,"ITI",chl),"^",3)
	.s Qty=$p(^DHCINIT(Init,"ITI",chl),"^",1)
	.s UomId=$p(^DHCINIT(Init,"ITI",chl),"^",7)
	.s toInclb=..GetToLocINCLB(Initi)
	.s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("T",Initi)
	.s JsonStr="{""RowId"":"""",""Inclb"":"""_toInclb_""",""Qty"":"""_Qty_""",""UomId"":"""_UomId_""",""HVBarCode"":"""_HVBarCode_""",""InitiDR"":"""_Initi_"""}"
	.i Detail="" d
	..s Detail=JsonStr
	.e  d
	..s Detail=Detail_","_JsonStr
	i Detail="" d RtnObj.Err(-4,"","单据明细为空!","",0)
	q:RtnObj.success<0 RtnObj
	s Detail="["_Detail_"]"
	
	s RtnObj=..Save(Main,Detail)
	q RtnObj
}

/// d ##class(web.DHCSTMHUI.DHCINIsTrf).jsConfirm("{""RowIdStr"":""64^65""}")
ClassMethod jsConfirm(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s RowIdStr=PJObj.%Get("RowIdStr")
	s del="^"
	s cnt=$l(RowIdStr,del)
	ts
	f i=1:1:cnt d
	.s RowId=$p(RowIdStr,del,i)
	.s RtnObj=..Confirm(RowId) 
	.q:RtnObj.success'=0
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 库存转移单库房确认
/// Author: tsr
/// Date: 2015-02-02
/// Argu:
///   init - 库存转移主表 RowId
/// Return:
ClassMethod Confirm(RowId As %String) As RtnObj
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	&sql(update DHC_InIsTrf set INIT_AcknowCompleted='Y' where %ID=:RowId)
	i SQLCODE'=0 d 
	.d RtnObj.Err(-1,"","确认失败")
	q RtnObj
}

/// 库存转移单物资名称模糊查询
/// Author: tsr
/// Date: 2015-06-02
/// Return:	0~包含;1~不包含
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).CheckInciDesc(11,11)
ClassMethod CheckInciDesc(init As %String, inciDesc As %String) As %String
{
	n (init,inciDesc)
	s err=0
	s Ch=0
	f  s Ch=$o(^DHCINIT(init,"ITI",Ch)) q:(Ch="")||(err'=0)  d
	.s inclb=$p(^DHCINIT(init,"ITI",Ch),"^",3)
	.s inci=+inclb
	.s incDesc=$p(^INCI(inci,1),"^",2)
	.s:incDesc[inciDesc err=-1
	q:err'=0 0
 	q -1
}

/// Descript:	处理出库单中的init_inrq_dr
/// Creator:	wangjiabin
/// CreateDate:	2015-07-22
/// Input:		init
/// Return:		0:成功, 其他:失败
ClassMethod UpdateInitInfo(init As %String) As %Library.String
{
	n (init)
	q:init="" 0
	s inrq=$p(^DHCINIT(init),"^",7)
	q:inrq="" 0

	s ret=0,flag=0,ch=0
	f  s ch=$o(^INRQ(inrq,"RQI",ch)) q:(ch="")||(flag'=0)  d
	.s inrqi=inrq_"||"_ch
	.i $d(^DHCINIT(0,"RQI",inrqi,init)) d
	..s flag=1

	i flag=0 d
	.&sql(update dhc_inistrf set init_inrq_dr=null where %id=:init)
	.i SQLCODE s ret=-1

	q ret
}

/// Creator:	wangjiabin
/// CreatDate:	2015-09-25
/// Description:判断该出库单是否已经生成月报
/// InPut:		出库单rowid
/// Table:
/// OutPut:
/// Return:		0,未生成；1,已生成
ClassMethod IfMakeMon(init As %String) As %Library.String
{
	n (init)
	q:init="" 0
	
	s loc=$p(^DHCINIT(init),"^",5)		;出库科室
	s date=$p(^DHCINIT(init),"^",9)		;出库审核日期
	q:date="" 1
	&sql(select DHCSM_Rowid from DHC_StkMon where DHCSM_CTLOC_DR=:loc and DHCSM_ToDate>=:date and DHCSM_StkType='M')
	q:'SQLCODE 1
	q 0
}

/// 请求单物资名称模糊查询
/// Date: 2015-12-07
/// Return:	Y~包含;N~不包含
ClassMethod CheckInciDescbyreq(reqid As %String, inciDesc As %String) As %String
{
	n (reqid,inciDesc)
	q:reqid="" "Y"
	q:inciDesc="" "Y"		;入参为"",按Y处理
	s Flag="N"
	s (reqitm,incDesc)=""
	f  s reqitm=$o(^INRQ(reqid,"RQI",reqitm)) q:(reqitm="")||(Flag="Y")  d
	.s inci=$p(^INRQ(reqid,"RQI",reqitm),"^",4)
	.q:inci=""
	.s incDesc=$p($g(^INCI(inci,1)),"^",2)
	.i incDesc[inciDesc s Flag="Y" q 
	
	q Flag
}

/// 2016-04-15 获取请求单高值标志
ClassMethod GetReqHVFlag(req As %String) As %String
{
	n (req)

	s HVFlag="N"
	s ch=0
	f  s ch=$o(^INRQ(req,"RQI",ch)) q:(ch="")!(HVFlag="Y")  d
	.s inci=$P(^INRQ(req,"RQI",ch),"^",4)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	q HVFlag
}

/// Descript:	判断出库单上是否有可处理的高值条码(用于高值退库时的数据获取,调用时留意)
/// Creator:	wangjiabin
/// CreateDate:	2016-12-15
/// Input:		init
/// Output:		Y:有可处理的明细, N:没有
ClassMethod GetInitHVEnableFlag(init As %String) As %String
{
	n (init)
	s ret="N"
	q:init="" ret
	
	s initCh=0
	f  s initCh=$o(^DHCINIT(init,"ITI",initCh)) q:(initCh="")||(ret="Y")  d
	.s initi=init_"||"_initCh
	.s HVEnableFlag=##class(web.DHCSTMHUI.DHCINIsTrfItm).GetInitiHVEnable(initi)
	.q:HVEnableFlag="N"
	.;有可处理的明细,则将返回值置为Y
	.s ret="Y"
	q ret
}

/// 获取请领单明细的类组串(^隔开)
/// Author:	wangjiabin
/// Date:	2017-03-23
/// Argu:
///   ReqId - 请求单RowId
/// Return:
ClassMethod GetDetailScg(ReqId As %String) As %String
{
	n (ReqId)
	q:ReqId="" ""
	s result=""
	s ch=""
	f  s ch=$o(^INRQ(ReqId,"RQI",ch)) q:ch=""  d
	.s ReqItmId=ReqId_"||"_ch
	.s inci=$p(^INRQ(ReqId,"RQI",ch),"^",4)
	.s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s scg=$p(scgInfo,"^",5)
	.i result="" d
	..s result=scg
	.e  i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(result,scg,"^")=0 d
	..s result=result_"^"_scg
	
	q result
}

/// 获取转移单明细的类组串(^隔开)
/// Author:	wangjiabin
/// Date:	2017-03-23
/// Argu:
///   Init - 请求单RowId
/// Return:
ClassMethod GetInsTrfDetailScg(Init As %String) As %String
{
	n (Init)
	q:Init="" ""
	s result=""
	s ch=0
	f  s ch=$o(^DHCINIT(Init,"ITI",ch)) q:ch=""  d
	.s Initi=Init_"||"_ch
	.s inclb=$p(^DHCINIT(Init,"ITI",ch),"^",3)
	.s inci=+inclb
	.s scg=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",5)
	.i result="" d
	..s result=scg
	.e  i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(result,scg,"^")=0 d
	..s result=result_"^"_scg
	
	q result
}

/// 根据库存出库单生成退货单后逻辑删除出库单
/// Author: tsr
/// Date: 2017-08-16
/// Remarks: 生成退货单前已清除占用,不进行占用处理
ClassMethod LogicalDelete(Init As %String) As RtnObj
{
	n (Init)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".LogicalDelete"
	i Init="" q RtnObj.Err(-1,"",MethodName_":参数错误")
	s AllowDel=..AllowDel(Init)
	i AllowDel<0 q RtnObj.Err(-2,Init,"不允许删除","",0)
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).DelByPointer("T",Init)
	i RtnObj.success<0 q RtnObj
	s ret=..HandleTransResQty(Init,1)
	i ret'=0 q RtnObj.Err(-4,Init,MethodName_":处理请求单在途失败")
	
	&sql(update DHC_InIsTrfItm
		set INITI_INRQI_DR=null,INITI_INGRI_DR=null
		where INITI_INIT_ParRef=:Init)
	i SQLCODE<0 q RtnObj.Err(-5,Init,MethodName_":处理dhc_inistrfitm失败,SQLCODE:"_SQLCODE)
	
	&sql(update DHC_InIsTrf
		set INIT_State='99',INIT_INGR_Dr=null,INIT_INRQ_DR=null
		where %id=:Init)
	i SQLCODE'=0 q RtnObj.Err(-6,Init,MethodName_":处理dhc_inistrfitm失败,SQLCODE:"_SQLCODE)
 	q RtnObj
}

/// 验证高值条码是否在此出库单中
/// Author:zhangxiao
/// Date:2017-11-7
/// Argu:
///   init - 库存转移主表 RowId,
///   user- 人员id
///   hvbarcode-高值条码
/// Return:
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).CheckHVBarCode("127","541","WSGZ20170223001")
ClassMethod CheckHVBarCode(init As %String, user As %String, hvbarcode As %String) As %String
{
	n (init,user,hvbarcode)
	q:init="" -1
	q:user="" -2
	q:hvbarcode="" -3
	s itmtrackid=""
	&sql(select DHCIT_Rowid into:itmtrackid from DHC_ItmTrack where DHCIT_Label=:hvbarcode)
	q:itmtrackid="" -4  ;高值条码未登记
	s initi="",Type="T"
	&sql(select DHCITD_Pointer into:initi from DHC_ItmTrackDetail where DHCITD_Type=:Type and DHCITD_Parref=:itmtrackid)
	q:initi="" -5    ;没有出库
	s tmpinit=init_"||%"
	&sql(select DHCITD_Pointer into:initi from DHC_ItmTrackDetail where DHCITD_Type=:Type and DHCITD_Parref=:itmtrackid and DHCITD_Pointer like :tmpinit)
	q:+initi'=init -6 ;高值条码不在此出库单中

	s date=+$h
	s time=$p($h,",",2)
	&sql(update DHC_InIsTrfItm set INITI_DateAcknow=:date,INITI_TimeAcknow=:time,INITI_UserAck_DR=:user where INITI_RowId=:initi)
	q:SQLCODE'=0 -7  ;验收失败
	
	q 0
}

/// 根据高值条码获取物资信息
ClassMethod GetDataByBarcode(hvbarcode As %String) As %String
{
	n (hvbarcode)
	q:hvbarcode="" ""
	s inci="",Code="",Desc=""
	&sql(select DHCIT_INCI_DR->INCI_Code,DHCIT_INCI_DR->INCI_Desc,DHCIT_INCI_DR into:Code,:Desc,:inci from DHC_ItmTrack where DHCIT_Label=:hvbarcode )
	q:inci="" ""
	s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	q Code_"^"_Desc_"^"_spec
}

/// CreatDate:	2017-12-06
/// Description:判断出库单是否为高值单据等属性
/// Input:		主表rowid
/// Return:		{HVFlag:Y/N,...} json格式,便于扩展
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).GetInitFlag(116)
ClassMethod GetInitFlag(Parref As %String) As %String
{
	n (Parref)
	q:Parref="" ""
	s ParrefHVFlag="N"
	s Ch=0
	f  s Ch=$o(^DHCINIT(Parref,"ITI",Ch)) q:(Ch="")||(ParrefHVFlag="Y")  d
	.s Inclb=$p(^DHCINIT(Parref,"ITI",Ch),"^",3)
	.s Inci=$p(Inclb,"||",1)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.q:HVFlag'="Y"
	.s ParrefHVFlag=HVFlag
	
	s DataStr=ParrefHVFlag
	s TitleStr="HVFlag"
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Result
}

/// CreatDate:	20211021 lihui
/// Description: 判断出库单是否包含某个供应商
/// Input:		主表rowid
/// Return:		
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).FilterVen(116)
ClassMethod FilterVen(Parref As %String, VenId) As %String
{
	n (Parref,VenId)
	q:Parref="" "Y"
	q:VenId="" "Y"
	s Flag="N"
	s Ch=0
	f  s Ch=$o(^DHCINIT(Parref,"ITI",Ch)) q:(Ch="")||(Flag="Y")  d
	.s Inclb=$p(^DHCINIT(Parref,"ITI",Ch),"^",3)
	.s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	.s VendorId=$p(VendorInfo,"^",1)
	.i VenId=VendorId s Flag="Y"
	q Flag
}

/// Creator:	wxj
/// CreatDate:	2022-02-08
/// Description:判断出库单是否已跨月
/// InPut:		出库单rowid
/// Return:		0,未跨月；1,已跨月
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).IfCrossMon(17)
ClassMethod IfCrossMon(init As %String) As %Library.String
{
	n (init)
	q:init="" 0
	s date=$p(^DHCINIT(init),"^",9)		;出库审核日期
	q:date="" 0
	s AuditDate=$zd(date,3)
	s AuditYear=+$p(AuditDate,"-",1)
	s AuditMon=+$p(AuditDate,"-",2)
	s Today=$zd(+$H,3)
	s Year=+$p(Today,"-",1)
	s Month=+$p(Today,"-",2)
	q:(AuditYear<Year) 1 
	q:(AuditYear=Year)&&(AuditMon<Month) 1
	q 0
}

/// Descript: 验证出库单是否存在过期批次
/// Creater: lihui
/// CreateDate: 20220511
/// Table: DHC_InIsTrf,DHC_InIsTrfItm
/// Input: 转移主表id
/// Output:
/// Return:		"": 数据验证通过, 非空: 错误信息
ClassMethod CheckDataExp(Init) As %Library.String
{
	n (Init)
	q:Init="" 0
	s AppCode=..%GetParameter("AppName")
	s KeyValue=$p(^DHCINIT(Init),"^",1)   ;转移单号
	s ErrInfo=""
	s FrLoc=$p(^DHCINIT(Init),"^",5)
	i FrLoc=""  d
	.s ErrInfo="出库科室为空"
	q:ErrInfo'="" ErrInfo
	s ToLoc=$p(^DHCINIT(Init),"^",6)
	i ToLoc=""  d
	.s ErrInfo="接收科室为空"
	q:ErrInfo'="" ErrInfo    ;接收科室验证不通过
	s Chl=0
	f  s Chl=$o(^DHCINIT(Init,"ITI",Chl)) q:(Chl="")!(ErrInfo'="")  d
	.s Inclb=$p(^DHCINIT(Init,"ITI",Chl),"^",3)
	.s Inci=+Inclb
	.s batexp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	.s ExpDate=$p(batexp,"^",2)
	.s:ExpDate'="" ExpDate=..DH2L(ExpDate)
	.s Param="^"_FrLoc_"^"
	.s AllowExpDateOut=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppCode,"AllowExpDateOut",Param)
	.i (AllowExpDateOut'="Y")&&(ExpDate'="")&&(ExpDate<+$h) d
	..s Incicode=$p(^INCI(Inci,1),"^",1)
	..s ErrInfo=Incicode_"过期 不允许出库"
	.q:ErrInfo'=""
	q:ErrInfo'="" ErrInfo    ;明细验证不通过
	q ""
}

/// Creator:	wxj
/// CreatDate:	2022-10-18
/// Description:检查出库单是否已退库
/// InPut:		出库单rowid
/// Return:		0,不存在未退库明细；1,存在未退库明细
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).IfAllReturn(17)
ClassMethod IfAllReturn(Init As %String) As %Library.String
{
	n (Init)
	q:Init="" 0
	s Flag=0
	s InitCh=0
	f  s InitCh=$o(^DHCINIT(Init,"ITI",InitCh)) q:(InitCh="")||(Flag=1)  d
	.q:'$d(^DHCINIT(Init,"ITI",InitCh))
	.s Initi=Init_"||"_InitCh
	.s NewInit=$o(^DHCINIT(0,"INITI",Initi,""))
	.s:+NewInit=0 Flag=1
	q Flag
}

}
