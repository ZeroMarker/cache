Import sqluser

///  Creator:ban
///  CreatDate:2021.11.17
///  Description:科室借包后台类
///  Table:CSSD_PackageApply
Class web.CSSDHUI.Stat.LendPkgQueryStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

///  Creator:ban
///  CreatDate:2021.11.17
///  Description:科室借包查询
///  Table:CSSD_PackageApply
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.LendPkgQueryStat","SelectAll",^tmpwhy("321"))
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "ApplyId,ApplyDate,ApplyNO,ApplyLocID,ApplyLocDesc,ApplyUserId,ApplyUserName,SubmitDate,SubmitTime,ApplyItmId,ApplyQty,PkgDr,PkgDesc,CallBackId,CallBackNo,CallBackItmId,ReturnQty,DispItmId,DispNo,DispQty") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s PApplyLocId=PJObj.%Get("LendLoc")
	s PApplyState=PJObj.%Get("LendState")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	q:((PStartDate="")||(PEndDate=""))
	s StartDate=..DH2L(PStartDate)
	s EndDate=..DH2L(PEndDate)
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID,CSSDPA_DATE,CSSDPA_NO,CSSDPA_APPLYLOCDR,CSSDPA_APPLYUSERDR,CSSDPA_APPLYUSERDR->SSUSR_Name as applyUserName,CSSDPA_SubmitDate,CSSDPA_SubmitTime,CSSDPA_Flag FROM CSSD_PackageApply "
	_"WHERE CSSDPA_Type='1' AND CSSDPA_SubmitDate BETWEEN "_StartDate_" AND "_EndDate
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s ApplyId= Result.Data("ID")
		s ApplyDate = Result.Data("CSSDPA_DATE")
		s SubmitDate= Result.Data("CSSDPA_SubmitDate")
		s SubmitTime= Result.Data("CSSDPA_SubmitTime")
		s ApplyNO = Result.Data("CSSDPA_NO")
		s ApplyLocID=Result.Data("CSSDPA_APPLYLOCDR")
		s ApplyUserId = Result.Data("CSSDPA_APPLYUSERDR")
		s ApplyUserName=Result.Data("applyUserName")
		
		s ApplyDate=..DL2H(SubmitDate)_" "_..TL2H(SubmitTime)
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",ApplyLocID,gHospId)
		s ApplyLocDesc=$s(ApplyLocID'="":$p(^CTLOC(ApplyLocID),"^",2),1:"")
		continue:ShowDataFlag="N"
		continue:((PApplyLocId'="")&(ApplyLocID'=PApplyLocId))
		
		s ApplyItmId=0
		f  s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",ApplyId,ApplyItmId)) q:ApplyItmId=""  d
		.s ApplyItmObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
		.d ApplyItmObj.%Reload()
		.s ApplyQty=ApplyItmObj.CSSDPADReqQty								//数量
		.s PkgDr=ApplyItmObj.CSSDPADPackageDr.%Id()							//包id
		.s PkgDesc=ApplyItmObj.CSSDPADPackageDr.CSSDPDesc					//包名称
		.s DispQty=ApplyItmObj.CSSDPADOutQty								//发放数
		.;获取借包单对应的发放信息
		.s (CallBackLendId,CallBackId,DispItmId,DispNo,DispNoStr)="",(ReturnQty,CallBackLendId)=0
		.f  s CallBackLendId=$o(^User.CSSDPackageCallbackI("CSSDPCApplyComplateIndex",ApplyId,"W",CallBackLendId)) q:CallBackLendId=""  d
		..s CallBackLendItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefItmIndex",CallBackLendId,PkgDr,""))
		..q:CallBackLendItmId=""
		..
		..s DispItmObj="",DispItmId=0
		..f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCallBackDetailIndex",CallBackLendItmId,DispItmId)) q:DispItmId=""  d
		...s DispItmObj=##class(User.CSSDPackageDisp).%OpenId(DispItmId)
		...s:$IsObject(DispItmObj) DispNo=DispItmObj.CSSDPDParrefDr.CSSDPDMSerialNo
		...i DispNoStr="" s DispNoStr=DispNo
		...e  s DispNoStr=DispNoStr_","_DispNo
		.;获取借包单对应的回收信息
		.s CallBackNoStr="",CallBackId=0
		.f  s CallBackId=$o(^User.CSSDPackageCallbackI("CSSDPCApplyComplateIndex",ApplyId,"Y",CallBackId)) q:CallBackId=""  d
		..s CallBackObj=##class(User.CSSDPackageCallback).%OpenId(CallBackId)
		..d CallBackObj.%Reload()
		..s CallBackNo=CallBackObj.CSSDPCSerialNo
		..s CallBackItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefItmIndex",CallBackId,PkgDr,""))
		..q:CallBackItmId=""
		..s CallBackItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(CallBackItmId)
		..d CallBackItmObj.%Reload()
		..q:'$IsObject(CallBackItmObj)
		..s ReturnQty=ReturnQty+CallBackItmObj.CSSDCDQty					//归还数
		..i CallBackNoStr="" s CallBackNoStr=CallBackNo
		..e  s CallBackNoStr=CallBackNoStr_","_CallBackNo
		.q:((PApplyState="UnReturned")&&(ApplyQty=ReturnQty))
		.q:((PApplyState="Returned")&&(ApplyQty'=ReturnQty))
		.s CallBackNo=CallBackNoStr
		.s DispNo=DispNoStr
		.d OutPutRow
	}
	d Result.Close()
 Quit $$$OK
OutPutRow
 s Data=$lb(ApplyId,ApplyDate,ApplyNO,ApplyLocID,ApplyLocDesc,ApplyUserId,ApplyUserName,SubmitDate,SubmitTime,ApplyItmId,ApplyQty,PkgDr,PkgDesc,CallBackId,CallBackNo,CallBackItmId,ReturnQty,DispItmId,DispNo,DispQty)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
