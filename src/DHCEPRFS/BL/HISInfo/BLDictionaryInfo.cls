/// Desc:字典接口
/// Creator:Candy
Class DHCEPRFS.BL.HISInfo.BLDictionaryInfo Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Desc:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLDictionaryInfo","CTLoc")
Query CTLoc() As %Query(ROWSPEC = "rowid:%String,Code:%String,Desc:%String,Alias:%String")
{
}

ClassMethod CTLocExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
		
	s LocID	= $g(ALocID)
	s LocName = $g(ALocName)
		
	s RowID = ""
	for {
		s RowID = $o(^CTLOC(0,"LocType","E",RowID))
		q:(RowID = "")
		
		s objCtLoc = $g(^CTLOC(+RowID))
		s Code =  $p(objCtLoc,"^",1)
		s Desc = $p(objCtLoc,"^",2)
		//continue:(Desc [ "门诊")
		//continue:(Desc [ "医院")
		continue:(Desc [ "诊室")					//华西医院专用
		continue:(Desc [ "取消")
		continue:(Desc [ "停")
		s ContactName = $p(objCtLoc,"^",43)			//一些医院用于存储科室或病区拼音码
		s:(ContactName = "") ContactName = $p($p(objCtLoc,"^",2),"-",1)
		s:(Desc [ "-") Desc = $p(Desc,"-",2) 
		s ^CacheTemp(repid,ind) = $lb(RowID,Code,Desc,ContactName)
		s ind = ind + 1		
	}
	Quit $$$OK
}

ClassMethod CTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTLocExecute ]
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

/// Desc:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLDictionaryInfo","Doctor")
Query Doctor() As %SQLQuery(ROWSPEC = "UserID:%String,UserName:%String")
{
	select CTPCP_RowId1 as UserID ,CTPCP_Desc as UserName
	from SQLUser.CT_CareProv
	order by CTPCP_Desc
}

/// 病房
/// Desc:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLDictionaryInfo","Ward")
Query Ward() As %SQLQuery(ROWSPEC = "rowid:%String,Desc:%String")
{
	SELECT WARD_Desc AS rowid,WARD_Desc AS Name FROM SQLUser.PAC_Ward
}

}
