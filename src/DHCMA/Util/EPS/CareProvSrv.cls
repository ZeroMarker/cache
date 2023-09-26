/// 名称: DHCMA.Util.EPS.CareProvSrv
/// 描述: 医护人员 服务类
/// 编写者：yankai
/// 编写日期: 2018-09-07
Class DHCMA.Util.EPS.CareProvSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  yankai
/// CreatDate：   2018-09-07
/// Description:  查询医护人员列表
/// Table：       DHCMA.Util.EPx.CareProv
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.CareProvSrv","QryCareProvInfo")
Query QryCareProvInfo() As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,TypeCode:%String,TypeDesc:%String,RangeID:%String,RangeDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCareProvInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMA.Util.EPx.CareProvD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.EPx.CareProv).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set OID         = obj.OID
	 	Set Code        = obj.BTCode
		Set Desc        = obj.BTDesc
		Set TypeCode	= obj.BTType
		Set RangeID     = obj.BTRangeID
		Set IsActive    = obj.BTIsActive
		Set ActDate     = obj.BTActDate
		Set ActTime     = obj.BTActTime
		Set ActUserID   = obj.BTActUserID
		Continue:IsActive'=1
		Set TypeDesc=$s(TypeCode="D":"医生",TypeCode="N":"护士",1:"")
		
		Set RangeDesc=""
		Set objRange=##class(DHCMA.Util.EPx.CareProv).GetObjByOID(RangeID)
		If $IsObject(objRange){
			Set RangeDesc=objRange.BTDesc
		}
		
		Set ActUserDesc=""
		Set objActUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
		If $IsObject(objActUser){
			Set ActUserDesc=objActUser.BTDesc
		}
		
		//ID:%String,OID:%String,Code:%String,Desc:%String,Type:%String,TypeDesc:%String,RangeID:%String,RangeDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String
		set Data=$lb(xID,OID,Code,Desc,TypeCode,TypeDesc,RangeID,RangeDesc,IsActive,ActDate,ActTime,ActUserID,ActUserDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryCareProvInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCareProvInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCareProvInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCareProvInfoExecute ]
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
