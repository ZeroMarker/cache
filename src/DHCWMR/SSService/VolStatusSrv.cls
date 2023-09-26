/// 名称: DHCWMR.SSService.VolStatusSrv
/// 描述: 病案卷状态相关服务
/// 编写者：zhufei
/// 编写日期: 2014-09-20
Class DHCWMR.SSService.VolStatusSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-20
/// Description:  查询卷状态列表
/// Table：       DHCWMR.SS.Volume
/// Input：       VolID : 病案卷ID
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolStatusSrv","QryStatusList","")
Query QryStatusList(aVolID As %String) As %Query(ROWSPEC = "VStatusID:%String,StatusDesc:%String,ActDate:%String,ActTime:%String,UserFrom:%String,UserTo:%String,BatchNumber:%String,UpdoOpera:%String,UpdoReason:%String,UpdoDate:%String,UpdoTime:%String,UpdoUser:%String")
{
}

ClassMethod QryStatusListExecute(ByRef qHandle As %Binary, aVolID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aVolID="" $$$OK
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) $$$OK
	Quit:objVol.SVIsActive'=1 $$$OK
	
	For indStatus=1:1:objVol.ChildStatus.Count() {
		Set objStatus=objVol.ChildStatus.GetAt(indStatus)
		Continue:'$IsObject(objStatus)
		Continue:'$IsObject(objStatus.VSStatus)
		
		Set VStatusID=objStatus.%Id()
		Set StatusDesc=objStatus.VSStatus.WIDesc
		Set ActDate=objStatus.VSActDate
		Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set ActTime=objStatus.VSActTime
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set UserFrom=objStatus.VSUserFrom
		Set:UserFrom'="" UserFrom=$p($g(^SSU("SSUSR",+UserFrom)),"^",2)
		Set UserTo=objStatus.VSUserTo
		Set:UserTo'="" UserTo=$p($g(^SSU("SSUSR",+UserTo)),"^",2)
		Set BatchNumber=objStatus.VSBatchNumber
		Set UpdoOpera=objStatus.VSUpdoOpera
		Set UpdoDate=objStatus.VSUpdoDate
		Set:UpdoDate'="" UpdoDate=$zd(UpdoDate,3)
		Set UpdoTime=objStatus.VSUpdoTime
		Set:UpdoTime'="" UpdoTime=$zt(UpdoTime,2)
		Set UpdoUser=objStatus.VSUpdoUser
		Set:UpdoUser'="" UpdoUser=$p($g(^SSU("SSUSR",+UpdoUser)),"^",2)
		Set UpdoReason=objStatus.VSUpdoReason
		
		Set Data=$lb(VStatusID,StatusDesc,ActDate,ActTime,UserFrom,UserTo,BatchNumber,UpdoOpera,UpdoReason,UpdoDate,UpdoTime,UpdoUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryStatusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatusListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatusListExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2014-09-20
/// Description:  查询卷状态附加信息
/// Table：       DHCWMR.SS.VolStatus、DHCWMR.SS.Operation、DHCWMR.SS.OperaDetail
/// Input：       VStatusID : 卷状态ID
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolStatusSrv","QryStatusDtl","")
Query QryStatusDtl(aVStatusID As %String) As %Query(ROWSPEC = "VStatusID:%String,VSDetailID:%String,ItemDesc:%String,ItemType:%String,ItemValue:%String,ItemText:%String")
{
}

ClassMethod QryStatusDtlExecute(ByRef qHandle As %Binary, aVStatusID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aVStatusID="" $$$OK
	
	Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(aVStatusID)
	Quit:'$IsObject(objStatus) $$$OK
	Set VStatusID=objStatus.%Id()
	Set BatchNumber=objStatus.VSBatchNumber
	Quit:BatchNumber="" $$$OK
	Set objOpera=##class(DHCWMR.SS.Operation).GetObjByBatchNumber(BatchNumber)
	Quit:'$IsObject(objOpera) $$$OK
	
	For indDtl=1:1:objStatus.ChildDetail.Count() {
		Set objDetail=objStatus.ChildDetail.GetAt(indDtl)
		Continue:'$IsObject(objDetail)
		Continue:'$IsObject(objDetail.ODItem)
		Set VSDetailID=objDetail.%Id()
		Set ItemDesc=objDetail.ODItem.WDDesc
		Set ItemType=objDetail.ODItem.WDType
		Set ItemDicCode=objDetail.ODItem.WDDicCode
		Set ItemValue=objDetail.ODValue
		Set ItemText=objDetail.ODText
		If ItemDicCode="D" {
			For indVal=1:1:$l(ItemValue,"#") {
				Set tmpValue=$p(ItemValue,"#",indVal)
				Continue:tmpValue=""
				Set tmpText=##class(DHCWMR.SS.OperaDetail).GetItemText(ItemDicCode,tmpValue)
				Continue:tmpText=""
				Set ItemText=ItemText_"#"_tmpText
			}
		}
		Set:$e(ItemText,1,2)="#" ItemText=$e(ItemText,2,$l(ItemText))
		Set:ItemText'="" ItemText=$tr(ItemText,"#","、")
		
		Set data=$lb("")
		Set $li(data,1)=dtl.%Id()
		Set $li(data,2)=dtl.VSDItem.%Id()
		Set $li(data,3)=dtl.VSDItem.WDDesc
		Set $li(data,4)=$tr(dtl.VSDText,"#","、")
		Set:dtl.VSDItem.WDType'="D" $li(data,4)=dtl.VSDValue
		Set $li(data,5)=dtl.VSDValue
		
		Set Data=$lb(VStatusID,VSDetailID,ItemDesc,ItemType,ItemValue,ItemText)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryStatusDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatusDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStatusDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatusDtlExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:		zhouruimeng
/// CreatDate:		2016-03-15
/// Description:	根据就诊号取病历的上一个状态
/// Input:			aEpsiodeID
/// Return:			状态描述
/// w ##class(DHCWMR.SSService.VolStatusSrv).GetPremStatus(14)
ClassMethod GetPremStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Set VolumeID=objVol.%Id()
	
	Set PreSubID=objVol.ChildStatus.Count()
	For {
		Set PreSubID=$o(^DHCWMR.SS.VolumeD(VolumeID,"S",PreSubID),-1)
		Quit:PreSubID=""
		Quit:return'=""
		
		Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(VolumeID_"||"_PreSubID)
		Continue:'$IsObject(objVolStatus)
		Continue:'$IsObject(objVolStatus.VSStatus)
		Continue:objVolStatus.VSUpdoOpera'="" //撤销状态 作废或回置
		Set StatusDesc=objVolStatus.VSStatus.WIDesc
		Set return=StatusDesc		
	}
	
	Quit return
}

}
