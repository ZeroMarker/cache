Class web.CSSDHUI.Stat.ApplyStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wb
/// CreatDate:2020-7-16
/// Description:请领单查询
/// Table:CSSD_PackageApply
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.ApplyStat","SelectAll",^tmpljlkk)
Query SelectAll(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ApplyNo,ApplyLocId,ApplyLocDesc,SupLocId,SupLocDesc,ApplyLevel,ApplyLevelDesc,ApplyStateDesc,ApplyUserName,SubmitDate,ApplyDate,RefuseReason,PkgId,PkgDesc,ApplyQty:%Integer,ApplyType,ApplyTypeDesc") [ SqlProc ]
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
	s PSupLocId=PJObj.%Get("SupLoc")
	s PApplyLocId=PJObj.%Get("ApplyLoc")
	s PPkgId=PJObj.%Get("PkgName")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PState=PJObj.%Get("State")
	s PPkgClassId=PJObj.%Get("PackageClass")
	s PSpecId=PJObj.%Get("PackageSpec")
	s gHospId=PJObj.%Get("gHospId")
	s PApplyNo=PJObj.%Get("ApplyNo")
	s PReqLevel=PJObj.%Get("ReqLevel")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	s Result=##class(%Library.ResultSet).%New()	
	s SqlStr="select ID As RowId,CSSDPA_NO,CSSDPA_Type,CSSDPA_ReqLevel,CSSDPA_LOCDR,"
			_" CSSDPA_Flag,CSSDPA_UseDate,CSSDPA_SubmitDate,CSSDPA_SubmitTime,"
			_" CSSDPA_APPLYUSERDR->SSUSR_Name,CSSDPA_APPLYLOCDR,CSSDPA_RefuseReason "
			_"from CSSD_PackageApply "
			_" where CSSDPA_SubmitDate between "_PStartDate_" and "_PEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s ApplyNo = Result.Data("CSSDPA_NO")
		continue:(PApplyNo'="")&&(ApplyNo'[PApplyNo)
		s ApplyType = Result.Data("CSSDPA_Type")
		s ApplyLevel =Result.Data("CSSDPA_ReqLevel")
		continue:(PReqLevel'="")&&(ApplyLevel'=PReqLevel)
		s ApplyUserName = Result.Data("SSUSR_Name")
		s SubmitDate = Result.Data("CSSDPA_SubmitDate")
		s SubmitTime= Result.Data("CSSDPA_SubmitTime")
		s ApplyLocId = Result.Data("CSSDPA_APPLYLOCDR")
		s SupLocId = Result.Data("CSSDPA_LOCDR")
		s ApplyState = Result.Data("CSSDPA_Flag")
		s ApplyDate = Result.Data("CSSDPA_UseDate")
		s RefuseReason = Result.Data("CSSDPA_RefuseReason")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",ApplyLocId,gHospId)
		continue:ShowDataFlag="N"
		continue:((PStartTime'="")&&(SubmitTime<PStartTime))&&(SubmitDate=PStartDate)
		continue:((PEndTime'="")&&(SubmitTime>=PEndTime))&&(SubmitDate=PEndDate)
		continue:((PApplyLocId'="")&&(PApplyLocId'=ApplyLocId))
		continue:((PSupLocId'="")&&(PSupLocId'=SupLocId))
		continue:((PState'="")&&(PState'=ApplyState))
		s ApplyLocDesc=$s(ApplyLocId'="":$p(^CTLOC(ApplyLocId),"^",2),1:"")
		s SupLocDesc=$s(SupLocId'="":$p(^CTLOC(SupLocId),"^",2),1:"")
		s ApplyStateDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqStatueDesc(ApplyState)
		s ApplyDate=..DL2H(ApplyDate)
		s SubmitDate=..DL2H(SubmitDate)
		s SubmitTime=..TL2H(SubmitTime)
		s SubmitDate=SubmitDate_" "_SubmitTime
		s ApplyTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqTypeDesc(ApplyType)
		s ApplyLevelDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqLevelDesc(ApplyLevel)
		s ApplyItmId=0
		f  s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",RowId,ApplyItmId)) q:ApplyItmId=""  d
		.s ApplyItmObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
		.q:'$IsObject(ApplyItmObj)
		.s ApplyQty=ApplyItmObj.CSSDPADReqQty
		.s PkgId=ApplyItmObj.CSSDPADPackageDrGetObjectId()
		.s SpecId=ApplyItmObj.CSSDPADPackageDr.CSSDPSpecDrGetObjectId()
		.s PkgDesc=ApplyItmObj.CSSDPADPackageDr.CSSDPDesc
		.s PkgClassId=ApplyItmObj.CSSDPADPackageDr.CSSDPPackClassGetObjectId()
		.q:(PPkgId'="")&(PPkgId'=PkgId)
		.q:(PPkgClassId'="")&(PPkgClassId'=PkgClassId)
		.q:(PSpecId'="")&(PSpecId'=SpecId)
		.d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ApplyNo,ApplyLocId,ApplyLocDesc,SupLocId,SupLocDesc,ApplyLevel,ApplyLevelDesc,ApplyStateDesc,ApplyUserName,SubmitDate,ApplyDate,RefuseReason,PkgId,PkgDesc,ApplyQty,ApplyType,ApplyTypeDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
