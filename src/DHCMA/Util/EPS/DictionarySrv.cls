/// 名称: DHCMA.Util.EPS.DictionarySrv
/// 描述: 系统字典 服务类
/// 编写者：刘贞贺
/// 编写日期: 2018-09-31
Class DHCMA.Util.EPS.DictionarySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	  刘贞贺
/// CreatDate：   2018-09-25
/// Description:  Update  补充OID参数
/// Table：       DHCMA.Util.EPx.Dictionary
/// Input：       
/// w ##class(DHCMA.Util.EPS.DictionarySrv).Update("5^^999^9999^2^1^1^","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set OID      = $p(aInputStr,aSeparete,2)
	Set Code     = $p(aInputStr,aSeparete,3)
	Set Desc     = $p(aInputStr,aSeparete,4)
	Quit:ID=""||Code=""||Desc="" return

	if (OID="")
	{	
		Set obj=##class(DHCMA.Util.EPx.Dictionary).GetObjById(ID)
		Set OID=obj.OID
	}
	Quit:OID="" return
	Set flag=##class(DHCMA.Util.EPS.OIDService).GetValidOID(OID)
	Quit:flag="" return
	
	Set $p(aInputStr,aSeparete,2) = OID
	Set return=##class(DHCMA.Util.EPx.Dictionary).Update(aInputStr,aSeparete)
	b
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-4
/// Description:  查询系统字典类型
/// Table：       DHCMA.Util.BT.DicType
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.DictionarySrv","QryHISDicType")
Query QryHISDicType() As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String")
{
}

ClassMethod QryHISDicTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For{
	 	Set xID=$o(^DHCMA.Util.BT.DicTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.BT.DicType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.BTCode
	 	Set Desc     = obj.BTDesc
	 	Set ProductID="",ProductCode="",BTProductDesc =""
	 	If $IsObject(obj.BTProductDr){
	    	Set ProductID   = obj.BTProductDr.%Id()
		 	Set ProductCode = obj.BTProductDr.ProCode
	    	Set ProductDesc = obj.BTProductDr.ProDesc
	 	}
	 	Continue:(ProductCode'="HIS")  //只查询HIS对应字典类型
	    
		Set Data=$lb(xID,Code,Desc,ProductID,ProductDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryHISDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHISDicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHISDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHISDicTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	  刘贞贺
/// CreatDate：   2018-09-25
/// Description:  查询字典列表
/// Table：       DHCMA.Util.EPx.Dictionary
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.Util.EPS.DictionarySrv","QryDicInfo","")
Query QryDicInfo(aTypeDr As %String, aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,OID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,RangeID:%String,RangeDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDicInfoExecute(ByRef qHandle As %Binary, aTypeDr As %String, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:aTypeDr="" $$$OK
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMA.Util.EPx.DictionaryD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.EPx.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set OID         = obj.OID
	 	Set Code        = obj.BTCode
		Set Desc        = obj.BTDesc
		Set RangeID     = obj.BTRangeID
		Set IsActive    = obj.BTIsActive
		Set ActDate     = obj.BTActDate
		Set ActTime     = obj.BTActTime
		Set ActUserID   = obj.BTActUserID
		
		Set TypeID="",TypeCode="",TypeDesc=""
		If $IsObject(obj.BTTypeDr) {
			Set TypeID=obj.BTTypeDr.%Id()
			Set TypeCode=obj.BTTypeDr.BTCode
			Set TypeDesc=obj.BTTypeDr.BTDesc
		}
		Continue:(aTypeDr'=TypeID)

		Continue:(aAlias'="")&&(Desc'[aAlias)&&(aAlias'[Desc)
	
		Set RangeDesc=""
		Set objRange=##class(DHCMA.Util.EPx.Dictionary).GetObjByOID(TypeCode,RangeID)
		If $IsObject(objRange){
			Set RangeDesc=objRange.BTDesc
		}
		
	 	Set IsActive=$s(IsActive=1:"是",1:"否")
	 	Set:ActDate'="" ActDate=$zd(ActDate,3)
	 	Set:ActTime'="" ActTime=$zt(ActTime,1)
	 	Set ActUserDesc=""
	 	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	If ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}
	 	
		set Data=$lb(xID,OID,Code,Desc,TypeID,TypeCode,TypeDesc,RangeID,RangeDesc,IsActive,ActDate,ActTime,ActUserID,ActUserDesc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryDicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicInfoExecute ]
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
