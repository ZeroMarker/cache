/// 名称: DHCCPW.MRC.CPWD.PathWayDicSrv
/// 描述: 临床路径字典相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-18
Class DHCCPW.MRC.CPWD.PathWayDicSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:      zhufei
/// CreatDate:    2015-06-18
/// Description:  查询临床路径字典
/// Table:        User.DHCMRCClinPathWaysDic
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.CPWD.PathWayDicSrv","QryPathWayDic","炎")
Query QryPathWayDic(aCPWDAlias As %String) As %Query(ROWSPEC = "CPWDID:%String,CPWDDesc:%String,CPWDTypeID:%String,CPWDTypeDesc:%String")
{
}

ClassMethod QryPathWayDicExecute(ByRef qHandle As %Binary, aCPWDAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Count=0
	Set xCPWDID=0
	For {
		Set xCPWDID=$o(^DHCMRC("CPWD",xCPWDID))
		Quit:xCPWDID=""
		Quit:Count>30
		
		Set objCPWD=##class(User.DHCMRCClinPathWaysDic).GetObjById(xCPWDID)
		Continue:'$IsObject(objCPWD)
		
		Set CPWDCode=objCPWD.CPWDCode
		Set CPWDDesc=objCPWD.CPWDDesc
		Continue:(aCPWDAlias'="")&&(CPWDDesc'[aCPWDAlias)
		Continue:'$IsObject(objCPWD.CPWDCPWTypeDR)
		Set CPWDTypeID=objCPWD.CPWDCPWTypeDR.%Id()
		Set CPWDTypeDesc=objCPWD.CPWDCPWTypeDR.CLPTDesc
		Set CPWDActive=objCPWD.CPWDActive
		Continue:CPWDActive'["Y"
		
		Set Count=Count+1
		Set Data=$lb(CPWDID,CPWDDesc,CPWDTypeID,CPWDTypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryPathWayDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathWayDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPathWayDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathWayDicExecute ]
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
