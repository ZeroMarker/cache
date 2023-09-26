Import sqluser

Class web.CSSDHUI.Stat.UrgentStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:加急统计查询
/// Creator:ban
/// CreateDate:2023-04-24
/// Table:CSSD_Trans
/// Input:查询条件
/// Return：加急消毒包数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.UrgentStat","SelectAll","{""StartDate"":""2023-03-07"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""EndDate"":""2023-04-23"",""DateType"":"""",""LocId"":"""",""PkgId"":""""}")
Query SelectAll(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PkgId:%Integer,PkgDesc,Label,Qty:%Integer,ItmQty:%Integer,LevelFlag,PackLocDesc,SterNo,MachineNo,ExpDate,SterDate,SterTime,SterDateTime,SterChkDate,SterChkTime,SterChkDateTime,CleanItmId,CleanMachineNo,CleanBatchNo,CleanDate,CleanTime,CleanDateTime,CleanChkDate,CleanChkTime,CleanChkDateTime") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PPkgId=PJObj.%Get("PkgId")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PLocId=PJObj.%Get("LocId")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gUserId = PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK

	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)

	f date=PStartDate:1:PEndDate d
	.s TransId="" 
	.f  s TransId=$o(^User.CSSDTransI("IndexCSSDTDate",date,TransId)) q:TransId=""  d
	..q:'$d(^User.CSSDTransD(TransId))
	..s TransInfo=$g(^User.CSSDTransD(TransId))
	..q:TransInfo=""
	..s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	..s ExpDate=TransObj.CSSDTExpDate
	..s CleanItmObj=TransObj.CSSDTClean
	..s Label=TransObj.CSSDTLabel
	..s ExpDate=..DL2H(ExpDate)
	..s PkgId=$li(TransInfo,16)
	..s PackId=$lg(TransInfo,15)
	..s SterItmId=$lg(TransInfo,17)
	..s Qty=1
	..q:PkgId=""
	..q:((PPkgId'="")&&(PPkgId'=PkgId))
	..s ItmQty=##class(web.CSSDHUI.Common.PackageInfoCommon).GetItmQtyByPkgId(PkgId)
	..s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	..s PkgTypeDetailDr=PkgObj.CSSDPPackTypeDetail
	..s PkgTypeDetailDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(PkgTypeDetailDr)
	..s PkgDesc=""
	..s:PkgId'="" PkgDesc=$li(^User.CSSDPackageD(PkgId),5)
	..i PkgTypeDetailDr=1 d
	...s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	..;配包打包
	..s (PackInfo,PackLocDr,PackLocDesc,LevelFlag)=""
	..s:PackId'="" PackInfo=$g(^User.CSSDPackagePackD(PackId))
	..i PackInfo'=""  d
	...s PackLocDr=$lg(PackInfo,15)
	...i PackLocDr'="" s PackLocDesc=$p(^CTLOC(PackLocDr),"^",2)
	...s LevelFlag=$lg(PackInfo,25)
	..q:((PLocId'="")&&(PLocId'=PackLocDr))
	..q:LevelFlag'=1
	..;灭菌
	..s (SterNo,MachineNo,SterDate,SterTime,SterDateTime,SterChkDate,SterChkTime,SterChkDateTime)=""
	..s:SterItmId'="" SterItmInfo=$g(^User.CSSDPackageSterilizeD(SterItmId))
	..i SterItmInfo'="" d
	...s SterMainId=$lg(SterItmInfo,13)
	...s SterMainInfo=$g(^User.CSSDSterilizeRecordD(SterMainId))
	...q:SterMainInfo=""
	...;灭菌批号
	...s SterNo=$lg(SterMainInfo,4)
	...;灭菌器号
	...s MachineNo=$lg(SterMainInfo,18)
	...s SterDate=$lg(SterMainInfo,2)
	...s:SterDate'="" SterDate=..DL2H(SterDate)
	...s SterTime=$lg(SterMainInfo,8)
	...s:SterTime'="" SterTime=..TL2H(SterTime)
	...s SterDateTime=SterDate_" "_SterTime
	...s SterChkDate=$lg(SterMainInfo,46)
	...s:SterChkDate'="" SterChkDate=..DL2H(SterChkDate)
	...s SterChkTime=$lg(SterMainInfo,26)
	...s:SterChkTime'="" SterChkTime=..TL2H(SterChkTime)
	...s SterChkDateTime=SterChkDate_" "_SterChkTime
	..;清洗详情
	..s (CleanItmId,CleanMachineNo,CleanBatchNo,CleanDate,CleanTime,CleanDateTime,CleanChkDate,CleanChkTime,CleanChkDateTime)=""
	..i $IsObject(CleanItmObj) d
	...s CleanItmId=CleanItmObj.%Id()
	...s CleanMainObj=CleanItmObj.CSSDCDPCleanMain
	...s CleanMachineNo=CleanMainObj.CSSDCMachineNo
	...s CleanBatchNo=CleanMainObj.CSSDCNo
	...s CleanDate=CleanMainObj.CSSDCDate
	...s CleanDate=..DL2H(CleanDate)
	...s CleanTime=CleanMainObj.CSSDCTime
	...s CleanTime=..TL2H(CleanTime)
	...s CleanDateTime=CleanDate_" "_CleanTime
	...s CleanChkDate=CleanMainObj.CSSDCChkDate
	...s CleanChkDate=..DL2H(CleanChkDate)
	...s CleanChkTime=CleanMainObj.CSSDCChkTime
	...s CleanChkTime=..TL2H(CleanChkTime)
	...s CleanChkDateTime=CleanChkDate_" "_CleanChkTime
	..d OutPutRow
	Quit $$$OK
OutPutRow
	s Data=$lb(TransId,PkgId,PkgDesc,Label,Qty,ItmQty,LevelFlag,PackLocDesc,SterNo,MachineNo,ExpDate,SterDate,SterTime,SterDateTime,SterChkDate,SterChkTime,SterChkDateTime,CleanItmId,CleanMachineNo,CleanBatchNo,CleanDate,CleanTime,CleanDateTime,CleanChkDate,CleanChkTime,CleanChkDateTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
