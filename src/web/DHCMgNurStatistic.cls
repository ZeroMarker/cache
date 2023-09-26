Class web.DHCMgNurStatistic Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 按年龄段查询
Query SearchPersonAge(StDate As %String, EndDate As %String) As %Query(ROWSPEC = "Personcout,PersonName,PersonID,PersonSexDR,PersonBirthDay,PersonDepDR,PersonTransDate,Personmarriage,PersonWorkDateTime,PersonTelHand,PersonNativePlaceDR,PersonIdentity,Personpeopledr,PersonPolitydr,PersonSchoolAgeDr,PersonDegreeDR,PersonPostTyp,PersonBattery,PersonNurTyp,PersonWorkType,PersonCareDate,PersonTeachPostDR,PersonProfPostDR,PersonTechPostDate,PersonAppDutyDR,PersonHosEngageDate,PersonheadshipDR,PersonNurHeadDate")
{
}

ClassMethod SearchPersonAgeExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatistic","SearchPersonAge","1900-09-01","2013-10-30")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ($g(StDate)="")!($g(EndDate)="") Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s Personcout=0
 	s ret=""
 	i StDate="" s StDate=+$H
 	e  s stdate=$ZDH(StDate,3)
 	i EndDate="" s EndDate=+$H
 	e  s enddate=$ZDH(EndDate,3)
 	f birthday=stdate:1:enddate d
 	.s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SAge",birthday,id)) q:id=""  d
 	..s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	..s ^TY=id
 	..s PersonName=a.PersonName //姓名
 	..s PersonID=a.PersonID //工号
 	..i a.PersonSexDR="1" s PersonSexDR="男" //性别
 	..i a.PersonSexDR="2"  s PersonSexDR="女"
 	..;i a.PersonBirthDay'="" s PersonBirthDay=$ZD(a.PersonBirthDay,3) //出生日期
 	..;e  s PersonBirthDay=""
 	..i a.PersonBirthDay'="" s PersonBirthDay=$P(..CalAge(a.PersonBirthDay,+$H),"Y",1) //_"岁" //年龄
 	..;b ;10
 	..e  s PersonBirthDay=""
 	..i (a.PersonDepDR'="")&&(a.PersonDepDR'="9999") s PersonDepDR=$p(^CTLOC(a.PersonDepDR),"^",2) //护理单元
	..i a.PersonDepDR="9999" s PersonDepDR="护士"
	..i a.PersonDepDR="" s PersonDepDR=""
	..i a.PersonTransDate'="" s PersonTransDate=$ZD(a.PersonTransDate,3) //调入科室时间
	..e  s PersonTransDate=""
 	..i a.Personmarriage="1" s Personmarriage="未婚" //婚姻
 	..i a.Personmarriage="2" s Personmarriage="已婚"
 	..i a.Personmarriage="3" s Personmarriage="离婚"
 	..i a.PersonWorkDateTime'="" s PersonWorkDateTime=$ZD(a.PersonWorkDateTime,3) //参加工作时间
 	..e  s PersonWorkDateTime=""
 	..s PersonTelHand=a.PersonTelHand //手机
 	..s PersonNativePlaceDR=a.PersonNativePlaceDR //籍贯
 	..s PersonIdentity=a.PersonIdentity //身份证
 	..s Personpeopledr=a.Personpeopledr.Code //民族
 	..i a.PersonPolitydr'="" s PersonPolitydr=a.PersonPolitydr.Code //政治面貌
 	..e  s PersonPolitydr=""
 	..i a.PersonSchoolAgeDr'="" s PersonSchoolAgeDr=a.PersonSchoolAgeDr.Code //学历
 	..e  s PersonSchoolAgeDr=""
 	..i a.PersonDegreeDR'="" s PersonDegreeDR=a.PersonDegreeDR.Code //学位
 	..e  s PersonDegreeDR=""
 	..i a.PersonPostTyp'="" s PersonPostTyp=a.PersonPostTyp.Code //工作科室
 	..e  s PersonPostTyp=""
 	..i a.PersonBattery'="" s PersonBattery=a.PersonBattery.Code //护士层级
 	..s PersonBattery=""
 	..i a.PersonNurTyp'="" s PersonNurTyp=a.PersonNurTyp.Code //护士种类
 	..e  s PersonNurTyp=""
 	..s PersonWorkType=a.PersonWorkType //工作类别
 	..i a.PersonCareDate'="" s PersonCareDate=$ZD(a.PersonCareDate,3) //参加护理工作时间
 	..e  s PersonCareDate=""
 	..i a.PersonTeachPostDR'="" s PersonTeachPostDR=a.PersonTeachPostDR.Code //教学职称
 	..e  s PersonTeachPostDR=""
 	..i a.PersonProfPostDR'="" s PersonProfPostDR=a.PersonProfPostDR.Code //专业技术职称
 	..e  s PersonProfPostDR=""
 	..i a.PersonTechPostDate'="" s PersonTechPostDate=$ZD(a.PersonTechPostDate,3) //职称时间
 	..e  s PersonTechPostDate=""
 	..i a.PersonAppDutyDR'="" s PersonAppDutyDR=a.PersonAppDutyDR.Code //聘任职称
 	..e  s PersonAppDutyDR=""
 	..i a.PersonHosEngageDate'="" s PersonHosEngageDate=$ZD(a.PersonHosEngageDate,3) //职称聘任时间
 	..e  s PersonHosEngageDate=""
 	..i a.PersonheadshipDR'="" s PersonheadshipDR=a.PersonheadshipDR.Code //职务
 	..e  s PersonheadshipDR=""
 	..i a.PersonNurHeadDate'="" s PersonNurHeadDate=$ZD(a.PersonNurHeadDate,3) //护士长任职时间
 	..e  s PersonNurHeadDate=""
 	..;b ;11
  	..//s ret="^PersonName|"_PersonName_"^PersonID|"_PersonID_"^PersonSexDR|"_PersonSexDR_"^PersonBirthDay|"_PersonBirthDay_"^PersonDepDR|"_PersonDepDR_"^PersonTransDate|"_PersonTransDate_"^Personmarriage|"_Personmarriage_"^PersonWorkDateTime|"_PersonWorkDateTime_"^PersonTelHand|"_PersonTelHand_"^PersonNativePlaceDR|"_PersonNativePlaceDR_"^PersonIdentity|"_PersonIdentity_"^Personpeopledr|"_Personpeopledr_"^PersonPolitydr|"_PersonPolitydr_"^PersonSchoolAgeDr|"_PersonSchoolAgeDr_"^PersonDegreeDR|"_PersonDegreeDR_"^PersonPostTyp|"_PersonPostTyp_"^PersonBattery|"_PersonBattery_"^PersonNurTyp|"_PersonNurTyp_"^PersonWorkType|"_PersonWorkType_"^PersonCareDate|"_PersonCareDate_"^PersonTeachPostDR|"_PersonTeachPostDR_"^PersonProfPostDR|"_PersonProfPostDR_"^PersonTechPostDate|"_PersonTechPostDate_"^PersonAppDutyDR|"_PersonAppDutyDR_"^PersonHosEngageDate|"_PersonHosEngageDate_"^PersonheadshipDR|"_PersonheadshipDR_"^PersonNurHeadDate|"_PersonNurHeadDate
 	..//b ;10
 	..s Personcout=Personcout+1
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(Personcout,PersonName,PersonID,PersonSexDR,PersonBirthDay,PersonDepDR,PersonTransDate,Personmarriage,PersonWorkDateTime,PersonTelHand,PersonNativePlaceDR,PersonIdentity,Personpeopledr,PersonPolitydr,PersonSchoolAgeDr,PersonDegreeDR,PersonPostTyp,PersonBattery,PersonNurTyp,PersonWorkType,PersonCareDate,PersonTeachPostDR,PersonProfPostDR,PersonTechPostDate,PersonAppDutyDR,PersonHosEngageDate,PersonheadshipDR,PersonNurHeadDate)
	Set ^CacheTemp(repid,ind)=Data
 	//Set ^CacheTemptest(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchPersonAgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPersonAgeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else {			
	 Set Row=^CacheTemp(repid,ind)
	}
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchPersonAgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPersonAgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

/// 按护士层级查询
Query SearchNurBattery(NurBattery As %String) As %Query(ROWSPEC = "PersonName,PersonID,PersonSexDR,PersonBattery,PersonBirthDay,PersonDepDR,PersonTransDate,Personmarriage,PersonWorkDateTime,PersonTelHand,PersonNativePlaceDR,PersonIdentity,Personpeopledr,PersonPolitydr,PersonSchoolAgeDr,PersonDegreeDR,PersonPostTyp,PersonNurTyp,PersonWorkType,PersonCareDate,PersonTeachPostDR,PersonProfPostDR,PersonTechPostDate,PersonAppDutyDR,PersonHosEngageDate,PersonheadshipDR,PersonNurHeadDate")
{
}

ClassMethod SearchNurBatteryExecute(ByRef qHandle As %Binary, NurBattery As %String) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatistic","SearchNurBattery","N1")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s NurBattery=$G(NurBattery)
 	s NurBattery=$ZConvert(NurBattery,"U")
 	i NurBattery="N1" s NurBattery="12||1"
 	i NurBattery="N2" s NurBattery="12||2"
 	i NurBattery="N3" s NurBattery="12||3"
 	i NurBattery="N4" s NurBattery="12||4"
 	i NurBattery="N5" s NurBattery="12||5"
 	s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SBattery",NurBattery,id)) q:id=""  d
 	.s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	.s PersonName=a.PersonName //姓名
 	.s PersonID=a.PersonID //工号
 	.i a.PersonSexDR="1" s PersonSexDR="男" //性别
 	.i a.PersonSexDR="2"  s PersonSexDR="女"
 	.i a.PersonBattery'="" s PersonBattery=a.PersonBattery.Code //护士层级
 	.e  s PersonBattery=""
 	.;i a.PersonBirthDay'="" s PersonBirthDay=$ZD(a.PersonBirthDay,3) //出生日期
 	.;e  s PersonBirthDay=""
 	.i a.PersonBirthDay'="" s PersonBirthDay=$P(..CalAge(a.PersonBirthDay,+$H),"Y",1) //_"岁" //年龄
 	.;b ;10
 	.e  s PersonBirthDay=""
 	.i (a.PersonDepDR'="")&&(a.PersonDepDR'="9999") s PersonDepDR=$p(^CTLOC(a.PersonDepDR),"^",2) //护理单元
	.i a.PersonDepDR="9999" s PersonDepDR="护士"
	.i a.PersonDepDR="" s PersonDepDR=""
	.i a.PersonTransDate'="" s PersonTransDate=$ZD(a.PersonTransDate,3) //调入科室时间
	.e  s PersonTransDate=""
 	.i a.Personmarriage="1" s Personmarriage="未婚" //婚姻
 	.i a.Personmarriage="2" s Personmarriage="已婚"
 	.i a.Personmarriage="3" s Personmarriage="离婚"
 	.i a.PersonWorkDateTime'="" s PersonWorkDateTime=$ZD(a.PersonWorkDateTime,3) //参加工作时间
 	.e  s PersonWorkDateTime=""
 	.s PersonTelHand=a.PersonTelHand //手机
 	.s PersonNativePlaceDR=a.PersonNativePlaceDR //籍贯
 	.s PersonIdentity=a.PersonIdentity //身份证
 	.s Personpeopledr=a.Personpeopledr.Code //民族
 	.i a.PersonPolitydr'="" s PersonPolitydr=a.PersonPolitydr.Code //政治面貌
 	.e  s PersonPolitydr=""
 	.i a.PersonSchoolAgeDr'="" s PersonSchoolAgeDr=a.PersonSchoolAgeDr.Code //学历
 	.e  s PersonSchoolAgeDr=""
 	.i a.PersonDegreeDR'="" s PersonDegreeDR=a.PersonDegreeDR.Code //学位
 	.e  s PersonDegreeDR=""
 	.i a.PersonPostTyp'="" s PersonPostTyp=a.PersonPostTyp.Code //工作科室
 	.e  s PersonPostTyp=""
 	.i a.PersonNurTyp'="" s PersonNurTyp=a.PersonNurTyp.Code //护士种类
 	.e  s PersonNurTyp=""
 	.s PersonWorkType=a.PersonWorkType //工作类别
 	.i a.PersonCareDate'="" s PersonCareDate=$ZD(a.PersonCareDate,3) //参加护理工作时间
 	.e  s PersonCareDate=""
 	.i a.PersonTeachPostDR'="" s PersonTeachPostDR=a.PersonTeachPostDR.Code //教学职称
 	.e  s PersonTeachPostDR=""
 	.i a.PersonProfPostDR'="" s PersonProfPostDR=a.PersonProfPostDR.Code //专业技术职称
 	.e  s PersonProfPostDR=""
 	.i a.PersonTechPostDate'="" s PersonTechPostDate=$ZD(a.PersonTechPostDate,3) //职称时间
 	.e  s PersonTechPostDate=""
 	.i a.PersonAppDutyDR'="" s PersonAppDutyDR=a.PersonAppDutyDR.Code //聘任职称
 	.e  s PersonAppDutyDR=""
 	.i a.PersonHosEngageDate'="" s PersonHosEngageDate=$ZD(a.PersonHosEngageDate,3) //职称聘任时间
 	.e  s PersonHosEngageDate=""
 	.i a.PersonheadshipDR'="" s PersonheadshipDR=a.PersonheadshipDR //职务
 	.e  s PersonheadshipDR=""
 	.i a.PersonNurHeadDate'="" s PersonNurHeadDate=$ZD(a.PersonNurHeadDate,3) //护士长任职时间
 	.e  s PersonNurHeadDate=""
 	.;b ;11
 	.;s ret="^PersonName|"_PersonName_"^PersonID|"_PersonID_"^PersonSexDR|"_PersonSexDR_"^PersonBirthDay|"_PersonBirthDay_"^PersonDepDR|"_PersonDepDR_"^PersonTransDate|"_PersonTransDate_"^Personmarriage|"_Personmarriage_"^PersonWorkDateTime|"_PersonWorkDateTime_"^PersonTelHand|"_PersonTelHand_"^PersonNativePlaceDR|"_PersonNativePlaceDR_"^PersonIdentity|"_PersonIdentity_"^Personpeopledr|"_Personpeopledr_"^PersonPolitydr|"_PersonPolitydr_"^PersonSchoolAgeDr|"_PersonSchoolAgeDr_"^PersonDegreeDR|"_PersonDegreeDR_"^PersonPostTyp|"_PersonPostTyp_"^PersonBattery|"_PersonBattery_"^PersonNurTyp|"_PersonNurTyp_"^PersonWorkType|"_PersonWorkType_"^PersonCareDate|"_PersonCareDate_"^PersonTeachPostDR|"_PersonTeachPostDR_"^PersonProfPostDR|"_PersonProfPostDR_"^PersonTechPostDate|"_PersonTechPostDate_"^PersonAppDutyDR|"_PersonAppDutyDR_"^PersonHosEngageDate|"_PersonHosEngageDate_"^PersonheadshipDR|"_PersonheadshipDR_"^PersonNurHeadDate|"_PersonNurHeadDate
 	.;b ;10
 	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonName,PersonID,PersonSexDR,PersonBattery,PersonBirthDay,PersonDepDR,PersonTransDate,Personmarriage,PersonWorkDateTime,PersonTelHand,PersonNativePlaceDR,PersonIdentity,Personpeopledr,PersonPolitydr,PersonSchoolAgeDr,PersonDegreeDR,PersonPostTyp,PersonNurTyp,PersonWorkType,PersonCareDate,PersonTeachPostDR,PersonProfPostDR,PersonTechPostDate,PersonAppDutyDR,PersonHosEngageDate,PersonheadshipDR,PersonNurHeadDate)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchNurBatteryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNurBatteryExecute ]
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

ClassMethod SearchNurBatteryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNurBatteryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 按专业技术职称查询
Query SearchPersonProfPostDR(ProfPostDRString As %String) As %Query(ROWSPEC = "PersonName,PersonID,PersonSexDR,PersonProfPostDR,PersonTechPostDate,PersonBirthDay,PersonDepDR,PersonTransDate,Personmarriage,PersonWorkDateTime,PersonTelHand,PersonNativePlaceDR,PersonIdentity,Personpeopledr,PersonPolitydr,PersonSchoolAgeDr,PersonDegreeDR,PersonPostTyp,PersonBattery,PersonNurTyp,PersonWorkType,PersonCareDate,PersonTeachPostDR,PersonAppDutyDR,PersonHosEngageDate,PersonheadshipDR,PersonNurHeadDate")
{
}

ClassMethod SearchPersonProfPostDRExecute(ByRef qHandle As %Binary, ProfPostDRString As %String) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatistic","SearchPersonProfPostDR","护师")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	q:ProfPostDRString=""
 	s str="聘任专业技术职称"
 	s rw="" f  s rw=$O(^DHCMGNUR.CommDictionaryI("Code"," "_str,rw)) q:rw=""  d
 	.s rid="" f  s rid=$O(^DHCMGNUR.CommDictionarySubI("Code"," "_ProfPostDRString,rw,rid)) q:rid=""  d
 	..s mid=rw_"||"_rid
 	..s id="" 
 	..f  s id=$O(^DHCMGNUR.MgPersonsI("SProfPostDR",mid,id)) q:id=""  d
 	...;b ;110
 	...s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
 	...s PersonName=a.PersonName //姓名
 	...s PersonID=a.PersonID //工号
 	...i a.PersonSexDR="1" s PersonSexDR="男" //性别
 	...i a.PersonSexDR="2"  s PersonSexDR="女"
 	...i a.PersonBattery'="" s PersonBattery=a.PersonBattery.Code //护士层级
 	...s PersonBattery=""
 	...;i a.PersonBirthDay'="" s PersonBirthDay=$ZD(a.PersonBirthDay,3) //出生日期
 	...;e  s PersonBirthDay=""
 	...i a.PersonBirthDay'="" s PersonBirthDay=$P(..CalAge(a.PersonBirthDay,+$H),"Y",1) //_"岁" //年龄
 	...;b ;10
 	...e  s PersonBirthDay=""
 	...i (a.PersonDepDR'="")&&(a.PersonDepDR'="9999") s PersonDepDR=$p(^CTLOC(a.PersonDepDR),"^",2) //护理单元
	...i a.PersonDepDR="9999" s PersonDepDR="护士"
	...i a.PersonDepDR="" s PersonDepDR=""
	...i a.PersonTransDate'="" s PersonTransDate=$ZD(a.PersonTransDate,3) //调入科室时间
	...e  s PersonTransDate=""
 	...i a.Personmarriage="1" s Personmarriage="未婚" //婚姻
 	...i a.Personmarriage="2" s Personmarriage="已婚"
 	...i a.Personmarriage="3" s Personmarriage="离婚"
 	...i a.PersonWorkDateTime'="" s PersonWorkDateTime=$ZD(a.PersonWorkDateTime,3) //参加工作时间
 	...e  s PersonWorkDateTime=""
 	...s PersonTelHand=a.PersonTelHand //手机
 	...s PersonNativePlaceDR=a.PersonNativePlaceDR //籍贯
 	...s PersonIdentity=a.PersonIdentity //身份证
 	...s Personpeopledr=a.Personpeopledr.Code //民族
 	...i a.PersonPolitydr'="" s PersonPolitydr=a.PersonPolitydr.Code //政治面貌
 	...e  s PersonPolitydr=""
 	...i a.PersonSchoolAgeDr'="" s PersonSchoolAgeDr=a.PersonSchoolAgeDr.Code //学历
 	...e  s PersonSchoolAgeDr=""
 	...i a.PersonDegreeDR'="" s PersonDegreeDR=a.PersonDegreeDR.Code //学位
 	...e  s PersonDegreeDR=""
 	...i a.PersonPostTyp'="" s PersonPostTyp=a.PersonPostTyp.Code //工作科室
 	...e  s PersonPostTyp=""
 	...i a.PersonNurTyp'="" s PersonNurTyp=a.PersonNurTyp.Code //护士种类
 	...e  s PersonNurTyp=""
 	...s PersonWorkType=a.PersonWorkType //工作类别
 	...i a.PersonCareDate'="" s PersonCareDate=$ZD(a.PersonCareDate,3) //参加护理工作时间
 	...e  s PersonCareDate=""
 	...i a.PersonTeachPostDR'="" s PersonTeachPostDR=a.PersonTeachPostDR.Code //教学职称
 	...e  s PersonTeachPostDR=""
 	...i a.PersonProfPostDR'="" s PersonProfPostDR=a.PersonProfPostDR.Code //专业技术职称
 	...e  s PersonProfPostDR=""
 	...i a.PersonTechPostDate'="" s PersonTechPostDate=$ZD(a.PersonTechPostDate,3) //职称时间
 	...e  s PersonTechPostDate=""
 	...i a.PersonAppDutyDR'="" s PersonAppDutyDR=a.PersonAppDutyDR.Code //聘任职称
 	...e  s PersonAppDutyDR=""
 	...i a.PersonHosEngageDate'="" s PersonHosEngageDate=$ZD(a.PersonHosEngageDate,3) //职称聘任时间
 	...e  s PersonHosEngageDate=""
 	...i a.PersonheadshipDR'="" s PersonheadshipDR=a.PersonheadshipDR //职务
 	...e  s PersonheadshipDR=""
 	...i a.PersonNurHeadDate'="" s PersonNurHeadDate=$ZD(a.PersonNurHeadDate,3) //护士长任职时间
 	...e  s PersonNurHeadDate=""
 	...;b ;11
 	...;s ret="^PersonName|"_PersonName_"^PersonID|"_PersonID_"^PersonSexDR|"_PersonSexDR_"^PersonBirthDay|"_PersonBirthDay_"^PersonDepDR|"_PersonDepDR_"^PersonTransDate|"_PersonTransDate_"^Personmarriage|"_Personmarriage_"^PersonWorkDateTime|"_PersonWorkDateTime_"^PersonTelHand|"_PersonTelHand_"^PersonNativePlaceDR|"_PersonNativePlaceDR_"^PersonIdentity|"_PersonIdentity_"^Personpeopledr|"_Personpeopledr_"^PersonPolitydr|"_PersonPolitydr_"^PersonSchoolAgeDr|"_PersonSchoolAgeDr_"^PersonDegreeDR|"_PersonDegreeDR_"^PersonPostTyp|"_PersonPostTyp_"^PersonBattery|"_PersonBattery_"^PersonNurTyp|"_PersonNurTyp_"^PersonWorkType|"_PersonWorkType_"^PersonCareDate|"_PersonCareDate_"^PersonTeachPostDR|"_PersonTeachPostDR_"^PersonProfPostDR|"_PersonProfPostDR_"^PersonTechPostDate|"_PersonTechPostDate_"^PersonAppDutyDR|"_PersonAppDutyDR_"^PersonHosEngageDate|"_PersonHosEngageDate_"^PersonheadshipDR|"_PersonheadshipDR_"^PersonNurHeadDate|"_PersonNurHeadDate
 	...;b ;10
 	...d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(PersonName,PersonID,PersonSexDR,PersonProfPostDR,PersonTechPostDate,PersonBirthDay,PersonDepDR,PersonTransDate,Personmarriage,PersonWorkDateTime,PersonTelHand,PersonNativePlaceDR,PersonIdentity,Personpeopledr,PersonPolitydr,PersonSchoolAgeDr,PersonDegreeDR,PersonPostTyp,PersonBattery,PersonNurTyp,PersonWorkType,PersonCareDate,PersonTeachPostDR,PersonAppDutyDR,PersonHosEngageDate,PersonheadshipDR,PersonNurHeadDate)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchPersonProfPostDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPersonProfPostDRExecute ]
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

ClassMethod SearchPersonProfPostDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPersonProfPostDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

}
