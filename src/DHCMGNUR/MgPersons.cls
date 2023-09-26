Class DHCMGNUR.MgPersons Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship perLeaExp As DHCMGNUR.MgNurLeaExp [ Cardinality = children, Inverse = LeaExpParref ];

Relationship perEduTra As DHCMGNUR.MgNurEduTra [ Cardinality = children, Inverse = EduTraParref ];

Relationship perRewPun As DHCMGNUR.MgNurRewardPunish [ Cardinality = children, Inverse = RewardPunishParref ];

Relationship perContact As DHCMGNUR.MgNurContact [ Cardinality = children, Inverse = ContactParref ];

Relationship perResThesis As DHCMGNUR.MgNurResThesis [ Cardinality = children, Inverse = ResThesisParref ];

Relationship perHosLearn As DHCMGNUR.MgNurHosBusLearing [ Cardinality = children, Inverse = HosLearnParref ];

Relationship perDepartLearn As DHCMGNUR.MgNurDepartLearning [ Cardinality = children, Inverse = DepartLearnParref ];

Relationship perFamRel As DHCMGNUR.MgNurFamilyRelation [ Cardinality = children, Inverse = FamRelParref ];

Relationship perExamine As DHCMGNUR.MgNurExamine [ Cardinality = children, Inverse = ExamineParref ];

// Relationship perVac As DHCMGNUR.MgNurVacation [ Cardinality = children, Inverse = VacParref ];

Relationship perHoli As DHCMGNUR.MgNurHoliday [ Cardinality = children, Inverse = HoliParref ];

Relationship perChiefPos As DHCMGNUR.MgNurChiefPosition [ Cardinality = children, Inverse = ChiefPosParref ];

Relationship perProTechPos As DHCMGNUR.MgNurProTechPosition [ Cardinality = children, Inverse = ProTechPosParref ];

Relationship perNurseLevel As DHCMGNUR.MgNurNurseLevel [ Cardinality = children, Inverse = NurseLevelParref ];

Relationship perPerBook As DHCMGNUR.MgNurPersonalBook [ Cardinality = children, Inverse = PerBookParref ];

Relationship perDepWork As DHCMGNUR.MgNurDepartmentWork [ Cardinality = children, Inverse = DepWorkParref ];

Relationship perPerEvent As DHCMGNUR.MgNurPersonalEvent [ Cardinality = children, Inverse = PerEventParref ];

Property PersonSSDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Person_SS_DR ];

/// Person_RegNo 注册号
Property PersonRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Person_RegNo ];

/// Person_ID ID
Property PersonID As %Library.String(TRUNCATE = 1) [ SqlFieldName = Person_ID ];

/// Person_Name 姓名
Property PersonName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Person_Name ];

/// Person_Sex_DR 性别
Property PersonSexDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Person_Sex_DR ];

/// Person_BirthDay 出生日期
Property PersonBirthDay As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = Person_BirthDay ];

/// Person_marriage 婚姻
Property Personmarriage As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Person_marriage ];

/// Person_Work_Type 工作类别
Property PersonWorkType As %String(TRUNCATE = 1) [ SqlFieldName = Person_Work_Type ];

/// Person_SchoolMedWest  中西医
Property PersonSchoolMedWest As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 60, SqlFieldName = Person_SchoolMedWest ];

/// Person_ProfPost_DR 专业技术职称
Property PersonProfPostDR As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 9, SqlFieldName = Person_ProfPost_DR ];

/// Person_TeachPost_DR  教学职称
Property PersonTeachPostDR As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 10, SqlFieldName = Person_TeachPost_DR ];

/// Person_Mentor_DR  导师资格
Property PersonMentorDR As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 11, SqlFieldName = Person_Mentor_DR ];

/// Person_WorkDateTime 参加工作时间
Property PersonWorkDateTime As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = Person_WorkDateTime ];

/// Person_Typ 人员类型1(   医生 护士 工作人员)
Property PersonTyp As %Library.String(DISPLAYLIST = ",Doctor,Nurse,Worker", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,N,W") [ SqlColumnNumber = 13, SqlFieldName = Person_Typ ];

/// Person_TelHome 家庭电话
Property PersonTelHome As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = Person_TelHome ];

/// Person_TelHand 手机
Property PersonTelHand As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = Person_TelHand ];

/// Person_Address 现住地址
Property PersonAddress As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = Person_Address ];

/// Person_NativePlace_DR  籍贯
Property PersonNativePlaceDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = Person_NativePlace_DR ];

/// Person_Dep_DR 护理单元
Property PersonDepDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Person_Dep_DR ];

/// Person_IFFullTime
Property PersonIFFullTime As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = Person_IFFullTime ];

/// Person_FromDate
Property PersonFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = Person_FromDate ];

/// Person_EndDate （转归日期）结束时间 退休 离职了
Property PersonEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = Person_EndDate ];

/// Person_AppDuty_DR   聘任职称
Property PersonAppDutyDR As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 21, SqlFieldName = Person_AppDuty_DR ];

/// Person_headship_DR  职务
Property PersonheadshipDR As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 22, SqlFieldName = Person_headship_DR ];

/// Person_Identity 身份证
Property PersonIdentity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = Person_Identity ];

/// Person_people_dr 民族
Property Personpeopledr As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 24, SqlFieldName = Person_people_dr ];

/// Person_Polity_dr 政治面貌
Property PersonPolitydr As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 25, SqlFieldName = Person_Polity_dr ];

/// Person_SchoolAge_Dr 学历
Property PersonSchoolAgeDr As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 26, SqlFieldName = Person_SchoolAge_Dr ];

/// Person_Degree_DR  学位
Property PersonDegreeDR As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 27, SqlFieldName = Person_Degree_DR ];

/// Person_GraduateDate 毕业时间
Property PersonGraduateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = Person_GraduateDate ];

/// Person_GraduateSchool 毕业院校 //DHCMGNUR.CommDictionarySub
Property PersonGraduateSchool As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 29, SqlFieldName = Person_GraduateSchool ];

/// Person_NurTyp  护士种类
Property PersonNurTyp As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 30, SqlFieldName = Person_NurTyp ];

/// Person_NurseQualDate取得执业资格时间
Property PersonNurseQualDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = Person_NurseQualDate ];

/// Person_Language 语言
Property PersonLanguage As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 32, SqlFieldName = Person_Language ];

/// Person_AdmHosDate 来院时间 
Property PersonAdmHosDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = Person_AdmHosDate ];

/// Person_RetireDate 退休时间
Property PersonRetireDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 34, SqlFieldName = Person_RetireDate ];

/// 专科护士标识
Property PersonPrefQualFlag As %Library.String(TRUNCATE = 1) [ SqlFieldName = Person_PrefQual_Flag ];

/// Person_PrefQual  专科护士种类PersonPrefQual
Property PersonPrefQual As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 35, SqlFieldName = Person_PrefQual ];

/// Person_PrefQualDate 取得专科护士资格时间
Property PersonPrefQualDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = Person_PrefQualDate ];

/// Person_TechPostDate 取得职称时间
Property PersonTechPostDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = Person_TechPostDate ];

/// Person_HosEngageDate 职称聘任时间（2013.10.11修改）
Property PersonHosEngageDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 38, SqlFieldName = Person_HosEngageDate ];

/// Person_EngageMth   职务聘任方式
Property PersonEngageMth As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 39, SqlFieldName = Person_EngageMth ];

/// PersonEngageDate 竞聘时间 (2013.10.11修改)
Property PersonEngageDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 40, SqlFieldName = Person_EngageDate ];

/// Person_PostTyp 工作科室
Property PersonPostTyp As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 41, SqlFieldName = Person_PostTyp ];

/// Person_EnterDepDate
Property PersonEnterDepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = Person_EnterDepDate ];

/// 临时科室
Property PersonTempDepDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = Person_TempDep_DR ];

Property PersonCatg As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = Person_Catg_DR ];

/// 工资号
Property PersonWageNo As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = Person_WageNo ];

/// 是否二次学历
Property PersonSecEdu As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = Person_SecEdu ];

/// 所学专业
Property PersonProfession As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 47, SqlFieldName = Person_Profession ];

/// 离开机构
Property PersonLeaveUnit As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = Person_LeaveUnit ];

/// Person_AppdutyDate
Property PersonAppdutyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 49, SqlFieldName = Person_AppdutyDate ];

/// Person_TeachHolidayFlag
Property PersonTeachHolidayFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = Person_TeachHolidayFlag ];

/// Person_PresentZipCode 现住址邮编
Property PersonPresentZipCode As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = Person_PresentZipCode ];

/// Person_HouseholdAdd 户籍地址
Property PersonHouseholdAdd As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = Person_HouseholdAdd ];

/// Person_HouseZipCode 户籍邮编
Property PersonHouseZipCode As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = Person_HouseZipCode ];

/// Person_CareDate  参加护理工作时间
Property PersonCareDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 54, SqlFieldName = Person_CareDate ];

/// 调入科室时间
Property PersonTransDate As %Library.Date(FORMAT = 1) [ SqlFieldName = Person_Trans_Date ];

/// Person_Height 身高
Property PersonHeight As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 55, SqlFieldName = Person_Height ];

/// Person_ShoeNO 鞋号
Property PersonShoeNO As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 56, SqlFieldName = Person_ShoeNO ];

/// Person_ClothesNO  白衣号
Property PersonClothesNO As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 57, SqlFieldName = Person_ClothesNO ];

/// Person_NurHeadDate  护士长时间
Property PersonNurHeadDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 58, SqlFieldName = Person_NurHeadDate ];

/// Person_SchoolType  学校制式
Property PersonSchoolType As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 59, SqlFieldName = Person_SchoolType ];

/// Person_Battery  护士层级
Property PersonBattery As DHCMGNUR.CommDictionarySub [ SqlColumnNumber = 61, SqlFieldName = Person_Battery ];

/// 审核标识
Property PersonFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 62, SqlFieldName = Person_Flag ];

/// 照片
Property PersonImage As %String(MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 63, SqlFieldName = Person_Image ];

/// 护士待调科室
Property PersonTmpDep As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 70, SqlFieldName = Person_TmpDep ];

/// 护士待调科时间
Property PersonTmpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 71, SqlFieldName = Person_TmpDate ];

/// 人员类型2（正式[N]、进修[S]、实习[P]）
Property PersonType2 As %Library.String [ SqlColumnNumber = 72, SqlFieldName = Person_Type2 ];

/// 实习生学校
Property PersonInternSchool As %Library.String [ SqlColumnNumber = 73, SqlFieldName = Person_InternSchool ];

/// 实习生专业
Property PersonInternProf As %Library.String [ SqlColumnNumber = 74, SqlFieldName = Person_InternProf ];

/// 实习生班级
Property PersonInternClass As %Library.String [ SqlColumnNumber = 75, SqlFieldName = Person_InternClass ];

/// 实习、进修开始日期
Property PersonInternStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 76, SqlFieldName = Person_InternStDate ];

/// 实习、进修结束日期
Property PersonInternEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 77, SqlFieldName = Person_InternEndDate ];

/// 实习进修联系地址
Property PersonInternAddress As %Library.String [ SqlColumnNumber = 78, SqlFieldName = Person_InternAddress ];

/// 进修专科
Property PersonStudyPref As %Library.String [ SqlColumnNumber = 79, SqlFieldName = Person_StudyPref ];

/// 进修原工作单位
Property PersonWorkUnit As %Library.String [ SqlColumnNumber = 80, SqlFieldName = Person_WorkUnit ];

/// 工人类型
Property PersonGRType As %Library.String [ SqlColumnNumber = 81, SqlFieldName = Person_GRType ];

Index Dep On PersonDepDR;

Index Regno On PersonRegNo;

Index SSDR On PersonSSDR;

Index SSID On PersonID;

Index TempDep On PersonTempDepDR;

Index Catg On PersonCatg;

Index SSNAME On PersonName;

Index SAge On PersonBirthDay;

Index SRetireDate On PersonRetireDate;

Index SBattery On PersonBattery;

Index SSchoolAgeDr On PersonSchoolAgeDr;

Index SProfPostDR On PersonProfPostDR;

Index PersonFalg On (PersonFlag, PersonID);

Index SDegreeDR On PersonDegreeDR;

Index SNurTyp On PersonNurTyp;

Index SSPerson On (PersonDepDR, PersonWorkDateTime);

Index SType On (PersonType2, PersonID);

ClassMethod Save(parr As %String) As %String
{
	s ^TEMP("g10311228001")=parr
	s parrlen=$l(parr,"^")
	s id=$P($P(parr,"^",1),"|",2)
	i id=""
	{
		s a=##class(DHCMGNUR.MgPersons).%New()
	}
	else
	{
		s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	}
	s a.PersonName=$ZConvert($P($P(parr,"^",2),"|",2),"U")
	s a.PersonBirthDay=$ZDH($P($P(parr,"^",3),"|",2),3)
	s a.PersonAddress=$P($P(parr,"^",4),"|",2)
	s a.PersonSexDR=$P($P(parr,"^",5),"|",2)
	s a.Personmarriage=$P($P(parr,"^",6),"|",2)
	s a.PersonTelHome=$P($P(parr,"^",7),"|",2)
	s a.PersonID=$ZConvert($P($P(parr,"^",8),"|",2),"U")
	s a.PersonTelHand=$P($P(parr,"^",9),"|",2)
	s a.PersonHouseholdAdd=$P($P(parr,"^",10),"|",2)
	s a.PersonIdentity=$P($P(parr,"^",11),"|",2)
	i $P($P(parr,"^",12),"|",2)'="" s a.PersonWorkDateTime=$ZDH($P($P(parr,"^",12),"|",2),3)
	e  s a.PersonWorkDateTime=""
	s a.PersonPresentZipCode=$P($P(parr,"^",13),"|",2)
	s a.PersonNativePlaceDR=$P($P(parr,"^",14),"|",2)
	s a.PersonHeight=$P($P(parr,"^",15),"|",2)
	s a.PersonRegNo=$P($P(parr,"^",16),"|",2)
	s a.PersonHouseZipCode=$P($P(parr,"^",17),"|",2)
	i $P($P(parr,"^",18),"|",2)'="" s a.PersonNurHeadDate=$ZDH($P($P(parr,"^",18),"|",2),3)
	e  s a.PersonNurHeadDate=""
	i $P($P(parr,"^",19),"|",2)'="" s a.PersonheadshipDR=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",19),"|",2),"__","||"))
	e  s a.PersonheadshipDR=""
	i $P($P(parr,"^",20),"|",2)'="" s a.PersonHosEngageDate=$ZDH($P($P(parr,"^",20),"|",2),3)
	e  s a.PersonHosEngageDate=""
	i $P($P(parr,"^",21),"|",2)'="" s a.PersonRetireDate=$ZDH($P($P(parr,"^",21),"|",2),3)
	e  s a.PersonRetireDate=""
	i $P($P(parr,"^",22),"|",2)'="" s a.PersonNurseQualDate=$ZDH($P($P(parr,"^",22),"|",2),3)
	e  s a.PersonNurseQualDate=""
	i $P($P(parr,"^",23),"|",2)'="" s a.PersonPrefQualDate=$ZDH($P($P(parr,"^",23),"|",2),3)
	e  s a.PersonPrefQualDate=""
	s a.PersonDepDR=$P($P(parr,"^",24),"|",2)
	i $P($P(parr,"^",25),"|",2)'="" s a.PersonTechPostDate=$ZDH($P($P(parr,"^",25),"|",2),3)
	e  s a.PersonTechPostDate=""
	i $P($P(parr,"^",26),"|",2)'="" s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",26),"|",2),"__","||"))
	e  s a.Personpeopledr=""
	i $P($P(parr,"^",27),"|",2)'="" s a.PersonPolitydr=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",27),"|",2),"__","||"))
	e  s a.PersonPolitydr=""
	i $P($P(parr,"^",28),"|",2)'="" s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",28),"|",2),"__","||"))
	e  s a.PersonShoeNO=""
	i $P($P(parr,"^",29),"|",2)'="" s a.PersonTeachPostDR=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",29),"|",2),"__","||"))
	e  s a.PersonTeachPostDR=""
	i $P($P(parr,"^",30),"|",2)'="" s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",30),"|",2),"__","||"))
	e  s a.PersonClothesNO=""
	i $P($P(parr,"^",31),"|",2)'="" s a.PersonBattery=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",31),"|",2),"__","||"))
	e  s a.PersonBattery=""
	i $P($P(parr,"^",32),"|",2)'="" s a.PersonMentorDR=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",32),"|",2),"__","||"))
	e  s a.PersonMentorDR=""
	i $P($P(parr,"^",33),"|",2)'="" s a.PersonSchoolType=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",33),"|",2),"__","||"))
	e  s a.PersonSchoolType=""
	i $P($P(parr,"^",34),"|",2)'="" s a.PersonNurTyp=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",34),"|",2),"__","||"))
	e  s a.PersonNurTyp=""
	i $P($P(parr,"^",35),"|",2)'="" s a.PersonPostTyp=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",35),"|",2),"__","||"))
	e  s a.PersonPostTyp=""
	i $P($P(parr,"^",36),"|",2)'="" s a.PersonProfession=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",36),"|",2),"__","||"))
	e  s a.PersonProfession=""
	i $P($P(parr,"^",37),"|",2)'="" s a.PersonSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",37),"|",2),"__","||"))
	e  s a.PersonSchoolAgeDr=""
	i $P($P(parr,"^",38),"|",2)'="" s a.PersonDegreeDR=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",38),"|",2),"__","||"))
	e  s a.PersonDegreeDR=""
	i $P($P(parr,"^",39),"|",2)'="" s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",39),"|",2),"__","||"))
	e  s a.PersonPrefQual=""
	i $P($P(parr,"^",40),"|",2)'="" s a.PersonTransDate=$ZDH($P($P(parr,"^",40),"|",2),3)
	e  s a.PersonTransDate=""
	i $P($P(parr,"^",41),"|",2)'="" s a.PersonAppDutyDR=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",41),"|",2),"__","||"))
	e  s a.PersonAppDutyDR=""
	i $P($P(parr,"^",42),"|",2)'="" s a.PersonGraduateSchool=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",42),"|",2),"__","||"))
	e  s a.PersonGraduateSchool=""
	i $P($P(parr,"^",43),"|",2)'="" s a.PersonProfPostDR=##class(DHCMGNUR.CommDictionarySub).%OpenId($tr($P($P(parr,"^",43),"|",2),"__","||"))
	e  s a.PersonProfPostDR=""
	s a.PersonWorkType=$P($P(parr,"^",44),"|",2)
	s a.PersonImage=$P($P(parr,"^",45),"|",2)
	s a.PersonPrefQualFlag=$P($P(parr,"^",46),"|",2)
	i $P($P(parr,"^",47),"|",2)'="" s a.PersonAdmHosDate=$ZDH($P($P(parr,"^",47),"|",2),3)
	e  s a.PersonAdmHosDate=""
	s a.PersonType2="N"
	d a.%Save()
	s pid=..getid($P($P(parr,"^",8),"|",2))
    ;s parm=$P($P(parr,"^",2),"|",2)_"^"_$P($P(parr,"^",8),"|",2)_"^^"_pid_"^"_$P($P(parr,"^",24),"|",2)_"^"_$ZDH($P($P(parr,"^",40),"|",2),3)_"^^Y^1"
    s parm=$P($P(parr,"^",2),"|",2)_"^"_$P($P(parr,"^",8),"|",2)_"^^"_pid_"^"_$P($P(parr,"^",24),"|",2)_"^"_$P($P(parr,"^",40),"|",2)_"^^Y^1"
    s transRowRw=$O(^DHCMGNUR.MgNurTransDepI("Current"," Y"," "_$P($P(parr,"^",8),"|",2),""))
    i transRowRw="" d
    .s aa=##class(DHCMGNUR.MgNurTransDep).Save(parm)
    e  d
    .s aa=##class(DHCMGNUR.MgNurTransDep).%OpenId(transRowRw)
    .;s ^TMOPE111=demo1^9993^^1255^781^2013-12-01^^Y^1
    .s ^TEMP1parm=parm
    .s aa.PerName=$P(parm,"^",1)
    .s aa.PerID=$P(parm,"^",2)
    .s aa.PerDr=##class(DHCMGNUR.MgPersons).%OpenId($P(parm,"^",4))
    .s aa.PerDepart=$P(parm,"^",5)
    .s aa.PerTranStDate=$ZDH($P(parm,"^",6),3)
    .s aa.PerTranCurrent="Y"
    .s aa.PerTranStTime=$P($H,",",2)
    .d aa.%Save()
	q a.%Id()
}

ClassMethod ExcuteTransDep()
{
	s personid="" f  s personid=$O(^DHCMGNUR.MgPersonsI("SSID",personid)) q:personid=""  d
	.s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID",personid,id)) q:id=""  d
	..s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	..q:a.PersonType2'="N"
	..s CurrDate=+$H
	..i ((a.PersonDepDR'=a.PersonTmpDep)&&(a.PersonTmpDep'="")&&(a.PersonTmpDate=CurrDate)) d
	...s parm=a.PersonName_"^"_a.PersonID_"^"_"^"_id_"^"_a.PersonTmpDep_"^"_$ZD(a.PersonTmpDate,3)_"^"_"^"_"Y"_"^"_"0"
	...s a.PersonDepDR=a.PersonTmpDep
	...s a.PersonTransDate=a.PersonTmpDate
	...d a.%Save()
	...s excuteid=a.%Id()
	...i excuteid'="" d
	....s aa=##class(DHCMGNUR.MgNurTransDep).Save(parm)
}

ClassMethod SaveLongTranDep(parm) As %String
{
	s rw=$P(parm,"^",4)
	s a=##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s currentDate=$ZD(+$H,3)
	i (currentDate'=$p(parm,"^",6))&($ZDH($p(parm,"^",6),3)>+$H) d
	.s a.PersonTmpDep=$p(parm,"^",5)
	.s a.PersonTmpDate=$ZDH($P(parm,"^",6),3)
	.s a.PersonTempDepDR=""
	.d a.%Save()
	e  i (currentDate=$p(parm,"^",6))!($ZDH($p(parm,"^",6),3)<+$H) d
	.s a.PersonDepDR=$p(parm,"^",5)
	.s a.PersonTransDate=$ZDH($P(parm,"^",6),3)
	.s a.PersonTempDepDR=""
	.s a.PersonTmpDep=$p(parm,"^",5)
	.s a.PersonTmpDate=$ZDH($P(parm,"^",6),3)
	.d a.%Save()
	.s excuteid=a.%Id()
	.i excuteid'="" d
	..s aa=##class(DHCMGNUR.MgNurTransDep).Save(parm)
	;s rw=$P(parm,"^",4)
	;s a=##class(DHCMGNUR.MgPersons).%OpenId(rw)
	;s a.PersonDepDR=$p(parm,"^",5)
	;s a.PersonTransDate=$ZDH($P(parm,"^",6),3)
	;s a.PersonTempDepDR=""
	;d a.%Save()
	;s aa=##class(DHCMGNUR.MgNurTransDep).Save(parm)
}

ClassMethod SaveTranDep(parm) As %String
{
	;s ^TEMPPARM2=parm
	s rw=$P(parm,"^",4)
	s currentDep=$P(parm,"^",11)
	;s DepId=""  f  s DepId=$O(^CTLOC(0,"Code",currentDep,DepId)) q:DepId=""  d
	s a=##class(DHCMGNUR.MgPersons).%OpenId(rw)
	i $P(parm,"^",5)=a.PersonDepDR s a.PersonTempDepDR=""
	e  s a.PersonTempDepDR=$P(parm,"^",5)
	d a.%Save()
	s aa=##class(DHCMGNUR.MgNurTransDep).Save(parm)
	//q a.%Id()
}

/// 暂时不用
ClassMethod SaveE(parr As %String) As %String
{
	s tmp=""
	//d ##class(DHCMGNUR.MgPersons).Save(parr)
	s l=$L(parr,"^")
	f i=1:1:l
	{
	  s itm=$P(parr,"^",i)
	  i itm="" continue
	  s name=$P(itm,"|")
	  s val=$P(itm,"|",2)
	  s tmp(name)=val
	}
	s tdata=""
    s id=$G(tmp("rw"))
     i id'=""
	 {		 
		 s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	 }	 
	 s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgPersons","a",p)) q:p=""  d
	 .;s p=$tr(p," ","")
	 .i $D(tmp(p)) d
	 ..q:tmp(p)=""
	 ..i tmp("Personpeopledr")'="" s a.Personpeopledr=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("Personpeopledr"),"民族"))
	 ..i tmp("PersonTeachPostDR")'="" s a.PersonTeachPostDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonTeachPostDR"),"教学职称"))
	 ..i tmp("PersonMentorDR")'="" s a.PersonMentorDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonMentorDR"),"导师资格"))
	 ..i tmp("PersonAppDutyDR")'="" s a.PersonAppDutyDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonAppDutyDR"),"聘任职称"))
	 ..i tmp("PersonheadshipDR")'="" s a.PersonheadshipDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonheadshipDR"),"职务"))
	 ..i tmp("PersonPolitydr")'="" s a.PersonPolitydr=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonPolitydr"),"政治面貌"))
	 ..i tmp("PersonSchoolAgeDr")'="" s a.PersonSchoolAgeDr=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonSchoolAgeDr"),"学历"))
	 ..i tmp("PersonDegreeDR")'="" s a.PersonDegreeDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonDegreeDR"),"学位"))
	 ..i tmp("PersonNurTyp")'="" s a.PersonNurTyp=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonNurTyp"),"护士种类"))
	 ..i tmp("PersonLanguage")'="" s a.PersonLanguage=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonLanguage"),"外语语种"))
	 ..i tmp("PersonPrefQual")'="" s a.PersonPrefQual=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonPrefQual"),"取得专科护士资格种类"))
	 ..i tmp("PersonEngageMth")'="" s a.PersonEngageMth=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonEngageMth"),"职务聘任方式"))
	 ..i tmp("PersonPostTyp")'="" s a.PersonPostTyp=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonPostTyp"),"人员类别"))
	 ..i tmp("PersonProfession")'="" s a.PersonProfession=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonProfession"),"专业"))
	 ..i tmp("PersonClothesNO")'="" s a.PersonClothesNO=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonClothesNO"),"衣号"))
	 ..i tmp("PersonShoeNO")'="" s a.PersonShoeNO=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonShoeNO"),"鞋号"))
	 ..i tmp("PersonSchoolType")'="" s a.PersonSchoolType=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonSchoolType"),"院校制式"))
	 ..i tmp("PersonSchoolMedWest")'="" s a.PersonSchoolMedWest=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonSchoolMedWest"),"中西医"))
	 ..i tmp("PersonBattery")'="" s a.PersonBattery=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonBattery"),"护士层级"))
	 ..i tmp("PersonProfPostDR") s a.PersonProfPostDR=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonProfPostDR"),"专业技术职称"))
	 ..//i tmp("PersonGraduateSchool") s a.PersonGraduateSchool=##class(DHCMGNUR.CommDictionarySub).%OpenId(..getcodedr(tmp("PersonGraduateSchool"),"毕业院校"))
	 ..i p="PersonBirthDay" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonWorkDateTime" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonFromDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonGraduateDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonCareDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonNurHeadDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonHosEngageDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..;i p="PersonEngageDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonRetireDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonNurseQualDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonPrefQualDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonTechPostDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonEndDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonAdmHosDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="PersonTransDate" s tmp(p)=$ZDH(tmp(p),3)
	 ..i p="Personpeopledr" s ^m123=tmp(p)
	 ..s $ZOBJPROPERTY(a,p)=tmp(p)
    d a.%Save()
	q a.%Id()
}

ClassMethod getVal1(id) As %String
{
	s ret=""
	i id'=""
	{
		s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
		s tmp=""
		s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgPersons","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(a,p)
		s parm=$G(^DHCMGNUR.MgPersonsD(id))
		s tmp("Personpeopledr")=$listget(parm,62)
		s tmp("PersonPolitydr")=$listget(parm,35)
		s tmp("PersonLanguage")=$listget(parm,27)
		s tmp("PersonShoeNO")=$listget(parm,50)
		s tmp("PersonSchoolMedWest")=$listget(parm,46)
		s tmp("PersonTeachPostDR")=$listget(parm,52)
		s tmp("PersonClothesNO")=$listget(parm,10)
		s tmp("PersonBattery")=$listget(parm,6)
		s tmp("PersonMentorDR")=$listget(parm,29)
		s tmp("PersonSchoolType")=$listget(parm,47)
		s tmp("PersonNurTyp")=$listget(parm,33)
		s tmp("PersonPostTyp")=$listget(parm,36)
		s tmp("PersonProfession")=$listget(parm,41)
		s tmp("PersonSchoolAgeDr")=$listget(parm,45)
		s tmp("PersonDegreeDR")=$listget(parm,11)
		s tmp("PersonEngageMth")=$listget(parm,15)
		s tmp("PersonheadshipDR")=$listget(parm,60)
		s tmp("PersonPrefQual")=$listget(parm,37)
		s tmp("PersonAppDutyDR")=$listget(parm,4)
		s tmp("PersonDepDR")=a.PersonDepDR 
		i tmp("PersonWorkDateTime")'="" s tmp("PersonWorkDateTime")=$ZD(tmp("PersonWorkDateTime"),3)
		i tmp("PersonBirthDay")'="" s tmp("PersonBirthDay")=$ZD(tmp("PersonBirthDay"),3)
		i tmp("PersonNurseQualDate")'="" s tmp("PersonNurseQualDate")=$ZD(tmp("PersonNurseQualDate"),3)
		i tmp("PersonPrefQualDate")'="" s tmp("PersonPrefQualDate")=$ZD(tmp("PersonPrefQualDate"),3)
		i tmp("PersonFromDate")'="" s tmp("PersonFromDate")=$ZD(tmp("PersonFromDate"),3)
		i tmp("PersonTechPostDate")'="" s tmp("PersonTechPostDate")=$ZD(tmp("PersonTechPostDate"),3)
		i tmp("PersonGraduateDate")'="" s tmp("PersonGraduateDate")=$ZD(tmp("PersonGraduateDate"),3)
		i tmp("PersonCareDate")'="" s tmp("PersonCareDate")=$ZD(tmp("PersonCareDate"),3)
		i tmp("PersonNurHeadDate")'="" s tmp("PersonNurHeadDate")=$ZD(tmp("PersonNurHeadDate"),3)
		;i tmp("PersonEngageDate")'="" s tmp("PersonEngageDate")=$ZD(tmp("PersonEngageDate"),3)
		i tmp("PersonHosEngageDate")'="" s tmp("PersonHosEngageDate")=$ZD(tmp("PersonHosEngageDate"),3)
		i tmp("PersonAdmHosDate")'="" s tmp("PersonAdmHosDate")=$ZD(tmp("PersonAdmHosDate"),3)
		i tmp("PersonEndDate")'="" s tmp("PersonEndDate")=$ZD(tmp("PersonEndDate"),3)
		i tmp("PersonRetireDate")'="" s tmp("PersonRetireDate")=$ZD(tmp("PersonRetireDate"),3)
		i tmp("PersonTransDate")'="" s tmp("PersonTransDate")=$ZD(tmp("PersonTransDate"),3)
		s k=""
		f {
			s k=$O(tmp(k))
			q:k=""
			if tmp(k)["%" continue
			s ret=ret_k_"|"_tmp(k)_"^"
		  }
	}
	q ret
}

/// 替换以前的getVal 获取数据
ClassMethod getVal(id) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	i id'=""
	{
		s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
		s PersonName=a.PersonName
		i a.PersonBirthDay'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonBirthDay=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonBirthDay)
		.e  s PersonBirthDay=""
		e  s PersonBirthDay=""
		s PersonAddress=a.PersonAddress
		i a.PersonSexDR'="" s PersonSexDR=a.PersonSexDR
		e  s PersonSexDR=""
		i a.Personmarriage'="" s Personmarriage=a.Personmarriage
		e  s Personmarriage=""
		s PersonTelHome=a.PersonTelHome
		s PersonID=a.PersonID
		s PersonTelHand=a.PersonTelHand
		s PersonHouseholdAdd=a.PersonHouseholdAdd
		s PersonIdentity=a.PersonIdentity
		i a.PersonWorkDateTime'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonWorkDateTime=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonWorkDateTime)
		.e  s PersonWorkDateTime=""
		e  s PersonWorkDateTime=""
		s PersonPresentZipCode=a.PersonPresentZipCode
		s PersonNativePlaceDR=a.PersonNativePlaceDR
		s PersonHeight=a.PersonHeight
		s PersonRegNo=a.PersonRegNo
		s PersonHouseZipCode=a.PersonHouseZipCode
		i a.PersonNurHeadDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonNurHeadDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonNurHeadDate)
		.e  s PersonNurHeadDate=""
		e  s PersonNurHeadDate=""
		i a.PersonheadshipDR'="" s PersonheadshipDR=$tr(a.PersonheadshipDR.%Id(),"||","__")
		e  s PersonheadshipDR=""
		i a.PersonHosEngageDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonHosEngageDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonHosEngageDate)
		.e  s PersonHosEngageDate=""
		e  s PersonHosEngageDate=""
		i a.PersonRetireDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonRetireDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonRetireDate)
		.e  s PersonRetireDate=""
		e  s PersonRetireDate=""
		i a.PersonNurseQualDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonNurseQualDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonNurseQualDate)
		.e  s PersonNurseQualDate=""
		e  s PersonNurseQualDate=""
		i a.PersonPrefQualDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonPrefQualDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonPrefQualDate)
		.e  s PersonPrefQualDate=""
		e  s PersonPrefQualDate=""
		s PersonDepDR=a.PersonDepDR
		i a.PersonTechPostDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonTechPostDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonTechPostDate)
		.e  s PersonTechPostDate=""
		e  s PersonTechPostDate=""
		i a.Personpeopledr'="" s Personpeopledr=$tr(a.Personpeopledr.%Id(),"||","__")
		e  s Personpeopledr=""
		i a.PersonPolitydr'="" s PersonPolitydr=$tr(a.PersonPolitydr.%Id(),"||","__")
		e  s PersonPolitydr=""
		i a.PersonShoeNO'="" s PersonShoeNO=$tr(a.PersonShoeNO.%Id(),"||","__")
		e  s PersonShoeNO=""
		i a.PersonTeachPostDR'="" s PersonTeachPostDR=$tr(a.PersonTeachPostDR.%Id(),"||","__")
		e  s PersonTeachPostDR=""
		i a.PersonClothesNO'="" s PersonClothesNO=$tr(a.PersonClothesNO.%Id(),"||","__")
		e  s PersonClothesNO=""
		i a.PersonBattery'="" s PersonBattery=$tr(a.PersonBattery.%Id(),"||","__")
		e  s PersonBattery=""
		i a.PersonMentorDR'="" s PersonMentorDR=$tr(a.PersonMentorDR.%Id(),"||","__")
		e  s PersonMentorDR=""
		i a.PersonSchoolType'="" s PersonSchoolType=$tr(a.PersonSchoolType.%Id(),"||","__")
		e  s PersonSchoolType=""
		i a.PersonNurTyp'="" s PersonNurTyp=$tr(a.PersonNurTyp.%Id(),"||","__")
		e  s PersonNurTyp=""
		i a.PersonPostTyp'="" s PersonPostTyp=$tr(a.PersonPostTyp.%Id(),"||","__")
		e  s PersonPostTyp=""
		i a.PersonProfession'="" s PersonProfession=$tr(a.PersonProfession.%Id(),"||","__")
		e  s PersonProfession=""
		i a.PersonSchoolAgeDr'="" s PersonSchoolAgeDr=$tr(a.PersonSchoolAgeDr.%Id(),"||","__")
		e  s PersonSchoolAgeDr=""
		i a.PersonDegreeDR'="" s PersonDegreeDR=$tr(a.PersonDegreeDR.%Id(),"||","__")
		e  s PersonDegreeDR=""
		i a.PersonPrefQual'="" s PersonPrefQual=$tr(a.PersonPrefQual.%Id(),"||","__")
		e  s PersonPrefQual=""
		i a.PersonTransDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonTransDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonTransDate)
		.e  s PersonTransDate=""
		e  s PersonTransDate=""
		i a.PersonAppDutyDR'="" s PersonAppDutyDR=$tr(a.PersonAppDutyDR.%Id(),"||","__")
		e  s PersonAppDutyDR=""
		;s PersonGraduateSchool=a.PersonGraduateSchool
		i a.PersonGraduateSchool'="" s PersonGraduateSchool=$tr(a.PersonGraduateSchool.%Id(),"||","__")
		e  s PersonGraduateSchool=""
		i a.PersonProfPostDR'="" s PersonProfPostDR=$tr(a.PersonProfPostDR.%Id(),"||","__")
		e  s PersonProfPostDR=""
		s PersonWorkType=a.PersonWorkType
		s PersonImage=a.PersonImage
		;s PersonPrefQualFlag=a.PersonPrefQualFlag
		s PersonFlag=a.PersonFlag
		i a.PersonAdmHosDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonAdmHosDate=##class(web.DHCMgNurPerHRComm).getDateFormat(a.PersonAdmHosDate)
		.e  s PersonAdmHosDate=""
		e  s PersonAdmHosDate=""
		b ;04
		s ret=ret_"PersonName"_"|"_PersonName_"^"_"PersonBirthDay"_"|"_PersonBirthDay_"^"_"PersonAddress"_"|"_PersonAddress_"^"_"PersonSexDR"_"|"_PersonSexDR_"^"_"Personmarriage"_"|"_Personmarriage_"^"_"PersonTelHome"_"|"_PersonTelHome_"^"_"PersonID"_"|"_PersonID_"^"_"PersonTelHand"_"|"_PersonTelHand_"^"_"PersonHouseholdAdd"_"|"_PersonHouseholdAdd_"^"_"PersonIdentity"_"|"_PersonIdentity_"^"_"PersonWorkDateTime"_"|"_PersonWorkDateTime_"^"_"PersonPresentZipCode"_"|"_PersonPresentZipCode_"^"_"PersonNativePlaceDR"_"|"_PersonNativePlaceDR_"^"_"PersonHeight"_"|"_PersonHeight_"^"_"PersonRegNo"_"|"_PersonRegNo_"^"_"PersonHouseZipCode"_"|"_PersonHouseZipCode_"^"_"PersonNurHeadDate"_"|"_PersonNurHeadDate_"^"_"PersonheadshipDR"_"|"_PersonheadshipDR_"^"_"PersonHosEngageDate"_"|"_PersonHosEngageDate_"^"_"PersonRetireDate"_"|"_PersonRetireDate_"^"_"PersonNurseQualDate"_"|"_PersonNurseQualDate_"^"_"PersonPrefQualDate"_"|"_PersonPrefQualDate_"^"_"PersonDepDR"_"|"_PersonDepDR_"^"_"PersonTechPostDate"_"|"_PersonTechPostDate_"^"_"Personpeopledr"_"|"_Personpeopledr_"^"_"PersonPolitydr"_"|"_PersonPolitydr_"^"_"PersonShoeNO"_"|"_PersonShoeNO_"^"_"PersonTeachPostDR"_"|"_PersonTeachPostDR_"^"_"PersonClothesNO"_"|"_PersonClothesNO_"^"_"PersonBattery"_"|"_PersonBattery_"^"_"PersonMentorDR"_"|"_PersonMentorDR_"^"_"PersonSchoolType"_"|"_PersonSchoolType_"^"_"PersonNurTyp"_"|"_PersonNurTyp_"^"_"PersonPostTyp"_"|"_PersonPostTyp_"^"_"PersonProfession"_"|"_PersonProfession_"^"_"PersonSchoolAgeDr"_"|"_PersonSchoolAgeDr_"^"_"PersonDegreeDR"_"|"_PersonDegreeDR_"^"_"PersonPrefQual"_"|"_PersonPrefQual_"^"_"PersonTransDate"_"|"_PersonTransDate_"^"_"PersonAppDutyDR"_"|"_PersonAppDutyDR_"^"_"PersonGraduateSchool"_"|"_PersonGraduateSchool_"^"_"PersonProfPostDR"_"|"_PersonProfPostDR_"^"_"PersonWorkType"_"|"_PersonWorkType_"^"_"PersonImage"_"|"_PersonImage_"^"_"PersonFlag"_"|"_PersonFlag_"^PersonAdmHosDate|"_PersonAdmHosDate_"^"
	}
	q ret
}

ClassMethod veritySave(parr As %String) As %String
{
	s ^TEMPPARR001=parr
	s id=$P(parr,"^",1)
	s flag=$P(parr,"^",2)	
	b ;02
	s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	s a.PersonFlag=flag
	b ;01
	d a.%Save()
	q a.%Id()
}

ClassMethod revokeSave(parr As %String) As %String
{
	s id=$P(parr,"^",1)
	s flag=$P(parr,"^",2)
	s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	s a.PersonFlag=flag
	d a.%Save()
	q a.%Id()
}

ClassMethod getcodedr(code, typ) As %String
{
	s typdr=##class(DHCMGNUR.MgPersons).getcodedrm(typ)
	q:typdr=""
	s codedr=""
	s mz="" f  s mz=$O(^DHCMGNUR.CommDictionarySubI("Code",mz)) q:mz=""  d
	.s rw="" f  s rw=$O(^DHCMGNUR.CommDictionarySubI("Code",mz,typdr,rw)) q:(rw="")!(codedr'="")  d
	..s a=^DHCMGNUR.CommDictionarySubD(typdr,rw)
	..s des=$List(a,5)
	..if des=code s codedr=typdr_"||"_rw
	q codedr
}

ClassMethod getcodedrm(typ) As %String
{
	s codedr=""
	s rw="" f  s rw=$O(^DHCMGNUR.CommDictionaryD(rw)) q:(rw="")!(codedr'="")  d
	.s a=^DHCMGNUR.CommDictionaryD(rw)
	.s code=$List(a,2)
	.if code=typ s codedr=rw
	q codedr
}

ClassMethod getid(ssid) As %String
{
	s ssid=$ZConvert(ssid,"U")
 	s id="" s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_ssid,id))
  	q id
}

ClassMethod getCurrentDep(id) As %String
{
	s ret=""
	s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	i a.PersonDepDR="" s PerCurrentDep=""
	i a.PersonDepDR="9999" s PerCurrentDep="待分区(不做统计)"
	i a.PersonDepDR="9998" s PerCurrentDep="退休区(不做统计)"
	i a.PersonDepDR="9997" s PerCurrentDep="离职区(不做统计)"
	i (a.PersonDepDR'="")&(a.PersonDepDR'="9999")&(a.PersonDepDR'="9998")&(a.PersonDepDR'="9997") s PerCurrentDep=$p(^CTLOC(a.PersonDepDR),"^",2)
	s PersonName=a.PersonName
	s PersonID=a.PersonID
	s ret=ret_"PerCurrentDep|"_PerCurrentDep_"^"_"PersonName|"_PersonName_"^"_"PersonID|"_PersonID
	//s ret=ret_"PersonName|"_PersonName_"^"_"PersonID|"_PersonID
	q ret
}

/// 护理人员首页下拉框护理单元显示
ClassMethod getnursedep(nurseno) As %String
{
	s ret=""
	s nurseno=$ZConvert(nurseno,"U")
	s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_nurseno,id)) q:id=""  d
	.s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	.;s perNurDep=$P(^CTLOC(a.PersonDepDR),"^",2)
	.s perNurDep=a.PersonDepDR
	.s perNurName=a.PersonName
	.s ret=ret_"perNurDep|"_perNurDep_"^"_"perNurName|"_perNurName
	q ret
}

ClassMethod undifyFlag() As %String
{
	for i=1:1:1285
	{
		s a=##class(DHCMGNUR.MgPersons).%OpenId(i)
		;s personname=a.PersonName
		s a.PersonFlag="0"
		d a.%Save()
	}
}

ClassMethod ExistPerson(parr As %String) As %String
{
	s parr=$zcvt(parr,"U")
	s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_parr,""))
	i id'="" s exitp=1
	e  s exitp=0
	q exitp
}

ClassMethod getzdhdate(date As %String) As %String
{
	q:date="" ""
	s date=$zdh(date,3)
	q date
}

Storage Default
{
<Data name="MgPersonsDefaultData">
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
<Value>PersonAppdutyDate</Value>
</Value>
<Value name="6">
<Value>PersonBattery</Value>
</Value>
<Value name="7">
<Value>PersonBirthDay</Value>
</Value>
<Value name="8">
<Value>PersonCareDate</Value>
</Value>
<Value name="9">
<Value>PersonCatg</Value>
</Value>
<Value name="10">
<Value>PersonClothesNO</Value>
</Value>
<Value name="11">
<Value>PersonDegreeDR</Value>
</Value>
<Value name="12">
<Value>PersonDepDR</Value>
</Value>
<Value name="13">
<Value>PersonEndDate</Value>
</Value>
<Value name="14">
<Value>PersonEngageDate</Value>
</Value>
<Value name="15">
<Value>PersonEngageMth</Value>
</Value>
<Value name="16">
<Value>PersonEnterDepDate</Value>
</Value>
<Value name="17">
<Value>PersonFromDate</Value>
</Value>
<Value name="18">
<Value>PersonGraduateDate</Value>
</Value>
<Value name="19">
<Value>PersonGraduateSchool</Value>
</Value>
<Value name="20">
<Value>PersonHeight</Value>
</Value>
<Value name="21">
<Value>PersonHosEngageDate</Value>
</Value>
<Value name="22">
<Value>PersonHouseZipCode</Value>
</Value>
<Value name="23">
<Value>PersonHouseholdAdd</Value>
</Value>
<Value name="24">
<Value>PersonID</Value>
</Value>
<Value name="25">
<Value>PersonIFFullTime</Value>
</Value>
<Value name="26">
<Value>PersonIdentity</Value>
</Value>
<Value name="27">
<Value>PersonLanguage</Value>
</Value>
<Value name="28">
<Value>PersonLeaveUnit</Value>
</Value>
<Value name="29">
<Value>PersonMentorDR</Value>
</Value>
<Value name="30">
<Value>PersonName</Value>
</Value>
<Value name="31">
<Value>PersonNativePlaceDR</Value>
</Value>
<Value name="32">
<Value>PersonNurHeadDate</Value>
</Value>
<Value name="33">
<Value>PersonNurTyp</Value>
</Value>
<Value name="34">
<Value>PersonNurseQualDate</Value>
</Value>
<Value name="35">
<Value>PersonPolitydr</Value>
</Value>
<Value name="36">
<Value>PersonPostTyp</Value>
</Value>
<Value name="37">
<Value>PersonPrefQual</Value>
</Value>
<Value name="38">
<Value>PersonPrefQualDate</Value>
</Value>
<Value name="39">
<Value>PersonPresentZipCode</Value>
</Value>
<Value name="40">
<Value>PersonProfPostDR</Value>
</Value>
<Value name="41">
<Value>PersonProfession</Value>
</Value>
<Value name="42">
<Value>PersonRegNo</Value>
</Value>
<Value name="43">
<Value>PersonRetireDate</Value>
</Value>
<Value name="44">
<Value>PersonSSDR</Value>
</Value>
<Value name="45">
<Value>PersonSchoolAgeDr</Value>
</Value>
<Value name="46">
<Value>PersonSchoolMedWest</Value>
</Value>
<Value name="47">
<Value>PersonSchoolType</Value>
</Value>
<Value name="48">
<Value>PersonSecEdu</Value>
</Value>
<Value name="49">
<Value>PersonSexDR</Value>
</Value>
<Value name="50">
<Value>PersonShoeNO</Value>
</Value>
<Value name="51">
<Value>PersonTeachHolidayFlag</Value>
</Value>
<Value name="52">
<Value>PersonTeachPostDR</Value>
</Value>
<Value name="53">
<Value>PersonTechPostDate</Value>
</Value>
<Value name="54">
<Value>PersonTelHand</Value>
</Value>
<Value name="55">
<Value>PersonTelHome</Value>
</Value>
<Value name="56">
<Value>PersonTempDepDR</Value>
</Value>
<Value name="57">
<Value>PersonTyp</Value>
</Value>
<Value name="58">
<Value>PersonWageNo</Value>
</Value>
<Value name="59">
<Value>PersonWorkDateTime</Value>
</Value>
<Value name="60">
<Value>PersonheadshipDR</Value>
</Value>
<Value name="61">
<Value>Personmarriage</Value>
</Value>
<Value name="62">
<Value>Personpeopledr</Value>
</Value>
<Value name="63">
<Value>PersonTranDate</Value>
</Value>
<Value name="64">
<Value>PersonTransDate</Value>
</Value>
<Value name="65">
<Value>PersonFlag</Value>
</Value>
<Value name="66">
<Value>PersonImage</Value>
</Value>
<Value name="67">
<Value>PersonPrefQualFlag</Value>
</Value>
<Value name="68">
<Value>PersonWorkType</Value>
</Value>
<Value name="69">
<Value>PersonTmpDep</Value>
</Value>
<Value name="70">
<Value>PersonTmpDate</Value>
</Value>
<Value name="71">
<Value>PersonType2</Value>
</Value>
<Value name="72">
<Value>PersonInternSchool</Value>
</Value>
<Value name="73">
<Value>PersonInternProf</Value>
</Value>
<Value name="74">
<Value>PersonInternClass</Value>
</Value>
<Value name="75">
<Value>PersonInternStDate</Value>
</Value>
<Value name="76">
<Value>PersonInternEndDate</Value>
</Value>
<Value name="77">
<Value>PersonInternAddress</Value>
</Value>
<Value name="78">
<Value>PersonStudyPref</Value>
</Value>
<Value name="79">
<Value>PersonWorkUnit</Value>
</Value>
<Value name="80">
<Value>PersonGRType</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgPersonsD</DataLocation>
<DefaultData>MgPersonsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgPersonsD</IdLocation>
<IndexLocation>^DHCMGNUR.MgPersonsI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgPersonsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
