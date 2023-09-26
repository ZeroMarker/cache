Import SQLUser

Class web.DHCRisBookQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCRisBookQuery","QueryBooked","^^633^^","62488","62494")	
Query QueryBooked(Info As %String, StdDate As %String, endDate As %String) As %Query(ROWSPEC = "OeordItemID:%String,Paadmdr:%String,RecLoc:%String,AppLoc:%String,Name:%String,Sex:%String,Age:%String,PatType:%String,RegNo:%String,IPNo:%String,OrdName:%String,Date:%String,Time:%String,Status:%String,AppointDate:%String,AppointstTime:%String,BookedEQ:%String")
{
}

ClassMethod QueryBookedExecute(ByRef qHandle As %Binary, Info As %String, StdDate As %String, endDate As %String) As %Status
{
 
 s ind=1
 Set repid=$I(^CacheTemp)
 
 s ^t=Info_"&"_StdDate_"&"_endDate
 
 s InHospital=$p($g(Info),"^",1)
 s InRecLocDR=$p($g(Info),"^",2)
 s InAppLocDR=$p($g(Info),"^",3)
 s InRegNo=$p($g(Info),"^",4)
 s InIPNo=$p($g(Info),"^",5)
 
 f date=StdDate:1:endDate d
 .s OrderRowid=0 f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:OrderRowid=""  d
 ..s itemsub=0 f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:itemsub=""  d
 ...s oeorditemdr=OrderRowid_"||"_itemsub 
 ...s (Date,Time,OrdName,ResultFlag,AppointDate,AppointstTime,BookedEQ,approwid,recdepdr,AppLocdr)=""
 ...s (arcimid,ServerMaterial,RERowid,Status)=""
 ...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 ...s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
 ...q:(ServerMaterial'="S")
 ...s OrdName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
 ...s ResultFlag=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",5)
 ...i ResultFlag'="" s RERowid=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(ResultFlag),""))
 ...i RERowid'="" s Status=$p($g(^OEC("RESST",RERowid)),"^",2) 
 ...s approwid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
 ...q:((approwid'="")!(approwid'=$c(0)))&(ResultFlag'="CA")
 ...i (approwid'="") d
 ....s (ResSchduleID,EqId,CareProvId,ResouceId)=""
 ....s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",approwid)),"^",2)
 ....i ResSchduleID'=""  d
 .....s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
 .....i ResouceId'="" d
 ......q:ResouceId="3270"
 ......s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
 ......s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
 ......i EqId'="" s BookedEQ=$p(^RBC("EQ",EqId),"^",2)
 ......i CareProvId'="" s BookedEQ=$p(^CTPCP(CareProvId,1),"^",2)
 ......q:(BookedEQ="")
 .....s AppointDate=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
 .....s AppointstTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5)
 .....i AppointDate'="" s AppointDate=$zd(AppointDate,3)
 .....i AppointstTime'="" s AppointstTime=$zt(AppointstTime,1)
 ...e  d
 ....s AppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
 ....q:((AppointDate'="")!(AppointDate'=$c(0)))&(ResultFlag'="CA")
 ....s AppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3) 
 ...s Date=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",7)  ;OEORI_Date oe_orditem
 ...s Date=$zd(Date,3)
 ...s Time=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",17)  ;OEORI_TimeOrd oe_orditem
 ...s Time=$zt(Time,3) 
 ...s paadmdr=$p(^OEORD(OrderRowid),"^",1)
 ...s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
 ...s RegNo=$p(PatInfo,"^",1)
 ...q:(InRegNo'="")&(InRegNo'=RegNo)
 ...s Name=$p(PatInfo,"^",2)
 ...s Age=$p(PatInfo,"^",4)
 ...s Sex=$p(PatInfo,"^",5)
 ...s PatType=$p(PatInfo,"^",7)
 ...s IPNo=$p(PatInfo,"^",9)
 ...q:(InIPNo'="")&(InIPNo'=IPNo) 
 ...s recdepdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)    ; OEORI_RecDep_DR oe_orditem
 ...s AppLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,7)),"^",2)
 ...;w !,AppLocdr
 ...i AppLocdr'="" s HospitalDR=$p($g(^CTLOC(AppLocdr)),"^",22) 
 ...q:(InHospital'="")&(InHospital'=HospitalDR)
 ...q:(InAppLocDR'="")&(InAppLocDR'=AppLocdr)
 ...q:(InRecLocDR'="")&(InRecLocDR'=recdepdr)
 ...s RecLoc=$p(^CTLOC(recdepdr),"^",2)
 ...i $f(RecLoc,"-")>0 s RecLoc=$p(RecLoc,"-",2)
 ...s AppLoc=$p(^CTLOC(recdepdr),"^",2)
 ...i $f(AppLoc,"-")>0 s AppLoc=$p(AppLoc,"-",2)
 ...Do QueryBooked
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryBooked
 set Data=$lb(oeorditemdr,paadmdr,RecLoc,AppLoc,Name,Sex,Age,PatType,RegNo,IPNo,OrdName,Date,Time,Status,AppointDate,AppointstTime,BookedEQ)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryBookedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookedExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryBookedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookedExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询医院
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookQuery","QueryHospital")
Query QueryHospital() As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QueryHospitalExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

   
    s rowid=0	f  s rowid=$o(^CT("HOSP",rowid)) q:rowid=""  d
    .s Code=$p($g(^CT("HOSP",rowid)),"^",1)
    .s Desc=$p($g(^CT("HOSP",rowid)),"^",2)
	.Do OutRow86
	 
	 Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRow86
	set Data=$lb(rowid,Desc,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHospitalExecute ]
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

ClassMethod QueryHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryAppLoc(HospDR As %String, Desc As %String) As %Query(ROWSPEC = "TRowid:%String,Desc:%String")
{
}

ClassMethod QueryAppLocExecute(ByRef qHandle As %Binary, HospDR As %String, Desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
    s hospital="(西院)"
    s Stop="(停用)"
    s LocType="E"
  
    
    s Desc=$ZCONVERT(Desc,"U")
    Set rowid=0	f  s rowid=$o(^CTLOC(0,"LocType",LocType,rowid)) q:rowid=""  d
	.s GetDesc=$p($g(^CTLOC(rowid)),"^",2) 
	.s HospitalDR=$p($g(^CTLOC(rowid)),"^",22)
	
	.i (HospDR'="")&(HospitalDR=HospDR)&(GetDesc'[Stop)&(GetDesc[Desc) d
	..Do OutRow8
	.i (HospDR="")&(GetDesc'[Stop)&(GetDesc[Desc) d
	..Do OutRow8
	
	 Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRow8
	set Data=$lb(rowid,GetDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAppLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppLocExecute ]
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

ClassMethod QueryAppLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询医嘱的接收科室
/// do ##class(%ResultSet).RunQuery("web.DHCRisBookQuery","QueryRecLoc","","")
Query QueryRecLoc(HospDR As %String, Desc As %String) As %Query(ROWSPEC = "TRowid:%String,Desc:%String")
{
}

ClassMethod QueryRecLocExecute(ByRef qHandle As %Binary, HospDR As %String, Desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
    s hospital="(西院)"
    s Stop="(停用)"
    s LocType="E"
    
    
    s Desc=$ZCONVERT(Desc,"U")
    Set rowid=0	f  s rowid=$o(^CTLOC(0,"LocType",LocType,rowid)) q:rowid=""  d
	.s GetDesc=$p($g(^CTLOC(rowid)),"^",2) 
	.s HospitalDR=$p($g(^CTLOC(rowid)),"^",22)
	.i (HospDR'="")&(HospitalDR=HospDR)&(GetDesc'[Stop)&(GetDesc[Desc) d
	..Do OutRowRecLoc
	.i (HospDR="")&(GetDesc'[Stop)&(GetDesc[Desc) d
	..Do OutRowRecLoc
	 
	 Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowRecLoc
	set Data=$lb(rowid,GetDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRecLocExecute ]
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

ClassMethod QueryRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
