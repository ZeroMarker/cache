Import sqluser

/// Descript:	润乾报表相关
/// Creator:	wangjiabin
/// CreateDate: 2016-07-12
Class web.DHCSTMHUI.RQReport Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	入库单信息query
/// 			主表信息通过query取值,方便打印报表内修改
/// Creator:	wangjiabin
/// CreateDate:	2016-07-12
/// Table:		DHC_InGdRec
/// Input:		Parref(主表rowid)
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetIngrDetail",6558)
Query GetIngrDetail(Parref As %String) As Query(ROWSPEC = "InGrNo,ApcvmDr,Vendor,AuditDate,AuditUserId,AuditUser,AuditTime,PoId,PoNo,Complete,LocId,LocDesc,CreateDate,CreateTime,CreateUserId,CreateUser,PayAllowed,IngrTypeId,IngrType,PurUserId,PurUser,ReqLocId,ReqLoc,AcceptUserId,AcceptUser,TreasureUserId,TreasureUser,StkGrpId,StkGrp,AuditFlag,GiftFlag,AdjCheque,InGrRemarks,SourceOfFund,SourceOfFundDesc,HospDesc,printTime,PrintCount:%Integer,ReprintFlag") [ SqlProc ]
{
}

ClassMethod GetIngrDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	s Ingr=Parref
	q:+Ingr=0 $$$OK
	
	S InGrNo =$p(^DHCINGR(Ingr),"^",1)
	S ApcvmDr =$p(^DHCINGR(Ingr),"^",3)
	s (Vendor,AuditUser,PoNo,LocDesc,CreateUser,IngrType,PurUser,ReqLoc,AcceptUser,TreasureUser,StkGrp,SourceOfFundDesc)=""
	;s:ApcvmDr'="" Vendor=$p(^APC("APCVM",ApcvmDr),"^",3)
	s AuditDate=$p(^DHCINGR(Ingr),"^",4)
	s:+AuditDate'=0 AuditDate=..DL2H(AuditDate)
	s AuditUserId=$p(^DHCINGR(Ingr),"^",8)
	s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
	s AuditTime=$p(^DHCINGR(Ingr),"^",9)
	s:+AuditTime'=0 AuditTime=..TL2H(AuditTime)
	s PoId=$p(^DHCINGR(Ingr),"^",11)
	s:PoId'="" PoNo=$p(^INPO(PoId),"^",1)
	s Complete=$p(^DHCINGR(Ingr),"^",12)
	s LocId=$p(^DHCINGR(Ingr),"^",13)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
	s CreateDate=$p(^DHCINGR(Ingr),"^",14)
	s:ApcvmDr'="" Vendor=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(CreateDate,ApcvmDr)
	s:+CreateDate'=0 CreateDate=..DL2H(CreateDate)
	s CreateTime=$p(^DHCINGR(Ingr),"^",15)
	s:+CreateTime'=0 CreateTime=..TL2H(CreateTime)
	s CreateUserId=$p(^DHCINGR(Ingr),"^",16)
	s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
	s PayAllowed=$p(^DHCINGR(Ingr),"^",22)		;是否允许付款
	s IngrTypeId=$p(^DHCINGR(Ingr),"^",23)
	s:IngrTypeId'="" IngrType=$p(^DHCOPTYPE(IngrTypeId),"^",2)
	s PurUserId=$p(^DHCINGR(Ingr),"^",24)
	s:PurUserId'="" PurUser=$p(^SSU("SSUSR",PurUserId),"^",2)
	s ReqLocId=$p(^DHCINGR(Ingr),"^",25)
	s:ReqLocId'="" ReqLoc=$p(^CTLOC(ReqLocId),"^",2)
	s AcceptUserId=$p(^DHCINGR(Ingr),"^",26)
	s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
	s TreasureUserId=$p(^DHCINGR(Ingr),"^",27)
	s:TreasureUserId'="" TreasureUser=$p(^SSU("SSUSR",TreasureUserId),"^",2)
	s StkGrpId=$p(^DHCINGR(Ingr),"^",28)
	s:StkGrpId'="" StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
	s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
	s StkType=$p(^DHCINGR(Ingr),"^",30)
	q:StkType'=..sssCode() ""
	s GiftFlag=$p(^DHCINGR(Ingr),"^",31)
	s AdjCheque=$p(^DHCINGR(Ingr),"^",32)
	s InGrRemarks=""
	s InGrRemarks=##class(web.DHCSTMHUI.Common.UtilCommon).GetREMList("^DHCINGR",Ingr)
	s SourceOfFund=$p(^DHCINGR(Ingr),"^",36)
	s:SourceOfFund'="" SourceOfFundDesc=$p(^DHCSOUROFFUND(SourceOfFund),"^",2)
	s HospId=$s(LocId'="":$p(^CTLOC(LocId),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)
	s PrintCount=..GetBillPrintCount("G",Ingr)
	s ReprintFlag=""
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutIngrDetail
	Quit $$$OK
	
OutPutIngrDetail
	s Data=$lb(InGrNo,ApcvmDr,Vendor,AuditDate,AuditUserId,
		AuditUser,AuditTime,PoId,PoNo,Complete,
		LocId,LocDesc,CreateDate,CreateTime,CreateUserId,
		CreateUser,PayAllowed,IngrTypeId,IngrType,PurUserId,
		PurUser,ReqLocId,ReqLoc,AcceptUserId,AcceptUser,
		TreasureUserId,TreasureUser,StkGrpId,StkGrp,AuditFlag,
		GiftFlag,AdjCheque,InGrRemarks,SourceOfFund,SourceOfFundDesc,
		HospDesc,printTime,PrintCount,ReprintFlag
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	退货单信息query
/// Creator:	wangjiabin
/// CreateDate:	2016-07-12
/// Table:		DHC_InGdRet
/// Input:		INGRT(主表rowid)
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetIngrtDetail",480)
Query GetIngrtDetail(INGRT As %String) As Query(ROWSPEC = "INGRTRowId,INGRTAPCVMDR,INGRTDate,INGRTTime,INGRTCompleted,INGRTSSUSRDR,INGRTNO,INGRTCTLOCDR,INGRTSSUSRAuditDR,INGRTAuditDate,INGRTAuditTime,INGRTAdjCheque,INGRTPayAllowed,INGRTPayAllowDate,INGRTSCGDR,INGRTAuditFlag,INGRTStkType,INGRTPrtFlag,INGRTPayAllowTime,INGRTPayAllowUserDR,VenDesc,LocDesc,INGRTDate,ingrtUser,ScgDesc,VenCode,HospDesc,printTime,PrintCount:%Integer,ReprintFlag") [ SqlProc ]
{
}

ClassMethod GetIngrtDetailExecute(ByRef qHandle As %Binary, INGRT As %String) As %Status
{
	n (qHandle,INGRT)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:INGRT="" $$$OK
	
	&sql(select INGRT_RowId,INGRT_APCVM_DR,INGRT_Date,INGRT_Time,INGRT_Completed,
		INGRT_SSUSR_DR,INGRT_NO,INGRT_CTLOC_DR,INGRT_SSUSR_Audit_DR,INGRT_AuditDate,
		INGRT_AuditTime,INGRT_AdjCheque,INGRT_PayAllowed,INGRT_PayAllowDate,INGRT_SCG_DR,
		INGRT_AuditFlag,INGRT_StkType,INGRT_PrtFlag,INGRT_PayAllowTime,INGRT_PayAllowUser_DR
	into
		INGRTRowId,INGRTAPCVMDR,INGRTDate,INGRTTime,INGRTCompleted,
		INGRTSSUSRDR,INGRTNO,INGRTCTLOCDR,INGRTSSUSRAuditDR,INGRTAuditDate,
		INGRTAuditTime,INGRTAdjCheque,INGRTPayAllowed,INGRTPayAllowDate,INGRTSCGDR,
		INGRTAuditFlag,INGRTStkType,INGRTPrtFlag,INGRTPayAllowTime,INGRTPayAllowUserDR
	from DHC_INGDRET where %ID=:INGRT)
	q:SQLCODE $$$OK

	s (VenDesc,VenCode,LocDesc,ingrtUser,ScgDesc)=""
	s:INGRTAPCVMDR'="" VenDesc=$p(^APC("APCVM",INGRTAPCVMDR),"^",3),VenCode=$p(^APC("APCVM",INGRTAPCVMDR),"^",2)
	s:INGRTCTLOCDR'="" LocDesc=$p(^CTLOC(INGRTCTLOCDR),"^",2)
	s:INGRTDate'="" INGRTDate=..DL2H(INGRTDate)
	s:INGRTSSUSRDR'="" ingrtUser=$p(^SSU("SSUSR",INGRTSSUSRDR),"^",2)
	s:INGRTSCGDR'="" ScgDesc=$p(^DHCSCG(INGRTSCGDR),"^",2)
	s HospId=$s(INGRTCTLOCDR'="":$p(^CTLOC(INGRTCTLOCDR),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)
	s PrintCount=..GetBillPrintCount("R",INGRT)
	s:INGRTAuditDate'="" INGRTAuditDate=..DL2H(INGRTAuditDate)
	s:INGRTAuditTime'="" INGRTAuditTime=..TL2H(INGRTAuditTime)
	s ReprintFlag=""
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutIngrtDetail
	Quit $$$OK
	
OutPutIngrtDetail
	s Data=$lb(INGRTRowId,INGRTAPCVMDR,INGRTDate,INGRTTime,INGRTCompleted,
		INGRTSSUSRDR,INGRTNO,INGRTCTLOCDR,INGRTSSUSRAuditDR,INGRTAuditDate,
		INGRTAuditTime,INGRTAdjCheque,INGRTPayAllowed,INGRTPayAllowDate,INGRTSCGDR,
		INGRTAuditFlag,INGRTStkType,INGRTPrtFlag,INGRTPayAllowTime,INGRTPayAllowUserDR,
		VenDesc,LocDesc,INGRTDate,ingrtUser,ScgDesc,
		VenCode,HospDesc,printTime,PrintCount,ReprintFlag
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	出(退)库单信息query
/// Creator:	wangjiabin
/// CreateDate:	2016-07-12
/// Table:		DHC_INIsTrf
/// Input:		Init(主表rowid)
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInitDetail",7491)
Query GetInitDetail(Init As %String) As Query(ROWSPEC = "INITRowId,INITAckDate,INITAcknowCompleted,INITAckTime,INITAckUserDR,INITDate,FrLocId,ReqId,INITNo,INITRemarks,INITUser,INITTime,ToLocId,INITType,INITUserCompleted,INITState,INITInAckDate,INITInAckTime,INITInAckUserDR,INITIsTrfDR,INITOperationRemark,OperateType,INITINGRDr,INITPrintFlag,INITSCGDR,INITStkType,FrLocDesc,ToLocDesc,ReqNo,INITDate,ReqId,INITUserName,OperateTypeDesc,INITTime,ReqUserName,ReqRemark,ScgDesc,HospDesc,INITInAckUserName,PrintTime,INITReqUserDR,INITReqUser,PrintCount:%Integer,INITAckUserName,ReqAuditUserName,ReqProAuditUserName,ReprintFlag") [ SqlProc ]
{
}

ClassMethod GetInitDetailExecute(ByRef qHandle As %Binary, Init As %String) As %Status
{
	n (qHandle,Init)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Init="" $$$OK
	s ReqId=""
	&sql(select INIT_RowId,INIT_AckDate,INIT_AcknowCompleted,INIT_AckTime,INIT_AckUser_DR,
		INIT_Date,INIT_FrLoc_DR,INIT_INRQ_DR,INIT_No,INIT_Remarks,
		INIT_SSUSR_DR,INIT_Time,INIT_ToLoc_DR,INIT_Type,INIT_UserCompleted,
		INIT_State,INIT_InAckDate,INIT_InAckTime,INIT_InAckUser_DR,INIT_IsTrf_DR,
		INIT_OperationRemark,INIT_OperateType,INIT_INGR_Dr,INIT_PrintFlag,INIT_SCG_DR,
		INIT_StkType,INIT_SCG_DR->SCG_Desc
	into
		INITRowId,INITAckDate,INITAcknowCompleted,INITAckTime,INITAckUserDR,
		INITDate,FrLocId,ReqId,INITNo,INITRemarks,
		INITUser,INITTime,ToLocId,INITType,INITUserCompleted,
		INITState,INITInAckDate,INITInAckTime,INITInAckUserDR,INITIsTrfDR,
		INITOperationRemark,OperateType,INITINGRDr,INITPrintFlag,INITSCGDR,
		INITStkType,ScgDesc
	from dhc_inistrf where %id=:Init)
	q:SQLCODE'=0 $$$OK
	s INITRemarks=$lts(INITRemarks,..sssMemoDelim())
	s:INITDate'="" INITDate=..DL2H(INITDate)
	s:INITTime'="" INITTime=..TL2H(INITTime)
	s FrLocDesc=$s(FrLocId'="":$p(^CTLOC(FrLocId),"^",2),1:"")
	s ToLocDesc=$s(ToLocId'="":$p(^CTLOC(ToLocId),"^",2),1:"")
	s:$f(FrLocDesc,"-") FrLocDesc=$p(FrLocDesc,"-",2)
	s:$f(ToLocDesc,"-") ToLocDesc=$p(ToLocDesc,"-",2)
	s INITUserName=""
	s:INITUser'="" INITUserName=$p(^SSU("SSUSR",INITUser),"^",2)
	
	s (ReqNo,ReqUser,ReqUserName,ReqRemark,ReqAuditUserId,ReqAuditUserName,ReqProAuditUserId,ReqProAuditUserName)=""
	i +ReqId'=0 d
	.s ReqNo=$p(^INRQ(ReqId),"^",1)
	.s ReqUser=$p(^INRQ(ReqId),"^",4)
	.s:ReqUser'="" ReqUserName=$p(^SSU("SSUSR",ReqUser),"^",2)
	.s ReqRemark=$g(^INRQ(ReqId,"REM",1))   //请求备注
	.s DHCInrq=$o(^DHCINRQ(0,"INRQ",ReqId,""),-1)
	.i DHCInrq'="" d
	..s ReqAuditUserId=$p(^DHCINRQ(DHCInrq),"^",11)
	..s:ReqAuditUserId'="" ReqAuditUserName=$p(^SSU("SSUSR",ReqAuditUserId),"^",2)
	..s ReqProAuditUserId=$p(^DHCINRQ(DHCInrq),"^",14)
	..s:ReqProAuditUserId'="" ReqProAuditUserName=$p(^SSU("SSUSR",ReqProAuditUserId),"^",2)
	
	s (OperateTypeDesc,INITInAckUserName)=""
	s:OperateType'="" OperateTypeDesc=$p(^DHCOPTYPE(OperateType),"^",2)
	s HospId=$s(FrLocId'="":$p(^CTLOC(FrLocId),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	i INITInAckUserDR'="" d
	.;使用: 人员姓名[人员Initials]
	.s INITInAckUserName=$p(^SSU("SSUSR",INITInAckUserDR),"^",2)_"["_$p(^SSU("SSUSR",INITInAckUserDR),"^",1)_"]"
	s PrintTime=..DL2H(+$h)
	s INITReqUserDR=$p(^DHCINIT(Init),"^",28)
	s INITReqUser=""
	i INITReqUserDR'="" d
	.;使用: 人员姓名[人员Initials]
	.s INITReqUser=$p(^SSU("SSUSR",INITReqUserDR),"^",2)_"["_$p(^SSU("SSUSR",INITReqUserDR),"^",1)_"]"
	s PrintCount=..GetBillPrintCount("T",Init)
	s INITAckUserName=$s(INITAckUserDR'="":$p(^SSU("SSUSR",INITAckUserDR),"^",2),1:"")
	s ReprintFlag=""
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutInitDetail
	Quit $$$OK
	
OutPutInitDetail
	s Data=$lb(INITRowId,INITAckDate,INITAcknowCompleted,INITAckTime,INITAckUserDR,
		INITDate,FrLocId,ReqId,INITNo,INITRemarks,
		INITUser,INITTime,ToLocId,INITType,INITUserCompleted,
		INITState,INITInAckDate,INITInAckTime,INITInAckUserDR,INITIsTrfDR,
		INITOperationRemark,OperateType,INITINGRDr,INITPrintFlag,INITSCGDR,
		INITStkType,FrLocDesc,ToLocDesc,ReqNo,INITDate,
		ReqId,INITUserName,OperateTypeDesc,INITTime,ReqUserName,
		ReqRemark,ScgDesc,HospDesc,INITInAckUserName,PrintTime,
		INITReqUserDR,INITReqUser,PrintCount,INITAckUserName,ReqAuditUserName,
		ReqProAuditUserName,ReprintFlag
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	订单信息query
/// Creator:	wangjiabin
/// CreateDate:	2016-07-13
/// Table:		IN_PO
/// Input:		Parref(主表rowid)
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInpoDetail",1381)
Query GetInpoDetail(Parref As %String) As Query(ROWSPEC = "INPO,INPONo,INPOAPCVMDR,INPODate,INPOCTCURDR,INPOExRate,INPOHandChg,INPOSSUSRDR,INPORemarks,INPOApproved,INPOCompleted,INPOReferenceDR,INPOTransDate,INPOTransTime,INPODateNeeded,INPOUserCompleted,INPOUserCompletedDR,INPOCreditTermDR,INPOUserUpdatedDR,INPOCancelled,INPOFullFilled,INPOUserCancFullFilledDR,INPODateCancelFullFilled,INPOTimeCancelFullFilled,INPOReasonCancFullFilledDR,PoLoc,PoLocDesc,StkGrpId,StkType,VenDesc,user,date,HospDesc,printTime,PrintCount:%Integer,ReprintFlag") [ SqlProc ]
{
}

ClassMethod GetInpoDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	&sql(SELECT IN_PO, INPO_No, INPO_APCVM_DR, INPO_Date, INPO_CTCUR_DR, INPO_ExRate, INPO_HandChg, 
		INPO_SSUSR_DR,INPO_Remarks, INPO_Approved , INPO_Completed, INPO_Reference_DR, INPO_TransDate,
		INPO_TransTime, INPO_DateNeeded, INPO_UserCompleted, INPO_UserCompleted_DR, INPO_CreditTerm_DR,
		INPO_UserUpdated_DR, INPO_Cancelled, INPO_FullFilled, INPO_UserCancFullFilled_DR,
		INPO_DateCancelFullFilled, INPO_TimeCancelFullFilled, INPO_ReasonCancFullFilled_DR  
	into
		INPO, INPONo, INPOAPCVMDR, INPODate, INPOCTCURDR, INPOExRate, INPOHandChg,INPOSSUSRDR,
		INPORemarks, INPOApproved , INPOCompleted, INPOReferenceDR, INPOTransDate,INPOTransTime,
		INPODateNeeded, INPOUserCompleted, INPOUserCompletedDR, INPOCreditTermDR,INPOUserUpdatedDR,
		INPOCancelled, INPOFullFilled, INPOUserCancFullFilledDR,INPODateCancelFullFilled, INPOTimeCancelFullFilled,
		INPOReasonCancFullFilledDR
	from IN_PO where %ID=:Parref) 
	q:SQLCODE $$$OK
	
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s InGrRemarks=$lts($g(INPORemarks),memoDelim)
	s (VenDesc,user,date)=""
	i INPOAPCVMDR'="" d
	.s VenDesc=$p(^APC("APCVM",INPOAPCVMDR),"^",3)
	i INPOSSUSRDR'="" d
	.s user=$p(^SSU("SSUSR",INPOSSUSRDR),"^",2)
	i (INPODate'="")&&(INPODate'["-") d
	.s date=..DL2H(INPODate)
	s (PoLoc,PoLocDesc,StkGrpId,StkType)=""
	s DhcPoId=$o(^DHCINPO(0,"INPO",Parref,0))
	i DhcPoId'=""  d
	.s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
	.s:PoLoc'="" PoLocDesc=$p(^CTLOC(PoLoc),"^",2)
	.s:$f(PoLocDesc,"-") PoLocDesc=$p(PoLocDesc,"-",2)
	.s Type=$p(^DHCINPO(DhcPoId),"^",4)
	.s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
	.s:StkGrpId'="" StkType=$p(^DHCSCG(StkGrpId),"^",2)
	s HospId=$s(PoLoc'="":$p(^CTLOC(PoLoc),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)
	s PrintCount=..GetBillPrintCount("PO",Parref)
	s ReprintFlag=""
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutInpoDetail
	Quit $$$OK
	
OutPutInpoDetail
	s Data=$lb(INPO,INPONo,INPOAPCVMDR,INPODate,INPOCTCURDR,
		INPOExRate,INPOHandChg,INPOSSUSRDR,INPORemarks,INPOApproved,
		INPOCompleted,INPOReferenceDR,INPOTransDate,INPOTransTime,INPODateNeeded,
		INPOUserCompleted,INPOUserCompletedDR,INPOCreditTermDR,INPOUserUpdatedDR,INPOCancelled,
		INPOFullFilled,INPOUserCancFullFilledDR,INPODateCancelFullFilled,INPOTimeCancelFullFilled,INPOReasonCancFullFilledDR,
		PoLoc,PoLocDesc,StkGrpId,StkType,VenDesc,
		user,date,HospDesc,printTime,PrintCount,ReprintFlag
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	库存调整单信息query
/// Creator:	wangjiabin
/// CreateDate:	2016-07-13
/// Table:		DHC_INAdj
/// Input:		adj(主表rowid)
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInscrapDetail",13)
Query GetInscrapDetail(adj As %String) As Query(ROWSPEC = "INADRemarks,INADINSTDR,INADSSUSRDR,INADDate,INADNo,INADTime,INADReasonAdjDR,INADState,INADChkDate,INADChkTime,INADChkUSRDR,INADAdjDR,INADSCGDR,INADCompleted,INADChkFlag,INADStkType,INADCTLOCDR,userName,chkUserName,locDesc,reasonDesc,scgDesc,HospDesc,printTime,PrintCount:%Float,ReprintFlag") [ SqlProc ]
{
}

ClassMethod GetInscrapDetailExecute(ByRef qHandle As %Binary, adj As %String) As %Status
{
	n (qHandle,adj)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:adj="" $$$OK
	s (INADRemarks,INADINSTDR,INADSSUSRDR,INADDate,INADNo,INADTime,INADReasonAdjDR,INADState,INADChkDate,INADChkTime,INADChkUSRDR,INADAdjDR,INADSCGDR,INADCompleted,INADChkFlag,INADStkType,INADCTLOCDR,userName,chkUserName,locDesc,reasonDesc,scgDesc)=""
	&sql(SELECT INAD_Remarks,INAD_INST_DR,INAD_SSUSR_DR,INAD_Date,INAD_No,
		INAD_Time,INAD_ReasonAdj_DR,INAD_State,INAD_ChkDate,INAD_ChkTime,
		INAD_ChkUSR_DR,INAD_Adj_DR,INAD_SCG_DR,INAD_Completed,INAD_ChkFlag,
		INAD_StkType,INAD_CTLOC_DR,inad_ssusr_dr->ssusr_name userName,inad_chkusr_dr->ssusr_name,inad_ctloc_Dr->ctloc_desc,
		inad_reasonadj_dr->adj_desc,inad_scg_dr->scg_desc
	into
		INADRemarks,INADINSTDR,INADSSUSRDR,INADDate,INADNo,
		INADTime,INADReasonAdjDR,INADState,INADChkDate,INADChkTime,
		INADChkUSRDR,INADAdjDR,INADSCGDR,INADCompleted,INADChkFlag,
		INADStkType,INADCTLOCDR,userName,chkUserName,locDesc,
		reasonDesc,scgDesc
	from DHC_INAdj where %ID=:adj)
	q:SQLCODE $$$OK
	
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s INADRemarks=$lts($g(INADRemarks),memoDelim)
	s:INADDate'="" INADDate=..DL2H(INADDate)
	s:INADTime'="" INADTime=..TL2H(INADTime)
	s:INADChkDate'="" INADChkDate=..DL2H(INADChkDate)
	s:INADChkTime'="" INADChkTime=..TL2H(INADChkTime)
	s:$f(locDesc,"-") locDesc=$p(locDesc,"-",2)
	s HospId=$s(INADCTLOCDR'="":$p(^CTLOC(INADCTLOCDR),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)
	s PrintCount=..GetBillPrintCount("A",adj)
	s ReprintFlag=""
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutInscrapDetail
	Quit $$$OK
	
OutPutInscrapDetail
	s Data=$lb(INADRemarks,INADINSTDR,INADSSUSRDR,INADDate,INADNo,
		INADTime,INADReasonAdjDR,INADState,INADChkDate,INADChkTime,
		INADChkUSRDR,INADAdjDR,INADSCGDR,INADCompleted,INADChkFlag,
		INADStkType,INADCTLOCDR,userName,chkUserName,locDesc,
		reasonDesc,scgDesc,HospDesc,printTime,PrintCount,ReprintFlag
	)
	
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript: 采购计划单query
/// Creator: tsr
/// CreateDate:	2017-08-16
/// Table: IN_Purplan
/// Input: PurId(主表rowid)
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInpurDetail",28)
Query GetInpurDetail(purId As %String) As Query(ROWSPEC = "INPPNo,INPPDate,INPPSSUSRDR,INPPUserName,INPPAuditDate,INPPAuditSSUSRDR,INPPAuditUserName,INPPPoFlag,INPPCTLOCDR,INPPLocDesc,INPPComplete,INPPTime,INPPAuditTime,INPPAuditFlag,INPPSCGDR,INPPSCGDesc,INPPStkType,INPPOperateType,INPPUrgentFlag,INPPRemarks,INPPRefuseCase,INPPIFRECFLAG,INPPDateNeeded,HospDesc,printTime,PrintCount:%Integer,ReprintFlag") [ SqlProc ]
{
}

ClassMethod GetInpurDetailExecute(ByRef qHandle As %Binary, purId As %String) As %Status
{
	n (qHandle,purId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:purId="" $$$OK
	s (INPPNo,INPPDate,INPPSSUSRDR,INPPUserName,INPPAuditDate,INPPAuditSSUSRDR,INPPAuditUserName,INPPPoFlag,INPPCTLOCDR,INPPLocDesc,INPPComplete,INPPTime,INPPAuditTime,INPPAuditFlag,INPPSCGDR,INPPSCGDesc,INPPStkType,INPPOperateType,INPPUrgentFlag,INPPRemarks,INPPRefuseCase,INPPIFRECFLAG,INPPDateNeeded)=""
	&sql(SELECT INPP_No, INPP_Date, INPP_SSUSR_DR, INPP_SSUSR_DR->SSUSR_Name, INPP_AuditDate,
		INPP_AuditSSUSR_DR, INPP_AuditSSUSR_DR->SSUSR_Name, INPP_PoFlag, INPP_CTLOC_DR,
		INPP_CTLOC_DR->CTLOC_Desc, INPP_Complete, INPP_Time, INPP_AuditTime, INPP_AuditFlag,
		INPP_SCG_DR, INPP_SCG_DR->SCG_Desc, INPP_StkType, INPP_OperateType, INPP_UrgentFlag,
		INPP_Remarks, INPP_RefuseCase, INPP_IFRECFLAG, INPP_DateNeeded
	into
		INPPNo, INPPDate, INPPSSUSRDR, INPPUserName, INPPAuditDate,
		INPPAuditSSUSRDR, INPPAuditUserName, INPPPoFlag, INPPCTLOCDR,
		INPPLocDesc, INPPComplete, INPPTime, INPPAuditTime, INPPAuditFlag,
		INPPSCGDR, INPPSCGDesc, INPPStkType, INPPOperateType, INPPUrgentFlag,
		INPPRemarks, INPPRefuseCase, INPPIFRECFLAG, INPPDateNeeded
	from IN_PurPlan where %ID=:purId)
	q:SQLCODE $$$OK
	
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s INPPRemarks=$lts($g(INPPRemarks),memoDelim)
	s:INPPDate'="" INPPDate=..DL2H(INPPDate)
	s:INPPTime'="" INPPTime=..TL2H(INPPTime)
	s:INPPAuditDate'="" INPPAuditDate=..DL2H(INPPAuditDate)
	s:INPPAuditTime'="" INPPAuditTime=..TL2H(INPPAuditTime)
	s:$f(INPPLocDesc,"-") INPPLocDesc=$p(INPPLocDesc,"-",2)
	s HospId=$s(INPPCTLOCDR'="":$p(^CTLOC(INPPCTLOCDR),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)
	s PrintCount=..GetBillPrintCount("INPP",purId)
	s ReprintFlag=""
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutInpurDetail
	Quit $$$OK
	
OutPutInpurDetail
	s Data=$lb(INPPNo,INPPDate,INPPSSUSRDR,INPPUserName,INPPAuditDate,
		INPPAuditSSUSRDR,INPPAuditUserName,INPPPoFlag,INPPCTLOCDR,INPPLocDesc,
		INPPComplete,INPPTime,INPPAuditTime,INPPAuditFlag,INPPSCGDR,
		INPPSCGDesc,INPPStkType,INPPOperateType,INPPUrgentFlag,INPPRemarks,
		INPPRefuseCase,INPPIFRECFLAG,INPPDateNeeded,HospDesc,printTime,
		PrintCount,ReprintFlag
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取物资库存项的详细信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-04
/// Table:		INC_Itm,DHC_ItmAddionInfo
/// Input:		
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInciDetail")
Query GetInciDetail() As Query(ROWSPEC = "InciId,InciCode,InciDesc,PurUomDesc,BUomDesc,BillUomDesc,StkCatDesc,NotUseFlag,ManfId,ManfDesc,Vendor,VendorDesc,HVFlag,ChargeFlag,ImplantFlag,Spec,Brand,Model,Abbrev,Supervision,Origin,BookCatId,BookCatCode,BookCatDesc,LastVenId,LastVenDesc,ArcCode,ArcDesc,ArcEffDateTo,CertNo,CertExpDate,CertItmDesc") [ SqlProc ]
{
}

ClassMethod GetInciDetailExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s StkType=..sssCode()
	s InciId=0
	f  s InciId=$o(^INCI(InciId)) q:InciId=""  d
	.q:+InciId'>0
	.q:'$d(^INCI(InciId,1))
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.q:StkCatId=""
	.s StkCatType=$p(^INC("SC",StkCatId),"^",3)
	.q:StkCatType'=StkType
	.
	.s (HVFlag,ChargeFlag,ImplantFlag,Spec,Brand,Model,Abbrev,Supervision,Origin,BookCatId,BookCatCode,BookCatDesc)=""
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,""))
	.i InfoId'="" d
	..s AddionInfo=$G(^DHCITMINFO(InfoId))
	..s HVFlag=$p(AddionInfo,"^",12)
	..s Spec=$p(AddionInfo,"^",27)
	..s BookCatId=$p(AddionInfo,"^",36)
	..s ChargeFlag=$p(AddionInfo,"^",57)
	..s Brand=$p(AddionInfo,"^",58)
	..s Model=$p(AddionInfo,"^",59)
	..s Abbrev=$p(AddionInfo,"^",60)
	..s Supervision=$p(AddionInfo,"^",61)
	..s ImplantFlag=$p(AddionInfo,"^",62)
	..s OriginId=$p(AddionInfo,"^",100)
	..s:OriginId'="" Origin=$p(^DHCSTORI(OriginId),"^",2)
	..s:BookCatId'="" BookCatCode=$p(^DHCSTBC(BookCatId),"^",1)
	..s:BookCatId'="" BookCatDesc=$p(^DHCSTBC(BookCatId),"^",2)
	.s:HVFlag="" HVFlag="N"
	.s:ChargeFlag="" ChargeFlag="N"
	.s:ImplantFlag="" ImplantFlag="N"
	.
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomDesc="",PurUomDesc="",StkCatDesc=""
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	.
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.s BillUom=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuom(ArcId)
	.s BillUomDesc=$p(BillUom,"^",2)   
	.s (ArcCode,ArcDesc,ArcEffDateTo)=""
	.i ArcId'="" d
	..s ArcSub=$p(ArcId,"||",1),ArcVer=$p(ArcId,"||",2)
	..q:(ArcSub="")||(ArcVer="")
	..s ArcCode=$p($g(^ARCIM(ArcSub,ArcVer,1)),"^",1)
	..s ArcDesc=$p($g(^ARCIM(ArcSub,ArcVer,1)),"^",2)
	..s ArcEffDateTo=$p($g(^ARCIM(ArcSub,ArcVer,7)),"^",1)
	..s:ArcEffDateTo'="" ArcEffDateTo=..DL2H(ArcEffDateTo)
	.
	.s Manf=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)
	.s ManfId=$p(Manf,"^",1)
	.s ManfDesc=$p(Manf,"^",2)
	.
	.s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(+InciId)
	.s Vendor=$p(VendorStr,"^")
	.s VendorDesc=$p(VendorStr,"^",2)
	.
	.s CertInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(InciId)
	.s CertNo=$p(CertInfo,"^",1)
	.s CertExpDate=$p(CertInfo,"^",2)
	.s CertItmDesc=$p(CertInfo,"^",3)
	.
	.s LastVenInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastVen(InciId)
	.s LastVenId=$p(LastVenInfo,"^",1)
	.s LastVenDesc=$p(LastVenInfo,"^",2)
	.
	.d OutPutInciDetail
	Quit $$$OK

OutPutInciDetail
	s Data=$lb(InciId,InciCode,InciDesc,PurUomDesc,BUomDesc,BillUomDesc,StkCatDesc,NotUseFlag,ManfId,ManfDesc,
		Vendor,VendorDesc,HVFlag,ChargeFlag,ImplantFlag,Spec,Brand,Model,Abbrev,Supervision,
		Origin,BookCatId,BookCatCode,BookCatDesc,LastVenId,LastVenDesc,ArcCode,ArcDesc,ArcEffDateTo,CertNo,
		CertExpDate,CertItmDesc
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取账簿分类
/// Creator:	wangjiabin
/// CreateDate:	2017-07-11
/// Table:		DHCST_BookCat
/// Input:		
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetBookCat")
Query GetBookCat() As Query(ROWSPEC = "BookCatId,BookCatCode,BookCatDesc") [ SqlProc ]
{
}

ClassMethod GetBookCatExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s StkType=..sssCode()
	s BookCatId=0
	f  s BookCatId=$o(^DHCSTBC(BookCatId)) q:BookCatId=""  d
	.s BookCatInfo=^DHCSTBC(BookCatId)
	.s BookCatCode=$p(BookCatInfo,"^",1)
	.;q:$e(BookCatCode,1)'="M"
	.s BookCatDesc=$p(BookCatInfo,"^",2)
	.s Remarks=$p(BookCatInfo,"^",3)
	.s UseFlag=$p(BookCatInfo,"^",4)
	.
	.d OutPutBookCatDetail
	Quit $$$OK

OutPutBookCatDetail
	s Data=$lb(BookCatId,BookCatCode,BookCatDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取供应商的详细信息
/// Creator:	wangjiabin
/// CreateDate:	2017-08-17
/// Table:		APC_Vendor,DHC_STVendor
/// Input:		
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetAPCVendorDetail")
Query GetAPCVendorDetail() As Query(ROWSPEC = "Rowid,Code,Name,Tel,ConPerson,CtrlAcct,CrLimit,Fax,President,PresidentId,Status,CategoryId,Category,CrAvail,LstPoDate,Address,ComLic,ComLicDate,AgentLic,DrugManLic,DrugManLicDate,Gsp,GspDate,ImportEnrol,ImportEnrolDate,ImportLic,ImportLicDate,MatEnrol,MatEnrolDate,MatManLic,MatManLicDate,MatPro,MatProDate,OrgCode,OrgCodeDate,Promises,ProPermit,ProPermitDate,RevReg,RevRegDate,Sanitation,SanitationDate,TrustDeed,Quality,QualityDate,AgentLicDate,SalesName,SalesNameDate,SalesTel,SalesID,ParVendor,ParVendorName,Abbrev,PresidentTel,Email,SalesCarrTel,Sms,PurchPlat,STVBarcode,LstBsDate,VendorAlias,bankLicApprovalNo,bankLicNo,registration,businessTerm,establishedDate,vendorEmail,coRenameFlag,carryFlag,regAddress,responsiblePerson,qualityManager,depotAddress,filingVoucher,matCatOfficial,ComLicIssuedDate,ComLicIssuedDept,RevRegIssuedDate,RevRegIssuedDept,OrgCodeIssuedDate,OrgCodeIssuedDept,DrugManLicIssuedDate,DrugManLicIssuedDept,MatManLicIssuedDate,MatManLicIssuedDept,MatProIssuedDate,MatProIssuedDept,GspIssuedDate,GspIssuedDept,DrugProIssuedDate,DrugProIssuedDept,matCatOfficialDesc,SocialCreditExpDate,SalesFax") [ SqlProc ]
{
}

ClassMethod GetAPCVendorDetailExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s StkType=..sssCode()
	s Rowid=0
	f  s Rowid=$o(^APC("APCVM",Rowid)) q:Rowid=""  d
	.
	.s Code=$p(^APC("APCVM",Rowid),"^",2)
	.s Name=$p(^APC("APCVM",Rowid),"^",3)
	.s Tel=$p(^APC("APCVM",Rowid),"^",7)
	.s ConPerson=$p(^APC("APCVM",Rowid),"^",8)		;开户行
	.s CtrlAcct=$p(^APC("APCVM",Rowid),"^",10)		;账户
	.s CrLimit=$p(^APC("APCVM",Rowid),"^",11)		;信贷限额采购额
	.s Fax=$p(^APC("APCVM",Rowid),"^",15)			;传真
	.s tmp=$p(^APC("APCVM",Rowid),"^",16)   
	.s President=$p(tmp,"||",1)						;法人
	.s PresidentId=$p(tmp,"||",2)					;法人身份证
	.s PresidentTel=$p(tmp,"||",3)					;法人电话
	.s Status=$p(^APC("APCVM",Rowid),"^",18)		;状态
	.s CategoryId=$p($G(^APC("APCVM",Rowid,1)),"^",1)	;分类id
	.s:CategoryId'="" Category=$p(^APC("APCVC",CategoryId),"^",3)
	.s CrAvail=$p($G(^APC("APCVM",Rowid,1)),"^",2)		;注册资金
	.s LstPoDate=$p($G(^APC("APCVM",Rowid,1)),"^",6)	;合同截止日期
	.s:LstPoDate'="" LstPoDate=..DL2H(LstPoDate)
	.s Address=##class(web.DHCSTMHUI.APCVenNew).GetAddress(Rowid)
	.s LstBsDate=$p($G(^APC("APCVM",Rowid,1)),"^",13)	;最后业务日期
	.s:LstBsDate'="" LstBsDate=..DL2H(LstBsDate)
	.s registration=$p($G(^APC("APCVM",Rowid)),"^",17)	//统一社会信用码
	.
	.s (ComLic,ComLicDate,AgentLic,DrugManLic,DrugManLicDate,Gsp,GspDate,ImportEnrol,ImportEnrolDate,ImportLic,ImportLicDate,MatEnrol,MatEnrolDate,MatManLic,MatManLicDate,MatPro,MatProDate,OrgCode,OrgCodeDate,Promises,ProPermit,ProPermitDate,RevReg,RevRegDate,Sanitation,SanitationDate,TrustDeed,Quality,AgentLicDate,QualityDate,SalesName,SalesNameDate,SalesTel,ParVendor,Abbrev,SalesID,Email,ParVendorName,SalesCarrTel,STVBarcode,Sms,PurchPlat,Alias,VendorAlias,bankLicApprovalNo,bankLicNo,businessTerm,establishedDate,vendorEmail,coRenameFlag,carryFlag,regAddress,responsiblePerson,qualityManager,depotAddress,filingVoucher,ComLicIssuedDate,ComLicIssuedDept,RevRegIssuedDate,RevRegIssuedDept,OrgCodeIssuedDate,OrgCodeIssuedDept,DrugManLicIssuedDate,DrugManLicIssuedDept,MatManLicIssuedDate,MatManLicIssuedDept,MatProIssuedDate,MatProIssuedDept,GspIssuedDate,GspIssuedDept,DrugProIssuedDate,DrugProIssuedDept,matCatOfficial,SocialCreditExpDate,SalesFax)=""
	.s STV=$o(^DHCSTV(0,Rowid,""))
	.i STV'=""  d
	..s ComLic=$p(^DHCSTV(STV),"^",1)					;工商执照
	..s ComLicDate=$p(^DHCSTV(STV),"^",2)
	..s:ComLicDate'="" ComLicDate=..DL2H(ComLicDate)
	..s AgentLic=$p(^DHCSTV(STV),"^",3)					;代理授权书
	..s DrugManLic=$p(^DHCSTV(STV),"^",4)				;药品经营许可证
	..s DrugManLicDate=$p(^DHCSTV(STV),"^",5)			;药品经营许可证有效期
	..s:DrugManLicDate'="" DrugManLicDate=..DL2H(DrugManLicDate)
	..s Gsp=$p(^DHCSTV(STV),"^",6)						;GSP认证
	..s GspDate=$p(^DHCSTV(STV),"^",7)					;GSP认证有效期
	..s:GspDate'="" GspDate=..DL2H(GspDate)
	..s ImportEnrol=$p(^DHCSTV(STV),"^",8)				;进口注册证
	..s ImportEnrolDate=$p(^DHCSTV(STV),"^",9)			;进口注册证有效期
	..s:ImportEnrolDate'="" ImportEnrolDate=..DL2H(ImportEnrolDate)
	..s ImportLic=$p(^DHCSTV(STV),"^",10)				;进口注册登记表
	..s ImportLicDate=$p(^DHCSTV(STV),"^",11)			;进口注册登记表有效期
	..s:ImportLicDate'="" ImportLicDate=..DL2H(ImportLicDate)
	..s MatEnrol=$p(^DHCSTV(STV),"^",12)				;器械注册证
	..s MatEnrolDate=$p(^DHCSTV(STV),"^",13)			;器械注册证有效期
	..s:MatEnrolDate'="" MatEnrolDate=..DL2H(MatEnrolDate)
	..s MatManLic=$p(^DHCSTV(STV),"^",14)				;器械经营许可证
	..s MatManLicDate=$p(^DHCSTV(STV),"^",15)			;器械经营许可证有效期
	..s:MatManLicDate'="" MatManLicDate=..DL2H(MatManLicDate)
	..s MatPro=$p(^DHCSTV(STV),"^",16)					;器械生产许可证
	..s MatProDate=$p(^DHCSTV(STV),"^",17)				;器械生产许可证有效期
	..s:MatProDate'="" MatProDate=..DL2H(MatProDate)
	..s OrgCode=$p(^DHCSTV(STV),"^",18)					;组织机构代码
	..s OrgCodeDate=$p(^DHCSTV(STV),"^",19)				;组织机构有效期
	..s:OrgCodeDate'="" OrgCodeDate=..DL2H(OrgCodeDate)
	..s Promises=$p(^DHCSTV(STV),"^",20)				;售后承诺服务书
	..s ProPermit=$p(^DHCSTV(STV),"^",21)				;药品生产许可证
	..s ProPermitDate=$p(^DHCSTV(STV),"^",22)			;药品生产许可证有效期
	..s:ProPermitDate'="" ProPermitDate=..DL2H(ProPermitDate)
	..s RevReg=$p(^DHCSTV(STV),"^",23)					;税务登记
	..s RevRegDate=$p(^DHCSTV(STV),"^",24)				;税务登记有效期
	..s:RevRegDate'="" RevRegDate=..DL2H(RevRegDate)
	..s Sanitation=$p(^DHCSTV(STV),"^",25)				;药品注册批件
	..s SanitationDate=$p(^DHCSTV(STV),"^",26)			;药品注册批件有效期
	..s:SanitationDate'="" SanitationDate=..DL2H(SanitationDate)
	..s TrustDeed=$p(^DHCSTV(STV),"^",27)				;法人委托书
	..s Quality=$p(^DHCSTV(STV),"^",29)					;质量承诺书
	..s AgentLicDate=$p(^DHCSTV(STV),"^",30)			;代理授权书有效期
	..s:AgentLicDate'="" AgentLicDate=..DL2H(AgentLicDate)
	..s QualityDate=$p(^DHCSTV(STV),"^",31)				;质量承诺书有效期
	..s:QualityDate'="" QualityDate=..DL2H(QualityDate)
	..s SalesName=$p(^DHCSTV(STV),"^",32)				;业务员姓名
	..s SalesNameDate=$p(^DHCSTV(STV),"^",33)			;业务员授权书有效期  
	..s:SalesNameDate'="" SalesNameDate=..DL2H(SalesNameDate)
	..s SalesTel=$p(^DHCSTV(STV),"^",34)				;业务员电话
	..s ParVendor=$p(^DHCSTV(STV),"^",36)				;上一级供应商
	..s Abbrev=$p(^DHCSTV(STV),"^",37)					;简称
	..s SalesID=$p(^DHCSTV(STV),"^",38)					;业务员身份证号
	..s Email=$p(^DHCSTV(STV),"^",39)					;业务员身份证号
	..s ParVendorName=""
	..i ParVendor'="" s ParVendorName=$p(^APC("APCVM",ParVendor),"^",3)
	..s SalesCarrTel=$p(^DHCSTV(STV),"^",40)			;配送手机号
	..s STVBarcode=$p(^DHCSTV(STV),"^",42)
	..s Sms=$p(^DHCSTV(STV),"^",43) ;
	..s PurchPlat=$p(^DHCSTV(STV),"^",44)
	..s Alias=$p(^DHCSTV(STV),"^",46)
	..s VendorAlias=$p(Alias,"/",1)						;第一部分为自行维护的助记码
	..s bankLicApprovalNo=$p(^DHCSTV(STV),"^",50)
	..s bankLicNo=$p(^DHCSTV(STV),"^",51)
	..s businessTerm=$p(^DHCSTV(STV),"^",52)
	..s:businessTerm'="" businessTerm=..DL2H(businessTerm)
	..s establishedDate=$p(^DHCSTV(STV),"^",53)
	..s:establishedDate'="" establishedDate=..DL2H(establishedDate)
	..s vendorEmail=$p(^DHCSTV(STV),"^",54)
	..s coRenameFlag=$p(^DHCSTV(STV),"^",55)
	..s carryFlag=$p(^DHCSTV(STV),"^",56)
	..s regAddress=$p(^DHCSTV(STV),"^",57)
	..s responsiblePerson=$p(^DHCSTV(STV),"^",58)
	..s qualityManager=$p(^DHCSTV(STV),"^",59)
	..s depotAddress=$p(^DHCSTV(STV),"^",60)
	..s filingVoucher=$p(^DHCSTV(STV),"^",61)
	..s ComLicIssuedDate=$p(^DHCSTV(STV),"^",62)
	..s:ComLicIssuedDate'="" ComLicIssuedDate=..DL2H(ComLicIssuedDate)
	..s ComLicIssuedDept=$p(^DHCSTV(STV),"^",63)
	..s RevRegIssuedDate=$p(^DHCSTV(STV),"^",64)
	..s:RevRegIssuedDate'="" RevRegIssuedDate=..DL2H(RevRegIssuedDate)
	..s RevRegIssuedDept=$p(^DHCSTV(STV),"^",65)
	..s OrgCodeIssuedDate=$p(^DHCSTV(STV),"^",66)
	..s:OrgCodeIssuedDate'="" OrgCodeIssuedDate=..DL2H(OrgCodeIssuedDate)
	..s OrgCodeIssuedDept=$p(^DHCSTV(STV),"^",67)
	..s DrugManLicIssuedDate=$p(^DHCSTV(STV),"^",68)
	..s:DrugManLicIssuedDate'="" DrugManLicIssuedDate=..DL2H(DrugManLicIssuedDate)
	..s DrugManLicIssuedDept=$p(^DHCSTV(STV),"^",69)
	..s MatManLicIssuedDate=$p(^DHCSTV(STV),"^",70)
	..s:MatManLicIssuedDate'="" MatManLicIssuedDate=..DL2H(MatManLicIssuedDate)
	..s MatManLicIssuedDept=$p(^DHCSTV(STV),"^",71)
	..s MatProIssuedDate=$p(^DHCSTV(STV),"^",72)
	..s:MatProIssuedDate'="" MatProIssuedDate=..DL2H(MatProIssuedDate)
	..s MatProIssuedDept=$p(^DHCSTV(STV),"^",73)
	..s GspIssuedDate=$p(^DHCSTV(STV),"^",74)
	..s:GspIssuedDate'="" GspIssuedDate=..DL2H(GspIssuedDate)
	..s GspIssuedDept=$p(^DHCSTV(STV),"^",75)
	..s DrugProIssuedDate=$p(^DHCSTV(STV),"^",76)
	..s:DrugProIssuedDate'="" DrugProIssuedDate=..DL2H(DrugProIssuedDate)
	..s DrugProIssuedDept=$p(^DHCSTV(STV),"^",77)
	..s matCatOfficial=$p(^DHCSTV(STV),"^",78)
	..s:matCatOfficial'="" matCatOfficialDesc=$p(^DHCMCO(matCatOfficial),"^",2)
	..s SocialCreditExpDate=$p(^DHCSTV(STV),"^",79)
	..s:SocialCreditExpDate'="" SocialCreditExpDate=..DL2H(SocialCreditExpDate)
	..s SalesFax=$p(^DHCSTV(STV),"^",80)
	.
	.d OutPutVendorDetail
	Quit $$$OK

OutPutVendorDetail
	s Data=$lb(Rowid,
		Code,Name,Tel,ConPerson,CtrlAcct,CrLimit,Fax,President,PresidentId,Status,
		CategoryId,Category,CrAvail,LstPoDate,Address,ComLic,ComLicDate,AgentLic,DrugManLic,
		DrugManLicDate,Gsp,GspDate,ImportEnrol,ImportEnrolDate,ImportLic,ImportLicDate,MatEnrol,MatEnrolDate,MatManLic,
		MatManLicDate,MatPro,MatProDate,OrgCode,OrgCodeDate,Promises,ProPermit,ProPermitDate,RevReg,RevRegDate,
		Sanitation,SanitationDate,TrustDeed,Quality,QualityDate,AgentLicDate,SalesName,SalesNameDate,SalesTel,SalesID,
		ParVendor,ParVendorName,Abbrev,PresidentTel,Email,SalesCarrTel,Sms,PurchPlat,STVBarcode,LstBsDate,VendorAlias,
		bankLicApprovalNo,bankLicNo,registration,businessTerm,establishedDate,vendorEmail,coRenameFlag,carryFlag,regAddress,responsiblePerson,qualityManager,depotAddress,
		filingVoucher,matCatOfficial,ComLicIssuedDate,ComLicIssuedDept,RevRegIssuedDate,RevRegIssuedDept,OrgCodeIssuedDate,OrgCodeIssuedDept,DrugManLicIssuedDate,DrugManLicIssuedDept,MatManLicIssuedDate,MatManLicIssuedDept,
		MatProIssuedDate,MatProIssuedDept,GspIssuedDate,GspIssuedDept,DrugProIssuedDate,DrugProIssuedDept,matCatOfficialDesc,SocialCreditExpDate,SalesFax
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取单据本次打印之前的打印次数
/// Creator:	wangjiabin
/// CreateDate:	2017-11-26
/// Table:		DHC_MatBillPrintLog
/// Input:		Type, Pointer
/// 			参数值参考 ##class(web.DHCSTMHUI.Common.UtilCommon).BillPrintLog方法
/// Output:		打印次数
ClassMethod GetBillPrintCount(Type, Pointer) As %Integer
{
	n (Type,Pointer)
	q:(Type="")||(Pointer="") 0
	s PrintCount=0
	s LastPrtId=$o(^User.DHCMatBillPrintLogI("IndexTypePointer",Type,Pointer,""),-1)
	i LastPrtId'="" d
	.s LastPrtInfo=^User.DHCMatBillPrintLogD(LastPrtId)
	.s PrintCount=$lg(LastPrtInfo,11)
	q PrintCount
}

/// Descript:	库存请求单query
/// Creator:	lxt
/// CreateDate:	2017-12-20
/// Table:		IN_Request
/// Input:		Parref(主表rowid-INRQ_RowId)
/// Output:	 
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInreqDetail",42)
Query GetInreqDetail(Parref As %String) As Query(ROWSPEC = "reqid,reqNo,recLoc,RecLocDesc,CreateUserName,Status,CreateDate,CreateTime,ReqLoc,ReqLocDesc,Remarks,Completed,inrqtype,scg,ScgDesc,template,autoSum,AuditUser,AuditDate,AuditTime,ProvAuditUser,ProvAuditDate,ProvAuditTime,HospDesc,printTime,PrintCount,ReprintFlag,HospNo,PaName") [ SqlProc ]
{
}

ClassMethod GetInreqDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	s req=Parref
	q:+req=0 $$$OK	
	s (reqid,reqNo,reqLoc,ReqLocDesc,CreateUserName,Status,CreateDate,supLoc,SupLocDesc,CreateTime,Remarks,Completed)=""
	&sql(select INRQ_RowId,INRQ_No,INRQ_RecLoc_DR,INRQ_RecLoc_DR->ctloc_desc,INRQ_SSUSR_DR->SSUSR_name,INRQ_Status,INRQ_Date,INRQ_ReqLoc_DR,INRQ_ReqLoc_DR->ctloc_desc,INRQ_Time,INRQ_Remarks,INRQ_UserCompleted
	into reqid,reqNo,reqLoc,ReqLocDesc,CreateUserName,Status,CreateDate,supLoc,SupLocDesc,CreateTime,Remarks,Completed
	from IN_Request where %id=:req)
	q:SQLCODE'=0 $$$OK
	
	s Remarks=$lts(Remarks,..sssMemoDelim())
	s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	s:CreateTime'="" CreateTime=..TL2H(CreateTime)
	s:$f(ReqLocDesc,"-") ReqLocDesc=$p(ReqLocDesc,"-",2)
	s:$f(SupLocDesc,"-") SupLocDesc=$p(SupLocDesc,"-",2)
	
	s INRQRowId="",inrqtype="",stkcg="",inrqtype="",PAAdmDR="",HospNo="",PaName=""
	s INRQRowId=$o(^DHCINRQ(0,"INRQ",req,INRQRowId))
	i INRQRowId'="" d
	.s inrqtype=$p(^DHCINRQ(INRQRowId),"^",1)
	.s scg=$p(^DHCINRQ(INRQRowId),"^",10)
	.i scg'="" s ScgDesc=$p($G(^DHCSCG(scg)),"^",2)
	.s template=$p(^DHCINRQ(INRQRowId),"^",18)
	.s autoSum=$p(^DHCINRQ(INRQRowId),"^",19)
	.s AuditUser=$p(^DHCINRQ(INRQRowId),"^",11)
	.s:AuditUser'="" AuditUserName=$P(^SSU("SSUSR",AuditUser),"^",2)
	.s AuditDate=$p(^DHCINRQ(INRQRowId),"^",12)
	.s AuditTime=$p(^DHCINRQ(INRQRowId),"^",13)
	.s:AuditDate'="" AuditDate=..DL2H(AuditDate)
	.s:AuditTime'="" AuditTime=..TL2H(AuditTime)
	.s ProvAuditUser=$p(^DHCINRQ(INRQRowId),"^",14)
	.s:ProvAuditUser'="" ProvAuditUserName=$P(^SSU("SSUSR",ProvAuditUser),"^",2)
	.s ProvAuditDate=$p(^DHCINRQ(INRQRowId),"^",15)
	.s ProvAuditTime=$p(^DHCINRQ(INRQRowId),"^",16)
	.s:ProvAuditDate'="" ProvAuditDate=..DL2H(ProvAuditDate)
	.s:ProvAuditTime'="" ProvAuditTime=..TL2H(ProvAuditTime)
	.s PAAdmDR=$p(^DHCINRQ(INRQRowId),"^",34)
	i PAAdmDR'="" d
	.s HospNo=$p(^PAPER(PAAdmDR,"PAT",1),"^",22)  ;住院号,姓名
	.s PaName=$p(^PAPER(PAAdmDR,"ALL"),"^",1)
	s HospId=$s(reqLoc'="":$p(^CTLOC(reqLoc),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)
	s PrintCount=..GetBillPrintCount("RQ",req)
	s ReprintFlag=""
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutReqDetail
	Quit $$$OK
	
OutPutReqDetail
	s Data=$lb(reqid,reqNo,supLoc,SupLocDesc,CreateUserName,Status,CreateDate,CreateTime,
	reqLoc,ReqLocDesc,Remarks,Completed,inrqtype,scg,ScgDesc,template,autoSum,AuditUser,
	AuditDate,AuditTime,ProvAuditUser,ProvAuditDate,ProvAuditTime,HospDesc,printTime,
	PrintCount,ReprintFlag,HospNo,PaName
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	二级库发放单query
/// Creator:	wangjiabin
/// CreateDate:	2018-03-16
/// Table:		DHC_INDisp
/// Input:		Parref(主表rowid-INRQ_RowId)
/// Output:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetINDispDetail",1)
Query GetINDispDetail(Parref As %String) As Query(ROWSPEC = "INDSRowid,INDSNo,INDSDate,INDSTime,INDSSSUSRDR,INDSReasonAdjustment,INDSStOutTypeDR,INDSType,INDSRemarks,INDSCTLOCDR,INDSAckDate,INDSAckTime,INDSSSUSRAckDR,INDSStat,INDSCompleted,INDSSCGDR,INDSStkType,INDSAckFlag,INDSDispMode,INDSDispUserDR,INDSDispUserGrpDR,INDSRQDR,INDSTOLOCDR,InDispUser,chkUserName,InDispLoc,reasonDesc,InDispSCG,InDispRqNo,InDispGrp,InDispRecUser,INDSToLoc,HospDesc,PrintDateTime,PrintCount:%Integer") [ SqlProc ]
{
}

ClassMethod GetINDispDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	&sql(select INDS_Rowid,INDS_No,INDS_Date,INDS_Time,INDS_SSUSR_DR,
			INDS_ReasonAdjustment,INDS_StOutType_DR,INDS_Type,INDS_Remarks,INDS_CTLOC_DR,
			INDS_AckDate,INDS_AckTime,INDS_SSUSR_Ack_DR,INDS_Stat,INDS_Completed,
			INDS_SCG_DR,INDS_StkType,INDS_AckFlag,INDS_DispMode,INDS_DispUser_DR,
			INDS_DispUserGrp_DR,INDS_RQ_DR,INDS_TOLOC_DR,inds_ssusr_dr->ssusr_name,INDS_SSUSR_Ack_DR->ssusr_name,
			inds_ctloc_Dr->ctloc_desc,inds_ReasonAdjustment->adj_desc,inds_scg_dr->scg_desc,inds_rq_dr->dsrq_no,inds_dispusergrp_dr->LUG_GroupDesc,
			inds_dispuser_dr->SSUSR_Name,inds_toloc_dr->CTLoc_Desc
		into
			:INDSRowid,:INDSNo,:INDSDate,:INDSTime,:INDSSSUSRDR,
			:INDSReasonAdjustment,:INDSStOutTypeDR,:INDSType,:INDSRemarks,:INDSCTLOCDR,
			:INDSAckDate,:INDSAckTime,:INDSSSUSRAckDR,:INDSStat,:INDSCompleted,
			:INDSSCGDR,:INDSStkType,:INDSAckFlag,:INDSDispMode,:INDSDispUserDR,
			:INDSDispUserGrpDR,:INDSRQDR,:INDSTOLOCDR,:InDispUser,:chkUserName,
			:InDispLoc,:reasonDesc,:InDispSCG,:InDispRqNo,:InDispGrp,
			:InDispRecUser,:INDSToLoc
		from DHC_INDisp where %id=:Parref)
	q:SQLCODE'=0 $$$OK
	s:INDSDate'="" INDSDate=..DL2H(INDSDate)
	s:INDSTime'="" INDSTime=..TL2H(INDSTime)
	s:INDSAckDate'="" INDSAckDate=..DL2H(INDSAckDate)
	s:INDSAckTime'="" INDSAckTime=..TL2H(INDSAckTime)
	
	s HospId=$s(INDSCTLOCDR'="":$p(^CTLOC(INDSCTLOCDR),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s PrintDateTime=..DL2H(+$h)_" "_..TL2H($p($h,",",2))
	s PrintCount=..GetBillPrintCount("C",Parref)
	d OutINDispDetail
	Quit $$$OK
	
OutINDispDetail
	s Data=$lb(INDSRowid,INDSNo,INDSDate,INDSTime,INDSSSUSRDR,
		INDSReasonAdjustment,INDSStOutTypeDR,INDSType,INDSRemarks,INDSCTLOCDR,
		INDSAckDate,INDSAckTime,INDSSSUSRAckDR,INDSStat,INDSCompleted,
		INDSSCGDR,INDSStkType,INDSAckFlag,INDSDispMode,INDSDispUserDR,
		INDSDispUserGrpDR,INDSRQDR,INDSTOLOCDR,InDispUser,chkUserName,
		InDispLoc,reasonDesc,InDispSCG,InDispRqNo,InDispGrp,
		InDispRecUser,INDSToLoc,HospDesc,PrintDateTime,PrintCount)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	二级库请领打印query
/// Creator:	qiushengxin
/// Table:		DHC_INDispReq
/// Input:		Parref(主表rowid)
/// Output:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetINDispReqDetail",5)
Query GetINDispReqDetail(Parref As %String) As websys.Query(ROWSPEC = "DSRQRowId,DSRQNo,DSRQDispLocDR,DSRQSCGDR,DSRQDate,DSRQTime,DSRQSSUSRDR,DSRQReqMode,DSRQReqUserGrpDR,DSRQReqUserDR,DSRQRemark,DSRQDispLoc,DSRQSCG,DSRQSSUSR,DSRQReqUserGrp,DSRQReqUser,HospDesc,PrintTime") [ SqlProc ]
{
}

ClassMethod GetINDispReqDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s (DSRQDate,DSRQTime)=""
	&sql(SELECT DSRQ_RowId,DSRQ_No,DSRQ_DispLoc_DR,DSRQ_SCG_DR,DSRQ_Date,
			DSRQ_Time,DSRQ_SSUSR_DR,DSRQ_ReqMode,DSRQ_ReqUserGrp_DR,DSRQ_ReqUser_DR,
			DSRQ_Remark,DSRQ_DispLoc_DR->CTLOC_Desc,DSRQ_SCG_DR->SCG_Desc,DSRQ_SSUSR_DR->SSUSR_Name,
			DSRQ_ReqUserGrp_DR->LUG_GroupDesc,DSRQ_ReqUser_DR->SSUSR_Name
		into
			DSRQRowId,DSRQNo,DSRQDispLocDR,DSRQSCGDR,DSRQDate,
			DSRQTime,DSRQSSUSRDR,DSRQReqMode,DSRQReqUserGrpDR,DSRQReqUserDR,
			DSRQRemark,DSRQDispLoc,DSRQSCG,DSRQSSUSR,DSRQReqUserGrp,DSRQReqUser
		from DHC_INDispReq where %ID=:Parref)
	q:SQLCODE $$$OK
	
	s:DSRQDate'="" DSRQDate=..DL2H(DSRQDate)
	s:DSRQTime'="" DSRQTime=..TL2H(DSRQTime)
	s:$f(DSRQDispLoc,"-") DSRQDispLoc=$p(DSRQDispLoc,"-",2)
	s:DSRQReqMode=0 DSRQReqMode="专业组领用"
	s:DSRQReqMode=1 DSRQReqMode="个人领用"
	s HospId=$s(DSRQDispLocDR'="":$p(^CTLOC(DSRQDispLocDR),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s PrintTime=..DL2H(+$h)_" "_..TL2H($p($h,",",2))
	
	d OutPutINDispReqDetail
	Quit $$$OK
	
OutPutINDispReqDetail
	s Data=$lb(DSRQRowId,DSRQNo,DSRQDispLocDR,DSRQSCGDR,DSRQDate,
		DSRQTime,DSRQSSUSRDR,DSRQReqMode,DSRQReqUserGrpDR,DSRQReqUserDR,
		DSRQRemark,DSRQDispLoc,DSRQSCG,DSRQSSUSR,DSRQReqUserGrp,
		DSRQReqUser,HospDesc,PrintTime
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	二级库退回打印query
/// Creator:	qiushengxin
/// Table:		DHC_InDispRet
/// Input:		Parref(主表rowid)
/// Output:
Query GetInDispRetDetail(Parref As %String) As websys.Query(ROWSPEC = "DSRRowId,DSRNo,DSRSCGDR,DSRDate,DSRTime,DSRSSUSRDR,DSRAckUserDr,DSRAckDate,DSRAckTime,DSRRemark,DSRCTLOCDR,DSRLocDesc,DSRSCG,DSRSSUSR,DSRAckUser,HospDesc,printTime") [ SqlProc ]
{
}

ClassMethod GetInDispRetDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s (DSRDate,DSRTime,DSRAckDate,DSRAckTime)=""
	&sql(SELECT DSR_RowId,DSR_No,DSR_SCG_DR,DSR_Date,DSR_Time,
				DSR_SSUSR_DR,DSR_AckUser_Dr,DSR_AckDate,DSR_AckTime,
				DSR_Remark,DSR_CTLOC_DR,DSR_CTLOC_DR->CTLOC_Desc,DSR_SCG_DR->SCG_Desc,DSR_SSUSR_DR->SSUSR_Name,
				DSR_AckUser_Dr->SSUSR_Name
		into 	DSRRowId,DSRNo,DSRSCGDR,DSRDate,
				DSRTime,DSRSSUSRDR,DSRAckUserDr,DSRAckDate,DSRAckTime,
				DSRRemark,DSRCTLOCDR,DSRLocDesc,DSRSCG,DSRSSUSR,DSRAckUser
		from DHC_InDispRet where %ID=:Parref)
	q:SQLCODE $$$OK
	
	s:DSRDate'="" DSRDate=..DL2H(DSRDate)
	s:DSRTime'="" DSRTime=..TL2H(DSRTime)
	s:DSRAckDate'="" DSRAckDate=..DL2H(DSRAckDate)
	s:DSRAckTime'="" DSRAckTime=..TL2H(DSRAckTime)
	s:$f(DSRLocDesc,"-") DSRLocDesc=$p(DSRLocDesc,"-",2)
	s HospId=$s(DSRCTLOCDR'="":$p(^CTLOC(DSRCTLOCDR),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)_" "_..TL2H($p($h,",",2))
	
	d OutPutInDispRetDetail
	Quit $$$OK
	
OutPutInDispRetDetail
	s Data=$lb( DSRRowId,DSRNo,DSRSCGDR,DSRDate,
				DSRTime,DSRSSUSRDR,DSRAckUserDr,DSRAckDate,DSRAckTime,
				DSRRemark,DSRCTLOCDR,DSRLocDesc,DSRSCG,DSRSSUSR,DSRAckUser,
				HospDesc,printTime	
			) 
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	付款单query
/// Creator:	tsr
/// CreateDate:	2018-08-01
/// Table:		DHC_Pay
/// Input:		Pay(主表rowid)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetPayDetail",28)
Query GetPayDetail(Pay As %String) As Query(ROWSPEC = "PayNo,Vendor,LocDesc,CreatUser,Ack1User,Ack2User,Ack11User,PayDate,PayTime,CompletedDate,CompletedTime,PayMode,CheckNo,CheckDate,CheckAmt:%Float,Ack1Date,Ack2Date,Ack11Date,HospDesc,printTime") [ SqlProc ]
{
}

ClassMethod GetPayDetailExecute(ByRef qHandle As %Binary, Pay As %String) As %Status
{
	n (qHandle,Pay)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Pay="" $$$OK
	s (PayNo,Vendor,LocId,PayDate,PayTime,CreatUser,PayMode,Ack1Flag,Ack2Flag,CheckNo,CheckDate,CheckAmt,Ack1Date,Ack2Date,Ack1User,Ack2User,Completed, Ack11Flag, Ack11Date, Ack11User,CompletedDate,CompletedTime)=""
	&sql(SELECT PAY_No, PAY_APCVM_DR, PAY_CTLOC_DR, PAY_Date, PAY_Time,
		PAY_SSUSR_DR, PAY_Mode, PAY_Ack1, PAY_Ack2, PAY_CheckNo,
		PAY_CheckDate, PAY_CheckAmt, PAY_Date_Ack1, PAY_Date_Ack2, PAY_SSUSR_Ack1,
		PAY_SSUSR_Ack2, PAY_Completed, PAY_Ack11, PAY_Date_Ack11, PAY_SSUSR_Ack11,
		PAY_CompletedDate, PAY_CompletedTime
	into
		PayNo, Vendor, LocId, PayDate, PayTime,
		CreatUser, PayMode, Ack1Flag, Ack2Flag, CheckNo,
		CheckDate, CheckAmt, Ack1Date, Ack2Date, Ack1User,
		Ack2User, Completed, Ack11Flag, Ack11Date, Ack11User,
		CompletedDate, CompletedTime
	from DHC_Pay where %ID=:Pay)
	q:SQLCODE $$$OK
	
	s:Vendor'="" Vendor=$p(^APC("APCVM",Vendor),"^",3)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
	s:CreatUser'="" CreatUser=$p(^SSU("SSUSR",CreatUser),"^",2)
	s:Ack1User'="" Ack1User=$p(^SSU("SSUSR",Ack1User),"^",2)
	s:Ack2User'="" Ack2User=$p(^SSU("SSUSR",Ack2User),"^",2)
	s:Ack11User'="" Ack11User=$p(^SSU("SSUSR",Ack11User),"^",2)
	s:PayDate'="" PayDate=..DL2H(PayDate)
	s:PayTime'="" PayTime=..TL2H(PayTime)
	s:CompletedDate'="" CompletedDate=..DL2H(CompletedDate)
	s:CompletedTime'="" CompletedTime=..TL2H(CompletedTime)
	s:CheckDate'="" CheckDate=..DL2H(CheckDate)
	s:Ack1Date'="" Ack1Date=..DL2H(Ack1Date)
	s:Ack2Date'="" Ack2Date=..DL2H(Ack2Date)
	s:Ack11Date'="" Ack11Date=..DL2H(Ack11Date)
	s:$f(LocDesc,"-") LocDesc=$p(LocDesc,"-",2)
	s HospId=$s(LocId'="":$p(^CTLOC(LocId),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)_" "_..TL2H($p($h,",",2))
	d OutPutPayDetail
	Quit $$$OK
	
OutPutPayDetail
	s Data=$lb(PayNo,Vendor,LocDesc,CreatUser,Ack1User,
		Ack2User,Ack11User,PayDate,PayTime,CompletedDate,
		CompletedTime,PayMode,CheckNo,CheckDate,CheckAmt,
		Ack1Date,Ack2Date,Ack11Date,HospDesc,printTime
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	发票组合单query
/// Creator:	tsr
/// CreateDate:	2018-08-01
/// Table:		DHC_VendorInv
/// Input:		Inv(主表rowid)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInvDetail",28)
Query GetInvDetail(Inv As %String) As Query(ROWSPEC = "AssemNo,Vendor,LocDesc,CreateUser,CreateDate,CreateTime,InvNo,InvDate,HospDesc,printTime,InvCode") [ SqlProc ]
{
}

ClassMethod GetInvDetailExecute(ByRef qHandle As %Binary, Inv As %String) As %Status
{
	n (qHandle,Inv)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inv="" $$$OK
	s (AssemNo,Vendor,Scg,CreateUser,CreateDate,CreateTime,LocId,RpAmt,SpAmt,InvNo,Completed,Filled,InvRpAmt,InvSpAmt,InvDate,InvCode )=""
	&sql(SELECT INV_AssemNo, INV_APCVM_DR, INV_SCG_DR, INV_CreateUser, INV_CreateDate,
		INV_CreateTime, INV_CTLOC_DR, INV_RpAmt, INV_SpAmt, INV_InvNo,
		INV_UserCompleted, INV_Filled, INV_InvRpAmt, INV_InvSpAmt, INV_InvDate,INV_InvCode 
	into
		AssemNo, Vendor, Scg, CreateUser, CreateDate,
		CreateTime, LocId, RpAmt, SpAmt, InvNo,
		Completed, Filled, InvRpAmt, InvSpAmt, InvDate,InvCode 
	from DHC_VendorInv where %ID=:Inv)
	q:SQLCODE $$$OK
	
	s:Vendor'="" Vendor=$p(^APC("APCVM",Vendor),"^",3)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
	s:CreateUser'="" CreateUser=$p(^SSU("SSUSR",CreateUser),"^",2)
	s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	s:CreateTime'="" CreateTime=..TL2H(CreateTime)
	s:$f(LocDesc,"-") LocDesc=$p(LocDesc,"-",2)
	s:InvDate'="" InvDate=..DL2H(InvDate)
	s HospId=$s(LocId'="":$p(^CTLOC(LocId),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H(+$h)_" "_..TL2H($p($h,",",2))
	d OutPutInvDetail
	Quit $$$OK
	
OutPutInvDetail
	s Data=$lb(AssemNo,Vendor,LocDesc,CreateUser,CreateDate,
		CreateTime,InvNo,InvDate,HospDesc,printTime,InvCode
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	凭证query
/// Creator:	tsr
/// CreateDate:	2018-08-02
/// Table:		DHC_StockVoucher
/// Input:		Inv(主表rowid)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetVoucherRecord",20)
Query GetVoucherRecord(Params As %String) As Query(ROWSPEC = "SVCrowid,SVCtype,SVCtypeDesc,SVCuser,SVCuserdesc,SVCdate,SVCtime,SVCvoucherNo,SVCloc,SVClocdesc,SVCmonth,SVCstrda,SVCendda,SVCscg,SVCscgdesc,SVCapcvm,SVCapcvmdesc,SVCrpamt:%Float,SVCspamt:%Float,HospId,HospDesc,count:%Float") [ SqlProc ]
{
}

ClassMethod GetVoucherRecordExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	s (SVCrowid,SVCtype,SVCuser,SVCuserdesc,SVCdate,SVCtime,SVCvoucherNo,SVCloc,SVClocdesc,SVCmonth,SVCstrda,SVCendda,SVCscg,SVCscgdesc,SVCapcvm,SVCapcvmdesc,SVCrpamt,SVCspamt)=""
	&sql(SELECT SVC_ROWID,svc_type,svc_ssusr_dr,svc_ssusr_dr->ssusr_name,svc_date,svc_time,
		svc_voucherNo,svc_Loc_dr,svc_Loc_dr->ctloc_desc,Svc_month,Svc_Startdate,svc_endDate, 
		svc_scg_dr,svc_scg_dr->scg_desc,svc_apcvm_dr,svc_apcvm_dr->apcvm_name,svc_rpamt,svc_spamt 
	into 
		SVCrowid,SVCtype,SVCuser,SVCuserdesc,SVCdate,SVCtime,
		SVCvoucherNo,SVCloc,SVClocdesc,SVCmonth,SVCstrda,SVCendda,
		SVCscg,SVCscgdesc,SVCapcvm,SVCapcvmdesc,SVCrpamt,SVCspamt 
		FROM DHC_StockVoucher where %id=:Params)
	q:SQLCODE $$$OK

	s:SVCdate'="" SVCdate=..DL2H(SVCdate)
	s:SVCtime'="" SVCtime=..TL2H(SVCtime)
	s:SVCstrda'="" SVCstrda=..DL2H(SVCstrda)
	s:SVCendda'="" SVCendda=..DL2H(SVCendda)
	s:SVCmonth'="" SVCmonth=..DL2H(SVCmonth),SVCmonth=$p(SVCmonth,"-",3)
	s HospId=$s(SVCloc'="":$p(^CTLOC(SVCloc),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s count=0
	&sql(SELECT count(1) into :count FROM DHC_StockVoucherItm WHERE SVCI_SVC_Parref=:Params)
	q:SQLCODE $$$OK
	i SVCtype="G"  d
	.s SVCtypeDesc="入库"
	e  d
	.s SVCtypeDesc="退货"
	d OutPutSVCDetail
	Quit $$$OK
	
OutPutSVCDetail
	s Data=$lb(SVCrowid,SVCtype,SVCtypeDesc,SVCuser,SVCuserdesc,SVCdate,SVCtime,
		SVCvoucherNo,SVCloc,SVClocdesc,SVCmonth,SVCstrda,SVCendda,
		SVCscg,SVCscgdesc,SVCapcvm,SVCapcvmdesc,SVCrpamt,SVCspamt,HospId,HospDesc,count)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	付款封面query
/// Creator:	tsr
/// CreateDate:	2018-08-03
/// Table:		DHC_INGdRec_Cover
/// Input:		CoverId(主表rowid)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetPayCover",3)
Query GetPayCover(CoverId As %String) As Query(ROWSPEC = "CvrNo,LocDesc,CreateDate,Createtime,UserName,HospDesc,Month,VoucherCount:%Float,RpAmt:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod GetPayCoverExecute(ByRef qHandle As %Binary, CoverId As %String) As %Status
{
	n (qHandle,CoverId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:CoverId="" $$$OK
	s (CvrNo,LocId,CreateDate,Createtime,UserId,Month,VoucherCount,RpAmt,SpAmt)=""	
	&sql(SELECT CVR_No,CVR_CTLOC_DR,CVR_Date,CVR_Time,CVR_SSUSR_DR,
		 CVR_Month,CVR_VoucherCount,CVR_RpAmt,CVR_SpAmt
	into
		CvrNo,LocId,CreateDate,Createtime,UserId,Month,VoucherCount,RpAmt,SpAmt
		FROM DHC_INGdRec_Cover where CVR_RowId=:CoverId)
	q:SQLCODE $$$OK

	s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	s:Createtime'="" Createtime=..TL2H(Createtime)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2) 
	s:UserId'="" UserName=$p($G(^SSU("SSUSR",UserId)),"^",2)
	s HospId=$s(LocId'="":$p(^CTLOC(LocId),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")

	d OutPutPayCover
	Quit $$$OK
	
OutPutPayCover
	s Data=$lb(CvrNo,LocDesc,CreateDate,Createtime,UserName,HospDesc,Month,
		VoucherCount,RpAmt,SpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	盘点打印调用
/// Creator:	wfg
/// CreateDate:	2018-9-29
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetINStkTk",22)
Query GetINStkTk(Inst As %String) As Query(ROWSPEC = "inst,InstNo,InstDate,InstTime,UserId,UserName,LocId,LocDesc,Status,Remarks,Comp,StkTakeComp,AdjComp,Inad,ManFlag,TkUom,IncludeNotUse,OnlyNotUse,StkGrpId,StkCatId,StkCatDesc,FrStkBin,FrStkBinDesc,ToStkBin,ToStkBinDesc,HighValueFlag,MinRp:%Float,MaxRp:%Float,RandomNum:%Float,StkGrpDesc,HospDesc,printTime,PrintCount:%Float,ReprintFlag") [ SqlProc ]
{
}

ClassMethod GetINStkTkExecute(ByRef qHandle As %Binary, Inst As %String) As %Status
{
	n (qHandle,Inst)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inst="" $$$OK
		
	&sql(select INST_No,INST_Date,INST_SSUSR_DR,INST_CTLOC_DR,INST_Status,INST_Time,
	 INST_Remarks,INST_Completed,INST_StockTakeComplete,INST_AdjustmentComplete,
	 INST_INAD_DR,INST_ManaFlag,INST_FreezeUom,INST_IncludeNotUse,INST_OnlyNotUse,
	 INST_SCG_DR,INST_INCSC_DR,INST_FrStkBin,INST_ToStkBin,INST_HighValueFlag,
	 INST_MinRp,INST_MaxRp,INST_RandomNum
	 into :InstNo,
	 :InstDate,:UserId,:LocId,:Status,:InstTime,:Remarks,:Comp,:StkTakeComp,:AdjComp,:Inad,
	 :ManFlag,:TkUom,:IncludeNotUse,:OnlyNotUse,:StkGrpId,:StkCatId,:FrStkBin,:ToStkBin,:HighValueFlag,
	 :MinRp,:MaxRp,:RandomNum
	 from DHC_InStkTk where %ID=:Inst)
	q:SQLCODE $$$OK
	s (UserName,LocDesc,StkCatDesc,FrStkBinDesc,ToStkBinDesc,StkGrpDesc,HospId,HospDesc,ReprintFlag)=""
	s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
	s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	s:FrStkBin'="" FrStkBinDesc=$p(^INC("SB",FrStkBin),"^",2)
	s:ToStkBin'="" ToStkBinDesc=$p(^INC("SB",FrStkBin),"^",2)
	s:StkGrpId'="" StkGrpDesc=$p($g(^DHCSCG(StkGrpId)),"^",2)
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s:HospId'="" HospDesc=$p(^CT("HOSP",HospId),"^",2)
	s:InstDate'="" InstDate=..DL2H(InstDate)
	s:InstTime'="" InstTime=..TL2H(InstTime)
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()  //备注内容分隔符
	s Remarks=$lts(Remarks,memoDelim)   //备注内容转换为字符串
	s printTime=..DL2H(+$h)
	s PrintCount=..GetBillPrintCount("STK",Inst)
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutINStkTk
	Quit $$$OK
OutPutINStkTk
	s Data=$lb(Inst,InstNo,InstDate,InstTime,UserId,UserName,LocId,LocDesc,Status,Remarks,
	Comp,StkTakeComp,AdjComp,Inad,ManFlag,TkUom,IncludeNotUse,OnlyNotUse,StkGrpId,StkCatId,
	StkCatDesc,FrStkBin,FrStkBinDesc,ToStkBin,ToStkBinDesc,HighValueFlag,MinRp,MaxRp,RandomNum,StkGrpDesc,
	HospDesc,printTime,PrintCount,ReprintFlag
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	库存报损单信息query
/// Creator:	qiushengxin
/// Table:		DHC_INScrap
/// Input:		Parref(主表rowid)
/// Output:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetscrapDetail",9)
Query GetscrapDetail(Parref As %String) As websys.Query(ROWSPEC = "INSCPNO,INSCPDate,INSCPTime,INSCPReason,INSCPCTLOCDR,INSCPSCGDR,locDesc,INSCPSSUSRName,INSCPChkDate:%Date,INSCPChkTime:%Date,INSCPChkUSRName,INSCPStat, INSCPRemarks,INSCPCompleted,INSCPSCGDesc,INSCPChkFlag,INSCPStkType,HospDesc,printTime,PrintCount:%Float,ReprintFlag") [ SqlProc ]
{
}

ClassMethod GetscrapDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s scrap=Parref
	q:+scrap=0 $$$OK	
	s (INSCPNO,INSCPDate,INSCPTime,INSCPReason,INSCPCTLOCDR,INSCPSCGDR,locDesc,INSCPSSUSRName,INSCPChkDate,INSCPChkTime,INSCPChkUSRName,INSCPStat,INSCPRemarks,INSCPCompleted,INSCPSCGDesc,INSCPChkFlag,INSCPStkType)=""
	&sql(SELECT INSCP_NO,INSCP_Date,INSCP_Time,INSCP_Reason->REASON_ScrapDesc,INSCP_CTLOC_DR,
				INSCP_SCG_DR,INSCP_CTLOC_DR->CTLOC_Desc,INSCP_SSUSR_DR->SSUSR_Name,INSCP_ChkDate,INSCP_ChkTime,
				INSCP_ChkUSR_DR->SSUSR_Name,INSCP_Stat, INSCP_Remarks,INSCP_Completed,INSCP_SCG_DR->SCG_Desc,
				INSCP_ChkFlag,INSCP_StkType
		into 	INSCPNO,INSCPDate,INSCPTime,INSCPReason,INSCPCTLOCDR,INSCPSCGDR,
				locDesc,INSCPSSUSRName,INSCPChkDate,INSCPChkTime,INSCPChkUSRName,
				INSCPStat, INSCPRemarks,INSCPCompleted,INSCPSCGDesc,INSCPChkFlag,INSCPStkType 
		from	DHC_INScrap where %ID=:scrap)
	q:SQLCODE $$$OK
	
	s:INSCPDate'="" INSCPDate=..DL2H(INSCPDate)
	s:INSCPTime'="" INSCPTime=..TL2H(INSCPTime)
	s:INSCPChkDate'="" INSCPChkDate=..DL2H(INSCPChkDate)
	s:INSCPChkTime'="" INSCPChkTime=..TL2H(INSCPChkTime)
	s:$f(locDesc,"-") locDesc=$p(locDesc,"-",2)
	s HospId=$s(INSCPCTLOCDR'="":$p(^CTLOC(INSCPCTLOCDR),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s printTime=..DL2H($h)_" "_..TL2H($p($h,",",2))
	s PrintCount=..GetBillPrintCount("D",Parref)
	s ReprintFlag=""
	s:PrintCount>1 ReprintFlag="（补）"
	d OutPutscrapDetail
	Quit $$$OK
	
OutPutscrapDetail
	s Data=$lb(INSCPNO,INSCPDate,INSCPTime,INSCPReason,INSCPCTLOCDR,INSCPSCGDR,
				locDesc,INSCPSSUSRName,INSCPChkDate,INSCPChkTime,INSCPChkUSRName,
				INSCPStat, INSCPRemarks,INSCPCompleted,INSCPSCGDesc,INSCPChkFlag,
				INSCPStkType,HospDesc,printTime,PrintCount,ReprintFlag
	) 
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取参数设置的一些属性
/// 				用于小数位数等控制
/// Creator:	wangjiabin
/// Input:		
/// Output:		RpFormat-进价显示格式, RpAmtFormat-进价金额显示格式（售价按照进价控制）
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetPropInfo")
Query GetPropInfo() As websys.Query(ROWSPEC = "RpFormat,RpAmtFormat,QtyFormat") [ SqlProc ]
{
}

ClassMethod GetPropInfoExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s (LocId,UserId,GroupId,HospId)=""
	i $d(%session) d
	.s LocId=$g(%session.Data("LOGON.CTLOCID"))
	.s UserId=$g(%session.Data("LOGON.USERID"))
	.s GroupId=$g(%session.Data("LOGON.GROUPID"))
	.s HospId=$g(%session.Data("LOGON.HOSPID"))
	s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s FmtRP=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("FmtRP",Params)
	s FmtRA=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("FmtRA",Params)
	s FmtQTY=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("FmtQTY",Params)
	
	s RpFormat="#,##0.00",RpAmtFormat="#,##0.00",QtyFormat="#,##0.00"
	
	s RpDeciPart=$p(FmtRP,".",2)
	i RpDeciPart'="" d
	.s RpFormat="#,##0."_RpDeciPart		;千分位 + 小数位数
	
	s RpAmtDeciPart=$p(FmtRA,".",2)
	i RpAmtDeciPart'="" d
	.s RpAmtFormat="#,##0."_RpAmtDeciPart		;千分位 + 小数位数
	
	s QtyDeciPart=$p(FmtQTY,".",2)
	i QtyDeciPart'="" d
	.s QtyFormat="#,##0."_QtyDeciPart		;千分位 + 小数位数
	
	d OutPutPropInfo
	Quit $$$OK
	
OutPutPropInfo
	s Data=$lb(RpFormat,RpAmtFormat,QtyFormat)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	简易盘点打印调用
/// Creator: lihui
/// CreateDate:	20201021
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetReqINStkTk",22)
Query GetReqINStkTk(Inst As %String) As Query(ROWSPEC = "Inst,InstNo,InstDate,InstTime,UserId,UserName,CreateLoc,CreateLocDesc,StkTkLoc,StkTkLocDesc,Remarks,Completed,CountCompleted,AdjCompleted,Inad,Incsc,StkCatDesc,StkGrpId,StkGrpDesc,HospDesc") [ SqlProc ]
{
}

ClassMethod GetReqINStkTkExecute(ByRef qHandle As %Binary, Inst As %String) As %Status
{
	n (qHandle,Inst)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inst="" $$$OK
		
	&sql(SELECT SUBST_No, SUBST_CreateDate, SUBST_CreateTime, SUBST_CreateUser_DR,SUBST_CreateLoc_DR,
				SUBST_CTLoc_DR, SUBST_SCG_DR, SUBST_INCSC_DR, SUBST_Completed,SUBST_INAD_DR,
				SUBST_Remarks, SUBST_CountCompleted, SUBST_AdjCompleted
		into 	:InstNo,:InstDate,:InstTime,:UserId,:CreateLoc,
				:StkTkLoc,:StkGrpId,:Incsc,:Completed,:Inad,
				:Remarks,:CountCompleted,:AdjCompleted
        FROM DHC_SubLocStkTk WHERE SUBST_RowId=:Inst)
	q:SQLCODE $$$OK

	s UserName=$s(UserId'="":$p(^SSU("SSUSR",UserId),"^",2),1:"")
 	s CreateLocDesc=$s(CreateLoc'="":$p(^CTLOC(CreateLoc),"^",2),1:"")
 	s StkTkLocDesc=$s(StkTkLoc'="":$p(^CTLOC(StkTkLoc),"^",2),1:"")
 	s StkCatDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
 	s:InstDate'="" InstDate=..DL2H(InstDate)
 	s:InstTime'="" InstTime=..TL2H(InstTime)
 	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()  //备注内容分隔符
 	s Remarks=$lts(Remarks,memoDelim)   //备注内容转换为字符串
 	s StkGrpDesc=$s(StkGrpId'="":$p($g(^DHCSCG(StkGrpId)),"^",2),1:"")
	s HospId=$s(CreateLoc'="":$p(^CTLOC(CreateLoc),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")

	d OutPutReqINStkTk
	Quit $$$OK
	
OutPutReqINStkTk
	s Data=$lb(Inst,InstNo,InstDate,InstTime,UserId,UserName,CreateLoc,CreateLocDesc,StkTkLoc,StkTkLocDesc,Remarks,Completed,CountCompleted,AdjCompleted,Inad,Incsc,StkCatDesc,StkGrpId,StkGrpDesc,HospDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取病人信息
/// Creator: lihui
/// CreateDate:	20201021
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetPatientInfo",235,"","")
Query GetPatientInfo(Adm As %String, PatId As %String = "", PatNo As %String = "") As Query(ROWSPEC = "PatId,PatName,PatSex,PatBir,PatTel,PatOld,PatLoc,PatDoc,PrintTime,PatNo,MrNo,BedNo,AdmLoc,HospDesc") [ SqlProc ]
{
}

ClassMethod GetPatientInfoExecute(ByRef qHandle As %Binary, Adm, PatId As %String = "", PatNo As %String = "") As %Status
{
	n (qHandle,Adm,PatId,PatNo)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Adm="" $$$OK
	
	i PatId="" d
	.i Adm'="" s PatId=$p(^PAADM(Adm),"^",1)
	.e  i PatNo'="" s PatId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	q:PatId="" $$$OK
	
	s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	s PatSex=$p(^PAPER(PatId,"ALL"),"^",7)
	s:PatSex'="" PatSex=$p(^CT("SEX",PatSex),"^",2)
	s PatBir=$p(^PAPER(PatId,"ALL"),"^",6)
	s PatTel=$p(^PAPER(PatId,"PER",1),"^",11)
	s PatOld=##class(web.DHCSTMHUI.Common.ServiceCommon).GetPapmiAge(PatId,Adm,"")
	s PatLoc=$p(^PAADM(Adm),"^",4)	//就诊科室
	s:PatLoc'="" PatLoc=$p(^CTLOC(PatLoc),"^",2)
	s PatDoc=$p(^PAADM(Adm),"^",9)	//医护人员
	s:PatDoc'="" PatDoc=$p(^CTPCP(PatDoc,1),"^",2)
	s PrintTime=..DL2H(+$h)
	s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	
	s AdmType=$o(^PAPERdr(PatId,"ADM",""),-1)
	s:Adm="" Adm=$o(^PAPERdr(PatId,"ADM",AdmType,""),-1)
	s AdmType=$p(^PAADM(Adm),"^",2)
	s MrNo=##class(web.DHCSTMHUI.Common.ServiceCommon).GetMrNoByPatientID(PatId,AdmType)
	s BedNo=$p($g(^PAADM(Adm)),"^",73)
	i BedNo'="" s BedNo=$p($g(^PAWARD(+BedNo,"BED",$P(BedNo,"||",2))),"^",1)
	s Hosp="",HospDesc=""
	s AdmLoc=$p(^PAADM(Adm),"^",4)
	s:AdmLoc'="" Hosp=$p(^CTLOC(AdmLoc),"^",22)
	s:Hosp'="" HospDesc=$p(^CT("HOSP",Hosp),"^",2)
	s:AdmLoc'="" AdmLoc=$p(^CTLOC(AdmLoc),"^",2)
	d OutPutPat
	Quit $$$OK
	
OutPutPat
	s Data=$lb(PatId,PatName,PatSex,PatBir,PatTel,PatOld,PatLoc,PatDoc,PrintTime,PatNo,MrNo,BedNo,AdmLoc,HospDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInMatDisp",^templxt("QueryInMatDispItm"))
Query GetInMatDisp(Parref As %String) As Query(ROWSPEC = "HospDesc,No,DispDate,UserName,RecLocDesc,WardLocDesc,PrintTime") [ SqlProc ]
{
}

ClassMethod GetInMatDispExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	s MainInfo=^User.DHCInMatDispD(Parref)
	
	s UserName="",WardLocDesc="",RecLocDesc=""
	s No=$lg(MainInfo,2)
	s DispDate=$lg(MainInfo,3)
	s:DispDate'="" DispDate=..DL2H(DispDate)
	s UserId=$lg(MainInfo,5)
	s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s RecLocId=$lg(MainInfo,6)
	s:RecLocId'="" RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
	s WardLocId=$lg(MainInfo,7)
	s:WardLocId'="" WardLocDesc=$p(^CTLOC(WardLocId),"^",2)
	s HospId=$s(RecLocId'="":$p(^CTLOC(RecLocId),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s PrintTime=..DL2H(+$h)
	d OutPutInDispDetail
	Quit $$$OK
	
OutPutInDispDetail
	s Data=$lb(HospDesc,No,DispDate,UserName,RecLocDesc,WardLocDesc,PrintTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RQReport","GetInMatDispRet",116)
Query GetInMatDispRet(Parref As %String) As Query(ROWSPEC = "HospDesc,No,DispRetDate,UserName,RecLocDesc,WardLocDesc,PrintTime") [ SqlProc ]
{
}

ClassMethod GetInMatDispRetExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	
	
	n (qHandle,Parref)
	tro  
	s ^zx("GetInMatDispRet")=Parref
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	s MainInfo=^User.DHCInMatRetD(Parref)
	
	s UserName="",WardLocDesc="",RecLocDesc=""
	s No=$lg(MainInfo,2)
	s DispRetDate=$lg(MainInfo,3)
	s:DispRetDate'="" DispRetDate=..DL2H(DispRetDate)
	s UserId=$lg(MainInfo,5)
	s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s RecLocId=$lg(MainInfo,6)
	s:RecLocId'="" RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
	s WardLocId=$lg(MainInfo,7)
	s:WardLocId'="" WardLocDesc=$p(^CTLOC(WardLocId),"^",2)
	s HospId=$s(RecLocId'="":$p(^CTLOC(RecLocId),"^",22),1:"")
	s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	s PrintTime=..DL2H(+$h)
	d OutPutInDispRet
	Quit $$$OK
	
OutPutInDispRet
	s Data=$lb(HospDesc,No,DispRetDate,UserName,RecLocDesc,WardLocDesc,PrintTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
