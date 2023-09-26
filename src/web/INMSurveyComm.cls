/// Creator:liwenzhen
/// Descriptions:护理调查
/// Date:2020-07-17
Class web.INMSurveyComm Extends %RegisteredObject
{

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:根据筛选条件查找人
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindPersonByType","^护士层级^19||1^","",0,0)
Query FindPersonByType(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonByTypeExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("parrpersonlist")=parr_"%"_input_"%"_role_"%"_nurseid
	s ward=$P(parr,"^",1)
	s searchType=$P(parr,"^",2)
	s searchRange=$P(parr,"^",3)
	s searchRange=$LFS(searchRange,",")
	s perType="",duty="",hire="",level=""
	s:searchType="人员类型" perType=searchRange
	s:searchType="职务" duty=searchRange
	s:searchType="聘任职称" hire=searchRange
	s:searchType="护士层级" level=searchRange
	s input=$zcvt(input,"U")
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perDr="" f  s perDr=$O(^CF.DHCINM.HR.PersonsD(perDr)) q:perDr=""  d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perDr)
	.q:(perType'="")&&($LF(perType,perObj.PerTypeDR)=0)
	.s curWard=##class(web.INMHRComm).GetCurrentWard(perDr,+$h)
	.q:(isAll=0)&&((curWard="")||('$d(tmpWard(curWard))))
	.s:curWard="" curWard=perObj.PerDepDR
	.q:((ward'="")&&(ward'=curWard))
	.s leaveDate=perObj.PerStateDate //离职或退休日期
	.q:(leaveDate'="")&&(leaveDate<=+$h)
	.s perDuty=##class(web.INMHRComm).GetNurseDuty(perDr)
	.q:(duty'="")&&($LF(duty,$p(perDuty,"^",1))=0)
	.s perHire=##class(web.INMHRComm).GetNurseHireDuty(perDr)
	.q:(hire'="")&&($LF(hire,$p(perHire,"^",1))=0)
	.s perLevel=##class(web.INMHRComm).GetNurseLevel(perDr)
	.q:(level'="")&&($LF(level,$p(perLevel,"^",1))=0)
	.s dutyDesc=$p(perDuty,"^",2)
	.s hireDesc=$p(perHire,"^",2)
	.s levelDesc=$p(perLevel,"^",2)
	.s wardDesc=""
	.i curWard'="" d
	..s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(curWard)
	..s:$IsObject(wardObj) wardDesc=wardObj.WardDesc
	.s perId=perObj.PerID
	.i perId="" s perId=perObj.PerNo
	.s perName=perObj.PerName
	.s perShort=##class(web.INMVueComm).ToChineseSpell(perName)
	.q:(input'="")&&(perName'[input)&&(perId'[input)&&(perShort'[input)
	.s ret="PerDr|"_perDr_"^PerID|"_perId_"^PerName|"_perName_"^perward|"_curWard_"^WardDesc|"_wardDesc
	.s ret=ret_"^HireDesc|"_hireDesc_"^LevelDesc|"_levelDesc_"^DutyDesc|"_dutyDesc
	.d OutPersons
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-07-23
/// Description:根据病区权限获取HIS病区
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindHISWard","2","",0,0)
Query FindHISWard(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHISWardExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp="",ret=""
	s tmpWard=""
	s surveyWard=""
	i parr'=""  d
	.s surObj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(parr)
	.f i=1:1:surObj.SurveyWard.Count()  d
	..s row=surObj.SurveyWard.GetAt(i)
	..i surveyWard="" d
	...s surveyWard=row
	..e  d
	...s surveyWard=surveyWard_","_row
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s Sort="" f  s Sort=$O(^CF.DHCINM.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s id="" f  s id=$O(^CF.DHCINM.DB.MgWardI("Sort",Sort,id)) q:id=""  d
	..q:(isAll=0)&&('$d(tmpWard(id)))
	..s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(id)
	..q:(obj.WardStDate'="")&&(obj.WardStDate>+$h) 
	..q:(obj.WardEndDate'="")&&(obj.WardEndDate<+$h) 
	..q:obj.CTLocDR=""
	..q:(surveyWard'="")&&((","_surveyWard_",")'[(","_id_","))
	..s ret="rw|"_id_"^CTLocDR|"_obj.CTLocDR.%Id()
	..i obj.CTLocDR.CTLOCDesc["-" s ret=ret_"^CTLocDesc|"_$P(obj.CTLocDR.CTLOCDesc,"-",2)
	..e  s ret=ret_"^CTLocDesc|"_obj.CTLocDR.CTLOCDesc
	..s ret=ret_"^WardDesc|"_obj.WardDesc
	..s tmp(Sort)=ret
	s Sort="" f  s Sort=$o(tmp(Sort)) q:Sort=""  d
	.s ret=tmp(Sort)
	.d OutWard
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-07-23
/// Description:根据病区权限获取HIS病区
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindBedListByWard","3")
Query FindBedListByWard(ward As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindBedListByWardExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp="",ret=""
	i ward="" {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	i wardobj.CTLocDR="" {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK 
	}
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	i pacward="" {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
#;	s subid=0 f  s subid=$O(^PAWARD(pacward,"BED",subid)) q:subid=""  d
#;	.s bedid=pacward_"__"_subid
#;	.s bedcode=$P(^PAWARD(pacward,"BED",subid),"^",1)
#;	.s ret="BedCode|"_bedcode_"^rw|"_bedid
#;	.d OutBed
	s room="" f  s room=$o(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	.s episodeId=0 f  s episodeId=$o(^PAADMi("CurrWard",pacward,room,episodeId)) q:(episodeId="")  d
	..s regId=$p(^PAADM(episodeId),"^",1)
	..s bedDR=$p(^PAADM(episodeId),"^",73)
	..s bedcode=""
	..s:bedDR'="" bedcode=$P(^PAWARD(pacward,"BED",$P(bedDR,"||",2)),"^",1)
	..s patName=$p(^PAPER(regId,"ALL"),"^",1)
	..;s:bedcode'="" patName=patName_"("_bedcode_")"
	..s ret="EpisodeId|"_episodeId_"^PatName|"_patName_"^BedNumber|"_bedcode
	..d OutBed
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutBed
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-07-23
/// Description:根据病区床号获取病人姓名
/// Input:
/// Output:
/// Other:
/// Test:w ##class(web.INMSurveyComm).GetPatName("1","4__2")
ClassMethod GetPatName(ward As %String, bedId As %String) As %String
{
	s patName="" 
	q:(ward="")||(bedId="") patName
	s bedId=$tr(bedId,"__","||")
	s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	q:wardobj.CTLocDR="" patName
	s loc=wardobj.CTLocDR.%Id()
	s pacWard=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	q:pacWard="" patName
	s flag=0
	s room="" f  s room=$o(^PAADMi("CurrWard",pacWard,room)) q:room=""  d
	.s episodeId=0 f  s episodeId=$o(^PAADMi("CurrWard",pacWard,room,episodeId)) q:(episodeId="")||(flag=1)  d
	..s regId=$p(^PAADM(episodeId),"^",1)
	..s bedDR=$p(^PAADM(episodeId),"^",73)
	..q:bedId'=bedDR
	..s patName=$p(^PAPER(regId,"ALL"),"^",1)
	..s flag=1
	q patName
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:保存调查任务发布
/// Input:
/// Output:
/// Other: w ##class("web.INMSurveyComm").SaveSurveyRelease("QuesTypeDesc|单选^QuesDesc|轮转科室是否有认真组织考试^QuesType|S^WriteTips|无^QuesOption|是」1」」「否」2」」^IsRequired|^JumpType|G^ArrangeType|H^RowId|^Parref|1")
ClassMethod SaveSurveyRelease(parr As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("RowId"))
	s ret=""
	i rw="" d
	.s obj=##class(DHCINM.Survey.MgSurveyRelease).%New()
	.s obj.Status="N"
	e  d
	.s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(rw)
	s className="DHCINM.Survey.MgSurveyRelease"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:p="SurveyPerson"
	.q:p="SurveyWard"
	.s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	.q:'$d(tmp(p))
	.s value=$zcvt($tr(tmp(p)," ",""),"U")
	.i ((ptype="date")&&(value'="")) d
	..s value=$zdh(value,3)
	.s $ZOBJPROPERTY(obj,p)=value
	s SurveyPerson=$g(tmp("SurveyPerson"))
	d obj.SurveyPerson.Clear()
	f i=1:1:$L(SurveyPerson,"「") d
	.s itm=$P(SurveyPerson,"「",i)
	.q:itm=""
	.d obj.SurveyPerson.Insert(itm)
	s SurveyWard=$g(tmp("SurveyWard"))
	d obj.SurveyWard.Clear()
	f i=1:1:$L(SurveyWard,",") d
	.s itm=$P(SurveyWard,",",i)
	.q:itm=""
	.d obj.SurveyWard.Insert(itm)
	s sc=obj.%Save()
	q sc
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:查询调查发布
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSurveyRelease","F^^^^","",0,0)
Query FindSurveyRelease(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyReleaseExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s releaseType=$p(parr,"^",1)
	s stDate=$p(parr,"^",2)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate'="" endDate=$zdh(endDate,3)
	s statusSearch=$p(parr,"^",4)
	s status="" f  s status=$o(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_releaseType,status)) q:status=""  d
	.q:(statusSearch'="")&&(statusSearch'=$replace(status," ",""))
	.s surStDate="" f  s surStDate=$o(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_releaseType,status,surStDate),-1) q:surStDate=""  d
	..q:(endDate<surStDate)&&(endDate'="")
	..s id="" f  s id=$O(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_releaseType,status,surStDate,id)) q:id=""  d	
	...s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(id)
	...q:'$IsObject(obj)
	...s SurveyTitle=obj.SurveyTitle
	...s SurveyContent=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),4)
	...s TotalScore=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),10)
	...s Explain=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),8)
	...s EndDate=obj.EndDate
	...q:(EndDate'="")&&(stDate>EndDate)&&(stDate'="")
	...s StDate=$zd(surStDate,3)
	...s:EndDate'="" EndDate=$zd(EndDate,3)
	...s Status=obj.Status
	...s StatusDesc=$case(obj.Status,"N":"已保存","Y":"已发布",:"")
	...s ret="RowId|"_id
	...s ret=ret_"^SurveyTitle|"_SurveyTitle_"^SurveyContent|"_SurveyContent_"^StDate|"_StDate_"^EndDate|"_EndDate
	...s ret=ret_"^TotalScore|"_TotalScore_"^Status|"_Status_"^StatusDesc|"_StatusDesc_"^SurveyDR|"_obj.SurveyContent
	...s ret=ret_"^Explain|"_Explain
	...d OutRelease
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRelease
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description: 发布护士调查任务
/// Date: 2020-07-17
/// Creator: liwenzhen
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSurveyComm).ReleaseNurseSurvey("1")
ClassMethod ReleaseNurseSurvey(rowId As %String = "") As %String
{
	q:rowId="" 0
	s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(rowId)
	q:'$IsObject(obj) 0
	s obj.Status="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除调查发布
/// Date: 2020-07-17
/// Creator: liwenzhen
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSurveyComm)DeleteSurveyRelease(1)
ClassMethod DeleteSurveyRelease(rowId As %String = "") As %String
{
	q:rowId="" 0
	s sc=##class(DHCINM.Survey.MgSurveyRelease).%DeleteId(rowId)
	q $$$ISOK(sc)
}

/// Creator:liwenzhen
/// Createdate:2020-07-19
/// Description:获取护士调查发布(弃用)
/// Input:rowId
/// Output:
/// Other: d ##class(web.INMSurveyComm).GetSurveyRelease("3")
ClassMethod GetSurveyRelease(rowId As %String = "") As %String
{
	
	s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(rowId)
	q:'$IsObject(obj) 0
	s SurveyTitle=obj.SurveyTitle
	s SurveyContent=obj.SurveyContent
	s StDate=$zd(obj.StDate,3)
	s EndDate=""
	s Status=obj.Status
	s:obj.EndDate'="" EndDate=$zd(obj.EndDate,3)
	s Remarks=obj.Remarks
	w "[{""RowId"":"""_rowId_""",""SurveyTitle"":"""_SurveyTitle_""",""SurveyContent"":"""_SurveyContent_""","
	w """StDate"":"""_StDate_""",""EndDate"":"""_EndDate_""",""Remarks"":"""_Remarks_""",""Status"":"""_Status_""","
	w """SurveyPerson"":["
	f i=1:1:obj.SurveyPerson.Count()  d
	.s Per=obj.SurveyPerson.GetAt(i)
	.s PerName=$lg(^CF.DHCINM.HR.PersonsD(Per),2)
	.s perward=##class(web.INMHRComm).GetCurrentWard(Per,+$h)
	.s WardDesc=""
	.i perward'="" d
	..s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(perward)
	..s:$IsObject(WardObj) WardDesc=WardObj.WardDesc
	.s DutyDesc=$p(##class(web.INMHRComm).GetNurseDuty(Per),"^",2)
	.s HireDesc=$p(##class(web.INMHRComm).GetNurseHireDuty(Per),"^",2)
	.s LevelDesc=$p(##class(web.INMHRComm).GetNurseLevel(Per),"^",2)
	.w "{""PerDR"":"""_Per_""",""PerName"":"""_PerName_""""
	.w ",""WardDesc"":"""_WardDesc_""",""DutyDesc"":"""_DutyDesc_""""
	.w ",""LevelDesc"":"""_LevelDesc_""",""HireDesc"":"""_HireDesc_"""}"
	.i i'=obj.SurveyPerson.Count() w ","
	w "]}]"
	q ""
}

/// Description: 获取护士调查提交情况
/// Date: 2020-07-17
/// Creator: liwenzhen
/// Input: perId：护士人员Id rowId：调查发布Id
/// Output: N：未提交 Y：已提交 ^调查表Id 
/// Other: w ##class(web.INMSurveyComm).GetSubmitStatus("2","6")
ClassMethod GetSubmitStatus(perId As %String = "", rowId As %String = "") As %String
{
	s status="A"
	s id=$o(^DHCINM.Survey.MgFormI("per"," "_rowId," "_perId,""))
	s date=""
	i id'="" d
	.s status=$lg($g(^DHCINM.Survey.MgFormD(id)),12)
	.s:status="" status="A"
	.s date=$lg($g(^DHCINM.Survey.MgFormD(id)),13)
	.s:date'="" date=$zd(date,3)
	q status_"^"_id_"^"_date
}

/// Creator:liwenzhen
/// Createdate:2020-07-19
/// Description:获取患者调查
/// Input:
/// Output:
/// Other:w ##class(web.INMSurveyComm).GetPatientSurvey("7")
ClassMethod GetPatientSurvey(rowId As %String) As %String
{
	s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(rowId)
	q:'$IsObject(obj) ""
	s ret="RowId|"_rowId
	s customKey=$LB("SurveyWard","SurveyPerson")
	s className="DHCINM.Survey.MgSurveyRelease"
	s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	.q:p["%"
	.q:p="ChildSub"
	.q:p="Parref"
	.q:($LF(customKey,p)>0)
	.s value=$ZOBJPROPERTY(obj,p)
	.s ptype=$g(^oddCOM(className,"a",p,"P","XSDTYPE"))
	.i ((ptype="date")&&(value'="")) d
	..s value=##class(web.INMHISComm).DateLogicalToHtml(value)
	.i ((ptype="time")&&(value'="")) d
	..s value=$zt(value)
	.s ret=ret_"^"_p_"|"_value
	s SurveyWard=""
	f i=1:1:obj.SurveyWard.Count()  d
	.s rowData=obj.SurveyWard.GetAt(i)
	.q:rowData=""
	.i SurveyWard="" d
	..s SurveyWard=rowData
	.e  d
	..s SurveyWard=SurveyWard_","_rowData
	s ret=ret_"^SurveyWard|"_SurveyWard
	q ret
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:查询调查发布
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindNurseSurveyWrite","N^^^^","",0,2)
Query FindNurseSurveyWrite(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseSurveyWriteExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s releaseType=$p(parr,"^",1)
	s stDate=$p(parr,"^",2)
	s endDate=$p(parr,"^",3)
	i stDate["-" d
	.s stDate=$zdh(stDate,3)
	e  s stDate=""
	i endDate["-" d
	.s endDate=$zdh(endDate,3)
	e  s endDate=""
	s status=$p(parr,"^",4)
	s:nurseid'="0" nurseid=$lg(^CF.DHCINM.DB.MgUserD(nurseid),5)
	s surStDate="" f  s surStDate=$o(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_releaseType," Y",surStDate)) q:surStDate=""  d
	.q:surStDate>+$h
	.s id="" f  s id=$O(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_releaseType," Y",surStDate,id)) q:id=""  d	
	..s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(id)
	..q:'$IsObject(obj)
	..s StDate=obj.StDate
	..s EndDate=obj.EndDate
	..q:(EndDate'="")&&(EndDate<+$h)
	..q:(StDate'="")&&(endDate<StDate)&&(endDate'="")
	..q:(EndDate'="")&&(stDate>EndDate)&&(stDate'="")
	..q:(obj.SurveyPerson.Find(nurseid)<0)&&(nurseid'=0)
	..s SurveyTitle=obj.SurveyTitle
	..s SurveyContent=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),4)
	..s Remarks=obj.Remarks
	..s StDate=##class(websys.Conversions).DateLogicalToHtml(StDate)
	..s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	..s SurveyDR=obj.SurveyContent
	..f i=1:1:obj.SurveyPerson.Count()  d
	...s Per=obj.SurveyPerson.GetAt(i)
	...q:(nurseid'=0)&&(nurseid'=Per)
	...s PerName=$lg(^CF.DHCINM.HR.PersonsD(Per),2)
	...s PerID=$lg(^CF.DHCINM.HR.PersonsD(Per),3) //工号
	...s PerWardDr=$lg(^CF.DHCINM.HR.PersonsD(Per),10) //病区
	...s WardDesc=$lg(^CF.DHCINM.DB.MgWardD(PerWardDr),4)
	...s submit=..GetSubmitStatus(Per,id)
	...s SubmitStatus=$p(submit,"^",1)
	...q:(status'="")&&(status'=SubmitStatus)
	...s Explain=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),8)
	...s TotalScore=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),10)
	...s rw=""
	...s:SubmitStatus'="A" rw=$p(submit,"^",2)
	...i rw'=""  d
	....s TotalScore=$lg($g(^DHCINM.Survey.MgFormD(rw)),11)
	....s Explain=$lg($g(^DHCINM.Survey.MgFormD(rw)),17)
	...s StatusDesc=$case(SubmitStatus,"Y":"已提交","N":"已保存","A":"未填写",:"")
	...s ret="RowId|"_rw
	...s ret=ret_"^SurveyTitle|"_SurveyTitle_"^SurveyContent|"_SurveyContent_"^StDate|"_StDate
	...s ret=ret_"^EndDate|"_EndDate_"^Status|"_SubmitStatus_"^StatusDesc|"_StatusDesc_"^Remarks|"_Remarks
	...s ret=ret_"^SurveyPerson|"_Per_"^PerName|"_PerName_"^SurveyDR|"_SurveyDR_"^PerID|"_PerID
	...s ret=ret_"^WardDR|"_PerWardDr_"^WardDesc|"_WardDesc_"^ReleaseDR|"_id_"^TotalScore|"_TotalScore
	...s ret=ret_"^Explain|"_Explain
	...d OutRelease
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRelease
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-07-22
/// Description:保存调查填写
/// Input:
/// Output:
/// Other: w ##class("web.INMSurveyComm").SaveSurveyForm("WardDR|3^FollowUpDate|^SurveyPerson|457^SurveyDR|2^ReleaseDR|1^IsCount|^TotalScore|^RowId|16^FollowUpStatus|随访完成^Creater|0^Type|F^Status|N")
ClassMethod SaveSurveyForm(parr As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("RowId"))
	s ret=""
	i rw="" d
	.s obj=##class(DHCINM.Survey.MgForm).%New()
	.s className="DHCINM.Survey.MgForm"
	.s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	..q:p["%"
	..q:p="ChildSub"
	..q:p="Parref"
	..q:p="Situation"
	..s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	..q:'$d(tmp(p))
	..s value=$zcvt($tr(tmp(p)," ",""),"U")
	..i ((ptype="date")&&(value'="")) d
	...s value=$zdh(value,3)
	..s $ZOBJPROPERTY(obj,p)=value
	..d obj.Situation.Clear()
	..f i=1:1:$l($g(tmp("Situation")),"「") d
	...s Situation=$p($g(tmp("Situation")),"「",i)
	...q:Situation=""
	...d obj.Situation.Insert(Situation)
	e  d
	.s obj=##class(DHCINM.Survey.MgForm).%OpenId(rw)
	.s obj.Status=$g(tmp("Status"))
	.s obj.TotalScore=$g(tmp("TotalScore"))
	.i $g(tmp("Type"))="P" d
	..s obj.SurveyPerson=$g(tmp("SurveyPerson"))
	..s obj.BedNumber=$g(tmp("BedNumber"))
	..s obj.WardDR=$g(tmp("WardDR"))
	.i $g(tmp("Type"))="F" d
	..s:$g(tmp("FollowUpDate"))'="" obj.FollowUpDate=$zdh($g(tmp("FollowUpDate")),3)
	..s obj.FollowUpStatus=$g(tmp("FollowUpStatus"))
	..s obj.FollowUpAnswer=$g(tmp("FollowUpAnswer"))
	s:tmp("Status")="Y" obj.SubmitDate=+$h
	s sc=obj.%Save()
	if $$$ISOK(sc)=0 d
	.s ret="保存失败"
	e  d
	.s ret=obj.%Id()
	q ret
}

/// Creator:liwenzhen
/// Createdate:2020-07-22
/// Description:保存调查填写
/// Input:
/// Output:
/// Other: w ##class("web.INMSurveyComm").SaveSurveyFormSub("QuesTypeDesc|单选^QuesDesc|轮转科室是否有认真组织考试^QuesType|S^WriteTips|无^QuesOption|是」1」」「否」2」」^IsRequired|^JumpType|G^ArrangeType|H^RowId|^Parref|1")
ClassMethod SaveSurveyFormSub(parr As %String, par As %String) As %String
{
	q:parr="" "入参为空"
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s ret=""
	i rw="" d
	.s obj=##class(DHCINM.Survey.MgFormSub).%New()
	.s className="DHCINM.Survey.MgFormSub"
	.s p="" f  s p=$O(^oddCOM(className,"a",p)) q:p=""  d
	..q:p["%"
	..q:p="ChildSub"
	..q:p="Parref"
	..q:p="QuesOption"
	..s ptype=^oddCOM(className,"a",p,"P","XSDTYPE")
	..q:'$d(tmp(p))
	..s value=$g(tmp(p))
	..i ($g(tmp("QuesType"))="多项填空")&&(p="QuesDesc") d
	...s value=$tr(value,"|","_")
	..s:p'="ArrangeType" value=$zcvt($tr(value," ",""),"U")
	..i ((ptype="date")&&(value'="")) d
	...s value=$zdh(value,3)
	..s $ZOBJPROPERTY(obj,p)=value
	.s obj.Parref=##class(DHCINM.Survey.MgForm).%OpenId(par)
	.s QuesOption=$g(tmp("QuesOption"))
	.d obj.QuesOption.Clear()
	.f i=1:1:$L(QuesOption,"「") d
	..s itm=$P(QuesOption,"「",i)
	..q:itm=""
	..d obj.QuesOption.Insert(itm)
	e  d
	.s obj=##class(DHCINM.Survey.MgFormSub).%OpenId(rw)
	.s obj.Answer=tmp("Answer")
	.s obj.AnswerInput=tmp("AnswerInput")
	s sc=obj.%Save()
	q sc
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:查询评价表维护
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSurveyFormSub","14","",0,0)
Query FindSurveyFormSub(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyFormSubExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s parref=$P(parr,"^",1)		
	s ret=""
	s sort="" f  s sort=$o(^DHCINM.Survey.MgFormSubI("parr",parref,sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCINM.Survey.MgFormSubI("parr",parref,sort,id)) q:id=""  d	
	..s obj=$g(^DHCINM.Survey.MgFormSubD(parref,id))
	..q:obj=""
	..s QuesDesc=$lg(obj,2)
	..s QuesType=$lg(obj,3)
	..s WriteTips=$lg(obj,6)
	..s IsRequired=$zcvt($lg(obj,5),"L")
	..s:IsRequired="" IsRequired="false"
	..s JumpType=$lg(obj,7)
	..s ArrangeType=$lg(obj,8)
	..s IsCount=$lg(obj,9)
	..s Answer=$lg(obj,11)
	..s AnswerInput=$lg(obj,20)
	..s QuesOption=""
	..f i=1:1:$ll($lg(obj,10))  d
	...s rowData=$lg($lg(obj,10),i)
	...q:rowData=""
	...i QuesOption="" d
	....s QuesOption=rowData
	...e  d
	....s QuesOption=QuesOption_"「"_rowData
	..s Rules=IsRequired_"」不能为空"
	..s QuesDR=$lg(obj,12)
	..s showFlag=$lg(obj,21)
	..s RelatedObj=$g(^CF.DHCINM.DB.SurveyFormSubD($p(QuesDR,"||",1),$p(QuesDR,"||",2)))
	..s RelatedQues=$lg(RelatedObj,20)
	..s RelatedSub=$lg(RelatedObj,21)
	..s ret="rw|"_parref_"__"_id_"^Answer|"_Answer_"^AnswerInput|"_AnswerInput
	..s ret=ret_"^QuesDesc|"_QuesDesc_"^QuesType|"_QuesType_"^WriteTips|"_WriteTips_"^IsRequired|"_IsRequired
	..s ret=ret_"^QuesOption|"_QuesOption_"^JumpType|"_JumpType_"^ArrangeType|"_ArrangeType_"^IsCount|"_IsCount
	..s ret=ret_"^Rules|"_Rules_"^Sort|"_$lg(obj,4)_"^QuesScore|"_$lg(obj,13)_"^QuesMin|"_$lg(obj,14)_"^QuesMax|"_$lg(obj,16)
	..s ret=ret_"^QuesMinDesc|"_$lg(obj,15)_"^QuesMaxDesc|"_$lg(obj,17)_"^InputHeight|"_$lg(obj,18)_"^InputWidth|"_$lg(obj,19)
	..s ret=ret_"^ShowFlag|"_showFlag_"^QuesDR|"_$tr(QuesDR,"||","__")_"^RelatedQues|"_$tr(RelatedQues,"||","__")_"^RelatedSub|"_RelatedSub
	..d OutSurveyFormSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyFormSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:查询随访调查发布
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindFollowUpSurveyWrite","F^^2019-01-01^2021-01-01^","",0,0)
Query FindFollowUpSurveyWrite(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindFollowUpSurveyWriteExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^tmp("FindFollowUpSurveyWrite")=parr
	;i ($p(parr,"^",3)="")||($p(parr,"^",4)="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s releaseType=$p(parr,"^",1)
	s fStatus=$p(parr,"^",2)
	s stOutDate=$zdh($p(parr,"^",3),3) 
	s endOutDate=$zdh($p(parr,"^",4),3)
	s searchType=$p(parr,"^",5)
	s searchInput=$p(parr,"^",6)
	s searchHosNum="",searchDoctor="",searchNurse="",searchPatName=""
	i searchType="住院号" s searchHosNum=searchInput
	i searchType="主管医生" s searchDoctor=searchInput
	i searchType="病人姓名" s searchPatName=searchInput
	i searchType="主管护士" s searchNurse=searchInput
	s searchWard=$p(parr,"^",7)
	s searchTitle=$p(parr,"^",8)
	s tmpRet=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s surStDate="" f  s surStDate=$o(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_releaseType," Y",surStDate)) q:surStDate=""  d
	.q:surStDate>+$h
	.s id="" f  s id=$O(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_releaseType," Y",surStDate,id)) q:id=""  d	
	..s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(id)
	..q:'$IsObject(obj)
	..s StDate=obj.StDate
	..s EndDate=obj.EndDate
	..q:(EndDate'="")&&(EndDate<+$h)
	..s surveyTitle=obj.SurveyTitle
	..s surveyContent=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),4) 
	..s surveyTitle=obj.SurveyTitle
	..q:(searchTitle'="")&&(searchTitle'=id)
	..;s Remarks=obj.Remarks //备注说明
	..;s:StDate'="" StDate=$zd(StDate,3)
	..;s:EndDate'="" EndDate=$zd(EndDate,3)
	..s surveyWard=""
	..k tmpHIS
	..s tmpHIS=""
	..f i=1:1:obj.SurveyWard.Count()  d
	...s ward=obj.SurveyWard.GetAt(i)
	...q:ward=""
	...q:(isAll=0)&&('$d(tmpWard(ward)))
	...q:(searchWard'="")&&((","_searchWard_",")'[(","_ward_","))
	...s HISWard=$lg(^CF.DHCINM.DB.MgWardD(ward),2) // HIS病区ID
	...q:HISWard=""
	...s wardId=$o(^PAWARD(0,"WARD_LocationDR",HISWard,""))
	...q:wardId=""
	...s tmpHIS(wardId)=ward
	..s outHosDate="" f  s outHosDate=$o(^PAADMi("DischDate",outHosDate)) q:(outHosDate="")||(outHosDate>endOutDate)  d
	...q:outHosDate<stOutDate
	...q:(outHosDate+obj.FStDays)>+$h //出院日期+随访开始天数应大于当前日期
	...q:(outHosDate+obj.FEndDays)<+$h //出院日期+随访结束天数应小于当前日期时
	...s outHosRw="" f  s outHosRw=$o(^PAADMi("DischDate",outHosDate,outHosRw)) q:outHosRw=""  d //就诊号
	....k tmpRet
	....s papmiDr=$P(^PAADM(outHosRw),"^",1) //根据就诊号获取病人ID
	....s patName=$p(^PAPER(papmiDr,"ALL"),"^",1)   //病人姓名
	....q:(searchPatName'="")&&(patName'[searchPatName)
	....s tmpRet("PatName")=patName
	....s hosNum=$P($g(^PAPER(papmiDr,"PAT",1)),"^",22) //住院号
	....s:hosNum="" hosNum=..IGetMrNoByEpisodeID(outHosRw,"O")
	....q:(searchHosNum'="")&&(hosNum'[searchHosNum)
	....s tmpRet("HosNum")=hosNum
	....s doctor=..GetCareDoctor(outHosRw) // 主管医生
	....q:(searchDoctor'="")&&(doctor'[searchDoctor)
	....s tmpRet("Doctor")=doctor
	....s mainNurse=..GetMainNurse(outHosRw) // 主管护士
	....s mainNurse=$p(mainNurse," ")
	....q:(searchNurse'="")&&(mainNurse'[searchNurse)
	....s tmpRet("MainNurse")=mainNurse
	....s currentWardID=$p($g(^PAADM(outHosRw)),"^",70) //获取出院前所在HIS病区
	....q:'$d(tmpHIS(currentWardID))
	....s wardDR=tmpHIS(currentWardID) //病区ID
	....s tmpRet("WardDR")=wardDR
	....s wardDesc=""
	....s:wardDR'="" wardDesc=$lg(^CF.DHCINM.DB.MgWardD(wardDR),4) //病区描述
	....s tmpRet("WardDesc")=wardDesc
	....s totalScore=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),10) //总分初始化
	....s explain=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),8)
	....s situationList=$lg(^CF.DHCINM.DB.SurveyFormD(obj.SurveyContent),11) //未随访情况
	....s followUpAnswer="「" //未随访情况填空
	....s status="A",followUpStatus="A",followUpDate=+$h,createrName="" //初始化
	....s rw=$o(^DHCINM.Survey.MgFormI("per"," "_id," "_outHosRw,"")) //判断表单是否已保存
	....i rw'="" d
	.....s status=$lg($g(^DHCINM.Survey.MgFormD(rw)),12)
	.....s totalScore=$lg($g(^DHCINM.Survey.MgFormD(rw)),11)
	.....s followUpStatus=$lg($g(^DHCINM.Survey.MgFormD(rw)),15)
	.....s followUpDate=$lg($g(^DHCINM.Survey.MgFormD(rw)),16)
	.....s explain=$lg(^DHCINM.Survey.MgFormD(rw),17)
	.....s creater=$lg($g(^DHCINM.Survey.MgFormD(rw)),2)
	.....s createrName=..GetUserName(creater)
	.....s situationList=$lg(^DHCINM.Survey.MgFormD(rw),18)
	.....s followUpAnswer=$lg(^DHCINM.Survey.MgFormD(rw),19)
	....q:(fStatus'="")&&(fStatus'=followUpStatus)
	....s situation=""
	....f i=1:1:$ll(situationList)  d
	.....s rowData=$lg(situationList,i)
	.....q:rowData=""
	.....s:situation'="" situation=situation_"「"_rowData
	.....s:situation="" situation=rowData
	....s statusDesc=$case(status,"Y":"已提交","N":"已保存","A":"未填写",:"")
	....s tmpRet("Status")=status
	....s tmpRet("StatusDesc")=statusDesc //提交状态
	....s tmpRet("FollowUpStatus")=followUpStatus //随访状态
	....s tmpRet("FollowUpStatusDesc")=##class(DHCINM.Survey.MgForm).FollowUpStatusLogicalToDisplay(followUpStatus) //随访状态
	....s tmpRet("FollowUpDate")=$zd(followUpDate,3) //随访日期
	....s tmpRet("TotalScore")=totalScore
	....s tmpRet("CreaterName")=createrName
	....s tmpRet("Explain")=explain
	....s tmpRet("Situation")=situation
	....s tmpRet("FollowUpAnswer")=followUpAnswer
	....d ..GetOutPatInfo(outHosRw,.tmpRet)
	....s tmpRet("BedNumber")=$g(tmpRet("BedCode"))
	....k tmpRet("BedCode")
	....s tmpRet("SurveyDR")=obj.SurveyContent
	....s tmpRet("ReleaseDR")=id
	....s tmpRet("SurveyPerson")=outHosRw //就诊号(被调查人)
	....s tmpRet("SurveyContent")=surveyContent //调查内容
	....s tmpRet("InHosDate")=$zd(..AdmDateTimeInBed(outHosRw),3) //入院日期
	....s tmpRet("OutHosDate")=$zd(outHosDate,3) //出院日期
	....s tmpRet("DischCondit")=..GetDischCondit(outHosRw) //出院转归
	....s tmpRet("SurveyTitle")=surveyTitle
	....s ret="RowId|"_rw
	....s desc="" f  s desc=$o(tmpRet(desc)) q:desc=""  d
	.....s ret=ret_"^"_desc_"|"_$g(tmpRet(desc))
	....d OutFollowup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutFollowup
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 根据病人id获取病人年龄
/// w ##class(web.INMSurveyComm).GetPatAge(50)
ClassMethod GetPatAge(papmiID As %String) As %String
{
	s birthday=$P($g(^PAPER(papmiID,"ALL")),"^",6) //出生日期
	;s:birthday'="" patAge=$e($zd(+$h,3),1,4)-$e($zd(birthday,3),1,4) //年龄
	s patAge=##class(web.INMVueComm).CalAge(birthday,+$h) //年龄
	s years=""
	i +patAge>6 s years=+patAge_"岁"
	e  i +patAge'=0 d
	.i +$P(patAge," ")'=0 s years=years_+$P(patAge," ")_"岁"
	.i +$P(patAge," ",2)'=0 s years=years_+$P(patAge," ",2)_"月"
	.s:years="" years="<1天"
	e  d
	.i +$P(patAge," ",2)'=0 s years=years_+$P(patAge," ",2)_"月"
	.i +$P(patAge," ",3)'=0 s years=years_+$P(patAge," ",3)_"天"
	.s:years="" years="<1天"
	q years
}

/// 根据就诊号获取病人出院转归情况
/// w ##class(web.INMSurveyComm).GetDischCondit(50)
ClassMethod GetDischCondit(EpisodeID As %String) As %String
{
	Set return=""
	Quit:EpisodeID="" return
	Set MRAdmId=$p($g(^PAADM(EpisodeID)),"^",61)
	Quit:MRAdmId="" return
	Set DisConId=$p(^MR(+MRAdmId,"PRO",1),"^",10)
	Set return=$p($g(^PAC("DISCON",+DisConId)),"^",2)
	Quit return
}

/// 根据就诊号获取病人入院日期(分床日期)
/// w ##class(web.INMSurveyComm).AdmDateTimeInBed(50)
ClassMethod AdmDateTimeInBed(EpisodeID As %String) As %String
{
	q:(($d(EpisodeID)=0)||(EpisodeID="")) ""
	
	s TRANSChildsub="",bed="",admdatetime="",admdate="",admtime=""
	s admdatetimeinbed=""

	f  s TRANSChildsub=$o(^PAADM(EpisodeID,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(EpisodeID,"TRANS",TRANSChildsub)),"^",8)
	.q:(bed="")
	.s admdate=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",1)
	.s admtime=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",2)
	s admdatetimeinbed=admdate
	q admdatetimeinbed
}

/// 根据就诊号获取病人最后一次的床号
/// w ##class(web.INMSurveyComm).GetPatientLastBedCode(50)
ClassMethod GetPatientLastBedCode(EpisodeID) As %String
{
	s transID="",bedCode=""
    f  s transID=$o(^PAADM(EpisodeID,"TRANS",transID),-1) q:((transID="")!(bedCode'=""))  d
    .s lastBedDR=$p(^PAADM(EpisodeID,"TRANS",transID),"^",8)
    .q:lastBedDR=""
    .s bedCode=$p(^PAADM(EpisodeID,"TRANS",transID),"^",33)
    .i bedCode="" d
    ..s bedSub=$P(lastBedDR,"||",2)
    ..s ward=$P(lastBedDR,"||",1)
    ..s bedCode=$P($g(^PAWARD(ward,"BED",bedSub)),"^",1)
    q bedCode
}

/// 根据就诊号获取病人第一次诊断
/// w ##class(web.INMSurveyComm).GetPatFirstDiag(50)
ClassMethod GetPatFirstDiag(EpisodeID As %String) As %String
{
	s ^TMP("GetPatFirstDiag")=EpisodeID
	q:EpisodeID="" ""
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s typ1="入院",typ2="初步"
    f a2=1:1:$g(^MR(mradm,"DIA",0))  d
    .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
    .q:icdr="" 
    .s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
    .s diatype=""
    .i $g(diatypedr)'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",2)  ;诊断类型
    .q:(diatype'[typ1)&&(diatype'[typ2)
    .s typ=typ1
    .s:diatype[typ2 typ=typ2
    .s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
    .s:icdcode'="" tmp(typ,a2)=icdcode
    .q:icdcode'=""
    .s MRDIADesc=0 s MRDIADesc=$o(^MR(mradm,"DIA",a2,"DES",MRDIADesc))
    .q:MRDIADesc=""
    .s MRDIADesc=$p(^MR(mradm,"DIA",chl,"DES",MRDIADesc),"^",1)
    .s:MRDIADesc'="" tmp(typ,a2)=MRDIADesc
    s diag=""
    s:$d(tmp(typ1)) diag=tmp(typ1,$O(tmp(typ1,0)))
    s:(diag="")&&($d(tmp(typ2))) diag=tmp(typ2,$O(tmp(typ2,0)))
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
    q diag
}

/// 根据就诊号获取病人的出院诊断
ClassMethod GetOutPDiagnosByEpisodeID(EpisodeID As %String) As %String
{
	q:+EpisodeID=0 ""
	s MRDiagnos="",Num=0
	s INDiaType=$O(^MRC("DTYP",0,"Code","DIS",0)) ;出院诊断
	s mradmId=$p(^PAADM(+EpisodeID),"^",61)
	s mrdiaSub=0
	f  s mrdiaSub=$o(^MR(mradmId,"DIA",mrdiaSub)) Q:(mrdiaSub="")  D
	.s TYPMRCDiagTyp=$p($g(^MR(mradmId,"DIA",mrdiaSub,"TYP",1)),"^",1)
	.q:TYPMRCDiagTyp'=INDiaType
	.s MRDIAICDCodeDR=+$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
	.//Q:MRDIAICDCodeDR=""
	.s MRDiagDesc=$p($g(^MRC("ID",MRDIAICDCodeDR)),"^",2)    /// 诊断描述
	.s MRDiagNotes=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))   /// 诊断注释
	.i MRDiagNotes'="" s MRDiagNotes=""_MRDiagNotes_""
	.s Num=Num+1
	.i MRDiagnos="" d
	..;s MRDiagnos=Num_"、"_MRDiagDesc_MRDiagNotes //有序号
	..s MRDiagnos=MRDiagDesc_MRDiagNotes 
	.e  d
	..;s MRDiagnos=MRDiagnos_"；"_Num_"、"_MRDiagDesc_MRDiagNotes //有序号
	..s MRDiagnos=MRDiagnos_"；"_MRDiagDesc_MRDiagNotes
	q MRDiagnos
}

/// 根据就诊号获取诊断
ClassMethod GetDiagByDoc(EpisodeID, N = "", DiagnosCat = "", DiagnosType = "")
{
	s $zt="Err"
	s rs=""
	s MRAdm=$p(^PAADM(EpisodeID),"^",61)
	s diags=##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	d diags.Execute(MRAdm)
	s index=0
	while diags.Next()
	{
		s index=index+1
		s diagnosCat=diags.GetDataByName("DiagnosCat")
		s diagnosType=diags.GetDataByName("DiagnosType")
		continue:(DiagnosType'="")&(diagnosType'[DiagnosType)
		#;continue:DiagnosCat["中医"
		s DiagnosICDDesc=diags.GetDataByName("DiagnosICDDesc")
		s DiagnosICDDesc=$replace(DiagnosICDDesc,"&nbsp","")
		continue:DiagnosICDDesc=""
		i diagnosType["出院" s diags(1,index,DiagnosICDDesc)=""
		e  s diags(2,index,DiagnosICDDesc)=""
	}
	s diagIndex=$o(diags(""))
	s count=0
	if diagIndex'=""
	{
		s index="" f  s index=$o(diags(diagIndex,index)) q:(index="")!(count=N)  d
		.s diagDesc="" f  s diagDesc=$o(diags(diagIndex,index,diagDesc)) q:(diagDesc="")!(count=N)  d
		..i rs'="" s rs=rs_","_diagDesc
		..e  s rs=diagDesc
		..s count=count+1
	}
	q ##class(ext.util.String).EvalJSON(rs)
Err
	q $ze
}

/// 根据就诊号获取主管医生
ClassMethod GetCareDoctor(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s docdr=$P($g(^PAADM(EpisodeID)),"^",9)
	q:docdr="" ""
	s docname=$P($g(^CTPCP(docdr,1)),"^",2)
	q docname
}

/// 根据就诊号获取病人主管护士
ClassMethod GetMainNurse(episodeID)
{
	s mainNurses=""
	s admExtID=""
	s admExtID=$O(^DHCPAAdm(0,"PAAdm",episodeID,admExtID),-1)
	i admExtID'="" d
	.s mainNurseID=$P($G(^DHCPAAdm(admExtID)),"^",2)
	.i mainNurseID'="" d
	..s mainNurseName=$P($G(^CTPCP(mainNurseID,1)),"^",2)
	..s mainNurses=mainNurseName
	.s nurseID=$P($G(^DHCPAAdm(admExtID)),"^",20)
	.i nurseID'="" d
	..s nurseName=$P($G(^CTPCP(nurseID,1)),"^",2)
	..s mainNurses=mainNurses_" "_nurseName
	q mainNurses
}

/// 根据病人ID获取联系方式
ClassMethod GetTelphone(papmiID)
{
	q:papmiID=""
	s telphone=""
	s handtel=$p($g(^PAPER(papmiID,"PER",4)),"^",21)   //手机
	s telphone=handtel
	q:handtel'="" telphone
	s homeTel=$p($g(^PAPER(papmiID,"PER",1)),"^",11)   //家庭电话
	s telphone=homeTel
	q:homeTel'="" telphone
    s workTel=$p($g(^PAPER(papmiID,"PER",1)),"^",9)    //工作电话
    s telphone=workTel
    q:workTel'="" telphone
    q telphone
}

/// Creator:liwenzhen
/// Createdate:2020-08-08
/// Description:查询调查提交情况
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSurveySubmit","F^1^^^2021-08-01^2021-08-31","",0,0)
Query FindSurveySubmit(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveySubmitExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s surveyType=$p(parr,"^",1)
	s rowId=$p(parr,"^",2)
	s searchWard=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	i rowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(rowId)
	i obj.Status="N" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s SurveyTitle=obj.SurveyTitle
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	i surveyType="N" d
	.f i=1:1:obj.SurveyPerson.Count()  d
	..s ret="",rw=""
	..s per=obj.SurveyPerson.GetAt(i)
	..s perName=$lg(^CF.DHCINM.HR.PersonsD(per),2)
	..s perWard=##class(web.INMHRComm).GetCurrentWard(per,+$h)
	..q:(searchWard'="")&&(searchWard'=perWard)
	..q:(input'="")&&(perName'[input)
	..;s perShort=##class(web.INMVueComm).ToChineseSpell(perName)
	..;q:(input'="")&&(perName'[input)&&(perId'[input)&&(perShort'[input)
	..s wardDesc=""
	..i perWard'="" d
	...s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(perWard)
	...s:$IsObject(wardObj) wardDesc=wardObj.WardDesc
	..s submit=..GetSubmitStatus(per,rowId)
	..s submitStatus=$p(submit,"^",1)
	..q:(status'="")&&(status'=submitStatus)
	..s submitDate=""
	..s:submitStatus="Y" submitDate=$p(submit,"^",3),rw=$p(submit,"^",2)
	..s statusDesc=$case(submitStatus,"Y":"已提交","N":"已保存","A":"未填写",:"")
	..s ret="RowId|"_rw_"^PerDr|"_per_"^PerName|"_perName_"^Ward|"_perWard_"^WardDesc|"_wardDesc
	..s ret=ret_"^Status|"_submitStatus_"^StatusDesc|"_statusDesc_"^SubmitDate|"_submitDate
	..d OutSubmit
	i surveyType="P" d
	.s id="" f  s id=$o(^DHCINM.Survey.MgFormI("releaseDR"," "_rowId,id)) q:id=""  d
	..s obj=##class(DHCINM.Survey.MgForm).%OpenId(id)
	..s SurveyPerson=obj.SurveyPerson
	..q:(input'="")&&(SurveyPerson'[input)
	..s Status=obj.Status
	..q:(status'="")&&(Status'=status)
	..s WardDR=obj.WardDR
	..q:(searchWard'="")&&(WardDR'=searchWard)
	..s PatName=SurveyPerson
	..i PatName?1n.n d
	...s regId=$p(^PAADM(PatName),"^",1)
	...s:regId'="" PatName=$p(^PAPER(regId,"ALL"),"^",1)
	..s BedNumber=obj.BedNumber
	..s Bedcode=""
	..i BedNumber["||" d
	...s Bedcode=$P(^PAWARD(+BedNumber,"BED",$p(BedNumber,"||",2)),"^",1) //床号描述
	..e  d
	...s Bedcode=BedNumber
	..s WardDesc=""
	..s WardDesc=$lg(^CF.DHCINM.DB.MgWardD(WardDR),4)
	..s TotalScore=obj.TotalScore
	..s creater=obj.Creater
	..s perName=$lg($g(^CF.DHCINM.DB.MgUserD(creater)),2)
	..i creater=0  d
	...s perName="超级管理员"
	..;i WardDR'=""  d
	..;s:loc'="" WardDesc=$P(^CTLOC($lg(^CF.DHCINM.DB.MgWardD(WardDR),2)),"^",2) //HIS病区
	..s SubmitDate=""
	..s:obj.SubmitDate'="" SubmitDate=$zd(obj.SubmitDate,3)
	..s StatusDesc=$case(Status,"Y":"已提交","N":"已保存",:"")
	..s ret="RowId|"_id_"^SurveyPerson|"_SurveyPerson_"^WardDR|"_WardDR_"^WardDesc|"_WardDesc_"^TotalScore|"_TotalScore
	..s ret=ret_"^Status|"_Status_"^StatusDesc|"_StatusDesc_"^SubmitDate|"_SubmitDate_"^BedNumber|"_$tr(BedNumber,"||","__")
	..s ret=ret_"^Bedcode|"_Bedcode_"^SurveyDR|"_obj.SurveyDR_"^ReleaseDR|"_obj.ReleaseDR_"^CreaterName|"_perName
	..s ret=ret_"^Explain|"_obj.Explain_"^SurveyTitle|"_SurveyTitle_"^PatName|"_PatName
	..d OutSubmit
	i surveyType="F" d
	.k tmpHIS
	.s tmpHIS=""
	.s tmpRet=""
	.s stOutDate="",endOutDate=""
	.s:$p(parr,"^",5)["-" stOutDate=$zdh($p(parr,"^",5),3) 
	.s:$p(parr,"^",6)["-" endOutDate=$zdh($p(parr,"^",6),3)
	.f i=1:1:obj.SurveyWard.Count()  d
	..s ward=obj.SurveyWard.GetAt(i)
	..q:ward=""
	..q:(isAll=0)&&('$d(tmpWard(ward)))
	..q:(searchWard'="")&&(searchWard'=ward)
	..s HISWard=$lg(^CF.DHCINM.DB.MgWardD(ward),2) // HIS病区ID
	..q:HISWard=""
	..s wardId=$o(^PAWARD(0,"WARD_LocationDR",HISWard,""))
	..q:wardId=""
	..s tmpHIS(wardId)=ward
	.s outHosDate="" f  s outHosDate=$o(^PAADMi("DischDate",outHosDate)) q:outHosDate=""  d
	..q:((stOutDate'="")&&(outHosDate<stOutDate))
	..q:((endOutDate'="")&&(outHosDate>endOutDate))
	..q:(outHosDate+obj.FStDays)>+$h //出院日期+随访开始天数应大于当前日期
	..q:(outHosDate+obj.FEndDays)<+$h //出院日期+随访结束天数应小于当前日期时
	..s outHosRw="" f  s outHosRw=$o(^PAADMi("DischDate",outHosDate,outHosRw)) q:outHosRw=""  d //就诊号
	...k tmpRet
	...s papmiDr=$P(^PAADM(outHosRw),"^",1) //根据就诊号获取病人ID
	...s patName=$p(^PAPER(papmiDr,"ALL"),"^",1)   //病人姓名
	...q:(input'="")&&(patName'[input)
	...s tmpRet("PatName")=patName
	...s currentWardID=$p($g(^PAADM(outHosRw)),"^",70) //获取出院前所在HIS病区
	...q:'$d(tmpHIS(currentWardID))
	...s wardDR=tmpHIS(currentWardID) //病区ID
	...s tmpRet("Ward")=wardDR
	...s wardDesc=""
	...s:wardDR'="" wardDesc=$lg(^CF.DHCINM.DB.MgWardD(wardDR),4) //病区描述
	...s tmpRet("WardDesc")=wardDesc
	...s submitStatus="A",followUpStatus="A",followUpDate="",submitDate="" //初始化
	...s rw=$o(^DHCINM.Survey.MgFormI("per"," "_rowId," "_outHosRw,"")) //判断表单是否已保存
	...s:rw'="" submitStatus=$lg($g(^DHCINM.Survey.MgFormD(rw)),12)
	...q:(status'="")&&(status'=submitStatus)
	...i rw'="" d
	....s submitStatus=$lg($g(^DHCINM.Survey.MgFormD(rw)),12)
	....s followUpStatus=$lg($g(^DHCINM.Survey.MgFormD(rw)),15)
	....s followUpDate=$lg($g(^DHCINM.Survey.MgFormD(rw)),16)
	....s:followUpDate'="" followUpDate=$zd(followUpDate,3)
	....s submitDate=$lg($g(^DHCINM.Survey.MgFormD(rw)),13)
	....s:submitDate'="" submitDate=$zd(submitDate,3)
	....s sort="" f  s sort=$o(^DHCINM.Survey.MgFormSubI("parr",rw,sort)) q:sort=""  d
	.....s subId="" f  s subId=$o(^DHCINM.Survey.MgFormSubI("parr",rw,sort,subId)) q:subId=""  d
	......s QuesDR=$tr($lg(^DHCINM.Survey.MgFormSubD(rw,subId),12),"||","__")
	......s tmpRet("QuesDR"_QuesDR)=..GetAnswerDesc(rw,subId)
	...s tmpRet("FollowUpStatusDesc")=##class(DHCINM.Survey.MgForm).FollowUpStatusLogicalToDisplay(followUpStatus) //随访状态
	...s tmpRet("Status")=status
	...s tmpRet("FollowUpDate")=followUpDate
	...s tmpRet("SubmitDate")=submitDate
	...s statusDesc=$case(submitStatus,"Y":"已提交","N":"已保存","A":"未填写",:"")
	...s tmpRet("StatusDesc")=statusDesc
	...s hosNum=$P($g(^PAPER(papmiDr,"PAT",1)),"^",22) //住院号
	...s tmpRet("HosNum")=hosNum
	...s tmpRet("OutHosDate")=$zd(outHosDate,3)
	...d ..GetOutPatInfo(outHosRw,.tmpRet)
	...s ret="RowId|"_rw
	...s desc="" f  s desc=$o(tmpRet(desc)) q:desc=""  d
	....s ret=ret_"^"_desc_"|"_$g(tmpRet(desc))
	...d OutSubmit
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSubmit
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-08-08
/// Description:查询调查提交情况
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSurveyColumns","5^5")
Query FindSurveyColumns(parr As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyColumnsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s surveyDR=$p(parr,"^",1)
	s rowId=$p(parr,"^",2)
	i (rowId="")||(surveyDR="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(rowId)
	i obj.Status="N" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s sort="" f  s sort=$o(^CF.DHCINM.DB.SurveyFormSubI("sortStatus",surveyDR,sort)) q:sort=""  d
	.s subId="" f  s subId=$o(^CF.DHCINM.DB.SurveyFormSubI("sortStatus",surveyDR,sort," Y",subId)) q:subId=""  d
	..s QuesDesc=$lg(^CF.DHCINM.DB.SurveyFormSubD(surveyDR,subId),2)
	..s QuesType=$lg(^CF.DHCINM.DB.SurveyFormSubD(surveyDR,subId),3)
	..s:QuesType="多项填空" QuesDesc=$replace(QuesDesc,"_","")
	..s ret="code|"_"QuesDR"_surveyDR_"__"_subId_"^desc|"_QuesDesc
	..d OutColumns
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutColumns
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2020-11-11
/// Description:获取答案描述
/// Input:
/// Output:
/// Other:
/// Test:w ##class(web.INMSurveyComm).GetAnswerDesc("39","2")
ClassMethod GetAnswerDesc(surveyDR As %String = "", subId As %String = "")
{
	q:(surveyDR="")||(subId="") ""
	s surveySub=^DHCINM.Survey.MgFormSubD(surveyDR,subId)
	s Answer=$lg(surveySub,11)
	q:Answer="" ""
	s QuesType=$lg(surveySub,3)
	s:QuesType="多项填空" Answer=$tr(Answer,"「","，")
	s:QuesType="时间" Answer=$tr(Answer,"-",":")
	q:(QuesType'="单选")&&(QuesType'="多选") Answer
	s QuesOption=$lg(surveySub,10)
	s AnswerDesc=""
	s flag=0
	f m=1:1:$ll(QuesOption) q:flag=1  d
	.s index=$p($lg(QuesOption,m),"」",5)
	.f i=1:1:$l(Answer,"「") d
	..s choose=$p(Answer,"「",i)
	..i choose=index d
	...s:AnswerDesc'="" AnswerDesc=AnswerDesc_","_$p($lg(QuesOption,m),"」",1)
	...s:AnswerDesc="" AnswerDesc=$p($lg(QuesOption,m),"」",1)
	...s:QuesType="单选" flag=1
	q AnswerDesc
}

/// Test:w ##class(web.INMSurveyComm).MoveSurveyData()
ClassMethod MoveSurveyData()
{
	s id="" f  s id=$o(^DHCINM.Survey.MgFormSubI("parr",id)) q:id=""  d
	.s sort=""  f  s sort=$o(^DHCINM.Survey.MgFormSubI("parr",id,sort)) q:sort=""  d
	..s subId="" f  s subId=$o(^DHCINM.Survey.MgFormSubI("parr",id,sort,subId)) q:subId=""  d
	...s ^DHCINM.Survey.MgFormSubD(id,subId)=^DHCINM.Survey.MgSurveyFormSubD(id,subId)
	q 1
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:查询评价表维护
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSurveyTitle","F","",0,0)
Query FindSurveyTitle(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyTitleExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s surveyType=$P(parr,"^",1)		
	s ret=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s surStDate="" f  s surStDate=$o(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_surveyType," Y",surStDate)) q:surStDate=""  d
	.q:surStDate>+$h
	.s id="" f  s id=$O(^DHCINM.Survey.MgSurveyReleaseI("typeStDate"," "_surveyType," Y",surStDate,id)) q:id=""  d	
	..s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(id)
	..q:'$IsObject(obj)
	..s EndDate=obj.EndDate
	..q:(EndDate'="")&&(EndDate<+$h)
	..s flag=0
	..i surveyType="F" d
	...f i=1:1:obj.SurveyWard.Count() q:flag=1  d
	....s ward=obj.SurveyWard.GetAt(i)
	....q:ward=""
	....i (isAll'=1)&&($d(tmpWard(ward))) s flag=1
	..s:isAll=1 flag=1
	..q:flag=0
	..s surveyTitle=obj.SurveyTitle
	..s ret="RowId|"_id_"^SurveyTitle|"_surveyTitle
	..d OutSurveyTitle
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyTitle
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:
/// Createdate:
/// Description:保存列表数据
/// Input:
/// Output:
/// Other:w ##class(web.INMSurveyComm).AddSurveyFieldSet()
ClassMethod AddSurveyFieldSet() As %String
{
	// SELECT * FROM DHCINM_Set.MgMenu WHERE Menu_Desc="随访表填写"
	s menuId=$o(^CT.DHCINM.Set.MgMenuI("Code"," FOLLOWUPWRITE",""))
	s tmpParr("SurveyTitle")="调查标题"
	s tmpParr("StatusDesc")="提交状态"
	s tmpParr("PatName")="病人姓名"
	s tmpParr("HosNum")="住院号"
	s tmpParr("InHosDate")="提交状态"
	s tmpParr("DischCondit")="出院转归"
	s tmpParr("OutHosDate")="出院日期"
	s tmpParr("WardDesc")="病区"
	s tmpParr("BedNumber")="床号"
	s tmpParr("Phone")="联系方式"
	s tmpParr("FollowUpStatusDesc")="随访状态"
	s tmpParr("Doctor")="主管医生"
	s tmpParr("Diag")="诊断"
	s tmpParr("PatSex")="性别"
	s tmpParr("PatAge")="年龄"
	s sort=0
	s code="" f  s code=$o(tmpParr(code)) q:code=""  d
	.s sort=sort+1
	.s parr="FieldDesc|"_$g(tmpParr(code))_"^FieldCode|"_code_"^FieldSort|"_sort
	.s parr=parr_"^FieldDisplay|true^FieldSelect|false^FieldLock|false^FieldLockPos|-1^RowID|^FieldWidth|100^FieldType|select^FieldTable|"_menuId
	.s tmp=""
	.k tmp
	.s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	.s id=$g(tmp("RowID"))
	.i id="" d
	..s obj=##class(CT.DHCINM.Set.MgFieldSet).%New()
	.e  s obj=##class(CT.DHCINM.Set.MgFieldSet).%OpenId(id)
	.s obj.FieldCode=$tr(tmp("FieldCode")," ","")
	.s obj.FieldDesc=$tr(tmp("FieldDesc")," ","")
	.s obj.FieldDisplay=$tr(tmp("FieldDisplay")," ","")
	.s obj.FieldSelect=$tr(tmp("FieldSelect")," ","")
	.s obj.FieldLock=$tr(tmp("FieldLock")," ","")
	.s obj.FieldLockPos=$tr(tmp("FieldLockPos")," ","")
	.s obj.FieldSort=$tr(tmp("FieldSort")," ","")
	.s obj.FieldTable=$tr(tmp("FieldTable")," ","")
	.s obj.FieldWidth=$tr(tmp("FieldWidth")," ","")
	.s obj.FieldType=$tr(tmp("FieldType")," ","")
	.;i id'="" d ..UpDateFieldSort(tmp("FieldTable"),id,tmp("FieldSort"))
	.s sc=obj.%Save()
	.d $System.Status.DisplayError(sc)
	q $$$ISOK(sc)
}

ClassMethod IGetMrNoByEpisodeID(EpisodeID, inType) As %String
{
	s $ZT="err"
	s ErrMsg=""
	q ##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(EpisodeID,.ErrMsg)
err
	q ""
}

/// Creator:liwenzhen
/// Createdate:2022-04-14
/// Description:获取出院病人信息
/// Input:就诊号
/// Output:
/// Other:d 
ClassMethod GetOutPatInfo(EpisodeID As %String = "", tmp As %String = "")
{
	s papmiDr=$P(^PAADM(EpisodeID),"^",1) //根据就诊号获取病人ID
	s patName=$p(^PAPER(papmiDr,"ALL"),"^",1)   //病人姓名
	s tmp("PatName")=patName
	s hosNum=$P($g(^PAPER(papmiDr,"PAT",1)),"^",22) //住院号
	s ErrMsg=""
	s:hosNum="" hosNum=..IGetMrNoByEpisodeID(EpisodeID,"O")
	s tmp("HosNum")=hosNum
	s bedCode=..GetPatientLastBedCode(EpisodeID) //床号
	s tmp("BedCode")=bedCode
	s sexDr=$P(^PAPER(papmiDr,"ALL"),"^",7) //性别
	i sexDr'="" s patSex=$P(^CT("SEX",sexDr),"^",2)
	e  s patSex=""
	s tmp("PatSex")=patSex
	s tmp("PatAge")=..GetPatAge(papmiDr) //年龄
	;s diag=..GetPatFirstDiag(outHosRw) //第一次诊断
	s outDiag=..GetOutPDiagnosByEpisodeID(EpisodeID) //出院诊断
	s tmp("Diag")=outDiag
	s tmp("Doctor")=..GetCareDoctor(EpisodeID) //主管医生
	s tmp("MainNurse")=..GetMainNurse(EpisodeID) //主管护士
	s tmp("Phone")=..GetTelphone(papmiDr) //联系方式
	s tmp("RelationDesc")=""
	s RelationID=$p($g(^PAPER(papmiDr,"EMP")),"^",4)
	s:RelationID'="" tmpRet("RelationDesc")=$P($g(^CT("RLT",RelationID)),"^",2)  //联系人关系
	s tmp("RelationName")=$p($g(^PAPER(papmiDr,"PER",2)),"^",13) //联系人	
	s tmp("RelationPhone")=$p($g(^PAPER(papmiDr,"ALL")),"^",4) //联系人电话
	q 1
}

/// Creator:liwenzhen
/// Createdate:2022-04-14
/// Description:获取用户姓名
/// Input:
/// Output:
/// Other:d 
ClassMethod GetUserName(id As %String = "")
{
	q:id=0 "超级管理员"
	s name=$lg(^CF.DHCINM.DB.MgUserD(id),2)
	q name
}

/// Creator:liwenzhen
/// Createdate:2022-04-14
/// Description:调查统计
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSurveyCount","P^22^^^","D",0,0)
Query FindSurveyCount(parr As %String = "", type As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyCountExecute(ByRef qHandle As %Binary, parr As %String = "", type As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s surveyType=$p(parr,"^",1)
	s rowId=$p(parr,"^",2)
	s searchWard=$p(parr,"^",3)
	s searchWard=$lfs(searchWard,",")
	s startDate=$p(parr,"^",4)
	s:startDate'="" startDate=$zdh(startDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate'="" endDate=$zdh(endDate,3)
	
	i rowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(rowId)
	s SurveyTitle=obj.SurveyTitle
	
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	k tmp
	i surveyType="N" d
	.f i=1:1:obj.SurveyPerson.Count()  d
	..s rw=""
	..s per=obj.SurveyPerson.GetAt(i)
	..s perName=$lg(^CF.DHCINM.HR.PersonsD(per),2)
	..s ward=##class(web.INMHRComm).GetCurrentWard(per,+$h)
	..s submit=..GetSubmitStatus(per,rowId)
	..s submitStatus=$p(submit,"^",1)
	..s submitDate=""
	..s:submitStatus="Y" submitDate=$zdh($p(submit,"^",3),3),rw=$p(submit,"^",2)
	..s:rw'="" ward=$lg(^DHCINM.Survey.MgFormD(rw),8)
	..q:(isAll=0)&&('$d(tmpWard(ward)))
	..q:(searchWard'="")&&($LF(searchWard,ward)=0)
	..q:(submitDate'="")&&(((startDate'="")&&(submitDate<startDate))||((endDate'="")&&(submitDate>endDate)))
	..d:type="C" CountData
	..d:type="D" OutDetail
	i surveyType="P" d
	.s rw="" f  s rw=$o(^DHCINM.Survey.MgFormI("releaseDR"," "_rowId,rw)) q:rw=""  d
	..s submitStatus=$lg(^DHCINM.Survey.MgFormD(rw),12)
	..s ward=$lg(^DHCINM.Survey.MgFormD(rw),8)
	..q:(isAll=0)&&('$d(tmpWard(ward)))
	..q:(searchWard'="")&&($LF(searchWard,ward)=0)
	..s submitDate=$lg(^DHCINM.Survey.MgFormD(rw),13)
	..q:(submitDate'="")&&(((startDate'="")&&(submitDate<startDate))||((endDate'="")&&(submitDate>endDate)))
	..i type="D"  d
	...s patName=$lg(^DHCINM.Survey.MgFormD(rw),7)
	...i patName?1n.n d
	....s regId=$p(^PAADM(patName),"^",1)
	....s:regId'="" patName=$p(^PAPER(regId,"ALL"),"^",1)
	...s bedNumber=$lg(^DHCINM.Survey.MgFormD(rw),14)
	...s bedcode=bedNumber
	...s:bedNumber["||" bedcode=$P(^PAWARD(+bedNumber,"BED",$p(bedNumber,"||",2)),"^",1) //床号描述
	...s surveyPerson=$lg(^DHCINM.Survey.MgFormD(rw),7)
	...s ret="PatName|"_patName_"^ReleaseDR|"_rowId_"^Bedcode|"_bedcode_"^SurveyPerson|"_surveyPerson
	...d OutDetail
	..d:type="C" CountData
	i surveyType="F" d
	.k tmpHIS
	.s stOutDate="",endOutDate=""
	.f i=1:1:obj.SurveyWard.Count()  d
	..s ward=obj.SurveyWard.GetAt(i)
	..q:ward=""
	..q:(isAll=0)&&('$d(tmpWard(ward)))
	..q:(searchWard'="")&&($LF(searchWard,ward)=0)
	..s HISWard=$lg(^CF.DHCINM.DB.MgWardD(ward),2) // HIS病区ID
	..q:HISWard=""
	..s wardId=$o(^PAWARD(0,"WARD_LocationDR",HISWard,""))
	..q:wardId=""
	..s tmpHIS(wardId)=ward
	.s outHosDate="" f  s outHosDate=$o(^PAADMi("DischDate",outHosDate)) q:outHosDate=""  d
	..q:((stOutDate'="")&&(outHosDate<stOutDate))
	..q:((endOutDate'="")&&(outHosDate>endOutDate))
	..q:(outHosDate+obj.FStDays)>+$h //出院日期+随访开始天数应小于当前日期
	..q:(outHosDate+obj.FEndDays)<+$h //出院日期+随访结束天数应大于当前日期时
	..s outHosRw="" f  s outHosRw=$o(^PAADMi("DischDate",outHosDate,outHosRw)) q:outHosRw=""  d //就诊号
	...s currentWardID=$p($g(^PAADM(outHosRw)),"^",70) //获取出院前所在HIS病区
	...q:'$d(tmpHIS(currentWardID))
	...k tmpInfo
	...s ward=tmpHIS(currentWardID) //病区ID
	...s wardDesc=""
	...s:ward'="" wardDesc=$lg(^CF.DHCINM.DB.MgWardD(ward),4) //病区描述
	...s rw=$o(^DHCINM.Survey.MgFormI("per"," "_rowId," "_outHosRw,"")) //判断表单是否已保存
	...s submitStatus="A",submitDate=""
	...s:rw'="" submitStatus=$lg($g(^DHCINM.Survey.MgFormD(rw)),12),submitDate=$lg($g(^DHCINM.Survey.MgFormD(rw)),13)
	...q:(submitDate'="")&&(((startDate'="")&&(submitDate<startDate))||((endDate'="")&&(submitDate>endDate)))
	...d:type="C" CountData
	...i type="D" d
	....q:rw=""
	....s formGlo=$g(^DHCINM.Survey.MgFormD(rw))
	....s situation="",followUpAnswer="「"
	....s followUpStatus=$lg(formGlo,15)
	....s followUpDate=$lg(formGlo,16)
	....s:followUpDate'="" followUpDate=$zd(followUpDate,3)
	....s situation=$lg(formGlo,18)
	....s:situation'="" situation=$lts(situation,"「",1)
	....s followUpAnswer=$lg(formGlo,19)
	....s followUpStatusDesc=##class(DHCINM.Survey.MgForm).FollowUpStatusLogicalToDisplay(followUpStatus)
	....s ret="FollowUpStatusDesc|"_followUpStatusDesc_"^FollowUpDate|"_followUpDate_"^Situation|"_situation
	....s ret=ret_"^FollowUpAnswer|"_followUpAnswer_"^FollowUpStatus|"_followUpStatus_"^OutHosDate|"_$zd(outHosDate,3)
	....d ..GetOutPatInfo(outHosRw,.tmpInfo)
	....s desc="" f  s desc=$o(tmpInfo(desc)) q:desc=""  d
	.....s ret=ret_"^"_desc_"|"_$g(tmpInfo(desc))
	....d OutDetail
	
	d:type="C" OutCount
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

CountData 
	s tmp(ward,"Total")=$g(tmp(ward,"Total"))+1
	s:submitStatus="Y" tmp(ward,"Y")=$g(tmp(ward,"Y"))+1
	q
OutCount
	s ward="" f  s ward=$o(tmp(ward)) q:ward=""  d
	.q:'$d(^CF.DHCINM.DB.MgWardD(ward))
	.s wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(ward)),4)
	.s total=$g(tmp(ward,"Total"))
	.s submit=$s($g(tmp(ward,"Y"))="":"0",1:$g(tmp(ward,"Y")))
	.s ret="WardDR|"_ward_"^WardDesc|"_wardDesc_"^SurveyTitle|"_SurveyTitle
	.s ret=ret_"^SurveyCount|"_total_"^SurveySubmit|"_submit
 	.s ^CacheTemp(repid,ind)=$lb(ret)
 	.s ind=ind+1
 	q
OutDetail
	q:submitStatus'="Y"
	q:rw=""
	s formGlo1=$g(^DHCINM.Survey.MgFormD(rw))
	s score=$lg(formGlo1,11)
	s wardDesc=$lg(^CF.DHCINM.DB.MgWardD(ward),4)
	s explain=$lg(formGlo1,17)
	s creater=$lg(formGlo1,2)
	s createrName=..GetUserName(creater)
	s ret=ret_"^SurveyTitle|"_SurveyTitle_"^Score|"_score_"^SubmitDate|"_$zd(submitDate,3)_"^RowId|"_rw_"^Status|Y"_"^Explain|"_explain
	s ret=ret_"^WardDR|"_ward_"^WardDesc|"_wardDesc_"^CreaterName|"_createrName
	s ^CacheTemp(repid,ind)=$lb(ret)
 	s ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2022-04-14
/// Description:查询调查条目
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindCountColumns","20","","0","0")
Query FindCountColumns(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindCountColumnsExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ReleaseId=parr
	s ReleaseGlo=$g(^DHCINM.Survey.MgSurveyReleaseD(ReleaseId))
	s surveyDR=$lg(ReleaseGlo,5)
	i surveyDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s result=##class(%ResultSet).%New("web.INMDBComm:FindSurveyFormSub")
	d result.Execute(surveyDR_"^Y",input,role,nurseid)
	while result.Next()
	{
		s Data=$lb(result.GetData(1))
 		s ^CacheTemp(repid,ind)=Data
 		s ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:liwenzhen
/// Createdate:2022-04-14
/// Description:统计调查条目
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSubCount","20^1__12^^^^好^好","S","0")
Query FindSubCount(parr As %String = "", type As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSubCountExecute(ByRef qHandle As %Binary, parr As %String = "", type As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s releaseId=$p(parr,"^",1)
	s dbSubId=$tr($p(parr,"^",2),"_","|")
	s searchWard=$p(parr,"^",3)
	s searchWard=$lfs(searchWard,",")
	s startDate=$p(parr,"^",4)
	s:startDate'="" startDate=$zdh(startDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate'="" endDate=$zdh(endDate,3)
	s keyword=$p(parr,"^",6)
	s searchKey=$p(parr,"^",7)
	s parref=$p(dbSubId,"||")
	i dbSubId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s dbSubGlo=$g(^CF.DHCINM.DB.SurveyFormSubD(parref,$p(dbSubId,"||",2)))
	s quesType=$lg(dbSubGlo,3)
	d:type="C" IntTmp
	s total=0
	s formId="" f  s formId=$o(^DHCINM.Survey.MgFormI("releaseDR"," "_releaseId,formId)) q:formId=""  d
	.s formGlo=$g(^DHCINM.Survey.MgFormD(formId))
	.s ward=$lg(formGlo,8)
	.q:(isAll=0)&&('$d(tmpWard(ward)))
	.q:(searchWard'="")&&($LF(searchWard,ward)=0)
	.s submitDate=$lg(formGlo,13)
	.q:(submitDate'="")&&(((startDate'="")&&(submitDate<startDate))||((endDate'="")&&(submitDate>endDate)))
	.s subId="" f  s subId=$o(^DHCINM.Survey.MgFormSubI("quesDR",formId," "_dbSubId,subId)) q:subId=""  d
	..s subGlo=$g(^DHCINM.Survey.MgFormSubD(formId,subId))
	..s answer=$lg(subGlo,11)
	..q:answer=""
	..s total=total+1 
	..s quesType=$lg(subGlo,3)
	..i (quesType="单选")||(quesType="多选")||(quesType="单项填空")||(quesType="多项填空")||(quesType="量表") d
	...f i=1:1:$l(answer,"「") d
	....s value=$p(answer,"「",i)
	....i quesType["填空" d
	.....d:(type="D")||(type="S") OutDetail
	.....s key="" f  s key=$o(tmp(key)) q:key=""  d
	......s:(value)[($g(tmp(key,"OptionDesc"))) tmp(key,"Number")=$g(tmp(key,"Number"))+1
	....e  s tmp(value,"Number")=$g(tmp(value,"Number"))+1
	..e  d
	...s tmp(answer,"OptionDesc")=answer
	...s tmp(answer,"Number")=$g(tmp(answer,"Number"))+1
	
	d:type="C" OutCount
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IntTmp
	k tmp
	i (quesType="多选")||(quesType="单选")||(quesType="量表") d
	.s quesOptions=$lg(dbSubGlo,10)
	.f i=1:1:$ll(quesOptions)  d
	..s quesOption=$lg(quesOptions,i)
	..s desc=$p(quesOption,"」",1)
	..s index=$p(quesOption,"」",5)
	..s tmp(index,"OptionDesc")=desc
	..s tmp(index,"Number")=0
	i (quesType="单项填空")||(quesType="多项填空") d
	.f i=1:1:$l(keyword,"，") d
	..s desc=$p(keyword,"，",i)
	..s tmp(i,"OptionDesc")=desc
	..s tmp(i,"Number")=0
	q
OutCount	
	s index="" f  s index=$o(tmp(index)) q:index=""  d
	.s rate=0
	.s:total'=0 rate=$fn($g(tmp(index,"Number"))/total*100,"",2)
	.s ret="Rate|"_rate
	.s code="" f  s code=$o(tmp(index,code)) q:code=""  d
	..s ret=ret_"^"_code_"|"_$g(tmp(index,code))
 	.s ^CacheTemp(repid,ind)=$lb(ret)
 	.s ind=ind+1
	q
OutDetail
	q:(value'[searchKey)&&(type="S")
	s ret="Desc|"_value_"^SubmitDate|"_$zd(submitDate,3)
	s ^CacheTemp(repid,ind)=$lb(ret)
 	s ind=ind+1
 	q
}

/// Creator:liwenzhen
/// Createdate:2022-04-19
/// Description:导出调查条目统计
/// Input:
/// Output:
/// Other:
/// Test: w ##class(web.INMSurveyComm).GetColumns("20","单选,多选")
ClassMethod GetColumns(parr As %String = "", type As %String = "") As %Status
{
	s ReleaseId=parr
	s searchType=$lfs(type,",")
	s ReleaseGlo=$g(^DHCINM.Survey.MgSurveyReleaseD(ReleaseId))
	s surveyDR=$lg(ReleaseGlo,5)
	i surveyDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s result=##class(%ResultSet).%New("web.INMDBComm:FindSurveyFormSub")
	d result.Execute(surveyDR_"^Y")
	s list=##class(%ListOfDataTypes).%New()
	f  s key=result.Next() q:key=0  d
	.k tmpRes
	.d ##class(web.INMVueComm).SplitStr(result.GetData(1),"^","|",.tmpRes)
	.s quesType=$g(tmpRes("QuesType"))
	.q:(searchType'="")&&($lf(searchType,quesType)=0)
	.s array=##class(%ArrayOfDataTypes).%New()
	.s quesDesc=$g(tmpRes("Sort"))_"."_$g(tmpRes("QuesDesc"))
	.s rowId=$tr($g(tmpRes("RowId")),"|","_")
	.s quesOptions=$g(tmpRes("QuesOption"))
	.d array.SetAt(rowId,"prop")
	.d array.SetAt(quesDesc,"desc")
	.s childList=##class(%ListOfDataTypes).%New()
	.f i=1:1:$l(quesOptions,"「")  d
	..s child=##class(%ArrayOfDataTypes).%New()
	..s quesOption=$p(quesOptions,"「",i)
	..s desc=$p(quesOption,"」",1)
	..s index=$p(quesOption,"」",5)
	..d child.SetAt(rowId_"_"_index,"prop")
	..d child.SetAt(desc,"desc")
	..d childList.Insert(child)
	.d:(quesType="多选")||(quesType="单选")||(quesType="量表") array.SetAt(childList,"child")
	.d list.Insert(array)
	s ret=##class(DHCINM.WebService.INMAppCommon).Encode(list)
	w ret
	q ""
}

/// Creator:liwenzhen
/// Createdate:2022-04-19
/// Description:导出调查条目统计
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSubCountByWard","20","","0","0")
Query FindSubCountByWard(parr As %String = "", input As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindSubCountByWardExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s releaseId=$p(parr,"^",1)
	s searchWard=$p(parr,"^",2)
	s searchWard=$lfs(searchWard,",")
	s startDate=$p(parr,"^",3)
	s:startDate'="" startDate=$zdh(startDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate'="" endDate=$zdh(endDate,3)
	s isAll=0
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s ReleaseGlo=$g(^DHCINM.Survey.MgSurveyReleaseD(releaseId))
	s surveyDR=$lg(ReleaseGlo,5)
	i surveyDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	k tmpOption,tmpRet
	s result=##class(%ResultSet).%New("web.INMDBComm:FindSurveyFormSub")
	d result.Execute(surveyDR_"^Y",input,"",nurseid)
	f  s key=result.Next() q:key=0  d
	.k tmpRes
	.d ##class(web.INMVueComm).SplitStr(result.GetData(1),"^","|",.tmpRes)
	.s dbQuesType=$g(tmpRes("QuesType"))
	.q:(dbQuesType'="单选")&&(dbQuesType'="多选")&&(dbQuesType'="量表")
	.s dbRowId=$g(tmpRes("RowId"))
	.s dbQuesOption=tmpRes("QuesOption")
	.f i=1:1:$l(dbQuesOption,"「")  d
	..s quesOption=$p(dbQuesOption,"「",i)
	..s desc=$p(quesOption,"」",1)
	..s index=$p(quesOption,"」",5)
	..s tmpOption(dbRowId,index)=desc
	.s formId="" f  s formId=$o(^DHCINM.Survey.MgFormI("releaseDR"," "_releaseId,formId)) q:formId=""  d
	..s formGlo=$g(^DHCINM.Survey.MgFormD(formId))
	..s ward=$lg(formGlo,8)
	..q:(isAll=0)&&('$d(tmpWard(ward)))
	..q:(searchWard'="")&&($LF(searchWard,ward)=0)
	..s submitDate=$lg(formGlo,13)
	..q:(submitDate'="")&&(((startDate'="")&&(submitDate<startDate))||((endDate'="")&&(submitDate>endDate)))
	..s subId="" f  s subId=$o(^DHCINM.Survey.MgFormSubI("quesDR",formId," "_dbRowId,subId)) q:subId=""  d
	...s subGlo=$g(^DHCINM.Survey.MgFormSubD(formId,subId))
	...s answer=$lg(subGlo,11)
	...q:answer=""
	...f i=1:1:$l(answer,"「") d
	....s value=$p(answer,"「",i)
	....s tmpRet(ward,dbRowId,value,"Number")=$g(tmpRet(ward,dbRowId,value,"Number"))+1
	....s tmpRet(ward,dbRowId,"Total")=$g(tmpRet(ward,dbRowId,"Total"))+1
	
	s ward="" f  s ward=$o(tmpRet(ward)) q:ward=""  d
	.s wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(ward)),4)
	.s ret="WardDesc|"_wardDesc
	.s rowId="" f  s rowId=$o(tmpRet(ward,rowId)) q:rowId=""  d
	..s index="" f  s index=$o(tmpOption(rowId,index)) q:index=""  d
	...s total=$g(tmpRet(ward,rowId,"Total"))
	...s number=$g(tmpRet(ward,rowId,index,"Number"))
	...s:number="" number=0
	...s rate=0
	...s:'total=0 rate=$fn(number/total*100,"",2)
	...s ret=ret_"^"_$tr(rowId,"|","_")_"_"_index_"|"_rate_"%"
	.s ^CacheTemp(repid,ind)=$lb(ret)
 	.s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description: 获取调查表总数量及完成数
/// Date: 2022-03-23
/// Creator: wangpf
/// Table: DHCINM.Survey.MgSurveyRelease DHCINM.Survey.MgForm
/// Input: 病区Id 调查项目Id 调查开始日期 调查结束日期
/// Output: 调查表总数量及完成数
/// Other:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSurCountList","^^^^",0)
Query FindSurCountList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSurCountListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s item=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp
	s surType="" f  s surType=$o(^DHCINM.Survey.MgSurveyReleaseI("typeStDate",surType)) q:surType=""  d
	.s tSurType=$tr(surType," ")
	.s surTypeDesc=$case(tSurType,"N":"护士满意度","P":"患者满意度","F":"出院随访",:"")
	.s surStDate="" f  s surStDate=$o(^DHCINM.Survey.MgSurveyReleaseI("typeStDate",surType," Y",surStDate)) q:surStDate=""  d
	..q:(endDate'="")&&(endDate<surStDate)
	..s surId="" f  s surId=$o(^DHCINM.Survey.MgSurveyReleaseI("typeStDate",surType," Y",surStDate,surId)) q:surId=""  d
	...s surObj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(surId)
	...q:'$IsObject(surObj)
	...s surEndDate=surObj.EndDate
	...q:(surEndDate'="")&&(stDate'="")&&(surEndDate<stDate)
	...s surItem=surObj.SurveyContent
	...q:(item'="")&&(item'=surItem)
	...s surItemDesc=$lg($g(^CF.DHCINM.DB.SurveyFormD(surItem)),4)
	...s quit=1
	...i tSurType="N" d
	....s perList=surObj.SurveyPerson
	....s key="" f  s val=perList.GetNext(.key) q:(key="")||(quit'=1)  d
	.....q:val=""
	.....s perWard=##class(web.INMHRComm).GetCurrentWard(val,surStDate)
	.....q:((ward'="")&&(ward'=perWard))||((isAll'=1)&&('$d(tmpWard(perWard))))
	.....s quit=0
	....s count=perList.Count()
	...e  d
	....s surWardList=surObj.SurveyWard
	....s key="" f  s val=surWardList.GetNext(.key) q:(key="")||(quit'=1)  d
	.....q:val=""
	.....q:((ward'="")&&(ward'=val))||((isAll'=1)&&('$d(tmpWard(val))))
	.....s quit=0
	....s count=surWardList.Count()
	...q:quit=1
	...s resultCount=0
	...s resultId="" f  s resultId=$o(^DHCINM.Survey.MgFormI("releaseDR"," "_surId,resultId)) q:resultId=""  d
	....s resultObj=##class(DHCINM.Survey.MgForm).%OpenId(resultId)
	....q:'$IsObject(resultObj)
	....q:resultObj.Status'="Y"
	....s resultCount=resultCount+1
	...s ret="SurType|"_tSurType_"^SurTypeDesc|"_surTypeDesc_"^SurItem|"_surItem_"^SurItemDesc|"_surItemDesc
	...s ret=ret_"^SurTitle|"_surObj.SurveyTitle_"^Count|"_count_"^ResultCount|"_resultCount_"^rw|"_surId
	...d OutRelease
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRelease
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSurCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSurCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurCountListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Description: 获取某次调查结果统计
/// Date: 2022-03-23
/// Creator: wangpf
/// Table: DHCINM.Survey.MgForm
/// Input: 病区Id 任务Id
/// Output: 某次调查结果统计
/// Other:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindSurStatList","^^^^",0)
Query FindSurStatList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSurStatListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ward=$p(parr,"^")
	s taskId=$p(parr,"^",2)
	
	i (nurseid="")||(taskId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp,tmpDesc
	s surId="" f  s surId=$o(^DHCINM.Survey.MgFormI("releaseDR"," "_taskId,surId)) q:surId=""  d
	.s surObj=##class(DHCINM.Survey.MgForm).%OpenId(surId)
	.q:'$IsObject(surObj)
	.q:surObj.Status'="Y"
	.s surWard=surObj.WardDR
	.q:((ward'="")&&(ward'=surWard))||((isAll'=1)&&('$d(tmpWard(surWard))))
	.s surItem=surObj.SurveyDR
	.s:'$d(tmpDesc(surItem,"Desc")) tmpDesc(surItem,"Desc")=$lg($g(^CF.DHCINM.DB.SurveyFormD(surItem)),4)
	.s subId="" f  s subId=$o(^DHCINM.Survey.MgFormSubD(surId,subId)) q:subId=""  d
	..s subObj=##class(DHCINM.Survey.MgFormSub).%OpenId(surId_"||"_subId)
	..q:'$IsObject(subObj)
	..q:(subObj.QuesType'="单选")&&(subObj.QuesType'="多选")
	..s itemSub=subObj.QuesDR
	..i '$d(tmp(surItem,itemSub)) d
	...s optionList=subObj.QuesOption
	...s key="" f  s value=optionList.GetNext(.key) q:key=""  d
	....s index=$p(value,"」",5)
	....s tmpDesc(surItem,itemSub,index,"Desc")=$p(value,"」")
	....s tmp(surItem,itemSub,index)=0
	..s:'$d(tmpDesc(surItem,itemSub,"Desc")) tmpDesc(surItem,itemSub,"Desc")=subObj.QuesDesc
	..s tmp(surItem,itemSub)=$g(tmp(surItem,itemSub))+1
	..s answer=subObj.Answer
	..s answerList=$lfs(answer,"「")
	..s ptr=0 f  s sta=$listnext(answerList,ptr,val) q:sta'=1  d
	...q:val=""
	...i '$d(tmp(surItem,itemSub,val)) d
	....s optionList=subObj.QuesOption
	....s key="" f  s value=optionList.GetNext(.key) q:key=""  d
	....s index=$p(value,"」",5)
	....q:val'=index
	....s tmpDesc(surItem,itemSub,index,"Desc")=$p(value,"」")
	....s tmp(surItem,itemSub,index)=0
	...s tmp(surItem,itemSub,val)=tmp(surItem,itemSub,val)+1
	
	s surItem="" f  s surItem=$o(tmp(surItem)) q:surItem=""  d
	.s itemSub="" f  s itemSub=$o(tmp(surItem,itemSub)) q:itemSub=""  d
	..s ret="SurItem|"_surItem_"^SurItemDesc|"_tmpDesc(surItem,"Desc")_"^SurSub|"_$tr(itemSub,"|","_")_"^SurSubDesc|"_tmpDesc(surItem,itemSub,"Desc")
	..s result=""
	..s itemAns="" f  s itemAns=$o(tmp(surItem,itemSub,itemAns)) q:itemAns=""  d
	...s result=result_$case(result,"":"",:"」")_tmpDesc(surItem,itemSub,itemAns,"Desc")_"「"_tmp(surItem,itemSub,itemAns)
	..s ret=ret_"^Result|"_result_"^Total|"_tmp(surItem,itemSub)
	..d OutRelease
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRelease
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSurStatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurStatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSurStatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurStatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
