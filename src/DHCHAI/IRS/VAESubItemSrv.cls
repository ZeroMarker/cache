/// 名称: DHCHAI.IRS.VAESubItemSrv
/// 描述: VAE监测项目子项服务类
/// 编写者: zhoubo
/// 编写日期: 2022-01-13
Class DHCHAI.IRS.VAESubItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-01-13
/// Description:  查询VAE监测项目
/// Table：       DHCHAI.IR.VAESubItem
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAESubItemSrv","QueryMonitSItem")
Query QueryMonitSItem(aAlias As %String = "", aActive As %String = "") As %Query(ROWSPEC = "ID:%String,VASItmCode:%String,VASItmDesc:%String,VASResume:%String,VASIsActive:%String,VASActDate:%String,VASActTime:%String,VASActUserDr:%String,VASActUser:%String") [ SqlProc ]
{
}

ClassMethod QueryMonitSItemExecute(ByRef qHandle As %Binary, aAlias As %String = "", aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^CT.MA.HAI.IR.VAESubItemD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.VAESubItem).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set VASItmCode  = obj.VASItmCode
		Set VASItmDesc  = obj.VASItmDesc
		Set VASResume   = obj.VASResume
		Set VASIsActive=obj.VASIsActive
		Continue:(aActive'="")&&(aActive'=VASIsActive)
		If (aAlias'=""){
			Continue:(VASItmCode_VASItmDesc_VASResume)'[aAlias
		}
		Set VASIsActive=$s(VASIsActive=1:"是",1:"否")
		
		Set VASActDate = obj.VASActDate
		Set:VASActDate'="" VASActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VASActDate)
		Set VASActTime = obj.VASActTime
		Set:VASActTime'="" VASActTime=$zt(VASActTime,1)
		
		If $IsObject(obj.VASActUserDr) {
			Set VASActUserDr = obj.VASActUserDr.%Id()
			Set VASActUser   = obj.VASActUserDr.BTDesc
		} Else {
			Set VASActUserDr="",VASActUser=""
		}
		
		set Data=$lb(xID,VASItmCode,VASItmDesc,VASResume,VASIsActive,VASActDate,VASActTime,VASActUserDr,VASActUser)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryMonitSItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMonitSItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMonitSItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMonitSItemExecute ]
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
