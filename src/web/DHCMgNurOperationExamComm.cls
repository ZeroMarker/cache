/// 
/// 
/// 操作项目考试公共查询类
Class web.DHCMgNurOperationExamComm Extends %RegisteredObject
{

ClassMethod setArray(parr, tmp)
{
	q:parr="" tmp
	s len=$L(parr,"^")
	f i=1:1:len
	{
		s item=$P(parr,"^",i)
		i item="" continue
		s name=$P(item,"|")
		s val=$P(item,"|",2)
		s tmp(name)=val
	}
}

/// 
/// 
/// 查询操作项目
Query SearchOperItm(par As %String, stype As %String = "") As %Query(ROWSPEC = "operatedesc,operatecode")
{
}

ClassMethod SearchOperItmExecute(ByRef qHandle As %Binary, par As %String, stype As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s stype=$ZConvert(stype,"U")
 	s par=$ZConvert(par,"U")
 	s raw=$O(^DHCMGNUR.CommDictionaryI("Code"," "_par,""))
 	q:raw=""
 	s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubD(raw,rw)) q:rw=""  d
 	.s str=^DHCMGNUR.CommDictionarySubD(raw,rw)
 	.;s code=$list(str,2)
 	.s code=raw_"||"_rw
 	.s desc=$list(str,5)
 	.q:((stype'="")&&(desc'[stype))
 	.d OutRowtyp
	 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(desc,code)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchOperItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchOperItmExecute ]
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

ClassMethod SearchOperItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchOperItmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod nurheadGetDataBack(parr, tmp)
{
	s dep=$P(parr,"^",1)
 	s nurse=$ZConvert($P(parr,"^",2),"U")
 	s operitm=$ZConvert($P(parr,"^",3),"U")
 	s operdate=$P(parr,"^",4)
 	i $G(operdate)'="" s operdate=$ZDH(operdate,3)
 	e  s operdate=""
 	s larloc=$P(parr,"^",5)
 	s group=$P(parr,"^",6)
 	s userid=$P(parr,"^",7)
 	s tmp=""
 	s date="" f  s date=$O(^DHCMGNUR.MgNurOperationExamI("Date",date)) q:date=""  d
 	.q:((operdate'="")&&(date<operdate))
 	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurOperationExamI("Date",date,rw)) q:rw=""  d
 	..s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(rw)
 	..q:((dep'="")&&(obj.ScoreDep'=dep))
 	..i obj.ScoreDate'="" s ScoreDate=$ZD(obj.ScoreDate,3)
 	..e  s ScoreDate=""
 	..i obj.ScoreDep'="" s ScoreDep=$P(^CTLOC(obj.ScoreDep),"^",2)
 	..e  s ScoreDep=""
 	..q:(operitm'="")&&($ZConvert(obj.ScoreItem,"U")'=operitm)
 	..i obj.ScoreItem'="" d
 	...s ItmObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreItem)
 	...s ScoreItem=ItmObj.Code
 	..e  s ScoreItem=""
 	..i obj.ScoreMissReason'="" d
 	...s reaObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreMissReason)
 	...s ScoreReason=reaObj.Code
 	..e  s ScoreReason=""
 	..q:(nurse'="")&&($ZConvert(obj.ScoreNur,"U")'=nurse)
 	..i obj.ScoreNur'="" d
 	...s perRaw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScoreNur,"U"),""))
 	...i perRaw'="" d
 	....s perObj=##class(DHCMGNUR.MgPersons).%OpenId(perRaw)
 	....s nurName=perObj.PersonName
 	....s nurNo=perObj.PersonID
 	....s ScoreNur=$ZConvert(nurNo,"U")_nurName
 	..e  s ScoreNur=""
 	..s ScoreResult=obj.ScoreResult
 	..s ScoreMonth=..getMonth(obj.ScoreMonth)
 	..s ScoreYear=obj.ScoreYear
 	..s tmp(rw)="ScoreDate|"_ScoreDate_"^ScoreDep|"_ScoreDep_"^ScoreItem|"_ScoreItem_"^ScoreReason|"_ScoreReason_"^ScoreNur|"_ScoreNur_"^ScoreResult|"_ScoreResult_"^ScoreMonth|"_ScoreMonth_"^ScoreYear|"_ScoreYear
	q tmp
}

ClassMethod chiefNurheadGetDataBack(parr, tmp) As %String
{
	s dep=$P(parr,"^",1)
 	s nurse=$ZConvert($P(parr,"^",2),"U")
 	s operitm=$ZConvert($P(parr,"^",3),"U")
 	s operdate=$P(parr,"^",4)
 	i $G(operdate)'="" s operdate=$ZDH(operdate,3)
 	e  s operdate=""
 	s larloc=$P(parr,"^",5)
 	s group=$P(parr,"^",6)
 	s userid=$P(parr,"^",7)
 	s tmp=""
 	s larLocId="" f  s larLocId=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_userid,larLocId)) q:larLocId=""  d
 	.s unitId="" f  s unitId=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",larLocId,unitId)) q:unitId=""  d
 	..s date="" f  s date=$O(^DHCMGNUR.MgNurOperationExamI("DateDep",date)) q:date=""  d
 	...q:((operdate'="")&&(date<operdate))
 	...s rw="" f  s rw=$O(^DHCMGNUR.MgNurOperationExamI("DateDep",date," "_unitId,rw)) q:rw=""  d
 	....s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(rw)
 	....q:((dep'="")&&(obj.ScoreDep'=dep))
 	....q:((nurse'="")&&(obj.ScoreNur'=nurse))
 	....q:((operitm'="")&&(obj.ScoreItem'=operitm))
 	....i obj.ScoreDate'="" s ScoreDate=$ZD(obj.ScoreDate,3)
 	....e  s ScoreDate=""
 	....i $G(^CTLOC(obj.ScoreDep))'="" s ScoreDep=$P(^CTLOC(obj.ScoreDep),"^",2)
 	....e  s ScoreDep=""
 	....i obj.ScoreItem'="" d
 	.....s itmObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreItem)
 	.....s ScoreItem=itmObj.Code
 	....e  s ScoreItem=""
 	....i obj.ScoreMissReason'="" d
 	.....s reaObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreMissReason)
 	.....s ScoreReason=reaObj.Code
 	....e  s ScoreReason=""
 	....i obj.ScoreNur'="" d
 	.....s perRaw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScoreNur,"U"),""))
 	.....i perRaw'="" d
 	......s perObj=##class(DHCMGNUR.MgPersons).%OpenId(perRaw)
 	......s nurName=perObj.PersonName
 	......s nurNo=perObj.PersonID
 	......s ScoreNur=$ZConvert(nurNo,"U")_nurName
 	....e  s ScoreNur=""
 	....s ScoreResult=obj.ScoreResult
 	....s ScoreMonth=..getMonth(obj.ScoreMonth)
 	....s ScoreYear=obj.ScoreYear
 	....s tmp(rw)="ScoreDate|"_ScoreDate_"^ScoreDep|"_ScoreDep_"^ScoreItem|"_ScoreItem_"^ScoreReason|"_ScoreReason_"^ScoreNur|"_ScoreNur_"^ScoreResult|"_ScoreResult_"^ScoreMonth|"_ScoreMonth_"^ScoreYear|"_ScoreYear
	q tmp
}

ClassMethod hlbgetdataBack(parr, tmp) As %String
{
	s dep=$P(parr,"^",1)
 	s nurse=$ZConvert($P(parr,"^",2),"U")
 	s operitm=$ZConvert($P(parr,"^",3),"U")
 	s operdate=$P(parr,"^",4)
 	i $G(operdate)'="" s operdate=$ZDH(operdate,3)
 	e  s operdate=""
 	s larloc=$P(parr,"^",5)
 	s group=$P(parr,"^",6)
 	s userid=$P(parr,"^",7)
 	s tmp=""
 	i larloc'="" d
 	.s largeLoc=$ZConvert(larloc,"U")
 	.s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_largeLoc,loc)) q:loc=""  d
 	..s date="" f  s date=$O(^DHCMGNUR.MgNurOperationExamI("DateDep",date)) q:date=""  d
 	...q:((operdate'="")&&(date<operdate))
 	...s rw="" f  s rw=$O(^DHCMGNUR.MgNurOperationExamI("DateDep",date," "_loc,rw)) q:rw=""  d
 	....s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(rw)
 	....q:((dep'="")&&(obj.ScoreDep'=dep))
 	....q:((nurse'="")&&(obj.ScoreNur'=nurse))
 	....q:((operitm'="")&&(obj.ScoreItem'=operitm))
 	....i obj.ScoreDate'="" s ScoreDate=$ZD(obj.ScoreDate,3)
 	....e  s ScoreDate=""
 	....i $G(^CTLOC(obj.ScoreDep))'="" s ScoreDep=$P(^CTLOC(obj.ScoreDep),"^",2)
 	....e  s ScoreDep=""
 	....i obj.ScoreItem'="" d
 	.....s itmObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreItem)
 	.....s ScoreItem=itmObj.Code
 	....e  s ScoreItem=""
 	....i obj.ScoreMissReason'="" d
 	.....s reaObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreMissReason)
 	.....s ScoreReason=reaObj.Code
 	....e  s ScoreReason=""
 	....i obj.ScoreNur'="" d
 	.....s perRaw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScoreNur,"U"),""))
 	.....i perRaw'="" d
 	......s perObj=##class(DHCMGNUR.MgPersons).%OpenId(perRaw)
 	......s nurName=perObj.PersonName
 	......s nurNo=perObj.PersonID
 	......s ScoreNur=$ZConvert(nurNo,"U")_nurName
 	....e  s ScoreNur=""
 	....s ScoreResult=obj.ScoreResult
 	....s ScoreMonth=..getMonth(obj.ScoreMonth)
 	....s ScoreYear=obj.ScoreYear
 	....s tmp(rw)="ScoreDate|"_ScoreDate_"^ScoreDep|"_ScoreDep_"^ScoreItem|"_ScoreItem_"^ScoreReason|"_ScoreReason_"^ScoreNur|"_ScoreNur_"^ScoreResult|"_ScoreResult_"^ScoreMonth|"_ScoreMonth_"^ScoreYear|"_ScoreYear
	e  d
	.d ..nurheadGetData(parr,.tmp)
	q tmp
}

ClassMethod nurheadGetData(parr, tmp)
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s dep=$P(parr,"^",1)
 	s nurse=$ZConvert($P(parr,"^",2),"U")
 	s operitm=$ZConvert($P(parr,"^",3),"U")
 	s operdate=$P(parr,"^",4)
 	i $G(operdate)'="" s operdate=$ZDH(operdate,3)
 	e  s operdate=""
 	s larloc=$P(parr,"^",5)
 	s group=$P(parr,"^",6)
 	s userid=$P(parr,"^",7)
 	i $P(parr,"^",9)'="" s stdate=$zdh($P(parr,"^",9),3)
 	e  s stdate=""
 	i $P(parr,"^",10)'="" s enddate=$zdh($P(parr,"^",10),3)
 	e  s enddate=""
 	s tmp=""
 	s nurseno="" f  s nurseno=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_dep,nurseno)) q:nurseno=""  d
 	.s date="" f  s date=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_dep,nurseno,date)) q:date=""  d
 	..q:((operdate'="")&&(date<operdate))
 	..s rw="" f  s rw=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_dep,nurseno,date,rw)) q:rw=""  d
 	...s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(rw)
 	...q:((stdate'="")&&(obj.ScoreDate'="")&&(obj.ScoreDate<stdate))
    ...q:((enddate'="")&&(obj.ScoreDate'="")&&(obj.ScoreDate>enddate))
    ...q:obj.Flag="N"
 	...i obj.ScoreDate'="" d
 	....i ((dateFlag=3)!(dateFlag=4)) s ScoreDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ScoreDate)
 	....e  s ScoreDate=""
 	...e  s ScoreDate=""
 	...q:((dep'="")&&(obj.ScoreDep'=dep))
 	...i obj.ScoreDep'="" s ScoreDep=$P(^CTLOC(obj.ScoreDep),"^",2)
 	...e  s ScoreDep=""
 	...q:(operitm'="")&&($ZConvert(obj.ScoreItem,"U")'=operitm)
 	...i obj.ScoreItem'="" d
 	....s ItmObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreItem)
 	....s ScoreItem=ItmObj.Code
 	...e  s ScoreItem=""
 	...i obj.ScoreMissReason'="" d
 	....s reaObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreMissReason)
 	....s ScoreReason=reaObj.Code
 	...e  s ScoreReason=""
 	...q:(nurse'="")&&($ZConvert(obj.ScoreNur,"U")'=nurse)
 	...i obj.ScoreNur'="" d
 	....s perRaw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScoreNur,"U"),""))
 	....i perRaw'="" d
 	.....s perObj=##class(DHCMGNUR.MgPersons).%OpenId(perRaw)
 	.....s nurName=perObj.PersonName
 	.....s nurNo=perObj.PersonID
 	.....s ScoreNur=$ZConvert(nurNo,"U")_nurName
 	...e  s ScoreNur=""
 	...s ScoreResult=obj.ScoreResult
 	...s ScoreMonth=..getMonth(obj.ScoreMonth)
 	...s ScoreYear=obj.ScoreYear
 	...s tmp(dep,$Tr(nurseno," ",""),date,rw)="ScoreDate|"_ScoreDate_"^ScoreDep|"_ScoreDep_"^ScoreItem|"_ScoreItem_"^ScoreReason|"_ScoreReason_"^ScoreNur|"_ScoreNur_"^ScoreResult|"_ScoreResult_"^ScoreMonth|"_ScoreMonth_"^ScoreYear|"_ScoreYear
	...;s tmp(dep,nurseno,date)="ScoreDate|"_ScoreDate_"^ScoreDep|"_ScoreDep_"^ScoreItem|"_ScoreItem_"^ScoreReason|"_ScoreReason_"^ScoreNur|"_ScoreNur_"^ScoreResult|"_ScoreResult_"^ScoreMonth|"_ScoreMonth
	q tmp
}

ClassMethod chiefNurheadGetData(parr, tmp) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s dep=$P(parr,"^",1)
 	s nurse=$ZConvert($P(parr,"^",2),"U")
 	s operitm=$ZConvert($P(parr,"^",3),"U")
 	s operdate=$P(parr,"^",4)
 	i $G(operdate)'="" s operdate=$ZDH(operdate,3)
 	e  s operdate=""
 	s larloc=$P(parr,"^",5)
 	s group=$P(parr,"^",6)
 	s userid=$P(parr,"^",7)
 	i $P(parr,"^",9)'="" s stdate=$zdh($P(parr,"^",9),3)
 	e  s stdate=""
 	i $P(parr,"^",10)'="" s enddate=$zdh($P(parr,"^",10),3)
 	e  s enddate=""
 	s tmp=""
 	s larLocId="" f  s larLocId=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_userid,larLocId)) q:larLocId=""  d
 	.s unitId="" f  s unitId=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",larLocId,unitId)) q:unitId=""  d
 	..s nurseno="" f  s nurseno=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_unitId,nurseno)) q:nurseno=""  d
 	...s date="" f  s date=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_unitId,nurseno,date)) q:date=""  d
 	....s rw="" f  s rw=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_unitId,nurseno,date,rw)) q:rw=""  d
 	.....s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(rw)
 	.....q:((dep'="")&&(obj.ScoreDep'=dep))
 	.....q:((nurse'="")&&(obj.ScoreNur'=nurse))
 	.....q:((operitm'="")&&(obj.ScoreItem'=operitm))
 	.....q:((stdate'="")&&(obj.ScoreDate'="")&&(obj.ScoreDate<stdate))
    .....q:((enddate'="")&&(obj.ScoreDate'="")&&(obj.ScoreDate>enddate))
    .....q:obj.Flag="N"
 	.....i obj.ScoreDate'="" d
 	......i ((dateFlag=3)!(dateFlag=4)) s ScoreDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ScoreDate)
 	......e  s ScoreDate=""
 	.....e  s ScoreDate=""
 	.....i $G(^CTLOC(obj.ScoreDep))'="" s ScoreDep=$P(^CTLOC(obj.ScoreDep),"^",2)
 	.....e  s ScoreDep=""
 	.....i obj.ScoreItem'="" d
 	......s itmObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreItem)
 	......s ScoreItem=itmObj.Code
 	.....e  s ScoreItem=""
 	.....i obj.ScoreMissReason'="" d
 	......s reaObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreMissReason)
 	......s ScoreReason=reaObj.Code
 	.....e  s ScoreReason=""
 	.....i obj.ScoreNur'="" d
 	......s perRaw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScoreNur,"U"),""))
 	......i perRaw'="" d
 	.......s perObj=##class(DHCMGNUR.MgPersons).%OpenId(perRaw)
 	.......s nurName=perObj.PersonName
 	.......s nurNo=perObj.PersonID
 	.......s ScoreNur=$ZConvert(nurNo,"U")_nurName
 	.....e  s ScoreNur=""
 	.....s ScoreResult=obj.ScoreResult
 	.....s ScoreMonth=..getMonth(obj.ScoreMonth)
 	.....s ScoreYear=obj.ScoreYear
 	.....s tmp(unitId,$Tr(nurseno," ",""),date,rw)="ScoreDate|"_ScoreDate_"^ScoreDep|"_ScoreDep_"^ScoreItem|"_ScoreItem_"^ScoreReason|"_ScoreReason_"^ScoreNur|"_ScoreNur_"^ScoreResult|"_ScoreResult_"^ScoreMonth|"_ScoreMonth_"^ScoreYear|"_ScoreYear
	q tmp
}

ClassMethod hlbgetdata(parr, tmp) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s dep=$P(parr,"^",1)
 	s nurse=$ZConvert($P(parr,"^",2),"U")
 	s operitm=$ZConvert($P(parr,"^",3),"U")
 	s operdate=$P(parr,"^",4)
 	i $G(operdate)'="" s operdate=$ZDH(operdate,3)
 	e  s operdate=""
 	s larloc=$P(parr,"^",5)
 	s group=$P(parr,"^",6)
 	s userid=$P(parr,"^",7)
 	i $P(parr,"^",9)'="" s stdate=$zdh($P(parr,"^",9),3)
 	e  s stdate=""
 	i $P(parr,"^",10)'="" s enddate=$zdh($P(parr,"^",10),3)
 	e  s enddate=""
 	s tmp=""
 	i larloc'="" d
 	.s largeLoc=$ZConvert(larloc,"U")
 	.s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_largeLoc,loc)) q:loc=""  d
 	..s nurseno="" f  s nurseno=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_loc,nurseno)) q:nurseno=""  d
 	...s date="" f  s date=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_loc,nurseno,date)) q:date=""  d
 	....s rw="" f  s rw=$O(^DHCMGNUR.MgNurOperationExamI("flag"," "_loc,nurseno,date,rw)) q:rw=""  d
 	.....s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(rw)
 	.....q:((dep'="")&&(obj.ScoreDep'=dep))
 	.....q:((nurse'="")&&(obj.ScoreNur'=nurse))
 	.....q:((operitm'="")&&(obj.ScoreItem'=operitm))
 	.....q:((stdate'="")&&(obj.ScoreDate'="")&&(obj.ScoreDate<stdate))
 	.....q:((enddate'="")&&(obj.ScoreDate'="")&&(obj.ScoreDate>enddate))
 	.....q:obj.Flag="N"
 	.....i obj.ScoreDate'="" d
 	......i ((dateFlag=3)!(dateFlag=4)) s ScoreDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ScoreDate)
 	......e  s ScoreDate=""
 	.....e  s ScoreDate=""
 	.....i $G(^CTLOC(obj.ScoreDep))'="" s ScoreDep=$P(^CTLOC(obj.ScoreDep),"^",2)
 	.....e  s ScoreDep=""
 	.....i obj.ScoreItem'="" d
 	......s itmObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreItem)
 	......s ScoreItem=itmObj.Code
 	.....e  s ScoreItem=""
 	.....i obj.ScoreMissReason'="" d
 	......s reaObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreMissReason)
 	......s ScoreReason=reaObj.Code
 	.....e  s ScoreReason=""
 	.....i obj.ScoreNur'="" d
 	......s perRaw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScoreNur,"U"),""))
 	......i perRaw'="" d
 	.......s perObj=##class(DHCMGNUR.MgPersons).%OpenId(perRaw)
 	.......s nurName=perObj.PersonName
 	.......s nurNo=perObj.PersonID
 	.......s ScoreNur=$ZConvert(nurNo,"U")_nurName
 	.....e  s ScoreNur=""
 	.....s ScoreResult=obj.ScoreResult
 	.....s ScoreMonth=..getMonth(obj.ScoreMonth)
 	.....s ScoreYear=obj.ScoreYear
 	.....s tmp(loc,$Tr(nurseno," ",""),date,rw)="ScoreDate|"_ScoreDate_"^ScoreDep|"_ScoreDep_"^ScoreItem|"_ScoreItem_"^ScoreReason|"_ScoreReason_"^ScoreNur|"_ScoreNur_"^ScoreResult|"_ScoreResult_"^ScoreMonth|"_ScoreMonth_"^ScoreYear|"_ScoreYear
	e  d
	.s nurdep="" f  s nurdep=$O(^DHCMGNUR.MgNurOperationExamI("flag",nurdep)) q:nurdep=""  d
	..s nurseno="" f  s nurseno=$O(^DHCMGNUR.MgNurOperationExamI("flag",nurdep,nurseno)) q:nurseno=""  d
	...s date="" f  s date=$O(^DHCMGNUR.MgNurOperationExamI("flag",nurdep,nurseno,date)) q:date=""  d
	....s rw="" f  s rw=$O(^DHCMGNUR.MgNurOperationExamI("flag",nurdep,nurseno,date,rw)) q:rw=""  d
	.....s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(rw)
	.....q:((dep'="")&&(obj.ScoreDep'=dep))
 	.....q:((nurse'="")&&(obj.ScoreNur'=nurse))
 	.....q:((operitm'="")&&(obj.ScoreItem'=operitm))
 	.....q:((stdate'="")&&(obj.ScoreDate'="")&&(obj.ScoreDate<stdate))
 	.....q:((enddate'="")&&(obj.ScoreDate'="")&&(obj.ScoreDate>enddate))
 	.....q:obj.Flag="N"
 	.....i obj.ScoreDate'="" d
 	......i ((dateFlag=3)!(dateFlag=4)) s ScoreDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ScoreDate)
 	......e  s ScoreDate=""
 	.....e  s ScoreDate=""
 	.....i $G(^CTLOC(obj.ScoreDep))'="" s ScoreDep=$P(^CTLOC(obj.ScoreDep),"^",2)
 	.....e  s ScoreDep=""
 	.....i obj.ScoreItem'="" d
 	......s itmObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreItem)
 	......s ScoreItem=itmObj.Code
 	.....e  s ScoreItem=""
 	.....i obj.ScoreMissReason'="" d
 	......s reaObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreMissReason)
 	......s ScoreReason=reaObj.Code
 	.....e  s ScoreReason=""
 	.....i obj.ScoreNur'="" d
 	......s perRaw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScoreNur,"U"),""))
 	......i perRaw'="" d
 	.......s perObj=##class(DHCMGNUR.MgPersons).%OpenId(perRaw)
 	.......s nurName=perObj.PersonName
 	.......s nurNo=perObj.PersonID
 	.......s ScoreNur=$ZConvert(nurNo,"U")_nurName
 	.....e  s ScoreNur=""
 	.....s ScoreResult=obj.ScoreResult
 	.....s ScoreMonth=..getMonth(obj.ScoreMonth)
 	.....s ScoreYear=obj.ScoreYear
 	.....s tmp($Tr(nurdep," ",""),$Tr(nurseno," ",""),date,rw)="ScoreDate|"_ScoreDate_"^ScoreDep|"_ScoreDep_"^ScoreItem|"_ScoreItem_"^ScoreReason|"_ScoreReason_"^ScoreNur|"_ScoreNur_"^ScoreResult|"_ScoreResult_"^ScoreMonth|"_ScoreMonth_"^ScoreYear|"_ScoreYear
	q tmp
}

ClassMethod getMonth(itm)
{
	i itm="Jan" s month="一月"
	i itm="Feb" s month="二月"
	i itm="Mar" s month="三月"
	i itm="Apr" s month="四月"
	i itm="May" s month="五月"
	i itm="Jun" s month="六月"
	i itm="Jul" s month="七月"
	i itm="Aug" s month="八月"
	i itm="Sep" s month="九月"
	i itm="Oct" s month="十月"
	i itm="Nov" s month="十一月"
	i itm="Dec" s month="十二月"
	i itm="" s month=""
	q month
}

ClassMethod getMonth2(itm)
{
	i itm="Jan" s month="01"
	i itm="Feb" s month="02"
	i itm="Mar" s month="03"
	i itm="Apr" s month="04"
	i itm="May" s month="05"
	i itm="Jun" s month="06"
	i itm="Jul" s month="07"
	i itm="Aug" s month="08"
	i itm="Sep" s month="09"
	i itm="Oct" s month="10"
	i itm="Nov" s month="11"
	i itm="Dec" s month="12"
	i itm="" s month=""
	q month
}

/// 
/// 
/// 查询操作项考试数据列表
Query SearchOperDataLst(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SearchOperDataLstExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TMP("g20150831001")=parr
 	//27^00001^67||1^2015-08-01^Emclinic^demo^1
 	s dep=$P(parr,"^",1)
 	s nurse=$ZConvert($P(parr,"^",2),"U")
 	s operitm=$ZConvert($P(parr,"^",3),"U")
 	s operdate=$P(parr,"^",4)
 	i $G(operdate)'="" s operdate=$ZDH(operdate,3)
 	e  s operdate=""
 	s larloc=$P(parr,"^",5)
 	s group=$P(parr,"^",6)
 	s userid=$P(parr,"^",7)
 	s check=$P(parr,"^",8)
 	i $P(parr,"^",9)'="" s stdate=$zdh($P(parr,"^",9),3)
 	e  s stdate=""
 	i $P(parr,"^",10)'="" s enddate=$zdh($P(parr,"^",10),3)
 	e  s enddate=""
 	s ret=""
 	s tmp="" k tmp
 	;i ((group["护士长")&&(group'["总")) d
 	;i group="nurhead" d
 	;.d ..nurheadGetData(parr,.tmp)
 	;.s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
 	;..s ret=tmp(rw)_"^rw|"_rw
 	;..d OutRowtyp
 	;i group="znurhead" d
 	;.d ..chiefNurheadGetData(parr,.tmp)
 	;.s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
 	;..s ret=tmp(rw)_"^rw|"_rw
 	;..d OutRowtyp
 	;i (group="demo")!(group="hlb")!(group="hlbzr") d
 	;.d ..hlbgetdata(parr,.tmp)
 	;.s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
 	;..s ret=tmp(rw)_"^rw|"_rw
 	;..d OutRowtyp
	i group="nurhead" d
 	.d ..nurheadGetData(parr,.tmp)
 	.s nurdep="" f  s nurdep=$O(tmp(nurdep)) q:nurdep=""  d
 	..s nurno="" f  s nurno=$O(tmp(nurdep,nurno)) q:nurno=""  d
 	...s nurdate="" f  s nurdate=$O(tmp(nurdep,nurno,nurdate)) q:nurdate=""  d
 	....s rw="" f  s rw=$O(tmp(nurdep,nurno,nurdate,rw)) q:rw=""  d
 	.....s ret=tmp(nurdep,nurno,nurdate,rw)_"^rw|"_rw
 	.....d OutRowtyp
 	i group="znurhead" d
 	.d ..chiefNurheadGetData(parr,.tmp)
 	.s nurdep="" f  s nurdep=$O(tmp(nurdep)) q:nurdep=""  d
 	..s nurno="" f  s nurno=$O(tmp(nurdep,nurno)) q:nurno=""  d
 	...s nurdate="" f  s nurdate=$O(tmp(nurdep,nurno,nurdate)) q:nurdate=""  d
 	....s rw="" f  s rw=$O(tmp(nurdep,nurno,nurdate,rw)) q:rw=""  d
 	.....s ret=tmp(nurdep,nurno,nurdate,rw)_"^rw|"_rw
 	.....d OutRowtyp
 	i (group="demo")!(group="hlb")!(group="hlbzr") d
 	.d ..hlbgetdata(parr,.tmp)
 	.s nurdep="" f  s nurdep=$O(tmp(nurdep)) q:nurdep=""  d
 	..s nurno="" f  s nurno=$O(tmp(nurdep,nurno)) q:nurno=""  d
 	...s nurdate="" f  s nurdate=$O(tmp(nurdep,nurno,nurdate)) q:nurdate=""  d
 	....s rw="" f  s rw=$O(tmp(nurdep,nurno,nurdate,rw)) q:rw=""  d
 	.....s ret=tmp(nurdep,nurno,nurdate,rw)_"^rw|"_rw
 	.....d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchOperDataLstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchOperDataLstExecute ]
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

ClassMethod SearchOperDataLstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchOperDataLstExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 获取未参加考试人员名单
ClassMethod getNurUnScore(parr As %String, tmp) As %String
{
	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	s stdate=$P(parr,"^",3)
 	if stdate=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s stdate=$zdh(stdate,3)
 	s edate=$P(parr,"^",4)
 	if edate=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s edate=$zdh(edate,3)
 	s usercode=$P(parr,"^",5)
 	s argitemdr=$P(parr,"^",6)
 	s usercode=$zconvert(usercode,"U")
}

/// 
/// Method Description:按照时间段输出未考试人员
/// Parameter:"parr":开始时间^结束时间
Query getUnScore(parr As %String) As %Query(ROWSPEC = "depdes,person,ksdate,result,item,rw,moth,missreason")
{
}

ClassMethod getUnScoreExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
  	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	s stdate=$P(parr,"^",3)
 	if stdate=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s stdate=$zdh(stdate,3)
 	s edate=$P(parr,"^",4)
 	if edate=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s edate=$zdh(edate,3)
 	s usercode=$P(parr,"^",5)
 	s argitemdr=$P(parr,"^",6)
 	s usercode=$zconvert(usercode,"U")
 	s userlocstr=""
 	i usercode="" s userlocstr=""
 	e  d
 	.s userlocstr=..getlocBigInfo(usercode)
 	.i userlocstr'="" s userlocstr="^"_userlocstr_"^"
 	s factloc="^"_loc_"^"
 	s levflag=3
 	s factnurtype=##class(Nur.DHCNURLocData).gettype(usercode)
 	i factnurtype["科护士长" s levflag=2
 	i factnurtype["护理部" s levflag=1
 	s argtypedr=$P(parr,"^",6)
 	s argpass=$P(parr,"^",7)
    ;f date=stdate:1:edate d
   	q:levflag=3
   	s MonthStr="一月^二月^三月^四月^五月^六月^七月^八月^九月^十月^十一月^十二月"
   	s perid="" f  s perid=$O(^User.DHCMGNurScoreI("NurId",perid)) q:perid=""  d
   	.s date="" f  s date=$O(^User.DHCMGNurScoreI("NurId",perid,date)) q:date=""  d
   	..q:((date<stdate)!(date>edate))
   	..q:(stdate=edate)&(date'=stdate)
   	..s id="" f  s id=$O(^User.DHCMGNurScoreI("NurId",perid,date,id)) q:id=""  d
   	...s obj=##class(User.DHCMGNurScore).%OpenId(id)
   	...s ScoreDate=obj.ScoreDate
   	...s ScoreItem=obj.ScoreItem.%Id()
   	...s ScoreMissReason=obj.ScoreMissReason.MgCodeCode
   	...s ScoreResult=obj.ScoreResult
   	...s Scoremoth=obj.Scoremoth.%Id()
   	...s TMPOBJ(perid,Scoremoth,id)=ScoreResult
   	...;s TMPOBJ1(perid,ScoreItem,id)=ScoreResult
   	...;b ;01
   	s monthIdStr=""
   	s rr="" f  s rr=$O(^User.DHCMGCCodeXHI("Typ",19,rr)) q:rr=""  d
   	.s monthIdStr=monthIdStr_rr_"^"
   	s monthIdStr=$E(monthIdStr,0,$l(monthIdStr)-1)
   	;b ;01
   	s dateTime=$FNUMBER($P($ZD(+$H,3),"-",1),"")
   	s yearfirst=$FNUMBER($P($ZD(stdate,3),"-",1),"")
   	s yearlast=$FNUMBER($P($ZD(edate,3),"-",1),"")
   	i yearfirst'=dateTime Set qHandle=$lb(0,repid,0) Quit $$$OK
   	i yearlast'=dateTime Set qHandle=$lb(0,repid,0) Quit $$$OK
   	s firstDate=$FNUMBER($P($ZD(stdate,3),"-",2),"")
   	s lastDate=$FNUMBER($P($ZD(edate,3),"-",2),"")
   	s l=firstDate
	s perid="" f  s perid=$O(^User.DHCMGNurScoreI("NurId",perid)) q:perid=""  d
	.;i l'>lastDate d
	.f l=firstDate:1:lastDate d
	..i (($D(TMPOBJ(perid,$P(monthIdStr,"^",l)))=0)) s TMPOBJ2(perid,$P(monthIdStr,"^",l))=1
	..
	s sp="" f  s sp=$O(TMPOBJ2(sp)) q:sp=""  d
	.s monid="" f  s monid=$O(TMPOBJ2(sp,monid)) q:monid=""  d
	..s spObj=##class(User.DHCMGPersons).%OpenId(sp)
	..s monObj=##class(User.DHCMGCCodeXH).%OpenId(monid)
	..i $G(TMPOBJ2(sp,monid))=1 d
	...s person=spObj.PersonID_spObj.PersonName
	...s moth=monObj.MgCodeDesc
	...s ksdate=""
	...s (result,rw,item,missreason)=""
	...s par=##class(User.DHCMGPersons).%OpenId(sp)
	...i $G(^CTLOC(par.PersonDepDR))'="" s depdes=$P(^CTLOC(par.PersonDepDR),"^",2)
	...e  s depdes=""
    ...d OutRowtyp2Score
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp2Score
	set Data=$lb(depdes,person,ksdate,result,item,rw,moth,missreason)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getUnScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getUnScoreExecute ]
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

ClassMethod getUnScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getUnScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getlocBigInfo(UserId) As %String
{
	s ret=""
	q:UserId=""
	s UserId=$zconvert(UserId,"U")
	s rw="" s rw=$o(^Nur.DHCNURLocDataI("UserId"," "_UserId,rw))
	i rw'="" d
	.s chl="" f  s chl=$o(^Nur.DHCNURLocDataSubD(rw,chl)) q:chl=""  d
	..s rowid=rw_"||"_chl
	..s obj=##class(Nur.DHCNURLocDataSub).%OpenId(rowid)
	..s locdr=obj.Loc
	..q:locdr=""
	..i ret="" s ret=locdr
	..e  s ret=ret_"^"_locdr
	q ret
}

}
