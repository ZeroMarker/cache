Import SQLUser

/// HRP数据抽取
Class web.DHCSTMHUI.HRPData Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 1.材料分类字典表 (MAT_TYPE)
/// CALL web_DHCSTMHUI.MAT_TYPE()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryMatType")
Query QueryMatType() As Query(ROWSPEC = "MAT_TYPE_ID,MAT_TYPE_CODE,MAT_TYPE_NAME,SUPER_CODE,IS_LAST,TYPE_LEVEL,IS_STOP,SPELL_CODE,WBX_CODE,IS_BUDG,IS_AUTO_EXP,EXP_YEAR,NOTE,SORT_CODE") [ SqlName = MAT_TYPE, SqlProc ]
{
}

ClassMethod QueryMatTypeExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s IsLast=1
	s TypeLevel=2
	s IsStop=0
	s SpellCode=""
	s WbxCode=""
	s IsBudg=0
	s IsAutoExp=1
	s ExpYear=""
	s Note=""
	
	s StkCatId=""
	f  s StkCatId=$o(^INC("SC",StkCatId)) q:StkCatId=""  d
	.s StkCatCode=$p(^INC("SC",StkCatId),"^",1)
	.s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	.s StkType=$p(^INC("SC",StkCatId),"^",3)
	.q:StkType'=..sssCode()
	.q:'$d(^DHCSCG("STKCAT",StkCatId))
	.s StkGrpId=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetParSCG(StkCatId,"M",0)
	.d OutputMatType
	Quit $$$OK
OutputMatType
	s Data=$lb(StkCatId,StkCatCode,StkCatDesc,StkGrpId,IsLast,TypeLevel,IsStop,
		SpellCode,WbxCode,IsBudg,IsAutoExp,ExpYear,Note,StkCatId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 2.材料分类变更字典表 (MAT_TYPE_DICT)
/// CALL web_DHCSTMHUI.MAT_TYPE_DICT()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryMatTypeDict")
Query QueryMatTypeDict() As Query(ROWSPEC = "MAT_TYPE_NO,MAT_TYPE_ID,MAT_TYPE_CODE,MAT_TYPE_NAME,SUPER_CODE,IS_LAST,TYPE_LEVEL,SPELL_CODE,WBX_CODE,IS_BUDG,IS_AUTO_EXP,EXP_YEAR,NOTE,SORT_CODE,CHANGE_USER,CHANGE_DATE,IS_STOP,CHANGE_NOTE") [ SqlName = MAT_TYPE_DICT, SqlProc ]
{
}

ClassMethod QueryMatTypeDictExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s IsLast=1
	s TypeLevel=2
	s SpellCode=""
	s WbxCode=""
	s IsStop=0
	s IsBudg=0
	s IsAutoExp=1
	s ExpYear=""
	s Note=""
	s ChangeNote=""
	s ChangeDate=$zd(+$h,3)
	s ChangeUser="herp"
	
	s StkCatId=""
	f  s StkCatId=$o(^INC("SC",StkCatId)) q:StkCatId=""  d
	.s ChangeStkCatId=StkCatId
	.s StkCatCode=$p(^INC("SC",StkCatId),"^",1)
	.s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	.s StkType=$p(^INC("SC",StkCatId),"^",3)
	.q:StkType'=..sssCode()
	.q:'$d(^DHCSCG("STKCAT",StkCatId))
	.s StkGrpId=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetParSCG(StkCatId,"M",0)
	.d OutputMatTypeDict
	Quit $$$OK
OutputMatTypeDict
	s Data=$lb(ChangeStkCatId,StkCatId,StkCatCode,StkCatDesc,StkGrpId,IsLast,TypeLevel,SpellCode,WbxCode,IsBudg,
		IsAutoExp,ExpYear,Note,StkCatId,ChangeUser,ChangeDate,IsStop,ChangeNote)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 3.材料字典 (MAT_INV)
/// CALL web_DHCSTMHUI.MAT_INV()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryMatInv")
Query QueryMatInv() As Query(ROWSPEC = "INV_ID,INV_CODE,INV_NAME,ALIAS,SPELL_CODE,WBX_CODE,MAT_TYPE_ID,INV_MODEL,UNIT_CODE,FAC_ID,AMORTIZE_TYPE,PRICE_TYPE,PLAN_PRICE,PRICE_RATE,SELL_PRICE,IS_SINGLE_VEN,IS_BATCH,IS_BAR,IS_PER_BAR,IS_CERT,IS_QUALITY,IS_DISINFECT,IS_COM,IS_DURA,IS_HIGHVALUE,IS_CHARGE,IS_SEC_WHG,IS_SHEL_MAKE,SDATE,EDATE,BAR_CODE_NEW,ABC_TYPE,PER_WEIGHT,PER_VOLUM,BRAND_NAME,AGENT_NAME,INV_STRUCTURE,INV_USAGE,USE_STATE,NOTE,STATE,CHECK_DATE,CHECKER,IS_BID,BID_DATE,BID_CODE,IS_INVOLVED,IS_IMPLANT,STORA_TRAN_COND,IS_ZERO_STORE,ALIAS_SPELL") [ SqlName = MAT_INV, SqlProc ]
{
}

ClassMethod QueryMatInvExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s AmortizeType=1
	s PriceType=0
	s PlanPrice=""
	s PriceRate=""
	s SellPrice=""
	s IsSingleVen=0
	s IsBatch=0
	s IsBar=0
	s IsPerBar=0
	s IsCert=0
	s IsQuailty=0
	s IsSter=0
	s IsCom=0
	s IsDura=0
	s IsSec=0
	s IsSelMake=0
	s UseState=1
	s StkType=..sssCode()
	s Inci=0
	s IsCom=""
	s SDate=""
	s EDate=""
	s BarCodeNew=""
	s ABCType=""
	s PerWeight=""
	s PerVolum=""
	s AgentName=""
	s InvStructure=""
	s InvUsage=""
	s Note=""
	s State=""
	s CheckDate=""
	s Checker=""
	s IsBid=""
	s BidDate=""
	s BidCode=""
	s IsInvolved=""
	s IsImplant=""
	s StoraTranCond=""
	s IsZeroStore=""
	s AliasSpell=""
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci=0
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgStkType=$p(ScgInfo,"^",3)
	.q:ScgStkType'=StkType
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s InciPYDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(InciDesc,3)
	.s InciWBDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(InciDesc,6)
	.s StkCatId=$p(^INCI(Inci,2),"^",2)
	.q:StkCatId=""
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s ManfId=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(Inci),"^",1)
	.s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.i HvFlag="Y" s HvFlag=1
	.e  s HvFlag=0
	.s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci)
	.i ChargeFlag="Y" s ChargeFlag=1
	.e  s ChargeFlag=0
	.s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(Inci)
	.d QueryMatInv
	Quit $$$OK
QueryMatInv
	s Data=$lb(Inci,InciCode,InciDesc,InciDesc,InciPYDesc,InciWBDesc,StkCatId,Model,BUomId,ManfId,
		AmortizeType,PriceType,PlanPrice,PriceRate,SellPrice,IsSingleVen,IsBatch,IsBar,IsPerBar,IsCert,IsQuailty,IsSter,IsCom,IsDura,HvFlag,ChargeFlag,IsSec,IsSelMake,
		SDate,EDate,BarCodeNew,ABCType,PerWeight,PerVolum,Brand,AgentName,InvStructure,InvUsage,UseState,
		Note,State,CheckDate,Checker,IsBid,BidDate,BidCode,IsInvolved,IsImplant,StoraTranCond,IsZeroStore,AliasSpell)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 4.材料字典变更表 (MAT_INV_DICT)
/// CALL web_DHCSTMHUI.MAT_INV_DICT()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryMatInvDICT")
Query QueryMatInvDICT() As Query(ROWSPEC = "INV_NO,INV_ID,INV_CODE,INV_NAME,ALIAS,SPELL_CODE,WBX_CODE,MAT_TYPE_ID,MAT_TYPE_NO,INV_MODEL,UNIT_CODE,FAC_ID,AMORTIZE_TYPE,PRICE_TYPE,PLAN_PRICE,PRICE_RATE,SELL_PRICE,IS_SINGLE_VEN,IS_BATCH,IS_BAR,IS_PER_BAR,IS_CERT,IS_QUALITY,IS_DISINFECT,IS_COM,IS_DURA,IS_HIGHVALUE,IS_CHARGE,IS_SEC_WHG,IS_SHEL_MAKE,SDATE,EDATE,BAR_CODE_NEW,ABC_TYPE,PER_WEIGHT,PER_VOLUM,BRAND_NAME,AGENT_NAME,INV_STRUCTURE,INV_USAGE,USE_STATE,NOTE,STATE,CHECK_DATE,CHECKER,IS_BID,BID_DATE,BID_CODE,IS_INVOLVED,IS_IMPLANT,STORA_TRAN_COND,IS_ZERO_STORE,ALIAS_SPELL,CHANGE_USER,CHANGE_DATE,IS_STOP,CHANGE_NOTE") [ SqlName = MAT_INV_DICT, SqlProc ]
{
}

ClassMethod QueryMatInvDICTExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s AmortizeType=1
	s PriceType=0
	s IsSingleVen=0
	s IsBatch=0
	s IsBar=0
	s IsPerBar=0
	s IsCert=0
	s IsQuailty=0
	s IsSter=0
	s IsCom=0
	s IsDura=0
	s IsSec=0
	s IsSelMake=0
	s UseState=1
	s ChangeUser="herp"
	s ChangeDate=$zd(+$h,3)
	s StkType=..sssCode()
	
	s PlanPrice=""
	s PriceRate=""
	s SellPrice=""
	s IsCom=""
	s SDate=""
	s EDate=""
	s BarCodeNew=""
	s ABCType=""
	s PerWeight=""
	s PerVolum=""
	s AgentName=""
	s InvStructure=""
	s InvUsage=""
	s Note=""
	s State=""
	s CheckDate=""
	s CheckDate=""
	s Checker=""
	s IsBid=""
	s BidDate=""
	s BidCode=""
	s IsInvolved=""
	s IsImplant=""
	s StoraTranCond=""
	s IsZeroStore=""
	s AliasSpell=""
	s ChangeNote=""
	
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci=0
	.s ChangeInci=Inci
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgStkType=$p(ScgInfo,"^",3)
	.q:ScgStkType'=StkType
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s InciPYDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(InciDesc,3)
	.s InciWBDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(InciDesc,6)
	.s StkCatId=$p(^INCI(Inci,2),"^",2)
	.q:StkCatId=""
	.s ChangeStkCatId=StkCatId
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s ManfId=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(Inci),"^",1)
	.s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.i HvFlag="Y" s HvFlag=1
	.e  s HvFlag=0
	.s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci)
	.i ChargeFlag="Y" s ChargeFlag=1
	.e  s ChargeFlag=0
	.s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(Inci)
	.s NotUseFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetNotUseFlag(Inci)
	.i NotUseFlag="Y" s NotUseFlag=1
	.e  s NotUseFlag=0
	.d QueryMatInvDict
	Quit $$$OK
QueryMatInvDict
	s Data=$lb(ChangeInci,Inci,InciCode,InciDesc,InciDesc,InciPYDesc,InciWBDesc,StkCatId,ChangeStkCatId,Model,BUomId,ManfId,
		AmortizeType,PriceType,PlanPrice,PriceRate,SellPrice,IsSingleVen,IsBatch,IsBar,IsPerBar,IsCert,IsQuailty,IsSter,IsCom,IsDura,HvFlag,ChargeFlag,IsSec,IsSelMake,SDate,EDate,BarCodeNew,ABCType,PerWeight,PerVolum,
		Brand,AgentName,InvStructure,InvUsage,UseState,Note,State,CheckDate,Checker,IsBid,BidDate,BidCode,IsInvolved,IsImplant,StoraTranCond,IsZeroStore,AliasSpell,ChangeUser,ChangeDate,NotUseFlag,ChangeNote)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 5.物资供应商(MAT_VEN_DICT)
/// CALL web_DHCSTMHUI.MAT_VEN_DICT()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryMatVendor")
Query QueryMatVendor() As Query(ROWSPEC = "VEN_CODE,VEN_NAME") [ SqlName = MAT_VEN_DICT, SqlProc ]
{
}

ClassMethod QueryMatVendorExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s VendorId=""
	f  s VendorId=$o(^APC("APCVM",VendorId)) q:VendorId=""  d
	.s APCStkType=$p(^APC("APCVM",VendorId),"^",9)
	.q:APCStkType'=..sssCode()
	.s APCCode=$p(^APC("APCVM",VendorId),"^",2)
	.s APCDesc=$p(^APC("APCVM",VendorId),"^",3)
	.d QueryMatVendor
	Quit $$$OK
QueryMatVendor
	s Data=$lb(VendorId,APCDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 6.入库主表(HIP_MAT_IN_MAIN)
/// CALL web_DHCSTMHUI.HIP_MAT_IN_MAIN("2022-07-01","2022-08-01")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryInGdMain","2022-07-01","2022-08-01")
Query QueryInGdMain(StartDate As %String, EndDate As %String) As Query(ROWSPEC = "IN_NO,YEAR,MONTH,BUS_TYPE_CODE,SUP_code,STORE_code,BRIEF,MAKER,IN_DATE,CHECKER,CHECK_DATE,CONFIRMER,CONFIRM_DATE,PROTOCOL_CODE,PROJ_CODE,SOURCE_CODE,BILL_NO,BILL_DATE,BILL_STATE,HOS_DISTRICT") [ SqlName = HIP_MAT_IN_MAIN, SqlProc ]
{
}

ClassMethod QueryInGdMainExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	s ProtocolCode=""
	s ProjCode=""
	s SourceCode=""
	s BillNo=""
	s BillDate=""
	s BillState=""
	
	f Date=StartDate:1:EndDate d
	.
	.s DateStr=$zd(Date,3)
	.s Year=$p(DateStr,"-",1)
	.s Month=$p(DateStr,"-",2)
	.
	.s InGdMain=""
	.f  s InGdMain=$o(^DHCINGR(0,"DODate",Date,InGdMain)) q:InGdMain=""  d
	..
	..s No=$p(^DHCINGR(InGdMain),"^",1)
	..s AuditFlag=$p(^DHCINGR(InGdMain),"^",29)
	..s Type=$p(^DHCINGR(InGdMain),"^",30)
	..q:Type'=..sssCode()
	..q:AuditFlag'="Y"
	..s No="RK"_No			;HRP约定
	..
	..s TypeCode=2
	..s Vendor=$p(^DHCINGR(InGdMain),"^",3)
	..s AuditDate=$p(^DHCINGR(InGdMain),"^",4)
	..s AuditUser=$p(^DHCINGR(InGdMain),"^",8)
	..s LocId=$p(^DHCINGR(InGdMain),"^",13)
	..s CreateDate=$p(^DHCINGR(InGdMain),"^",14)
	..s CreateUser=$p(^DHCINGR(InGdMain),"^",16)
	..s AcceptUser=$p(^DHCINGR(InGdMain),"^",26)
	..
	..s Remark=""
	..s:$d(^DHCINGR(InGdMain,"REM",1)) Remark=^DHCINGR(InGdMain,"REM",1)
	..
	..s CreateDate=$zd(CreateDate,3)
	..s AuditDate=$zd(AuditDate,3)
	..s AcceptDate=DateStr
	..s HospId=..sssHospId(LocId)
	..s HospCode=$s(HospId'="":$p(^CT("HOSP",HospId),"^",1),1:"")
	..d QueryInGdMain
	.
	.s InGdRet=""
	.f  s InGdRet=$o(^INGRT(0,"AUDITDATE",Date,InGdRet)) q:InGdRet=""  d
	..
	..s No=$p(^INGRT(InGdRet),"^",1)
	..s AuditFlag=$p(^INGRT(InGdRet),"^",15)
	..s Type=$p(^INGRT(InGdRet),"^",16)
	..q:Type'=..sssCode()
	..q:AuditFlag'="Y"
	..s No="TH"_No			;HRP约定
	..
	..s TypeCode=12
	..s Vendor=$p(^INGRT(InGdRet),"^",2)
	..s CreateDate=$p(^INGRT(InGdRet),"^",3)
	..s CreateUser=$p(^INGRT(InGdRet),"^",5)
	..s LocId=$p(^INGRT(InGdRet),"^",7)
	..s AuditUser=$p(^INGRT(InGdRet),"^",8)
	..s AuditDate=$p(^INGRT(InGdRet),"^",9)
	..s Remark=$p(^INGRT(InGdRet),"^",26)
	..
	..s CreateDate=$zd(CreateDate,3)
	..s AuditDate=$zd(AuditDate,3)
	..s AcceptUser=AuditUser
	..s AcceptDate=DateStr
	..s HospId=..sssHospId(LocId)
	..s HospCode=$s(HospId'="":$p(^CT("HOSP",HospId),"^",1),1:"")
	..d QueryInGdMain
	Quit $$$OK
QueryInGdMain
	s Data=$lb(No,Year,Month,TypeCode,Vendor,LocId,Remark,CreateUser,CreateDate,AuditUser,AuditDate,
		AcceptUser,AcceptDate,ProtocolCode,ProjCode,SourceCode,BillNo,BillDate,BillState,HospCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 6.1.入库主表(HIP_MAT_IN_MAININV)---按发票确认日期
/// CALL web_DHCSTMHUI.HIP_MAT_IN_MAININV("2023-02-01","2023-02-16")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryInGdMainINV","2023-02-01","2023-02-16")
Query QueryInGdMainINV(StartDate As %String, EndDate As %String) As Query(ROWSPEC = "IN_NO,YEAR,MONTH,BUS_TYPE_CODE,SUP_code,STORE_code,STORE_name,BRIEF,MAKER,IN_DATE,CHECKER,CHECK_DATE,CONFIRMER,CONFIRM_DATE,PROTOCOL_CODE,PROJ_CODE,SOURCE_CODE,BILL_NO,BILL_DATE,BILL_STATE,HOS_DISTRICT") [ SqlName = HIP_MAT_IN_MAININV, SqlProc ]
{
}

ClassMethod QueryInGdMainINVExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	s ProtocolCode=""
	s ProjCode=""
	s SourceCode=""
	s BillNo=""
	s BillDate=""
	s BillState=""
	
	s Pid=..NewPid()
	f Date=StartDate:1:EndDate d
	.s DateStr=$zd(Date,3)
	.s Year=$p(DateStr,"-",1)
	.s Month=$p(DateStr,"-",2)
	.s Inclb=""
	.f  s Inclb=$o(^DHCPAYTRANS(0,"DATEINCLB",Date,Inclb)) q:Inclb=""  d
	..s InvTransId=""
	..f  s InvTransId=$o(^DHCPAYTRANS(0,"DATEINCLB",Date,Inclb,InvTransId)) q:InvTransId=""  d
	...s TransType=$p(^DHCPAYTRANS(InvTransId),"^",1)
	...s Pointer=$p(^DHCPAYTRANS(InvTransId),"^",2)
	...q:$d(^TMPDHCSTMHRPINV("InvTrans",Pid,TransType,+Pointer))
	...s ^TMPDHCSTMHRPINV("InvTrans",Pid,TransType,+Pointer)=InvTransId
	...i ((TransType="G")||(TransType="GC")) d
	....s InGdMain=+Pointer
	....s TmpNo=$p(^DHCINGR(InGdMain),"^",1)
	....s No=$s(TransType="G":"RK"_TmpNo,1:"QXRK"_TmpNo)
	....s AuditFlag=$p(^DHCINGR(InGdMain),"^",29)
	....s Type=$p(^DHCINGR(InGdMain),"^",30)
	....q:Type'=..sssCode()
	....q:AuditFlag'="Y"
	....s TypeCode=$s(TransType="G":2,1:-2)
	....s Vendor=$p(^DHCINGR(InGdMain),"^",3)
	....s AuditDate=$p(^DHCINGR(InGdMain),"^",4)
	....s AuditUser=$p(^DHCINGR(InGdMain),"^",8)
	....s LocId=$p(^DHCINGR(InGdMain),"^",13)
	....s LocDesc=$p(^CTLOC(LocId),"^",2)
	....s CreateDate=$p(^DHCINGR(InGdMain),"^",14)
	....s CreateUser=$p(^DHCINGR(InGdMain),"^",16)
	....s AcceptUser=$p(^DHCINGR(InGdMain),"^",26)
	....s Remark=""
	....s:$d(^DHCINGR(InGdMain,"REM",1)) Remark=^DHCINGR(InGdMain,"REM",1)
	....s CreateDate=$zd(CreateDate,3)
	....s AuditDate=$zd(AuditDate,3)
	....s AcceptDate=DateStr
	....s HospId=..sssHospId(LocId)
	....s HospCode=$s(HospId'="":$p(^CT("HOSP",HospId),"^",1),1:"")
	....d QueryInGdMainINV
	...e  d
	....s InGdRet=+Pointer
	....s TmpNo=$p(^INGRT(InGdRet),"^",1)
	....s AuditFlag=$p(^INGRT(InGdRet),"^",15)
	....s Type=$p(^INGRT(InGdRet),"^",16)
	....q:Type'=..sssCode()
	....q:AuditFlag'="Y"
	....s No=$s(TransType="R":"TH"_TmpNo,1:"QXHT"_TmpNo)		;HRP约定
	....s TypeCode=$s(TransType="R":12,1:-12)
	....s Vendor=$p(^INGRT(InGdRet),"^",2)
	....s CreateDate=$p(^INGRT(InGdRet),"^",3)
	....s CreateUser=$p(^INGRT(InGdRet),"^",5)
	....s LocId=$p(^INGRT(InGdRet),"^",7)
	....s LocDesc=$p(^CTLOC(LocId),"^",2)
	....s AuditUser=$p(^INGRT(InGdRet),"^",8)
	....s AuditDate=$p(^INGRT(InGdRet),"^",9)
	....s Remark=$p(^INGRT(InGdRet),"^",26)
	....s CreateDate=$zd(CreateDate,3)
	....s AuditDate=$zd(AuditDate,3)
	....s AcceptUser=AuditUser
	....s AcceptDate=DateStr
	....s HospId=..sssHospId(LocId)
	....s HospCode=$s(HospId'="":$p(^CT("HOSP",HospId),"^",1),1:"")
	....d QueryInGdMainINV
	
	k ^TMPDHCSTMHRPINV("InvTrans",Pid)
	Quit $$$OK
	
QueryInGdMainINV
	s Data=$lb(No,Year,Month,TypeCode,Vendor,LocId,LocDesc,Remark,CreateUser,CreateDate,AuditUser,AuditDate,
		AcceptUser,AcceptDate,ProtocolCode,ProjCode,SourceCode,BillNo,BillDate,BillState,HospCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 7.入库明细表(HIP_MAT_IN_DETAIL)
/// CALL web_DHCSTMHUI.HIP_MAT_IN_DETAIL"2022-08-26","2022-08-26")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryInGdDetail","2022-08-26","2022-08-26")
Query QueryInGdDetail(StartDate As %String, EndDate As %String) As Query(ROWSPEC = "IN_ID,IN_NO,INV_CODE,BATCH_NO,PRICE,AMOUNT,AMOUNT_MONEY,NOTE") [ SqlName = HIP_MAT_IN_DETAIL, SqlProc ]
{
}

ClassMethod QueryInGdDetailExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	f Date=StartDate:1:EndDate d
	.s DateStr=$zd(Date,3)
	.s Year=$p(DateStr,"-",1)
	.s Month=$p(DateStr,"-",2)
	.
	.s RowId=""
	.f  s RowId=$o(^DHCINGR(0,"DODate",Date,RowId)) q:RowId=""  d

	..s No=$p(^DHCINGR(RowId),"^",1)
	..s AuditFlag=$p(^DHCINGR(RowId),"^",29)
	..s Type=$p(^DHCINGR(RowId),"^",30)
	..q:Type'=..sssCode()
	..q:AuditFlag'="Y"
	..s No="RK"_No			;HRP约定
	..
	..s Ch=""
	..f  s Ch=$o(^DHCINGR(RowId,"GRI",Ch)) q:Ch=""  d
	...s IngriData=$g(^DHCINGR(RowId,"GRI",Ch))
	...s Qty=$p(IngriData,"^",4)
	...s TrUomId=$p(IngriData,"^",10)
	...s BatchNo=$p(IngriData,"^",13)
	...s InciId=$p(IngriData,"^",25)
	...s Rp=$p(IngriData,"^",30)
	...s RpAmt=$p(IngriData,"^",31)
	...
	...s Remark=""
	...s:$d(^DHCINGR(RowId,"GRI",Ch,"REM",1)) Remark=^DHCINGR(RowId,"GRI",Ch,"REM",1)
	...;s Remark=RowId_"||"_Ch_"||"_Remark
	...
	...s InciCode=$p(^INCI(InciId,1),"^",1)
	...s BUomId=$p(^INCI(InciId,1),"^",10)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUomId,BUomId)
	...s Qty=Qty*UomFac
	...s Rp=Rp/UomFac
	...
	...d QueryInGdDetail
	.
	.s RowId=""
	.f  s RowId=$o(^INGRT(0,"AUDITDATE",Date,RowId)) q:RowId=""  d

	..s No=$p(^INGRT(RowId),"^",1)
	..s AuditFlag=$p(^INGRT(RowId),"^",15)
	..s Type=$p(^INGRT(RowId),"^",16)
	..q:Type'=..sssCode()
	..q:AuditFlag'="Y"
	..s No="TH"_No			;HRP约定
	..
	..s Ch=""
	..f  s Ch=$o(^INGRT(RowId,"DHCGRR",Ch)) q:Ch=""  d
	...s IngrtData=$g(^INGRT(RowId,"DHCGRR",Ch))
	...q:IngrtData=""
	...
	...s Qty=$p(IngrtData,"^",2)
	...s TrUomId=$p(IngrtData,"^",3)
	...s RpAmt=$p(IngrtData,"^",4)
	...s Inclb=$p(IngrtData,"^",6)
	...s Rp=$p(IngrtData,"^",7)
	...s Remark=$p(IngrtData,"^",21)
	...
	...s InciId=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	...s InciCode=$p(^INCI(InciId,1),"^",1)
	...s BUomId=$p(^INCI(InciId,1),"^",10)
	...s Incib=$p(^INCI(InciId,"IL",IL,"LB",LB),"^",1)
	...s IB=$p(Incib,"||",2)
	...s BatchNo=$p(^INCI(InciId,"IB",IB),"^",1)
	...
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUomId,BUomId)
	...s Qty=Qty*UomFac
	...s Rp=Rp/UomFac
	...
	...d QueryInGdDetail
	Quit $$$OK
QueryInGdDetail
	s Data=$lb(RowId,No,InciCode,BatchNo,Rp,Qty,RpAmt,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 7.1.入库明细表(HIP_MAT_IN_DETAILINV)---按发票确认统计
/// CALL web_DHCSTMHUI.HIP_MAT_IN_DETAILINV("2022-08-26","2022-10-28")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryInGdDetailINV","2022-08-26","2022-10-28")
Query QueryInGdDetailINV(StartDate As %String, EndDate As %String) As Query(ROWSPEC = "IN_ID,IN_NO,INV_CODE,BATCH_NO,PRICE,AMOUNT,AMOUNT_MONEY,NOTE") [ SqlName = HIP_MAT_IN_DETAILINV, SqlProc ]
{
}

ClassMethod QueryInGdDetailINVExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	f Date=StartDate:1:EndDate d
	.s DateStr=$zd(Date,3)
	.s Year=$p(DateStr,"-",1)
	.s Month=$p(DateStr,"-",2)
	.
	.s Inclb=""
	.f  s Inclb=$o(^DHCPAYTRANS(0,"DATEINCLB",Date,Inclb)) q:Inclb=""  d
	..s InvTransId=""
	..f  s InvTransId=$o(^DHCPAYTRANS(0,"DATEINCLB",Date,Inclb,InvTransId)) q:InvTransId=""  d
	...s TransType=$p(^DHCPAYTRANS(InvTransId),"^",1)
	...s Pointer=$p(^DHCPAYTRANS(InvTransId),"^",2)
	...i (TransType="G")||(TransType="GC") d
	....s InGdMain=+Pointer
	....s InGdCh=$p(Pointer,"||",2)
	....s AuditFlag=$p(^DHCINGR(InGdMain),"^",29)
	....q:AuditFlag'="Y"
	....s Type=$p(^DHCINGR(InGdMain),"^",30)
	....q:Type'=..sssCode()
	....s TmpNo=$p(^DHCINGR(InGdMain),"^",1)
	....s No=$s(TransType="G":"RK"_TmpNo,1:"QXRK"_TmpNo)
	....s IngriData=$g(^DHCINGR(InGdMain,"GRI",InGdCh))
	....s Qty=$p(IngriData,"^",4)
	....s TrUomId=$p(IngriData,"^",10)
	....s BatchNo=$p(IngriData,"^",13)
	....s InciId=$p(IngriData,"^",25)
	....s Rp=$p(IngriData,"^",30)
	....s RpAmt=$p(IngriData,"^",31)
	....s Remark=""
	....s:$d(^DHCINGR(InGdMain,"GRI",InGdCh,"REM",1)) Remark=^DHCINGR(InGdMain,"GRI",InGdCh,"REM",1)
	....s InciCode=$p(^INCI(InciId,1),"^",1)
	....s BUomId=$p(^INCI(InciId,1),"^",10)
	....s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUomId,BUomId)
	....s Qty=Qty*UomFac
	....s Rp=Rp/UomFac
	....d QueryInGdDetailINV
	...e  d
	....s InGdRet=+Pointer
	....s InRetCh=$p(Pointer,"||",2)
	....s TmpNo=$p(^INGRT(InGdRet),"^",1)
	....s No=$s(TransType="R":"TH"_TmpNo,1:"QXHT"_TmpNo)		;HRP约定
	....s AuditFlag=$p(^INGRT(InGdRet),"^",15)
	....s Type=$p(^INGRT(InGdRet),"^",16)
	....q:Type'=..sssCode()
	....q:AuditFlag'="Y"
	....s IngrtData=$g(^INGRT(InGdRet,"DHCGRR",InRetCh))
	....q:IngrtData=""
	....s Qty=$p(IngrtData,"^",2)
	....s TrUomId=$p(IngrtData,"^",3)
	....s RpAmt=$p(IngrtData,"^",4)
	....s Inclb=$p(IngrtData,"^",6)
	....s Rp=$p(IngrtData,"^",7)
	....s Remark=$p(IngrtData,"^",21)
	....s InciId=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	....s InciCode=$p(^INCI(InciId,1),"^",1)
	....s BUomId=$p(^INCI(InciId,1),"^",10)
	....s Incib=$p(^INCI(InciId,"IL",IL,"LB",LB),"^",1)
	....s IB=$p(Incib,"||",2)
	....s BatchNo=$p(^INCI(InciId,"IB",IB),"^",1)
	....s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUomId,BUomId)
	....s Qty=Qty*UomFac
	....s Rp=Rp/UomFac
	....d QueryInGdDetailINV
	
	Quit $$$OK
QueryInGdDetailINV
	s Data=$lb(+Pointer,No,InciCode,BatchNo,Rp,Qty,RpAmt,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 8.出库主表(HIP_MAT_OUT_MAIN)
/// CALL web_DHCSTMHUI.HIP_MAT_OUT_MAIN("2022-07-01","2022-08-04")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryTrf","2022-08-04","2022-08-04")
Query QueryTrf(StartDate As %String, EndDate As %String) As Query(ROWSPEC = "OUT_NO,YEAR,MONTH,BUS_TYPE_CODE,STORE_CODE,BRIEF,DEPT_CODE,DEPT_EMP,MAKER,OUT_DATE,CHECKER,CHECK_DATE,CONFIRMER,CONFIRM_DATE,PROJ_CODE,SOURCE_CODE,STATE,HOS_DISTRICT") [ SqlName = HIP_MAT_OUT_MAIN, SqlProc ]
{
}

ClassMethod QueryTrfExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	s TypeCode=3
	s State=3
	s ProjCode=""
	s SourceCode=""
	f Date=StartDate:1:EndDate d
	.s DateStr=$zd(Date,3)
	.s Year=$p(DateStr,"-",1)
	.s Month=$p(DateStr,"-",2)
	.s Init=""
	.f  s Init=$o(^DHCINIT(0,"AckDate",Date,Init)) q:Init=""  d
	..s Type=$p(^DHCINIT(Init),"^",24)
	..q:Type'=..sssCode()
	..s INITState=$p(^DHCINIT(Init),"^",14)
	..q:((INITState=99)||(INITState=20)||(INITState=10)||(INITState=11))
	..s OutAckUser=$p(^DHCINIT(Init),"^",11)
	..q:OutAckUser=""
	..s No=$p(^DHCINIT(Init),"^",1)
	..s FromLocId=$p(^DHCINIT(Init),"^",5)
	..s FromLocCode=$p(^CTLOC(FromLocId),"^",1)
	..s Remark=""
	..s:$d(^DHCINIT(Init,"REM",1)) Remark=^DHCINIT(Init,"REM",1)
	..s ToLocId=$p(^DHCINIT(Init),"^",6)
	..s ToLocCode=$p(^CTLOC(ToLocId),"^",1)
	..s InAckUser=$p(^DHCINIT(Init),"^",17)
	..s CreateUser=$p(^DHCINIT(Init),"^",8)
	..s CreateDate=$p(^DHCINIT(Init),"^",2)
	..s CreateDate=$zd(CreateDate,3)
	..s OutAckDate=DateStr
	..s HospId=..sssHospId(FromLocId)
	..s HospCode=$s(HospId'="":$p(^CT("HOSP",HospId),"^",1),1:"")
	..d QueryTrf
	Quit $$$OK
QueryTrf
	s Data=$lb(No,Year,Month,TypeCode,FromLocId,Remark,ToLocId,InAckUser,CreateUser,CreateDate,OutAckUser,
	OutAckDate,OutAckUser,OutAckDate,ProjCode,SourceCode,State,HospCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 9.出库明细表(HIP_MAT_OUT_DETAIL)
/// CALL web_DHCSTMHUI.HIP_MAT_OUT_DETAIL("2022-07-01","2022-08-04")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryTrfDetail","2022-08-04","2022-08-04")
Query QueryTrfDetail(StartDate As %String, EndDate As %String) As Query(ROWSPEC = "OUT_ID,OUT_NO,INV_CODE,BATCH_NO,PRICE,AMOUNT,AMOUNT_MONEY,NOTE") [ SqlName = HIP_MAT_OUT_DETAIL, SqlProc ]
{
}

ClassMethod QueryTrfDetailExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)

	s TypeCode=3
	s State=3

	f Date=StartDate:1:EndDate d
	.s Init=""
	.f  s Init=$o(^DHCINIT(0,"AckDate",Date,Init)) q:Init=""  d
	..s Type=$p(^DHCINIT(Init),"^",24)
	..q:Type'=..sssCode()
	..s INITState=$p(^DHCINIT(Init),"^",14)
	..q:((INITState=99)||(INITState=20)||(INITState=10)||(INITState=11))
	..s OutAckUser=$p(^DHCINIT(Init),"^",11)
	..q:OutAckUser=""
	..s No=$p(^DHCINIT(Init),"^",1)
	..s DetailCh=0
	..f  s DetailCh=$o(^DHCINIT(Init,"ITI",DetailCh)) q:DetailCh=""  d
	...s Inclb=$p(^DHCINIT(Init,"ITI",DetailCh),"^",3)
	...s Inci=+Inclb
	...s InciCode=$p(^INCI(Inci,1),"^",1)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
	...s Incib=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	...s BatchNo=$p(^INCI($p(Incib,"||",1),"IB",$p(Incib,"||",2)),"^",1)
	...s TrUomId=$p(^DHCINIT(Init,"ITI",DetailCh),"^",7)
	...s Rp=$p(^DHCINIT(Init,"ITI",DetailCh),"^",15)
	...s Qty=$p(^DHCINIT(Init,"ITI",DetailCh),"^",1)
	...s RpAmt=$p(^DHCINIT(Init,"ITI",DetailCh),"^",16)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUomId,BUomId)
	...s Qty=Qty*UomFac
	...s Rp=Rp/UomFac
	...s Remark=Init_"||"_DetailCh_$p(^DHCINIT(Init,"ITI",DetailCh),"^",24)
	...d QueryTrfDetail
	Quit $$$OK
QueryTrfDetail
	s Data=$lb(Init,No,InciCode,BatchNo,Rp,Qty,RpAmt,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 库房字典
/// CALL web_DHCSTMHUI.MAT_DEPT_DICT()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRPData","QueryDHCSTloc")
Query QueryDHCSTloc() As Query(ROWSPEC = "STORE_CODE,STORE_NAME,STORE_FLAG") [ SqlName = MAT_DEPT_DICT, SqlProc ]
{
}

ClassMethod QueryDHCSTlocExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	;按科室扩充信息维护中的"器械材料"取值
	s DHCLoc=0
	f  s DHCLoc=$o(^DHCLOC(DHCLoc)) q:DHCLoc=""  d
	.s DHCLocData=^DHCLOC(DHCLoc)
	.s LocId=$p(DHCLocData,"^",1)
	.s DHCLocType=$p(DHCLocData,"^",5)
	.q:DHCLocType'="A"
	.
	.s STOREFLAG=1						;1-表示库房
	.s LocData=^CTLOC(LocId)
	.s LocCode=$p(LocData,"^",1)
	.s LocDesc=$p(LocData,"^",2)
	.d QueryDHCSTloc
	
	Quit $$$OK
QueryDHCSTloc
	s Data=$lb(LocId,LocDesc,STOREFLAG)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
