/// Creator:gzj
/// Date:2018-11-09
/// Description:规培生管理公共类
Class web.NurMgNormativeComm Extends %RegisteredObject
{

/// Creator:gzj
/// Description:按照来院日期过滤人员信息
/// Date:2018-11-09
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgNormativeComm","FindNurseForYear","")
Query FindNurseForYear(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseForYearExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s comeYear=$p(parr,"^",1)
	s ward=$p(parr,"^",2)
	s RowID="" f  s RowID=$o(^DHCNMG.HR.MgPersonsI("type"," N",RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.q:'$IsObject(obj)
	.s IsExist=..IsExistInNormal(comeYear,RowID)
	.q:IsExist=1
	.s ComeDate=obj.PerComeDate
	.q:((comeYear'="")&&($p($zd(ComeDate,3),"-",1)'=comeYear))
	.s NurseName=obj.PerName
	.s NurseNo=obj.PerID
	.s WardID=obj.PerDepDR
	.q:((ward'="")&&(WardID'=ward))
	.s NurseWard=""
	.i WardID'="" d
	..s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(WardID)
	..q:'$IsObject(WardObj)
	..s NurseWard=WardObj.WardDesc
	.s NurseComeDate=""
	.
	.i obj.PerComeDate'="" s NurseComeDate=$zd(obj.PerComeDate,3)
	.s ret="NurseName|"_NurseName_"^NurseNo|"_NurseNo_"^NurseWard|"_NurseWard_"^NurseComeDate|"_NurseComeDate_"^RowID|"_RowID
	.d OutputNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseForYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseForYearExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurseForYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseForYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-11-09
/// Description:判断此人是否在规培中存在
/// 
ClassMethod IsExistInNormal(year As %String, nurseID As %String) As %String
{
	q:((year="")!(nurseID="")) 0
	s flag=0
	s Rw=$o(^DHCNMG.HR.MgNurNormativeI("year",year,nurseID,""))
	i Rw'="" s flag=1
	q flag
}

/// Creator:gzj
/// Date:2018-11-09
/// Description:获取护士的最新层级
/// Return:护士层级
ClassMethod GetNurseLevel(nurseID As %String) As %String
{
	q:nurseID="" ""
	s flag=0
	s NurseLevel=""
	s date="" f  s date=$o(^DHCNMG.HR.MgLevelI("date",date),-1) q:((date="")!flag=1)  d
	.s RowID="" f  s RowID=$o(^DHCNMG.HR.MgLevelI("date",date,nurse,RowID),-1) q:((RowID="")!(flag=1))  d
	..s obj=##class(DHCNMG.HR.MgLevel).%OpenId(RowID)
	..q:'$IsObject(obj)
	..q:obj.LevelStatus'="A"
	..s LevelID=obj.NurLevel
	..i LevelID'="" d
	...s NurseLevel=##class(web.NurMgPersonComm).GetCommCode(LevelID)
	...s flag=1
	q NurseLevel
}

/// Creator:gzj
/// Date:2018-11-09
/// Description:获取护士的最新的职称名称
/// 
ClassMethod GetNurseHireDuty(nurseID As %String) As %String
{
	q:nurseID="" ""
	s flag=0
	s NurseHireDuty=""
	s date="" f  s date=$o(^DHCNMG.HR.MgHireDutyI("date",date),-1) q:((date="")!(flag=1))  d
	.s RowID="" f  s RowID=$o(^DHCNMG.HR.MgHireDutyI("date",date,nurseID,RowID),-1) q:((RowID="")!(flag=1))  d
	..s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(RowID)
	..q:'$IsObject(obj)
	..q:obj.HireStatus'="A"
	..s HireDutyID=obj.HireDuty
	..i HireDutyID'="" d
	...s NurseHireDuty=##class(web.NurMgPersonComm).GetCommCode(HireDutyID)
	...s flag=1
	q NurseHireDuty
}

ClassMethod SaveNormativeData(parr As %String, year As %String) As %String
{
	q:parr="" 0
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s itm=$p(parr,"^",i)
		i itm="" continue
		s obj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		q:'$IsObject(obj)
		;s rw=$o(^DHCNMG.HR.MgNurNormativeI("year",
		s rw=$o(^DHCNMG.HR.MgNurNormativeI("year",year,itm,""))
		i rw="" s NObj=##class(DHCNMG.HR.MgNurNormative).%New()
		e  s NObj=##class(DHCNMG.HR.MgNurNormative).%OpenId(rw)
		s NObj.NurseID=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		s NObj.NurseYear=year
		s NurseHighAcade="",NurseDegree=""
		s educateDate=$o(^DHCNMG.HR.MgEducateI("flag",itm,""),-1)
		i educateDate'="" d
		.s educateRw=$o(^DHCNMG.HR.MgEducateI("flag",itm,educateDate,""),-1)
		.i educateRw'="" d
		..s educateObj=##class(DHCNMG.HR.MgEducate).%OpenId(educateRw)
		..q:'$IsObject(educateObj)
		..q:educateObj.EduStatus'="A"
		..s NurseHighAcade=educateObj.EduAcademic
		..s NurseDegree=educateObj.EduDegree
		s NObj.NurseHighAcade=NurseHighAcade
		s NObj.NurseDegree=NurseDegree
		s NurseHireDuty=""
		s hireDate=$o(^DHCNMG.HR.MgHireDutyI("HireDate",itm,""),-1)
		i hireDate'="" d
		.s hireRw=$o(^DHCNMG.HR.MgHireDutyI("HireDate",itm,hireDate,""),-1)
		.i hireRw'="" d
		..s hireObj=##class(DHCNMG.HR.MgHireDuty).%OpenId(hireRw)
		..q:'$IsObject(hireObj)
		..q:hireObj.HireStatus'="A"
		..s NurseHireDuty=hireObj.HireDuty
		i obj.PerRegRegiDate'="" s NObj.NurseRegiDate=obj.PerRegRegiDate
		
		s sc=NObj.%Save()
		
	}
	q 0
}

/// Creator:gzj
/// Description:查询规培生列表
/// Date:2018-11-09
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgNormativeComm","FindNormtiveList","")
Query FindNormtiveList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNormtiveListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stYear=$p(parr,"^",1)
	s endYear=$p(parr,"^",2)
	s ward=$p(parr,"^",3)
	s year="" f  s year=$o(^DHCNMG.HR.MgNurNormativeI("year",year)) q:year=""  d
	.q:((stYear'="")&&(year<stYear))
	.q:((endYear'="")&&(year>endYear))
	.s nurse="" f  s nurse=$o(^DHCNMG.HR.MgNurNormativeI("year",year,nurse)) q:nurse=""  d
	..s rw="" f  s rw=$o(^DHCNMG.HR.MgNurNormativeI("year",year,nurse,rw)) q:rw=""  d
	...s obj=##class(DHCNMG.HR.MgNurNormative).%OpenId(rw)
	...q:'$IsObject(obj)
	...s NurseName=obj.NurseID.PerName
	...s NurseNo=obj.NurseID.PerID
	...s NurseSex=""
	...i obj.NurseID.PerSexDR'="" s NurseSex=##class(web.NurMgPersonComm).GetCommCode(obj.NurseID.PerSexDR)
	...s NurseHireDuty=..GetNurseHireDuty(obj.NurseID.%Id())
	...s NurseHighAcade=""
	...i obj.NurseHighAcade'="" s NurseHighAcade=##class(web.NurMgPersonComm).GetCommCode(obj.NurseHighAcade)
	...s NurseYear=obj.NurseYear
	...s NurseWard=""
	...q:((ward'="")&&(obj.NurseID.PerDepDR'=ward))
	...i obj.NurseID.PerDepDR'="" d
	....s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.NurseID.PerDepDR)
	....q:'$IsObject(WardObj)
	....s NurseWard=WardObj.WardDesc
	...s ret="NurseName|"_NurseName_"^NurseNo|"_NurseNo_"^NurseSex|"_NurseSex_"^NurseHireDuty|"_NurseHireDuty_"^NurseHighAcade|"_NurseHighAcade_"^NurseYear|"_NurseYear_"^RowID|"_rw_"^NurseWard|"_NurseWard
	...d OutputNormative
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNormative
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNormtiveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNormtiveListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNormtiveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNormtiveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-11-10
/// Description:获取规培生的登记表信息
/// 
ClassMethod GetNormativeData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.HR.MgNurNormative).%OpenId(id)
	q:'$IsObject(obj) ""
	s NurseName=obj.NurseID.PerName
	s NurseSex=obj.NurseID.PerSexDR
	i obj.NurseID.PerBirthday'="" s NurseBirthday=$zd(obj.NurseID.PerBirthday,3)
	e  s NurseBirthday=""
	s NurseNative=obj.NurseID.PerNativePlace
	s NursePolitical=obj.NurseID.PerPolitical
	s NurseHeight=obj.NurseID.PerHeight
	s NurseHighAcade=obj.NurseHighAcade
	s NurseDegree=obj.NurseDegree
	s NurseHireDuty=obj.NurseHireDuty
	s NurseRegiDate=obj.NurseRegiDate
	s NurseRegiPlace=obj.NurseRegiPlace
	s NurseHealth=obj.NurseHealth
	s NurseCardID=obj.NurseID.PerCardId
	s NurseMarriage=obj.NurseID.PerMarriage
	s NursePhone=obj.NurseID.PerPhone
	s NurseFamily=obj.NurseFamily
	s NurseParentPhone=obj.NurseParentPhone
	s NurseAddress=obj.NurseID.PerAddress
	s NurseQQ=obj.NurseQQ
	//第一学历信息 第二学历信息从学习经历中获取
	s NurseFirstSchool=""
	s NurseFirstDate=""
	s NurseFirstAcade=""
    s NurseFirstPro=""
    s NurseSecSchool=""    
    s NurseSecDate=""         
    s NurseSecAcade=""           
    s NurseSecPro=""
    s n=0
    s date="" f  s date=$o(^DHCNMG.HR.MgEducateI("flag",obj.NurseID.%Id(),date)) q:date=""  d
    .s EducateRw="" f  s EducateRw=$o(^DHCNMG.HR.MgEducateI("flag",obj.NurseID.%Id(),date,EducateRw)) q:EducateRw=""  d
    ..s EduObj=##class(DHCNMG.HR.MgEducate).%OpenId(EducateRw)
    ..q:'$IsObject(EduObj)
    ..s n=n+1
    ..i n=1 d
    ...i EduObj.EduSchool'="" d
    ....s NurseFirstSchool=##class(web.NurMgPersonComm).GetCommCode(EduObj.EduSchool)
    ....i EduObj.EduEndDate'="" s NurseFirstDate=$zd(EduObj.EduEndDate,3)
    ....i EduObj.EduAcademic'="" s NurseFirstAcade=EduObj.EduAcademic
    ....i EduObj.EduProfession'="" s NurseFirstPro=EduObj.EduProfession
    ..i n=2 d
    ...i EduObj.EduSchool'="" d
    ....s NurseSecSchool=##class(web.NurMgPersonComm).GetCommCode(EduObj.EduSchool)
    ....i EduObj.EduEndDate'="" s NurseSecDate=$zd(EduObj.EduEndDate,3)
    ....i EduObj.EduAcademic'="" s NurseSecAcade=EduObj.EduAcademic
    ....i EduObj.EduProfession'="" s NurseSecPro=EduObj.EduProfession
    ///实习医院信息
    s InternHospital=obj.InternHospital
    s InernLevel=obj.InernLevel
    s InternLoc=obj.InternLoc
    i obj.InternStDate'="" s InternStDate=$zd(obj.InternStDate,3)
    e  s InternStDate=""
    i obj.InternEndDate'="" s InternEndDate=$zd(obj.InternEndDate,3)
    e  s InternEndDate=""
    s CityHospital=obj.CityHospital
    s CityLevel=obj.CityLevel
    s CityLoc=obj.CityLoc
    i obj.CityStDate'="" s CityStDate=$zd(obj.CityStDate,3)
    e  s CityStDate=""
    i obj.CityEndDate'="" s CityEndDate=$zd(obj.CityEndDate,3)
    e  s CityEndDate=""
    s OutSideHospital=obj.OutSideHospital
    s OutSideLevel=obj.OutSideLevel
    s OutSideLoc=obj.OutSideLoc
    i obj.OutSideStDate'="" s OutSideStDate=$zd(obj.OutSideStDate,3)
    e  s OutSideStDate=""
    i obj.OutSideEndDate'="" s OutSideEndDate=$zd(obj.OutSideEndDate,3)
    e  s OutSideEndDate=""
    s ret="NurseName|"_NurseName_"^NurseSex|"_NurseSex_"^NurseBirthday|"_NurseBirthday_"^NurseNative|"_NurseNative
    _"^NursePolitical|"_NursePolitical_"^NurseHeight|"_NurseHeight_"^NurseHighAcade|"_NurseHighAcade_"^NurseDegree|"_NurseDegree
    _"^NurseHireDuty|"_NurseHireDuty_"^NurseRegiDate|"_NurseRegiDate_"^NurseRegiPlace|"_NurseRegiPlace
    _"^NurseHealth|"_NurseHealth_"^NurseCardID|"_NurseCardID_"^NurseMarriage|"_NurseMarriage_"^NursePhone|"_NursePhone
    _"^NurseFamily|"_NurseFamily_"^NurseParentPhone|"_NurseParentPhone_"^NurseAddress|"_NurseAddress
    _"^NurseQQ|"_NurseQQ_"^NurseFirstSchool|"_NurseFirstSchool_"^NurseFirstDate|"_NurseFirstDate_"^NurseFirstAcade|"_NurseFirstAcade
    _"^NurseFirstPro|"_NurseFirstPro_"^NurseSecSchool|"_NurseSecSchool_"^NurseSecDate|"_NurseSecDate_"^NurseSecAcade|"_NurseSecAcade
    _"^NurseSecPro|"_NurseSecPro_"^InternHospital|"_InternHospital_"^InernLevel|"_InernLevel_"^InternLoc|"_InternLoc
    _"^InternStDate|"_InternStDate_"^InternEndDate|"_InternEndDate_"^CityHospital|"_CityHospital_"^CityLevel|"_CityLevel
    _"^CityLoc|"_CityLoc_"^CityStDate|"_CityStDate_"^CityEndDate|"_CityEndDate_"^OutSideHospital|"_OutSideHospital
    _"^OutSideLevel|"_OutSideLevel_"^OutSideLoc|"_OutSideLoc_"^OutSideStDate|"_OutSideStDate_"^OutSideEndDate|"_OutSideEndDate
    _"^RowID|"_id
    q ret
}

/// Creator:gzj
/// Date:2018-11-10
/// Description:保存规培生记录数据
/// 
ClassMethod SaveNormativeRec(parr As %String) As %String
{
	//NurseName|任明进^NurseSex|6||1^NurseBirthday|1987-08-21^NurseNative|安徽
	//^NursePolitical|2||6^NurseHeight|^NurseHighAcade|3||1^NurseDegree|19||1
	//^NurseHireDuty|^NurseRegiDate|^NurseRegiPlace|^NurseHealth|
	//^NurseCardID|340521198708214631^NurseMarriage|^NursePhone|13560380357
	//^NurseFamily|^NurseParentPhone|^NurseAddress|^NurseQQ|^NurseFirstSchool|
	//^NurseFirstDate|^NurseFirstAcade|^NurseFirstPro|^NurseSecSchool|^NurseSecDate|
	//^NurseSecAcade|^NurseSecPro|^InternHospital|^InernLevel|^InternLoc|^InternStDate|
	//^InternEndDate|^CityHospital|^CityLevel|^CityLoc|^CityStDate|^CityEndDate|^OutSideHospital|^OutSideLevel|
	//^OutSideLoc|^OutSideStDate|^OutSideEndDate|^RowID|3
	s tmp=""
	s a=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id'="" s obj=##class(DHCNMG.HR.MgNurNormative).%OpenId(id)
	e  s obj=##class(DHCNMG.HR.MgNurNormative).%New()
	i $tr(tmp("NurseRegiDate")," ","")'="" s obj.NurseRegiDate=$zdh($tr($g(tmp("NurseRegiDate"))," ",""),3)
	s obj.NurseRegiPlace=$tr($g(tmp("NurseRegiPlace"))," ","")
	s obj.NurseFamily=$tr($g(tmp("NurseFamily"))," ","")
	s obj.NurseParentPhone=$tr($g(tmp("NurseParentPhone"))," ","")
	s obj.NurseQQ=$tr($g(tmp("NurseQQ"))," ","")
	s obj.InternHospital=$tr($g(tmp("InternHospital"))," ","")
	s obj.InernLevel=$tr($g(tmp("InernLevel"))," ","")
	i $tr($g(tmp("InternStDate"))," ","")'="" s obj.InternStDate=$zdh($tr($g(tmp("InternStDate"))," ",""),3)
	i $tr($g(tmp("InternEndDate"))," ","")'="" s obj.InternEndDate=$zdh($tr($g(tmp("InternEndDate"))," ",""),3)
	s obj.InternLoc=$tr($g(tmp("InternLoc"))," ","")
	s obj.CityHospital=$tr($g(tmp("CityHospital"))," ","")
	s obj.CityLevel=$tr($g(tmp("CityLevel"))," ","")
	i $tr($g(tmp("CityStDate"))," ","")'="" s obj.CityStDate=$zdh($tr($g(tmp("CityStDate"))," ",""),3)
	i $tr($g(tmp("CityEndDate"))," ","")'="" s obj.CityEndDate=$zdh($tr($g(tmp("CityEndDate"))," ",""),3)
	s obj.CityLoc=$tr($g(tmp("CityLoc"))," ","")
	s obj.OutSideHospital=$tr($g(tmp("OutSideHospital"))," ","")
	s obj.OutSideLevel=$tr($g(tmp("OutSideLevel"))," ","")
	i $tr($g(tmp("OutSideStDate"))," ","")'="" s obj.OutSideStDate=$zdh($tr($g(tmp("OutSideStDate"))," ",""),3)
	i $tr($g(tmp("OutSideEndDate"))," ","")'="" s obj.OutSideEndDate=$zdh($tr($g(tmp("OutSideEndDate"))," ",""),3)
	s obj.OutSideLoc=$tr($g(tmp("OutSideLoc"))," ","")
	s obj.NurseHealth=$tr($g(tmp("NurseHealth"))," ","")
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod SaveTransData(parr As %String, user As %String) As %String
{
	s tmp=""
	s a=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgNurNormalTrans).%New()
	e  s obj=##class(DHCNMG.HR.MgNurNormalTrans).%OpenId(id)
	s obj.TransYear=$tr($g(tmp("TransYear"))," ","")
	s obj.TransTitle=$tr($g(tmp("TransTitle"))," ","")
	s obj.TransRemart=$tr($g(tmp("TransRemark"))," ","")
	s obj.TransFlag=$tr($g(tmp("TransFlag"))," ","")
	s obj.CreateUser=$tr(user," ","")
	s sc=obj.%Save()
	
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:查询规培生轮转列表
/// Date:2018-11-11
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgNormativeComm","FindNormaTranList","")
Query FindNormaTranList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNormaTranListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s year="" f  s year=$o(^DHCNMG.HR.MgNurNormalTransI("flag"," Y",year)) q:year=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.HR.MgNurNormalTransI("flag"," Y",year,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.HR.MgNurNormalTrans).%OpenId(RowID)
	..q:'$IsObject(obj)
	..s TransYear=obj.TransYear
	..s TransTitle=obj.TransTitle
	..s TransRemart=obj.TransRemart
	..s CreateDate=$zd(obj.CreateDate,3)
	..s ret="TransYear|"_TransYear_"^TransTitle|"_TransTitle_"^TransRemart|"_TransRemart_"^CreateDate|"_CreateDate_"^RowID|"_RowID
	..d OutputNormative
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNormative
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNormaTranListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNormaTranListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNormaTranListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNormaTranListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:按照记录查询规培生列表
/// Date:2018-11-11
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgNormativeComm","FindNormaListForYear","2018","")
Query FindNormaListForYear(rw As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNormaListForYearExecute(ByRef qHandle As %Binary, rw As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s RecObj=##class(DHCNMG.HR.MgNurNormalTrans).%OpenId(rw)
	i '$IsObject(RecObj) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s year=RecObj.TransYear
	s NurseID="" f  s NurseID=$o(^DHCNMG.HR.MgNurNormativeI("year",year,NurseID)) q:NurseID=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.HR.MgNurNormativeI("year",year,NurseID,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.HR.MgNurNormative).%OpenId(RowID)
	..q:'$IsObject(obj)
	..s NurseName=obj.NurseID.PerName
	..s rw=obj.NurseID.%Id()
	..s ret="NurseName|"_NurseName_"^rw|"_rw
	..d OutputNormative
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNormative
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNormaListForYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNormaListForYearExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNormaListForYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNormaListForYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNormaTransData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.HR.MgNurNormalTrans).%OpenId(id)
	q:'$IsObject(obj) ""
	s TransYear=obj.TransYear
	s TransTitle=obj.TransTitle
	s TransRemart=obj.TransRemart
	s ret="TransYear|"_TransYear_"^TransTitle|"_TransTitle_"^TransRemart|"_TransRemart_"^RowID|"_id
	q ret
}

/// 
/// 
/// Descrition:保存组
ClassMethod SaveTransGroup(parr As %String) As %String
{
	q:parr="" 0
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s Par=$tr($g(tmp("Par"))," ","")
	s GroupCode=$tr($g(tmp("GroupCode"))," ","")
	s GroupDesc=$tr($g(tmp("GroupDesc"))," ","")
	s GroupMember=$tr($g(tmp("GroupMember"))," ","")
	s RowID=$tr($g(tmp("RowID"))," ","")
	q:Par="" 0
	i RowID="" d
	.s obj=##class(DHCNMG.HR.MgNurNormativeGroup).%New()
	.s obj.GroupParref=##class(DHCNMG.HR.MgNurNormalTrans).%OpenId(Par)
	e  s obj=##class(DHCNMG.HR.MgNurNormativeGroup).%OpenId(Par_"||"_RowID)
	s obj.GroupCode=GroupCode
	s obj.GroupDesc=GroupDesc
	s obj.RowSort=..GetTransGroupSort(Par)
	d obj.GroupMember.Clear()
	s len=$l(GroupMember,",")
	f i=1:1:len
	{
		s itm=$p(GroupMember,",",i)
		i itm="" continue
		d obj.GroupMember.Insert(itm)
	}
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Date:2018-11-12
/// Description:获取分组sort
ClassMethod GetTransGroupSort(Par As %String) As %String
{
	q:Par="" ""
	s ret=""
	s sort=$o(^DHCNMG.HR.MgNurNormativeGroupI("Sort",Par,""))
	i sort="" s ret=1
	e  s ret=sort+1
	q ret
}

/// Creator:gzj
/// Description:查询行数据
/// Date:2018-11-12
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgNormativeComm","FindTransPlanRows","1","")
Query FindTransPlanRows(Par As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransPlanRowsExecute(ByRef qHandle As %Binary, Par As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$o(^DHCNMG.HR.MgNurNormativeGroupI("Sort",Par,sort)) q:sort=""  d
	.s rw="" f  s rw=$o(^DHCNMG.HR.MgNurNormativeGroupI("Sort",Par,sort,rw)) q:rw=""  d
	..s groupObj=##class(DHCNMG.HR.MgNurNormativeGroup).%OpenId(Par_"||"_rw)
	..s PersonList=""
	..s len=groupObj.GroupMember.Count()
	..f i=1:1:len d
	...s itm=groupObj.GroupMember.GetAt(i)
	...q:itm=""
	...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
	...q:'$IsObject(perObj)
	...i PersonList="" s PersonList=perObj.PerName
	...e  s PersonList=PersonList_","_perObj.PerName
	..s ret1=""
	..s date="" f  s date=$o(^DHCNMG.HR.MgNurNormativeDateI("Plan",Par,date)) q:date=""  d
	...s dateRw="" f  s dateRw=$o(^DHCNMG.HR.MgNurNormativeDateI("Plan",Par,date,dateRw)) q:dateRw=""  d
	....s dateObj=##class(DHCNMG.HR.MgNurNormativeDate).%OpenId(Par_"||"_dateRw)
	....q:'$IsObject(dateObj)
	....s ret1=ret1_"^Time"_Par_"__"_dateRw_"|"
	....s cellData=""
	....s RowID="" f  s RowID=$o(^DHCNMG.HR.MgNurNormalTransSubI("data",Par,Par_"||"_rw,Par_"||"_dateRw,RowID)) q:RowID=""  d
	.....s dataObj=##class(DHCNMG.HR.MgNurNormalTransSub).%OpenId(Par_"||"_RowID)
	.....q:'$IsObject(dataObj)
	.....s WardDesc="",WardID=""
	.....i dataObj.PlanWardDR'="" d
	......s WardDesc=dataObj.PlanWardDR.WardDesc
	......s WardID=dataObj.PlanWardDR.%Id()
	.....s TimePerson=""
	.....i dataObj.PlanPerDR'="" d
	......f j=1:1:dataObj.PlanPerDR.Count() d
	.......s item=dataObj.PlanPerDR.GetAt(j)
	.......q:item=""
	.......s nurseObj=##class(DHCNMG.HR.MgPersons).%OpenId(item)
	.......i TimePerson="" s TimePerson=nurseObj.PerName_"!"_item
	.......e  s TimePerson=TimePerson_"ˇ"_nurseObj.PerName_"!"_item
	......i cellData="" s cellData=WardDesc_"!"_WardID_"@"_TimePerson
	......e  s cellData=cellData_"#"_WardDesc_"!"_WardID_"@"_TimePerson
	....s ret1=ret1_cellData
	..s ret="TransGroup|"_PersonList_"^TransGroupID|"_Par_"__"_rw_"^"_ret1
	..d OutputTransRows
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTransRows
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransPlanRowsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransPlanRowsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTransPlanRowsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransPlanRowsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-11-12
/// Description:查询组内规培生信息
ClassMethod FindGroupNurse(group As %String) As %String
{
	q:group="" ""
	s groupId=$tr(group,"__","||")
	s ret=""
	s obj=##class(DHCNMG.HR.MgNurNormativeGroup).%OpenId(groupId)
	q:'$IsObject(obj) ""
	s count=obj.GroupMember.Count()
	s num=1
	f i=1:1:count
	{
		s itm=obj.GroupMember.GetAt(i)
		i itm="" continue
		s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
		q:'$IsObject(perObj)
		i num=1 s ret="{""PerName"":"""_perObj.PerName_""",""PerDR"":"""_itm_"""}"
		e  s ret=ret_",{""PerName"":"""_perObj.PerName_""",""PerDR"":"""_itm_"""}"
		s num=num+1
	}
	s ret="["_ret_"]"
	q ret
}

ClassMethod GetTransGroupData(Par As %String, row As %String, column As %String) As %String
{
	q:((Par="")!(row="")!(column="")) ""
	s Par=$Tr(Par," ","")
	s row=$tr($tr(row," ",""),"__","||")
	s column=$tr($tr(column," ",""),"__","||")
	s rw=$o(^DHCNMG.HR.MgNurNormalTransSubI("Row",Par,row,column,""))
	q:rw="" ""
	s obj=##class(DHCNMG.HR.MgNurNormalTransSub).%OpenId(Par_"||"_rw)
	q:'$IsObject(obj) ""
	
	q ""
}

/// Creator:gzj
/// Description:查询分组信息
/// Date:2018-11-12
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgNormativeComm","FindTransGroup","2018","")
Query FindTransGroup(Par As %String, row As %String, column As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransGroupExecute(ByRef qHandle As %Binary, Par As %String, row As %String, column As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	
	d OutputTransGroup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTransGroup
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTransGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 
/// 
/// Description:保存时段
ClassMethod SaveTranDate(parr As %String) As %String
{
	q:parr="" 0
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s Par=$tr($g(tmp("PlanDR"))," ","")
	s stDate=$tr($g(tmp("PlanStDate"))," ","")
	s endDate=$tr($g(tmp("PlanEndDate"))," ","")
	q:((stDate="")!(endDate="")) 0
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	
	
	i Par'="" d
	.s rw=$o(^DHCNMG.HR.MgNurNormativeDateI("Plan",Par,stDate,""))
	.i rw'="" s obj=##class(DHCNMG.HR.MgNurNormativeDate).%OpenId(Par_"||"_rw)
	.e  d
	..s obj=##class(DHCNMG.HR.MgNurNormativeDate).%New()
	..s obj.DateParref=##class(DHCNMG.HR.MgNurNormalTrans).%OpenId(Par)
	.s obj.PlanStDate=stDate
	.s obj.PlanEndDate=endDate
	.s sc=obj.%Save()
	.;q:$$$ISOK(sc)
	q 1
}

/// Creator:gzj
/// Description:查询时段列表
/// Date:2018-11-12
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgNormativeComm","FindTransDateList","1","")
Query FindTransDateList(Par As %String, parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTransDateListExecute(ByRef qHandle As %Binary, Par As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s date="" f  s date=$o(^DHCNMG.HR.MgNurNormativeDateI("Plan",Par,date)) q:date=""  d
	.s rw="" f  s rw=$o(^DHCNMG.HR.MgNurNormativeDateI("Plan",Par,date,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgNurNormativeDate).%OpenId(Par_"||"_rw)
	..q:'$IsObject(obj)
	..i obj.PlanStDate'="" s PlanStDate=$zd(obj.PlanStDate,3)
	..e  s PlanStDate=""
	..i obj.PlanEndDate'="" s PlanEndDate=$zd(obj.PlanEndDate,3)
	..e  s PlanEndDate=""
	..s ret="PlanStDate|"_PlanStDate_"^PlanEndDate|"_PlanEndDate_"^Par|"_Par_"^RowID|"_rw_"^TimeCode|Time"_Par_"__"_rw_"^TimeDesc|"_PlanStDate_"至"_PlanEndDate
	..d OutputDateList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDateList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTransDateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransDateListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTransDateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransDateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-11-12
/// Description:保存规培生轮转子表
ClassMethod SaveTransSub(parr As %String) As %String
{
	q:parr="" 0
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s Par=$tr($g(tmp("Par"))," ","")
	s rw=$tr($g(tmp("rw"))," ","")
	s PlanGroupDR=$tr($tr($g(tmp("PlanGroupDR"))," ",""),"__","||")
	s PlanTimeDR=$tr($tr($g(tmp("PlanTimeDR"))," ",""),"__","||")
	s PlanWardDR=$tr($g(tmp("PlanWardDR"))," ","")
	s PlanPerDR=$tr($g(tmp("PlanPerDR"))," ","")
	s len=$l(PlanPerDR,",")
	i Par'=""
	{
		i rw="" d
		.s obj=##class(DHCNMG.HR.MgNurNormalTransSub).%New()
		.s obj.Parref=##class(DHCNMG.HR.MgNurNormalTrans).%OpenId(Par)
		e  s obj=##class(DHCNMG.HR.MgNurNormalTransSub).%OpenId(Par_"||"_rw)
		s obj.PlanGroupDR=##class(DHCNMG.HR.MgNurNormativeGroup).%OpenId(PlanGroupDR)
		s obj.PlanTimeDR=##class(DHCNMG.HR.MgNurNormativeDate).%OpenId(PlanTimeDR)
		s obj.PlanWardDR=##class(DHCNMG.DB.MgWard).%OpenId(PlanWardDR)
		d obj.PlanPerDR.Clear()
		f i=1:1:len
		{
			s itm=$p(PlanPerDR,",",i)
			i itm="" continue
			d obj.PlanPerDR.Insert(itm)
		}
		s sc=obj.%Save()
		
	}
	
	q 1
}

ClassMethod Test(itm) As %String
{
	s NurseHighAcade="",NurseDegree=""
	s educateDate=$o(^DHCNMG.HR.MgEducateI("flag",itm,""),-1)
	i educateDate'="" d
	.s educateRw=$o(^DHCNMG.HR.MgEducateI("flag",itm,educateDate,""),-1)
	.i educateRw'="" d
	..s educateObj=##class(DHCNMG.HR.MgEducate).%OpenId(educateRw)
	..q:'$IsObject(educateObj)
	..q:educateObj.EduStatus'="A"
	..s NurseHighAcade=educateObj.EduAcademic
	..s NurseDegree=educateObj.EduDegree
	q NurseHighAcade_"^"_NurseDegree
}

}
