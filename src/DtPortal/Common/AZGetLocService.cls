Class DtPortal.Common.AZGetLocService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 获取科室列表
/// creted by zhaowentao
/// 入参：
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.AZGetLocService","QueryLocData")
Query QueryLocData() As DtPortal.Query(ROWSPEC = "LocRowID,LocCode,LocName") [ SqlProc ]
{
}

ClassMethod QueryLocDataExecute(ByRef qHandle As %Binary) As %Status
{
	new (qHandle)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	set LocGroupID1=0
	for
	{
		set LocGroupID1=$o(^DtPortal.Configure.LocGroupD(LocGroupID1))
		q:LocGroupID1=""
		set LocGroupID2=0
		for
		{
			set LocGroupID2=$o(^DtPortal.Configure.LocGroupD(LocGroupID1,"Log",LocGroupID2))
			q:LocGroupID2=""
			set aId=LocGroupID1_"||"_ LocGroupID2
			Set obj=##Class(DtPortal.Configure.LocGroupSub).%OpenId(aId)
			continue:'$IsObject(obj)
			set type=obj.LocGroupType
			continue:type'="I"
			set LocRowID=aId ;obj.LocGroupLocID.%Id()
			set LocCode=obj.LocGroupLocID.CTLOCCode
			set LocName=obj.LocGroupLocID.CTLOCDesc
			Set Data=$lb(LocRowID,LocCode,LocName)
			Set ^||CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 }
	 
	q $$$OK
}

// 根据科室组 配置中的字表id 获取其父记录下的所有的字表id	

// d ##class(%ResultSet).RunQuery("DtPortal.Common.AZGetLocService","getDDlocSubId","1||1")

Query getDDlocSubId(locId As %String) As DtPortal.Query(ROWSPEC = "locId:%String") [ SqlProc ]
{
}

ClassMethod getDDlocSubIdExecute(ByRef qHandle As %Binary, locId As %String) As %Status
{
	n (qHandle,locId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	if locId=""   quit $$$OK	
	set alocGroupID=locId
	set:locId["||" alocGroupID=$p(locId,"||",1)
	set locGroupSubID=""
	for
		{
			set locGroupSubID=$o(^DtPortal.Configure.LocGroupD(alocGroupID,"Log",locGroupSubID))
			quit:locGroupSubID=""
		
			set subRowID=alocGroupID_"||"_locGroupSubID
			set subObj=##class(DtPortal.Configure.LocGroupSub).GetObjById(subRowID)
			continue:'$IsObject(subObj)
			set LocGroupType=subObj.LocGroupType
			continue:LocGroupType'="I"
			set LocID=subObj.LocGroupLocID.%Id()
			Set Data=$lb(subRowID)
			s ^||CacheTemp(repid,ind)=Data
 	        s ind=ind+1
			
		}
	
	Quit $$$OK
}

}
