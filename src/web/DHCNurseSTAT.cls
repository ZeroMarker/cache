Class web.DHCNurseSTAT Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Query GetNurseNum(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "NurseName,nursesum,NurseID,DHCQueryDesc")
{
}

ClassMethod GetNurseNumExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{

	Set repid=$I(^CacheTemp)
 	s ind=1
 	i StartDate="" s qHandle=$lb(0,repid,0) q $$$OK
 	i EndDate="" s qHandle=$lb(0,repid,0) q $$$OK
    f curDateval=StartDate:1:EndDate d 
    .s DHCORERowId=0 f  s DHCORERowId=$o(^DHCOrdExec(0,"Date",curDateval,DHCORERowId)) q:DHCORERowId=""  d
    ..s DHCORERowId=$p(DHCORERowId,$c(1))
    ..s curallitem=$g(^DHCOrdExec(DHCORERowId))
    ..s DHCQueryCode=$p(curallitem,"^",6)
    ..q:DHCQueryCode=""
    ..;q:(argquerycode'="")&(argquerycode'=DHCQueryCode) 
    ..s DHCOREnurseid=$p(curallitem,"^",10)
    ..;q:(argnurseid'="")&(argnurseid'=DHCOREnurseid) 
    ..q:DHCOREnurseid=""
    ..s OEOReID=$p(curallitem,"^",1)
    ..s OEOReID=$p(OEOReID,$c(1))
    ..s oeordid=$p(OEOReID,"||",1)
    ..q:oeordid=""
    ..s oeorichildsub=$p(OEOReID,"||",2)
    ..q:oeorichildsub=""
    ..q:$d(^OEORD(oeordid,"I",oeorichildsub,3))=0
    ..s oeoriSeqno=$p($g(^OEORD(oeordid,"I",oeorichildsub,3)),"^",4)
    ..q:$g(oeoriSeqno)["."
    ..s curDHCOREOEOREDR=$p(curallitem,"^",9)
    ..i $d(^temcurnurseinfo($j,DHCOREnurseid,DHCQueryCode))=0 d
    ...s ^temcurnurseinfo($j,DHCOREnurseid,DHCQueryCode)=1
    ..e  d
    ...s ^temcurnurseinfo($j,DHCOREnurseid,DHCQueryCode)=$g(^temcurnurseinfo($j,DHCOREnurseid,DHCQueryCode))+1
    s reportTP=0
    i $d(^temcurnurseinfo($j))'=0 d
    .s DHCOREnurseidTP=0 f  s DHCOREnurseidTP=$o(^temcurnurseinfo($j,DHCOREnurseidTP)) q:DHCOREnurseidTP=""  d
    ..q:DHCOREnurseidTP=""
    ..s DHCQueryDesc=0  f  s DHCQueryDesc=$o(^temcurnurseinfo($j,DHCOREnurseidTP,DHCQueryDesc)) q:DHCQueryDesc=""  d
    ...q:DHCQueryDesc=""
    ...s ssname4=$p(^SSU("SSUSR",DHCOREnurseidTP),"^",2)
    ...s nursesum=$g(^temcurnurseinfo($j,DHCOREnurseidTP,DHCQueryDesc))
    ...s reportTP=reportTP+nursesum
    ...s NurseName=ssname4
    ...s NurseID=DHCOREnurseidTP
    ...d OutPutWard
     i $d(^temcurnurseinfo($j))'=0 k ^temcurnurseinfo($j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutWard
	set Data=$lb(NurseName,nursesum,NurseID,DHCQueryDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1

	quit
}

ClassMethod GetNurseNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurseNumExecute ]
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

ClassMethod GetNurseNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurseNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Storage Default
{
<Data name="DHCNurseSTATDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNurseSTATD</DataLocation>
<DefaultData>DHCNurseSTATDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNurseSTATD</IdLocation>
<IndexLocation>^web.DHCNurseSTATI</IndexLocation>
<StreamLocation>^web.DHCNurseSTATS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
