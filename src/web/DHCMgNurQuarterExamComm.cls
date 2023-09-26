/// 
/// 
/// 季度考试公共类
Class web.DHCMgNurQuarterExamComm Extends %RegisteredObject
{

ClassMethod setArray(parr, tmp)
{
	q:parr="" tmp
	s len=$L(parr,"^")
	f i=1:1:len
	{
		s item=$P(parr,"^",i)
		i item="" continue
		s name=$P(item,"@")
		s val=$P(item,"@",2)
		s tmp(name)=val
	}
}

Query SearchCommType(param As %String, stype As %String = "") As %Query(ROWSPEC = "desc,code")
{
}

ClassMethod SearchCommTypeExecute(ByRef qHandle As %Binary, param As %String, stype As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s stype=$ZConvert(stype,"U")
 	s param=$ZConvert(param,"U")
 	s par=$O(^DHCMGNUR.CommDictionaryI("Code"," "_param,""))
 	q:par=""
 	s tm="" f  s tm=$O(^DHCMGNUR.CommDictionarySubI("Code",tm)) q:tm=""  d
 	.s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",tm,par,rw)) q:rw=""  d
 	..s raw=par_"||"_rw
 	..s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(raw)
 	..s desc=a.Code
 	..q:((stype'="")&&(desc'[stype))
 	..d OutRowtyp
	 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(desc,raw)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchCommTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchCommTypeExecute ]
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

ClassMethod SearchCommTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchCommTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 
/// 查询护士 工号+姓名
Query SearchNurse(parr As %String = "", sdep As %String = "") As %Query(ROWSPEC = "nurseInfo,nurseNo")
{
}

ClassMethod SearchNurseExecute(ByRef qHandle As %Binary, parr As %String = "", sdep As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s parr=$ZConvert(parr,"U")
 	s nurse="" f  s nurse=$O(^DHCMGNUR.MgPersonsI("SSID",nurse)) q:nurse=""  d
 	.s rw="" f  s rw=$O(^DHCMGNUR.MgPersonsI("SSID",nurse,rw)) q:rw=""  d
 	..s obj=##class(DHCMGNUR.MgPersons).%OpenId(rw)
 	..q:obj.PersonType2'="N"
 	..s nursename=obj.PersonName
 	..s nurseNo=obj.PersonID
 	..s nurseInfo=nurseNo_"!"_nursename
 	..q:((parr'="")&&(nurseInfo'[parr))
 	..q:((sdep'="")&&(obj.PersonDepDR'=sdep))
 	..d OutRowtyp
	 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(nurseInfo,nurseNo)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNurseExecute ]
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

ClassMethod SearchNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

ClassMethod nurseHeaderGetData(parr As %String, tmp) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ^TEMP("1111111")=parr
	s dep=$P(parr,"^",1)
 	s typ=$P(parr,"^",2)
 	s nurse=$ZConvert($Tr($P(parr,"^",3)," ",""),"U")
 	s examdate=$P(parr,"^",5)
 	i examdate'="" s examdate=$ZDH(examdate,3)
 	s pass=$P(parr,"^",4)
 	s largedep=$P(parr,"^",6)
 	s group=$P(parr,"^",7)
 	s userid=$P(parr,"^",8)
 	s depid=$p(parr,"^",9)
 	s tmp=""
	s date="" f  s date=$O(^DHCMGNUR.MgNurQuarterExamI("Date",date)) q:date=""  d
 	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurQuarterExamI("Date",date,rw)) q:rw=""  d
 	..s obj=##class(DHCMGNUR.MgNurQuarterExam).%OpenId(rw)
 	..;q:((dep'="")&&(obj.QuarterDep'=dep))
 	..q:((depid'="")&&(obj.QuarterDep'=depid))
 	..;q:((typ'="")&&(obj.QuarterType'=typ))
 	..q:((examdate'="")&&(obj.QuarterDate<examdate))
 	..;q:((pass'="")&&(obj.QuarterPass'=pass))
 	..;q:((nurse'="")&&(obj.QuarterNur'=nurse))
 	..q:obj.QuarterFlag="N"
 	..i obj.QuarterDate'="" d
 	...i ((dateFlag=3)!(dateFlag=4)) s QuarterDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.QuarterDate)
 	...e  s QuarterDate=""
 	..e  s QuarterDate=""
 	..s QuarterDep=$P(^CTLOC(obj.QuarterDep),"^",2)
 	..i obj.QuarterMissReason'="" s QuarterMissReason=obj.QuarterMissReason.Code
 	..e  s QuarterMissReason=""
 	..s QuarterNur=obj.QuarterNur
 	..s raw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(QuarterNur,"U"),""))
 	..i raw'="" d
 	...s perobj=##class(DHCMGNUR.MgPersons).%OpenId(raw)
 	...s QuarterNur=QuarterNur_perobj.PersonName
 	..i obj.QuarterPass="1" s QuarterPass="不及格"
 	..i obj.QuarterPass="2" s QuarterPass="及格"
 	..i obj.QuarterPass="3" s QuarterPass="良好"
 	..i obj.QuarterPass="4" s QuarterPass="优秀"
 	..i obj.QuarterPass="" s QuarterPass=""
 	..s QuarterResult=obj.QuarterResult
 	..i obj.QuarterType="1" s QuarterType="一季度"
 	..i obj.QuarterType="2" s QuarterType="二季度"
 	..i obj.QuarterType="3" s QuarterType="三季度"
 	..i obj.QuarterType="4" s QuarterType="四季度"
 	..s tmp(rw)="QuarterDate|"_QuarterDate_"^QuarterDep|"_QuarterDep_"^QuarterMissReason|"_QuarterMissReason_"^QuarterNur|"_QuarterNur_"^QuarterPass|"_QuarterPass_"^QuarterResult|"_QuarterResult_"^QuarterType|"_QuarterType_"^rw|"_rw
 	q tmp
}

ClassMethod chiefNurheadGetData(parr, tmp) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s dep=$P(parr,"^",1)
 	s typ=$P(parr,"^",2)
 	s nurse=$ZConvert($Tr($P(parr,"^",3)," ",""),"U")
 	s examdate=$P(parr,"^",5)
 	i examdate'="" s examdate=$ZDH(examdate,3)
 	e  s examdate=""
 	s pass=$P(parr,"^",4)
 	s largedep=$P(parr,"^",6)
 	s group=$P(parr,"^",7)
 	s userid=$P(parr,"^",8)
 	s tmp=""
 	s larLocId="" f  s larLocId=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_userid,larLocId)) q:larLocId=""  d
 	.s unitId="" f  s unitId=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ",larLocId,unitId)) q:unitId=""  d
 	..s date="" f  s date=$O(^DHCMGNUR.MgNurQuarterExamI("DateDep",date)) q:date=""  d
 	...q:(examdate'="")&&(date<examdate)
 	...s rw="" f  s rw=$O(^DHCMGNUR.MgNurQuarterExamI("DateDep",date," "_unitId,rw)) q:rw=""  d
 	....s obj=##class(DHCMGNUR.MgNurQuarterExam).%OpenId(rw)
 	....q:(dep'="")&&(obj.QuarterDep'=dep)
 	....q:obj.QuarterFlag="N"
 	....q:(pass'="")&&(obj.QuarterPass'=pass)
 	....q:((nurse'="")&&(obj.QuarterNur'=nurse))
 	....q:((typ'="")&&(obj.QuarterType'=typ))
 	....i obj.QuarterDate'="" d
 	.....i ((dateFlag=3)!(dateFlag=4)) s QuarterDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.QuarterDate)
 	.....e  s QuarterDate=""
 	....e  s QuarterDate=""
 	....s QuarterDep=$P(^CTLOC(obj.QuarterDep),"^",2)
 	....i obj.QuarterMissReason'="" s QuarterMissReason=obj.QuarterMissReason.Code
 	....e  s QuarterMissReason=""
 	....s QuarterNur=obj.QuarterNur
 	....s raw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(QuarterNur,"U"),""))
 	....i raw'="" d
 	.....s perobj=##class(DHCMGNUR.MgPersons).%OpenId(raw)
 	.....s QuarterNur=QuarterNur_perobj.PersonName
 	....i obj.QuarterPass="1" s QuarterPass="不及格"
 	....i obj.QuarterPass="2" s QuarterPass="及格"
 	....i obj.QuarterPass="3" s QuarterPass="良好"
 	....i obj.QuarterPass="4" s QuarterPass="优秀"
 	....i obj.QuarterPass="" s QuarterPass=""
 	....s QuarterResult=obj.QuarterResult
 	....i obj.QuarterType="1" s QuarterType="一季度"
 	....i obj.QuarterType="2" s QuarterType="二季度"
 	....i obj.QuarterType="3" s QuarterType="三季度"
 	....i obj.QuarterType="4" s QuarterType="四季度"
 	....s tmp(rw)="QuarterDate|"_QuarterDate_"^QuarterDep|"_QuarterDep_"^QuarterMissReason|"_QuarterMissReason_"^QuarterNur|"_QuarterNur_"^QuarterPass|"_QuarterPass_"^QuarterResult|"_QuarterResult_"^QuarterType|"_QuarterType_"^rw|"_rw
 	q tmp
}

ClassMethod hlbgetdata(parr, tmp) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s dep=$P(parr,"^",1)
 	s typ=$P(parr,"^",2)
 	s nurse=$ZConvert($Tr($P(parr,"^",3)," ",""),"U")
 	s examdate=$P(parr,"^",5)
 	i examdate'="" s examdate=$ZDH(examdate,3)
 	e  s examdate=""
 	s pass=$P(parr,"^",4)
 	s largedep=$P(parr,"^",6)
 	s group=$P(parr,"^",7)
 	s userid=$P(parr,"^",8)
 	s tmp=""
 	b ;0008
 	i largedep="" d
 	.s date="" f  s date=$O(^DHCMGNUR.MgNurQuarterExamI("Date",date)) q:date=""  d
 	..s rw="" f  s rw=$O(^DHCMGNUR.MgNurQuarterExamI("Date",date,rw)) q:rw=""  d
 	...s obj=##class(DHCMGNUR.MgNurQuarterExam).%OpenId(rw)
 	...q:((dep'="")&&(obj.QuarterDep'=dep))
 	...q:((typ'="")&&(obj.QuarterType'=typ))
 	...q:((examdate'="")&&(obj.QuarterDate<examdate))
 	...q:((pass'="")&&(obj.QuarterPass'=pass))
 	...q:((nurse'="")&&(obj.QuarterNur'=nurse))
 	...q:obj.QuarterFlag="N"
 	...i obj.QuarterDate'="" d
 	....i ((dateFlag=3)!(dateFlag=4)) s QuarterDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.QuarterDate)
 	....e  s QuarterDate=""
 	...e  s QuarterDate=""
 	...s QuarterDep=$P(^CTLOC(obj.QuarterDep),"^",2)
 	...i obj.QuarterMissReason'="" s QuarterMissReason=obj.QuarterMissReason.Code
 	...e  s QuarterMissReason=""
 	...s QuarterNur=obj.QuarterNur
 	...s raw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(QuarterNur,"U"),""))
 	...i raw'="" d
 	....s perobj=##class(DHCMGNUR.MgPersons).%OpenId(raw)
 	....s QuarterNur=QuarterNur_perobj.PersonName
 	...i obj.QuarterPass="1" s QuarterPass="不及格"
 	...i obj.QuarterPass="2" s QuarterPass="及格"
 	...i obj.QuarterPass="3" s QuarterPass="良好"
 	...i obj.QuarterPass="4" s QuarterPass="优秀"
 	...i obj.QuarterPass="" s QuarterPass=""
 	...s QuarterResult=obj.QuarterResult
 	...i obj.QuarterType="1" s QuarterType="一季度"
 	...i obj.QuarterType="2" s QuarterType="二季度"
 	...i obj.QuarterType="3" s QuarterType="三季度"
 	...i obj.QuarterType="4" s QuarterType="四季度"
 	...s tmp(rw)="QuarterDate|"_QuarterDate_"^QuarterDep|"_QuarterDep_"^QuarterMissReason|"_QuarterMissReason_"^QuarterNur|"_QuarterNur_"^QuarterPass|"_QuarterPass_"^QuarterResult|"_QuarterResult_"^QuarterType|"_QuarterType_"^rw|"_rw
 	e  d
 	.b ;009
 	.s largeLoc=$ZConvert(largedep,"U")
 	.s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_largeLoc,loc)) q:loc=""  d
 	..s date="" f  s date=$O(^DHCMGNUR.MgNurQuarterExamI("DateDep",date)) q:date=""  d
 	...q:(examdate'="")&&(date<examdate)
 	...s rw="" f  s rw=$O(^DHCMGNUR.MgNurQuarterExamI("DateDep",date," "_loc,rw)) q:rw=""  d
 	....s obj=##class(DHCMGNUR.MgNurQuarterExam).%OpenId(rw)
 	....q:(dep'="")&&(obj.QuarterDep'=dep)
 	....q:obj.QuarterFlag="N"
 	....q:(pass'="")&&(obj.QuarterPass'=pass)
 	....q:((nurse'="")&&(obj.QuarterNur'=nurse))
 	....q:((typ'="")&&(obj.QuarterType'=typ))
 	....i obj.QuarterDate'="" d
 	.....i ((dateFlag=3)!(dateFlag=4)) s QuarterDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.QuarterDate)
 	.....e  s QuarterDate=$ZD(obj.QuarterDate,3)
 	....e  s QuarterDate=""
 	....s QuarterDep=$P(^CTLOC(obj.QuarterDep),"^",2)
 	....i obj.QuarterMissReason'="" s QuarterMissReason=obj.QuarterMissReason.Code
 	....e  s QuarterMissReason=""
 	....s QuarterNur=obj.QuarterNur
 	....s raw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(QuarterNur,"U"),""))
 	....i raw'="" d
 	.....s perobj=##class(DHCMGNUR.MgPersons).%OpenId(raw)
 	.....s QuarterNur=QuarterNur_perobj.PersonName
 	....i obj.QuarterPass="1" s QuarterPass="不及格"
 	....i obj.QuarterPass="2" s QuarterPass="及格"
 	....i obj.QuarterPass="3" s QuarterPass="良好"
 	....i obj.QuarterPass="4" s QuarterPass="优秀"
 	....i obj.QuarterPass="" s QuarterPass=""
 	....s QuarterResult=obj.QuarterResult
 	....i obj.QuarterType="1" s QuarterType="一季度"
 	....i obj.QuarterType="2" s QuarterType="二季度"
 	....i obj.QuarterType="3" s QuarterType="三季度"
 	....i obj.QuarterType="4" s QuarterType="四季度"
 	....s tmp(rw)="QuarterDate|"_QuarterDate_"^QuarterDep|"_QuarterDep_"^QuarterMissReason|"_QuarterMissReason_"^QuarterNur|"_QuarterNur_"^QuarterPass|"_QuarterPass_"^QuarterResult|"_QuarterResult_"^QuarterType|"_QuarterType_"^rw|"_rw
 	q tmp
}

/// 
/// 查询护士季度成绩
Query SearchNurseExam(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod SearchNurseExamExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//parr="^^^^2015-08-01^^总护士长^2199"
 	//parr="76^^^^2015-08-01^^住院护士长^1243"
 	//parr="^^^^2015-08-01^EmClinic^护理部^1243"
 	s dep=$P(parr,"^",1)
 	s typ=$P(parr,"^",2)
 	s nurse=$ZConvert($Tr($P(parr,"^",3)," ",""),"U")
 	s examdate=$P(parr,"^",5)
 	i examdate'="" s examdate=$ZDH(examdate,3)
 	s pass=$P(parr,"^",4)
 	s largedep=$P(parr,"^",6)
 	s group=$P(parr,"^",7)
 	s userid=$P(parr,"^",8)
 	s ret=""
 	s tmp="" k tmp
 	i (group["住院护士长") d
 	.d ..nurseHeaderGetData(parr,.tmp)
 	.s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
 	..s ret=tmp(rw)
 	..d OutRowtyp
 	e  i group="总护士长" d
 	.d ..chiefNurheadGetData(parr,.tmp)
 	.s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
 	..s ret=tmp(rw)
 	..d OutRowtyp
 	e  i ((group="护理部")!(group="Demo Group")) d
 	.d ..hlbgetdata(parr,.tmp)
 	.s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
 	..s ret=tmp(rw)
 	..d OutRowtyp
	 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchNurseExamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNurseExamExecute ]
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

ClassMethod SearchNurseExamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNurseExamExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

}
