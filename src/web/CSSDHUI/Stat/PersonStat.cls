Import sqluser

/// ban
/// 2022-02-14
/// 人员工作量统计
Class web.CSSDHUI.Stat.PersonStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2022-02-14
/// Description:供应室人员工作量统计汇总
/// Input:时间区间
/// Others:d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.PersonStat","QueryPersonSum",^tempsbx("Params"))
/// 人员 回收:标牌追溯包、非标牌追溯包、合计 清洗:标牌追溯包、非标牌追溯包、合计 配包:标牌追溯包、非标牌追溯包、合计 配包审核:标牌追溯包、非标牌追溯包、合计 灭菌:标牌追溯包、非标牌追溯包、合计 发放:标牌追溯包、非标牌追溯包、合计
Query QueryPersonSum(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "Type,PkgDesc,UserName,Qty:%Integer,AttributeId:%Integer,AttributeDesc") [ SqlProc ]
{
}

ClassMethod QueryPersonSumExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s gHospId=PJObj.%Get("gHospId")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PSupLocId=PJObj.%Get("SupLoc")
	s PUserId=PJObj.%Get("UserName")
	
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	s FStartDate=..DH2L(PStartDate)
	s FEndDate=..DH2L(PEndDate)
	
	f Date=FStartDate:1:FEndDate d
	.s CallBackMainId=0
	.f  s CallBackMainId=$o(^User.CSSDPackageCallbackI("CSSDPCAckDateIndex",Date,CallBackMainId)) q:CallBackMainId=""  d
	..s CallBackMainObj=##class(User.CSSDPackageCallback).%OpenId(CallBackMainId)
	..q:'$IsObject(CallBackMainObj)
	..q:'$IsObject(CallBackMainObj.CSSDPCToUserDr)
	..s LocId=CallBackMainObj.CSSDPCFromLocDrGetObjectId()
	..s UserId=CallBackMainObj.CSSDPCToUserDrGetObjectId()
	..s UserName=CallBackMainObj.CSSDPCToUserDr.SSUSRName
	..s CallBackItmId=0
	..f  s CallBackItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackMainId,CallBackItmId)) q:CallBackItmId=""  d
	...s CallBackItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(CallBackItmId)
	...q:'$IsObject(CallBackItmObj)
	...q:'$IsObject(CallBackItmObj.CSSDCDPackageDr)
	...s Qty=CallBackItmObj.CSSDCDQty				//回收数
	...s PkgId=CallBackItmObj.CSSDCDPackageDrGetObjectId()
	...s PkgDesc=CallBackItmObj.CSSDCDPackageDr.CSSDPDesc
	...s AttributeId=CallBackItmObj.CSSDCDPackageDr.CSSDPPackTypeDetail
	...s Type="CallBack"
	...d OutputRowData
	.s CleanMainId=0
	.f  s CleanMainId=$o(^User.CSSDCleanI("IndexCSSDCDate",Date,CleanMainId)) q:CleanMainId=""  d
	..s CleanMainObj=##class(User.CSSDClean).%OpenId(CleanMainId)
	..q:'$IsObject(CleanMainObj)
	..q:'$IsObject(CleanMainObj.CSSDCCleaner)
	..s LocId=CleanMainObj.CSSDCLocDrGetObjectId()
	..s UserId=CleanMainObj.CSSDCCleanerGetObjectId()
	..s UserName=CleanMainObj.CSSDCCleaner.SSUSRName
	..s CleanItmId=0
	..f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanMainId,CleanItmId)) q:CleanItmId=""  d
	...s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	...q:'$IsObject(CleanItmObj)
	...q:'$IsObject(CleanItmObj.CSSDPRPackage)
	...s Qty=CleanItmObj.CSSDCDPQty					//清洗数
	...s PkgId=CleanItmObj.CSSDPRPackageGetObjectId()
	...s PkgDesc=CleanItmObj.CSSDPRPackage.CSSDPDesc
	...s AttributeId=CleanItmObj.CSSDPRPackage.CSSDPPackTypeDetail
	...s Type="Clean"
	...d OutputRowData
	.s PackId=0
	.f  s PackId=$o(^User.CSSDPackagePackI("IndexCSSDPPDate",Date,PackId)) q:PackId=""  d
	..s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	..q:'$IsObject(PackObj)
	..q:'$IsObject(PackObj.CSSDPPAckUserDr)
	..q:'$IsObject(PackObj.CSSDPPPackage)
	..s LocId=PackObj.CSSDPPLocDrGetObjectId()
	..s UserId=PackObj.CSSDPPAckUserDrGetObjectId()
	..s UserName=PackObj.CSSDPPAckUserDr.SSUSRName
	..s Qty=PackObj.CSSDPPQty							//配包数
	..s PkgId=PackObj.CSSDPPPackageGetObjectId()
	..s PkgDesc=PackObj.CSSDPPPackage.CSSDPDesc
	..s AttributeId=PackObj.CSSDPPPackage.CSSDPPackTypeDetail
	..s Type="Pack"
	..d OutputRowData
	.s PackCheckId=0
	.f  s PackCheckId=$o(^User.CSSDPackagePackI("IndexCSSDPPDate",Date,PackCheckId)) q:PackCheckId=""  d
	..s PackCheckObj=##class(User.CSSDPackagePack).%OpenId(PackCheckId)
	..q:'$IsObject(PackCheckObj)
	..q:'$IsObject(PackCheckObj.CSSDPPUserDr)
	..q:'$IsObject(PackCheckObj.CSSDPPPackage)
	..s LocId=PackObj.CSSDPPLocDrGetObjectId()
	..s UserId=PackCheckObj.CSSDPPUserDrGetObjectId()
	..s UserName=PackCheckObj.CSSDPPUserDr.SSUSRName	//配包审核人
	..s Qty=PackCheckObj.CSSDPPQty						//配包审核数
	..s PkgId=PackCheckObj.CSSDPPPackageGetObjectId()
	..s PkgDesc=PackCheckObj.CSSDPPPackage.CSSDPDesc
	..s AttributeId=PackCheckObj.CSSDPPPackage.CSSDPPackTypeDetail
	..s Type="PackCheck"
	..d OutputRowData
	.s SterMainId=0
	.f  s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexCSSDSRDate",Date,SterMainId)) q:SterMainId=""  d
	..s SterMainObj=##class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	..q:'$IsObject(SterMainObj)
	..q:'$IsObject(SterMainObj.CSSDSRUserDr)
	..s LocId=SterMainObj.CSSDSRLocDrGetObjectId()
	..s UserId=SterMainObj.CSSDSRUserDrGetObjectId()
	..s UserName=SterMainObj.CSSDSRUserDr.SSUSRName
	..s SterItmId=0
	..f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:SterItmId=""  d
	...s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	...q:'$IsObject(SterItmObj)
	...q:'$IsObject(SterItmObj.CSSDPSPackage)
	...s Qty=SterItmObj.CSSDPSQty					//灭菌数
	...s PkgId=SterItmObj.CSSDPSPackageGetObjectId()
	...s PkgDesc=SterItmObj.CSSDPSPackage.CSSDPDesc
	...s AttributeId=SterItmObj.CSSDPSPackage.CSSDPPackTypeDetail
	...s Type="Ster"
	...d OutputRowData
	.s DispMainId=0
	.f  s DispMainId=$o(^User.CSSDPackageDispMainI("DispDateIndex",Date,DispMainId)) q:DispMainId=""  d
	..s DispMainObj=##class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	..q:'$IsObject(DispMainObj)
	..q:'$IsObject(DispMainObj.CSSDPDMFromUserDr)
	..s LocId=DispMainObj.CSSDPDMFromLocDrGetObjectId()
	..s UserId=DispMainObj.CSSDPDMFromUserDrGetObjectId()
	..s UserName=DispMainObj.CSSDPDMFromUserDr.SSUSRName
	..s DispItmId=0
	..f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,DispItmId)) q:DispItmId=""  d
	...s DispItmObj=##class(User.CSSDPackageDisp).%OpenId(DispItmId)
	...q:'$IsObject(DispItmObj)
	...q:'$IsObject(DispItmObj.CSSDPDPackage)
	...s Qty=DispItmObj.CSSDPDDispQty				//发放数
	...s PkgId=DispItmObj.CSSDPDPackageGetObjectId()
	...s PkgDesc=DispItmObj.CSSDPDPackage.CSSDPDesc
	...s AttributeId=DispItmObj.CSSDPDPackage.CSSDPPackTypeDetail
	...s Type="Disp"
	...d OutputRowData
	Quit $$$OK
OutputRowData
	s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgId,gHospId)
	q:ShowDataFlag="N"
	q:(PSupLocId'="")&&(PSupLocId'=LocId)
	q:(PUserId'="")&&(PUserId'=UserId)
	s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
	s Data=$lb(Type,PkgDesc,UserName,Qty,AttributeId,AttributeDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
