Import sqluser

Class web.DHCSTMHUI.LocLimitAmt Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询科室限额信息
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		CT_Loc，DHC_LocReqLimit
/// Input:		
/// Return：	科室限额信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocLimitAmt","QueryLocLimit",^templxt("QueryLocLimit"))
Query QueryLocLimit(Params As %String) As Query(ROWSPEC = "RowId,LocId,LocCode,LocDesc,StartDate,EndDate,ReqAmt:%Float,UsedAmt:%Float,PeriodTypeId,PeriodTypeDesc,Year") [ SqlProc ]
{
}

ClassMethod QueryLocLimitExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pYear=PJObj.%Get("Year")
	s pLocCode=PJObj.%Get("LocCode")
	s pLocDesc=PJObj.%Get("LocDesc")
	s pPeriodType=PJObj.%Get("PeriodType")	//周期
	s pLimitAmt=PJObj.%Get("LimitAmt")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s pStartDate=$zdh(pYear_"-01-01",3)
	s pEndDate=$zdh(pYear_"-12-31",3)
	s StartDate=..DL2H(pStartDate)
	s EndDate=..DL2H(pEndDate)
	
	s result = ##class(%Library.ResultSet).%New()
	//取每年第一条数据进行显示
	s SqlStr = "select %ID as RowId,LRL_CTLoc_DR as LocId,LRL_CTLoc_DR->CTLoc_Code as LocCode,LRL_CTLoc_DR->CTLoc_Desc as LocDesc from DHC_LocReqLimit"
	_" where LRL_StartDate="_pStartDate
	i pLocCode'="" d
	.s SqlStr=SqlStr_" and LRL_CTLoc_DR->CTLoc_Code like '%"_pLocCode_"%' "
	i pLocDesc'="" d
	.s SqlStr=SqlStr_" and LRL_CTLoc_DR->CTLoc_Desc like '%"_pLocDesc_"%' "
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s LocId = Result.Data("LocId")
		s LocCode = Result.Data("LocCode")
		s LocDesc = Result.Data("LocDesc")
		continue:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(LocId,pHospId)'=0)
		continue:(##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(LocId)="Y")
		
		s ReqAmt=$p(^DHCLRL(RowId),"^",4)
		s PeriodTypeId=$p(^DHCLRL(RowId),"^",7)
		
		i PeriodTypeId=1 s LimitTypeDesc="按年"
		i PeriodTypeId=2 s LimitTypeDesc="按季"
		i PeriodTypeId=3 s LimitTypeDesc="按月"
		
		s UsedAmt=""
		i (pStartDate<=+$h)&&(pEndDate>=+$h) d
		.s UsedAmt=$p(..GetPeriorUsed(LocId,+$h),"^",1)
		
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,LocId,LocCode,LocDesc,StartDate,EndDate,ReqAmt,UsedAmt,PeriodTypeId,LimitTypeDesc,pYear)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.LocLimitAmt).GetPeriorUsed(114,+$h)
ClassMethod GetPeriorUsed(LocId, Date = "", LimitType = "", LimitDataId = "")
{
	n (LocId,Date,LimitType,LimitDataId)
	q:(LocId="") ""
	q:((LimitType="")&&(LimitDataId'=""))||(((LimitType'="")&&(LimitDataId=""))) ""
	s:Date="" Date=+$h
	
	s (StartDate,EndDate)=""
	&sql(select LRL_StartDate,LRL_EndDate into :StartDate,:EndDate from DHC_LocReqLimit 
		where LRL_CTLoc_DR=:LocId and LRL_StartDate<=:Date and LRL_EndDate>=:Date)
	q:(StartDate="")||(EndDate="") ""
	
	s (SumAmt,SumQty)=0
	i LimitType="" d
	.&sql(select sum(LRR_UsedAmt) into :SumAmt from DHC_LocReqRecord 
		where LRR_CTLoc_DR=:LocId and LRR_Date between :StartDate and :EndDate)
	e  i LimitType=1 d
	.&sql(select sum(LRRI_UsedAmt),sum(LRRI_UsedQty) into :SumAmt,:SumQty from DHC_LocReqRecorditm 
		where LRRI_Scg_Dr=:LimitDataId and LRRI_Parrfe->LRR_CTLoc_DR=:LocId 
		and LRRI_Parrfe->LRR_Date between :StartDate and :EndDate)
	e  i LimitType=2 d
	.&sql(select sum(LRRI_UsedAmt),sum(LRRI_UsedQty) into :SumAmt,:SumQty from DHC_LocReqRecorditm 
		where LRRI_Cat_Dr=:LimitDataId and LRRI_Parrfe->LRR_CTLoc_DR=:LocId 
		and LRRI_Parrfe->LRR_Date between :StartDate and :EndDate)
	e  i LimitType=3 d
	.&sql(select sum(LRRI_UsedAmt),sum(LRRI_UsedQty) into :SumAmt,:SumQty from DHC_LocReqRecorditm 
		where LRRI_Inci_Dr=:LimitDataId and LRRI_Parrfe->LRR_CTLoc_DR=:LocId 
		and LRRI_Parrfe->LRR_Date between :StartDate and :EndDate)
	s:SumAmt="" SumAmt=0
	s:SumQty="" SumQty=0
	q SumAmt_"^"_SumQty
}

/// Descript:	查询科室限额明细数据
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		DHC_LocItmLimitAmt
/// Input:		
/// Return：	科室限额明细数据
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocLimitAmt","QueryLocLimitDetail","{""Parref"":""5868"",""LimitType"":1,""BDPHospital"":""2"",""StkGrpId"":"""",""InciDesc"":""""}")
Query QueryLocLimitDetail(Params As %String) As Query(ROWSPEC = "RowId,ScgId,CatId,InciId,Code,Desc,PUomDesc,ReqAmt:%Float,ReqQty:%Float,OnceReqQty:%Float,UsedAmt:%Float,UsedQty:%Float") [ SqlProc ]
{
}

ClassMethod QueryLocLimitDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s Parref=PJObj.%Get("Parref")
	s LimitType=PJObj.%Get("LimitType")
	s pStkGrpId=PJObj.%Get("StkGrpId")
	s pInciDesc=PJObj.%Get("InciDesc")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s LocId=$p(^DHCLRL(Parref),"^",1)
	s StartDate=$zd($p(^DHCLRL(Parref),"^",2),3)
	s Year=$p(StartDate,"-",1)
	s pStartDate=Year_"-01-01"
	s pStartDate=$zdh(pStartDate,3)
	s pEndDate=Year_"-12-31"
	s pEndDate=$zdh(pEndDate,3)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),LocId,"",pHospId)
	i ScgStr="" Quit $$$OK
	
	s len=$l(ScgStr,"^")
	i LimitType=1 d
	.f i=1:1:len d
	..s ScgId=$p(ScgStr,"^",i)
	..s Code=$p(^DHCSCG(ScgId),"^",1)
	..s Desc=$p(^DHCSCG(ScgId),"^",2)
	..s chl=$o(^DHCLRL(0,"Scg",ScgId,Parref,""))
	..s (RowId,ReqAmt,UsedAmt)=""
	..i (pStartDate<=+$h)&&(pEndDate>=+$h) d
	...s UsedAmt=$p(..GetPeriorUsed(LocId,+$h,1,ScgId),"^",1)
	..i chl'="" d
	...s RowId=Parref_"||"_chl
	...s ReqAmt=$p(^DHCLRL(Parref,"LRLI",chl),"^",6)
	...;s UsedAmt=$p(^DHCLRL(Parref,"LRLI",chl),"^",7)
	..d OutPutRow2
	e  i LimitType=2 d
	.f i=1:1:len d
	..s pScgId=$p(ScgStr,"^",i)
	..s relachl=0
	..f  s relachl=$o(^DHCSCG(pScgId,"RE",relachl)) q:(relachl="")  d
	...s CatId=$p(^DHCSCG(pScgId,"RE",relachl),"^",1)
	...s Code=$p(^INC("SC",CatId),"^",1)
	...s Desc=$p(^INC("SC",CatId),"^",2)
	...s chl=$o(^DHCLRL(0,"Cat",CatId,Parref,0))
	...s (RowId,ReqAmt,UsedAmt)=""
	...s UsedAmt=""
	...i (pStartDate<=+$h)&&(pEndDate>=+$h) d
	....s UsedAmt=$p(..GetPeriorUsed(LocId,+$h,2,CatId),"^",1)
	...i chl'="" d
	....s RowId=Parref_"||"_chl
	....s ReqAmt=$p(^DHCLRL(Parref,"LRLI",chl),"^",6)
	....;s UsedAmt=$p(^DHCLRL(Parref,"LRLI",chl),"^",7)
	...d OutPutRow2
	e  i LimitType=3 d
	.f i=1:1:len d
	..s ScgId=$p(ScgStr,"^",i)
	..q:(pStkGrpId'="")&&(pStkGrpId'=ScgId)
	..s relachl=0
	..f  s relachl=$o(^DHCSCG(ScgId,"RE",relachl)) q:(relachl="")  d
	...s CatId=$p(^DHCSCG(ScgId,"RE",relachl),"^",1)
	...s InciId=0
	...f  s InciId=$o(^INCI(0,"StkCat",CatId,InciId)) q:(InciId="")  d
	....s NotUseFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetNotUseFlag(InciId)
	....q:NotUseFlag="Y"
	....s Code=$p(^INCI(InciId,1),"^",1)
	....s Desc=$p(^INCI(InciId,1),"^",2)
	....q:(pInciDesc'="")&&(Desc'[pInciDesc)
	....s BUomId=$p(^INCI(InciId,1),"^",10)
	....s PUomId=$p(^INCI(InciId,3),"^",6)
	....s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	....s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	....s chl=$o(^DHCLRL(0,"Inci",InciId,Parref,0))
	....s (RowId,ReqAmt,UsedAmt,ReqQty,OnceReqQty,UsedQty)=""
	....i (pStartDate<=+$h)&&(pEndDate>=+$h) d
	.....s UsedInfo=..GetPeriorUsed(LocId,+$h,3,InciId)
	.....s UsedAmt=$p(UsedInfo,"^",1)
	.....s UsedQty=$p(UsedInfo,"^",2)
	.....s:UsedQty'="" UsedQty=UsedQty/Fac
	....i chl'="" d
	.....s RowId=Parref_"||"_chl
	.....s ReqAmt=$p(^DHCLRL(Parref,"LRLI",chl),"^",6)
	.....s ReqQty=$p(^DHCLRL(Parref,"LRLI",chl),"^",10)	//基本单位数量
	.....s OnceReqQty=$p(^DHCLRL(Parref,"LRLI",chl),"^",11)	//基本单位数量
	.....;s UsedAmt=$p(^DHCLRL(Parref,"LRLI",chl),"^",7)
	.....;s UsedQty=$p(^DHCLRL(Parref,"LRLI",chl),"^",12)
	.....;s:UsedQty'="" UsedQty=UsedQty/Fac
	.....s:ReqQty'="" ReqQty=ReqQty/Fac
	.....s:OnceReqQty'="" OnceReqQty=OnceReqQty/Fac
	....d OutPutRow2
	
	Quit $$$OK
OutPutRow2
	s Data=$lb(RowId,ScgId,CatId,InciId,Code,Desc,PUomDesc,ReqAmt,ReqQty,OnceReqQty,UsedAmt,UsedQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	更新周期模式及相关日期金额
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.LocLimitAmt).jsUpdatePeriod(^templxt("jsUpdatePeriod"))
ClassMethod jsUpdatePeriod(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..UpdatePeriod(Params)
	q RtnObj.Json()
}

/// Descript:	更新周期模式及相关日期金额
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		DHC_LocReqLimit
/// Input:		
/// Return：	RtnObj
ClassMethod UpdatePeriod(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".UpdatePeriod"
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!","",0)

	s pYear=PJObj.%Get("Year")
	s pPeriodType=PJObj.%Get("PeriodType")
	s pLimitAmt=PJObj.%Get("LimitAmt")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	i pPeriodType=1 d
	.s num=12
	e  i pPeriodType=2 d
	.s num=3
	e  i pPeriodType=3 d
	.s num=1
	
	s pStartDate=pYear_"-01-01"
	s pStartDate=$zdh(pStartDate,3)
	s pEndDate=pYear_"-12-31"
	s pEndDate=$zdh(pEndDate,3)
	
	ts
	s LocId=0
	f  s LocId=$o(^CTLOC(LocId)) q:(LocId="")||(RtnObj.success<0)  d
	.q:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(LocId,pHospId)'=0)
	.q:(##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(LocId)="Y")
	.s Flag=..CheckYearExist(LocId,pYear)
	.i Flag="Y" d
	..&sql(delete from DHC_LocReqLimit where LRL_StartDate>=:pStartDate and LRL_EndDate<=:pEndDate)
	..i SQLCODE'=0 d RtnObj.Err(-2,"","删除当前年份历史数据失败！")
	.f month=1:num:12 q:(RtnObj.success<0)  d
	..s StartDate=pYear_"-"_month_"-01"
	..s StartDate=$zdh(StartDate,3)
	..s NextStartDate=$SYSTEM.SQL.DATEADD("mm",num,StartDate)
	..s EndDate=$zdh(NextStartDate,3)-1
	..s obj=##class(User.DHCLocReqLimit).%New()
	..d obj.LRLCTLocDRSetObjectId(LocId)
	..s obj.LRLStartDate=StartDate
	..s obj.LRLEndDate=EndDate
	..s obj.LRLReqAmt=pLimitAmt
	..s obj.LRLUsedAmt=0
	..s obj.LRLPeriodType=pPeriodType
	..s Sc=obj.%Save()
	..i $$$ISERR(Sc) d RtnObj.Err(-2,"",MethodName_":更新失败!")
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// 当前年份是否已生成
/// w ##class(web.DHCSTMHUI.LocLimitAmt).CheckYearExist(1,"2021")
ClassMethod CheckYearExist(LocId, Year)
{
	n (LocId,Year)
	s Flag="N"
	s LastYear=Year-1
	s LastDate=LastYear_"-12-31"
	s LastDate=$zdh(LastDate,3)
	
	s NextDate=$o(^DHCLRL(0,"LOCDATE",LocId,LastDate))
	q:NextDate="" Flag
	
	s NextDate=$zd(NextDate,3)
	s NextYear=$p(NextDate,"-",1)
	
	s:NextYear=Year Flag="Y"
	q Flag
}

/// Descript:	保存科室限额
/// 对象类型数据
ClassMethod jsSave(Detail As %String) As %String
{
	n (Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Detail)
	q RtnObj.Json()
}

/// Descript:	保存科室限额
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		DHC_LocReqLimit
/// Input:		
/// Return：	RtnObj
ClassMethod Save(Detail As %String) As RtnObj
{
	n (Detail)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!","",0)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s LocId=Obj.%Get("LocId")
		s StartDate=Obj.%Get("StartDate")
		s EndDate=Obj.%Get("EndDate")
		s ReqAmt=Obj.%Get("ReqAmt")
		s LimitTypeId=Obj.%Get("LimitTypeId")
		s StartDate=..DH2L(StartDate)
		s EndDate=..DH2L(EndDate)
		
		s LocStocflag=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(LocId)
		i LocStocflag="Y" d RtnObj.Err(-2,"","库房不需要设置限额","",0)
		q:RtnObj.success<0
		
		&sql(update DHC_LocReqLimit set LRL_ReqAmt=:ReqAmt where LRL_CTLoc_DR=:LocId 
			and LRL_StartDate>=:StartDate and LRL_EndDate<=:EndDate)
		i SQLCODE'=0 d RtnObj.Err(-3,"",MethodName_":更新限额失败!")
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	保存科室限额明细信息
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.LocLimitAmt).jsSaveDetail(^templxt("jsSaveDetail1"),^templxt("jsSaveDetail2"))
ClassMethod jsSaveDetail(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveDetail(Main,Detail)
	q RtnObj.Json()
}

/// Descript:	保存科室限额明细信息
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		DHC_LocItmLimitAmt
/// Input:		
/// Return：	RtnObj
/// w ##class(web.DHCSTMHUI.LocLimitAmt).SaveDetail(^templxt("mm11"),^templxt("mm22"))
ClassMethod SaveDetail(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".SaveDetail"
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	s LRLRowId=MainObj.%Get("RowId")
	q:LRLRowId="" RtnObj.Err(-2,"","未选择科室","",0)
	s pLocId=MainObj.%Get("LocId")
	s pStartDate=MainObj.%Get("StartDate")
	s pEndDate=MainObj.%Get("EndDate")
	s pLimitType=MainObj.%Get("LimitType")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-2,"","明细解析失败!")
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s ScgId=Obj.%Get("ScgId")
		s CatId=Obj.%Get("CatId")
		s InciId=Obj.%Get("InciId")
		s ReqAmt=Obj.%Get("ReqAmt")
		s OnceReqQty=Obj.%Get("OnceReqQty")
		s ReqQty=Obj.%Get("ReqQty")
		i (ScgId="")&&(CatId="")&&(InciId="") d RtnObj.Err(-3,"",MethodName_"：未选择可用限额信息","",0)
		q:RtnObj.success<0
		;i (ReqAmt="")&&(OnceReqQty="")&&(ReqQty="") d RtnObj.Err(-4,"",MethodName_"：未录入限额信息")
		;q:RtnObj.success<0
		s UomId=""
		i InciId'="" d		//按入库单位展示，按基本单位保存
		.s BUomId=$p(^INCI(InciId,1),"^",10)
		.s PUomId=$p(^INCI(InciId,3),"^",6)
		.s UomId=BUomId
		.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
		.s:OnceReqQty'="" OnceReqQty=OnceReqQty*Fac
		.s:ReqQty'="" ReqQty=ReqQty*Fac
		s StartDate=pStartDate-1
		f  s StartDate=$o(^DHCLRL(0,"LOCDATE",pLocId,StartDate)) q:(StartDate="")||(StartDate>pEndDate)||(RtnObj.success<0)  d
		.s EndDate=$o(^DHCLRL(0,"LOCDATE",pLocId,StartDate,0))
		.s Parref=$o(^DHCLRL(0,"LOCDATE",pLocId,StartDate,EndDate,0))
		.i pLimitType=1 d
		..s chl=$o(^DHCLRL(0,"Scg",ScgId,Parref,0))
		.e  i pLimitType=2 d
		..s chl=$o(^DHCLRL(0,"Cat",CatId,Parref,0))
		.e  i pLimitType=3 d
		..s chl=$o(^DHCLRL(0,"Inci",InciId,Parref,0))
		.i chl'="" d
		..s RowId=Parref_"||"_chl
		..&sql(update DHC_LocItmLimitAmt set LRLI_StartDate=:StartDate,LRLI_EndDate=:EndDate,LRLI_ReqAmt=:ReqAmt,LRLI_Scg_Dr=:ScgId,LRLI_Cat_Dr=:CatId,LRLI_Inci_Dr=:InciId,LRLI_CTUOM_DR=:UomId,LRLI_OnceReqQty=:OnceReqQty,LRLI_ReqQty=:ReqQty 
			where %ID=:RowId)
		.e  d
		..s chl=$o(^DHCLRL(Parref,"LRLI",""),-1)
		..s chl=+chl+1
		..&sql(insert into DHC_LocItmLimitAmt(LRLI_ParRef,LRLI_ChildSub,LRLI_StartDate,LRLI_EndDate,LRLI_ReqAmt,LRLI_Scg_Dr,LRLI_Cat_Dr,LRLI_Inci_Dr,LRLI_LimitType,LRLI_CTUOM_DR,LRLI_OnceReqQty,LRLI_ReqQty) 
			values(:Parref,:chl,:StartDate,:EndDate,:ReqAmt,:ScgId,:CatId,:InciId,:pLimitType,:UomId,:OnceReqQty,:ReqQty))
		.i SQLCODE'=0 d RtnObj.Err(-2,"",MethodName_":更新失败!")
		.q:RtnObj.success<0
		q:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	获取统计方式
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		
/// Input:		
/// Return：	
ClassMethod GetLimitTypeDesc(LimitTypeId As %String) As %String
{
	n (LimitTypeId)
	s LimitTypeDesc=""
	s:LimitTypeId=1 LimitTypeDesc="按类组"
	s:LimitTypeId=2 LimitTypeDesc="按库存分类"
	s:LimitTypeId=3 LimitTypeDesc="按品种"
	q LimitTypeDesc
}

/// Descript:	更新科室已用额度
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		
/// Input:		
/// Return：	0:成功;否则失败
/// w ##class(web.DHCSTMHUI.LocLimitAmt).UpLocUsedAmt(21).Json()
ClassMethod UpLocUsedAmt(Init As %String) As RtnObj
{
	n (Init,%session)
	s RtnObj=##class(RtnObj).%New()
	q:(Init="") RtnObj.Err(-1,"","出库单不能为空","",0)
	q:'$d(^DHCINIT(Init)) RtnObj.Err(-2,"","出库单不存在","",0)
	
	s paramStr=..sssParamStr()
	s UseLocLimitAmt=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTTRANSFERM","UseLocLimitAmt",paramStr)
	q:(UseLocLimitAmt'="Y") RtnObj
	
	s FrLocId=$p(^DHCINIT(Init),"^",5)
	s ToLocId=$p(^DHCINIT(Init),"^",6)
	s FrLocStocflag=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(FrLocId)
	s ToLocStocflag=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(ToLocId)
	q:((FrLocStocflag="Y")&&(ToLocStocflag="Y")) RtnObj	//库房不使用限额
	q:((FrLocStocflag'="Y")&&(ToLocStocflag'="Y")) RtnObj	//科室间转移暂不考虑
	s LocId=""
	i (ToLocStocflag="Y") s LocId=FrLocId		//退库
	e  s LocId=ToLocId		//出库
	s Date=+$h
	
	s Year=$p($zd(Date,3),"-",1)
	s Flag=..CheckYearExist(LocId,Year)
	q:Flag="N" RtnObj
	//插入限额记录主表
	s MainId=$o(^DHCLRR(0,"LOC",LocId,Date,0))
	i MainId="" d
	.&sql(INSERT INTO DHC_LocReqRecord (LRR_CTLoc_DR, LRR_Date) VALUES(:LocId,:Date))
	.i SQLCODE d RtnObj.Err(-102,"","插入科室限额记录失败")
	.q:RtnObj.success'=0
	.s MainId=$p($g(%ROWID),$c(1))
	q:RtnObj.success'=0 RtnObj
	//获取出库单明细金额、数量信息
	s chl=0,SumRpAmt=0
	f  s chl=$o(^DHCINIT(Init,"ITI",chl)) q:(chl="")||(RtnObj.success'=0)  d
	.q:'$d(^DHCINIT(Init,"ITI",chl))
	.s InitInfo=^DHCINIT(Init,"ITI",chl)
	.s Inclb=$p(InitInfo,"^",3)
	.s InciId=+Inclb
	.s StkScgId=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId),"^",5)
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.s RpAmt=$p(InitInfo,"^",16)
	.s Qty=$p(InitInfo,"^",1)
	.s UomId=$p(InitInfo,"^",7)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	.s Qty=Qty*Fac	//基本单位数量
	.i ToLocStocflag="Y" s RpAmt=-RpAmt,Qty=-Qty	//退库
	.s SumRpAmt=SumRpAmt+RpAmt
	.//更新限额记录子表
	.s LRRIChl=$o(^DHCLRR(0,"inci",InciId,MainId,0))
	.i LRRIChl="" d
	..s LRRIChl=1+$o(^DHCLRR(MainId,"LRRI",""),-1)
	..s LrrIUsedAmt=RpAmt
	..s LrrIUsedQty=Qty
	..;i LrrIUsedAmt<0 s LrrIUsedAmt=0
	..;i LrrIUsedQty<0 s LrrIUsedQty=0
	..&sql(insert into DHC_LocReqRecorditm(
		lrri_parrfe,Lrri_childSub,lrri_scg_dr,Lrri_cat_dr,lrri_inci_dr,Lrri_UsedAmt,LRRI_UsedQty)
		values
		(:MainId,:LRRIChl,:StkScgId,:StkCatId,:InciId,:LrrIUsedAmt,:LrrIUsedQty))
	..i SQLCODE d RtnObj.Err(-202,"","插入科室已使用限领明细失败")
	.e  d
	..s LrrIUsedAmt=$p(^DHCLRR(MainId,"LRRI",LRRIChl),"^",4)
	..s LrrIUsedQty=$p(^DHCLRR(MainId,"LRRI",LRRIChl),"^",6)
	..s LrrIUsedAmt=LrrIUsedAmt+RpAmt
	..s LrrIUsedQty=LrrIUsedQty+Qty
	..;i LrrIUsedAmt<0 s LrrIUsedAmt=0
	..;i LrrIUsedQty<0 s LrrIUsedQty=0
	..s LRRIId=MainId_"||"_LRRIChl
	..&sql(update DHC_LocReqRecorditm set Lrri_UsedAmt=:LrrIUsedAmt,LRRI_UsedQty=:LrrIUsedQty where %id=:LRRIId)
	..i SQLCODE d RtnObj.Err(-203,"","更新科室已使用限领明细失败")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	//更新限额记录主表
	s (RecordUsedAmt)=0
	&sql(select sum(Lrri_UsedAmt) into :RecordUsedAmt from DHC_LocReqRecorditm where LRRI_Parrfe=:MainId)
	&sql(update DHC_LocReqRecord set LRR_UsedAmt=:RecordUsedAmt where %ID=:MainId)
	i SQLCODE d RtnObj.Err(-205,"","更新科室限额记录失败")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Descript:	获取请求单超过限额物资信息
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		
/// Input:		
/// Return：	科室总额是否超限(Y/""),科室分类超限(类组/库存分类/物资)IdStr
/// w ##class(web.DHCSTMHUI.LocLimitAmt).GetLimitAmtByReq(35)
ClassMethod GetLimitAmtByReq(ReqId As %String) As %String
{
	n (ReqId)
	s RtnObj=##class(RtnObj).%New()
	q:(ReqId="") RtnObj.Err(-1,"","请选择请求单！","",0).Json()
	q:'$d(^INRQ(ReqId)) RtnObj.Err(-1,"","请求单不存在","",0).Json()
	
	s TemplateFlag="N"
	s dhcReqId=$o(^DHCINRQ(0,"INRQ",ReqId,0))
	i dhcReqId'="" d
	.s TemplateFlag=$p(^DHCINRQ(dhcReqId),"^",18)
	q:TemplateFlag="Y" RtnObj.Json()
	
	s LocId=$p(^INRQ(ReqId),"^",6)
	s LocStocflag=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(LocId)
	q:LocStocflag="Y" RtnObj.Json()			//库房申请不判断
	
	s HospId=..sssHospId(LocId)
	s Date=+$h
	s (StartDate,EndDate)=""
	&sql(select %ID,LRL_StartDate,LRL_EndDate into :LimitId,:StartDate,:EndDate from DHC_LocReqLimit where LRL_CTLoc_DR=:LocId and LRL_StartDate<=:Date and LRL_EndDate>=:Date)
	q:LimitId="" RtnObj.Json()
	
	s Pid=..NewPid()
	k ^DHCSTMPID("LocLimit")
	s sumRpAmt=0
	s chl=0
	f  s chl=$o(^INRQ(ReqId,"RQI",chl)) q:chl=""  d
	.s InciId=$p(^INRQ(ReqId,"RQI",chl),"^",4)
	.s UomId=$p(^INRQ(ReqId,"RQI",chl),"^",5)
	.s Qty=$p(^INRQ(ReqId,"RQI",chl),"^",3)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(InciId,UomId,HospId)
	.s RpAmt=Rp*Qty
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	.s Qty=Qty*Fac	//基本单位数量
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.s StkScgId=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId),"^",5)
	.s sumRpAmt=sumRpAmt+RpAmt
	.//类组
	.i '$d(^DHCSTMPID("LocLimit",Pid,"Scg",StkScgId)) d
	..s ^DHCSTMPID("LocLimit",Pid,"Scg",StkScgId)=RpAmt
	.e  d
	..s ^DHCSTMPID("LocLimit",Pid,"Scg",StkScgId)=^DHCSTMPID("LocLimit",Pid,"Scg",StkScgId)+RpAmt
	.//库存分类
	.i '$d(^DHCSTMPID("LocLimit",Pid,"Cat",StkCatId)) d
	..s ^DHCSTMPID("LocLimit",Pid,"Cat",StkCatId)=RpAmt
	.e  d
	..s ^DHCSTMPID("LocLimit",Pid,"Cat",StkCatId)=^DHCSTMPID("LocLimit",Pid,"Cat",StkCatId)+RpAmt
	.//品种
	.i '$d(^DHCSTMPID("LocLimit",Pid,"Inci",InciId)) d
	..s ^DHCSTMPID("LocLimit",Pid,"Inci",InciId)=RpAmt_"^"_Qty
	.e  d
	..s RpAmt=$p(^DHCSTMPID("LocLimit",Pid,"Inci",InciId),"^",1)+RpAmt
	..s Qty=$p(^DHCSTMPID("LocLimit",Pid,"Inci",InciId),"^",2)+Qty
	..s ^DHCSTMPID("LocLimit",Pid,"Inci",InciId)=RpAmt_"^"_Qty
	.
	s ^DHCSTMPID("LocLimit",Pid,"Sum")=sumRpAmt
	s Result=..GetLimitAmt(LimitId,LocId,Date,Pid)
	
	q Result
}

/// Descript:	获取转移单超过限额物资信息
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		
/// Input:		
/// Return：	科室总额是否超限(Y/""),科室分类超限(类组/库存分类/物资)IdStr
/// w ##class(web.DHCSTMHUI.LocLimitAmt).GetLimitAmtByInit(368)
ClassMethod GetLimitAmtByInit(InitId As %String) As %String
{
	n (InitId)
	s RtnObj=##class(RtnObj).%New()
	q:(InitId="") RtnObj.Err(-1,"","请选择转移单！","",0).Json()
	q:'$d(^DHCINIT(InitId)) RtnObj.Err(-1,"","转移单不存在","",0).Json
	
	s FrLocId=$p(^DHCINIT(InitId),"^",5)
	s ToLocId=$p(^DHCINIT(InitId),"^",6)
	s FrLocStocflag=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(FrLocId)
	s ToLocStocflag=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(ToLocId)
	q:((FrLocStocflag="Y")&&(ToLocStocflag="Y")) RtnObj.Json()		//库房不使用限额
	q:((FrLocStocflag'="Y")&&(ToLocStocflag'="Y")) RtnObj.Json()	//科室间转移暂不考虑
	q:ToLocStocflag="Y" RtnObj.Json()								//退库不需要判断
	
	s LocId=""
	i (ToLocStocflag="Y") s LocId=FrLocId		//退库
	e  s LocId=ToLocId		//出库
	
	s HospId=..sssHospId(LocId)
	s Date=+$h
	s (StartDate,EndDate,LimitId)=""
	&sql(select %ID,LRL_StartDate,LRL_EndDate into :LimitId,:StartDate,:EndDate from DHC_LocReqLimit where LRL_CTLoc_DR=:LocId and LRL_StartDate<=:Date and LRL_EndDate>=:Date)
	q:LimitId="" RtnObj.Json()
	
	s Pid=..NewPid()
	k ^DHCSTMPID("LocLimit")
	s sumRpAmt=0
	s chl=0
	f  s chl=$o(^DHCINIT(InitId,"ITI",chl)) q:chl=""  d
	.s InitInfo=^DHCINIT(InitId,"ITI",chl)
	.s Inclb=$p(InitInfo,"^",3)
	.s InciId=+Inclb
	.s Qty=$p(InitInfo,"^",1)
	.s UomId=$p(InitInfo,"^",7)
	.s RpAmt=$p(InitInfo,"^",16)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	.s Qty=Qty*Fac	//基本单位数量
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.s StkScgId=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId),"^",5)
	.s sumRpAmt=sumRpAmt+RpAmt
	.//类组
	.i '$d(^DHCSTMPID("LocLimit",Pid,"Scg",StkScgId)) d
	..s ^DHCSTMPID("LocLimit",Pid,"Scg",StkScgId)=RpAmt
	.e  d
	..s ^DHCSTMPID("LocLimit",Pid,"Scg",StkScgId)=^DHCSTMPID("LocLimit",Pid,"Scg",StkScgId)+RpAmt
	.//库存分类
	.i '$d(^DHCSTMPID("LocLimit",Pid,"Cat",StkCatId)) d
	..s ^DHCSTMPID("LocLimit",Pid,"Cat",StkCatId)=RpAmt
	.e  d
	..s ^DHCSTMPID("LocLimit",Pid,"Cat",StkCatId)=^DHCSTMPID("LocLimit",Pid,"Cat",StkCatId)+RpAmt
	.//品种
	.i '$d(^DHCSTMPID("LocLimit",Pid,"Inci",InciId)) d
	..s ^DHCSTMPID("LocLimit",Pid,"Inci",InciId)=RpAmt_"^"_Qty
	.e  d
	..s RpAmt=$p(^DHCSTMPID("LocLimit",Pid,"Inci",InciId),"^",1)+RpAmt
	..s Qty=$p(^DHCSTMPID("LocLimit",Pid,"Inci",InciId),"^",2)+Qty
	..s ^DHCSTMPID("LocLimit",Pid,"Inci",InciId)=RpAmt_"^"_Qty
	.
	s ^DHCSTMPID("LocLimit",Pid,"Sum")=sumRpAmt
	s Result=..GetLimitAmt(LimitId,LocId,Date,Pid)
	
	q Result
}

ClassMethod GetLimitAmt(LimitId, LocId, Date, Pid)
{
	n (LimitId,LocId,Date,Pid)
	s (ResultLoc,ResultScg,ResultCat,ResultInci,ResultInciQty,ResultInciOnceQty)=""
	
	i '$d(^DHCSTMPID("LocLimit",Pid)) q ""
	//判断科室限额
	s sumRpAmt=^DHCSTMPID("LocLimit",Pid,"Sum")
	s LocReqAmt=$p(^DHCLRL(LimitId),"^",4)
	s LocUsedAmt=$p(..GetPeriorUsed(LocId,Date),"^",1)
	i LocReqAmt'="" d
	.s LocUsedAmt=LocUsedAmt+sumRpAmt
	.i (LocUsedAmt>LocReqAmt) d
	..s LocDesc=$p(^CTLOC(LocId),"^",2)
	..s ResultLoc=LocDesc
	//判断科室类组限额
	s ScgId=0
	f  s ScgId=$o(^DHCSTMPID("LocLimit",Pid,"Scg",ScgId)) q:(ScgId="")  d
	.s RpAmt=^DHCSTMPID("LocLimit",Pid,"Scg",ScgId)
	.s LimitChl=$o(^DHCLRL(0,"Scg",ScgId,LimitId,0))
	.q:LimitChl=""
	.s ScgDesc=$p(^DHCSCG(ScgId),"^",2)
	.s ScgReqAmt=$p(^DHCLRL(LimitId,"LRLI",LimitChl),"^",6)
	.q:ScgReqAmt=""
	.s ScgUsedAmt=+$p(..GetPeriorUsed(LocId,Date,1,ScgId),"^",1)
	.s ScgUsedAmt=ScgUsedAmt+RpAmt
	.i (ScgUsedAmt>ScgReqAmt) d
	..s ResultScg=ResultScg_" "_ScgDesc
	//判断科室库存分类限额
	s CatId=0
	f  s CatId=$o(^DHCSTMPID("LocLimit",Pid,"Cat",CatId)) q:(CatId="")  d
	.s RpAmt=^DHCSTMPID("LocLimit",Pid,"Cat",CatId)
	.s LimitChl=$o(^DHCLRL(0,"Cat",CatId,LimitId,0))
	.q:LimitChl=""
	.s CatDesc=$p(^INC("SC",CatId),"^",2)
	.s CatReqAmt=$p(^DHCLRL(LimitId,"LRLI",LimitChl),"^",6)
	.q:CatReqAmt=""
	.s CatUsedAmt=+$p(..GetPeriorUsed(LocId,Date,2,CatId),"^",1)
	.s CatUsedAmt=CatUsedAmt+RpAmt
	.i (CatUsedAmt>CatReqAmt) d
	..s ResultCat=ResultCat_" "_CatDesc
	//判断科室品种限额和限量
	s InciId=0
	f  s InciId=$o(^DHCSTMPID("LocLimit",Pid,"Inci",InciId)) q:(InciId="")  d
	.s RpAmt=$p(^DHCSTMPID("LocLimit",Pid,"Inci",InciId),"^",1)
	.s Qty=$p(^DHCSTMPID("LocLimit",Pid,"Inci",InciId),"^",2)
	.s LimitChl=$o(^DHCLRL(0,"Inci",InciId,LimitId,0))
	.q:LimitChl=""
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s InciReqAmt=$p(^DHCLRL(LimitId,"LRLI",LimitChl),"^",6)
	.s InciOnceReqQty=$p(^DHCLRL(LimitId,"LRLI",LimitChl),"^",11)
	.s InciReqQty=$p(^DHCLRL(LimitId,"LRLI",LimitChl),"^",10)
	.q:(InciReqAmt="")&&(InciOnceReqQty="")&&(InciReqQty="")
	.s InciUsedAmt=+$p(..GetPeriorUsed(LocId,Date,3,InciId),"^",1)
	.s InciUsedQty=+$p(..GetPeriorUsed(LocId,Date,3,InciId),"^",2)
	.s InciUsedAmt=InciUsedAmt+RpAmt
	.s InciUsedQty=InciUsedQty+Qty
	.i (InciUsedAmt>InciReqAmt) d
	..s ResultInci=ResultInci_" "_InciDesc
	.i (InciUsedQty>InciReqQty) d
	..s ResultInciQty=ResultInciQty_" "_InciDesc
	.i (Qty>InciOnceReqQty) d
	..s ResultInciOnceQty=ResultInciOnceQty_" "_InciDesc
	
	s Title="ResultLoc^ResultScg^ResultCat^ResultInci^ResultInciQty^ResultInciOnceQty"
	s Data=ResultLoc_"^"_ResultScg_"^"_ResultCat_"^"_ResultInci_"^"_ResultInciQty_"^"_ResultInciOnceQty
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	q Result
}

/// Descript:	获取底层科室限额和剩余限额
/// Creator:	lxt
/// CreateDate:	2020-07-14
/// Table:		
/// Input:		
/// Return：	科室总限额^科室总剩余额度^统计方式^按统计方式总限额^按统计方式剩余额度
/// w ##class(web.DHCSTMHUI.LocLimitAmt).GetLimitAmtStr(114,17)
ClassMethod GetLimitAmtStr(LocId As %String, InciId As %String = "") As %String
{
	n (LocId,InciId)
	q:(LocId="") ""
	
	s Date=+$h
	s (LimitId,StartDate,EndDate,ReqAmt,LeftAmt,ScgReqAmt,ScgLeftAmt,CatReqAmt,CatLeftAmt,InciReqAmt,InciLeftAmt)=""
	&sql(select %ID,LRL_ReqAmt,LRL_StartDate,LRL_EndDate into :LimitId,:ReqAmt,:StartDate,:EndDate from DHC_LocReqLimit where LRL_CTLoc_DR=:LocId and LRL_StartDate<=:Date and LRL_EndDate>=:Date)
	q:LimitId="" ""
	
	s StkCatId=$p(^INCI(InciId,2),"^",2)
	s StkScgId=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId),"^",5)
	
	s Result=""
	s InciLimitChl=$o(^DHCLRL(0,"Inci",InciId,LimitId,0))
	i InciLimitChl'="" s InciReqAmt=$p(^DHCLRL(LimitId,"LRLI",InciLimitChl),"^",6)
	i InciReqAmt'="" d
	.s InciUsedAmt=+$p(..GetPeriorUsed(LocId,Date,3,InciId),"^",1)
	.s InciLeftAmt=InciReqAmt-InciUsedAmt
	.i InciLeftAmt<0 s InciLeftAmt=0
	.s Result="品种"_"^"_InciReqAmt_"^"_InciLeftAmt
	q:Result'="" Result
	
	s CatLimitChl=$o(^DHCLRL(0,"Cat",StkCatId,LimitId,0))
	i CatLimitChl'="" s CatReqAmt=$p(^DHCLRL(LimitId,"LRLI",CatLimitChl),"^",6)
	i CatReqAmt'="" d
	.s CatUsedAmt=+$p(..GetPeriorUsed(LocId,Date,2,StkCatId),"^",1)
	.s CatLeftAmt=CatReqAmt-CatUsedAmt
	.i CatLeftAmt<0 s CatLeftAmt=0
	.s Result="库存分类"_"^"_CatReqAmt_"^"_CatLeftAmt
	q:Result'="" Result
	
	s ScgLimitChl=$o(^DHCLRL(0,"Scg",StkScgId,LimitId,0))
	i ScgLimitChl'="" s ScgReqAmt=$p(^DHCLRL(LimitId,"LRLI",ScgLimitChl),"^",6)
	i ScgReqAmt'="" d
	.s ScgUsedAmt=+$p(..GetPeriorUsed(LocId,Date,1,StkScgId),"^",1)
	.s ScgLeftAmt=ScgReqAmt-ScgUsedAmt
	.i ScgLeftAmt<0 s ScgLeftAmt=0
	.s Result="类组"_"^"_ScgReqAmt_"^"_ScgLeftAmt
	q:Result'="" Result
	
	i ReqAmt'="" d
	.s UsedAmt=+$p(..GetPeriorUsed(LocId,Date),"^",1)
	.s LeftAmt=ReqAmt-UsedAmt
	.i LeftAmt<0 s LeftAmt=0
	.s Result="科室"_"^"_ReqAmt_"^"_LeftAmt
	q:Result'="" Result
	
	q Result
}

}
