/// 名称: DHCMA.Util.EPS.SSUserSrv
/// 描述: 用户字典 服务类
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.EPS.SSUserSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  zhufei
/// CreatDate：   2018-07-31
/// Description:  查询用户列表
/// Table：       DHCMA.Util.EPx.SSUser
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.SSUserSrv","QryUserInfo")
Query QryUserInfo(aHospID As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,LocID:%String,LocDesc:%String,CareProvID:%String,CareProvName:%String,CareProvTpCode:%String,CareProvTpDesc:%String,RangeID:%String,RangeDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryUserInfoExecute(ByRef qHandle As %Binary, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMA.Util.EPx.SSUserD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.EPx.SSUser).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set OID         = obj.OID
	 	Set Code        = obj.BTCode
		Set Desc        = obj.BTDesc
		Set LocID       = obj.BTLocID
		Set CareProvID  = obj.BTCareProvID
		Set RangeID     = obj.BTRangeID
		Set IsActive    = obj.BTIsActive
		Set IsActDesc	= $SELECT(obj.BTIsActive:"是",1:"否")
		Set ActDate     = obj.BTActDate
		Set ActTime     = obj.BTActTime
		Set ActUserID   = obj.BTActUserID
		
		//院区检查
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("SS_User",+OID,aHospID)
		 	Continue:retFlg'="Y"
		}
		
		Set LocDesc=""
		Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(LocID)
		If $IsObject(objLoc){
			Set LocDesc=objLoc.BTDesc
		}
		
		Set CareProvName="",CareProvTpCode="",CareProvTpDesc=""
		Set objCareProv=##class(DHCMA.Util.EP.CareProv).GetObjByOID(CareProvID)
		If $IsObject(objCareProv){
			Set CareProvName=objCareProv.BTDesc
			Set CareProvTpCode=objCareProv.BTType
		}
		Set CareProvTpDesc=$s(CareProvTpCode="D":"医生",CareProvTpCode="N":"护士",1:"")
		
		Set RangeDesc=""
		Set objRange=##class(DHCMA.Util.EPx.SSUser).GetObjByOID(RangeID)
		If $IsObject(objRange){
			Set RangeDesc=objRange.BTDesc
		}
		
		Set ActUserDesc=""
		Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
			Set ActUserDesc=objActUser.BTDesc
		}
		
		set Data=$lb(xID,OID,Code,Desc,LocID,LocDesc,CareProvID,CareProvName,CareProvTpCode,CareProvTpDesc,RangeID,RangeDesc,IsActive,IsActDesc,ActDate,ActTime,ActUserID,ActUserDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserInfoExecute ]
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
