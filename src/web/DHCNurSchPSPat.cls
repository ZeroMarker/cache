Class web.DHCNurSchPSPat Extends %Persistent
{

// 病区放大镜  d ##class(%ResultSet).RunQuery("web.DHCNurSchPSPat","GetPSPat")

Query GetPSPat(stdate As %String, eddate As %String, locid As %String, yips As %String) As %Query(ROWSPEC = "PatName :%String,Loc:%String,regNo:%String,sex:%String,age:%String,arcimdes:%String")
{
}

ClassMethod GetPSPatExecute(ByRef qHandle As %Binary, stdate As %String, eddate As %String, locid As %String, yips As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i stdate="" s stdate=+$h
 	i eddate="" s eddate=+$h
 	s oeordId=""
 	s flag=0
 	s logonLocId=$g(%session.Data("LOGON.CTLOCID"))
 	i logonLocId'="" d
 	.s logonHospital=$p(^CTLOC(logonLocId),"^",22)
 	s num=0
 	f date=stdate:1:eddate d
 	.f  s oeordId=$o(^OEORDi(0,"StDt",date,oeordId)) q:oeordId=""  d  
 	..s oeoriSub="" 
 	..f  s oeoriSub=$o(^OEORDi(0,"StDt",date,oeordId,oeoriSub)) q:(oeoriSub="")  d
 	...s skintest=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    ...s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    ...s ordLoc=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",3)
    ...q:ordLoc=""
    ...s ordHospital=$p(^CTLOC(ordLoc),"^",22)
    ...q:ordHospital'=$g(logonHospital)
 	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
	...q:ordStatCode="D" //q "停止医嘱不能置皮试结果!"   
    ...q:skintest'="Y"
    ...q:(abnorm="")&(yips="on")
    ...q:(abnorm'="")&(yips="")
    ...s admId=$p($g(^OEORD(oeordId)),"^",1)
    ...s ctlocId=$p(^PAADM(admId),"^",4)
    ...
    ...q:(ctlocId'=locid)&(locid'="") 	
    ...s depdr=$p(^CTLOC(ctlocId),"^",19)
 	...q:depdr'=1
    
    ...s sr=##Class(web.DHCCLCom).PatInfo(oeordId_"||"_oeoriSub)
    ...s regNo=$P(sr,"^",1)
    ...s sex=$P(sr,"^",4)
    ...s age=$P(sr,"^",8)  
	...s PatName=$P(sr,"^",5)
	...;s BedCode=$P(sr,"^",7)
	...s Loc=$P(sr,"^",2)
	...s WardDesc=$P(sr,"^",9)
	...s arcimdr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s scrip=$P(arcimdr,"||")
	...s ver=$P(arcimdr,"||",2)
	...s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2)
	...;s arcimdes=$p(arcimdes,"[")   //For WF 不要规格
	...i abnorm="Y" s arcimdes=arcimdes_"(+)"
	...i abnorm="N" s arcimdes=arcimdes_"(-)"
    ...s flag=1
    ...s num=num+1
    ...d OutRow2

    s PatName="",Loc="合计:"_num,regNo="",sex="",age="",arcimdes=""
 	d OutRow2

	 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow2
	set Data=$lb(PatName,Loc,regNo,sex,age,arcimdes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPSPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPSPatExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPSPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetallWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 获取门诊科室  d ##class(%ResultSet).RunQuery("web.DHCNurSchPSPat","GetPSPat")

Query GetMZLoc(desc) As %Query(ROWSPEC = "locdesc :%String,loccode:%String,locid:%String")
{
}

ClassMethod GetMZLocExecute(ByRef qHandle As %Binary, desc) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s locid="",locdesc="",loccode=""
 	;d OutRow1
 	f  s locid=$o(^CTLOC(locid)) q:locid=""  d 
 	.s depdr=$p(^CTLOC(locid),"^",19)
 	.q:depdr'=1
 	.s locdesc=$p(^CTLOC(locid),"^",2)
 	.q:(locdesc="")
 	.s tmplocdesc=$$ALPHAUP^SSUTIL4(locdesc) 	
 	.s CTLocCode= $p($g(^CTLOC(locid)),"^",43)
 	.s desc=$$ALPHAUP^SSUTIL4(desc)
 	.q:(tmplocdesc'[desc)&(desc'="")&(CTLocCode'[desc)
 	.i locdesc["-" s locdesc=$p(locdesc,"-",2)
 	.s loccode=CTLocCode
 	.d OutRow1

	 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow1
	set Data=$lb(locdesc,loccode,locid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMZLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMZLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMZLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetallWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCNurSchPSPatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNurSchPSPatD</DataLocation>
<DefaultData>DHCNurSchPSPatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNurSchPSPatD</IdLocation>
<IndexLocation>^web.DHCNurSchPSPatI</IndexLocation>
<StreamLocation>^web.DHCNurSchPSPatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
