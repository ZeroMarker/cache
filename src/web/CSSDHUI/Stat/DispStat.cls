Import sqluser

/// why
/// 2019-08-29
/// 统计发放
Class web.CSSDHUI.Stat.DispStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:按消毒包汇总\按科室汇总\科室消毒包器械明细\科室发放消毒包详情等发放工作量报表后台
/// Creator:why
/// CreateDate:2019-7-11
/// Table:cssd_packagedisp
/// Input:排序，查询条件
/// Return：发放工作量
/// w ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.DispStat","QueryDetail","{""DateType"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""SupLoc"":"""",""RecLoc"":"""",""SterTypeId"":"""",""PkgClassId"":"""",""PkgDesc"":"""",""PkgSpec"":"""",""StartDate"":""2022-11-16"",""StartTime"":"""",""EndDate"":""2022-11-22"",""EndTime"":""""}","")
Query QueryDetail(Params As %Text, PRecLocId As %String) As web.CSSDHUI.Query(ROWSPEC = "ToLocId,ToLocDesc,FromLocId,FromLocDesc,SubmitDateTime,DispNo,DispUserId,DispUserName,DispId,DispPrice:%Float,DispQty:%Float,SumPrice:%Float,PkgId,PkgDesc,PkgClassId,PkgClassDesc,PkgSterTypeId,PkgSterTypeDesc,MaterialId,MaterialDesc,UomDesc,Remark,ItmId,ItmDesc,ItmQty:%Float") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text, PRecLocId As %String = "") As %Status
{
	n (qHandle,Params,PRecLocId)
	s PId=..NewPid()
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PSupLoc=PJObj.%Get("SupLoc")
	s PRecLoc=PJObj.%Get("RecLoc")
	s PPkgClassId=PJObj.%Get("PkgClassId")
	s PPkgId=PJObj.%Get("PkgDesc")
	s PSterTypeId=PJObj.%Get("SterTypeId")
	s PPkgSpecId=PJObj.%Get("PkgSpec")
	s gHospId=PJObj.%Get("gHospId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	i PRecLocId'="" s PRecLoc=PRecLocId		//PRecLocId科室发放详情链接传值
	k ^TMPCSSD(PId,"DispStat")
	s SqlStr="SELECT main.CSSDPDM_ToLoc_DR as ToLocId ,main.CSSDPDM_ToLoc_DR->CTLOC_Desc as ToLocDesc,"
		_" main.CSSDPDM_FromLoc_Dr as FromLocId,main.CSSDPDM_FromLoc_Dr->CTLOC_Desc as FromLocDesc,"
		_" main.CSSDPDM_SubmitDate as SubmitDate,main.CSSDPDM_SerialNo as DispNo,"
		_" main.CSSDPDM_FromUser_DR as DispUserId,main.CSSDPDM_SubmitTime as SubmitTime,"
		_" detail.CSSDPD_Package_DR as PkgId,detail.CSSDPD_DispPrice as DispPrice,"
		_" detail.CSSDPD_PackMaterial as MaterialId,detail.CSSDPD_PackMaterial->CSSDM_Desc as MaterialDesc,"
		_" detail.CSSDPD_Qty as DispQty,detail.CSSDPD_Rowid as DispId FROM CSSD_PackageDispMain main,cssd_packagedisp detail"
		_" where main.ID=detail.CSSDPD_Parref_DR and CSSDPDM_ComplateFlag ='Y'"
		_" and CSSDPDM_DispDate between "_PStartDate_" AND "_PEndDate_""
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	d result.Execute()
	While(result.Next())
	{
		s ToLocId=result.Data("ToLocId")
		s ToLocDesc=result.Data("ToLocDesc")
		s FromLocId=result.Data("FromLocId")
		s FromLocDesc=result.Data("FromLocDesc")
		s SubmitDate=result.Data("SubmitDate")
		s DispNo=result.Data("DispNo")
		s DispUserId=result.Data("DispUserId")
		s SubmitTime=result.Data("SubmitTime")
		s PkgId=result.Data("PkgId")
		s DispPrice=result.Data("DispPrice")
		s MaterialId=result.Data("MaterialId")
		s MaterialDesc=result.Data("MaterialDesc")
		s DispQty=result.Data("DispQty")
		s DispId=result.Data("DispId")
		s SumPrice=DispPrice*DispQty
		
		continue:((PStartTime'="")&&(SubmitTime<PStartTime))&&(SubmitDate=PStartDate)
		continue:((PEndTime'="")&&(SubmitTime>=PEndTime))&&(SubmitDate=PEndDate)
		continue:((PRecLoc'="")&&(PRecLoc'=ToLocId))
		continue:((PSupLoc'="")&&(PSupLoc'=FromLocId))
		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		s SubmitDate=..DL2H(SubmitDate)
		s SubmitTime=..TL2H(SubmitTime)
		s SubmitDateTime=SubmitDate_" "_SubmitTime
		s DispUserName=""
		s:DispUserId'="" DispUserName=$p($g(^SSU("SSUSR",DispUserId)),"^",2)
		
		s PkgObj=##Class(User.CSSDPackage).%OpenId(PkgId)
		s PkgDesc=PkgObj.CSSDPDesc
		s PkgSterTypeId=PkgObj.CSSDPSterTypeGetObjectId()
		s PkgSterTypeDesc=PkgObj.CSSDPSterType.CSSDSTSterName
		s PkgSpecId=PkgObj.CSSDPSpecDrGetObjectId()
		s PkgClassId=PkgObj.CSSDPPackClassGetObjectId()
		s PkgClassDesc=PkgObj.CSSDPPackClass.CSSDPCPackCalssName
		s UomDesc=PkgObj.CSSDPUom.CTUOMDesc
		s Remark=PkgObj.CSSDPRemark
		continue:((PSterTypeId'="")&&(PSterTypeId'=PkgSterTypeId))
		continue:((PPkgSpecId'="")&&(PPkgSpecId'=PkgSpecId))
		continue:((PPkgClassId'="")&&(PPkgClassId'=PkgClassId))
		
		s ItmId="",ItmQty=1
		s ItmDesc=PkgDesc	//消毒包没有绑定器械,则默认消毒包本身，数量为1
		s TmpPkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,0))
		i TmpPkgItmId="" d
		.d OutputRow
		e  d
		.s PkgItmId=""
		.f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:PkgItmId=""  d
		..i $d(^TMPCSSD(PId,"DispStat",DispId)) s (SumPrice,DispQty)=0
		..e  s ^TMPCSSD(PId,"DispStat",DispId)=""
		..s ItmId = $list(^User.CSSDPackageItemD(PkgItmId),7)
		..s ItmQty=$List(^User.CSSDPackageItemD(PkgItmId),4)
		..s ItmObj=##class(User.CSSDItem).%OpenId(ItmId)
		..s ItmDesc=ItmObj.CSSDIDesc
		..d OutputRow
	}
	d result.Close()
	q $$$OK
OutputRow
	s Data=$lb(ToLocId,ToLocDesc,FromLocId,FromLocDesc,SubmitDateTime,DispNo,DispUserId,DispUserName,DispId,DispPrice,DispQty,SumPrice,PkgId,PkgDesc,PkgClassId,PkgClassDesc,PkgSterTypeId,PkgSterTypeDesc,MaterialId,MaterialDesc,UomDesc,Remark,ItmId,ItmDesc,ItmQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 全院无菌物品发放汇总表
/// Creator:ban
/// CreatDate:2021-11-29
/// Description:Query
/// Input:时间区间
/// Others:d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.DispStat","QueryDispSum","{""DateType"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""SupLoc"":"""",""RecLoc"":"""",""SterTypeId"":"""",""PkgClassId"":"""",""PkgDesc"":"""",""PkgSpec"":"""",""StartDate"":""2019-11-15"",""StartTime"":"""",""EndDate"":""2022-11-16"",""EndTime"":""""}"))
/// 包名、灭菌量（灭菌时间）、临床灭菌包发放数、手术室灭菌包发放数、供应室过期灭菌包数（过期时间）、供应室灭菌包库存数（实时）
Query QueryDispSum(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "Type,PkgId,PkgDesc,Qty:%Integer") [ SqlProc ]
{
}

ClassMethod QueryDispSumExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s gHospId=PJObj.%Get("gHospId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	
	f Date=PStartDate:1:PEndDate d
	.s SterMainId=""
	.f  s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexCSSDSRDate",Date,SterMainId)) q:SterMainId=""  d
	..s SterMainObj=##class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	..s SterLocId=SterMainObj.CSSDSRLocDrGetObjectId()
	..s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",SterLocId,gHospId)
	..q:ShowDataFlag="N"
	..s SterItmId=""
	..f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:SterItmId=""  d
	...s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	...q:'$IsObject(SterItmObj)
	...s Qty=SterItmObj.CSSDPSQty
	...s SterPkgObj=SterItmObj.CSSDPSPackage
	...q:'$IsObject(SterPkgObj)
	...s PkgId=SterPkgObj.%Id()
	...s PkgDesc=SterPkgObj.CSSDPDesc
	...s Type="Ster"
	...d OutputRowDispSum
	.s DispMainId="" 
	.f  s DispMainId=$o(^User.CSSDPackageDispMainI("DispDateIndex",Date,DispMainId)) q:DispMainId=""  d
	..s DispMainObj=##class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	..s ToLocId=DispMainObj.CSSDPDMToLocDrGetObjectId()
	..s ToLocDesc=DispMainObj.CSSDPDMToLocDr.CTLOCDesc
	..s DispShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",ToLocId,gHospId)
	..q:DispShowDataFlag="N"
	..s DispItmId=""
	..f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,DispItmId)) q:DispItmId=""  d
	...s DispItmObj=##class(User.CSSDPackageDisp).%OpenId(DispItmId)
	...q:'$IsObject(DispItmObj)
	...s PkgId=DispItmObj.CSSDPDPackage.%Id()
	...s PkgDesc=DispItmObj.CSSDPDPackage.CSSDPDesc
	...s Qty=DispItmObj.CSSDPDDispQty
	...i ToLocDesc["手术室"  d
	....s Type="OprDisp"
	...e   d
	....s Type="OrdDisp"
	...d OutputRowDispSum
	.s TransId="" 
	.f  s TransId=$o(^User.CSSDTransI("IndexCSSDTDate",Date,TransId)) q:TransId=""  d
	..s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	..q:'$IsObject(TransObj)
	..s PkgId=TransObj.CSSDTPackageGetObjectId()
	..s PkgDesc=TransObj.CSSDTPackage.CSSDPDesc
	..s Status=TransObj.CSSDTStatus
	..s ExpDate=TransObj.CSSDTExpDate
	..s Qty=1
	..s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgId,gHospId)
	..q:ShowDataFlag="N"
	..s ExpDate=..DH2L(ExpDate)
	..i Status="S" s Type="Stock"				//灭菌未发放的即未库存
	..i Date>ExpDate s Type="Expire"			//过期的消毒包数
	..d OutputRowDispSum
	Quit $$$OK
OutputRowDispSum
	s Data=$lb(Type,PkgId,PkgDesc,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 各科室消耗统计表
/// Creator:ban
/// CreatDate:2021-11-29
/// Description:Query
/// Input:时间区间
/// Others:d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.DispStat","QueryConsumeSum","")
/// 科室  科室发放包金额  报损金额  合计
/// 说明：报损的是器械，所以需要维护器械价格，金额列为发放给科室所有的包价格 报损金额为该科室时间段内的所有报损额
Query QueryConsumeSum(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "Type,LocId,LocDesc,Qty:%Integer,Price:%Float,SumPrice:%Float") [ SqlProc ]
{
}

ClassMethod QueryConsumeSumExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s gHospId=PJObj.%Get("gHospId")
	
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	
	f Date=PStartDate:1:PEndDate d
	.s ConsumeMainId=""
	.f  s ConsumeMainId=$o(^User.CSSDUllageI("CSSDUDateLocDrIndex",Date,ConsumeMainId)) q:ConsumeMainId=""  d
	..s ConsumeMainObj=##class(User.CSSDUllage).%OpenId(ConsumeMainId)
	..s LocId=ConsumeMainObj.CSSDULocGetObjectId()
	..s LocDesc=ConsumeMainObj.CSSDULoc.CTLOCDesc
	..s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",LocId,gHospId)
	..q:ShowDataFlag="N"
	..s ConsumeItmId=""
	..f  s ConsumeItmId=$o(^User.CSSDUllageDetailI("CSSDUDMainDrIndex",ConsumeMainId,ConsumeItmId)) q:ConsumeItmId=""  d
	...s ConsumeItmObj=##class(User.CSSDUllageDetail).%OpenId(ConsumeItmId)
	...q:'$IsObject(ConsumeItmObj)
	...s Qty=ConsumeItmObj.CSSDUDNum
	...s ItemId=ConsumeItmObj.CSSDUDItemGetObjectId()
	...s Price=$lg(^User.CSSDItemD(ItemId),4)
	...s SumPrice=Price*Qty
	...s Type="Consume"
	...d OutputRowConsume
	.s DispMainId="" 
	.f  s DispMainId=$o(^User.CSSDPackageDispMainI("DispDateIndex",Date,DispMainId)) q:DispMainId=""  d
	..s DispMainObj=##class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	..s LocId=DispMainObj.CSSDPDMToLocDrGetObjectId()
	..s LocDesc=DispMainObj.CSSDPDMToLocDr.CTLOCDesc
	..s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",LocId,gHospId)
	..q:ShowDataFlag="N"
	..s DispItmId=""
	..f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,DispItmId)) q:DispItmId=""  d
	...s DispItmObj=##class(User.CSSDPackageDisp).%OpenId(DispItmId)
	...q:'$IsObject(DispItmObj)
	...s PkgId=DispItmObj.CSSDPDPackageGetObjectId()
	...s Price=DispItmObj.CSSDPDDispPrice
	...s Qty=DispItmObj.CSSDPDDispQty
	...s SumPrice=Qty*Price
	...s Type="Disp"
	...d OutputRowConsume
	
	Quit $$$OK
OutputRowConsume
	s Data=$lb(Type,LocId,LocDesc,Qty,Price,SumPrice)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
