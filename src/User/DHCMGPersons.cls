Class User.DHCMGPersons Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_Persons ]
{

Parameter EXTENTSIZE = 250;

/// Person_SS_DR
Property PersonSSDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Person_SS_DR ];

/// Person_RegNo
Property PersonRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Person_RegNo ];

/// Person_ID
Property PersonID As %Library.String(TRUNCATE = 1) [ SqlFieldName = Person_ID ];

/// Person_Name
Property PersonName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Person_Name ];

/// Person_Sex_DR
Property PersonSexDR As %String(TRUNCATE = 1) [ SqlFieldName = Person_Sex_DR ];

/// Person_BirthDay
Property PersonBirthDay As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = Person_BirthDay ];

/// Person_marriage
Property Personmarriage As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Person_marriage ];

/// Person_ProfPost_DR
Property PersonProfPostDR As User.DHCMGCPostCode [ SqlColumnNumber = 9, SqlFieldName = Person_ProfPost_DR ];

/// Person_TeachPost_DR
Property PersonTeachPostDR As User.DHCMGCPostCode [ SqlColumnNumber = 10, SqlFieldName = Person_TeachPost_DR ];

/// Person_Mentor_DR
Property PersonMentorDR As User.DHCMGCPostCode [ SqlColumnNumber = 11, SqlFieldName = Person_Mentor_DR ];

/// Person_WorkDateTime
Property PersonWorkDateTime As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = Person_WorkDateTime ];

/// Person_Typ
Property PersonTyp As %Library.String(DISPLAYLIST = ",Doctor,Nurse,Worker", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,N,W") [ SqlColumnNumber = 13, SqlFieldName = Person_Typ ];

/// Person_TelHome
Property PersonTelHome As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = Person_TelHome ];

/// Person_TelHand
Property PersonTelHand As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = Person_TelHand ];

/// Person_Address
Property PersonAddress As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = Person_Address ];

/// Person_NativePlace_DR
Property PersonNativePlaceDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = Person_NativePlace_DR ];

/// Person_Dep_DR
Property PersonDepDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = Person_Dep_DR ];

/// Person_IFFullTime
Property PersonIFFullTime As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = Person_IFFullTime ];

/// Person_FromDate
Property PersonFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = Person_FromDate ];

/// Person_EndDate
Property PersonEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = Person_EndDate ];

/// Person_AppDuty_DR
Property PersonAppDutyDR As User.DHCMGCPostCode [ SqlColumnNumber = 22, SqlFieldName = Person_AppDuty_DR ];

/// Person_headship_DR
Property PersonheadshipDR As User.DHCMGCPostCode [ SqlColumnNumber = 23, SqlFieldName = Person_headship_DR ];

/// Person_Identity
Property PersonIdentity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = Person_Identity ];

/// Person_people_dr
Property Personpeopledr As User.DHCMGCCode [ SqlColumnNumber = 25, SqlFieldName = Person_people_dr ];

/// Person_Polity_dr
Property PersonPolitydr As User.DHCMGCCode [ SqlColumnNumber = 26, SqlFieldName = Person_Polity_dr ];

/// Person_SchoolAge_Dr
Property PersonSchoolAgeDr As User.DHCMGCCode [ SqlColumnNumber = 27, SqlFieldName = Person_SchoolAge_Dr ];

/// Person_Degree_DR
Property PersonDegreeDR As User.DHCMGCCode [ SqlColumnNumber = 28, SqlFieldName = Person_Degree_DR ];

/// Person_GraduateDate
Property PersonGraduateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = Person_GraduateDate ];

/// Person_GraduateSchool
Property PersonGraduateSchool As User.DHCMGCCode [ SqlColumnNumber = 30, SqlFieldName = Person_GraduateSchool ];

/// Person_NurTyp
Property PersonNurTyp As User.DHCMGCCode [ SqlColumnNumber = 31, SqlFieldName = Person_NurTyp ];

/// Person_NurseQualDate
Property PersonNurseQualDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = Person_NurseQualDate ];

/// Person_Language
Property PersonLanguage As User.DHCMGCCode [ SqlColumnNumber = 33, SqlFieldName = Person_Language ];

/// Person_AdmHosDate
Property PersonAdmHosDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 34, SqlFieldName = Person_AdmHosDate ];

/// Person_RetireDate
Property PersonRetireDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = Person_RetireDate ];

/// Person_PrefQual
Property PersonPrefQual As User.DHCMGCCode [ SqlColumnNumber = 36, SqlFieldName = Person_PrefQual ];

/// Person_PrefQualDate
Property PersonPrefQualDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = Person_PrefQualDate ];

/// Person_TechPostDate
Property PersonTechPostDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 38, SqlFieldName = Person_TechPostDate ];

/// Person_HosEngageDate
Property PersonHosEngageDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = Person_HosEngageDate ];

/// Person_EngageMth
Property PersonEngageMth As User.DHCMGCCode [ SqlColumnNumber = 40, SqlFieldName = Person_EngageMth ];

/// PersonEngageDate
Property PersonEngageDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 41, SqlFieldName = Person_EngageDate ];

/// Person_PostTyp
Property PersonPostTyp As User.DHCMGCCode [ SqlColumnNumber = 42, SqlFieldName = Person_PostTyp ];

/// Person_EnterDepDate
Property PersonEnterDepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 43, SqlFieldName = Person_EnterDepDate ];

//临时科室

Property PersonTempDepDR As %Library.String(TRUNCATE = 1) [ SqlFieldName = Person_TempDep_DR ];

Property PersonCatg As %Library.String(TRUNCATE = 1) [ SqlFieldName = Person_Catg_DR ];

//工资号

Property PersonWageNo As %Library.String(TRUNCATE = 1) [ SqlFieldName = Person_WageNo ];

//是否二次学历

Property PersonSecEdu As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = Person_SecEdu ];

//所学专业

Property PersonProfession As User.DHCMGCCode [ SqlFieldName = Person_Profession ];

//离开机构

Property PersonLeaveUnit As %Library.String(TRUNCATE = 1) [ SqlFieldName = Person_LeaveUnit ];

// Person_AppdutyDate

Property PersonAppdutyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = Person_AppdutyDate ];

// Person_TeachHolidayFlag

Property PersonTeachHolidayFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = Person_TeachHolidayFlag ];

/// Person_PresentZipCode 现住址邮编
Property PersonPresentZipCode As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = Person_PresentZipCode ];

/// Person_HouseholdAdd 户籍地址
Property PersonHouseholdAdd As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = Person_HouseholdAdd ];

/// Person_HouseZipCode 户籍邮编
Property PersonHouseZipCode As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = Person_HouseZipCode ];

// Person_CareDate  参加护理工作时间 

Property PersonCareDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 49, SqlFieldName = Person_CareDate ];

/// Person_Height 身高
Property PersonHeight As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = Person_Height ];

/// Person_ShoeNO 鞋号
Property PersonShoeNO As User.DHCMGCCode [ SqlColumnNumber = 51, SqlFieldName = Person_ShoeNO ];

/// Person_ClothesNO  白衣号
Property PersonClothesNO As User.DHCMGCCode [ SqlColumnNumber = 52, SqlFieldName = Person_ClothesNO ];

// Person_NurHeadDate  护士长时间 

Property PersonNurHeadDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 53, SqlFieldName = Person_NurHeadDate ];

/// Person_SchoolType
Property PersonSchoolType As User.DHCMGCCode [ SqlColumnNumber = 54, SqlFieldName = Person_SchoolType ];

/// Person_SchoolMedWest
Property PersonSchoolMedWest As User.DHCMGCCode [ SqlColumnNumber = 55, SqlFieldName = Person_SchoolMedWest ];

/// Person_Battery
Property PersonBattery As User.DHCMGCCode [ SqlColumnNumber = 56, SqlFieldName = Person_Battery ];

Index Dep On PersonDepDR;

Index Regno On PersonRegNo [ Unique ];

Index SSDR On PersonSSDR;

Index SSID On PersonID;

Index TempDep On PersonTempDepDR;

Index Catg On PersonCatg;

ClassMethod Insert1(parr As %String) As %String
{
 //s a=##class(User.DHCMGPersons).Insert1()
  //s parr=^t(1)
   //s ^tt345("bb",1)=parr
   //q 12
   //i parr="22" s parr=^tt345("bb",1)
   s parr=$g(parr)
   s ssid=$P(parr,"^",1)
   s name=$P(parr,"^",2)
   //i name="李玲飞" b //5566
   s regno=$P(parr,"^",3)
   s id=$P(parr,"^",4)
   s sex=$P(parr,"^",5)
   s birth=$P(parr,"^",6)
   if birth'=""  s birth=$ZDH(birth,3)
   s marr=$P(parr,"^",7)
   s professpost=$P(parr,"^",8)
   s TeachPost=$P(parr,"^",9)
   s Mentor=$P(parr,"^",10)
   s WorkDateTime=$P(parr,"^",11)
   if WorkDateTime'="" s WorkDateTime=$ZDH(WorkDateTime,3)
   s Typ=$P(parr,"^",12)
   s TelHome=$P(parr,"^",13)
   s TelHand=$P(parr,"^",14)
   s Address=$P(parr,"^",15)
   s NativePl=$P(parr,"^",16)
   s Dep=$P(parr,"^",17)
   s flag=$P(parr,"^",18)
   s RowID=$P(parr,"^",19)
   s datefrom=$P(parr,"^",20)
   s dateend=$P(parr,"^",21)
   s appduty=$P(parr,"^",24)
   s headship=$P(parr,"^",23)
   s identity=$P(parr,"^",22)  //+idcardno+"^"+headship+"^"+appduty ;
   s peple=$P(parr,"^",25)
   s politic =$P(parr,"^",26)
   s schage=$P(parr,"^",27)
   s degree =$P(parr,"^",28)
   s graduate=$P(parr,"^",29)
   if graduate'="" s graduate=$ZDH(graduate,3)
   s shcool =$P(parr,"^",30)
   s language=$P(parr,"^",31)
   s rydate=$P(parr,"^",32)
   if rydate'="" d
   .i $l(rydate,"-")<3 s rydate=rydate_"-1"
   . s rydate=$ZDH(rydate,3)
   s entdep=$P(parr,"^",33)
   if entdep'=""  s entdep=$ZDH(entdep,3)
   s nurtyp=$P(parr,"^",34)
   s nurqualdate =$P(parr,"^",35)
   if nurqualdate'=""  d
   .i $l(nurqualdate,"-")<3 s nurqualdate=nurqualdate_"-1"
   .s nurqualdate=$ZDH(nurqualdate,3)
   s nurpref =$P(parr,"^",36)
   s prefqualdate=$P(parr,"^",37) 
   if prefqualdate'=""  d
   .i $l(prefqualdate,"-")<3 s prefqualdate=prefqualdate_"-1"
   .s prefqualdate=$ZDH(prefqualdate,3)
   s dutydate=$P(parr,"^",38)
   if dutydate'=""  s dutydate=$ZDH(dutydate,3)
   s engdate=$P(parr,"^",39)
   if engdate'="" d
   .i $l(engdate,"-")<3 s engdate=engdate_"-1"
   .s engdate=$ZDH(engdate,3)
   s hosendmth=$P(parr,"^",40)
   s hosengdate =$P(parr,"^",41)
   if hosengdate'="" d
   .i $l(hosengdate,"-")<3 s hosengdate=hosengdate_"-1"
   .s hosengdate=$ZDH(hosengdate,3)
   s posttyp=$P(parr,"^",42) 
   s retiredate=$P(parr,"^",43)
   s pertyp=$P(parr,"^",44)
   s wageno=$P(parr,"^",45) 
   s profession=$P(parr,"^",46) 
   s secedu=$P(parr,"^",47)
   s leaveunit=$P(parr,"^",48)
   s teachHolidayFlag= $P(parr,"^",49)
   s PersonPresentZipCode=$P(parr,"^",50)
   s PersonHouseholdAdd=$P(parr,"^",51)
   s PersonHouseZipCode=$P(parr,"^",52)
   s PersonCareDate=$P(parr,"^",53)
   i PersonCareDate'="" s PersonCareDate=$zdh(PersonCareDate,3)
   s PersonHeight=$P(parr,"^",54)

   s PersonShoeNO=$P(parr,"^",55)
   s PersonClothesNO=$P(parr,"^",56)
   s PersonNurHeadDate=$P(parr,"^",57)
   i PersonNurHeadDate'="" s PersonNurHeadDate=$zdh(PersonNurHeadDate,3)
   i PersonNurHeadDate=+$h s PersonNurHeadDate=""
   s PersonBattery=$P(parr,"^",58)
   
   if retiredate'="" d
   .i $l(retiredate,"-")<3 s retiredate=retiredate_"-1"
   .s retiredate=$ZDH(retiredate,3)
   if datefrom'="" s datefrom=$zdh(datefrom,3)
   if dateend'="" s dateend=$zdh(dateend,3)
   s delArrsortFalg=0
   i RowID'="" d
   .s parrOLD=^User.DHCMGPersonsD(RowID)
   .s DepOLD=$list(parrOLD, 7)
   .i Dep'=DepOLD s delArrsortFalg=1
   i name="李玲飞" b //556677
   ;b //999
   if RowID=""  s a=##class(User.DHCMGPersons).%New()
   e  s a=##class(User.DHCMGPersons).%OpenId(RowID)
   if ssid'="" s a.PersonSSDR=ssid

	/// Person_RegNo
	s a.PersonRegNo=regno
	
	/// Person_ID
	s a.PersonID=id
	
	/// Person_Name
	s a.PersonName=name
	
	/// Person_Sex_DR
	s a.PersonSexDR=sex //##class(User.CTSex).%OpenId(sex)
	
	/// Person_BirthDay
	s a.PersonBirthDay=birth
	
	/// Person_marriage
	s a.Personmarriage=marr //##class(User.CTMarital).%OpenId(marr)
	
	/// Person_ProfPost_DR
	if professpost'="" s a.PersonProfPostDR=##class(User.DHCMGCPostCode).%OpenId(professpost)
	e  s a.PersonProfPostDR=""
	/// Person_TeachPost_DR
	if TeachPost'="" s a.PersonTeachPostDR=##class(User.DHCMGCPostCode).%OpenId(TeachPost)
	e  s a.PersonTeachPostDR=""
	/// Person_Mentor_DR
	if Mentor'="" s a.PersonMentorDR=##class(User.DHCMGCPostCode).%OpenId(Mentor)
	e  s a.PersonMentorDR=""
	/// Person_WorkDateTime
	s a.PersonWorkDateTime=WorkDateTime
	
	/// Person_Typ
	s a.PersonTyp=Typ
	
	s a.PersonCatg=pertyp
	/// Person_TelHome
	s a.PersonTelHome=TelHome
	
	/// Person_TelHand
	s a.PersonTelHand=TelHand
	
	/// Person_Address
	s a.PersonAddress=Address
	
	/// Person_NativePlace_DR
	s a.PersonNativePlaceDR=NativePl  //##class(User.CTNation).%OpenId(NativePl)
	
	/// Person_Dep_DR
	s a.PersonDepDR=Dep //##class(User.CTLoc).%OpenId(Dep)
	
	/// Person_IFFullTime
	s a.PersonIFFullTime=flag
	
	/// Person_FromDate
	s a.PersonFromDate=datefrom
	
	/// Person_EndDate
	s a.PersonEndDate=dateend
	
	/// Person_AppDuty_DR
	if appduty'="" s a.PersonAppDutyDR=##class(User.DHCMGCPostCode).%OpenId(appduty)
	e  s a.PersonAppDutyDR=""
	/// Person_headship_DR
	if posttyp'="" s a.PersonheadshipDR=##class(User.DHCMGCPostCode).%OpenId(headship)
	e  s a.PersonheadshipDR=""
	/// Person_Identity
	s a.PersonIdentity=identity
	
	/// Person_people_dr
	if peple'="" s a.Personpeopledr=##class(User.DHCMGCCode).%OpenId(peple)
	e  s a.Personpeopledr=""
	/// Person_Polity_dr
	if politic'="" s a.PersonPolitydr=##class(User.DHCMGCCode).%OpenId(politic)
	e  s a.PersonPolitydr=""
	/// Person_SchoolAge_Dr
	if schage'="" s a.PersonSchoolAgeDr=##class(User.DHCMGCCode).%OpenId(schage)
	e  s a.PersonSchoolAgeDr=""
	/// Person_Degree_DR
	if degree'="" s a.PersonDegreeDR=##class(User.DHCMGCCode).%OpenId(degree)
	e  s a.PersonDegreeDR=""
	/// Person_GraduateDate
	s a.PersonGraduateDate=graduate
	
	/// Person_GraduateSchool
	if shcool'="" s a.PersonGraduateSchool=##class(User.DHCMGCCode).%OpenId(shcool)
	e  s a.PersonGraduateSchool=""
	/// Person_NurTyp
	//s a.PersonNurTyp=nurtyp
	if nurtyp'="" s a.PersonNurTyp=##class(User.DHCMGCCode).%OpenId(nurtyp)
	e   s a.PersonNurTyp=""
	/// Person_NurseQualDate
	s a.PersonNurseQualDate=nurqualdate
	
	/// Person_Language
	if language'="" s a.PersonLanguage=##class(User.DHCMGCCode).%OpenId(language)
	e  s a.PersonLanguage=""
	/// Person_AdmHosDate
	s a.PersonAdmHosDate=rydate
	
	/// Person_RetireDate
	s a.PersonRetireDate=retiredate
	
	/// Person_PrefQual
	if nurpref'="" s a.PersonPrefQual=##class(User.DHCMGCCode).%OpenId(nurpref)
	e  s a.PersonPrefQual=""
	/// Person_PrefQualDate
	s a.PersonPrefQualDate=prefqualdate
	
	/// Person_TechPostDate
	s a.PersonTechPostDate=dutydate
	
	/// Person_HosEngageDate
	s a.PersonHosEngageDate=hosengdate
	
	/// Person_EngageMth
	if hosendmth'="" s a.PersonEngageMth=##class(User.DHCMGCCode).%OpenId(hosendmth)
	e  s a.PersonEngageMth=""
	/// PersonEngageDate
	s a.PersonEngageDate=engdate
	
	/// Person_PostTyp
	if posttyp'="" s a.PersonPostTyp=##class(User.DHCMGCCode).%OpenId(posttyp)
	e  s a.PersonPostTyp=""
	/// Person_EnterDepDate
	s a.PersonEnterDepDate=entdep
	//工资号
	s a.PersonWageNo=wageno
	//是否二次学历
	s a.PersonSecEdu=secedu
	//专业
	if profession'="" s a.PersonProfession=##class(User.DHCMGCCode).%OpenId(profession)
	e  s a.PersonProfession=""
	//离开机构
	s a.PersonLeaveUnit=leaveunit	
	//是否教学假
	s a.PersonTeachHolidayFlag=teachHolidayFlag	
	
	//现住址邮编
	s a.PersonPresentZipCode=PersonPresentZipCode
	//户籍地址
	s a.PersonHouseholdAdd=PersonHouseholdAdd
	//户籍邮编
	s a.PersonHouseZipCode=PersonHouseZipCode
	//参加护理工作时间
	s a.PersonCareDate=PersonCareDate
	//身高
	s a.PersonHeight=PersonHeight
	//鞋号
	i PersonShoeNO'="" s a.PersonShoeNO=##class(User.DHCMGCCode).%OpenId(PersonShoeNO)
	

	//白衣号
	i PersonClothesNO'="" s a.PersonClothesNO=##class(User.DHCMGCCode).%OpenId(PersonClothesNO)
	s a.PersonNurHeadDate=PersonNurHeadDate
	
	//护士层级
	i PersonBattery'="" s a.PersonBattery=##class(User.DHCMGCCode).%OpenId(PersonBattery)
	e  s a.PersonBattery=""
	;b //9999999
	d a.%Save()
	//b //5
    if RowID'="" s id=RowID
    ;if RowID="" s id=..getid(Dep)
    if RowID="" s id=a.%Id()
  	s parr="^"_id_"^"_Dep_"^"_$ZD(entdep,3)_"^^Y"
    i id'="" s a=##class(User.DHCMGTrans).Save(parr)
    i delArrsortFalg=1 d
    .d ##class(User.DHCMGArrangPerSort).delarrSortByper(RowID)
    .d ##class(User.DHCMGGroupPersons).DelPersonByper(RowID)
  	if RowID="" q id
	q id
}

ClassMethod getworkId(dep, pertyp) As %String
{
 //s a=##class(User.DHCMGPersons).getworkId("102","")
     s a=^User.DHCMGCCodeD(pertyp)
	 s code=$list(a,2)
	 s desc=$list(a,3)
	 s depcode=$P(^CTLOC(dep),"^")
	 s depcode=$E(depcode,0,3)

	// s ptyp=depcode_code  
	 s ptyp=code  
	 s id=" "_ptyp
	 s ln=$l(id)
	 s flag=id
	 s del=flag
	 s preid=""
	 s lb=""
	 s rw="" s rw=$O(^User.DHCMGPersonsD(rw),-1)
	 if rw=""  s lb=ptyp_"0001"
	 e  d 
	 .s rw=rw+1
	 .s lb=ptyp_rw
	 q lb
	 f  s id=$O(^User.DHCMGPersonsI("SSID",id)) q:(id="")!(flag="")  d
	 .s lb=$E(id,0,ln)
	 .if lb'=flag d
	 ..s flag=""
	 .q:flag=""
	 .s preid=id
	 b //00
	 s workerid=""
	 if preid="" s workerid=del_"001"
	 e  s lastlb=(($P(preid,del,2))+1)
	 if workerid'="" q workerid
	 s bl=3-$l(lastlb)
	 b  //
	 for i=1:1:bl
	 {
	    s lastlb="0"_lastlb
	 }
	 if workerid="" s workerid=del_lastlb
	 q $TR(workerid," ")
}

ClassMethod setTempDep(personid As %String, tempdep As %String) As %String
{
 //设置临时科室
   s a=##class(User.DHCMGPersons).%OpenId(personid)
   s a.PersonTempDepDR=tempdep
   d a.%Save()
   q 0
}

ClassMethod getTempDep(personid As %String) As %String
{
 // s a=##class(User.DHCMGPersons).getTempDep
   s a=##class(User.DHCMGPersons).%OpenId(personid)
   s tempdep =a.PersonTempDepDR
   q tempdep
}

ClassMethod getid(dep) As %String
{
  s id="" s id=$O(^User.DHCMGPersonsI("Dep"," "_dep,id),-1)
  q id
}

ClassMethod updateImported(parr As %String) As %String
{
 //s a=##class(User.DHCMGPersons).updateImported()
   s RowID="" f  s RowID=$o(^tmpmgnur("Nur",RowID)) q:RowID=""  d
   .s parr=$g(^tmpmgnur("Nur",RowID))
   .s sex=$P(parr,"^",1)              //性别
   .s peple=$P(parr,"^",2)           //民族
   .s politic=$P(parr,"^",3)         //政治面貌
   .s rydate=$P(parr,"^",4)
   .if rydate'="" d
   .. s rydate=$ZDH(rydate,3)        //来院时间
   .s headship=$P(parr,"^",5)        ////职务
   .s hosengdate =$P(parr,"^",6)
   .if hosengdate'="" d
   ..s hosengdate=$ZDH(hosengdate,3)   //院内聘任日期
   .s hosendmth=19              //院内聘任方式
   .s appduty=$P(parr,"^",7)     //聘任职称
   
   .s graduate=$P(parr,"^",8)                   //毕业时间
   .if graduate'="" s graduate=$ZDH(graduate,3)   
   .s degree =$P(parr,"^",9)

   .s a=##class(User.DHCMGPersons).%OpenId(RowID)
   .s a.PersonSexDR=sex                         //性别
   ./// Person_people_dr
	.if peple'="" s a.Personpeopledr=##class(User.DHCMGCCode).%OpenId(peple)  
	.e  s a.Personpeopledr=""                  //民族
	./// Person_Polity_dr
	.if politic'="" s a.PersonPolitydr=##class(User.DHCMGCCode).%OpenId(politic)
	.e  s a.PersonPolitydr=""                  //政治面貌
	./// Person_AdmHosDate
	.s a.PersonAdmHosDate=rydate      //来院时间
	
	.if headship'="" s a.PersonheadshipDR=##class(User.DHCMGCPostCode).%OpenId(headship)
	.e  s a.PersonheadshipDR=""      //职务
	./// Person_HosEngageDate
	.s a.PersonHosEngageDate=hosengdate     //院内聘任日期
    
	./// Person_EngageMth
	.if hosendmth'="" s a.PersonEngageMth=##class(User.DHCMGCCode).%OpenId(hosendmth)
	.e  s a.PersonEngageMth=""                   ////院内聘任方式
	
	./// Person_AppDuty_DR
	.if appduty'="" s a.PersonAppDutyDR=##class(User.DHCMGCPostCode).%OpenId(appduty)
	.e  s a.PersonAppDutyDR=""                    ////聘任职称
	
    .i appduty'="" d
    ..s prom=##class(User.DHCMGPersonPromote).%New()
    ..s prom.PromPerson=(RowID)
    ..s prom.PromDate=hosengdate
    ..s prom.PromTime=$P($h,",",2)
    ..s prom.PromAppProfPosDR=appduty
    ..s prom.PromCurrent="Y"
    ..s recdate=$P($h,",",1)
	..s rectime=$P($h,",",2)
    ..s prom.PromRecDate=recdate
    ..s prom.PromRecTime=rectime
    ..d prom.%Save()
    ./// Person_GraduateDate
	.s a.PersonGraduateDate=graduate	    ////毕业时间
	
	./// Person_Degree_DR
	.if degree'="" s a.PersonDegreeDR=##class(User.DHCMGCCode).%OpenId(degree)
	.e  s a.PersonDegreeDR=""
	.s id=""
	.s id =$o(^User.DHCMGPersonSchoolI("Person"," "_RowID,id),-1)
	.i id'="" d
	..s school=##class(User.DHCMGPersonSchool).%OpenId(id)
    ..s school.SchoolGraduateDate=graduate
    ..i degree'="" s school.SchoolDegreeDR=##class(User.DHCMGCCode).%OpenId(degree)
 	..e  s school.SchoolDegreeDR=""
 	..d school.%Save()
	..d a.%Save()
   
	q 0
}

ClassMethod updateImportedPinren(parr As %String) As %String
{
 //s a=##class(User.DHCMGPersons).updateImportedPinren()
   s RowID=7055 f  s RowID=$o(^tempXHnurschool(RowID)) q:RowID=""  d
   .s hosengdate ="2012-08-06"
   .if hosengdate'="" d
   ..s hosengdate=$ZDH(hosengdate,3)   //院内聘任日期
   .;s hosendmth=19              //院内聘任方式
   .s appduty=10     //聘任职称

   .s a=##class(User.DHCMGPersons).%OpenId(RowID)
	./// Person_HosEngageDate
	.;s a.PersonHosEngageDate=hosengdate     //院内聘任日期
    
	./// Person_EngageMth
	.;if hosendmth'="" s a.PersonEngageMth=##class(User.DHCMGCCode).%OpenId(hosendmth)
	.;e  s a.PersonEngageMth=""                   ////院内聘任方式
	
	./// Person_AppDuty_DR
	.if appduty'="" s a.PersonAppDutyDR=##class(User.DHCMGCPostCode).%OpenId(appduty)
	.e  s a.PersonAppDutyDR=""                    ////聘任职称
	.s a.PersonAppdutyDate=hosengdate
    .i appduty'="" d
    ..s prom=##class(User.DHCMGPersonPromote).%New()
    ..s prom.PromPerson=(RowID)
    ..s prom.PromDate=hosengdate
    ..s prom.PromTime=$P($h,",",2)
    ..s prom.PromAppProfPosDR=appduty
    ..s prom.PromCurrent="Y"
    ..s recdate=$P($h,",",1)
	..s rectime=$P($h,",",2)
    ..s prom.PromRecDate=recdate
    ..s prom.PromRecTime=rectime
    ..d prom.%Save()
    .;b //5
    .d a.%Save()
    .;b
	q 0
}

ClassMethod Delid(rw) As %String
{

   d ##class(User.DHCMGPersons).%DeleteId(rw)
   q 0
}

Storage Default
{
<Data name="DHCMGPersonsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonAddress</Value>
</Value>
<Value name="3">
<Value>PersonAdmHosDate</Value>
</Value>
<Value name="4">
<Value>PersonAppDutyDR</Value>
</Value>
<Value name="5">
<Value>PersonBirthDay</Value>
</Value>
<Value name="6">
<Value>PersonDegreeDR</Value>
</Value>
<Value name="7">
<Value>PersonDepDR</Value>
</Value>
<Value name="8">
<Value>PersonEndDate</Value>
</Value>
<Value name="9">
<Value>PersonEngageDate</Value>
</Value>
<Value name="10">
<Value>PersonEngageMth</Value>
</Value>
<Value name="11">
<Value>PersonEnterDepDate</Value>
</Value>
<Value name="12">
<Value>PersonFromDate</Value>
</Value>
<Value name="13">
<Value>PersonGraduateDate</Value>
</Value>
<Value name="14">
<Value>PersonGraduateSchool</Value>
</Value>
<Value name="15">
<Value>PersonHosEngageDate</Value>
</Value>
<Value name="16">
<Value>PersonID</Value>
</Value>
<Value name="17">
<Value>PersonIFFullTime</Value>
</Value>
<Value name="18">
<Value>PersonIdentity</Value>
</Value>
<Value name="19">
<Value>PersonLanguage</Value>
</Value>
<Value name="20">
<Value>PersonMentorDR</Value>
</Value>
<Value name="21">
<Value>PersonName</Value>
</Value>
<Value name="22">
<Value>PersonNativePlaceDR</Value>
</Value>
<Value name="23">
<Value>PersonNurTyp</Value>
</Value>
<Value name="24">
<Value>PersonNurseQualDate</Value>
</Value>
<Value name="25">
<Value>PersonPolitydr</Value>
</Value>
<Value name="26">
<Value>PersonPostTyp</Value>
</Value>
<Value name="27">
<Value>PersonPrefQual</Value>
</Value>
<Value name="28">
<Value>PersonPrefQualDate</Value>
</Value>
<Value name="29">
<Value>PersonProfPostDR</Value>
</Value>
<Value name="30">
<Value>PersonRegNo</Value>
</Value>
<Value name="31">
<Value>PersonRetireDate</Value>
</Value>
<Value name="32">
<Value>PersonSSDR</Value>
</Value>
<Value name="33">
<Value>PersonSchoolAgeDr</Value>
</Value>
<Value name="34">
<Value>PersonSexDR</Value>
</Value>
<Value name="35">
<Value>PersonTeachPostDR</Value>
</Value>
<Value name="36">
<Value>PersonTechPostDate</Value>
</Value>
<Value name="37">
<Value>PersonTelHand</Value>
</Value>
<Value name="38">
<Value>PersonTelHome</Value>
</Value>
<Value name="39">
<Value>PersonTyp</Value>
</Value>
<Value name="40">
<Value>PersonWorkDateTime</Value>
</Value>
<Value name="41">
<Value>PersonheadshipDR</Value>
</Value>
<Value name="42">
<Value>Personmarriage</Value>
</Value>
<Value name="43">
<Value>Personpeopledr</Value>
</Value>
<Value name="44">
<Value>PersonTempDepDR</Value>
</Value>
<Value name="45">
<Value>PersonCatg</Value>
</Value>
<Value name="46">
<Value>PersonProfession</Value>
</Value>
<Value name="47">
<Value>PersonSecEdu</Value>
</Value>
<Value name="48">
<Value>PersonWageNo</Value>
</Value>
<Value name="49">
<Value>PersonLeaveUnit</Value>
</Value>
<Value name="50">
<Value>PersonAppdutyDate</Value>
</Value>
<Value name="51">
<Value>PersonTeachHolidayFlag</Value>
</Value>
<Value name="52">
<Value>PersonPresentZipCode</Value>
</Value>
<Value name="53">
<Value>PersonHouseholdAdd</Value>
</Value>
<Value name="54">
<Value>PersonHouseZipCode</Value>
</Value>
<Value name="55">
<Value>PersonCareDate</Value>
</Value>
<Value name="56">
<Value>PersonHeight</Value>
</Value>
<Value name="57">
<Value>PersonShoeNO</Value>
</Value>
<Value name="58">
<Value>PersonClothesNO</Value>
</Value>
<Value name="59">
<Value>PersonNurHeadDate</Value>
</Value>
<Value name="60">
<Value>PersonSchoolType</Value>
</Value>
<Value name="61">
<Value>PersonSchoolMedWest</Value>
</Value>
<Value name="62">
<Value>PersonBattery</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonsD</DataLocation>
<DefaultData>DHCMGPersonsDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCMGPersonsD</IdLocation>
<IndexLocation>^User.DHCMGPersonsI</IndexLocation>
<StreamLocation>^User.DHCMGPersonsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
