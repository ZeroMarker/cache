Import sqluser

/// wfg
/// 2019-6-19
/// 灭菌模块相关报表后台
Class web.CSSDHUI.Stat.SterStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	灭菌工作量统计报表后台 人员统计、机器统计、灭菌详情等
/// Creator:	wfg
/// CreateDate:	2019-7-11
/// Table:		cssd_SterilizeRecord
/// Input:		排序，查询条件
/// Return：	灭菌详情
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.SterStat","QueryDetail","{""DateType"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""SterType"":"""",""SterMachineDr"":"""",""SterUserId"":"""",""PackageClass"":"""",""PackageDr"":"""",""PkgSpec"":"""",""RecallFlag"":""Y"",""ReportType"":""FlagStatSterWorkLoadDetail"",""StartDate"":""2022-05-23"",""StartTime"":"""",""EndDate"":""2022-06-10"",""EndTime"":"""",""SterNo"":""""}")
Query QueryDetail(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "PkgName,PkgTypeDesc,PkgDictName,Label,DeptName,SterItmId,SterNo,MachineNo,ExpDate,SterProgressName,SterUserName,SterDateTime,SterQty:%Integer,SterChkerName,SterChkDateTime,SterCheckResultDesc,SterCheResultDesc,SterBatResultDesc,RecallDateTime,RecallUserName,RecallFlag,RecallReasonDesc,TransRowid") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PSterMachineDr=PJObj.%Get("SterMachineDr")	//灭菌器id
	s PSterNo=PJObj.%Get("SterNo")					//灭菌批号
	s PSterUserId=PJObj.%Get("SterUserId")			//灭菌人
	s PPkgId=PJObj.%Get("PackageDr")			//消毒包名
	s PRecallFlag=PJObj.%Get("RecallFlag")			//是否召回
	s PPkgClassId=PJObj.%Get("PackageClass")		//消毒包分类
	s PPkgSpecId=PJObj.%Get("PkgSpec")				//消毒包规格
	s PSterType=PJObj.%Get("SterType")				//灭菌方式
	s gHospId=PJObj.%Get("gHospId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	
	f Date=PStartDate:1:PEndDate d
	.s LocId=""
	.f  s LocId=$o(^User.CSSDSterilizeRecordI("IndexDateLoc",Date,LocId)) q:LocId=""  d
	..s SterMainId=""
	..f  s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexDateLoc",Date,LocId,SterMainId)) q:SterMainId=""  d
	...s SterMainInfo=$g(^User.CSSDSterilizeRecordD(SterMainId))
	...q:SterMainInfo=""
	...s SterDate=$lg(SterMainInfo,2)
	...s SterNo=$lg(SterMainInfo,4)
	...s SterTime=$lg(SterMainInfo,8)
	...s SterUserId=$lg(SterMainInfo,9)
	...s SterBatResult=$lg(SterMainInfo,12)
	...s SterLocDr=$lg(SterMainInfo,17)
	...s SterChkerId=$lg(SterMainInfo,25)
	...s SterChkTime=$lg(SterMainInfo,26)
	...s SterMachineId=$lg(SterMainInfo,35)
	...s ProgressId=$lg(SterMainInfo,36)
	...s SterIsChe=$lg(SterMainInfo,39)
	...s SterIsBio=$lg(SterMainInfo,40)
	...s SterCheResult=$lg(SterMainInfo,43)
	...s SterChkDate=$lg(SterMainInfo,46)
	...q:((PStartTime'="")&&(SterTime<PStartTime))&&(SterDate=PStartDate)
	...q:((PEndTime'="")&&(SterTime>=PEndTime))&&(SterDate=PEndDate)
	...q:((PSterNo'="")&&(PSterNo'=SterNo))
	...s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",SterLocDr,gHospId)
	...q:ShowDataFlag="N"
	...s (SterUserName,SterChkerName,SterProgressName)=""
	...s ProgressObj=##class(User.CSSDBaseCode).%OpenId(ProgressId)
	...i $IsObject(ProgressObj) s SterProgressName=ProgressObj.CSSDDCName
	...q:((PSterMachineDr'="")&&(PSterMachineDr'=SterMachineId))
	...s MachineConfigObj =##class(User.CSSDMachineConfig).%OpenId(SterMachineId)
	...q:'$IsObject(MachineConfigObj)
	...s MachineNo=MachineConfigObj.CSSDMCAlias
	...s MachineTempType=MachineConfigObj.CSSDMCTempType
	...q:((PSterType'="")&&(PSterType'=MachineTempType))
	...s:SterUserId'="" SterUserName=$p($g(^SSU("SSUSR",SterUserId)),"^",2)
	...q:((PSterUserId'="")&&(PSterUserId'=SterUserId))
	...s SterDate=..DL2H(SterDate)
	...s SterTime=..TL2H(SterTime)
	...s SterDateTime=SterDate_" "_SterTime
	...s:SterChkerId'="" SterChkerName=$p($g(^SSU("SSUSR",SterChkerId)),"^",2)
	...s SterChkDate=..DL2H(SterChkDate)
	...s SterChkTime=..TL2H(SterChkTime)
	...s SterChkDateTime=SterChkDate_" "_SterChkTime
	...s (PkgName,PkgDictName,PkgTypeDesc,DeptName,Label,ExpDate)=""
	...s (SterCheckResultDesc,SterCheResultDesc,SterBatResultDesc)=""
	...s (RecallDateTime,RecallUserName,RecallReasonDesc,RecallFlag,TransRowid)=""
	...s SterQty=0
	...i ((SterIsChe="Y")&&(SterCheResult="1")) s SterCheResultDesc="化学验收合格"
	...i ((SterIsChe="Y")&&(SterCheResult="2")) s SterCheResultDesc="化学验收不合格"
	...i ((SterIsBio="Y")&&(SterBatResult="1")) s SterBatResultDesc="生物验收合格"
	...i ((SterIsBio="Y")&&(SterBatResult="2")) s SterBatResultDesc="生物验收不合格"
	...s TmpId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,""))
	...i (TmpId="")&&(PRecallFlag="") d
	....d OutputRow
	...s SterItmId=""
	...f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:SterItmId=""  d
	....s SterItmInfo=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	....s SterQty=SterItmInfo.CSSDPSQty
	....s RecallFlag=SterItmInfo.CSSDPSRecallFlag
	....s RecallDate=SterItmInfo.CSSDPSRecallDate
	....s RecallTime=SterItmInfo.CSSDPSRecallTime
	....s RecallUserId=SterItmInfo.CSSDPSRecallUserGetObjectId()
	....s RecallReasonId=SterItmInfo.CSSDPSRecallReasonGetObjectId()
	....s Label=SterItmInfo.CSSDPSLabel
	....s PkgId=SterItmInfo.CSSDPSPackageGetObjectId()
	....s PkgObj=SterItmInfo.CSSDPSPackage
	....s SterCheckResult = SterItmInfo.CSSDPSStates
	....s HospitalDr=PkgObj.CSSDPHospitalGetObjectId()
	....s PkgTypeCode=PkgObj.CSSDPPackTypeDetail
	....s PkgName=PkgObj.CSSDPDesc
	....s PkgSpecId=PkgObj.CSSDPSpecDrGetObjectId()
	....q:(PRecallFlag'="")&&(PRecallFlag'=RecallFlag)
	....i PkgTypeCode=1 d
	.....s PkgDictName=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	.....s DeptName=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictBindLocName(Label)
	....s RecallDate=..DL2H(RecallDate)
	....s RecallTime=..TL2H(RecallTime)
	....s RecallDateTime=RecallDate_" "_RecallTime
	....s:RecallUserId'="" RecallUserName=$p(^SSU("SSUSR",RecallUserId),"^",2)
	....s:RecallReasonId'="" RecallReasonDesc=$lg(^User.CSSDRecallReasonD(RecallReasonId),3)
	....i RecallFlag="Y" s RecallFlag="已召回"
	....s PkgTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(PkgTypeCode)
	....s PkgClassId=$lg(^User.CSSDPackageD(PkgId),12)
	....q:((PPkgId'="")&&(PPkgId'=PkgId))
	....q:((PPkgClassId'="")&&(PPkgClassId'=PkgClassId))
	....q:((PPkgSpecId'="")&&(PPkgSpecId'=PkgSpecId))
	....i SterCheckResult="Y" s SterCheckResultDesc="合格"
	....i SterCheckResult="N" s SterCheckResultDesc="不合格"
	....s TransRowid= $o(^User.CSSDTransI("CSSDTLabel",Label,""))
	....s ExpDate=$lg(^User.CSSDTransD(TransRowid),12)
	....s ExpDate=..DL2H(ExpDate)
	....d OutputRow
	Quit $$$OK

OutputRow
	s Data=$lb(PkgName,PkgTypeDesc,PkgDictName,Label,DeptName,SterItmId
			,SterNo,MachineNo,ExpDate,SterProgressName,SterUserName,SterDateTime,SterQty,
			SterChkerName,SterChkDateTime,SterCheckResultDesc,SterCheResultDesc,SterBatResultDesc,
			RecallDateTime,RecallUserName,RecallFlag,RecallReasonDesc,TransRowid)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	统计一定时间范围内灭菌不合格的消毒包数量
/// Creator:	wfg
/// CreateDate:	2019-7-11
/// Table:		CSSD_SterPredoDetail
/// Input:		Params：查询条件
/// Return：	时间范围内灭菌不合格数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.SterStat","QuerySterFailed","{""DateType"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""PackageClassDr"":"""",""PackageDr"":"""",""PkgSpec"":"""",""ReportType"":""FlagStatSterlFailed"",""StartDate"":""2022-05-30"",""EndDate"":""2022-11-02""}")
Query QuerySterFailed(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "PkgId,PkgDesc,Label,SterFailReasonDesc,SterFailDate,Qty:%Float") [ SqlProc ]
{
}

ClassMethod QuerySterFailedExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PPkgId=PJObj.%Get("PackageDr")
	s PPkgClassId=PJObj.%Get("PackageClassDr")
	s PPkgSpecId=PJObj.%Get("PkgSpec")
	s gHospId=PJObj.%Get("gHospId")

	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)

	s SqlStr=" SELECT CSSDSP_Package_DR AS PkgId,CSSDSP_Package_DR->CSSDP_Desc as PkgDesc,"
		_" CSSDSPD_Resion->CSSD_SteFailDesc AS SterReasonDesc,CSSDSPD_Num AS Label,"
		_" CSSDSP_Package_DR->CSSDP_PackClassdr AS PkgClassId,CSSDSPD_MainDr->CSSDSP_Date AS SterFailDate,"
		_" CSSDSP_Package_DR->CSSDP_SpecDr AS PkgSpecId FROM CSSD_SterPredoDetail"
		_" where CSSDSPD_MainDr->CSSDSP_Date between "_PStartDate_" AND "_PEndDate_""
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	d result.Execute()
	While(result.Next())
	{
		s PkgId=result.Data("PkgId")
		s PkgDesc=result.Data("PkgDesc")
		s Label=result.Data("Label")
		s SterFailReasonDesc=result.Data("SterReasonDesc")
		s SterFailDate=result.Data("SterFailDate")
		s PkgClassId=result.Data("PkgClassId")
		s PkgSpecId=result.Data("PkgSpecId")
		s SterFailDate=..DL2H(SterFailDate)
		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgId,gHospId)
		continue:ShowDataFlag="N"
		continue:((PPkgClassId'="")&&(PPkgClassId'=PkgClassId))
		continue:((PPkgSpecId'="")&&(PPkgSpecId'=PkgSpecId))
		s Qty=1
		d OutputRowFail
	}
	d result.Close()
	q $$$OK
OutputRowFail
	s Data=$lb(PkgId,PkgDesc,Label,SterFailReasonDesc,SterFailDate,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
