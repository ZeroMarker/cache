Import SQLUser

Class web.DHCPAPregDelPlacenta Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//胎膜情况

Query MembranceMode() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod MembranceModeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s plconRowID=0                      ; "PLCON"                     
    f  s plconRowID=$o(^PAC("MEMBCOND",plconRowID)) q:plconRowID=""  d
    .s desc=$p($g(^PAC("MEMBCOND",plconRowID)),"^",2)
    .s rw=plconRowID
    .d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
    set Data=$lb(rw,desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod MembranceModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MembranceModeExecute ]
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

ClassMethod MembranceModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MembranceModeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

//w ##class(web.DHCPAPregDelPlacenta).getPlacdata("414||3||12")

ClassMethod getPlacdata(PLACID) As %String
{
    q:(PLACID="")||(+PLACID=0) ""
    s pregDr=$p(PLACID,"||",1)
    s delSub=$p(PLACID,"||",2)
    s PlacSub=$p(PLACID,"||",3)
    s ^TEMP("yl","DHCPAPregDelPlacenta","getPlacdata")=$g(PLACID)
    s MembranceID=$p($g(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub)),"^",10)
    s rtl=$g(MembranceID)
    s CordLength=$p($g(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub)),"^",6)
    //脐附着
    s CordInsertionID=$p($g(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub)),"^",5)
    //PlacInfo 扩展节点？
    s PlacInfo=$g(^PAPRG(pregDr,"DEL",delSub,"PLAC",PlacSub,"DHC"))
    b
    s MembRuptureCode=$p(PlacInfo,"^",1)
    s MachineTurn=$p(PlacInfo,"^",2)
    s PLACSize=$p(PlacInfo,"^",3)
    s LiquorAmoutID=$p(PlacInfo,"^",4)
    s LiquorAmout=""
    i LiquorAmoutID="L" s LiquorAmout="少"
    i LiquorAmoutID="N" s LiquorAmout="正常"
    i LiquorAmoutID="M" s LiquorAmout="多"
	s LiquorAbnormalID=$p(PlacInfo,"^",5)
	s LiquorAbnormal=""
	i LiquorAbnormalID="Y" s LiquorAbnormal="有"
	i LiquorAbnormalID="N" s LiquorAbnormal="无"
	s LiquorStatus=""
	s LiquorStatusID=$p(PlacInfo,"^",6)
	i LiquorStatusID'="" s LiquorStatus=$p(^DHCProcC("LiquorStatus",LiquorStatusID),"^",2)
    s rtl=rtl_"^"_$g(MembRuptureCode)_"^"_$g(MachineTurn)_"^"_$g(PLACSize)_"^"_$g(CordLength)_"^"_$g(CordInsertionID)_"^"_LiquorAmout_" "_LiquorAmoutID_"^"_LiquorAbnormal_" "_LiquorAbnormalID_"^"_LiquorStatus_" "_LiquorStatusID
    q rtl
}

Query MembRuptureSite() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod MembRuptureSiteExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s desc="不清",rw="D"
    d output
    s desc="胎盘",rw="P"
    d output
    s desc="脐血管",rw="C"
    d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
    set Data=$lb(rw,desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod MembRuptureSiteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MembRuptureSiteExecute ]
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

ClassMethod MembRuptureSiteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MembranceModeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query Machine() As %Query(ROWSPEC = "ord,typ")
{
}

ClassMethod MachineExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s typ="母面",ord="Y"
    d output
    s typ="子面",ord="N"
    d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
output
    set Data=$lb(ord,typ)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod MachineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MachineExecute ]
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

ClassMethod MachineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MachineExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

//CordInsertion

Query CordInsertion() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod CordInsertionExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s plconRowID=0
    f  s plconRowID=$o(^PAC("PLCINSRT",plconRowID)) q:plconRowID=""  d
    .s desc=$p($g(^PAC("PLCINSRT",plconRowID)),"^",2)
    .s rw=plconRowID
    .d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
    set Data=$lb(desc,rw)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod CordInsertionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CordInsertionExecute ]
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

ClassMethod CordInsertionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CordInsertionExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetLiquorStat(type As %String = "") As %Query(ROWSPEC = "LiquorStatDes:%String,rowid:%String")
{
}

ClassMethod GetLiquorStatExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0,i=0 //ypz 060811
	f  s rowid=$o(^DHCProcC("LiquorStatus",rowid)) q:rowid=""  d
	.s LiquorStatDes=$p(^DHCProcC("LiquorStatus",rowid),"^",2)
	.;s IndictCode=$p(^DHCProcC("Indicator",rowid),"^",1)
	.;q:(OPTypeDes'[type)
 	.Do OutputRow55	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow55
	set Data=$lb(LiquorStatDes,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLiquorStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLiquorStatExecute ]
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

ClassMethod GetLiquorStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLiquorStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LiquorAbnm() As %Query(ROWSPEC = "desc,rw")
{
}

ClassMethod LiquorAbnmExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s desc="有",rw="Y"
    d output
    s desc="无",rw="N"
    d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
    set Data=$lb(desc,rw)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod LiquorAbnmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LiquorAbnmExecute ]
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

ClassMethod LiquorAbnmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LiquorAbnmExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query LiquorAmt() As %Query(ROWSPEC = "desc,rw")
{
}

ClassMethod LiquorAmtExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s desc="少",rw="L"
    d output
    s desc="正常",rw="N"
    d output
    s desc="多",rw="M"
    d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
    set Data=$lb(desc,rw)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod LiquorAmtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LiquorAmtExecute ]
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

ClassMethod LiquorAmtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LiquorAmtExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPlacBabyList(PLACID As %String)
{
 q:PLACID="" ""
 s rtl=""
 s pregDr=$p(PLACID,"||",1)
 s delSub=$p(PLACID,"||",2)
 s PlacSub=$p(PLACID,"||",3)
 s babychildsub=0
 f  s babychildsub=$o(^PAPRGi("BABY_Placenta_dr",PLACID,pregDr, "DEL",delSub,"BABY",babychildsub)) q:babychildsub=""  d
 .s babyrowid=pregDr_"||"_delSub_"||"_babychildsub
 .s tmpbabychildsub=+babychildsub
 .i tmpbabychildsub'=0 d
 ..s PlcDes=$p($g(^PAPRG(pregDr,"DEL",delSub,"BABY",babychildsub)),"^",49)
 ..i PlcDes'="" s PlcDes=$zt(PlcDes,2)
 ..s PatientID=$p($g(^PAPRG(pregDr,"DEL",delSub,"BABY",babychildsub)),"^",73)
 ..s PatientID=+PatientID
 ..s BABYName=""
 ..i PatientID'=0 d
 ...s BABYName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
 ..s PlcDes=PlcDes_" "_BABYName
 ..s rtl=rtl_"^"_$g(babyrowid)_"$"_$g(PlcDes)
 q rtl
}

Query GetBabyID(type As %String = "") As %Query(ROWSPEC = "PlcDes:%String,rowid:%String")
{
}

ClassMethod GetBabyIDExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^tmpw(3)=$g(type)
	s rowid=0,i=0 //ypz 060811
	i type="" s type=%request.Get("PARREF")
	s ^tmpw(1)=%request.Get("PARREF")
	q:type="" ""
	s pregDr=$p(type,"||",1)
    s delSub=$p(type,"||",2)
    s babySub=0
	f  s babySub=$o(^PAPRG(pregDr,"DEL",delSub,"BABY",babySub)) q:babySub=""  d
    .s rowid=pregDr_"||"_delSub_"||"_babySub
    .s PlcDes=$p($g(^PAPRG(pregDr,"DEL",delSub,"BABY",babySub)),"^",49)
 	.i PlcDes'="" s PlcDes=$zt(PlcDes,2)
 	.s PatientID=$p($g(^PAPRG(pregDr,"DEL",delSub,"BABY",babySub)),"^",73)
    .s PatientID=+PatientID
    .s BABYName=""
    .i PatientID'=0 d
    ..s BABYName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
    .s PlcDes=PlcDes_" "_BABYName
 	.Do OutputRow45 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow45
	set Data=$lb(PlcDes,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBabyIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBabyIDExecute ]
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

ClassMethod GetBabyIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBabyIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
