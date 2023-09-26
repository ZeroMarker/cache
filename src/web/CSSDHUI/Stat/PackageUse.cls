Import sqluser

/// ban
/// 2022-10-24
/// 患者使用统计
Class web.CSSDHUI.Stat.PackageUse Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:   患者使用统计
/// Creator:    ban
/// CreateDate: 2022-10-24
/// Table:      cssd_transop
/// Input:      
/// Return： 获取消毒包绑定患者的统计数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.PackageUse","QueryPackageUse","{""StartDate"":""2022-10-24"",""gUserId"":""7412"",""gLocId"":""124"",""gGroupId"":""103"",""gHospId"":""2"",""EndDate"":""2022-10-26"",""ReportType"":""FlagPackageUse""}")
Query QueryPackageUse(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "Label,PkgDesc,OPCountDate,RecLocDesc,PatientName,DispDate,Qty:%Integer") [ SqlProc ]
{
}

ClassMethod QueryPackageUseExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PRecLocId=PJObj.%Get("RecLoc")
	
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	
	s DeptCenterId=$o(^User.CSSDDeptCenterI("CSSDDLocIndex",PRecLocId,""))
	
	f Date=PStartDate:1:PEndDate d
	.s TransOpId=""
	.f  s TransOpId=$o(^User.CSSDTransOPI("UseDateIndex",Date,TransOpId)) q:TransOpId=""  d
	..s TransOpObj=##Class(User.CSSDTransOP).%OpenId(TransOpId)
	..q:'$IsObject(TransOpObj)
	..s Label=TransOpObj.CSSDTOPLabel				;标签
	..s PatientName=TransOpObj.CSSDTOPPationtName	;使用患者姓名
	..s OPCountDate=TransOpObj.CSSDOPCountDate		;手术日期
	..s OPCountDate=..DL2H(OPCountDate)
	..s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	..q:TransId=""
	..s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	..q:'$IsObject(TransObj)
	..q:'$IsObject(TransObj.CSSDTDisp)
	..q:'$IsObject(TransObj.CSSDTPackage)
	..s DispMainObj=TransObj.CSSDTDisp.CSSDPDParrefDr
	..s PkgDesc=TransObj.CSSDTPackage.CSSDPDesc
	..s AttributeId=TransObj.CSSDTPackage.CSSDPPackTypeDetail
	..s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
	..s:AttributeId=1 PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	..q:'$IsObject(DispMainObj)
	..s DispDate=DispMainObj.CSSDPDMDispDate	;消毒包发放日期
	..s RecLocId=DispMainObj.CSSDPDMToLocDrGetObjectId()
	..s DispDate=..DL2H(DispDate)
	..s RecLocDesc=""
	..s:RecLocId'="" RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
	..q:(DeptCenterId="")&&(RecLocId'=PRecLocId)
	..s Qty=1
	..d OutputRow
	Quit $$$OK

OutputRow
	s Data=$lb(Label,PkgDesc,OPCountDate,RecLocDesc,PatientName,DispDate,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
