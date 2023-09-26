Class web.DHCANOPRoomStatus Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindexeLoc(OPRCTLocId As %String = "", BedTypeCode As %String = "", IfAvailable As %String = "") As %Query(ROWSPEC = "TOPRRowid:%String,TOPRCTLoc:%String,TOPRDesc:%String,TOPRStatDesc:%String,TopordnoOld:%String,TAvailable:%String")
{
}

ClassMethod FindexeLocExecute(ByRef qHandle As %Binary, OPRCTLocId As %String, BedTypeCode As %String, IfAvailable As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i BedTypeCode="" s BedTypeCode="T"				//默认查询手术床
	s TOPRRowid=0
	f  s TOPRRowid=$o(^DHCANC("OPRoom",TOPRRowid))  q:TOPRRowid=""  d
	.s TOPRDesc=$p(^DHCANC("OPRoom",TOPRRowid),"^",2)
	.s TOPRCTLoc=""
	.s TOPRStatDesc="可用"
	.s Topordno=0
	.s TopordnoOld=0
	.s TopordnoOldDe="共0已完成0台"
	.s ctlocId=$p(^DHCANC("OPRoom",TOPRRowid),"^",3)
	.q:(OPRCTLocId'="")&(OPRCTLocId'=ctlocId)
	.s TOPRCTLoc=$p($g(^CTLOC(+ctlocId)),"^",2)
	.s Available=$p(^DHCANC("OPRoom",TOPRRowid),"^",7)
	.q:(IfAvailable="Y")&(Available="N")
	.i Available'="N" s TAvailable="正常"
	.e  s TAvailable="停用"
	.s TBedType=$p(^DHCANC("OPRoom",TOPRRowid),"^",9)
	.q:(BedTypeCode'="")&(BedTypeCode'=TBedType)
	.s opaId=0
	.f  s opaId=$o(^DHCANOPArrange(0,"RoomStatus",TOPRRowid,"I",opaId))  q:opaId=""  d
	..s StDate=$P(^DHCANOPArrange(opaId),"^",14) 	//OPA_StartDate 开始日期
	..q:StDate'=+$h									//查询当天有无入室手术
	..s TOPRStat=$P(^DHCANOPArrange(opaId),"^",27)
	..i TOPRStat="I" s TOPRStatDesc="占用"
	.s Num=0
	.s opaId=0
	.f  s opaId=$o(^DHCANOPArrange(0,"SDate",+$h,opaId))  q:opaId=""  d
	..s OPRRowid=$P(^DHCANOPArrange(opaId),"^",20)
	..q:OPRRowid'=TOPRRowid
	..s NOPRStat=$P(^DHCANOPArrange(opaId),"^",27)
	..i (NOPRStat="L")!(NOPRStat="F")!(NOPRStat="I") s Num=Num+1
	..s Topordno=$P(^DHCANOPArrange(opaId),"^",26)
	..i +Topordno>TopordnoOld s TopordnoOld=+Topordno
	..s TopordnoOldDe="共"_TopordnoOld_"已完成"_Num_"台"
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TOPRRowid,TOPRCTLoc,TOPRDesc,TOPRStatDesc,TopordnoOldDe,TAvailable)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeLocExecute ]
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

ClassMethod FindexeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetANOPStat(OPRCTLocId As %String, BedTypeCode As %String, IfAvailable As %String)
{
	i $g(BedTypeCode)="" s BedTypeCode="T"
	s pre=0
	s num=0
	s num1=0
	s TOPRRowid=0
	f  s TOPRRowid=$o(^DHCANC("OPRoom",TOPRRowid))  q:TOPRRowid=""  d
	.s ctlocId=$p(^DHCANC("OPRoom",TOPRRowid),"^",3)
	.q:(OPRCTLocId'="")&(OPRCTLocId'=ctlocId)
	.s BedType=$p(^DHCANC("OPRoom",TOPRRowid),"^",9)
	.q:(BedTypeCode'="")&(BedTypeCode'=BedType)
	.s Available=$p(^DHCANC("OPRoom",TOPRRowid),"^",7)
	.q:(IfAvailable="Y")&(Available="N")
	.s num=num+1
	.s opaId=0
	.s TOPRStatDesc=""
	.f  s opaId=$o(^DHCANOPArrange(0,"RoomStatus",TOPRRowid,"I",opaId))  q:opaId=""  d
	..s StDate=$P(^DHCANOPArrange(opaId),"^",14) 	//OPA_StartDate 开始日期
	..q:StDate'=+$h									//查询当天有无入室手术
	..s TOPRStat=$P(^DHCANOPArrange(opaId),"^",27)
	..i TOPRStat="I" s TOPRStatDesc="OK"
	.i $g(TOPRStatDesc)="OK" s num1=num1+1
	i num'=0 s pre=$j(num1/num,1,3)
	s pre=pre*100
	q pre_"%"
}

Query GetAnOpList(OPRRowid As %String) As %Query(ROWSPEC = "Topordno:%String,TopApptime:%String,Topdes:%String,IfFinish:%String")
{
}

ClassMethod GetAnOpListExecute(ByRef qHandle As %Binary, OPRRowid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s opaId=0
	f  s opaId=$o(^DHCANOPArrange(0,"SDate",+$h,opaId))  q:opaId=""  d
	   .s TOPRRowid=$P(^DHCANOPArrange(opaId),"^",20)
	   .q:TOPRRowid'=OPRRowid
	   .s Topordno=$P(^DHCANOPArrange(opaId),"^",26)
	   .s TopApptime=$P(^DHCANOPArrange(opaId),"^",15)		//OPA_StartTime 开始时间
	   .if TopApptime'=""  s TopApptime=$ZT(TopApptime,2)
	   .s NOPRStat=$P(^DHCANOPArrange(opaId),"^",27)
	   .i (NOPRStat="L")!(NOPRStat="F")!(NOPRStat="I") s IfFinish="Y"
	   .e  s IfFinish="N"
	   .s adm=$P(^DHCANOPArrange(opaId),"^",1)
	   .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	   .s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:subchl=""  d
	   ..s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)
	   ..q:opdr=""
	   ..if $D(^ORC("OPER",opdr)) s Topdes=$P(^ORC("OPER",opdr),"^",2)
	   .d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Topordno,TopApptime,Topdes,IfFinish)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetANOPRoom(OPRRowid As %String)
{
	q:OPRRowid="" ""
	s OPRDesc=""
	s OPRDesc=$p(^DHCANC("OPRoom",OPRRowid),"^",2)
	q OPRDesc
}

Query FindStatus() As %Query(ROWSPEC = "StatusDesc:%String,StatusCode:%String")
{
}

ClassMethod FindStatusExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s StatusDesc="手术床",StatusCode="T"
	d OutputRow22
	s StatusDesc="术后恢复床",StatusCode="P"
	d OutputRow22
	s StatusDesc="预麻床",StatusCode="I"
	d OutputRow22
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow22
	set Data=$lb(StatusDesc,StatusCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStatusExecute ]
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

ClassMethod FindStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
