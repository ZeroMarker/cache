Class DHCEPRFS.BL.BLMetaBase Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:杨鹏
/// CreateDate:20170821
/// Desc:获得所有省份字典
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaBase","GetAllProvince","")
Query GetAllProvince() As %Query(ROWSPEC = "Id:%String,Code:%String,Name:%String,Description:%String,Source:%String,OrderNum:%Integer,IsActive:%String")
{
}

ClassMethod GetAllProvinceExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s ProvinceID=""
 	for {
	 	s ProvinceID=$o(^DHCEPRFS.META.B.ProvinceD(ProvinceID))
	 	q:(ProvinceID="")
	 	s objProvince=##class(DHCEPRFS.META.B.Province).%OpenId(ProvinceID)
	 	s data = $lb(objProvince.%Id(),objProvince.Code,objProvince.Name,objProvince.Description,objProvince.Source,
	 			objProvince.OrderNum,objProvince.IsActive)
		s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod GetAllProvinceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllProvinceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetAllProvinceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllProvinceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:杨鹏
/// CreateDate:20170821
/// Desc:获得所有婚姻能字典
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaBase","GetAllMarriage","")
Query GetAllMarriage() As %Query(ROWSPEC = "Id:%String,Code:%String,Name:%String,Description:%String,Source:%String,OrderNum:%Integer,IsActive:%String")
{
}

ClassMethod GetAllMarriageExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s MarriageID=""
 	for {
	 	s MarriageID=$o(^DHCEPRFS.META.B.MarriageD(MarriageID))
	 	q:(MarriageID="")
	 	s objMarriage=##class(DHCEPRFS.META.B.Marriage).%OpenId(MarriageID)
	 	s data = $lb(objMarriage.%Id(),objMarriage.Code,objMarriage.Name,objMarriage.Description,objMarriage.Source,
	 			objMarriage.OrderNum,objMarriage.IsActive)
		s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod GetAllMarriageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllMarriageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetAllMarriageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllMarriageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
