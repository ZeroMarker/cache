Class DHCEPRRBAC.BL.BLOperation Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLOperation","GetOperation")
Query GetOperation() As %Query(ROWSPEC = "OperationID:%String,OpName:%String,OpCode:%String,OpDesc:%String")
{
}

ClassMethod GetOperationExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s rowID = ""
	for	{
		s rowID = $o(^DHCEPRRBAC.META.OperDFD(rowID))
		q:(rowID = "")

		s obj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(rowID)
		s active = obj.OpActive
		
		continue:((obj.OpActive '= "Y") && (obj.OpActive '= "1"))
		
		s name = obj.OpName
		s code = obj.OpCode
		s desc = obj.OpDesc
		
		s ^CacheTemp(repid,ind) = $lb(rowID,name,code,desc)
	    s ind=ind+1		
   }
   Quit $$$OK
}

ClassMethod GetOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationExecute ]
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

}
