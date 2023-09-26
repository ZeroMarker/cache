/// Desc:结果列设置
/// Creator:Candy
Class DHCEPRFS.BL.BLResultColumn Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Desc:获得结果列
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLResultColumn","GetColumns")
Query GetColumns(Column As %String) As %Query(ROWSPEC = "ColName,ColDesc")
{
}

ClassMethod GetColumnsExecute(ByRef qHandle As %Binary, Column As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRFS.META.ResultColumnI("IdxIsActive"," Y",sequence))
		q:(sequence = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.ResultColumnI("IdxIsActive"," Y",sequence,rowID))
			q:(rowID = "")
			s ColName = $li(^DHCEPRFS.META.ResultColumnD(rowID),3)
			continue:($f(Column,ColName)>0)
			s ColDesc = $li(^DHCEPRFS.META.ResultColumnD(rowID),2)
			s ^CacheTemp(repid,ind)=$lb(ColName,ColDesc)
			s ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetColumnsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetColumnsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetColumnsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetColumnsExecute ]
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

ClassMethod AddColumn(AID As %String, AName As %String, ADesc As %String, AIsActive As %String) As %String
{
	s result = -1
	q:(AName= "")||(ADesc = "") result
	if (AID = "")
	{
		s obj = ##Class(DHCEPRFS.META.ResultColumn).%New()
	}else
	{
		s obj = ##Class(DHCEPRFS.META.ResultColumn).%OpenId(AID)
	}
	s obj.ColDesc = ADesc
	s obj.ColName = AName
	s obj.IsActive = AIsActive
	s sc= obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

}
