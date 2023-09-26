/// 名称: DHCHAI.IRS.BPSurveyExecSrv
/// 描述: 血透个案调查定义相关服务
/// 编写者: zhoubo
/// 编写日期: 2022-10-12
Class DHCHAI.IRS.BPSurveyExecSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-10-12
/// Description:  通过编码查询
/// Table：       DHCHAI.IR.BPSurveyExec
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.BPSurveyExecSrv","QueryByCode","")
Query QueryByCode(aCode As %String, aHospIDs As %String = "", aActiveFalg As %String = "") As %Query(ROWSPEC = "ID:%String,SESurvNumber:%String,SESurvSttDate:%String,SESurvEndDate:%String,HospID:%String,HospCode:%String,HospDesc:%String,UserDr:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryByCodeExecute(ByRef qHandle As %Binary, aCode As %String, aHospIDs As %String = "", aActiveFalg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set aCode=$ZCVT($g(aCode),"U")
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set xID=0
 	For {
	 	Set xID=$o(^CT.MA.HAI.IR.BPSurveyExecD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.BPSurveyExec).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=obj.%Id()
	 	Set Code=obj.SESurvNumber
	 	Set SESurvSttDate=obj.SESurvSttDate
	 	Set SESurvEndDate=obj.SESurvEndDate
	 	Continue:(aCode'="")&&($zcvt(Code,"U")'[aCode)
	 	//院区
	 	Set SEHospIDs=obj.SEHospDr
	 	Set SEHospIDs=$tr(SEHospIDs,",","|")
		Set HospID="",HospCode="",HospDesc=""
		For xSEID=1:1:$l(SEHospIDs,"|"){
			Set SEHospID=$p(SEHospIDs,"|",xSEID)
			Continue:SEHospID=""
			
			Set HospID=HospID_"|"_SEHospID
			Set HospCode=HospCode_"|"_$li(^DHCHAI.BT.HospitalD(SEHospID),2)
			Set HospDesc=HospDesc_"|"_$li(^DHCHAI.BT.HospitalD(SEHospID),3)
		}
		Set:HospID'="" HospID=$e(HospID,2,$l(HospID))
		Set:HospCode'="" HospCode=$e(HospCode,2,$l(HospCode))
		Set:HospDesc'="" HospDesc=$e(HospDesc,2,$l(HospDesc))

		Set UserDr="",UserDesc=""
		If $IsObject(obj.SEUpdateUserDr) {
			Set UserDr=obj.SEUpdateUserDr.BTCode
			Set UserDesc=obj.SEUpdateUserDr.BTDesc
		}
		Continue:(aActiveFalg="1")&(SESurvEndDate<+$h)
		Set:SESurvSttDate'="" SESurvSttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SESurvSttDate)
		Set:SESurvEndDate'="" SESurvEndDate =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SESurvEndDate)
		Set Data=$lb(ID,Code,SESurvSttDate,SESurvEndDate,HospID,HospCode,HospDesc,UserDr,UserDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
