Import sqluser

/// wfg
/// 2019-6-19
/// 统计清洗数据
Class web.CSSDHUI.Stat.CleanStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	清洗工作量统计报表，报表类型：人员汇总、机器汇总、清洗详情后台调用
/// Creator:	ban
/// CreateDate:	2022-11-11
/// Table:		CSSD_Clean
/// Input:		排序，查询条件
/// Return：	清洗详情统计
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.CleanStat","QueryDetailClean","{""DateType"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""MachineNo"":"""",""CleanUserId"":"""",""PackageClass"":"""",""PackageName"":"""",""PackageSpec"":"""",""ReportType"":""FlagStatCleanWorkLoadByPeople"",""StartDate"":""2022-11-01"",""StartTime"":"""",""EndDate"":""2022-11-08"",""EndTime"":"""",""CleanNo"":""""}")
Query QueryDetailClean(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "CleanId,CleanMachineNo,CleanNo,CleanMethodDesc,CleanUserName,CleanDateTime,CleanChkName,CleanChkDateTime,CleanResultDesc,PkgDesc,CleanQty:%Integer,ItmQty:%Integer,SumPkgItmQty:%Integer") [ SqlProc ]
{
}

ClassMethod QueryDetailCleanExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
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
	s PMachineNo=PJObj.%Get("MachineNo")
	s PCleanNo=PJObj.%Get("CleanNo")
	s PCleanUserId=PJObj.%Get("CleanUserId")
	s PPkgId=PJObj.%Get("PackageName")
	s PPkgClassId=PJObj.%Get("PackageClass")
	s PPkgSpecId=PJObj.%Get("PackageSpec")
	s gHospId=PJObj.%Get("gHospId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	s SqlStr="SELECT ID, CSSDC_ChkTime,CSSDC_ChkDate, CSSDC_ChkerDR, CSSDC_CleanMethod, CSSDC_CleanProgress, CSSDC_CleanerDR,"
		_" CSSDC_Date, CSSDC_IsCmtEnterMachine, CSSDC_IsCreateLbl, CSSDC_Loc_DR, CSSDC_MachineConfigDr,"
		_" CSSDC_MachineConfigDr->CSSDMC_Alias as MachineNo, CSSDC_No, CSSDC_Result, CSSDC_Time, CSSDC_User_DR, CSSDC_CleanVehicleLbl"
		_" FROM CSSD_Clean where CSSDC_Date between "_PStartDate_" AND "_PEndDate_""
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	d result.Execute()
	While(result.Next())
	{
		s CleanId=result.Data("ID")
		s CleanMachineNo=result.Data("MachineNo")
		s MachineConfigId=result.Data("CSSDC_MachineConfigDr")
		s CleanNo=result.Data("CSSDC_No")
		s CleanResult=result.Data("CSSDC_Result")
		s CleanUserId=result.Data("CSSDC_CleanerDR")
		s CleanChkId=result.Data("CSSDC_ChkerDR")
		s CleanMethodId=result.Data("CSSDC_CleanMethod")
		s CleanDate=result.Data("CSSDC_Date")
		s CleanTime=result.Data("CSSDC_Time")
		s ChkDate=result.Data("CSSDC_ChkDate")
		s ChkTime=result.Data("CSSDC_ChkTime")
		s CleanLocId=result.Data("CSSDC_Loc_DR")
		
		continue:((PStartTime'="")&&(CleanTime<PStartTime))&&(CleanDate=PStartDate)
		continue:((PEndTime'="")&&(CleanTime>=PEndTime))&&(CleanDate=PEndDate)
		s (CleanUserName,CleanChkName,CleanResultDesc,CleanMethodDesc)=""
		s:CleanUserId'="" CleanUserName=$p($g(^SSU("SSUSR",CleanUserId)),"^",2)
		s:CleanChkId'="" CleanChkName=$p($g(^SSU("SSUSR",CleanChkId)),"^",2)
		i CleanResult=1 s CleanResultDesc="合格"
		i CleanResult=0 s CleanResultDesc="不合格"
		s CleanMethodObj=##Class(User.CSSDCleanType).%OpenId(CleanMethodId)
		i $IsObject(CleanMethodObj) d
		.s CleanMethodDesc=CleanMethodObj.CSSDCTCleanMode
		s CleanDate=..DL2H(CleanDate)
		s CleanTime=..TL2H(CleanTime)
		s CleanDateTime=CleanDate_" "_CleanTime
		s ChkDate=..DL2H(ChkDate)
		s ChkTime=..TL2H(ChkTime)
		s CleanChkDateTime=ChkDate_" "_ChkTime
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",CleanLocId,gHospId)
		q:ShowDataFlag="N"
		
		i CleanMachineNo="" s CleanMachineNo="手工"	//手工清洗默认为手工，需要过滤
		continue:((PMachineNo'="")&&(PMachineNo'="0")&&(PMachineNo'=MachineConfigId))
		continue:((PMachineNo="0")&&(MachineConfigId'=""))
		continue:((PCleanNo'="")&&(PCleanNo'=CleanNo))
		continue:((PCleanUserId'="")&&(PCleanUserId'=CleanUserId))
		
		s SumPkgItmQty=0
		s CleanItmId=""
		f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId,CleanItmId)) q:CleanItmId=""  d
		.s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		.s PkgId=CleanItmObj.CSSDPRPackageGetObjectId()
		.s PackageObj=CleanItmObj.CSSDPRPackage
		.s CleanQty=CleanItmObj.CSSDCDPQty
		.s States=CleanItmObj.CSSDCDPStates
		.i States="N" s CleanQty=CleanItmObj.CSSDCDPTotalQty
		.q:((PPkgId'="")&&(PPkgId'=PkgId))
		.q:'$IsObject(PackageObj)
		.s PkgDesc=PackageObj.CSSDPDesc
		.s PkgClassId=PackageObj.CSSDPPackClassGetObjectId()
		.s PkgSpecId=PackageObj.CSSDPSpecDrGetObjectId()
		.q:((PPkgClassId'="")&&(PPkgClassId'=PkgClassId))
		.q:((PPkgSpecId'="")&&(PPkgSpecId'=PkgSpecId))
		.s ItmQty=##class(web.CSSDHUI.Common.PackageInfoCommon).GetItmQtyByPkgId(PkgId)
		.s SumPkgItmQty=CleanQty*ItmQty
		.s:+SumPkgItmQty=0 SumPkgItmQty=1	;没有器械明细时默认器械明细数为1，便于按器械数统计工作量
		.d OutputRowDetail
	}
	d result.Close()
	q $$$OK
OutputRowDetail
	s Data=$lb(CleanId,CleanMachineNo,CleanNo,CleanMethodDesc,CleanUserName,CleanDateTime,
			CleanChkName,CleanChkDateTime,CleanResultDesc,PkgDesc,CleanQty,ItmQty,SumPkgItmQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	清洗不合格报表统计后台
/// Creator:	ban
/// CreateDate:	2022-11-11
/// Table:		CSSD_Clean
/// Input:		排序，查询条件
/// Return：	清洗不合格统计
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.CleanStat","QueryCleanFailed","{""DateType"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""PackageClassDr"":"""",""PackageDr"":"""",""PkgSpec"":"""",""StartDate"":""2022-11-01"",""EndDate"":""2022-11-08""}")
Query QueryCleanFailed(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "PkgId,PkgDesc,ItmId,ItmDesc,SumNum:%Integer,RejectDesc,FailDate") [ SqlProc ]
{
}

ClassMethod QueryCleanFailedExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
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

	s sql="SELECT CSSDUPD_Pkg AS PkgId,CSSDUPD_Pkg->CSSDP_Desc as PkgDesc,"
		_" CSSDUPD_Itm AS ItmId,CSSDUPD_Itm->CSSDI_Desc as ItmDesc,CSSDUPD_SumNum as SumNum,"
		_" CSSDUPD_QueWhy->CSSD_RejectDesc AS RejectDesc,CSSDUPD_MainDr->CSSDUP_Date AS FailDate,"
		_" CSSDUPD_Pkg->CSSDP_PackClassdr AS PkgClassId,CSSDUPD_Pkg->CSSDP_SpecDr AS PkgSpecId"
		_" FROM CSSD_UsedPredoDetail where CSSDUPD_MainDr->CSSDUP_Date between "_PStartDate_" AND "_PEndDate_""
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sql)
	d result.Execute()
	While(result.Next())
	{ 
		s PkgId=result.Data("PkgId")
		s PkgDesc=result.Data("PkgDesc")
		s ItmId=result.Data("ItmId")
		s ItmDesc=result.Data("ItmDesc")
		s SumNum=result.Data("SumNum")
		s RejectDesc=result.Data("RejectDesc")
		s FailDate=result.Data("FailDate")
		s PkgClassId=result.Data("PkgClassId")
		s PkgSpecId=result.Data("PkgSpecId")
		s FailDate=..DL2H(FailDate)

		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgId,gHospId)
		continue:ShowDataFlag="N"
		continue:((PPkgClassId'="")&&(PPkgClassId'=PkgClassId))
		continue:((PPkgSpecId'="")&&(PPkgSpecId'=PkgSpecId))
		d OutputRowCleanFailed
	}
	d result.Close()
	q $$$OK
OutputRowCleanFailed
	s Data=$lb(PkgId,PkgDesc,ItmId,ItmDesc,SumNum,RejectDesc,FailDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
