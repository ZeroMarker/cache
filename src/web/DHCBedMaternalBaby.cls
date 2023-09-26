Import SQLUSER

Class web.DHCBedMaternalBaby Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod AddMaternalBaby(WardID As %String, BedTypeID As %String, LeftOffset As %String, TopOffset As %String, IntervalX As %String, IntervalY As %String, Width As %String, Height As %String, BabyIntervalY As %String, MaxAttachBabies As %String)
{
	s ^tempsc("AddMaternalBaby")=$lb(WardID , BedTypeID , LeftOffset , TopOffset , IntervalX , IntervalY , Width , Height , BabyIntervalY , MaxAttachBabies )
	s BMBRowId=$o(^DHCBed("MaternalBaby",0,"Ward",WardID,""))
	q:BMBRowId'="" "该病区已维护!"
	s:IntervalX="undefined" IntervalX=""
	s:IntervalY="undefined" IntervalY=""
	s:BabyIntervalY="undefined" BabyIntervalY=""
 	k PList
	TSTART
	s PList(2)=WardID
	s PList(3)=BedTypeID
	s PList(4)=LeftOffset
	s PList(5)=TopOffset
	s PList(6)=IntervalX
	s PList(7)=IntervalY
	s PList(8)=Width
	s PList(9)=Height
	s PList(10)=BabyIntervalY
	s PList(11)=MaxAttachBabies
	&SQL(insert into DHC_Bed_MaternalBaby Values :PList())
	i SQLCODE
	{
	    TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod DeleteMaternalBaby(BMBID As %String)
{
	i BMBID'="" d
	.&SQL(delete from DHC_Bed_MaternalBaby where BMB_RowId=:BMBID)
	q SQLCODE
}

/// ##class(%ResultSet).RunQuery("web.DHCBedMaternalBaby","FindBedMaternalBaby")
ClassMethod FindBedMaternalBabyClose(ByRef qHandle As %Binary, HospitalRowId) As %Status [ PlaceAfter = FindBedMaternalBabyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBedMaternalBabyExecute(ByRef qHandle As %Binary, HospitalRowId) As %Status
{
    s ^tempsc("FindBedMaternalBaby")=HospitalRowId
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tBMBID=0
	f  s tBMBID=$o(^DHCBed("MaternalBaby",tBMBID)) q:tBMBID=""  d
	   .s tWardID=$p(^DHCBed("MaternalBaby",tBMBID),"^",1)
	   .s tWardID=$replace(tWardID," ","")
	   .s locId=$p(^PAWARD(tWardID),"^",5)
	   .s locHospID=$p(^CTLOC(locId),"^",22)
	   .q:HospitalRowId'=locHospID
	   .s tPacWard=""
	   .i tWardID'="" d
	   ..;s tWardID=$o(^PAWARD(0,"WARD_Code",tWardID,0))
	   ..s tPacWard=$p(^PAWARD(tWardID),"^",2)
	   .s tBedTypeID=$p(^DHCBed("MaternalBaby",tBMBID),"^",2)
	   .s tBedType=""
	   .i tBedTypeID'="" s tBedType=$p($g(^PAC("BEDTP",tBedTypeID)),"^",2)
	   .s tLeftOffset=$p(^DHCBed("MaternalBaby",tBMBID),"^",3)
	   .s tTopOffset=$p(^DHCBed("MaternalBaby",tBMBID),"^",4)
	   .s tIntervalX=$p(^DHCBed("MaternalBaby",tBMBID),"^",5)
	   .s tIntervalY=$p(^DHCBed("MaternalBaby",tBMBID),"^",6)
	   .s tWidth=$p(^DHCBed("MaternalBaby",tBMBID),"^",7)
	   .s tHeight=$p(^DHCBed("MaternalBaby",tBMBID),"^",8)
	   .s tBabyIntervalY=$p(^DHCBed("MaternalBaby",tBMBID),"^",9)
	   .s tMaxAttachBabies=$p(^DHCBed("MaternalBaby",tBMBID),"^",10)
	   .d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tPacWard,tBedType,tLeftOffset,tIntervalX,tTopOffset,tIntervalY,tWidth,tHeight,tBabyIntervalY,tMaxAttachBabies,tBMBID,tWardID,tBedTypeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBedMaternalBabyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedMaternalBabyExecute ]
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

ClassMethod UpdateMaternalBaby(BMBID As %String, WardID As %String, BedTypeID As %String, LeftOffset As %String, TopOffset As %String, IntervalX As %String, IntervalY As %String, Width As %String, Height As %String, BabyIntervalY As %String, MaxAttachBabies As %String)
{
	s:IntervalX="undefined" IntervalX=""
	s:IntervalY="undefined" IntervalY=""
	s:BabyIntervalY="undefined" BabyIntervalY=""
	;s ifHasWard=$O(^DHCBed("MaternalBaby",0,"Ward",WardID,""))
	;q:ifHasWard'="" "该病区已存在，请核实"
	k PList 
	s PList(1)=BMBID
	s PList(2)=WardID
	s PList(3)=BedTypeID
	s PList(4)=LeftOffset
	s PList(5)=TopOffset
	s PList(6)=IntervalX
	s PList(7)=IntervalY
	s PList(8)=Width
	s PList(9)=Height
	s PList(10)=BabyIntervalY
	s PList(11)=MaxAttachBabies
	&sql(update DHC_Bed_MaternalBaby  Values PList() where BMB_RowId=:BMBID)
 	q SQLCODE
}

Query FindBedMaternalBaby(HospitalRowId) As %Query(ROWSPEC = "tPacWard:%String,tBedType:%String,tLeftOffset:%String,tIntervalX:%String,tTopOffset:%String,tIntervalY:%String,tWidth:%String,tHeight:%String,tBabyIntervalY:%String,tMaxAttachBabies:%String,tBMBID:%String,tWardID:%String,tBedTypeID:%String")
{
}

Query GetBedType() As %Query(ROWSPEC = "BEDTP_Desc:%String,BEDTP_RowId:%Integer")
{
}

ClassMethod GetBedTypeExecute(ByRef qHandle As %Binary) As %Status
{
	
	s repid=$i(^CacheTemp)
	s ind=1
	s id=0
	f  s id=$o(^PAC("BEDTP",id)) q:id=""  d
	.s desc=$p(^PAC("BEDTP",id),"^",2)
	.s dateFrom=$P(^PAC("BEDTP",id),"^",8)
 	.s dateTo=$P(^PAC("BEDTP",id),"^",9)
 	.s h=+$h
 	.q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	.d OutRowGetBedType
    s qHandle=$lb(0,repid,0)  
    q $$$OK

OutRowGetBedType
	s Data=$lb(desc,id)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe,prechkdays
}

ClassMethod GetBedTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBedTypeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetBedTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBedTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query GetWard() As %Query(ROWSPEC = "WARD_Desc:%String,WARD_RowId:%Integer")
{
}

ClassMethod GetWardExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s sub=0 f  s sub=$o(^PAWARD(sub)) q:(+sub=0)  d
    	.q:$p(^PAWARD(sub),"^",6)'="Y"
    	.s desc=$p($g(^PAWARD(sub)),"^",2)
    	.s locId=$p(^PAWARD(sub),"^",5)
    	.q:locId=""
    	.s dateFrom=$P(^PAWARD(sub),"^",7)
 		.s dateTo=$P(^PAWARD(sub),"^",9)
 		.s h=+$h
 		.q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
   		.d OutwardRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutwardRow
	s Data=$lb(desc,sub)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

}
