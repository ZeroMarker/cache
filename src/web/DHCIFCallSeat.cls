Class web.DHCIFCallSeat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveSeatNo(SeatNo As %String, State As %String) As %String
{
	q:SeatNo="" "-1"
	s parr="^"_SeatNo_"^"_""_"^"_""_State
	s ret=##class(User.DHCIFCallSeat).Save(parr)
	q ret
}

Query GetSeatNo() As %Query(ROWSPEC = "SeatNo:%String,Name:%String,CallDateTime:%String")
{
}

ClassMethod GetSeatNoExecute(ByRef qHandle As %Binary, CTLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if CTLocID="" Quit $$$OK
 	s rw="" f  s rw=$O(^User.DHCIFCallSeatD(rw)) q:rw=""  d
 	.s CallSeatNo=$list(^User.DHCIFCallSeatD(rw),3)
 	.s CallDate=$list(^User.DHCIFCallSeatD(rw),2)
 	.s CallTime=$list(^User.DHCIFCallSeatD(rw),5)
 	.s CallDateTime=$ZD(CallDate,3)_" "_$ZT(CallTime)
 	.s SeatID="" f  s SeatID=$O(^User.DHCNurSySeatI("loc"," "_CTLocID,SeatID)) q:SeatID=""  d
 	..s a=^User.DHCNurSySeatD(SeatID)
 	..s flag=$listget(a,7)
 	..q:flag="N"
 	..s SeatCode=$list(a,3)
 	..q:CallSeatNo'=SeatCode
 	..s Name=""
 	..s id="" f  s id=$O(^User.DHCNurSyPatRecI("seat"," "_CTLocID," "_SeatID," Y",id)) q:id=""  d
 	...s a=^User.DHCNurSyPatRecD(id)
 	...s EpisodeID=$listget(a,3)
 	...s RegNo=$list(a,4)
 	...s Papmidr=$P($g(^PAADM(EpisodeID)),"^",1)
 	...s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
    ..d Out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
Out
	set Data=$lb(CallSeatNo,Name,CallDateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSeatNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSeatNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSeatNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSeatNoExecute ]
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

ClassMethod DelSeatNo(SeatNo As %String) As %String
{
	q:SeatNo="" "-1"
	s rw="" f  s rw=$O(^User.DHCIFCallSeatD(rw)) q:rw=""  d
	.s CallSeatNo=$list(^User.DHCIFCallSeatD(rw),3)
	.q:CallSeatNo'=SeatNo
	.d ##class(User.DHCIFCallSeat).%DeleteId(rw)
	q 0
}

}
