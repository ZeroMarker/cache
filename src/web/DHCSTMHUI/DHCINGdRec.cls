Import sqluser

/// Descript:入库主表相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-25
Class web.DHCSTMHUI.DHCINGdRec Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTIMPORTM";

/// Descript:	保存/更新入库单信息(Js调用)
/// Creator:	lihui
/// CreateDate:	20180904
/// w ##class(web.DHCSTMHUI.DHCINGdRec).jsSave(^tmpqsx("DHCINGdRec).jsSave1"),^tmpqsx("DHCINGdRec).jsSave2"))
ClassMethod jsSave(MainInfo As %String, ListData As %String) As %Library.String
{
	n (MainInfo,ListData)
	
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(MainInfo,ListData)
	q RtnObj.Json()
}

/// Descript:	保存/更新入库单信息
/// Creator:	lihui
/// CreateDate:	2012-06-26
/// Table:	DHC_InGdRec,DHC_InGdRecItm
/// Input:	主单信息，明细信息
/// Output:
/// Return：成功：入库单主表id；
/// 失败：ErrCode:ErrInfo
/// w ##class(web.DHCSTMHUI.DHCINGdRec).Save(^tsr("MainInforec"),^tsr("ListDatarec"))
ClassMethod Save(MainInfo As %String, ListData As %String) As RtnObj
{
	n (MainInfo,ListData)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	
	s Sc=PJObj.%FromJSON(MainInfo)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	s IngrId=PJObj.%Get("IngrId")
	
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s pLocId=PJObj.%Get("RecLoc")
	
	ts
	i IngrId=""  d
	.s RtnObj=..Insert(MainInfo)	;保存入库主表
	e  d
	.s RtnObj=..Update(MainInfo)  ;更新入库主表信息
	i RtnObj.success'=0 tro  q RtnObj
	
	s IngrId=RtnObj.rowid
	i ListData'=""  d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecItm).Save(IngrId,ListData,MainInfo) //高值入参MainInfo
	i RtnObj.success'=0 tro  q RtnObj
	
	
	&sql(update dhc_ingdrecitm set ingri_ctloc_dr=:pLocId where ingri_ingr_parref=:IngrId)
	i SQLCODE<0 d RtnObj.Err(-2,"","更新入库明细中入库科室失败!") tro  q RtnObj

	/// 入库时保存时自动完成
	s GroupId=""
	s User=$p(^DHCINGR(IngrId),"^",16)
	s:User'="" GroupId=$p(^SSU("SSUSR",User),"^",5)
	s LocId=$p(^DHCINGR(IngrId),"^",13)
	s Param=GroupId_"^"_LocId_"^"_User
	s AppName=..%GetParameter("AppName")
	s AutoCompAfterSaveIN=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoCompAfterSaveIN",Param)
	s Params="{""gUserId"":"""_User_""",""gGroupId"":"""_GroupId_"""}"
	s CompState=$p($g(^DHCINGR(IngrId)),"^",12)
	i (AutoCompAfterSaveIN="Y")&&(CompState'="Y") d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).MakeComplete(IngrId,Params)
	i RtnObj.success'=0  tro  q RtnObj
	
	//传递入库信息到平台
	s HospId=..sssHospId(LocId)
	s Ret=##class(web.DHCSTMHUI.ServiceForSCI).SaveIngr(IngrId)
	s Ret=##class(web.DHCSTMHUI.ServiceForECS).SaveIngr(IngrId,HospId)
	i Ret<0 tro  q RtnObj.Err(-1,"","云平台处理入库单失败!")
	
	tc
	s RtnObj.rowid=IngrId
	q RtnObj
}

/// Descript:	查询入库单
/// Creator:	lihui
/// CreateDate: 2012-06-26
/// Input:	查询条件
/// Output:	主单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRec","Query",^templxt("2222"))
Query Query(Params As %String) As Query(ROWSPEC = "IngrId,IngrNo,Vendor,RecLocId,RecLoc,IngrType,PurchUser,PoNo,CreateUser,CreateDate,Complete,ReqLoc,StkGrp,RpAmt:%Float,SpAmt:%Float,AuditDate,AuditUser,Margin:%Float,AcceptUser,VenId,InGrRemarks,SourceOfFund,ReqLocDesc,AdjCheque,GiftFlag,Audit,AuditFlag,PrintCount:%Float,CreateTime")
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")
	s EndDate=PJobj.%Get("EndDate") 
	s pNo=PJobj.%Get("FInGrNo")
	s pVendorId=PJobj.%Get("FVendorBox")
	s pRecLocId=PJobj.%Get("FRecLoc")
	s pCompleteFlag=PJobj.%Get("FStatusBox")
	s pIncId=PJobj.%Get("IncId")
	s pAuditFlag=PJobj.%Get("AuditFlag")
	s pInvNo=PJobj.%Get("InvNo")
	s pUserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	s GroupId=PJobj.%Get("gGroupId")
	s pCreateUserId=PJobj.%Get("CreateUserId")
	s pQueryType=PJobj.%Get("QueryType")
	s pPrintFlag=PJobj.%Get("PrintFlag") 
	s pFindtype=PJobj.%Get("Findtype")  ;调价换票或者赠送标志
	s pRequestLoc=PJobj.%Get("RequestLoc")
	s pHVFlag=PJobj.%Get("HVFlag")
	s pAcceptFlag=PJobj.%Get("AcceptFlag")  ;验收标志
	s:pInvNo'="" pInvNo=$$ALPHAUP^SSUTIL4(pInvNo)
	s PScgId=PJobj.%Get("ScgId")
	s PInci=PJobj.%Get("Inci")
	s PInciDesc=PJobj.%Get("InciDesc")
	s pIngrStr=PJobj.%Get("IngrStr")
	q:(pIngrStr="")&&((StartDate="")||(EndDate="")||(pRecLocId="")) $$$OK

	
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s pHospId=..sssHospId(pRecLocId)
	s:pHospId="" pHospId=HospId
	s StkGrplist=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(pUserId,..sssCode(),pRecLocId,"",pHospId)
	
	;根据参数过滤需要验收后再审核的类组
	s Param=GroupId_"^"_pRecLocId_"^"_pUserId_"^"_$g(pHospId)
	s AppName=..%GetParameter("AppName")
	s DoubleAuditStkGrplist=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"DoubleAudit",Param)

	s sqlStr = "select INGR_RowId as Rowid,INGR_No,INGR_APCVM_DR,INGR_APCVM_DR->APCVM_Name as Vendor,"
		_"INGR_Loc_Dr->CTLOC_Desc as RecLoc,INGR_Loc_Dr as RecLocId ,INGR_Type->IPT_Desc as IngrType, INGR_SSUSR_Purch_DR->SSUSR_NAME AS PurchUser,"
		_"INGR_INPO_DR->INPO_No as PoNo, INGR_CreateUser IngrUser, INGR_CreateUser->SSUSR_NAME AS CreateUser, INGR_CreateDate,INGR_CreateTime,"
		_"INGR_Completed,INGR_ReqLoc_Dr as ReqLoc,INGR_ReqLoc_Dr->CTLOC_Desc as ReqLocDesc, INGR_SCG_DR as StkGrpId, INGR_SCG_DR->SCG_Desc as StkGrp,INGR_AuditFlag,"
		_"INGR_Date,INGR_SSUSR_DR,INGR_SSUSR_Accept_DR,INGR_StkType stkType,INGR_Remarks InGrRemarks,INGR_SourceOfFund->sof_desc SOFDesc,INGR_PrintFlag,INGR_GiftFlag,INGR_AdjCheque "
		_"from DHC_INGdRec where 1=1"
	i pIngrStr'="" d
	.s sqlStr=sqlStr_" and INGR_RowId in ("_pIngrStr_")"
	e  d
	.s sqlStr=sqlStr_" and (INGR_CreateDate between "_StartDate_" and "_EndDate_") and INGR_Loc_Dr="_pRecLocId
	s sqlStr=sqlStr_" Order by INGR_CreateDate Desc,INGR_CreateTime Desc"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s IngrId = result.Data("Rowid")
		s IngrNo = result.Data("INGR_No")
		s Vendor = result.Data("Vendor")
		s VenId=result.Data("INGR_APCVM_DR")
		s RecLocId = result.Data("RecLocId")
		s RecLoc = result.Data("RecLoc")
		s RecLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RecLoc)
		s IngrType=result.Data("IngrType")
		s PurchUser=result.Data("PurchUser")
		s PoNo = result.Data("PoNo")
		s IngrUser = result.Data("IngrUser")
		continue:(pCreateUserId'="")&&(IngrUser'=pCreateUserId)
		s CreateUser = result.Data("CreateUser")
		s printflag=result.Data("INGR_PrintFlag")
		s:printflag="" printflag="N"
		continue:(pPrintFlag=2)&(printflag'="Y")  //过滤未打印
		continue:(pPrintFlag=3)&(printflag="Y")   //过滤已打印
		s CreateDate = result.Data("INGR_CreateDate")
		s CreateTime = result.Data("INGR_CreateTime")
		s CompleteFlag = result.Data("INGR_Completed")
		i CompleteFlag="" s CompleteFlag="N"
		s ReqLoc = result.Data("ReqLoc")
		continue:(pRequestLoc'="")&&(ReqLoc'=pRequestLoc)
		s ReqLocDesc = result.Data("ReqLocDesc")
		s StkGrp = result.Data("StkGrp")
		s StkGrpId=result.Data("StkGrpId")
		continue:(PScgId'="")&&(StkGrpId'=PScgId)
		s Chl=""
		s:PInci'="" Chl=$o(^DHCINGR(0,"INCI",PInci,IngrId,0))
		continue:(PInci'="")&(Chl="")
		s Ret=0
		s:PInciDesc'="" Ret=..CheckInciDesc(IngrId,PInciDesc)
		continue:(PInciDesc'="")&&(Ret'=0)
		s SourceOfFund=result.Data("SOFDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		CONTINUE:(StkGrpId'="")&&(StkGrplist'="")&&(("^"_StkGrplist_"^")'[("^"_StkGrpId_"^"))	;按照人员类组过滤入库单
		s AuditFlag=result.Data("INGR_AuditFlag")
		s:AuditFlag="" AuditFlag="N"
		s AuditUserId=result.Data("INGR_SSUSR_DR")
		s AuditDate=result.Data("INGR_Date")
		s venDate=CreateDate
		i AuditDate'="" s venDate=AuditDate
		s:VenId'="" Vendor=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(venDate,VenId)
		s AcceptUserId=result.Data("INGR_SSUSR_Accept_DR")
		continue:((pAcceptFlag="Y")&&(AcceptUserId=""))
		continue:((pAcceptFlag="N")&&(AcceptUserId'=""))
		s stkType=result.Data("stkType")
		CONTINUE:(pQueryType="audit")&&((DoubleAuditStkGrplist[("*"_StkGrpId_"*"))&&(StkGrpId'="")&&(DoubleAuditStkGrplist'=""))&&(AcceptUserId="")	;根据参数过滤需要验收后再审核的类组
		CONTINUE:stkType'=..sssCode()
		CONTINUE:(pAuditFlag'="")&(AuditFlag'=pAuditFlag)
		CONTINUE:(pCompleteFlag'="")&(CompleteFlag'=pCompleteFlag)
		CONTINUE:(pNo'="")&(IngrNo'[pNo)
		CONTINUE:(pVendorId'="")&(VenId'=pVendorId)
		s Chl="",Sub=""
		s:pIncId'="" Chl='$o(^DHCINGR(0,"INCI",pIncId,IngrId,0))
		CONTINUE:(pIncId'="")&(Chl="") 
		s:pInvNo'="" Sub=$o(^DHCINGR(0,"INVNO",pInvNo,IngrId,0))
		CONTINUE:(pInvNo'="")&(Sub="") 
		s AdjCheque=result.Data("INGR_AdjCheque")
		s:AdjCheque="" AdjCheque="N"
		CONTINUE:(pFindtype="A")&&(AdjCheque'="Y")
		s GiftFlag=result.Data("INGR_GiftFlag")
		s:GiftFlag="" GiftFlag="N"
		CONTINUE:(pFindtype="G")&&(GiftFlag'="Y")
		s TmpHVFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(IngrId,"G")
		continue:(pHVFlag'="")&&(TmpHVFlag'=pHVFlag)
		s IsInclude=""
		i (StkGrpId="")&&(StkGrplist'="") d
		.s DetailScg=..GetRecDetailScg(IngrId)
		.s:DetailScg'="" IsInclude=##class(web.DHCSTMHUI.Common.UtilCommon).CheckInList(StkGrplist,DetailScg,"^")
		continue:IsInclude=0				//明细过滤
		//总金额
		&sql(select sum(initm_realtotal),sum(initm_SpAmt),initm_invno
		into :RpAmt,:SpAmt,:InvNoNumber from dhc_ingdrecitm where ingri_ingr_parref=:IngrId)
		s (AuditUser,AcceptUser)=""
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
		s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
		s Margin=SpAmt-RpAmt
		s Complete="未完成",Audit="未审核"
		i CompleteFlag="Y"  d
		.s Complete="完成"
		i AuditFlag="Y"  d
		.s Audit="已审核"
		s InGrRemarks=result.Data("InGrRemarks")
		s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s InGrRemarks=$lts(InGrRemarks,MemoDelim)
		s PrintCount=##class(web.DHCSTMHUI.RQReport).GetBillPrintCount("G",IngrId)
		d OutPutRow
	}
	Quit $$$OK

OutPutRow
	s Data=$lb(IngrId,IngrNo,Vendor,RecLocId,RecLoc,IngrType,PurchUser,PoNo,CreateUser,CreateDate,Complete,ReqLoc,StkGrp,RpAmt,SpAmt,AuditDate,AuditUser,Margin,AcceptUser,VenId,InGrRemarks,SourceOfFund,ReqLocDesc,AdjCheque,GiftFlag,Audit,AuditFlag,PrintCount,CreateTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	根据RowId取得入库单主项信息
/// Creator:	lihui
/// CreateDate: 2012-06-25
/// Input:	入库主表id  
/// Output:主单信息
/// Return：
/// w ##class(web.DHCSTMHUI.DHCINGdRec).Select(114)
ClassMethod Select(Ingr As %String) As %String
{
	n (Ingr)
	q:+Ingr=0 ""

	S InGrNo =$p(^DHCINGR(Ingr),"^",1)
	S ApcvmDr =$p(^DHCINGR(Ingr),"^",3)
	s AuditDate=$p(^DHCINGR(Ingr),"^",4)
	s AuditUserId=$p(^DHCINGR(Ingr),"^",8)
	s AuditTime=$p(^DHCINGR(Ingr),"^",9)
	s PoId=$p(^DHCINGR(Ingr),"^",11)
	s Complete=$p(^DHCINGR(Ingr),"^",12)
	s LocId=$p(^DHCINGR(Ingr),"^",13)
	s CreateDate=$p(^DHCINGR(Ingr),"^",14)
	s CreateTime=$p(^DHCINGR(Ingr),"^",15)
	s CreateUserId=$p(^DHCINGR(Ingr),"^",16)
	s PayAllowed=$p(^DHCINGR(Ingr),"^",22)		;是否允许付款
	s IngrTypeId=$p(^DHCINGR(Ingr),"^",23)
	s PurUserId=$p(^DHCINGR(Ingr),"^",24)
	s ReqLocId=$p(^DHCINGR(Ingr),"^",25)
	s AcceptUserId=$p(^DHCINGR(Ingr),"^",26)
	s TreasureUserId=$p(^DHCINGR(Ingr),"^",27)
	s StkGrpId=$p(^DHCINGR(Ingr),"^",28)
	s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
	s StkType=$p(^DHCINGR(Ingr),"^",30)
	s GiftFlag=$p(^DHCINGR(Ingr),"^",31)
	s AdjCheque=$p(^DHCINGR(Ingr),"^",32)
	s SourceOfFund=$p(^DHCINGR(Ingr),"^",36)
	s InGrRemarks=##class(web.DHCSTMHUI.Common.UtilCommon).GetREMList("^DHCINGR",Ingr)
	q:StkType'=..sssCode() "{}"
	
	s (AuditUser,PoNo,LocDesc,VendorDesc,CreateUser,IngrType,PurUser,ReqLocDesc,AcceptUser,TreasureUser,StkGrp,SourceOfFundDesc)=""
	s:+AuditDate'=0 AuditDate=..DL2H(AuditDate)
	s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
	s:+AuditTime'=0 AuditTime=..TL2H(AuditTime)
	s:PoId'="" PoNo=$p(^INPO(PoId),"^",1)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2),LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
	s:ApcvmDr'="" VendorDesc=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(CreateDate,ApcvmDr)
	s:+CreateDate'=0 CreateDate=..DL2H(CreateDate)
	s:+CreateTime'=0 CreateTime=..TL2H(CreateTime)
	s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
	s:IngrTypeId'="" IngrType=$p(^DHCOPTYPE(IngrTypeId),"^",2)
	s:PurUserId'="" PurUser=$p(^SSU("SSUSR",PurUserId),"^",2)
	s:ReqLocId'="" ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2),ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
	s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
	s:TreasureUserId'="" TreasureUser=$p(^SSU("SSUSR",TreasureUserId),"^",2)
	s:StkGrpId'="" StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
	s:SourceOfFund'="" SourceOfFundDesc=$p(^DHCSOUROFFUND(SourceOfFund),"^",2)
	s RecLocId=..sssComboStr(LocId,LocDesc)
	s Vendor=..sssComboStr(ApcvmDr,VendorDesc)
	s AuditUser=..sssComboStr(AuditUserId,AuditUser)
	s LocDesc=..sssComboStr(LocId,LocDesc)
	s CreateUser=..sssComboStr(CreateUserId,CreateUser)
	s PurUser=..sssComboStr(PurUserId,PurUser)
	s ReqLocId=..sssComboStr(ReqLocId,ReqLocDesc)
	s AcceptUserId=..sssComboStr(AcceptUserId,AcceptUser)
	s SourceOfFund=..sssComboStr(SourceOfFund,SourceOfFundDesc)
	s TreasureUser=..sssComboStr(TreasureUserId,TreasureUser)
	s IngrTypeId=..sssComboStr(IngrTypeId,IngrType)
	s Data=Ingr_"^"_InGrNo_"^"_ApcvmDr_"^"_Vendor_"^"_AuditDate_"^"_AuditUserId_"^"_AuditUser_"^"_AuditTime_"^"_PoId_"^"_PoNo
		_"^"_Complete_"^"_RecLocId_"^"_LocDesc_"^"_CreateDate_"^"_CreateTime_"^"_CreateUserId_"^"_CreateUser_"^"_PayAllowed_"^"_IngrTypeId_"^"_IngrType
		_"^"_PurUserId_"^"_PurUser_"^"_ReqLocId_"^"_ReqLocDesc_"^"_AcceptUserId_"^"_AcceptUser_"^"_TreasureUserId_"^"_TreasureUser_"^"_StkGrpId_"^"_StkGrp
		_"^"_AuditFlag_"^"_GiftFlag_"^"_AdjCheque_"^"_InGrRemarks_"^"_SourceOfFund_"^"_SourceOfFundDesc_"^"_VendorDesc_"^"_ReqLocDesc
	s Title="IngrId^InGrNo^ApcvmDr^Vendor^AuditDate^AuditUserId^AuditUser^AuditTime^PoId^PoNo"
		_"^Complete^RecLocId^RecLoc^CreateDate^CreateTime^CreateUserId^CreateUser^PayAllowed^IngrTypeId^IngrType"
		_"^PurchaseUserId^PurchaseUser^ReqLocId^ReqLoc^AcceptUserId^AcceptUser^TreasureUserId^TreasureUser^StkGrpId^StkGrp"
		_"^AuditFlag^GiftFlag^AdjCheque^InGrRemarks^SourceOfFund^SourceOfFundDesc^VendorDesc^ReqLocDesc"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:	插入入库主表记录
/// Creator:	lihui
/// CreateDate:	2012-06-26
/// Table:	DHC_InGdRec
/// Input:	主单信息
/// Output:
/// Return：成功：入库主表id；
ClassMethod Insert(MainInfo) As RtnObj
{
	n (MainInfo,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s VenId=PJObj.%Get("ApcvmDr")
	i VenId="" s VenId=PJObj.%Get("Vendor")
	i VenId="" q RtnObj.Err(-2,"","供应商不能为空!","","0")
	
	s LocId=PJObj.%Get("RecLoc")
	i LocId="" q RtnObj.Err(-3,"","入库科室不能为空!","","0")
	
	s CreateUser=PJObj.%Get("gUserId")
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	s PresentFlag=PJObj.%Get("GiftFlag")
	s ExchangeFlag=PJObj.%Get("AdjCheque")
	s IngrTypeId=PJObj.%Get("IngrTypeId")
	s PurUserId=PJObj.%Get("PurchaseUser")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s PoId=PJObj.%Get("PoId")
	s InGrRemarks=PJObj.%Get("InGrRemarks")
	s SourceOfFund=PJObj.%Get("SourceOfFund")
	s ReqLoc=PJObj.%Get("ReqLocId")
	s SynBarcode=PJObj.%Get("SynBarcode")
	s InitId=PJObj.%Get("InitId")
	s AcceptUserId=PJObj.%Get("AcceptUserId")
	s OeriRecflag=PJObj.%Get("OeriRecflag")  ;高值入库补录标志
	s gHospId=PJObj.%Get("gHospId")
	s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s InGrRemarks=$lfs(InGrRemarks,MemoDelim)
	s:IngrTypeId="" IngrTypeId=$o(^DHCOPTYPE(0,"TYPE","IM",0))
	s Complete="N"
	s AuditFlag="N"
	s StkType=..sssCode()
	
	;生成单号需加锁
	s AppName=..%GetParameter("AppName")
	s ret=..sssLock(AppName)
	i ret'=0 q RtnObj.Err(-99,"","生成入库单号加锁失败!")

	s IngrNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
	i IngrNo="" d ..sssUnLock(AppName) d RtnObj.Err(-4,"","生成入库单号失败!")
	q:RtnObj.success'=0 RtnObj
	
	&sql(insert into dhc_ingdrec(INGR_APCVM_DR,INGR_Completed,INGR_CTCUR_DR,
		INGR_ExRate,INGR_HandChg,INGR_No,INGR_Loc_Dr,INGR_CreateUser,
		INGR_CreateDate,INGR_CreateTime,INGR_AdjCheque,INGR_GiftFlag,INGR_Type,
		INGR_SSUSR_Purch_DR,INGR_SCG_DR,INGR_AuditFlag,INGR_StkType,INGR_INPO_DR,
		INGR_Remarks,INGR_SourceOfFund,INGR_ReqLoc_Dr,INGR_Backup3,INGR_INIsTrf_DR,INGR_SSUSR_Accept_DR,INGR_OeoriRecFlag) 
		values (:VenId,:Complete,1,1,0,:IngrNo,:LocId,:CreateUser,:CreateDate,:CreateTime,
		:ExchangeFlag,:PresentFlag,:IngrTypeId,:PurUserId,:StkGrpId,:AuditFlag,:StkType,:PoId,
		:InGrRemarks,:SourceOfFund,:ReqLoc,:SynBarcode,:InitId,:AcceptUserId,:OeriRecflag))
	i SQLCODE'=0  d
	.d ..sssUnLock(AppName)  d RtnObj.Err(-4,"","生成入库单号失败!")
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock(AppName)
	s RtnObj.rowid=$p($g(%ROWID),$c(1))
	q RtnObj
}

/// Descript:	更新入库主表记录
/// Creator:	lihui
/// CreateDate:	2011-12-1
/// Table:	DHC_InGdRec
/// Input:	主单信息
/// Output:
/// Return：成功：0；
ClassMethod Update(MainInfo As %String) As RtnObj
{
	n (MainInfo)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s IngrId=PJObj.%Get("IngrId")
	i ((IngrId="")||('$d(^DHCINGR(IngrId)))) q RtnObj.Err(-2,"","入库单不存在!","",0)
	
	s VenId=PJObj.%Get("ApcvmDr")
	i VenId="" s VenId=PJObj.%Get("Vendor")
	i VenId="" q RtnObj.Err(-3,"","供应商不能为空!","",0)
	
	s LocId=PJObj.%Get("RecLoc")
	i LocId="" q RtnObj.Err(-4,"","入库科室不能为空!","",0)
	
	s PresentFlag=PJObj.%Get("GiftFlag")
	s ExchangeFlag=PJObj.%Get("AdjCheque")
	s IngrTypeId=PJObj.%Get("IngrTypeId")
	s PurUserId=PJObj.%Get("PurchaseUser")
	s InGrRemarks=PJObj.%Get("InGrRemarks")
	s SourceOfFund=PJObj.%Get("SourceOfFund")
	s ReqLoc=PJObj.%Get("ReqLocId")
	s AcceptUserId=PJObj.%Get("AcceptUserId")
	s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s InGrRemarks=$lfs(InGrRemarks,MemoDelim)

	&sql(UPDATE dhc_ingdrec SET INGR_APCVM_DR = :VenId, INGR_Loc_Dr=:LocId,
		INGR_Type=:IngrTypeId, INGR_SSUSR_Purch_DR=:PurUserId,INGR_AdjCheque=:ExchangeFlag,
		INGR_GiftFlag=:PresentFlag,INGR_Remarks=:InGrRemarks,INGR_SourceOfFund=:SourceOfFund,INGR_ReqLoc_Dr=:ReqLoc,
		INGR_SSUSR_Accept_DR=:AcceptUserId 
		WHERE INGR_Rowid=:IngrId)
	i SQLCODE'=0 q RtnObj.Err(-5,"","更新入库单失败!")

	s RtnObj.rowid=IngrId
	q RtnObj
}

/// Descript: 提供js界面调用 插入入库主表信息
/// 20180831 lihui
ClassMethod MainInsertForJs(MainInfo) As %Library.String
{
	n (MainInfo,%session)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	ts
	s RtnObj=..Insert(MainInfo)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript: 提供js界面调用 更新入库主表信息
/// 20180831 lihui
ClassMethod MainUpdateForJs(MainInfo) As %Library.String
{
	n (MainInfo)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	ts
	s RtnObj=..Update(MainInfo)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript: 提供js界面调用 删除入库单
/// 20180831 lihui
/// w ##class(web.DHCSTMHUI.DHCINGdRec).jsDelete(489)
ClassMethod jsDelete(IngrId) As %Library.String
{
	n (IngrId)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..Delete(IngrId)
	q RtnObj.Json()
}

/// Descript:	删除入库单
/// Creator:	lihui
/// CreateDate:	2012-06-27
/// Input:	
/// Output:	
/// Return：0:成功 
///  w ##class(web.DHCSTMHUI.DHCINGdRec).Delete(489)
ClassMethod Delete(IngrId) As RtnObj
{
	n (IngrId,%session)
	s RtnObj=##class(RtnObj).%New()
	i IngrId=""  q RtnObj.Err(-1,"","未选择入库单","",0)

	i '$d(^DHCINGR(IngrId)) q RtnObj.Err(-2,"","入库单不存在!","",0)
	
	s CompFlag=$p(^DHCINGR(IngrId),"^",12)
	s AuditFlag=$p(^DHCINGR(IngrId),"^",29)
	s OeoriRecFlag=..GetOeriRecFlag(IngrId)
	i CompFlag="Y" q RtnObj.Err(-3,"","入库单已完成","",0)
	i AuditFlag="Y" q RtnObj.Err(-4,"","入库单已审核!","",0)
	i ..IsIngriAudited(IngrId)=1 q RtnObj.Err(-5,"","入库单部分明细已审核!","",0)
	
	//先处理SCI平台订单状态
	s LocId=$p(^DHCINGR(IngrId),"^",13)
	s HospId=..sssHospId(LocId)
	d ##class(web.DHCSTMHUI.ServiceForSCI).deleteOrder(IngrId)
	d ##class(web.DHCSTMHUI.ServiceForECS).DeleteIngr(IngrId,HospId)
	
	ts
	;先删除相关的高值跟踪信息
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).DelByPointer("G",+IngrId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-6,"","删除高值跟踪信息失败!")

	//删除补录单据处理补录状态
	i OeoriRecFlag="Y" d
	.s retinfo=..upHvmatState(IngrId)
	.i retinfo'=0 d RtnObj.Err(-7,"","处理高值补录记录失败!")
	i RtnObj.success'=0 tro  q RtnObj
	
	;先删除子表对应扩展表中的数据
	s tmpgriadd=""
	&sql(select INGRINFO_RowId into :tmpgriadd from DHC_INGdRecItmAddionInfo where INGRINFO_DR->INGRI_INGR_ParRef=:IngrId)
	i tmpgriadd'="" d
	.&sql(delete from DHC_INGdRecItmAddionInfo where INGRINFO_DR->INGRI_INGR_ParRef=:IngrId)
	.i SQLCODE'=0 d RtnObj.Err(-8,"","删除明细附加表失败!")
	i RtnObj.success'=0 tro  q RtnObj
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_INGdRec",IngrId)
	&sql(Delete from DHC_InGdRec where INGR_Rowid=:IngrId) 
	i SQLCODE'=0 d
	.d RtnObj.Err(-9,"","删除入库单失败!")
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_INGdRec","User.DHCINGdRec","入库单",IngrId,"","D",OldJsonStr)
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Descript:   判断是否有已经审核的入库明细
/// Creator:    lihui
/// CreateDate: 2013-08-19
/// 0:没有已审核明细,  1有已审核的明细
/// w ##class(web.DHCSTMHUI.DHCINGdRec).IsIngriAudited(4553)
ClassMethod IsIngriAudited(IngrId) As %Library.String
{
	n (IngrId)
	q:IngrId="" 0
	
	s flag=0
	s ch=0
	f  s ch=$o(^DHCINGR(IngrId,"GRI",ch)) q:(ch="")!(flag=1)  d
	.s inclb=$p(^(ch),"^",1)
	.q:inclb=""
	.s flag=1
	
	q flag
}

/// Descript:完成入库单(Js调用)
/// Creator: lihui
/// CreateDate: 20180904
/// w ##class(web.DHCSTMHUI.DHCINGdRec).jsMakeComplete(369,^tmpli("MakeCompleteparams"),"")
ClassMethod jsMakeComplete(IngrId As %String, Params As %String, NightFlag As %String = "") As %Library.String
{
	n (IngrId,Params,NightFlag)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..MakeComplete(IngrId,Params,NightFlag)
	q RtnObj.Json()
}

/// Descript:完成入库单
/// Creator:zhangdongmei
/// CreateDate:2012-06-29
/// Input:入库主表rowid,操作人,安全组id,夜间高值处理命令标志(缺省为空,Y表示夜间处理调用)
/// Output:     
/// Return：0：成功;
/// 失败：ErrCode:ErrInfo
/// w ##class(web.DHCSTMHUI.DHCINGdRec).MakeComplete(369,^tmpli("MakeCompleteparams"),"")
ClassMethod MakeComplete(IngrId As %String, Params As %String, NightFlag As %String = "") As RtnObj
{
	n (IngrId,Params,NightFlag)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","入参解析失败!")
	i IngrId=""  q RtnObj.Err(-2,"","操作完成失败!")
	i '$d(^DHCINGR(IngrId))  q RtnObj.Err(-3,"","入库单不存在!","",0)
	i $p(^DHCINGR(IngrId),"^",12)="Y"  q RtnObj.Err(-4,"","入库单已经完成!","",0)
	
	s User=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	s HospId=PJObj.%Get("gHospId")
	s LocId=$p(^DHCINGR(IngrId),"^",13)
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Param=GroupId_"^"_LocId_"^"_User_"^"_HospId
	s UseItmTrack=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName"),"UseItmTrack",Param)
	s CreBarByIngdrec=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName"),"CreBarByIngdrec",Param)   ;是否在入库时候自动生成高值条码
	s CompFlag="Y"
	
	//检查价格模式2，进价是否与调价表一致
	s RtnObj=..CheckAspRp(IngrId,Param)
	q:RtnObj.success'=0 RtnObj
	
	ts
	i (UseItmTrack="Y")&&(CreBarByIngdrec="Y")&&(NightFlag'="Y") d
	.s Err=..SplitIngr(IngrId)			;仅在高值跟踪时调用
	.i Err<0  d RtnObj.Err(-5,"","入库单拆分高值条目失败!")
	.q:RtnObj.success'=0
	.s Err=..CreateBarCode(IngrId,User)	;仅在高值跟踪时调用
	.i Err<0  d RtnObj.Err(-6,"","入库单生成高值条码失败!")
	i RtnObj.success'=0 tro  q RtnObj
	
	&sql(update dhc_ingdrec set ingr_completed=:CompFlag where ingr_rowid=:IngrId)
	i SQLCODE'=0 tro  q RtnObj.Err(-2,"","操作完成失败!")
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(IngrId,"IMD",User,"G")
	
	s AppName=..%GetParameter("AppName")
	s AutoAuditAfterComp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAuditAfterComp",Param)
	s Paramtitle="gGroupId^gLocId^gUserId^gHospId"
	s paramobj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Param,Paramtitle)
	i (AutoAuditAfterComp="Y")&(NightFlag'="Y") d //高值夜间处理调用该命令时,不进行自动审核
	.s RtnObj=..Audit(IngrId,paramobj,GroupId)
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Descript:取消完成入库单(Js调用)
/// Creator: lihui
/// CreateDate: 20180904
ClassMethod jsCancleComplete(IngrId As %String, Params As %String) As %Library.String
{
	n (IngrId,Params)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..CancleComplete(IngrId,Params)
	q RtnObj.Json()
}

/// Descript:取消完成入库单
/// Creator:lihui
/// CreateDate:2012-06-29
/// Input:入库主表rowid,操作人 
/// Output:     
/// Return：0：成功;
/// 失败：ErrCode:ErrInfo
ClassMethod CancleComplete(IngrId As %String, Params As %String) As RtnObj
{
	n (IngrId,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","入参解析失败!")
	i IngrId=""  q RtnObj.Err(-2,"","请选择入库单","",0)
	i '$d(^DHCINGR(IngrId)) q RtnObj.Err(-3,"","入库单不存在!","",0)
	i $p(^DHCINGR(IngrId),"^",12)'="Y" q RtnObj.Err(-4,"","入库单尚未完成!","",0)
	i $p(^DHCINGR(IngrId),"^",29)="Y" q RtnObj.Err(-5,"","入库单已经审核!","",0)
	
	s Complete="N"
	&sql(update dhc_ingdrec set ingr_completed=:Complete where ingr_rowid=:IngrId)
	i SQLCODE'=0 q RtnObj.Err(-2,"","取消完成失败!")
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(IngrId,"IMD","G")
	q RtnObj
}

/// Descript:根据物资id取物资入库默认信息
/// Creator:    lihui
/// CreateDate: 2012-06-29
/// Table:
/// Input:库存项id,安全组id^科室id^用户id
/// Output:     
/// Return：产地id^产地名称^入库单位id^入库单位^进价^售价^批号^效期^定价类型^招标轮次
/// w ##class(web.DHCSTMHUI.DHCINGdRec).GetItmInfo(8956,"143^153^541")
ClassMethod GetItmInfo(IncId As %String, Params As %String) As %Library.String
{
	n (IncId,Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	
	s GroupId=PJObj.%Get("gGroupId")
	s LocId=PJObj.%Get("gLocId")
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	//s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigManf(IncId,..%GetParameter("AppName"),Params)
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(IncId)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfDesc=$p(ManfInfo,"^",2)
	s BUomId=$p(^INCI(IncId,1),"^",10)
	s PurUomId=$p(^INCI(IncId,3),"^",6)
	s (BUomDesc,PurUomDesc)=""
	s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	s PriceInfo=..GetPriceInfoForRec(IncId,PurUomId,Params)
	s Rp=$p(PriceInfo,"^",1)
	s Sp=$p(PriceInfo,"^",2)
	s BatExp=..GetDefaultBatExp(IncId,Params)
	s BatNo=$p(BatExp,"^",1)
	s ExpDate=$p(BatExp,"^",2)
	s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
	s (MtDr,MtDesc,MaxSp,Spec,Model)=""
	i Info'=""  d
	.s MtDr=$p(^DHCITMINFO(Info),"^",15)
	.s:MtDr'="" MtDesc=$p($g(^DHCINMT(MtDr)),"^",2)
	.s MaxSp=$p(^DHCITMINFO(Info),"^",16)
	.s Spec=$p(^DHCITMINFO(Info),"^",27)
	.s Model=$p(^DHCITMINFO(Info),"^",59)
	s PbDesc=""
	s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
	s vendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(IncId)
	s vendor=$p(vendorStr,"^",1)
	s vendordesc=$p(vendorStr,"^",2)
	s BatchReq=$p(^INCI(IncId,2),"^",10)
	s ExpReq=$p(^INCI(IncId,2),"^",11)
	s:BatchReq="N" BatNo=""
	s:ExpReq="N" ExpDate=""
	s BarCodes=$p(^INCI(IncId,3),"^",9)

	s BRp=$s(+ConFac'=0:Rp/ConFac,1:Rp)
	s BSp=$s(+ConFac'=0:Sp/ConFac,1:Sp)
	s BRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BRp,HospId,2)
	s BSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BSp,HospId,2)
	s InciCode=$p(^INCI(IncId,1),"^",1),InciDesc=$p(^INCI(IncId,1),"^",2)
	s CertInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(IncId)
	s CertNo=$p(CertInfo,"^",1),CertExpDate=$p(CertInfo,"^",2)
	s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
	s:StkGrpInfo'="" GrpId=$p(StkGrpInfo,"^",5)
	s:StkGrpInfo'="" GrpDesc=$p(StkGrpInfo,"^",2)
	s Incsc=$p(^INCI(IncId,2),"^",2)
	s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
	s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(IncId,HospId)
	s MatInsuCode=$p(MatInsuInfo,"^",1)
	s MatInsuDesc=$p(MatInsuInfo,"^",2)
	s Data1=ManfId_"^"_ManfDesc_"^"_PurUomId_"^"_PurUomDesc_"^"_Rp_"^"_Sp_"^"_BatNo_"^"_ExpDate_"^"_MtDesc_"^"_PbDesc
	s Data2=BUomId_"^"_ConFac_"^"_MtDr_"^"_MaxSp_"^"_HVFlag_"^"_BatchReq_"^"_ExpReq_"^"_Spec_"^"_CertNo_"^"_CertExpDate
	s Data3=vendor_"^"_vendordesc_"^"_BarCodes_"^"_BRp_"^"_BSp_"^"_BUomDesc_"^"_InciCode_"^"_InciDesc_"^"_GrpId_"^"_GrpDesc
	s Data4=Model_"^"_IncscDesc_"^"_MatInsuCode_"^"_MatInsuDesc
	s Data= Data1_"^"_Data2_"^"_Data3_"^"_Data4
	s Title="ManfId^ManfDesc^PurUomId^PurUomDesc^Rp^Sp^BatNo^ExpDate^MtDesc^PbDesc"
		_"^BUomId^ConFac^MtDr^MaxSp^HVFlag^BatchReq^ExpReq^Spec^CertNo^CertExpDate"
		_"^vendor^vendordesc^BarCodes^BRp^BSp^BUomDesc^InciCode^InciDesc^GrpId^GrpDesc"
		_"^Model^IncscDesc^MatInsuCode^MatInsuDesc"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:取某物资的批号和效期
/// Creator:    lihui
/// CreateDate: 2012-09-19
/// Table:
/// Input:库存项id
/// Output:     
/// Return：批号^效期
ClassMethod GetDefaultBatExp(IncId As %String, Params As %String, ProduceDate = "") As %Library.String
{
	n (IncId,Params,ProduceDate)
	s BatNo=""
	s ExpDate=""
	s BatnoProp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"DefaBatNo",Params)
	s LastBatExp=..GetLastIngrBatExp(IncId)
	i BatnoProp=1  d     ;取上次入库批号
	.s BatNo=$p(LastBatExp,"^",1)
	e  i BatnoProp=2  d     ;自动生成批号
	.s BatNo=..CreateBatNo(IncId)
	
	s ExpProp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"DefaExpDate",Params)
	i ExpProp=1  d     ;取上次入库效期
	.s ExpDate=$p(LastBatExp,"^",2)
	e  i ExpProp=2  d     ;自动生成效期(当天)
	.s ExpDate=..CreateExpDate(IncId,2)
	e  i ExpProp=3  d     ;自动生成效期（生产日期）
	.s ProduceDate=..DH2L(ProduceDate)
	.s ExpDate=..CreateExpDate(IncId,3,ProduceDate)
	q BatNo_"^"_ExpDate
}

/// Descript:自动生成物资入库批号
/// Creator:    ZhangDongmei
/// CreateDate: 2012-06-29
/// Table:
/// Input:库存项id
/// Output:     
/// Return：批号
/// w ##class(web.DHCSTMHUI.DHCINGdRec).CreateBatNo(9)
ClassMethod CreateBatNo(IncId As %String) As %Library.String
{
	n (IncId)
	s PostFix="01"
	i IncId'=""  d
	.s InciCode=$p(^INCI(IncId,1),"^",1)
	.s PostFix=$e(InciCode,$l(InciCode)-1,$l(InciCode))
	s TmpBatNo=$zd(+$h,8)
	s BatNo=TmpBatNo_PostFix
	q BatNo
}

/// Descript:取某物资最后一次入库的批号和效期
/// Creator:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:
/// Input:库存项id
/// Output:     
/// Return：批号^效期
ClassMethod GetLastIngrBatExp(Inci As %String) As %Library.String
{
	n (Inci)
	s Ingr=$o(^DHCINGR(0,"INCI",Inci,""),-1)
	q:Ingr="" ""
	s Chl=$o(^DHCINGR(0,"INCI",Inci,Ingr,""),-1)
	q:Chl="" ""
	s BatNo=$p(^DHCINGR(Ingr,"GRI",Chl),"^",13)
	s ExpDate=$p(^DHCINGR(Ingr,"GRI",Chl),"^",9)
	s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	q BatNo_"^"_ExpDate
}

/// Descript:自动生成物资效期
/// Creator:    ZhangDongmei
/// CreateDate: 2012-06-29
/// Table:
/// Input:
/// Output:
/// Return：效期
/// w ##class(web.DHCSTMHUI.DHCINGdRec).CreateExpDate()
ClassMethod CreateExpDate(IncId, DateType = "", ProduceDate = "") As %Library.String
{
	n (IncId,DateType,ProduceDate)
	s ExpDate="",CurrDate=""
	i DateType="2" s CurrDate=+$h
	e  i DateType="3" s CurrDate=ProduceDate
	q:CurrDate="" ExpDate
	
	s InfoId=$o(^DHCITMINFO(0,"INCI",IncId,0))
	s InciExpireLen=$s(InfoId'="":$p(^DHCITMINFO(InfoId),"^",32),1:"")
	i InciExpireLen'="" d
	.s ExpDate=$p($SYSTEM.SQL.DATEADD("mm",InciExpireLen,CurrDate)," ")
	q:ExpDate'="" ExpDate

	s ExpDateValue=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"ExpDateValue")
	s ExpDate=$p($SYSTEM.SQL.DATEADD("yy",ExpDateValue,CurrDate)," ")
	s ExpDate=..DL2H(ExpDate)
	q ExpDate
}

/// Descript:   审核入库单(Js调用)
/// Creator:    lihui
/// CreateDate: 20180904
/// w ##class(web.DHCSTMHUI.DHCINGdRec).jsAudit(^tmpbin(863),^tmpbin(864))
ClassMethod jsAudit(IngrIdStr, Params, NightFlag = "") As %Library.String
{
	n (IngrIdStr,Params,NightFlag)
	s RtnObj=##class(RtnObj).%New()
	
	s $ZT=..sssError()
	s del="^"
	s cnt=$l(IngrIdStr,del)
	s ErrMsg="",Succnt=0,RowidStr=""
	f i=1:1:cnt d
	.s IngrId=$p(IngrIdStr,del,i)
	.s RtnObj=..Audit(IngrId,Params,NightFlag)
	.i RtnObj.success=0 d
	..s Succnt=Succnt+1
	..i RowidStr="" d
	...s RowidStr= IngrId
	..e  d
	...s RowidStr=RowidStr_"^"_IngrId
	.e  d
	..s msginfo=IngrId_":"_RtnObj.msg
	..i ErrMsg="" d
	...s ErrMsg= msginfo
	..e  d
	...s ErrMsg=ErrMsg_"#"_msginfo
	s RtnObj.rowid=RowidStr
	s RtnObj.msg=cnt_"@"_Succnt_"@"_ErrMsg
	s RtnObj.success=0
	q RtnObj.Json()
}

/// Descript:   审核入库单
/// Creator:    ZhangDongmei
/// CreateDate: 2011-12-03
/// Table:DHC_InGdRec,DHC_InGdRecItm,INC_ItmBat,INC_ItmLcBt,INC_ItmLoc
/// DHC_LocDailyTotal,DHC_LcBtDailyTotal
/// Input:入库主表id,审核人,安全组id,夜间高值处理命令标志(缺省为空,为Y时不再判断高值条码数量)
/// Output:     
/// Return：成功：0;
/// 失败：ErrCode:ErrInfo
/// w ##class(web.DHCSTMHUI.DHCINGdRec).Audit("94","{""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2""}","")
ClassMethod Audit(IngrId, Params, NightFlag = "") As RtnObj
{
	n (IngrId,Params,NightFlag,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","入参解析失败!")
	i ((IngrId="")||('$d(^DHCINGR(IngrId)))) q RtnObj.Err(-2,"","入库单不存在!","",0)
	s complete=$p(^DHCINGR(IngrId),"^",12)
	i complete'="Y" q RtnObj.Err(-5,"","入库单尚未完成,不能审核!","",0)
	s AuditFlag=$p(^DHCINGR(IngrId),"^",29)
	i AuditFlag="Y" q RtnObj.Err(-6,"","入库单已审核!","",0)
	
	s Usr=PJObj.%Get("gUserId")
	s LocId=$p(^DHCINGR(IngrId),"^",13)
	s ReqLoc=$p(^DHCINGR(IngrId),"^",25)
	s SourceOfFund=$p(^DHCINGR(IngrId),"^",36)
	s GroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s HospId=""
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Param=GroupId_"^"_LocId_"^"_Usr_"^"_HospId
	s AppName=..%GetParameter("AppName")
	
	s AutoAckOut=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName"),"AutoAckOutAfterCompleted",Param)
	s AutoTransAfterAudit=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoTransAfterAudit",Param)
	s ItmTrack=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName"),"UseItmTrack",Param)
	s OeoriRecFlag=..GetOeriRecFlag(IngrId)
	s IfAutoAuditRecInit=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.HVMatOrdItm).%GetParameter("AppName"),"IfAutoAuditRecInit",Param)  ;是否自动审核补录入库单
	
	;夜间任务不判断高值条码数量
	s CheckInfo=""
	i ((ItmTrack="Y")&&(NightFlag'="Y")&&(OeoriRecFlag'="Y")) d
	.s CheckInfo=##class(web.DHCSTMHUI.DHCItmTrack).CheckLabelsByPointer("G",IngrId)
	i CheckInfo'="" q RtnObj.Err(-3,"","条码信息录入有误!")
	
	s ret=0
	s ret=..sssLock(AppName_IngrId)
	i ret'=0 q RtnObj.Err(-4,"","加锁失败!")
	
	s AspFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"AllowAspWhileReceive")
	s:AspFlag="Y" RtnObj=..CheckAllowAsp(IngrId)
	i RtnObj.success'=0 d ..sssUnLock(AppName_IngrId) q RtnObj
	
	//检查价格模式2，进价是否与调价表一致
	s RtnObj=..CheckAspRp(IngrId,Param)
	i RtnObj.success'=0 d ..sssUnLock(AppName_IngrId) q RtnObj

	s CH=0
	s Err=0
	ts
	f  s CH=$o(^DHCINGR(IngrId,"GRI",CH)) q:(CH="")||(RtnObj.success<0)  d
	.s INCLB=$p(^DHCINGR(IngrId,"GRI",CH),"^",1)
	.i INCLB'="" d RtnObj.Err(-8,"","明细已经审核!")
	.s DHCINGRI=IngrId_"||"_CH
	. ;处理库存及台帐相关
	.s RtnObj=..HandleStock(DHCINGRI,Usr,GroupId_"^"_LocId)
	i RtnObj.success'=0 trollback  d ..sssUnLock(AppName_IngrId) q RtnObj
	
	s ret=..UpdateDHCINGdRec(IngrId,Usr)
	d ..sssUnLock("LOCKREC"_IngrId)
	i ret'=0 tro  q RtnObj.Err(-9,"","更新入库主表失败!")
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(IngrId,"IMA",Usr,"G")
	
	//自动出库,手工审核补录高值入库单
	s Init=""
	i ((OeoriRecFlag="Y")&&(IfAutoAuditRecInit'="Y")) d
	.s RtnObj=..SplitIngrIntoInit(IngrId,Usr,gHospId)
	e  d
	.i (NightFlag'="Y")&&(AutoTransAfterAudit="Y") d   ;主表未记录接收科室 则根据明细中记录的接收科室操作
	..s RtnObj=..CreateTransferByIngr(IngrId,ReqLoc,gHospId)
	..s Init=RtnObj.rowid
	i RtnObj.success'=0 tro  q RtnObj.Err(-10,"","生成出库单失败!")
	s AutoAckOut=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName"),"AutoAckOutAfterCompleted",Params)
	i (AutoAckOut="Y")&&(NightFlag'="Y")&&(AutoTransAfterAudit="Y")&&(Init'="")  d
	.f i=1:1:$l(Init,"^")  q:RtnObj.success'=0  d
	..s tmpInit=$p(Init,"^",i)
	..s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(tmpInit,Usr)
	..i RtnObj.success'=0 d RtnObj.Err(-11,tmpInit,"自动出库审核失败") q
	
	s RtnObj=..UpdateInvInfo(IngrId,"G")
	i RtnObj.success'=0 tro  q RtnObj.Err(-9,"","创建发票信息失败")
	
	s InsertSpecListAfterAudit=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"InsertSpecListAfterAudit",Param)
	i InsertSpecListAfterAudit="Y" d
	.s SpecRet=..InsertSpeclistByRecId(IngrId)
	.i SpecRet'=0 d RtnObj.Err(-12,"","更新具体规格到物资信息中失败!")
	i RtnObj.success'=0 tro  q RtnObj
	s RtnObj=##class(web.DHCSTMHUI.PurchaseInfo).SaveRecQty("G",IngrId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-9,"","更新带量已采购量失败")
	tc
	q RtnObj
}

/// Creator: lihui
/// CreatDate: 20180802
/// Description: 入库更新具体规格到规格列表
/// InPut：库存项id,具体规格描述
/// Table: DHCItmSpecList
/// OutPut:
/// Return: 0成功;非0 不成功;
/// w ##class(web.DHCSTMHUI.DHCINGdRec).InsertSpeclistByRecId(948)
ClassMethod InsertSpeclistByRecId(RecId) As %Library.String
{
	n (RecId)
	s Ret=0
	q:RecId="" Ret
	s Ch=0
	
	f  s Ch=$o(^DHCINGR(RecId,"GRI",Ch)) q:(Ch="")||(Ret'=0)  d
	.q:+Ch=0
	.s IngriData=^DHCINGR(RecId,"GRI",Ch)
	.s Inci=$p(IngriData,"^",25)
	.s Specdesc=$p(IngriData,"^",58)
	.q:Specdesc=""
	.q:+Inci=0
	.s SPECRowId=""
	.&sql(SELECT SPEC_RowId INTO :SPECRowId FROM DHC_ItmSpecList WHERE SPEC_INCI_DR=:Inci AND SPEC_Desc=:Specdesc)
	.i SPECRowId=""  d
	..s RtnObj=##class(RtnObj).%New()
	..s Data=""_"^"_Specdesc
	..s Title="RowId^Spec"
	..s ListData="["_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)_"]"
	..s RtnObj=##class(web.DHCSTMHUI.INCALIAS).SaveSpec(Inci,ListData)
	..i RtnObj.success'=0 d
	...s Ret=-1
	q Ret
}

/// Creator:zhangdongmei
/// CreatDate:2012-09-20
/// Description:处理入库时自动调价
/// Input:入库子表id
/// Table:
/// OutPut:
/// Return:0:成功;
/// -1  ;售价与当前价不一致，但是不允许自动调价
/// -2   ;保存调价记录失败
/// -4  ;审核调价记录失败
ClassMethod HandleAsp(ingri, UserId) As RtnObj
{
	n (ingri,UserId)
	s RtnObj=##class(RtnObj).%New()
	i (ingri="") q RtnObj
	
	s DhcIngr=+ingri
	s CH=$p(ingri,"||",2)
	s Sp=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",32)
	s Rp=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",30)
	s Uom=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",10)
	s LocId=$p(^DHCINGR(DhcIngr),"^",13)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Inci=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",25) 
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s CurSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,Uom,HospId)
	i (Sp=CurSp) q RtnObj
	s BatSpFlag=..sssBatSpFlag(HospId,Inci)
	s AspFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"AllowAspWhileReceive")
	s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci) //非收费材料可以调整售价
	s:(AspFlag="N")&&(ChargeFlag="Y")&&(BatSpFlag'=1) $p(^DHCINGR(DhcIngr,"GRI",CH),"^",32)=CurSp	;售价与当前售价不一致,但是不允许自动调价,修改入库单售价为当前售价
	i (AspFlag="N") q RtnObj
	
	s GrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s GrpId=$p(GrpInfo,"^",5)
	s MainData=GrpId_"^"_LocId_"^"_HospId
	s MainTitle="ScgId^gLocId^gHospId"
	s MainObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	s PreExeDate=$zd(+$h+1,3)   ;第二天生效
	s AdjSPCat="自动调价"
	s ListData=PreExeDate_"^"_Inci_"^"_Uom_"^"_Sp_"^"_Rp_"^"_UserId_"^"_HospId_"^"_AdjSPCat
	s ListTitle="PreExecuteDate^Inci^AspUomId^ResultSpUom^ResultRpUom^gUserId^gHospId^AdjSPCat"
	s ListDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(ListData,ListTitle)
	s ListDataObj="["_ListDataObj_"]"
	
	s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Update(MainObj,ListDataObj)
	i RtnObj.success'=0 q RtnObj
	s AspId=RtnObj.rowid
	i (AspId="") q RtnObj.Err(-1,"",InciDesc_"保存调价记录失败")
	s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Audit(AspId,UserId)
	i RtnObj.success'=0 q RtnObj
	
	q RtnObj
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:处理inc_itmloc,inc_itmlcbt,
/// dhc_locdailytotal,dhc_locbtdailytotal库存记录
/// Input:入库子表（DHC_InGdRecItm）rowid 
/// Table:inc_itmloc,inc_itmlcbt,dhc_locdailytotal,
/// dhc_locbtdailytotal
/// OutPut:
/// Return:0,成功；
ClassMethod HandleStock(Dhcingri, auditUser, param) As RtnObj
{
	n (Dhcingri,auditUser,param)
	s RtnObj=##class(RtnObj).%New()
	s GroupId=$p(param,"^",1)
	s LocId=$p(param,"^",2)
	s Dhcingr=+Dhcingri
	s Ch=$p(Dhcingri,"||",2)
	
	s IngrData=^DHCINGR(Dhcingr)
	s IngrNo=$p(IngrData,"^",1)
	s Vendor=$p(IngrData,"^",3)
	s GiftFlag=$p(IngrData,"^",31)
	s AdjCheque=$p(IngrData,"^",32)
	s SourceOfFund=$p(IngrData,"^",36)
	
	s IngrItmData=^DHCINGR(Dhcingr,"GRI",Ch)
	s Loc=$p(IngrItmData,"^",3)
	s Qty=$p(IngrItmData,"^",4)
	s ExpDate=$p(IngrItmData,"^",9)
	s Uom=$p(IngrItmData,"^",10)
	s BatchNo=$p(IngrItmData,"^",13)
	s Inci=$p(IngrItmData,"^",25)
	s ManfId=$p(IngrItmData,"^",29)
	s RealPrice=$p(IngrItmData,"^",30)
	s RpAmt=$P(IngrItmData,"^",31)
	s Sp=$P(IngrItmData,"^",32)
	s ProduceDate=$P(IngrItmData,"^",49)
	s SpAmt=$P(IngrItmData,"^",50)
	s SterilizedBat=$P(IngrItmData,"^",53)
	s SpecList=$P(IngrItmData,"^",58)
	s Tax=$P(IngrItmData,"^",69)
	s CertNo=$P(IngrItmData,"^",42)
	
	s ingriadd="",DetailId=""
	s ingriadd=$o(^DHCINGRINFO(0,"INGRI",Dhcingri,0))
	i ingriadd'="" d
	.s DetailId=$P(^DHCINGRINFO(ingriadd),"^",13)  ;第三方批次
	i ((Inci="")||(Loc="")||('$d(^INCI(Inci,1)))) q RtnObj.Err(-1,"","库存项不存在!")
	
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s Buom=$p(^INCI(Inci,1),"^",10)
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,Buom)
	s BQty=Qty*Fac 
	;生成批次信息
	s HospId=""
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Param=GroupId_"^"_LocId_"^"_auditUser_"^"_HospId
	s AppName=..%GetParameter("AppName")
	s NewSpAsSp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"NewSpAsSp",Param)
	;获取高值条码做完批次生成的依据,非批次码管理的条码返回为空,低值取值为空20200812
	s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsForRec("G",Dhcingri)
	
	s IncibParamObj={}
	d IncibParamObj.%Set("Inci",Inci).%Set("BatchNo",BatchNo).%Set("ExpDate",ExpDate).%Set("Rp",RealPrice).%Set("Sp",Sp)
	d IncibParamObj.%Set("UomId",Uom).%Set("ManfId",ManfId).%Set("VendorId",Vendor).%Set("SourceOfFund",SourceOfFund).%Set("SpecDesc",SpecList)
	d IncibParamObj.%Set("GiftFlag",GiftFlag).%Set("AdjCheque",AdjCheque).%Set("SterilizedBat",SterilizedBat).%Set("DetailId",DetailId).%Set("Tax",Tax)
	d IncibParamObj.%Set("ProduceDate",ProduceDate).%Set("HVBarCode",HVBarCode)
	d IncibParamObj.%Set("CertNo",CertNo)
	s NewIncibFlag=$s(NewSpAsSp="Y":"Y",1:"N")
	s RtnObj=..GetIncib(IncibParamObj,NewIncibFlag,Dhcingri)
	i RtnObj.success'=0 q RtnObj
	s Incib=RtnObj.rowid
	
	;改为上方的GetIncib,此处的GetBatNo/InsertDhcItmBat停用
	;s Incib=..GetBatNo(Inci,BatchNo,Expdate,RealPrice,Uom,ManfId,Vendor,SourceOfFund,SpecList,GiftFlag,AdjCheque,NewSpAsSp,SterilizedBat,DetailId,Tax,ProduceDate,HVBarCode,Sp)
	;i (Incib="") q RtnObj.Err(-2,"",InciDesc_"生成批次信息失败!")
	;s Ret=..InsertDhcItmBat(Incib,Dhcingri)
	;i (Ret'=0) q RtnObj.Err(-3,"",InciDesc_"保存批次附加信息失败!")
	
	s RtnObj=..HandleAspBatch(Dhcingri,auditUser,param,Incib)
	i (RtnObj.success'=0) q RtnObj
	;s RtnObj=..HandleAsp(Dhcingri,auditUser)
	;i (RtnObj.success'=0) q RtnObj
	;处理库存记录
	s Inclb=""
	s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStockForImp(Inci,Loc,Incib,BQty)
	i (RtnObj.rowid>0)  d
	.s Inclb=RtnObj.rowid
	i (RtnObj.success'=0) q RtnObj
	;处理高值跟踪表,保存批次信息
	s HVBarcode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",Dhcingri)
	i HVBarcode'="" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).MaintainBatNo("G",Dhcingri,Inclb)
	i (RtnObj.success'=0) q RtnObj
	;处理台帐记录
	s ListData="G"_"^"_IngrNo_"^"_Inclb_"^"_Qty_"^"_Uom_"^"_Sp_"^"_auditUser_"^"_Dhcingri_"^"_RealPrice_"^"_RpAmt_"^"_SpAmt
	s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(ListData)
	i (RtnObj.success'=0) q RtnObj
	;更新入库明细批次信息
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecItm).UpdateDhcRecItm(Dhcingri,Inclb)
	i (RtnObj.success'=0) q RtnObj
	;更新注册证信息 zhwh 2016-07-07
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecItm).HandleRecItmCertInfo(Dhcingri,param)
	i (RtnObj.success'=0) q RtnObj
	
	q RtnObj
}

/// Description:获取Incib(如不存在,则插入新值)
/// Input:		IncibObj(json对象型入参), NewIncibFlag(为Y时,直接生成新批次), Ingri(入库子表rowid)
/// d IncibParamObj.%Set("Inci",Inci).%Set("BatchNo",BatchNo).%Set("Expdate",Expdate).%Set("Rp",RealPrice).%Set("Sp",Sp)
/// d IncibParamObj.%Set("UomId",Uom).%Set("ManfId",ManfId).%Set("VendorId",Vendor).%Set("SourceOfFund",SourceOfFund).%Set("SpecDesc",SpecList)
/// d IncibParamObj.%Set("GiftFlag",GiftFlag).%Set("AdjCheque",AdjCheque).%Set("SterilizedBat",SterilizedBat).%Set("DetailId",DetailId).%Set("Tax",Tax)
/// d IncibParamObj.%Set("ProduceDate",ProduceDate).%Set("HVBarCode",HVBarCode)
ClassMethod GetIncib(IncibObj, NewIncibFlag, Ingri = "") As RtnObj
{
	n (IncibObj,NewIncibFlag,Ingri)
	s RtnObj=##class(RtnObj).%New()
	s Inci=IncibObj.Inci,BatchNo=IncibObj.BatchNo,ExpDate=IncibObj.ExpDate,Rp=IncibObj.Rp,Sp=IncibObj.Sp
	s UomId=IncibObj.UomId,ManfId=IncibObj.ManfId,VendorId=IncibObj.VendorId,SourceOfFund=IncibObj.SourceOfFund,SpecDesc=IncibObj.SpecDesc
	s GiftFlag=IncibObj.GiftFlag,AdjCheque=IncibObj.AdjCheque,SterilizedBat=IncibObj.SterilizedBat,DetailId=IncibObj.DetailId,Tax=IncibObj.Tax
	s ProduceDate=IncibObj.ProduceDate,HVBarCode=IncibObj.HVBarCode,CertNo=IncibObj.CertNo
	
	q:(Inci="")||(Rp="")||(UomId="") RtnObj.Err(-1,"","批次生成失败")
	s:GiftFlag="" GiftFlag="N"
	s:AdjCheque="" AdjCheque="N"
	
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s BuomDr=$p(^INCI(Inci,1),"^",10)
	s PuruomDr=$p(^INCI(Inci,3),"^",6)
	s PFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuruomDr,BuomDr)
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BuomDr)
	i UomId=BuomDr d
	.s BRp=Rp
	.s PurRp=Rp*PFac
	.s BSp=Sp
	.s PurSp=Sp*PFac
	e  d
	.s BRp=Rp/Fac
	.s PurRp=BRp*PFac
	.s BSp=Sp/Fac
	.s PurSp=BSp*PFac
	.s Tax=Tax/Fac
	
	
	;0.若DetailId有值,优先获取此Incib
	s IncibByDetailId=""
	i DetailId'="" d
	.s DHCIncibId=$o(^DHCINCIB(0,"DetailId",DetailId,0))
	.q:DHCIncibId=""
	.s IncibByDetailId=$p(^DHCINCIB(DHCIncibId),"^",1)
	.q:IncibByDetailId=""
	.
	.s TmpInci=$p(IncibByDetailId,"||",1),TmpIB=$p(IncibByDetailId,"||",2)
	.s TmpBatchNo=$p(^INCI(TmpInci,"IB",TmpIB),"^",1)
	.s TmpRp=$P(^DHCINCIB(DHCIncibId),"^",3)
	.s TmpVendorId=$p(^DHCINCIB(DHCIncibId),"^",8)
	.
	.;按DetailId取值时,如需对比更多信息,在此补充
	.s CheckMsg=""
	.i TmpInci'=Inci s CheckMsg=CheckMsg_"库存项Code不符 "
	.i TmpBatchNo'=BatchNo s CheckMsg=CheckMsg_"批号不符 "
	.i TmpVendorId'=VendorId s CheckMsg=CheckMsg_"供应商不符 "
	.i +TmpRp'=+BRp s CheckMsg=CheckMsg_"单价不符 "
	.i CheckMsg'="" d RtnObj.Err(-1,"",InciCode_" "_InciDesc_":生成批次信息失败,DetailId:"_DetailId_CheckMsg) q
	q:RtnObj.success<0 RtnObj
	i (IncibByDetailId'="") s RtnObj.rowid=IncibByDetailId q RtnObj
	
	;1.检查是否有对应的Incib存在
	s Incib=""
	i (NewIncibFlag'="Y") {
		i ((BatchNo="")||(ExpDate="")) {
			&sql(declare SeekIncibCursor cursor for
				select incib_rowid From inc_itmbat 
				where incib_inci_parref=:Inci and nvl(incib_no,'')=nvl(:BatchNo,'') and nvl(incib_expdate,'')=nvl(:ExpDate,'')
			)
			&sql(open SeekIncibCursor)
			s ret=""
			f  &sql(fetch SeekIncibCursor into :RowId) q:SQLCODE  d
			.q:RowId=""
			.s IncibArray(RowId)=""
			&sql(close SeekIncibCursor)
		}else{
			s IB=0
			f  s IB=$o(^INCI("IB_NoX",ExpDate,BatchNo,Inci,IB)) q:IB=""  d
			.s RowId=Inci_"||"_IB
			.s IncibArray(RowId)=""
		}
		
		s RowId=""
		f  s RowId=$o(IncibArray(RowId)) q:(RowId="")||(Incib'="")  d
		.s DHCIncib=$o(^DHCINCIB(0,"INCIB",RowId,0))
		.q:(DHCIncib="")||'$d(^DHCINCIB(DHCIncib))
		.s DHCIncibData=^DHCINCIB(DHCIncib)
		.s LBProduceDate=$p(DHCIncibData,"^",2)		;生产日期
		.s LBRp=$p(DHCIncibData,"^",3)				;基本单位进价
		.s LBSp=$p(DHCIncibData,"^",5)
		.s LBManfId=$p(DHCIncibData,"^",7)
		.s LBVendorId=$p(DHCIncibData,"^",8)
		.s LBSourceFund=$p(DHCIncibData,"^",12)
		.s LBSpecDesc=$p(DHCIncibData,"^",13)
		.s LBGiftFlag=$p(DHCIncibData,"^",15)
		.s LBAdjCheque=$p(DHCIncibData,"^",16)
		.s LBBarCode=$p(DHCIncibData,"^",17)		;批次码
		.s LBSterilizedBat=$p(DHCIncibData,"^",19)
		.s LBDetailId=$p(DHCIncibData,"^",20)		;第三方批次
		.s LBTax=$p(DHCIncibData,"^",21)			;税率
		.s LBCertNo=$p(DHCIncibData,"^",34)			;注册证号
		.
		.s:LBGiftFlag="" LBGiftFlag="N"
		.s:LBAdjCheque="" LBAdjCheque="N"
		.
		.q:(LBRp'=BRp)
		.q:(LBSp'=BSp)
		.q:(LBManfId'=ManfId)
		.q:(LBVendorId'=VendorId)
		.q:(LBSourceFund'=SourceOfFund)
		.q:(LBSpecDesc'=SpecDesc)
		.q:(LBGiftFlag'=GiftFlag)
		.q:(LBAdjCheque'=AdjCheque)
		.q:(LBSterilizedBat'=SterilizedBat)
		.q:(LBDetailId'=DetailId)
		.q:(+LBTax'=+Tax)
		.q:(LBProduceDate'=ProduceDate)
		.q:(LBBarCode'=HVBarCode)
		.q:(LBCertNo'=CertNo)
		.
		.s Incib=RowId
	}
	i Incib'="" s RtnObj.rowid=Incib q RtnObj
	
	;2.Incib不存在的,新建数据
	&sql(insert into inc_itmbat(INCIB_INCI_ParRef,INCIB_No,INCIB_ExpDate) values (:Inci,:BatchNo,:ExpDate))
	i SQLCODE'=0 q RtnObj.Err(-2,"","批次生成失败:"_SQLCODE)
	s Incib=%ROWID
	
	s Date=+$h
	s Time=$p($h,",",2)
	;附加表
	&sql(insert into dhc_incitmbat
		(INCIB_INCIB_Dr,INCIB_ProduceDate,INCIB_Rp,INCIB_RpPuruom,INCIB_Sp,
		INCIB_SpPuruom,INCIB_PHMNF_Dr,INCIB_APCVM_Dr,INCIB_INGRI_Dr,INCIB_DateAdd,INCIB_TimeAdd,
		INCIB_SourceOfFund,INCIB_SpecList,INCIB_GiftFlag,INCIB_AdjCheque,INCIB_SterilizedBat,
		INCIB_DetailId,INCIB_Tax,INCIB_BarCode,INCIB_CertNo) 
		values
		(:Incib,:ProduceDate,:BRp,:PurRp,:BSp,
		:PurSp,:ManfId,:VendorId,:Ingri,:Date,:Time,
		:SourceOfFund,:SpecDesc,:GiftFlag,:AdjCheque,:SterilizedBat,
		:DetailId,:Tax,:HVBarCode,:CertNo)
	)
	i SQLCODE'=0 q RtnObj.Err(-3,"","dhc_incitmbat记录失败:"_SQLCODE)
	
	s RtnObj.rowid=Incib
	q RtnObj
}

/// 2021-09-28 新增了GetIncib方法, 该GetBatNo方法逐渐弃用
/// Creator:zdm
/// CreatDate:2012-07-04
/// Description:生成批次信息
/// Input:库存项rowid，批号，效期，进价，单位,生产厂家ID,供应商,资金来源,具体规格,捐赠标记,调价换票标记
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid
/// wangjiabin 2014-06-09 添加apcvm参数,供应商作为区分incib的一个因素
ClassMethod GetBatNo(inci, bat, exp, rp, uom, mnf, apcvm, sourceoffund, SpecList, giftFlag, adjCheque, NewSpAsSp, SterilizedBat, DetailId, Tax, ProduceDate, HVBarCode, Sp) As %Library.String
{
	n (inci,bat,exp,rp,uom,mnf,apcvm,sourceoffund,SpecList,giftFlag,adjCheque,NewSpAsSp,SterilizedBat,DetailId,Tax,ProduceDate,HVBarCode,Sp)
	q:inci="" ""
	q:rp="" ""
	q:uom="" ""
	s incib=""
	i NewSpAsSp'="Y"  d
	.i (bat="")!(exp="")  d
	..s incib=..CheckNullIncibExist(inci,bat,exp,rp,uom,mnf,apcvm,sourceoffund,SpecList,giftFlag,adjCheque,SterilizedBat,DetailId,Tax,ProduceDate,HVBarCode,Sp)
	.e  d
	..s incib=..CheckIncibExist(inci,bat,exp,rp,uom,mnf,apcvm,sourceoffund,SpecList,giftFlag,adjCheque,SterilizedBat,DetailId,Tax,ProduceDate,HVBarCode,Sp)
	q:incib'="" incib
	
	&sql(insert into inc_itmbat(INCIB_INCI_ParRef,INCIB_No,INCIB_ExpDate) values (:inci,:bat,:exp))
	i SQLCODE'=0  q ""
	
	s incib=$p($g(%ROWID),$c(1))
	q incib
}

/// Creator:zhwh
/// CreatDate:2011-08-04
/// Description:检查inc_itmbat中是否存在空批号、空效期、进价相同的记录
/// Input:库存项rowid，批号，效期，进价，单位,生产厂家,供应商,资金来源,具体规格,捐赠标记,调价换票标记
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid(存在);""(不存在)
ClassMethod CheckNullIncibExist(inci, batno, expdate, rp, uom, mnf, apcvm, sourceoffund, SpecList, giftFlag, adjCheque, SterilizedBat, DetailId, Tax, ProduceDate, HVBarCode, Sp) As %String
{
	n (inci,batno,expdate,rp,uom,mnf,apcvm,sourceoffund,SpecList,giftFlag,adjCheque,SterilizedBat,DetailId,Tax,ProduceDate,HVBarCode,Sp)
	q:inci="" ""
	s:giftFlag="" giftFlag="N"
	s:adjCheque="" adjCheque="N"

	s BUomId=$p(^INCI(inci,1),"^",10)
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,BUomId)
	s rp=rp/Fac
	s Tax=Tax/Fac
	s Sp=Sp/Fac

	s incib=""
	&sql(declare seekBat cursor for  select incib_rowid  From inc_itmbat 
		where incib_inci_parref=:inci and nvl(incib_no,'')=nvl(:batno,'')
		and nvl(incib_expdate,'')=nvl(:expdate,''))
	&sql(open seekBat)
	s ret=""
	f  &sql(fetch seekBat into :incib)  q:SQLCODE!(ret'="")  d
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	.q:dhcincib=""
	.s tmprp=$P(^DHCINCIB(dhcincib),"^",3)
	.s tmpsp=$P(^DHCINCIB(dhcincib),"^",5)
	.//生产厂家
	.s tmpmnf=$p(^DHCINCIB(dhcincib),"^",7)
	.s tmpVendor=$p(^DHCINCIB(dhcincib),"^",8)
	.s tmpsourceoffund=$p(^DHCINCIB(dhcincib),"^",12)
	.s tmpSpecList=$p(^DHCINCIB(dhcincib),"^",13)
	.s tmpGiftFlag=$p(^DHCINCIB(dhcincib),"^",15)
	.s:tmpGiftFlag="" tmpGiftFlag="N"
	.s tmpAdjCheque=$p(^DHCINCIB(dhcincib),"^",16)
	.s:tmpAdjCheque="" tmpAdjCheque="N"
	.s tmpSterilizedBat=$p(^DHCINCIB(dhcincib),"^",19)
	.s tmpDetailId=$p(^DHCINCIB(dhcincib),"^",20) ;第三方批次
	.s tmpTax=$p(^DHCINCIB(dhcincib),"^",21) ;税额
	.s tmpProduceDate=$p(^DHCINCIB(dhcincib),"^",2) ;生产日期
	.s tmpbarcode=$p(^DHCINCIB(dhcincib),"^",17)  ;批次条码
	.q:(tmprp'=rp)
	.q:(tmpsp'=Sp)
	.q:(tmpmnf'=mnf)
	.q:(tmpVendor'=apcvm)
	.q:(tmpsourceoffund'=sourceoffund)
	.q:(tmpSpecList'=SpecList)
	.q:(tmpGiftFlag'=giftFlag)
	.q:(tmpAdjCheque'=adjCheque)
	.q:(tmpSterilizedBat'=SterilizedBat)
	.q:(tmpDetailId'=DetailId)
	.q:(+tmpTax'=+Tax)
	.q:(tmpProduceDate'=ProduceDate)
	.q:(tmpbarcode'=HVBarCode)
	.
	.s ret=incib
	&sql(close seekBat)
	q ret
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:检查inc_itmbat中是否存在批号、效期、进价相同的记录
/// Input:库存项rowid，批号，效期，进价，单位,生产厂家id,供应商,资金来源,具体规格,捐赠标记,调价换票标记
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid(存在);""(不存在)
ClassMethod CheckIncibExist(inci, batno, expdate, rp, uom, mnf, apcvm, sourceoffund, SpecList, giftFlag, adjCheque, SterilizedBat, DetailId, Tax, ProduceDate, HVBarCode, Sp) As %Library.String
{
	n (inci,batno,expdate,rp,uom,mnf,apcvm,sourceoffund,SpecList,giftFlag,adjCheque,SterilizedBat,DetailId,Tax,ProduceDate,HVBarCode,Sp)
	q:inci="" ""
	q:batno="" ""
	q:expdate="" ""
	s:giftFlag="" giftFlag="N"
	s:adjCheque="" adjCheque="N"
	s BUomId=$p(^INCI(inci,1),"^",10)
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,BUomId)
	s rp=rp/Fac
	s Tax=Tax/Fac
	s Sp=Sp/Fac

	s ret=""
	s sub=0
	f  s sub=$o(^INCI("IB_NoX",expdate,batno,inci,sub))  q:(sub="")!(ret'="")  d
	.s incib=inci_"||"_sub
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	.q:dhcincib=""
	.s tmprp=$p(^DHCINCIB(dhcincib),"^",3)		;基本单位对应的进价
	.s tmpsp=$p(^DHCINCIB(dhcincib),"^",5)
	.s tmpmnf=$p(^DHCINCIB(dhcincib),"^",7)
	.s tmpVendor=$p(^DHCINCIB(dhcincib),"^",8)
	.s tmpsourceoffund=$p(^DHCINCIB(dhcincib),"^",12)
	.s tmpSpecList=$p(^DHCINCIB(dhcincib),"^",13)
	.s tmpGiftFlag=$p(^DHCINCIB(dhcincib),"^",15)
	.s:tmpGiftFlag="" tmpGiftFlag="N"
	.s tmpAdjCheque=$p(^DHCINCIB(dhcincib),"^",16)
	.s:tmpAdjCheque="" tmpAdjCheque="N"
	.s tmpSterilizedBat=$p(^DHCINCIB(dhcincib),"^",19)
	.s tmpDetailId=$p(^DHCINCIB(dhcincib),"^",20) ;第三方批次
	.s tmpTax=$p(^DHCINCIB(dhcincib),"^",21) ;税额
	.s tmpProduceDate=$p(^DHCINCIB(dhcincib),"^",2) ;生产日期
	.s tmpbarcode=$p(^DHCINCIB(dhcincib),"^",17) ;批次码
	.
	.q:(tmprp'=rp)
	.q:(tmpsp'=Sp)
	.q:(tmpmnf'=mnf)
	.q:(tmpVendor'=apcvm)
	.q:(tmpsourceoffund'=sourceoffund)
	.q:(tmpSpecList'=SpecList)
	.q:(tmpGiftFlag'=giftFlag)
	.q:(tmpAdjCheque'=adjCheque)
	.q:(tmpSterilizedBat'=SterilizedBat)
	.q:(tmpDetailId'=DetailId)
	.q:(+tmpTax'=+Tax)
	.q:(tmpProduceDate'=ProduceDate)
	.q:(tmpbarcode'=HVBarCode)
	.
	.s ret=incib
	
	q ret
}

/// Creator:zdm
/// CreatDate:2009-09-08
/// Description:插入dhc_incitmbat
/// Input:inc_itmbat表rowid,入库子表id
/// Table:dhc_incitmbat
/// OutPut:
/// Return:0,成功；其它，失败
ClassMethod InsertDhcItmBat(Incib As %String, Dhcingri As %String) As %Library.String
{
	n (Incib,Dhcingri)
	q:Incib="" -1
	s Ch=$p(Dhcingri,"||",2)
	s Dhcingr=+Dhcingri
	q:Dhcingr=0 -1
	q:Ch="" -1
	s DhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	q:DhcIncib'="" 0
	
	s BuomDr=$p(^INCI(+Incib,1),"^",10)
	s PuruomDr=$p(^INCI(+Incib,3),"^",6)
	s PFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuruomDr,BuomDr)
	s Uom=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",10)
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BuomDr)
	s ProduceDate=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",49)
	s Mnf=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",29)
	s Rp=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",30)
	s Sp=$P(^DHCINGR(Dhcingr,"GRI",Ch),"^",32)
	s SpecList=$P(^DHCINGR(Dhcingr,"GRI",Ch),"^",58)
	s Vendor=$p(^DHCINGR(Dhcingr),"^",3)
	s GiftFlag=$p(^DHCINGR(Dhcingr),"^",31)
	s AdjCheque=$p(^DHCINGR(Dhcingr),"^",32)
	s SourceOfFund=$p(^DHCINGR(Dhcingr),"^",36)
	s SterilizedBat=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",53)
	s ingriadd="",DetailId=""
	s ingriadd=$o(^DHCINGRINFO(0,"INGRI",Dhcingri,0))
	i ingriadd'="" d
	.s DetailId=$P(^DHCINGRINFO(ingriadd),"^",13)  ;第三方批次
	s Tax=$P(^DHCINGR(Dhcingr,"GRI",Ch),"^",69)  ;单品税额
	s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsForRec("G",Dhcingri)

	i Uom=BuomDr  d
	.s BRp=Rp
	.s PurRp=Rp*PFac
	.s BSp=Sp
	.s PurSp=Sp*PFac
	e  d
	.s BRp=Rp/Fac
	.s PurRp=BRp*PFac
	.s BSp=Sp/Fac
	.s PurSp=BSp*PFac
	.s Tax=Tax/Fac
	s Date=+$h
	s Time=$p($h,",",2)
	
	&sql(insert into dhc_incitmbat(INCIB_INCIB_Dr,INCIB_ProduceDate,INCIB_Rp,INCIB_RpPuruom,INCIB_Sp,
		INCIB_SpPuruom,INCIB_PHMNF_Dr,INCIB_APCVM_Dr,INCIB_INGRI_Dr,INCIB_DateAdd,INCIB_TimeAdd,
		INCIB_SourceOfFund,INCIB_SpecList,INCIB_GiftFlag,INCIB_AdjCheque,INCIB_SterilizedBat,
		INCIB_DetailId,INCIB_Tax,INCIB_BarCode) 
		values (:Incib,:ProduceDate,:BRp,:PurRp,:BSp,:PurSp,:Mnf,:Vendor,:Dhcingri,:Date,:Time,:SourceOfFund,:SpecList,:GiftFlag,:AdjCheque,:SterilizedBat,:DetailId,:Tax,:HVBarCode))
	i SQLCODE'=0  q -11
	
	q 0
}

/// Creator:zdm
/// CreatDate:2009-06-02
/// Description:更新入库主表的审核相关字段
/// Table:DHC_InGdrec
/// Input:入库主表rowid
/// Return：0，成功；其它,不成功
ClassMethod UpdateDHCINGdRec(dhcingr, user) As %Library.String
{
	n (dhcingr,user)
	q:dhcingr="" -1
	s dd=+$h
	s tt=$p($h,",",2)
	s AuditFlag="Y"
	s invtotalamt=""
	&sql(select sum(initm_invmoney) into :invtotalamt from dhc_ingdrecitm where ingri_ingr_parref=:dhcingr)
	&sql(update dhc_ingdrec  set ingr_Date=:dd,ingr_time=:tt,ingr_ssusr_dr=:user,ingr_backup1=:invtotalamt,INGR_AuditFlag=:AuditFlag where ingr_rowid=:dhcingr)
	i SQLCODE'=0  q -3
	q 0
}

/// Descript:   保存入库验收信息
/// Creator:    ZhangDongmei
/// CreateDate: 2012-07-18
/// Table:DHC_InGdRec,DHC_InGdRecItm
/// Input:入库主表id;验收人id;明细id^检测口岸^检测报告^报告日期^注册证号^注册证有效期^摘要,
/// 明细id^检测口岸^检测报告^报告日期^注册证号^注册证有效期^摘要,
/// Output:     
/// Return：成功：0；
/// -5:保存入库单验收信息失败
/// -7其它：部分明细保存不成功，提示不成功的物资
/// w ##class(web.DHCSTMHUI.DHCINGdRec).SaveAcceptInfo(^tmpzx(2),^tmpzx(3)) 
ClassMethod SaveAcceptInfo(MainInfo As %String, ListData As %String) As %Library.String
{
	n (MainInfo,ListData)
	;s ^tmpzx(2)=MainInfo
	;s ^tmpzx(3)=ListData
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	
	s IngrIdStr=PJObj.%Get("IngrIdStr")
	i IngrIdStr="" q RtnObj.Err(-2,"","入库单不存在!","",0).Json()
	s UserId=PJObj.%Get("gUserId")
	s del="^"
	s cnt=$l(IngrIdStr,del)
	ts
	f i=1:1:cnt q:RtnObj.success'=0  d
	.s IngrId=$p(IngrIdStr,del,i)
	.&sql(update DHC_INGdRec set INGR_SSUSR_Accept_DR=:UserId where INGR_RowId=:IngrId)
	.i SQLCODE'=0  s Sc=RtnObj.Err(-3,"","更新入库表失败!") 
	i RtnObj.success'=0 tro  q RtnObj.Err(-3,"","修改主表信息失败!").Json()
	
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecItm).SaveAcceptInfo(ListData)
	i RtnObj.success'=0 tro  q RtnObj.Err(-3,"","存在保存失败的明细!").Json()
	
	s RtnObj=..SaveRecItmAddionInfo(ListData,UserId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-4,"","明细附加信息保存失败!").Json()
	tc
	q RtnObj.Json()
}

/// 保存入库子表附加表信息
ClassMethod SaveRecItmAddionInfo(ListData, UserId) As RtnObj
{
	n (ListData,UserId)
	s RtnObj=##class(RtnObj).%New()
	i UserId="" q RtnObj.Err(-1,"","缺少用户信息")
	
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-2,"","明细入参解析失败!")
	
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		s RtnObj=..UpdateRecItmAddionInfo(ItmObj,UserId)
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// 插入修改入库子表附加表信息
ClassMethod UpdateRecItmAddionInfo(Detail As %String, UserId As %String) As RtnObj
{
	n (Detail,UserId)
	s RtnObj=##class(RtnObj).%New()
	s ingri=Detail.%Get("RowId")
	s AOGTemp=Detail.%Get("AOGTemp") ;到货温度
	s PackGood=Detail.%Get("PackGood") ;外包装完好
	s AcceptCon=Detail.%Get("AcceptCon") ;验收结论
	s Token=Detail.%Get("Token") ;产品标识
	s LocalToken=Detail.%Get("LocalToken") ;中文标识
	s CheckRemarks=Detail.%Get("CheckRemarks") ;验收备注
	s ProdCertif=Detail.%Get("ProdCertif") ;有合格证
	
	s ingriadd=""
	s ingriadd=$o(^DHCINGRINFO(0,"INGRI",ingri,0))
	i ingriadd="" d
	.s obj=##class(User.DHCINGdRecItmAddionInfo).%New()
	e  d
	.s obj=##class(User.DHCINGdRecItmAddionInfo).%OpenId(ingriadd)
	.d obj.%Reload()
	d obj.INGRINFODRSetObjectId(ingri)
	s obj.INGRINFOAOGTemp=AOGTemp
	s obj.INGRINFOPackGood=PackGood
	s obj.INGRINFOAcceptCon=AcceptCon
	s obj.INGRINFOCheckDate=+$h
	s obj.INGRINFOCheckTime=$p($h,",",2)
	d obj.INGRINFOCheckUserDRSetObjectId(UserId)
	s obj.INGRINFOCheckRemarks=CheckRemarks
	s obj.INGRINFOToken=Token
	s obj.INGRINFOLocalToken=LocalToken
	s obj.INGRINFOProdCertif=ProdCertif
	s sc=obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-1,"","处理入库子表附加表失败!")
	q RtnObj
}

/// create 审核时处理批次调价
/// wyx 2014-04-16
ClassMethod HandleAspBatch(Ingri, Usr, StrParam, Incib) As RtnObj
{
	n (Ingri,Usr,StrParam,Incib)
	q:Ingri="" ""
	s RtnObj=##class(RtnObj).%New()
	s gGroupId=$p(StrParam,"^",1)
	s gLocId=$p(StrParam,"^",2)
	s gUserId=Usr
	s HospId=""
	i gLocId'="" s HospId=$p(^CTLOC(gLocId),"^",22)
	
	;补录生成的入库单,且已经存在Incib批次调价信息的,不再进行调价业务
	s HVM=$o(^DHCHVMORI(0,"INGRIModify",Ingri,0))
	i (HVM'="")&&($d(^DHCSTINAPB(0,"INCIB",Incib))) q RtnObj
	
	s Ingr=+Ingri,Ch=$p(Ingri,"||",2)
	s IngriData=$g(^DHCINGR(Ingr,"GRI",Ch))
	s ExpDate=$p(IngriData,"^",9)
	s IngrUomId=$p(IngriData,"^",10)
	s BatchNo=$p(IngriData,"^",13)
	s IncId=$p(IngriData,"^",25)
	s ManfId=$p(IngriData,"^",29)
	s Rp=$p(IngriData,"^",30)
	s Sp=$p(IngriData,"^",32)
	s NewSp=$p(IngriData,"^",45)
	
	s StkGrpType=$p(^DHCINGR(Ingr),"^",28)
	s Vendor=$p(^DHCINGR(Ingr),"^",3)
	S IncDesc=$P(^INCI(IncId,1),"^",2)
	s RetStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$h,IngrUomId,HospId,"")
	s PriorSp=$p(RetStr,"^",2)
	s PriorRp=$p(RetStr,"^",1)
	i (PriorRp'=Rp)||(PriorSp'=Sp) d
	.s PriceData1=IncId_"^"_IngrUomId_"^"_Sp_"^"_Rp_"^"_gUserId_"^"_PriorRp_"^"_PriorSp_"^"_StkGrpType_"^"_gLocId_"^"_IncDesc
	.s PriceData2=BatchNo_"^"_ExpDate_"^"_ManfId_"^"_HospId_"^"_Ingri_"^"_Vendor
	.s PriceData=PriceData1_"^"_PriceData2
	.s RtnObj=..CreateAdjPriceBatch(PriceData,Incib)
	
	q RtnObj
}

/// modify wyx 2014-04-14 保存批次调价记录(入库使用)
ClassMethod CreateAdjPriceBatch(StrParam As %String, Incib As %String) As RtnObj
{
	n (StrParam,Incib)
	s RtnObj=##class(RtnObj).%New()
	i Incib="" q RtnObj.Err(-1,"","批次不存在!")
	s resultString=0
	s GrpId=$p(StrParam,"^",8)
	s LocId=$p(StrParam,"^",9)
	s AppName=##class(web.DHCSTMHUI.INAdjPriceBatch).%GetParameter("AppName")
	s AdjBatNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
	i ((AdjBatNo="")||(+AdjBatNo<0)) q RtnObj.Err(-2,"","批次调价生成单号失败!")
	
	s preexedate=$zd($h,3)
	s ItmRowid=$p(StrParam,"^",1)
	s AdjUomId=$p(StrParam,"^",2)
	s ResultSp=$p(StrParam,"^",3)
	s ResultRp=$p(StrParam,"^",4)
	s AdjUserId=$p(StrParam,"^",5)
	s PriorRp=$p(StrParam,"^",6)
	s PriorSp=$p(StrParam,"^",7)
	s Batno=$p(StrParam,"^",11)
	s ExpDate=$p(StrParam,"^",12)
	s ManfId=$p(StrParam,"^",13)
	s HospId=$p(StrParam,"^",14)
	s Ingri=$p(StrParam,"^",15)
	s vendor=$p(StrParam,"^",16)
	s AdjReasonId=""
	s AdjSPCat="自动调价"
	
	tstart
	s tmpDetailData=Incib_"^"_preexedate_"^"_ItmRowid_"^"_AdjUomId_"^"_ResultSp_"^"_ResultRp_"^"_AdjUserId_"^"_AdjReasonId_"^"_HospId_"^入库生成^"_PriorRp_"^"_PriorSp_"^"_AdjSPCat
	s tmpDetailTitle="Incib^PreExecuteDate^Inci^AspUomId^ResultSpUom^ResultRpUom^gUserId^AdjReasonId^gHospId^Remark^PriorRpUom^PriorSpUom^AdjSPCat"
	s tmpDetailDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpDetailData,tmpDetailTitle)
	s tmpDetailDataObj="["_tmpDetailDataObj_"]"
	s tmpMainData=AdjBatNo_"^"_LocId_"^"_AdjUserId_"^"_HospId
	s tmpMainTitle="AspNo^gLocId^gUserId^gHospId"
	s tmpMainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpMainData,tmpMainTitle)
	s RtnObj=##class(web.DHCSTMHUI.INAdjPriceBatch).Save(tmpMainDataObj,tmpDetailDataObj)
	i RtnObj.success'=0 trollback  q RtnObj
	s AspBatId=RtnObj.rowid
	i (AspBatId="") tro  q RtnObj.Err(-2,"",Ingri_"保存调价记录失败")
	
	s Params=AdjUserId_"^"_GrpId_"^"_LocId
	s RtnObj=##class(web.DHCSTMHUI.INAdjPriceBatch).Audit(AspBatId,Params)
	i RtnObj.success'=0 trollback  q RtnObj
	
	tcommit
	q RtnObj
}

/// 根据入库单生成库存转移单
/// Author:zhwh
/// Date:2013-05-12
/// Argu:	入库单rowid, 库存转移接收科室rowid
/// Return: 转移单rowid, 成功; 否则, 失败
ClassMethod CreateTransferByIngr(ingr As %String, reqLoc As %String, gHospId) As RtnObj
{
	n (ingr,reqLoc,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	i ((ingr="")||('$d(^DHCINGR(ingr)))) q RtnObj.Err("-1","","入库单不存在","",0)
	
	;主表未记录接收科室 则根据明细中记录的接收科室操作
	s supplyLoc=$p(^DHCINGR(ingr),"^",13)
	i (reqLoc'="")&&(reqLoc=supplyLoc) q RtnObj.Err("-1","","接收科室不允许等于入库科室","",0)
	;s userId=$p(^DHCINGR(ingr),"^",16)
	s userId=$p(^DHCINGR(ingr),"^",8)
	s scg=$p(^DHCINGR(ingr),"^",28)
	s OperDesc="正常出库",OperStkType="OM"
	s operType=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",OperDesc,"DHC_OperateType",gHospId,OperStkType)
	s operType=$g(operType)
	s status=10		;出库单状态
	s stkType=..sssCode()
	s remark="自动出库"
	
	s Pid=..NewPid()
	k ^TMPDHCSTM(Pid)
	
	s listData=""
	s ch=0
	f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:ch=""  d
	.s ingri=ingr_"||"_ch
	.s IngriData=^DHCINGR(ingr,"GRI",ch)
	.s inclb=$p(IngriData,"^",1)
	.s recQty=$p(IngriData,"^",4)
	.s uomDr=$p(IngriData,"^",10)
	.s poi=$p(IngriData,"^",17) ;订单子表
	.s Sp=$p(IngriData,"^",32)
	.s barcode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("G",ingri)
	.s (inppi,ReqItmId)=""
	.i poi'="" d
	..s inpp=$o(^INPP(0,"INPOI",poi,0))
	..i inpp'="" d
	...s inppch=$o(^INPP(0,"INPOI",poi,inpp,0))
	...s inppi=inpp_"||"_inppch
	...s ReqItmch=$o(^INPP(inpp,"PPI",inppch,"RQI",0))
	...s:ReqItmch'="" ReqItmId=$p(^INPP(inpp,"PPI",inppch,"RQI",ReqItmch),"^",1)
	.
	.s tmpData=inclb_"^"_recQty_"^"_uomDr_"^"_ReqItmId_"^"_barcode_"^"_ingri_"^"_Sp
	.s tmpTitle="Inclb^Qty^UomId^Inrqi^HVBarCode^Ingri^Sp"
	.s tmpDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpData,tmpTitle)
	.s reqLocId=""
	.s IngriAdd=$o(^DHCINGRINFO(0,"INGRI",ingri,0))
	.s:IngriAdd'="" reqLocId=$p(^DHCINGRINFO(IngriAdd),"^",5)
	.s:reqLocId="" reqLocId=reqLoc
	.q:reqLocId=""
	.q:(reqLocId'="")&&(reqLocId=supplyLoc)
	.i '$d(^TMPDHCSTM(Pid,"list",reqLocId)) d
	..s ^TMPDHCSTM(Pid,"list",reqLocId)=tmpDataObj
	..s ^TMPDHCSTM(Pid,"mainData",reqLocId)=supplyLoc_"^"_reqLocId_"^"_operType_"^N^"_status_"^"_userId_"^"_scg_"^"_remark_"^"_ingr
	.e  d
	..s ^TMPDHCSTM(Pid,"list",reqLocId)=^TMPDHCSTM(Pid,"list",reqLocId)_","_tmpDataObj
	i '$d(^TMPDHCSTM(Pid,"list")) q RtnObj.Err("0","","没有需要处理的数据")
	
	s InitStr=""
	s reqLocId=0
	f  s reqLocId=$o(^TMPDHCSTM(Pid,"list",reqLocId)) q:reqLocId=""  d
	.s mainData=^TMPDHCSTM(Pid,"mainData",reqLocId)
	.s mainTitle="InitFrLoc^InitToLoc^OperateType^InitComp^InitState^InitUser^InitScg^InitRemarks^InitIngr"
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(mainData,mainTitle)
	.s listData=^TMPDHCSTM(Pid,"list",reqLocId)
	.q:listData=""
	.s listDataObj="["_listData_"]"
	.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).Save(mainDataObj,listDataObj)
	.q:RtnObj.success'=0
	.s Init=RtnObj.rowid
	.i InitStr=""  s InitStr=Init
	.e  s InitStr=InitStr_"^"_Init
	.s State=$p(^DHCINIT(Init),"^",14)
	.i State=10 d
	..s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).SetCompleted(Init)
	
	k ^TMPDHCSTM(Pid)
	s RtnObj.rowid=InitStr
	q RtnObj
}

/// 根据rowidStr查询入库单
/// Author:	wangjiabin
/// Date:	2015-06-16
/// Argu:	入库单rowid(,隔开)
/// Return:
Query QueryIngrStr(ingrStr As %String) As Query(ROWSPEC = "IngrId,IngrNo,Vendor,RecLoc,IngrType,PurchUser,PoNo,CreateUser,CreateDate,Complete,ReqLoc,StkGrp,RpAmt:%Float,SpAmt:%Float,AuditDate,AuditUser,Margin:%Float,AcceptUser,VenId,InGrRemarks,SourceOfFund,ReqLocDesc,InvAmt:%Float")
{
}

ClassMethod QueryIngrStrExecute(ByRef qHandle As %Binary, ingrStr As %String) As %Status
{
	n (qHandle,ingrStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:ingrStr="" $$$OK
	
	s sqlStr = "select INGR_RowId as Rowid,INGR_No,INGR_APCVM_DR,INGR_APCVM_DR->APCVM_Name as Vendor,"_
		"INGR_Loc_Dr->CTLOC_Desc as RecLoc, INGR_Type->IPT_Desc as IngrType, INGR_SSUSR_Purch_DR->SSUSR_NAME AS PurchUser,"_
		"INGR_INPO_DR->INPO_No as PoNo, INGR_CreateUser->SSUSR_NAME AS CreateUser, INGR_CreateDate,"_
		"INGR_Completed,INGR_ReqLoc_Dr as ReqLoc,INGR_ReqLoc_Dr->CTLOC_Desc as ReqLocDesc, INGR_SCG_DR as StkGrpId, INGR_SCG_DR->SCG_Desc as StkGrp,INGR_AuditFlag, "_
		"INGR_Date,INGR_SSUSR_DR,INGR_SSUSR_Accept_DR,INGR_StkType stkType,INGR_Remarks InGrRemarks,INGR_SourceOfFund "_
		"from DHC_INGdRec where %id in ("_ingrStr_")"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s IngrId = result.Data("Rowid")
		s IngrNo = result.Data("INGR_No")
		s Vendor = result.Data("Vendor")
		s VenId=result.Data("INGR_APCVM_DR")
		s RecLoc = result.Data("RecLoc")
		s RecLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RecLoc)
		s IngrType=result.Data("IngrType")
		s PurchUser=result.Data("PurchUser")
		s PoNo = result.Data("PoNo")
		s CreateUser = result.Data("CreateUser")
		s CreateDate = result.Data("INGR_CreateDate")
		s Complete = result.Data("INGR_Completed")
		s ReqLoc = result.Data("ReqLoc")
		s ReqLocDesc = result.Data("ReqLocDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s StkGrp = result.Data("StkGrp")
		s StkGrpId=result.Data("StkGrpId")
		s SourceOfFundId=result.Data("INGR_SourceOfFund")
		s SourceOfFund=$s(SourceOfFundId'="":$p(^DHCSOUROFFUND(SourceOfFundId),"^",2),1:"")
		s Audit=result.Data("INGR_AuditFlag")
		s:Audit="" Audit="N"
		s AuditUserId=result.Data("INGR_SSUSR_DR")
		s AuditDate=result.Data("INGR_Date")
		s AcceptUserId=result.Data("INGR_SSUSR_Accept_DR")
		s stkType=result.Data("stkType")
		
		//总金额
		&sql(select sum(initm_realtotal),sum(initm_SpAmt),sum(initm_invmoney)
		into :RpAmt,:SpAmt,:InvAmt from dhc_ingdrecitm where ingri_ingr_parref=:IngrId)
		s (AuditUser,AcceptUser)=""
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
		s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
		s Margin=SpAmt-RpAmt
		i Complete="Y"  d
		.s Complete="完成"
		e  d
		.s Complete="未完成"
		i Audit="Y"  d
		.s Audit="已审核"
		e  d
		.s Audit="未审核"
		s InGrRemarks=result.Data("InGrRemarks")
		s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s InGrRemarks=$lts(InGrRemarks,MemoDelim)
		d OutPutRowIngrStr
	}
	Quit $$$OK

OutPutRowIngrStr
	s Data=$lb(IngrId,IngrNo,Vendor,RecLoc,IngrType,PurchUser,PoNo,CreateUser,CreateDate,Complete,ReqLoc,StkGrp,RpAmt,SpAmt,AuditDate,AuditUser,Margin,AcceptUser,VenId,InGrRemarks,SourceOfFund,ReqLocDesc,InvAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取物资当前价格信息
/// Author:	wangjiabin
/// Date:	2015-08-14
/// Argu:	inci, uom, StrParam(安全组id^科室id^人员id)
/// Return: rp^sp
ClassMethod GetPrice(InciId As %String, UomId As %String, StrParam As %String) As %String
{
	n (InciId,UomId,StrParam)
	
	s GroupId=$p(StrParam,"^",1)
	s LocId=$p(StrParam,"^",2)
	s UserId=$p(StrParam,"^",3)
	s HospId=""
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetConfigRp(InciId,UomId,..%GetParameter("AppName"),Params)
	s Sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$H,UomId,HospId,"")
	q Rp_"^"_Sp
}

/// 拆分入库单明细
/// Author:	wangjiabin
/// Date:	2015-07-27
/// Argu:	入库单rowid(,隔开)
/// Return: 0:成功, <0:失败
/// w ##class(web.DHCSTMHUI.DHCINGdRec).SplitIngr(429)
ClassMethod SplitIngr(ingr As %String) As %String
{
	n (ingr)
	q:ingr="" ""
	s lastCh=$o(^DHCINGR(ingr,"GRI",""),-1)
	q:lastCh="" ""
	
	s IngrLoc=$p(^DHCINGR(ingr),"^",13)
	s HospId=$p(^CTLOC(IngrLoc),"^",22)
	s count=0,ret=0
	s ch=0
	f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:(ch="")||(ch>lastCh)||(ret<0)  d
	.s ingri=ingr_"||"_ch
	.s inci=$p(^DHCINGR(ingr,"GRI",ch),"^",25)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	.q:HVFlag'="Y"
	.s qty=$p(^DHCINGR(ingr,"GRI",ch),"^",4)
	.q:qty<=1
	.s Rp=$p(^DHCINGR(ingr,"GRI",ch),"^",30)
	.s Sp=$p(^DHCINGR(ingr,"GRI",ch),"^",32)
	.s NewSp=$p(^DHCINGR(ingr,"GRI",ch),"^",45)
	.s SpAmt=Sp
	.s RpAmt=Rp
	.s NewSpAmt=NewSp
	.s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	.s NewSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
	.s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	.s InvAmt=RpAmt
	.s $p(^DHCINGR(ingr,"GRI",ch),"^",4)=1
	.s $p(^DHCINGR(ingr,"GRI",ch),"^",26)=InvAmt
	.s $p(^DHCINGR(ingr,"GRI",ch),"^",31)=RpAmt
	.s $p(^DHCINGR(ingr,"GRI",ch),"^",50)=SpAmt
	.s $p(^DHCINGR(ingr,"GRI",ch),"^",46)=NewSpAmt
	.s ingridata=^DHCINGR(ingr,"GRI",ch)
	.f i=1:1:qty-1 d
	..s newCh=1+$o(^DHCINGR(ingr,"GRI",""),-1)
	..s newIngri=ingr_"||"_newCh
	..s ^DHCINGR(ingr,"GRI",newCh)=ingridata
	..s count=count+1
	.i count<1 s ret=-10
	q ret
}

/// 根据入库单明细生成高值条码
/// Author:	wangjiabin
/// Date:	2015-07-27
/// Argu:	入库单rowid(,隔开)
/// Return: 0:成功, <0:失败
ClassMethod CreateBarCode(ingr As %String, UserId As %String) As %String
{
	n (ingr,UserId)
	q:ingr="" ""
	s VenId=$p(^DHCINGR(ingr),"^",3)
	s LocId=$p(^DHCINGR(ingr),"^",13)
	s pHospId=..sssHospId(LocId)
	s Date=+$h,Time=$p($h,",",2)
	s ret=0
	
	ts
	s ch=0
	f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:(ch="")||(ret<0)  d
	.s ingri=ingr_"||"_ch
	.s dhcit=$o(^DHCITD(0,"Type","G","Pointer",ingri,0))
	.q:dhcit'=""
	.s qty=$p(^DHCINGR(ingr,"GRI",ch),"^",4)
	.q:qty'=1
	.s inci=$p(^DHCINGR(ingr,"GRI",ch),"^",25)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	.q:HVFlag'="Y"
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s Scg=$p(ScgInfo,"^",5)
	.
	.s BarCode=""
	.s StrParam=inci_"^"_BarCode
	.s dhcit=##class(web.DHCSTMHUI.DHCItmTrack).RegOne(StrParam,UserId,Scg,Date,Time,pHospId)
	.q:+dhcit<=0
	.s barcode=$p(^DHCIT(dhcit),"^",2)
	.s operData=LocId_"^"_UserId_"^"_inci_"^^"_VenId
	.s ret=##class(web.DHCSTMHUI.DHCItmTrack).Update("G",ingri,barcode,operData)
	.i ret<0 tro  q
	q:ret<0 ret
	tc
	q 0
}

/// 根据物资id判断物资名称和进价是否与上次入库不一致
/// Author:	tsr
/// Date: 2016-03-14
/// Argu: 物资id,进价
/// Return: 0:一致, <0:不一致
ClassMethod CheckNamePrice(inci As %String, rp As %String) As %String
{
	n (inci,rp)
	q:inci="" 0
	s inciName=$p(^INCI(inci,1),"^",2)
	s ingr=$o(^DHCINGR(0,"INCI",inci,""),-1)
	q:ingr="" 0
	s ingrch=$o(^DHCINGR(0,"INCI",inci,ingr,""),-1)
	q:ingrch="" 0
	s ingriName=$p(^DHCINGR(ingr,"GRI",ingrch),"^",2)
	s ingriRp=$p(^DHCINGR(ingr,"GRI",ingrch),"^",30)
	q:inciName'=ingriName -1
	q:rp'=ingriRp -2
	q 0
}

/// 判断该入库单明细中是否有未生效的调价单
/// Author:	tsr
/// Date: 2016-05-17
/// Argu: 入库单id
/// Return: 0:不存在, 不等于0:存在
ClassMethod CheckAllowAsp(Ingr As %String) As RtnObj
{
	n (Ingr)
	s RtnObj=##class(RtnObj).%New()
	i Ingr="" q RtnObj
	s loc=$P(^DHCINGR(Ingr),"^",13)
	s hosid=..sssHospId(loc)
	s ret=0
	s ch=0
	f  s ch=$o(^DHCINGR(Ingr,"GRI",ch)) q:(ch="")||(RtnObj.success'=0)  d
	.s inci=$p(^DHCINGR(Ingr,"GRI",ch),"^",25)
	.s incDesc=$p(^INCI(inci,1),"^",2)
	.s ret=##class(web.DHCSTMHUI.INAdjSalePrice).CheckItmAdjSp(inci,hosid)
	.i ret'=0 d RtnObj.Err(-1,"",incDesc_"存在未来生效调价单!","",0)
	q RtnObj
}

/// 打印入库单后修改打印标志
/// Author:	tsr
/// Date: 2016-05-31
/// Argu: 入库单id
/// Return: 0:成功, 不等于0:失败
ClassMethod PrintFlag(IngrIdStr As %String) As %String
{
	n (IngrIdStr)
	s RtnObj=##class(RtnObj).%New()
	ts
	s IngrStrLen=$l(IngrIdStr,"^")
	f i=1:1:IngrStrLen q:RtnObj.success'=0  d
	.s IngrId=$p(IngrIdStr,"^",i)
	.i ((IngrId="")||('$d(^DHCINGR(IngrId)))) d RtnObj.Err("-1","","入库单不存在","",0) 
	.q:RtnObj.success'=0
	.s PrintFlag=$p(^DHCINGR(IngrId),"^",43)
	.q:PrintFlag="Y"
	.s tmpPrintFlag="Y"
	.&sql(UPDATE DHC_INGdRec SET INGR_PrintFlag=:tmpPrintFlag WHERE INGR_RowId=:IngrId)
	.i (SQLCODE) d RtnObj.Err("-2","","入库单更新打印标志失败")
	.q:RtnObj.success'=0
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 高值条码(护士等角色)临时生成的处理
/// 	高值条码生成后:入库+审核+出库+出库审核+接收
/// Author:	wangjiabin
/// Date:	2016-11-07
/// Argu:	此方法的参数和入库单保存Save的参数是一样的,这里不再另写说明
/// Return: ingr:成功, 非空:失败信息
/// w ##class(web.DHCSTMHUI.DHCINGdRec).CreateUrgencyIngr(^templxt("Ur1"),^templxt("Ur2"))
ClassMethod CreateUrgencyIngr(MainInfo As %String, ListDetail As %String) As %String
{
	n (MainInfo,ListDetail,%session)
	s RtnObj=##class(RtnObj).%New()
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(MainInfo)
	i Sc'=0 d RtnObj.Err(-1,"","主参解析失败!") q RtnObj.Json()
	
	s VenId=MainObj.%Get("InGdReqVendor")
	s LocId=MainObj.%Get("InGdRecLocId")
	s CreateUser=MainObj.%Get("gUserId")
	s ReqLoc=MainObj.%Get("InGdReqLocId")
	s GroupId=MainObj.%Get("gGroupId")
	s Source=MainObj.%Get("Source")
	s gHospId=MainObj.%Get("gHospId")
	s StkGrpId=MainObj.%Get("ScgStk")

	s maintitle="IngrId^ApcvmDr^RecLoc^gUserId^GiftFlag^AdjCheque^IngrTypeId^PurchaseUser^StkGrpId^PoId^InGrRemarks^SourceOfFund^ReqLocId^SynBarcode^InitId^AcceptUserId^OeriRecflag"
	s maindata="^"_VenId_"^"_LocId_"^"_CreateUser_"^^^^^"_StkGrpId_"^^^"_Source_"^"_ReqLoc_"^^^^"

	s MainInfoObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(maindata,maintitle)
	s Sc=DetailObj.%FromJSON(ListDetail)
	i Sc'=0 d RtnObj.Err(-2,"","明细解析失败!") q RtnObj.Json()
	s detailtitle="RowId^IncId^BatchNo^ExpDate^ManfId^IngrUomId^Rp^HVBarCode^RecQty^NewSp^SxNo^InvNo^InvDate^Inpoi^Remark^Remarks"
	s detailtitle=detailtitle_"^QualityNo^MtDr^SterilizedNo^AdmNo^AdmExpdate^InvMoney^SpecDesc^OrderDetailSubId^reqLocId^Sp^Tax"
	
	ts
	s nndetail="["
	s count=0
	While (RtnObj.success=0) {
		s ItmObj=DetailObj.%Pop()
		q:ItmObj=""
		s (InvNo,InvDate,InvMoney,Remark,Remarks,QualityNo,MtDr,SterilizedNo,Tax)=""
		s Ingri=ItmObj.%Get("Ingri")
		s dhcitd=ItmObj.%Get("RowId")
		s barcode=ItmObj.%Get("BarCode")
		s IncId=$P(^DHCIT(dhcitd),"^",1)
		s BatchNo=ItmObj.%Get("BatchNo")
		s ExpDate=..DL2H(ItmObj.%Get("ExpDate"))
		s ManfId=ItmObj.%Get("ManfId")
		s IngrUomId=ItmObj.%Get("BUomId")
		s RecQty=ItmObj.%Get("Qty")
		s Rp=ItmObj.%Get("Rp")
		s NewSp=ItmObj.%Get("Sp")
		s Sp=ItmObj.%Get("Sp")
		s SxNo=ItmObj.%Get("SxNo")
		s Inpoi=ItmObj.%Get("Inpoi")
		s AdmNo=ItmObj.%Get("CertNo")
		s AdmExpdate=ItmObj.%Get("CertExpDate")
		s SpecDesc=ItmObj.%Get("SpecDesc")
		s OrderDetailSubId=ItmObj.%Get("OrderDetailSubId")
		s reqLocId=""
		s Status=$P(^DHCIT(dhcitd),"^",5)
		s OriginalStatus=ItmObj.%Get("OriginalStatus")
		i (Status'="")&&(OriginalStatus'="NotUnique") d RtnObj.Err(-2,"","条码"_barcode_"已入库") q
		
		s data="^"_IncId_"^"_BatchNo_"^"_ExpDate_"^"_ManfId_"^"_IngrUomId_"^"_Rp_"^"_barcode
		_"^"_RecQty_"^"_NewSp_"^"_SxNo_"^"_InvNo_"^"_InvDate_"^"_Inpoi_"^"_Remark_"^"_Remarks
		_"^"_QualityNo_"^"_MtDr_"^"_SterilizedNo_"^"_AdmNo_"^"_AdmExpdate_"^"_InvMoney_"^"_SpecDesc_"^"_OrderDetailSubId
		_"^"_reqLocId_"^"_Sp_"^"_Tax
		
		s nDetailObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(data,detailtitle)
		i count=0 d
		.s nndetail=nndetail_nDetailObj
		e  d
		.s nndetail=nndetail_","_nDetailObj
		s count=count+1
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s nndetail=nndetail_"]"
	s RtnObj=..Save(MainInfoObj,nndetail)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	s ingr=RtnObj.rowid
	s HospId=""
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Param=GroupId_"^"_LocId_"^"_CreateUser_"^"_HospId
	s AppName=..%GetParameter("AppName")
	s AutoCompAfterSaveIN=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoCompAfterSaveIN",Param)
	i AutoCompAfterSaveIN'="Y" d ;入库保存自动完成就不操作此步
	.s RtnObj=..MakeComplete(ingr,MainInfoObj,"Y")
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s RtnObj=..Audit(ingr,MainInfoObj,"Y")
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s RtnObj=..CreateTransferByIngr(ingr,ReqLoc,gHospId)		//自动出库
	i RtnObj.success'=0 tro  q RtnObj.Json() ;"出库制单失败!"
	s init=RtnObj.rowid
	
	s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(init,CreateUser,"","Y")
	i RtnObj.success'=0 tro  q RtnObj.Json() ;"出库审核失败!"
	
	tc
	s RtnObj.rowid=ingr
	q RtnObj.Json()
}

/// 判断条码是否已经入库(lihui20180129)
/// w ##class(web.DHCSTMHUI.DHCINGdRec).HVifIngr("201801290001")
ClassMethod HVifIngr(barcode) As %String
{
	n (barcode)
	q:barcode="" "N"
	s IngrFlag="N"
	s dhcit=$o(^DHCIT(0,"LABEL",barcode,""))
	q:dhcit="" IngrFlag
	s dhcitmid="",type="G"
	&sql(SELECT DHCITD_Rowid into:dhcitmid FROM DHC_ItmTrackDetail WHERE DHCITD_Type=:type and DHCITD_Parref=:dhcit)
	i dhcitmid'="" d
	.s IngrFlag="Y"
	q IngrFlag
}

/// 获取入库的价格信息
/// Author:	lihui
/// Date: 2017-05-22
/// Input: 库存项id,入库单位id,取进价标志,(安全组^科室^用户^医院)
/// Return: 进价^售价
/// w ##class(web.DHCSTMHUI.DHCINGdRec).GetPriceInfoForRec(8966,5,"143^153^541^2")
ClassMethod GetPriceInfoForRec(Inci As %String, Uom As %String, Params As %String) As %String
{
	n (Inci,Uom,Params)
	q:Inci="" "0^0"
	s:Uom="" Uom=$p(^INCI(Inci,3),"^",6)
	s HospId=$p(Params,"^",4)
	s AppName=..%GetParameter("AppName")
	s RpFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"DefaRp",Params)
	s BatSpFlag=..sssBatSpFlag("",Inci,Params)
	
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetConfigRp(Inci,Uom,AppName,Params)
	;批次售价 && 取批次调价表进价 && 没有批次调价信息, 取in_adjsaleprice中的数据
	if ((BatSpFlag=1)&&(RpFlag=2)) d
	.s BatRpInfo=##class(web.DHCSTMHUI.Common.PriceCommon).IfExitBatAdjprice(Inci)
	.s ExistBatRp=$p(BatRpInfo,"^",1)
	.q:ExistBatRp="Y"						;有批次调价信息的,过滤
	.s BatAspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(Inci,+$h,Uom,"")
	.s Rp=$p(BatAspInfo,"^",1) ;当前进价
	
	;计算售价收分
	s Sp=..GetSpForRec(Inci,Uom,Rp,Params)

	q Rp_"^"_Sp
}

/// w ##class(web.DHCSTMHUI.DHCINGdRec).GetSpForRec(8966,5,20,"143^153^541^2")
ClassMethod GetSpForRec(Inci As %String, Uom As %String, Rp As %String, Params As %String) As %String
{
	n (Inci,Uom,Rp,Params)
	q:Inci="" "0"
	
	s:Uom="" Uom=$p(^INCI(Inci,3),"^",6)
	s HospId=$p(Params,"^",4)
	s AppName=..%GetParameter("AppName")
	s SpFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"DefaSp",Params)
	s NotBatDefaSp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"NotBatDefaSp",Params)
	s BatSpFlag=..sssBatSpFlag("",Inci,Params)
	
	;计算售价收分
	i BatSpFlag="1" {
		;按定价类型
		s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetMtSp(Inci,Uom,Rp,HospId)
	}else{
		s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci)
		i (ChargeFlag="N")&&(NotBatDefaSp'="") d
		.s:NotBatDefaSp="0" Sp=0
		.s:NotBatDefaSp="1" Sp=Rp
		e  i SpFlag=1 d
		.;按定价类型
		.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetMtSp(Inci,Uom,Rp,HospId)
		e  d
		.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,Uom,HospId)
	}

	q Sp
}

/// Descript:   处理补录入库明细补录的状态
/// Creater:    lihui
/// CreateDate: 20171124
/// Table: DHC_InGdRecItm
/// Input: 入库主表id
/// Output:     
/// Return：成功:0，失败 <0;
ClassMethod upHvmatState(ingr As %String) As %Library.String
{
	n (ingr)
	q:ingr="" 0
	q:'$d(^DHCINGR(ingr)) 0
	
	s Err=0
	s chl=0
	f  s chl=$o(^DHCINGR(ingr,"GRI",chl)) q:(chl="")!(Err'=0)  d
	.q:'$d(^DHCINGR(ingr,"GRI",chl))
	.s ingri=ingr_"||"_chl
	.&sql(update DHC_HVMat_OrdItm set ORI_INGRI_Modify_DR=null,ORI_IngrFlag=null,ORI_DateOfManu=null where ORI_INGRI_Modify_DR=:ingri)
	.i SQLCODE'=0  d
	..s Err=-1
	
	q Err
}

/// 获取高值入库补录标志 20180203lihui
/// input : 入库主表id
/// output : 补录标志
/// w ##class(web.DHCSTMHUI.DHCINGdRec).GetOeriRecFlag(8557)
ClassMethod GetOeriRecFlag(ingr) As %String
{
	n (ingr)
	q:ingr="" "N"
	q:'$d(^DHCINGR(ingr)) "N"
	s OeriRecFlag=$p(^DHCINGR(ingr),"^",45)
	q:OeriRecFlag="" "N"
	q OeriRecFlag
}

/// 补录高值入库单按照接收科室拆分为出库单 20180203lihui
/// input : 入库主表id,Userid
/// output : 0 成功;<0 失败
/// w ##class(web.DHCSTMHUI.DHCINGdRec).SplitIngrIntoInit(807,3785)
ClassMethod SplitIngrIntoInit(ingr, user, gHospId) As RtnObj
{
	n (ingr,user,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	i ((ingr="")||('$d(^DHCINGR(ingr)))) q RtnObj.Err("-1","","入库单不存在","",0)
	
	s pid=..NewPid()
	k ^TMP(pid,"SplitIngrIntoInit")
	s ingrloc=$p(^DHCINGR(ingr),"^",13)
	s scg=$p(^DHCINGR(ingr),"^",28)
	s chl="",n=0
	f  s chl=$o(^DHCINGR(ingr,"GRI",chl)) q:(chl="")!(RtnObj.success'=0)  d
	.q:'$d(^DHCINGR(ingr,"GRI",chl))
	.s ingritminfo=^DHCINGR(ingr,"GRI",chl)
	.s ingrid=ingr_"||"_chl
	.s INGRINFO=$o(^DHCINGRINFO(0,"INGRI",ingrid,""))
	.i ((INGRINFO="")||('$d(^DHCINGRINFO(INGRINFO)))) d RtnObj.Err("-2","","入库明细附加表信息不存在") q
	.s reqloc=$p(^DHCINGRINFO(INGRINFO),"^",5) ;接收科室
	.i (reqloc="") s Sc=RtnObj.Err("-2","","接收科室不存在","",0) q
	.i (reqloc=ingrloc) s Sc=RtnObj.Err("-2","","接收科室与出库科室相同","",0) q
	.s inclb=$p(ingritminfo,"^",1)
	.s recQty=$p(ingritminfo,"^",4)
	.s uomDr=$p(ingritminfo,"^",10)
	.s initiRemark=ingrid		//夜间处理部分,备注保存对应的ingri
	.;明细id^批次id^数量^单位^请求明细id^备注(对应ingri)
	.s n=n+1
	.s ^TMP(pid,"SplitIngrIntoInit",reqloc,n)=inclb_"^"_recQty_"^"_uomDr_"^"_initiRemark_"^"_ingrid
	i RtnObj.success'=0 k ^TMP(pid,"SplitIngrIntoInit") q RtnObj
	
	s initstr=""
	s ReqLocid=""
	f  s ReqLocid=$o(^TMP(pid,"SplitIngrIntoInit",ReqLocid)) q:(ReqLocid="")!(RtnObj.success'=0)  d
	.s m=0,listdata=""
	.s OperDesc="正常出库",OperStkType="OM"
	.s operType=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",OperDesc,"DHC_OperateType",gHospId,OperStkType)
	.s operType=$g(operType)
	.s status=11		;出库单状态
	.s remark="高值材料补录"
	.s MainTitle="InitFrLoc^InitToLoc^OperateType^InitComp^InitState^InitUser^InitScg^InitRemarks"
	.s MainData=ingrloc_"^"_ReqLocid_"^"_operType_"^Y^"_status_"^"_user_"^"_scg_"^"_remark
	.s mainDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	.f  s m=$o(^TMP(pid,"SplitIngrIntoInit",ReqLocid,m)) q:(m="")!(RtnObj.success'=0)  d
	..s tmpdata=^TMP(pid,"SplitIngrIntoInit",ReqLocid,m)
	..s tmptitle="Inclb^Qty^UomId^Remark^Ingri"
	..s tmplistData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpdata,tmptitle)
	..i listdata="" d
	...s listdata=tmplistData
	..e  d
	...s listdata=listdata_","_tmplistData
	..s listDataObj="["_listdata_"]"
	.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).Save(mainDataObj,listDataObj)
	.i RtnObj.success'=0 d RtnObj.Err("-3","","保存出库单失败") q 
	.s init=RtnObj.rowid
	.s ch=0
	.f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:(ch="")!(RtnObj.success'=0)  d
	..s initi=init_"||"_ch
	..s ingri=$p(^DHCINIT(init,"ITI",ch),"^",24)
	..//将initi保存到initm_Remark中. initi_remarks暂时保留
	..&sql(update DHC_INGdRecItm set initm_Remark=:initi where %id=:ingri)
	..i SQLCODE d RtnObj.Err("-3","","更新入库明细失败") q 
	.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(init,user,"","N")
	.i RtnObj.success'=0 d RtnObj.Err("-6","","出库审核失败") q
	.s initstatus=31
	.&sql(update DHC_InIsTrf set INIT_State=:initstatus where %id=:init)
	.i SQLCODE'=0 d RtnObj.Err("-4","","更新出库单状态失败") q 
	i RtnObj.success'=0 q RtnObj
	
	s result=##class(web.DHCSTMHUI.DHCItmTrackDetailAddion).RecordIngr(ingr)
	i +result<0  d RtnObj.Err("-5","","更新高值跟踪信息失败") q RtnObj
	q RtnObj
}

/// 入库审核界面保存发票信息
ClassMethod jsUpdateINV(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..UpdateINV(Params)	
	q RtnObj.Json()
}

/// Descript:   入库审核界面保存发票信息
/// Creater:    lihui
/// CreateDate: 20180717
/// Input: Params(TrType:G,入库明细id,发票号,发票日期,发票金额,随行单号)
/// Output: 审核结果
/// Return：成功：0；失败：成功信息+失败信息
ClassMethod UpdateINV(Params As %String) As RtnObj
{
	n (Params)
	s MethodName=$CLASSNAME()_".UpdateINV"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!") q RtnObj
	s ingri=PJObj.%Get("RowId")
	s invCode=PJObj.%Get("InvCode")
	s invNo=PJObj.%Get("InvNo")
	s invAmt=PJObj.%Get("InvMoney")
	s invDate=PJObj.%Get("InvDate")
	s sxNo=PJObj.%Get("SxNo")
	s invDate=..DH2L(invDate)
	s invAmt=+invAmt
	s Ingr=+ingri
	s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
	i ((ingri="")||('$d(^DHCINGR(Ingr,"GRI",$p(ingri,"||",2))))) d RtnObj.Err(-2,"","入库单明细不存在!") q RtnObj
	s invSetdate=##class(web.DHCSTMHUI.DHCINGdRecItm).GetInvSetDate(ingri,"G",invNo)
	i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(..%GetParameter("AppName")_Ingr)<0 d RtnObj.Err(-99,Ingr,MethodName_":加锁失败","",-1) q RtnObj
	ts
	&sql(update dhc_ingdrecitm set initm_invno=:invNo,
		initm_invdate=:invDate,initm_invmoney=:invAmt,
		initm_sxno=:sxNo,initm_InvSetDate=:invSetdate,
		initm_InvCode=:invCode 
		where %id=:ingri)
	i SQLCODE'=0 d RtnObj.Err(-5,"","更新发票信息失败!")
	i RtnObj.success'=0 tro  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_Ingr) q RtnObj
	i AuditFlag="Y" d
	.s RtnObj=..UpdateInvInfo(Ingr,"G")
	.i RtnObj.success'=0 d RtnObj.Err(-6,"","创建发票信息失败!") q
	i RtnObj.success'=0 tro  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_Ingr) q RtnObj
	tc
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_Ingr) 
	q RtnObj
}

/// 判断条码是否已经入库(lihui20180903)
/// return: 入库主表ID^入库完成状态
/// w ##class(web.DHCSTMHUI.DHCINGdRec).GetInrInfoByBarcode("YL20170713024")
/// 
ClassMethod GetInrInfoByBarcode(barcode) As %String
{
	n (barcode)
	q:barcode="" "^N"
	s dhcit=$o(^DHCIT(0,"LABEL",barcode,""))
	q:dhcit="" "^N"
	s Pointer="",type="G",completeFlag="N"
	&sql(SELECT DHCITD_Pointer into:Pointer FROM DHC_ItmTrackDetail WHERE DHCITD_Type=:type and DHCITD_Parref=:dhcit)
	q:Pointer="" "^N"
	s Ingrid=+Pointer
	q:'$d(^DHCINGR(Ingrid)) "^N"
	s completeFlag=$p(^DHCINGR(Ingrid),"^",12)
	q Ingrid_"^"_completeFlag
}

/// Description:获取库存项信息
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		
/// Input:		库存项代码,生产厂家名称,单位描述
/// w ##class(web.DHCSTMHUI.DHCINGdRec).GetInciMsg("SDSLYCXDNBKN01","","袋(6)","东华标准版数字化医院[总院]")
ClassMethod GetInciMsg(InciCode As %String, Manf As %String, UomDesc As %String, Hospital As %String) As %Library.String
{
	n (InciCode,Manf,UomDesc,Hospital,%session)
	q:InciCode="" ""
	s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hospital),0))
	q:HospId="" ""
	s Inci=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",InciCode,"INC_Itm",HospId)
	q:Inci="" ""
	s UomId=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(UomDesc),0))
	s (Spec,Model,ManfId,ManfDesc)=""
	s AddInfo=$O(^DHCITMINFO(0,"INCI",Inci,0))
	i AddInfo'="" d
	.s AddInfoData=^DHCITMINFO(AddInfo)
	.s Spec=$p(AddInfoData,"^",27)
	.s Model=$p(AddInfoData,"^",59)
	.s ManfId=$p(AddInfoData,"^",25)
	.s:ManfId'="" ManfDesc=$P($g(^PHMNF(ManfId)),"^",2)
	q Inci_"^"_ManfId_"^"_UomId_"^"_Spec_"^"_Model_"^"_ManfDesc
}

/// 入库单物资名称模糊查询
/// Author: zx
/// Date: 20200310
/// Return:	0~包含;1~不包含
/// w ##class(web.DHCSTMHUI.DHCINIsTrf).CheckInciDesc(11,11)
ClassMethod CheckInciDesc(Ingr As %String, InciDesc As %String) As %String
{
	n (Ingr,InciDesc)
	s err=0
	s Ch=0
	f  s Ch=$o(^DHCINGR(Ingr,"GRI",Ch)) q:(Ch="")||(err'=0)  d
	.s Inci=$p(^DHCINGR(Ingr,"GRI",Ch),"^",25)
	.s Desc=$p(^INCI(Inci,1),"^",2)
	.s:Desc[InciDesc err=-1
	q:err'=0 0
	q -1
}

/// w ##class(web.DHCSTMHUI.DHCINGdRec).UpdateInvInfo(163,"G")
ClassMethod UpdateInvInfo(Ingr, Type) As RtnObj
{
	n (Ingr,Type)
	s RtnObj=##class(RtnObj).%New()
	q:(Ingr="")||(Type="") RtnObj
	
	i Type="G" d
	.s VendorId=$p(^DHCINGR(Ingr),"^",3)
	.s LocId=$p(^DHCINGR(Ingr),"^",13)
	.s chl=0
	.f  s chl=$o(^DHCINGR(Ingr,"GRI",chl)) q:(RtnObj.success'=0)||(chl="")  d
	..s InvCode=$p(^DHCINGR(Ingr,"GRI",chl),"^",51)
	..s InvNo=$p(^DHCINGR(Ingr,"GRI",chl),"^",27)
	..s InvDate=$p(^DHCINGR(Ingr,"GRI",chl),"^",34)
	..s InvDate=..DL2H(InvDate)
	..i (InvCode'="")||(InvNo'="") d
	...s InvId=""
	...&sql(select %ID into :InvId from DHC_VendorInv where nvl(INV_InvCode,'')=nvl(:InvCode,'') and nvl(INV_InvNo,'')=nvl(:InvNo,''))
	...i InvId="" d
	....s InvAmt=##class(web.DHCSTMHUI.DHCVendorInv).GetInvAmtByIngr(InvCode,InvNo)
	....s Data=InvId_"^"_VendorId_"^"_InvCode_"^"_InvNo_"^"_InvAmt_"^"_InvDate_"^"_LocId_"^"_"Y"_"^"_"Y"
	....s Title="RowId^Vendor^InvCode^InvNo^InvAmt^InvDate^IngrLoc^CompFlag^FilledFlag"
	....s InvData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	....s RtnObj=##class(web.DHCSTMHUI.DHCVendorInv).SaveInvInfo(InvData)
	...
	e  i Type="R" d
	.s VendorId=$p(^INGRT(Ingr),"^",2)
	.s LocId=$p(^INGRT(Ingr),"^",7)
	.s chl=0
	.f  s chl=$o(^INGRT(Ingr,"DHCGRR",chl)) q:(RtnObj.success'=0)||(chl="")  d
	..s InvCode=$p(^INGRT(Ingr,"DHCGRR",chl),"^",19)
	..s InvNo=$p(^INGRT(Ingr,"DHCGRR",chl),"^",12)
	..s InvDate=$p(^INGRT(Ingr,"DHCGRR",chl),"^",14)
	..s InvDate=..DL2H(InvDate)
	..i (InvCode'="")||(InvNo'="") d
	...s InvId=""
	...&sql(select %ID into :InvId from DHC_VendorInv where nvl(INV_InvCode,'')=nvl(:InvCode,'') and nvl(INV_InvNo,'')=nvl(:InvNo,''))
	...i InvId="" d
	....s InvAmt=##class(web.DHCSTMHUI.DHCVendorInv).GetInvAmtByIngr(InvCode,InvNo)
	....s Data=InvId_"^"_VendorId_"^"_InvCode_"^"_InvNo_"^"_InvAmt_"^"_InvDate_"^"_LocId_"^"_"Y"_"^"_"Y"
	....s Title="RowId^Vendor^InvCode^InvNo^InvAmt^InvDate^IngrLoc^CompFlag^FilledFlag"
	....s InvData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	....s RtnObj=##class(web.DHCSTMHUI.DHCVendorInv).SaveInvInfo(InvData)
	...
	
	q RtnObj
}

/// Description：检查价格模式2，进价是否与调价表一致
/// Creator：lxt
/// CreateDate：20230406
ClassMethod CheckAspRp(IngrId, Param) As RtnObj
{
	n (IngrId,Param)
	s HospId=$p(Param,"^",4)
	s RtnObj=##class(RtnObj).%New()
	s Ret=""
	s CH=0
	f  s CH=$o(^DHCINGR(IngrId,"GRI",CH)) q:(CH="")||(RtnObj.success<0)  d
	.s Inci=$p(^DHCINGR(IngrId,"GRI",CH),"^",25)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s UomId=$p(^DHCINGR(IngrId,"GRI",CH),"^",10)
	.s Rp=$p(^DHCINGR(IngrId,"GRI",CH),"^",30)
	.s BatSpFlag=..sssBatSpFlag(HospId,Inci)
	.q:BatSpFlag'=2
	.s AspRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRpOld(Inci,+$h,UomId,HospId)
	.i Rp'=AspRp d
	..i Ret="" s Ret=InciDesc
	..e  s Ret=Ret_","_InciDesc
	
	i Ret'="" d RtnObj.Err(-2,"",Ret_"进价与调价表不一致，请先进行调价！")
	q RtnObj
}

/// 获取入库单明细的类组串(^隔开)
/// Author:	wxj
/// Date:	2023-04-10
/// Input:Ingr - 入库单RowId
/// Return:
ClassMethod GetRecDetailScg(Ingr As %String) As %String
{
	n (Ingr)
	q:Ingr="" ""
	s result=""
	s ch=0
	f  s ch=$o(^DHCINGR(Ingr,"GRI",ch)) q:ch=""  d
	.s inci=$p(^DHCINGR(Ingr,"GRI",ch),"^",25)
	.s scg=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",5)
	.i result="" d
	..s result=scg
	.e  i ##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(result,scg,"^")=0 d
	..s result=result_"^"_scg	
	q result
}

}
