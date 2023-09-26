Import SQLUSER

Class web.DHCICUCSpeedUnit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCICUCSpeedUnit","FindQuerySpeed")
Query FindQuerySpeed(type As %String = "") As %Query(ROWSPEC = "ANCSUCode:%String,ANCSUDesc:%String,ANCSUType:%String,ANCSUUomDr:%String,ANCSUFactor:%String,ANCSUByPatWeight:%String,ANCSUBaseSpeedUnitDr:%String,ANCSUBaseUomFactor:%String,Rowid:%String,ANCSUBaseSpeedUnitDrdesc:%String") [ SqlProc ]
{
}

ClassMethod FindQuerySpeedExecute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s rowid=0
	
	f  s rowid=$o(^DHCICUC("SUnit",rowid))  q:rowid=""  d
		.s ANCSUCode=$p(^DHCICUC("SUnit",rowid),"^",1)
		.s ANCSUDesc=$p(^DHCICUC("SUnit",rowid),"^",2)
		.s ANCSUType=$p(^DHCICUC("SUnit",rowid),"^",3)
		.s ANCSUUomDr=$p(^DHCICUC("SUnit",rowid),"^",4)
		.s ANCSUFactor=$p(^DHCICUC("SUnit",rowid),"^",5)
		.s ANCSUByPatWeight=$p(^DHCICUC("SUnit",rowid),"^",6)
		.s ANCSUBaseSpeedUnitDr=$p(^DHCICUC("SUnit",rowid),"^",7)
		.s ANCSUBaseUomFactor=$p($g(^DHCICUC("SUnit",rowid)),"^",8)
		.s Rowid=rowid
		.i ANCSUBaseSpeedUnitDr'=""  d
			..s ANCSUBaseSpeedUnitDrdesc=$p(^DHCICUC("SUnit",ANCSUBaseSpeedUnitDr),"^",1)
		.i ANCSUBaseSpeedUnitDr=""  d
			..s ANCSUBaseSpeedUnitDrdesc=""
		.d OutRowtyp11
	
	s qHandle=$lb(0,repid,0)  
     q $$$OK

OutRowtyp11
	s Data=$lb(ANCSUCode,ANCSUDesc,ANCSUType,ANCSUUomDr,ANCSUFactor,ANCSUByPatWeight,ANCSUBaseSpeedUnitDr,ANCSUBaseUomFactor,Rowid,ANCSUBaseSpeedUnitDrdesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindQuerySpeedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuerySpeedExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindQuerySpeedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuerySpeedExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCICUCSpeedUnit).SpeedAdd("1^2^3^4^5^6^ug/hour^8")
ClassMethod SpeedAdd(typeStr As %String)
{
	
	s rowid=""
	s num=0
	s ret=0
	s tmp=$p(typeStr,"^",7)
	s newcode=$p(typeStr,"^",1)
	s newdesc=$p(typeStr,"^",2)
	f  s rowid=$O(^DHCICUC("SUnit",rowid)) q:rowid=""  d
		.s ANCSUCode=$p(^DHCICUC("SUnit",rowid),"^",1)
		.i ANCSUCode=newcode s ret=1
		.s ANCSUDesc=$p(^DHCICUC("SUnit",rowid),"^",2)
		.i ANCSUDesc=newdesc s ret=1
		.i (tmp=ANCSUCode) d
			..s tmp=rowid
		.s num=num+1
		.s ten=rowid+1
	q:ret=1 "代码重复Or描述重复"_"^"_ret
	s $p(typeStr,"^",7)=tmp
	s ^DHCICUC("SUnit",ten)=typeStr
	q 0
}

/// d ##class(web.DHCANOPReport).SpeedUpdate(14,"33^22^11^4^55^66^ug/hour^88")
ClassMethod SpeedUpdate(Rowid, typeStr As %String) As %String
{
	q:Rowid="" "select one record"
	s rowid="",ret=0
	s tmp=$p(typeStr,"^",7)
	s newcode=$p(typeStr,"^",1)
	s newdesc=$p(typeStr,"^",2)
	f  s rowid=$O(^DHCICUC("SUnit",rowid)) q:rowid=""  d
		.s ANCSUCode=$p(^DHCICUC("SUnit",rowid),"^",1)
		.i (ANCSUCode=newcode)&(Rowid'=rowid) s ret=1
		.s ANCSUDesc=$p(^DHCICUC("SUnit",rowid),"^",2)
		.i (ANCSUDesc=newdesc)&(Rowid'=rowid) s ret=1
		.i (tmp=ANCSUCode) d
			..s tmp=rowid
	q:ret=1 "代码或描述重复"_"^"_ret
	i ret=0 d
		.k ^DHCICUC("SUnit",Rowid)
		.s $p(typeStr,"^",7)=tmp
		.s ^DHCICUC("SUnit",Rowid)=typeStr
	q ret
}

ClassMethod SpeedDel(Rowid As %String) As %String
{
	q:(Rowid="") -2
	k ^DHCICUC("SUnit",Rowid)
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPReport","LookUpSpeed")
Query LookUpSpeed() As %Query(ROWSPEC = "tCode:%String,tDesc:%String,Id:%String")
{
}

ClassMethod LookUpSpeedExecute(ByRef qHandle As %Binary, type) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	
	s StatType=""
	f  s StatType=$o(^DHCANC("Speed",StatType)) q:StatType=""  d
		.s tCode=$p(^DHCANC("Speed",StatType),"^",1)
		.s tDesc=$p(^DHCANC("Speed",StatType),"^",2)
		.d OutputRow33
 	
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow33
	s Data=$lb(tCode,tDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpSpeedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpSpeedExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpSpeedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpSpeedExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="DHCICUCSpeedUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCICUCSpeedUnitD</DataLocation>
<DefaultData>DHCICUCSpeedUnitDefaultData</DefaultData>
<IdLocation>^web.DHCICUCSpeedUnitD</IdLocation>
<IndexLocation>^web.DHCICUCSpeedUnitI</IndexLocation>
<StreamLocation>^web.DHCICUCSpeedUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
