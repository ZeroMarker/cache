/// 名称: DHCWMR.SSService.ReceiptLogSrv
/// 描述: 接诊日志查询服务
/// 编写者：zhufei
/// 编写日期: 2014-09-29
Class DHCWMR.SSService.ReceiptLogSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2014-09-15
/// Description:  通过就诊号查询患者接诊日志
/// Table：       DHCWMR.SS.ReceiptLog
/// Input：       aPaadm
/// d ##class(%ResultSet).RunQuery("DHCWMR.SSService.ReceiptLogSrv","QryReceiptLog","282")
Query QryReceiptLog(aPaadm As %String) As %Query(ROWSPEC = "xID:%String,OperType:%String,MrTypeID:%String,MrTypeDesc:%String,MrNo:%String,Paadm:%String,VolumeID:%String,RecLoc:%String,RecUser:%String,RecDate:%String,RecTime:%String")
{
}

ClassMethod QryReceiptLogExecute(ByRef qHandle As %Binary, aPaadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aPaadm="") $$$OK
	
	Set xID=0
	For {
		Set xID=$o(^DHCWMR.SS.ReceiptLogI("IndexPaadm"," "_aPaadm,xID))
		Quit:xID=""
		
		Set obj=##class(DHCWMR.SS.ReceiptLog).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.MrType)
		
		Set OperType = obj.OperType
		Set:OperType=0 OperType="接诊"
		Set:OperType=1 OperType="接诊成功"
		Set:OperType=2 OperType="取消接诊"
		Set:OperType=3 OperType="取消接诊成功"
		Set MrTypeID = obj.MrType.%Id()
		Set MrTypeDesc = obj.MrType.MTDesc
		Set MrNo = obj.MrNo
		Set VolumeID = obj.Volume
		Set Paadm = obj.Paadm
		Set RecLoc = obj.RecLoc
		Set:RecLoc'="" RecLoc=$p($g(^CTLOC(RecLoc)),"^",2)
		Set:RecLoc["-" RecLoc=$p(RecLoc,"-",2)
		Set RecUser = obj.RecUser
		Set:RecUser'="" RecUser=$p($g(^SSU("SSUSR",RecUser)),"^",2)
		Set RecDate = obj.RecDate
		Set:RecDate'="" RecDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(RecDate)
		Set RecTime = $zt(obj.RecTime)
		Set Data = $lb(xID,OperType,MrTypeID,MrTypeDesc,MrNo,Paadm,VolumeID,RecLoc,RecUser,RecDate,RecTime)
		Set ^CacheTemp(repid,ind) = Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryReceiptLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReceiptLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReceiptLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReceiptLogExecute ]
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
