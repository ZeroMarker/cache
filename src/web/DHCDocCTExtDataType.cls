Import SQLUser

Class web.DHCDocCTExtDataType Extends %RegisteredObject
{

/// w ##class(web.DHCDocCTExtDataType).InsertExtDataType(^jason)
ClassMethod InsertExtDataType(Instr As %String) As %String
{
	k PLIST
	s PLIST(2)=$p(Instr,"^",1)
	s PLIST(3)=$p(Instr,"^",2)
	s PLIST(4)=$p(Instr,"^",3)
	s PLIST(5)=$p(Instr,"^",4)
	s PLIST(6)=$p(Instr,"^",5)
	s PLIST(7)=$p(Instr,"^",6)
	s PLIST(8)=$p(Instr,"^",7)
	s PLIST(9)=$p(Instr,"^",8)
	&sql(insert into DHCDoc_CT_ExtDataType values :PLIST())
	b ;
	q SQLCODE
}

ClassMethod UpdateExtDataType(InStr As %String, CTEDTRowid As %String) As %String
{
	q:CTEDTRowid="" 100
	s CTEDTCode=$p(InStr,"^",1)
	s CTEDTDesc=$p(InStr,"^",2)
	s CTEDTClassName=$p(InStr,"^",3)
	s CTEDTQueryName=$p(InStr,"^",4)
	s CTEDTActive=$p(InStr,"^",5)
	s CTEDTTable=$p(InStr,"^",6)
	s CTEDTTableCode=$p(InStr,"^",7)
	s CTEDTTableDesc=$p(InStr,"^",8)
	&sql(update DHCDoc_CT_ExtDataType set CTEDT_Code=:CTEDTCode,
	                                      CTEDT_Desc=:CTEDTDesc,
	                                      CTEDT_ClassName=:CTEDTClassName,
	                                      CTEDT_QueryName=:CTEDTQueryName,
	                                      CTEDT_Active=:CTEDTActive,
	                                      CTEDT_Table=:CTEDTTable,
	                                      CTEDT_TableCode=:CTEDTTableCode,
	                                      CTEDT_TableDesc=:CTEDTTableDesc
		                            where CTEDT_Rowid=:CTEDTRowid)
	
	q SQLCODE
}

ClassMethod QueryExtDataTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExtDataTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocCTExtDataType","QueryExtDataType")
ClassMethod QueryExtDataTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	s CTEDTRowId="" for {
		set CTEDTRowId=$o(^DHCDOCCTEDT("CTEDT",CTEDTRowId)) quit:CTEDTRowId=""
		s CTEDTCode=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",1)
		s CTEDTDesc=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",2)
		s CTEDTClassName=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",3)
		s CTEDTQueryName=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",4)
		s CTEDTActive=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",5)
		i CTEDTActive="Y" s CTEDTActive="是"
		e  s CTEDTActive="否"
		s CTEDTTable=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",6)
		s CTEDTTableCode=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",7)
		s CTEDTTableDesc=$p($g(^DHCDOCCTEDT("CTEDT",CTEDTRowId)),"^",8)
		b ;;;;
		d OutputRow2
		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2     
	set Data=$lb(CTEDTRowId,CTEDTCode,CTEDTDesc,CTEDTClassName,CTEDTQueryName,CTEDTActive,CTEDTTable,CTEDTTableCode,CTEDTTableDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QueryExtDataTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExtDataTypeExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query QueryExtDataType() As %Query(ROWSPEC = "TCTEDTRowId:%String,TCTEDTCode:%String,TCTEDTDesc:%String,TCTEDTClassName:%String,TCTEDTQueryName:%String,TCTEDTActive:%String,TCTEDTTable:%String,TCTEDTTableCode:%String,TCTEDTTableDesc:%String")
{
}

}
