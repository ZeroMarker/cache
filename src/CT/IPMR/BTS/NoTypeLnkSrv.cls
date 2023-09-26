/// 名称:CT.IPMR.BTS.NoTypeLnkSrv
/// 描述:号码类型关联服务
/// 创建者:WHui
/// 创建日期:2019-10-27
Class CT.IPMR.BTS.NoTypeLnkSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     WHui
/// CreatDate：   2019-10-28
/// Description:  查询病案号码类型关联科室
/// Table：       CT.IPMR.BT.NoTypeLnk
/// Input：       NoTypeID : CT.IPMR.BT.NoType.ID 号码类型
/// Return：      返回Query
/// Debug:		  D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.NoTypeLnkSrv","QryNoTpLocList","7||2")
Query QryNoTpLocList(aNoTypeID As %String) As %Query(ROWSPEC = "ID:%String,LocID:%String,LocDesc:%String,HospID:%String,HospDesc:%String")
{
}

ClassMethod QryNoTpLocListExecute(ByRef qHandle As %Binary, aNoTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aNoTypeID="") $$$OK
 	
 	Set xSub=0
 	For {
	 	Set xSub=$o(^CT.IPMR.BT.MrTypeD(+aNoTypeID,"NoType",+$p(aNoTypeID,"||",2),"Link",xSub))
	 	Quit:xSub=""
	 	
	 	Set objNoTpLnk=##class(CT.IPMR.BT.NoTypeLnk).GetObjById(aNoTypeID_"||"_xSub)
	 	Continue:'$IsObject(objNoTpLnk)
	 	Set ID = aNoTypeID_"||"_xSub
	 	Set LocID=objNoTpLnk.BNLocID
	 	Continue:LocID=""
	 	;Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	 	Set LocInfo	= ##class(MA.IPMR.BTS.LocationSrv).GetLocStrById(LocID)
	 	Set LocDesc=$p(LocInfo,"^",2)
	 	Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	 	
	 	Set HospID=objNoTpLnk.BNHospID
	 	;Set:HospID'="" HospDesc = $p($g(^CT("HOSP",+HospID)),"^",2)
	 	Set:HospID'="" HospInfo = ##class(MA.IPMR.BTS.HospitalSrv).GetHospStrById(+HospID)
	 	Set HospDesc=$p(HospInfo,"^",2)
		Set Data=$lb(ID,LocID,LocDesc,HospID,HospDesc)
		Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryNoTpLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNoTpLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNoTpLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNoTpLocListExecute ]
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
