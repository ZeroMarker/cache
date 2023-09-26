Include Nur.DateFormat

Class web.DHCPACVisitStatus Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码或描术是否重复	
ClassMethod IfExist(parr) As %String
{
	s code=$P(parr,"^",1)
	s desc=$P(parr,"^",2)
	s ret=""
	s rw="" f  s rw=$O(^DHCPACVisitStatus(rw)) q:(rw="")!(ret'="")  d
	.s curCode=$P($G(^DHCPACVisitStatus(rw)),"^",1)
	.i code=curCode s ret=rw q
	.s curDesc=$P($G(^DHCPACVisitStatus(rw)),"^",2)
	.i desc=curDesc s ret=rw q
	q ret
}

/// 新增或修改
ClassMethod Save(parr As %String) As %String
{
	//w ##class(web.DHCPACVisitStatus).Save("^Test2^入院2^急诊^1^2006-08-31^^Y^Y^")
	s ^tempdebug("11")=parr
	s id=$P(parr,"^",1)
	s Code=$P(parr,"^",2)
	s Desc=$P(parr,"^",3)
	s ret=..IfExist(Code_"^"_Desc)
	q:(id="")&&(ret'="") 1
	s EpisodeType=$P(parr,"^",4)
	s EpisodeStatus=$P(parr,"^",5)
	s DateFrom=$P(parr,"^",6)
	i DateFrom'="" s DateFrom=$$$ZDH(DateFrom,4)
	s DateTo=$P(parr,"^",7)
	i DateTo'="" s DateTo=$$$zdH(DateTo,4)
	s DoctorAccess=$P(parr,"^",8)
	s NurseAccess=$P(parr,"^",9)
	s PreVisitStatDr=$P(parr,"^",10)
	b //00
	if id'="" s a=##class(User.DHCPACVisitStatus).%OpenId(id)
	e  s a=##class(User.DHCPACVisitStatus).%New()
	s a.PVSCode=Code
	s a.PVSDesc=Desc
	s a.PVSEpisodeType=EpisodeType
	s a.PVSEpisodeStatus=EpisodeStatus
	s a.PVSDateFrom=DateFrom
	s a.PVSDateTo=DateTo
	s a.PVSDoctorAccess=DoctorAccess
	s a.PVSNurseAccess=NurseAccess
	i PreVisitStatDr'="" d
	.d a.PVSPreVisitStatDrSetObjectId(PreVisitStatDr)
	e  s a.PVSPreVisitStatDr=""
	s ret=0
	s sc=a.%Save()
	i $$$ISERR(sc) d
	.;d $System.Status.DisplayError(sc)
	.s ret="保存失败!"
	q ret
}

ClassMethod Delete(id As %String) As %String
{
	d ##class(User.DHCPACVisitStatus).%DeleteId(id)
	q 0
}

/// 查询急诊状态
Query FindPACVisitStatus(findType) As %Query(ROWSPEC = "tPVSCode,tPVSDesc,tPVSEpisodeType,tEpisodeStatus,tDateFrom,tDateTo,tDoctorAccess,tNurseAccess,tPreVisitStat,tPreVisitStatId,RowId")
{
}

ClassMethod FindPACVisitStatusExecute(ByRef qHandle As %Binary, findType) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCPACVisitStatus","FindPACVisitStatus")
	s RowId=0
	f  s RowId=$o(^DHCPACVisitStatus(RowId))  q:RowId=""  d
	.s tPVSCode=$p(^DHCPACVisitStatus(RowId),"^",1)
	.s tPVSDesc=$p(^DHCPACVisitStatus(RowId),"^",2)
	.s tPVSEpisodeType=$p(^DHCPACVisitStatus(RowId),"^",3)
	.s tEpisodeStatus=$p(^DHCPACVisitStatus(RowId),"^",4)
	.s tDateFrom=$p(^DHCPACVisitStatus(RowId),"^",5)
	.s tDateTo=$p(^DHCPACVisitStatus(RowId),"^",6)
	.s h=+$h
 	.q:(findType'="")&(((h<tDateFrom)&&(tDateFrom'=""))!((h>tDateTo)&&(tDateTo'="")))
	.i tDateFrom'="" s tDateFrom=$$$zd(tDateFrom,4)
	.i tDateTo'="" s tDateTo=$$$zd(tDateTo,4)
	.s tDoctorAccess=$p(^DHCPACVisitStatus(RowId),"^",7)
	.s tNurseAccess=$p(^DHCPACVisitStatus(RowId),"^",8)
	.s tPreVisitStat=""
	.s tPreVisitStatId=$p(^DHCPACVisitStatus(RowId),"^",9)
	.i tPreVisitStatId'="" s tPreVisitStat=$p(^DHCPACVisitStatus(tPreVisitStatId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tPVSCode,tPVSDesc,tPVSEpisodeType,tEpisodeStatus,tDateFrom,tDateTo,tDoctorAccess,tNurseAccess,tPreVisitStat,tPreVisitStatId,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPACVisitStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPACVisitStatusExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPACVisitStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPACVisitStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询急诊状态
Query FindPVSEpisodeType() As %Query(ROWSPEC = "Code,Desc")
{
}

ClassMethod FindPVSEpisodeTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCPACVisitStatus","FindPVSEpisodeType")
	s Code="I",Desc="Inpatient"
	d OutputRow1
	s Code="O",Desc="Outpatient"
	d OutputRow1
	s Code="E",Desc="Emergency"
	d OutputRow1
	s Code="P",Desc="Physical"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Code,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPVSEpisodeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPVSEpisodeTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPVSEpisodeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPVSEpisodeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCPACVisitStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPACVisitStatusD</DataLocation>
<DefaultData>DHCPACVisitStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPACVisitStatusD</IdLocation>
<IndexLocation>^web.DHCPACVisitStatusI</IndexLocation>
<StreamLocation>^web.DHCPACVisitStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
