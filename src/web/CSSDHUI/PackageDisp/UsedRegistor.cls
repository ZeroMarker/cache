Import sqluser

/// Creator:ban
/// CreatDate:2020-6-19
/// Description:消毒包领用登记界面后台类编写
/// Table:CSSD_PackageDispMain
Class web.CSSDHUI.PackageDisp.UsedRegistor Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.UsedRegistor","SelectAll","{""FStartDate"":""2023-03-06"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FEndDate"":""2023-04-23"",""UsedName"":""11889"",""ReturnedName"":"""",""Label"":""""}")
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,RegDate,RegUserName,Label,PkgId,PkgDesc,ToUserName,RecDate,ToLocName,ReturnUserName,ReturnDate,MaterialDesc,ValidDate,PackDate") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s PLabel=PJObj.%Get("Label")
	s FStartDate=PJObj.%Get("FStartDate")
	s FEndDate=PJObj.%Get("FEndDate")
	s PRegUserId=PJObj.%Get("UsedName")
	s PReturnUserId=PJObj.%Get("ReturnedName")
	s:FStartDate'="" StartDate=..DH2L(FStartDate)
	s:FEndDate'="" EndDate=..DH2L(FEndDate)
	s SqlStr= " SELECT CSSDPD_Rowid as rowId, CSSDPD_UseDate as regDate,CSSDPD_UseTime as regTime,CSSDPD_InnurseDr as RegUserId, "
				_" CSSDPD_Label as label,CSSDPD_Package_DR as pkgDr ,CSSDPD_Package_DR->CSSDP_Desc as packageName,CSSDPD_DispDate as recDate,"
				_" CSSDPD_ToUser_DR->SSUSR_Name as toUserName,CSSDPD_DispTime, CSSDPD_Parref_DR->CSSDPDM_ToLoc_DR->CTLOC_Desc as toLocName,"
				_" CSSDPD_InurBrDr as ReturnUserId,CSSDPD_ReturnDate as ReturnDate,CSSDPD_ReturnTime as ReturnTime"
				_" FROM cssd_packagedisp"
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId=result.Data("rowId")
		s PkgId=result.Data("pkgDr")
		s ToUserName=result.Data("toUserName")
		s RecDate=result.Data("recDate")
		s ToLocName=result.Data("toLocName")
		s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
		s AttributeId=PkgObj.CSSDPPackTypeDetail
		s PkgDesc=PkgObj.CSSDPDesc
		s count=0,DispDetailId=""
		f  s DispDetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",RowId,DispDetailId)) q:DispDetailId=""  d
		.s DetailObj=##Class(User.CSSDPackageDispDetail).%OpenId(DispDetailId)
		.q:'$IsObject(DetailObj)
		.s Label=DetailObj.CSSDPDDLabel
		.s RegDate=DetailObj.CSSDPDDUseDate
		.s RegTime=DetailObj.CSSDPDDUseTime
		.s RegUserId=DetailObj.CSSDPDDInnurseDrGetObjectId()
		.s ReturnDate=DetailObj.CSSDPDDReturnDate
		.s ReturnTime=DetailObj.CSSDPDDReturnTime
		.s ReturnUserId=DetailObj.CSSDPDDInurBrDrGetObjectId()
		.s count=count+1
		.d OutPutRow
		i count=0 d
		.s Label=result.Data("label")
		.s RegDate=result.Data("regDate")
		.s RegTime=result.Data("regTime")
		.s RegUserId=result.Data("RegUserId")
		.s ReturnDate=result.Data("ReturnDate")
		.s ReturnTime=result.Data("ReturnTime")
		.s ReturnUserId=result.Data("ReturnUserId")
		.d OutPutRow
	}
	d result.Close()
	Quit $$$OK
OutPutRow
	q:RegDate=""
	q:((StartDate'="")&&(RegDate<StartDate))
	q:((EndDate'="")&&(RegDate>EndDate))
	q:((PLabel'="")&&(PLabel'=Label))
	q:((PRegUserId'="")&&(PRegUserId'=RegUserId))
	q:((PReturnUserId'="")&&(PReturnUserId'=ReturnUserId))
	i AttributeId=1 d
	.s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	s RegUserName=..sssUserName(RegUserId)
	s ReturnUserName=..sssUserName(ReturnUserId)
	s RegDate=..DL2H(RegDate)
	s RegTime=..TL2H(RegTime)
	s RegDate=RegDate_" "_RegTime
	s ReturnDate=..DL2H(ReturnDate)
	s ReturnTime=..TL2H(ReturnTime)
	s ReturnDate=ReturnDate_" "_ReturnTime
	s transid=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	i transid'="" d
	.s PackTrans=##Class(User.CSSDTrans).%OpenId(transid)
	.s strExpDateD=PackTrans.CSSDTExpDate
	.s ValidDateH=strExpDateD-1
	.s ValidDate=..DL2H(ValidDateH)
	s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	i PackId'="" d
	.s PackDate=$lg(^User.CSSDPackagePackD(PackId),2)
	.s MaterialId=$lg(^User.CSSDPackagePackD(PackId),24)
	.s:PackDate'="" PackDate=..DL2H(PackDate)
	.s:MaterialId'="" MaterialDesc=$lg(^User.CSSDMaterialD(MaterialId),3)
	
	s Data=$lb(RowId,RegDate,RegUserName,Label,PkgId,PkgDesc,ToUserName,RecDate,ToLocName,ReturnUserName,ReturnDate,MaterialDesc,ValidDate,PackDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2020-6-19
/// Description:科室领包登记
/// Table:
/// d ##class(web.CSSDHUI.PackageDisp.UsedRegistor).jsOprUseRegistor("{""UsedDr"":""12833"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""ReturnedDr"":"""",""FStartDate"":""2021-12-02"",""FEndDate"":""2021-12-03"",""UsedName"":""李丽"",""ReturnedName"":"""",""Label"":""41832021120300001""}")
ClassMethod jsOprUseRegistor(Params) As %Library.String
{
	n (Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s $ZT=..sssError()	
	ts
	s RtnObj=..OprUseRegistor(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-6-19
/// Description:科室领包登记,修改登记人信息
/// Table:CSSD_PackageDisp
/// w ##class(web.CSSDHUI.PackageDisp.UsedRegistor).OprUseRegistor()
ClassMethod OprUseRegistor(Params) As web.CSSDHUI.RtnObj
{
	n (Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s RegUserId=PJObj.%Get("UsedName")
	s PLabel=PJObj.%Get("Label")
	
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",PLabel,""))
	i TransId="" d RtnObj.Err(-1,"","未找到该标签！")
	q:RtnObj.success'=0 RtnObj
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	d TransObj.%Reload()
	q:'$IsObject(TransObj)
	s PackStaus=TransObj.CSSDTStatus
	s PackObj=TransObj.CSSDTPack
	s ExpDate=TransObj.CSSDTExpDate
	s SterObj=TransObj.CSSDTSterilize
	s RecallFlag=TransObj.CSSDTSterilize.CSSDPSRecallFlag
	s DispObj=TransObj.CSSDTTrfDR					//先判断调拨
	i '$IsObject(DispObj) s DispObj=TransObj.CSSDTDisp
	
	i '$IsObject(PackObj) q RtnObj.Err(-2,"","未获取到标签包装信息！")
	i +$h>=ExpDate q RtnObj.Err(-3,"","该消毒包已过期，不能使用！")
	i '$IsObject(SterObj) q RtnObj.Err(-4,"","未获取到标签灭菌信息！")
	i RecallFlag="Y" q RtnObj.Err(-5,"","该消毒包已通知召回,不能领用！")
	i '$IsObject(DispObj) q RtnObj.Err(-4,"","未获取到标签发放信息！")
	
	s DispId=DispObj.%Id()
	s Label=DispObj.CSSDPDLabel
	s ToUserId=DispObj.CSSDPDToUserDr
	s NowDate=+$h,NowTime=$p($h,",",2)
	i Label'="" d
	.i PLabel'=Label d RtnObj.Err(-4,"","标签信息错误!") q
	.s InnurBrDr=DispObj.CSSDPDInurBrDr
	.s InnurseDr=DispObj.CSSDPDInnurseDr
	.i ('$IsObject(ToUserId)&&(PackStaus'="R")&&('$IsObject(InnurBrDr))) d RtnObj.Err(-4,"","该消毒包未接收，不能领用！") q
	.i ($IsObject(InnurseDr))&&('$IsObject(InnurBrDr)) d RtnObj.Err(-5,"","该消毒包已经被领用登记并未归还！") q
	.
	.&sql(UPDATE cssd_packagedisp SET CSSDPD_InnurseDr=:RegUserId,
		CSSDPD_UseDate=:NowDate,CSSDPD_UseTime=:NowTime,
		CSSDPD_InRegBrDate=null, CSSDPD_InurBrDr=null,
		CSSDPD_ReturnDate=null,CSSDPD_ReturnTime=null
		WHERE CSSDPD_Label=:PLabel )
	.i SQLCODE'=0  d RtnObj.Err(-7,"","更新领用信息失败！") q
	e  d
	.s DetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParrefCSSDPDDLabel",DispId,PLabel,""))
	.s DetailObj=##Class(User.CSSDPackageDispDetail).%OpenId(DetailId)
	.q:'$IsObject(DetailObj)
	.s InnurseDr=DetailObj.CSSDPDDInnurseDr
	.s InnurBrDr=DetailObj.CSSDPDDInurBrDr
	.i ('$IsObject(ToUserId)&&(PackStaus'="R")&&('$IsObject(InnurBrDr))) d RtnObj.Err(-4,"","该消毒包未接收，不能领用！") q
	.i ($IsObject(InnurseDr))&&('$IsObject(InnurBrDr)) d RtnObj.Err(-5,"","该消毒包已经被领用登记并未归还！") q
	.
	.&sql(UPDATE CSSD_PackageDispDetail SET CSSDPDD_InnurseDr=:RegUserId,
		CSSDPDD_UseDate=:NowDate,CSSDPDD_UseTime=:NowTime,
		 CSSDPDD_InurBrDr=null,CSSDPDD_ReturnDate=null,
		 CSSDPDD_ReturnTime=null
		 WHERE CSSDPDD_Label=:PLabel )
	.i SQLCODE'=0 d RtnObj.Err(-7,"","更新领用信息失败！") q
	q:RtnObj.success'=0 RtnObj
	
	&sql(update cssd_trans set cssdt_status='G' where cssdt_label=:PLabel )
	i SQLCODE'=0 q RtnObj.Err(-8,"","领用操作更新追踪状态信息失败！")

	q RtnObj
}

/// Creator:ban
/// CreatDate:2020-6-19
/// Description:科室领包消毒包进行归还
/// Table:
/// w ##class(web.CSSDHUI.PackageDisp.UsedRegistor).jsOprUseReturn(^templxt("OprUseReturn"))
ClassMethod jsOprUseReturn(Params) As %Library.String
{
	n (Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s $ZT=..sssError()	
	ts
	s RtnObj=..OprUseReturn(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-6-19
/// Description:科室领包消毒包进行归还
/// Table:CSSD_PackageDisp
/// w ##class(web.CSSDHUI.PackageDisp.UsedRegistor).OprUseReturn()
ClassMethod OprUseReturn(Params) As web.CSSDHUI.RtnObj
{
	n (Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s ReturnedDr=PJObj.%Get("ReturnedName")
	s PLabel=PJObj.%Get("Label")


	s TransId= $o(^User.CSSDTransI("CSSDTLabel",PLabel,""))
	i TransId="" d RtnObj.Err(-1,"","未找到该标签！")
	q:RtnObj.success'=0 RtnObj
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	d TransObj.%Reload()
	q:'$IsObject(TransObj)
	s PackStaus=TransObj.CSSDTStatus
	s DispObj=TransObj.CSSDTTrfDR	//先判断调拨
	i '$IsObject(DispObj) s DispObj=TransObj.CSSDTDisp
	d DispObj.%Reload()
	s DispId=DispObj.%Id()
	s Label=DispObj.CSSDPDLabel

	s NowDate=+$h,NowTime=$p($h,",",2)
	i Label'="" d
	.i PLabel'=Label d RtnObj.Err(-4,"","标签信息错误!") q
	.s InnurseDr=DispObj.CSSDPDInnurseDr
	.s InnurBrDr=DispObj.CSSDPDInurBrDr
	.i '$IsObject(InnurseDr) d
	..d RtnObj.Err(-5,"","该消毒包未被领用，不能归还！") q
	.i $IsObject(InnurBrDr) d
	..d RtnObj.Err(-6,"","该消毒包已经被归还，不能再次归还！") q
	.&sql(UPDATE cssd_packagedisp SET 
		CSSDPD_InurBrDr=:ReturnedDr,CSSDPD_ReturnDate=:NowDate,
		CSSDPD_ReturnTime=:NowTime WHERE CSSDPD_Label=:Label )
	.i SQLCODE'=0  d RtnObj.Err(-7,"","更新归还信息失败！") q
	e  d
	.s DetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParrefCSSDPDDLabel",DispId,PLabel,0))
	.s DetailObj=##Class(User.CSSDPackageDispDetail).%OpenId(DetailId)
	.q:'$IsObject(DetailObj)
	.s InnurseDr=DetailObj.CSSDPDDInnurseDr
	.s InnurBrDr=DetailObj.CSSDPDDInurBrDr
	.i '$IsObject(InnurseDr) d
	..d RtnObj.Err(-5,"","该消毒包未被领用，不能归还！") q
	.i $IsObject(InnurBrDr) d
	..d RtnObj.Err(-6,"","该消毒包已经被归还，不能再次归还！") q
	.&sql(UPDATE CSSD_PackageDispDetail SET 
		CSSDPDD_ReturnDate=:NowDate,CSSDPDD_ReturnTime=:NowTime,
		CSSDPDD_InurBrDr=:ReturnedDr WHERE CSSDPDD_Label=:PLabel)
	.i SQLCODE'=0  d RtnObj.Err(-7,"","更新归还信息失败！") q
	q:RtnObj.success'=0 RtnObj

	&sql(update cssd_trans set cssdt_status='R' where cssdt_label=:PLabel)
	i SQLCODE'=0  d RtnObj.Err(-7,"","领用操作更新追踪状态信息失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

}
