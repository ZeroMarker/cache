/// 名称: DHCHAI.IRS.VAEMonitItemSrv
/// 描述: VAE监测项目相关服务类
/// 编写者: zhoubo
/// 编写日期: 2022-01-13
Class DHCHAI.IRS.VAEMonitItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  查询VAE监测项目
/// Table：       DHCHAI.IR.VAEMonitItem
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAEMonitItemSrv","QueryMonitItem")
Query QueryMonitItem(aAlias As %String = "", aActive As %String = "") As %Query(ROWSPEC = "ID:%String,VAItmCode:%String,VAItmDesc:%String,VAResume:%String,HospID:%String,HospDesc:%String,VAIsActive:%String,VAActDate:%String,VAActTime:%String,VAActUserDr:%String,VAActUser:%String") [ SqlProc ]
{
}

ClassMethod QueryMonitItemExecute(ByRef qHandle As %Binary, aAlias As %String = "", aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^CT.MA.HAI.IR.VAEMonitItemD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.VAEMonitItem).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set VAItmCode  = obj.VAItmCode
		Set VAItmDesc  = obj.VAItmDesc
		Set VAResume   = obj.VAResume
		Set HospID="",HospCode="",HospDesc=""
		If $IsObject(obj.VAHospDr) {
			Set HospID   = obj.VAHospDr.%Id()
	 		Set HospCode = obj.VAHospDr.BTCode
	 		Set HospDesc = obj.VAHospDr.BTDesc
		}
		If (aAlias'=""){
			Continue:(VAItmCode_VAItmDesc_VAResume)'[aAlias
		}
		Set VAIsActive=obj.VAIsActive
		Continue:(aActive'="")&&(aActive'=VAIsActive)
	
		Set VAIsActive=$s(VAIsActive=1:"是",1:"否")
		
		Set VAActDate = obj.VAActDate
		Set:VAActDate'="" VAActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VAActDate)
		Set VAActTime = obj.VAActTime
		Set:VAActTime'="" VAActTime=$zt(VAActTime,1)
		
		If $IsObject(obj.VAActUserDr) {
			Set VAActUserDr = obj.VAActUserDr.%Id()
			Set VAActUser   = obj.VAActUserDr.BTDesc
		} Else {
			Set VAActUserDr="",VAActUser=""
		}
		
		set Data=$lb(xID,VAItmCode,VAItmDesc,VAResume,HospID,HospDesc,VAIsActive,VAActDate,VAActTime,VAActUserDr,VAActUser)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryMonitItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMonitItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMonitItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMonitItemExecute ]
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
