/// 排班信息
Class DHCMGNUR.MgNurArrangeJob Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 排班病区
Property AJWardDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = AJ_WardDR ];

/// 护士MgPersonsDR
Property AJNurseDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AJ_Nurse ];

/// 排班类型
Property AJType As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = AJ_Type ];

/// 排班代码
Property AJCodeDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = AJ_Code_DR ];

/// 班次日期
Property AJDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AJ_Date ];

/// 班次开始时间
Property AJStTime As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = AJ_StTime ];

/// 班次结束时间
Property AJEndTime As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = AJ_EndTime ];

/// 班时段
Property AJJobInterval As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = AJ_JobInterval ];

/// 备注
Property AJRemarks As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = AJ_Remarks ];

/// 排班护士长
Property AJNurseMaster As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = AJ_NurseMaster ];

/// 排班日期
Property AJModifyDate As %Date [ SqlColumnNumber = 12, SqlFieldName = AJ_Modify_Date ];

/// 排班时间
Property AJModifyTime As %Time [ SqlColumnNumber = 13, SqlFieldName = AJ_Modify_Time ];

/// 关联床位
Property AJConnBed As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = AJ_ConnBed ];

Property AJNurseType As %String [ SqlColumnNumber = 15, SqlFieldName = AJ_Nurse_Type ];

Index AJNurseIndex On (AJNurseType, AJNurseDR);

Index AJDateIndex On AJDate;

Index AJTypeIndex On AJType;

Index AJWardDRIndex On AJWardDR;

Index AJPersonDate On (AJNurseType, AJNurseDR, AJDate);

Index AJWardDateIdx On (AJWardDR, AJDate);

Index AJNurDateIndex On (AJWardDR, AJNurseType, AJNurseDR, AJDate);

/// 插入一条记录
/// Input:病区^护士^班次^班次类型^班次日期^班次开始时间^班次结束日期^备注^排班护士长^时段
/// w ##class(DHCMGNUR.MgNurArrangeJob).SaveAJData("1018^9324^6^Post^^^^^6253^H")
ClassMethod SaveAJData(parm As %String) As %String
{
	q:parm=""
	set l=$L(parm,"!")
	set ^TempXBL=l
	f i=1:1:l d
	.set parr=$P(parm,"!",i)
	.set AJWardDR = $P(parr,"^",1)
	.set AJNurseDR = $P(parr,"^",2)
	.set AJDate = $P(parr,"^",5) 
	.set AJStTime = $P(parr,"^",6)
	.set AJEndTime = $P(parr,"^",7)
	.if AJDate'="" set AJDate=$zdh(AJDate,3)
	.if AJStTime'="" set AJStTime = $zth(AJStTime)
	.if AJEndTime'="" set AJEndTime = $zth(AJEndTime)
	.set AJNurseType=$P(parr,"^",11)
	.set AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_AJWardDR," "_$zcvt(AJNurseType,"U")," "_AJNurseDR," "_AJDate,""))
	.if AJRowId="" do
	..set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%New()
	..set AJObject.AJWardDR = AJWardDR
	..set AJObject.AJNurseDR = AJNurseDR
	..set AJObject.AJNurseType=AJNurseType
	..set AJObject.AJCodeDR = $P(parr,"^",3)
	..set AJObject.AJType = $P(parr,"^",4)
	..set AJObject.AJDate = AJDate
	..set AJObject.AJStTime=AJStTime
	..set AJObject.AJEndTime = AJEndTime
	..set AJObject.AJRemarks = $P(parr,"^",8)
	..set AJObject.AJNurseMaster = $P(parr,"^",9)
	..set AJObject.AJModifyDate = $P($h,",",1)
	..set AJObject.AJModifyTime = $P($h,",",2)
	..set AJObject.AJJobInterval = $P(parr,"^",10)
	..d AJObject.%Save()
	.else  do
	..set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	..set AJObject.AJCodeDR = AJObject.AJCodeDR_","_$P(parr,"^",3)
	..set AJObject.AJType = AJObject.AJType_","_$P(parr,"^",4)
	..set AJObject.AJStTime = AJObject.AJStTime_","_AJStTime
	..set AJObject.AJEndTime = AJObject.AJEndTime_","_AJEndTime
	..set AJObject.AJRemarks = AJObject.AJRemarks_"\"_$P(parr,"^",8)
	..set AJObject.AJModifyDate = $P($h,",",1)
	..set AJObject.AJModifyTime = $P($h,",",2)
	..set AJObject.AJJobInterval = AJObject.AJJobInterval_","_$P(parr,"^",10)
	..d AJObject.%Save()
}

ClassMethod SaveAJData2(parr As %String) As %String
{
	q:parr=""
	set AJWardDR = $P(parr,"^",1)
	set AJNurseDR = $P(parr,"^",2)
	set AJDate = $zdh($P(parr,"^",5),3)
	set AJStTime = $P(parr,"^",6)
	set AJEndTime = $P(parr,"^",7)
	set AJNurseType=$P(parr,"^",11)
	set AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_AJWardDR," "_$zcvt(AJNurseType,"U")," "_$zcvt(AJNurseDR,"U")," "_AJDate,""))
	if AJRowId="" do
	.set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%New()
	.set AJObject.AJWardDR = AJWardDR
	.set AJObject.AJNurseDR = AJNurseDR
	.set AJObject.AJNurseType=AJNurseType
	.set AJObject.AJCodeDR = $P(parr,"^",3)
	.set AJObject.AJType = $P(parr,"^",4)
	.set AJObject.AJDate = AJDate
	.set AJObject.AJStTime=AJStTime
	.set AJObject.AJEndTime = AJEndTime
	.set AJObject.AJRemarks = $P(parr,"^",8)
	.set AJObject.AJNurseMaster = $P(parr,"^",9)
	.set AJObject.AJModifyDate = $P($h,",",1)
	.set AJObject.AJModifyTime = $P($h,",",2)
	.set AJObject.AJJobInterval = $P(parr,"^",10)
	else  do
	.set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	.set AJObject.AJCodeDR = $P(parr,"^",3)
	.set AJObject.AJType = $P(parr,"^",4)
	.set AJObject.AJStTime = AJStTime
	.set AJObject.AJEndTime = AJEndTime
	.set AJObject.AJRemarks = $P(parr,"^",8)
	.set AJObject.AJModifyDate = $P($h,",",1)
	.set AJObject.AJModifyTime = $P($h,",",2)
	.set AJObject.AJJobInterval = $P(parr,"^",10)
	TStart
	set sc = AJObject.%Save()
	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "fail"
	}
	else
	{
		TCommit
		q "success"
	}
}

/// 加载模板
/// Input:病区^模板^开始日期^天数^开始星期^排班护士长
/// d ##class(DHCMGNUR.MgNurArrangeJob).SaveModelToAJData("27^24^2014-12-29^7^1^demo")
ClassMethod SaveModelToAJData(parr As %String) As %String
{
	q:parr=""
	set WardId=$P(parr,"^",1)
	set ModelId=$P(parr,"^",2)
	set StDate = $zdh($P(parr,"^",3),3)
	set DayNum = $P(parr,"^",4)
	set WeekNum = $P(parr,"^",5)
	set NurseMaster = $P(parr,"^",6)
	set WeeksDesc="MONDAY^TUESDAY^WEDNESDAY^THURSDAY^FRIDAY^SATURDAY^SUNDAY"
	d ##class(web.DHCNurArgJobNurInfo).getDeptNurse(WardId_"^"_$zd(StDate,3)_"^"_$zd(StDate+DayNum-1,3),.tmp)
	set nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.q:PerArray("PersonType")'="MP"
	.b ;00
	.s MgPersonId=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(PerArray("PersonID"),"U"),""))
	.do GetItemData
	q "addSuccess"
GetItemData
	set MgPersonsObj=##class(DHCMGNUR.MgPersons).%OpenId(MgPersonId)
	set PersonID = MgPersonsObj.PersonID
	set j=0
	for i=WeekNum:1:(WeekNum+DayNum-1) do
	.if i#7'=0 set Week = $P(WeeksDesc,"^",i#7)
	.else  set Week = $P(WeeksDesc,"^",7)
	.set AdmDate = $zd(StDate + j,3)
	.set j=j+1
	.set AJMRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_ModelId," "_WardId," "_PersonID," "_Week,"")) 
	.q:AJMRowId=""
	.set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	.set AJWardDR = AJMObject.AJWardDR
	.set AJNurseDR = AJMObject.AJNurseDR
	.set AJCodeDR = AJMObject.AJCodeDR
	.set AJType = AJMObject.AJType
	.set AJDate = AdmDate
	.set AJStTime=AJMObject.AJStTime
	.set AJEndTime = AJMObject.AJEndTime
	.set AJRemarks = AJMObject.AJRemarks
	.set AJNurseMaster = NurseMaster
	.set AJJobInterval = AJMObject.AJJobInterval
	.;parr:病区^护士^班次^班次类型^班次日期^班次开始时间^班次结束日期^备注^排班护士长^时段
	.set parr = AJWardDR_"^"_AJNurseDR_"^"_AJCodeDR_"^"_AJType_"^"_AJDate_"^"_AJStTime_"^"_AJEndTime_"^"_AJRemarks_"^"_AJNurseMaster_"^"_AJJobInterval_"^MP"
	.b ;01
	.do ##class(DHCMGNUR.MgNurArrangeJob).SaveAJData2(parr)
	q
}

/// 删除排班信息
/// w ##class(DHCMGNUR.MgNurArrangeJob).DeleteAJData("1018^8328^2013-12-17") 
ClassMethod DeleteAJData(parm As %String) As %String
{
	q:parm=""
	set l=$L(parm,"!")
	set ^TempXBL=l
	for i=1:1:l do
	.set parr=$P(parm,"!",i)
	.set WardId = $P(parr,"^",1)
	.set PersonID = $P(parr,"^",2)
	.set AdmDate = $Zdh($P(parr,"^",3),3)
	.set PersonType=$P(parr,"^",4)
	.set AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(PersonType,"U")," "_PersonID," "_AdmDate,"")) 
	.q:AJRowId=""
	.set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	.d AJObject.%DeleteId(AJRowId)
}

/// 按班次时间和病区查询排班信息
/// Input：WardId^StDate^EndDate
/// do ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","FindAJData","27^2017-05-22^2017-05-28^nurse")
Query FindAJData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAJDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if parr="" 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	} 
	set WardId = $P(parr,"^",1)
	set StDate = $zdh($P(parr,"^",2),3)
	set EndDate = $zdh($P(parr,"^",3),3)
	set grpdesc=$P(parr,"^",4)
	s ^TEMP("201706021503")=parr
	set tmp=""
	d ##class(DHCMGNUR.MgNurArgJobChild).getDeptNurse(parr,.tmp)
	s trueorder=1
	set nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.do GetItemData2
	.s trueorder=trueorder+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetItemData2
	set Count=0
	set NCount=0
	set ret=""
	;set MgPersonId=$O(^DHCMGNUR.MgPersonsI("SSID"," "_PerArray("PersonID"),""))
	set PersonID=$ZConvert(PerArray("PersonID"),"U")
	set PersonName=PerArray("PersonName")
	set PersonBtyDesc=PerArray("PersonBty")
	set PersonOrder = PerArray("PersonOrder")
	s PersonType=PerArray("PersonType")
	set ret="NurseId|"_PersonID_"^NurseName|"_PersonName_"^NurseBty|"_PersonBtyDesc_"^NurseName2|"_$E(PersonName,1,1)
	for AdmDate=StDate:1:EndDate do
	.set ret=ret_"^Date"_$zd(AdmDate,3)_"|"
	.s status=##class(DHCMGNUR.MgNurArgJob).GetStatus(WardId_"^"_StDate_"^"_EndDate)
	.q:(grpdesc="nurse")&(status'="S")
	.set HolidayFlag=0
	.set JobDesc(AdmDate)=""
	.set AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(PersonType,"U")," "_$zcvt(PersonID,"U")," "_AdmDate,"")) 
	.if AJRowId'="" do 
	..set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	..set AJType = AJObject.AJType
	..set AJCodeDR = AJObject.AJCodeDR
	..set AJJobIntervalDesc = AJObject.AJJobInterval
	..for j=1:1:$L(AJCodeDR,",") do
	...set AJTypeItem = $P(AJType,",",j)
	...set AJCodeId = $P(AJCodeDR,",",j)
	...set AJJobInterval = $P(AJJobIntervalDesc,",",j)
	...if AJTypeItem="Post" do
	....set PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJCodeId)
	....set PostType = PostObject.PostType
	....set cdsobj=##class(DHCMGNUR.CommDictionarySub).%OpenId(PostType)
	....if JobDesc(AdmDate)="" set JobDesc(AdmDate)=PostObject.PostDesc
	....else  set JobDesc(AdmDate)=JobDesc(AdmDate)_"/"_PostObject.PostDesc
	....if ((AJJobInterval'="H")&&(AJJobInterval'="")) do
	.....set JobDesc(AdmDate) = JobDesc(AdmDate)_"("_AJJobInterval_")" 
	.....set Count=Count+(PostObject.PostHours/2)
	.....if (PostObject.PostNightHours'="")||(PostObject.PostNightHours'=" ") d
	......if ((AJJobInterval'="H")&&(AJJobInterval'="")) do
	.......set NCount=NCount+(PostObject.PostNightHours/2)
	......e  s NCount=NCount+PostObject.PostNightHours
	....else  d
	.....set Count=Count+PostObject.PostHours 
	.....if (PostObject.PostNightHours'="")||(PostObject.PostNightHours'=" ") d
	......set NCount=NCount+PostObject.PostNightHours
	.....else  set NCount=NCount+PostObject.PostNightHours
	...if (AJTypeItem="Holiday")||(AJTypeItem="Rest") do
	....set HolidayFlag=1
	....set HolidayObject = ##class(DHCMGNUR.MgNurHolidayCode).%OpenId(AJCodeId)
	....if JobDesc(AdmDate)="" set JobDesc(AdmDate)= HolidayObject.HolidayDesc
	....else  set JobDesc(AdmDate)= JobDesc(AdmDate)_"/"_HolidayObject.HolidayDesc
	...if AJTypeItem="OverTime" do
	....if JobDesc(AdmDate)="" set JobDesc(AdmDate)=AJCodeId
	....else  set JobDesc(AdmDate)=JobDesc(AdmDate)_"/"_AJCodeId
	..if HolidayFlag=1 set JobDesc(AdmDate)= JobDesc(AdmDate)
	..set ret=ret_$tr($tr(JobDesc(AdmDate),"’","'"),"‘","'")
	.else  set ret=ret_"^"
	i $zd(EndDate,10)=0 set parm=WardId_"^"_$zd((EndDate-6),3)_"^"_$zd(EndDate,3)
	e  s parm=WardId_"^"_$zd((EndDate-$zd(EndDate,10)+1),3)_"^"_$zd((EndDate+7-$zd(EndDate,10)),3)
	set retAJC=##class(DHCMGNUR.MgNurArgJobChild).getValue(parm_"^"_PersonID_"^"_PersonType)
	set tmpAJC=""
	k tmpAJC
	d ##class(web.DHCNurRosterComm).setTmp(retAJC,.tmpAJC)
	if retAJC'="" set ret=ret_"^JobAssign|"_tmpAJC("JobAssign")_"^JobNum|"_Count_"^NigthJobNum|"_NCount_"^NurseOrder|"_trueorder_"^NurseType|"_PersonType
	else  set ret=ret_"^JobAssign|^JobNum|"_Count_"^NigthJobNum|"_NCount_"^NurseOrder|"_trueorder_"^NurseType|"_PersonType
	do OutputAJRow
	q
OutputAJRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAJDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAJDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAJDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAJDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按人查询班次
/// do ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","FindPostByNurse","1230^2014-05-01^2014-06-01")
Query FindPostByNurse(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPostByNurseExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set WardId = $P(parr,"^",1)
	set StDate = $zdh($P(parr,"^",2),3)
	set EndDate = $zdh($P(parr,"^",3),3)
	set PersonType=$P(parr,"^",4)
	set tmp=""
	d ##class(DHCMGNUR.MgNurArgJobChild).getDeptNurse(parr,.tmp)
	set nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.set NurseRowId=PerArray("PersonID")
	.set NurseName=PerArray("PersonName")
	.set NurseType=PerArray("PersonType")
	.else  d
	..s wpsp=##class(DHCMGNUR.MgPSPersons).%OpenId(NurseRowId)
	..q:wpsp.PersonType'=PersonType
	.set TotalNum(NurseRowId)=0
	.set ret=NurseRowId_"^"_NurseName
	.for AdmDate=StDate:1:EndDate do
	..set AJRowId = ""
	..for  set AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(NurseType,"U")," "_NurseRowId," "_AdmDate,AJRowId)) q:AJRowId=""  do
	...set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	...set AJTypes = AJObject.AJType
	...for i=1:1:$L(AJTypes,",") do
	....set AJType=$P(AJTypes,",",i)
	....q:AJType'="Post"
	....set AJCode = $P(AJObject.AJCodeDR,",",i)
	....set AJJobInterval = $P(AJObject.AJJobInterval,",",i)
	....set PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJCode)
	....set PostCode = PostObject.PostCode
	....set PostHour = PostObject.PostHourNum
	....if $D(Count(NurseRowId,AJCode))=0  set Count(NurseRowId,AJCode)=0
	....if (AJJobInterval="H")&&(PostHour=8) d
	.....set Count(NurseRowId,AJCode)=Count(NurseRowId,AJCode)+1 
	.....set TotalNum(NurseRowId)=TotalNum(NurseRowId)+1
	....else  set Count(NurseRowId,AJCode)=Count(NurseRowId,AJCode)+0.5 set TotalNum(NurseRowId)=TotalNum(NurseRowId)+0.5
	.set WardPostCount=##class(DHCMGNUR.MgNurWardPost).getCount(WardId)
	.for Order=1:1:WardPostCount d
	..s PostId = $O(^DHCMGNUR.MgNurWardPostI("WardOrder"," "_WardId," "_Order,"")) 
	..q:PostId=""
	..set a=##class(DHCMGNUR.MgNurWardPost).%OpenId(PostId)
	..set WardPostId=a.PostID
	..set PostObj = ##class(DHCMGNUR.MgNurPost).%OpenId(WardPostId)
	..set PostValid = PostObj.PostValid
	..q:(PostValid="N")
	..if $D(Count(NurseRowId,WardPostId))=0  set Count(NurseRowId,WardPostId)=""
	..set ret = ret_"^"_Count(NurseRowId,WardPostId)
	.set ret = ret_"^"_TotalNum(NurseRowId)
	.Do OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostByNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostByNurseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPostByNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostByNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按班查询班次
/// do ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","FindPostDataByPost","27^2015-04-13^2015-04-18")
Query FindPostDataByPost(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPostDataByPostExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TEMP("g1703201707001")=parr
	set WardId = $P(parr,"^",1)
	set StDate = $zdh($P(parr,"^",2),3)
	set EndDate = $zdh($P(parr,"^",3),3)
	set PersonType=$P(parr,"^",4)
	set WardPostCount=##class(DHCMGNUR.MgNurPost).getCount(WardId)
	for Order=1:1:WardPostCount d
	.s PostId = $O(^DHCMGNUR.MgNurPostI("WardOrder"," "_WardId," "_Order,"")) 
	.q:PostId=""
	.;set a=##class(DHCMGNUR.MgNurPost).%OpenId(PostId)
	.;set WardPostId=a.PostID
	.set PostObj = ##class(DHCMGNUR.MgNurPost).%OpenId(PostId)
	.set PostCode = PostObj.PostCode
	.set PostValid = PostObj.PostValid
	.set PostDesc=PostObj.PostDesc
	.q:PostValid="N"
	.Do GetPostData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetPostData
	s dateFlag=##class(websys.Conversions).DateFormat()
	set ret="PostDesc|"_PostDesc
	set count(PostId)=0
	for AdmDate=StDate:1:EndDate do
	.set NurseNames(PostId,AdmDate)=""
	.set AJRowId="" f  s AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_WardId," "_AdmDate,AJRowId)) q:AJRowId=""  do
	..set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	..set AJNurse = AJObject.AJNurseDR
	..set AJNurseType=AJObject.AJNurseType
	..q:(PersonType'="")&&(PersonType'=AJNurseType)
	..set PersonRowId = $O(^DHCMGNUR.MgPersonsI("SSID"," "_AJNurse,"")) 
	..i PersonRowId'="" d
	...set PersonObject = ##class(DHCMGNUR.MgPersons).%OpenId(PersonRowId)
	...set NurseName = PersonObject.PersonName
	..set AJTypes = AJObject.AJType
	..for i=1:1:$L(AJTypes,",") do
	...set AJType = $P(AJTypes,",",i)
	...q:AJType'="Post"
	...set AJCode = $P(AJObject.AJCodeDR,",",i)
	...if AJCode=PostId do
	....if NurseNames(AJCode,AdmDate)="" set NurseNames(AJCode,AdmDate)= NurseName
	....else  set NurseNames(AJCode,AdmDate)= NurseNames(AJCode,AdmDate)_"/"_NurseName
	....set count(AJCode) = count(AJCode)+1
	.i ((dateFlag=3)!(dateFlag=4)) s AdmDate1=##class(web.DHCMgNurPerHRComm).getDateFormat(AdmDate)
	.;set ret = ret_"^Date"_$zd(AdmDate,3)_"|"_NurseNames(PostId,AdmDate)
	.set ret = ret_"^Date"_AdmDate1_"|"_NurseNames(PostId,AdmDate)
	set ret = ret_"^TotalNum|"_count(PostId)
	Do OutputRow2
	q
OutputRow2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostDataByPostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostDataByPostExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPostDataByPostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostDataByPostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询休假信息
/// do ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","FindHolidayData","27^2015-04-13^2015-04-18")
Query FindHolidayData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindHolidayDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TEMP("g1703021617001")=parr
	s dateFlag=##class(websys.Conversions).DateFormat()
	s repid=$I(^CacheTemp)
	s ind=1
	set WardId = $P(parr,"^",1)
	set StDate = $zdh($P(parr,"^",2),3)
	set EndDate = $zdh($P(parr,"^",3),3)
	set PersonType=$P(parr,"^",4)
	for AdmDate=StDate:1:EndDate do
	.set WardDesc = $P(^CTLOC(WardId),"^",2)
	.set AJRowId = ""
	.for  set AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_WardId," "_AdmDate,AJRowId)) q:AJRowId=""  do
	..set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	..set NurseId = AJObject.AJNurseDR
	..set AJNurseType=AJObject.AJNurseType
	..q:(PersonType'="")&&(AJNurseType'=PersonType)&&(PersonType'="ALL")
	..set PersonRowId = $O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(NurseId,"U"),"")) 
	..i PersonRowId'="" d
	...set PersonObject = ##class(DHCMGNUR.MgPersons).%OpenId(PersonRowId)
	...set NurseName = PersonObject.PersonName
	..set AJTypes = AJObject.AJType
	..for i=1:1:$L(AJTypes,",") do
	...set AJType = $P(AJTypes,",",i)
	...if (AJType="Holiday")||(AJType="Rest") do
	....set AJCode = $P(AJObject.AJCodeDR,",",i)
	....q:AJType'="Holiday"
	....set HolidayObject = ##class(DHCMGNUR.MgNurHolidayCode).%OpenId(AJCode)
	....set HolidayDesc = HolidayObject.HolidayDesc
	....b ;119
	....i AJObject.AJDate'="" d
	.....i ((dateFlag=3)!(dateFlag=4)) s HolidayDate=##class(web.DHCMgNurPerHRComm).getDateFormat(AJObject.AJDate)
	.....e  s HolidayDate = ""
	....e  s HolidayDate=""
	....set StTime2 = AJObject.AJStTime
	....set EndTime2 = AJObject.AJEndTime
	....set Remark = $P(AJObject.AJRemarks,"\",i)
	....s ret="WardDesc|"_WardDesc_"^NurseId|"_NurseId_"^NurseName|"_NurseName_"^HolidayDesc|"_HolidayDesc_"^HolidayDate|"_HolidayDate //$zd(HolidayDate,3)
	....s ret=ret_"^StTime2|"_$zt(StTime2,1)_"^EndTime2|"_$zt(EndTime2,1)_"^Remark"_Remark_"^rw|"_AJRowId
	....Do OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHolidayDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHolidayDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindHolidayDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHolidayDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询加班信息
/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","FindOverTimeData","27^2015-04-13^2015-04-18^N")
Query FindOverTimeData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOverTimeDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s repid=$I(^CacheTemp)
	s ind=1
	set WardId = $P(parr,"^",1)
	set StDate = $zdh($P(parr,"^",2),3)
	set EndDate = $zdh($P(parr,"^",3),3)
	set PersonType=$P(parr,"^",4)
	for AdmDate=StDate:1:EndDate do
	.set WardDesc = $P(^CTLOC(WardId),"^",2)
	.set AJRowId = ""
	.for  set AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_WardId," "_AdmDate,AJRowId)) q:AJRowId=""  do
	..set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	..set NurseId = AJObject.AJNurseDR
	..set AJNurseType=AJObject.AJNurseType
	..q:(PersonType'="")&&(AJNurseType'=PersonType)&&(PersonType'="ALL")
	..set PersonRowId = $O(^DHCMGNUR.MgPersonsI("SSID"," "_NurseId,"")) 
	..i PersonRowId'="" d
	...set PersonObject = ##class(DHCMGNUR.MgPersons).%OpenId(PersonRowId)
	...set NurseName = PersonObject.PersonName
	..set AJTypes = AJObject.AJType
	..for i=1:1:$L(AJTypes,",") do
	...set AJType = $P(AJTypes,",",i)
	...q:AJType'="OverTime"
	...set AJCode = $P(AJObject.AJCodeDR,",",i)
	...i AJObject.AJDate'="" d
	....i ((dateFlag=3)!(dateFlag=4)) set OTDate =##class(web.DHCMgNurPerHRComm).getDateFormat(AJObject.AJDate)
	....e  s OTDate=""
	...e  s OTDate=""
	...set StTime = $P(AJObject.AJStTime,",",i)
	...set EndTime = $P(AJObject.AJEndTime,",",i)
	...set Remarks = $P(AJObject.AJRemarks,"\",i)
	...if EndTime>StTime set TotalHour = (EndTime-StTime)/3600
	...else  set TotalHour = (EndTime-StTime)/3600+24
	...i TotalHour#0.1>=0.05 s TotalHour=TotalHour-(TotalHour#0.1)+0.1
	...else  s TotalHour=TotalHour-(TotalHour#0.1)
	...s ret="WardDesc|"_WardDesc_"^NurseId|"_NurseId_"^NurseName|"_NurseName_"^OTDate|"_OTDate
	...s ret=ret_"^StTime|"_$zt(StTime,1)_"^EndTime|"_$zt(EndTime,1)_"^Remarks|"_Remarks_"^TotalHour|"_TotalHour_"^rw|"_AJRowId
	...Do OutputRow3 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOverTimeDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOverTimeDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOverTimeDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOverTimeDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询单个护士某天的排班记录
/// Input:WardId^NurseId^AdmDate
/// OutPut:AJType^AJCodeDR^AJStTime^AJEndTime^AJJobInterval^AJRemarks
/// w ##class(DHCMGNUR.MgNurArrangeJob).FindNurRosterData("1018^9324^2014-01-14")
ClassMethod FindNurRosterData(parr As %String) As %String
{
	s ret=""
	set WardId = $P(parr,"^",1)
	set NurseId = $P(parr,"^",2)
	set AdmDate = $zdh($P(parr,"^",3),3)
	set NurseType=$P(parr,"^",4)
	b ;01
	set AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(NurseType,"U")," "_NurseId," "_AdmDate,""))
	i AJRowId'=""  d
	.set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	.set AJType = AJObject.AJType
	.set AJCodeDR = AJObject.AJCodeDR
	.set AJStTime = AJObject.AJStTime
	.set AJEndTime = AJObject.AJEndTime
	.set AJJobInterval = AJObject.AJJobInterval
	.set AJRemarks = AJObject.AJRemarks
	.set ret = AJType_"^"_AJCodeDR_"^"_AJStTime_"^"_AJEndTime_"^"_AJJobInterval_"^"_AJRemarks
	e  d
	.s ret=1
	q ret
}

/// w ##class(DHCMGNUR.MgNurArrangeJob).CheckEmptyPost("1018^2014-06-24^2014-06-30")
ClassMethod CheckEmptyPost(parr As %String) As %String
{
	q:parr=""
	s WardId = $P(parr,"^",1)
	s StDate = $zdh($P(parr,"^",2),3)
	s EndDate = $zdh($P(parr,"^",3),3)
	s tmp="" 
	s flag="Y"
	d ##class(DHCMGNUR.MgNurArgJobChild).getDeptNurse(parr,.tmp)
	s nOrder="" f  s nOrder=$O(tmp(nOrder)) q:(nOrder="")!(flag="N")  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.s PersonID=PerArray("PersonID")
	.s PersonType=PerArray("PersonType")
	.f AdmDate=StDate:1:EndDate d
	..s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_PersonType," "_$zcvt(PersonID,"U")," "_AdmDate,"")) 
	..q:AJRowId'="" 
	..s flag="N"
	q flag
}

/// 按人统计全院班次信息
/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","CountPostByPerson","70^2015-08-17^2015-04-23^^^")
/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","CountPostByPerson","868^2014-09-15^2014-09-21^^All^W")
Query CountPostByPerson(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CountPostByPersonExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s WardId=$P(parr,"^",1)
	s StDate = $zdh($P(parr,"^",2),3)
	s EndDate = $zdh($P(parr,"^",3),3)
	s PersonID=$zcvt($P(parr,"^",4),"U")
	s PersonType=$P(parr,"^",5)
	s Count=""
	s TotalNum=""
	i WardId=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i PersonID'="" d
	.s perdr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(PersonID,"U"),""))
	.q:perdr=""
	.s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	.s PersonType= perobj.PersonType2
	.f AdmDate=StDate:1:EndDate d
	..s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(PersonType,"U")," "_PersonID," "_AdmDate,""))
	..q:AJRowId=""
	..d GetPerPost
	.d CountPersonPost
	else  d
	.i PersonType'="" d
	..s NurseID="" f  s NurseID=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(PersonType,"U"),NurseID)) q:NurseID=""  d
	...s PersonID=$P(NurseID," ",2)
	...i PersonType="N" s flag=##class(web.DHCNurArgJobNurInfo).CheckNurDept(PersonID_"^"_parr)
	...e  s flag=##class(web.DHCNurArgJobNurInfo).CheckTmpNurDept(PersonID_"^"_parr)
	...q:flag=0
	...f AdmDate=StDate:1:EndDate d
	....s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(PersonType,"U")," "_PersonID," "_AdmDate,""))
	....q:AJRowId="" 
	....d GetPerPost
	...d CountPersonPost
	.else  d
	..s PersonType="" f  s PersonType=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId,PersonType)) q:PersonType=""  d
	...s NurseID="" f  s NurseID=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId,PersonType,NurseID)) q:NurseID=""  d
	....s PersonID=$P(NurseID," ",2)
	....i PersonType=" N" s flag=##class(web.DHCNurArgJobNurInfo).CheckNurDept(PersonID_"^"_parr)
	....e  s flag=##class(web.DHCNurArgJobNurInfo).CheckTmpNurDept(PersonID_"^"_parr)
	....q:flag=0
	....f AdmDate=StDate:1:EndDate d
	.....s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId,PersonType,NurseID," "_AdmDate,""))
	.....q:AJRowId="" 
	.....d GetPerPost
	....d CountPersonPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetPerPost
	s AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	s NurseRowId=AJObject.AJNurseDR
	i $d(TotalNum(NurseRowId))=0 s TotalNum(NurseRowId)=0
	s AJTypes = AJObject.AJType
	f i=1:1:$L(AJTypes,",") d
	.s AJType=$P(AJTypes,",",i)
	.q:AJType'="Post"
	.s AJCode = $P(AJObject.AJCodeDR,",",i)
	.s AJJobInterval = $P(AJObject.AJJobInterval,",",i)
	.s PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJCode)
	.s PostCode = PostObject.PostCode
	.s PostHours = PostObject.PostHours
	.i $D(Count(NurseRowId,AJCode))=0  set Count(NurseRowId,AJCode)=0
	.i (AJJobInterval="H") d
	..s Count(NurseRowId,AJCode)=Count(NurseRowId,AJCode)+1 
	..s TotalNum(NurseRowId)=TotalNum(NurseRowId)+1
	.else  s Count(NurseRowId,AJCode)=Count(NurseRowId,AJCode)+0.5 s TotalNum(NurseRowId)=TotalNum(NurseRowId)+0.5
	q
CountPersonPost	
	s MgPerID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(PersonID,"U"),""))
	q:$g(MgPerID)=""
	s a=##class(DHCMGNUR.MgPersons).%OpenId(MgPerID)
	s NurseRowId=a.PersonID
	s NurseName=a.PersonName
	s ret="NurseId|"_NurseRowId_"^NurseName|"_NurseName
	s order="" f  s order=$O(^DHCMGNUR.MgNurPostI("WardOrder"," "_WardId,order)) q:order=""  d
	.s PostId="" f  s PostId = $O(^DHCMGNUR.MgNurPostI("WardOrder"," "_WardId,order,PostId)) q:PostId=""  d 
	..set PostObj = ##class(DHCMGNUR.MgNurPost).%OpenId(PostId)
	..set PostValid = PostObj.PostValid
	..q:(PostValid="N")
	..s ret = ret_"^Post"_PostId_"|"_$g(Count(NurseRowId,PostId))
	s ret = ret_"^TotalNum|"_$g(TotalNum(NurseRowId))
	d OutputPostRow
	q
OutputPostRow
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CountPostByPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CountPostByPersonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CountPostByPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CountPostByPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按时间和病区统计护士休假信息
/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","CountHolidayData","27^2015-04-13^2015-04-18^N")
Query CountHolidayData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CountHolidayDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set WardId = $P(parr,"^",1)
	set StDate = $zdh($P(parr,"^",2),3)
	set EndDate = $zdh($P(parr,"^",3),3)
	set PersonType=$P(parr,"^",4)
	set count=""
	set total=""
	set tmp=""
	d ##class(DHCMGNUR.MgNurArgJobChild).getDeptNurse(parr,.tmp)
	for AdmDate=StDate:1:EndDate do
	.set AJRowId = "" for  set AJRowId = $O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_WardId," "_AdmDate,AJRowId)) q:AJRowId=""  do
	..set AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	..set NurseId = AJObject.AJNurseDR
	..set AJNurseType=AJObject.AJNurseType
	..q:(PersonType'="")&&(PersonType'=AJNurseType)&&(PersonType'="ALL")
	..set PersonRowId = $O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(NurseId,"U"),"")) 
	..q:PersonRowId=""
	..set PersonObject = ##class(DHCMGNUR.MgPersons).%OpenId(PersonRowId)
	..set NurseName = PersonObject.PersonName
	..set AJTypes = AJObject.AJType
	..set AJJobIntervals = AJObject.AJJobInterval
	..for i=1:1:$L(AJTypes,",") do
	...set AJType = $P(AJTypes,",",i)
	...q:(AJType'="Holiday") ;||(AJType'="Rest")
	...set AJCode = $P(AJObject.AJCodeDR,",",i)
	...set AJJobInterval=$P(AJJobIntervals,",",i)
	...i $d(count(NurseId,AJCode))'=0 d
	....i AJJobInterval'="H" set count(NurseId,AJCode)=count(NurseId,AJCode)+0.5
	....else  set count(NurseId,AJCode)=count(NurseId,AJCode)+1
	...else  d
	....i AJJobInterval'="H" set count(NurseId,AJCode)=0.5
	....else  set count(NurseId,AJCode)=1
	...i $d(total(NurseId))=0 d
	....i AJJobInterval'="H" set total(NurseId)=0.5
	....else  set total(NurseId)=1
	...else  d
	....i AJJobInterval'="H" set total(NurseId)=total(NurseId)+0.5
	....else  set total(NurseId)=total(NurseId)+1
	set nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.s NurseId=PerArray("PersonID")
	.s NurseName=PerArray("PersonName")
	.q:(PersonType'="")&&(PerArray("PersonType")'=PersonType)
	.set ret="NurseId|"_NurseId_"^NurseName|"_NurseName
	.s hldid="" f  s hldid=$O(^DHCMGNUR.MgNurHolidayCodeD(hldid)) q:hldid=""  d
	..s hldobj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(hldid)
	..q:hldobj.HolidayStatus="N"
	..if $d(count(NurseId,hldid))'=0 set ret=ret_"^Holiday"_hldid_"|"_count(NurseId,hldid)
	..else  set ret=ret_"^Holiday"_hldid_"|"
	.if $d(total(NurseId))'=0 set ret=ret_"^TotalNum|"_total(NurseId)
	.else  set ret=ret_"^TotalNum|"
	.Do OutputCountRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCountRow
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CountHolidayDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CountHolidayDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CountHolidayDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CountHolidayDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(DHCMGNUR.MgNurArrangeJob).SaveConnBed("76^04428^2015-06-10^3^N")
ClassMethod SaveConnBed(parm As %String) As %String
{
	q:parm="" 0
	s ^TempXBL("Bed")=parm
	f i=1:1:$L(parm,"!") d //日期
	.s parr=$P(parm,"!",i)
	.s WardId=$P(parr,"^",1)
	.s NurseId=$P(parr,"^",2)
	.s AdmDate=$zdh($P(parr,"^",3),3)
	.s ConnBed=$P(parr,"^",4)
	.s NurseType=$P(parr,"^",5)
	.s Id=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(NurseType,"U")," "_$zcvt(NurseId,"U")," "_AdmDate,""))
	.b ;00
	.q:Id="" 
	.s a=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(Id)
	.s a.AJConnBed=ConnBed
	.d a.%Save()
	q 1
}

/// w ##class(DHCMGNUR.MgNurArrangeJob).getBedValue("1018^9151^2014-09-15^MP")
ClassMethod getBedValue(parr As %String) As %String
{
	q:parr="" ""
	s WardId=$P(parr,"^",1)
	s NurseId=$P(parr,"^",2)
	s AdmDate=$zdh($P(parr,"^",3),3)
	s NurseType=$P(parr,"^",4)
	s PAWardId=$O(^PAWARD(0,"WARD_LocationDR",WardId,""))
	s Id=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(NurseType,"U")," "_NurseId," "_AdmDate,""))
	q:Id="" ""
	s a=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(Id)
	s GroupIds=a.AJConnBed
	q:GroupIds="" ""
	s ret=""
	f i=1:1:$L(GroupIds,",")
	{
		s GroupId=$P(GroupIds,",",i)
		s temp=##class(DHCMGNUR.MgNurBedGroup).getVal(GroupId)
		s GroupArr=""
		d ##Class(web.DHCNurRosterComm).setTmp(temp,.GroupArr)
		i ret'="" s ret=ret_","_GroupArr("BedDesc")
		else  s ret=GroupArr("BedDesc")
	}
	q ret
}

/// w ##class(DHCMGNUR.MgNurArrangeJob).getConnBed("1018^8584^2014-08-04")
ClassMethod getConnBed(parr As %String) As %String
{
	q:parr=""
	s WardId=$P(parr,"^",1)
	s NurseId=$P(parr,"^",2)
	s AdmDate=$zdh($P(parr,"^",3),3)
	s NurseType=$P(parr,"^",4)
	s Id=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(NurseType,"U")," "_NurseId," "_AdmDate,""))
	q:Id=""
	s a=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(Id)
	s ret=a.AJConnBed
	q ret
}

/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","countPostByWard","1018^2014-08-11^2014-08-17^Ward")
Query countPostByWard(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod countPostByWardExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s WardId=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s FindType=$P(parr,"^",4)
	s NurseType=$P(parr,"^",5)
	s NightCount="" s TotalCount="" s PostCount=""
	i WardId'="" d GetWardPost
	else  d
	.s WardOrder="" f  s WardOrder = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder)) q:WardOrder=""  do
	..s PerWardId = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder,"")) q:PerWardId=""
	..s PerWardObj = ##class(DHCMGNUR.MgNurPerWard).%OpenId(PerWardId)
	..s WardId= PerWardObj.WardLoc
	..q:$d(^CTLOC(WardId))=0
	..d GetWardPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetWardPost
	s NightCount(WardId)=0 s TotalCount(WardId)=0
	s NurseID="" f  s NurseID=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId,NurseID)) q:NurseID=""  d
	.s PersonID=$P(NurseID," ",2)
	.f AdmDate=StDate:1:EndDate d
	..s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_PersonID," "_AdmDate,"")) q:AJRowId="" 
	..d GetPostCell
	d OutWardPost
	q
GetPostCell
	s AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	s AJTypes = AJObject.AJType
	f i=1:1:$L(AJTypes,",") d
	.s AJType=$P(AJTypes,",",i)
	.q:AJType'="Post"
	.s AJCode = $P(AJObject.AJCodeDR,",",i)
	.s AJJobInterval = $P(AJObject.AJJobInterval,",",i)
	.s PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJCode)
	.s PostCode = PostObject.PostCode
	.s PostHours = PostObject.PostHours
	.s PostType=PostObject.PostType
	.s cdsobj=##class(DHCMGNUR.CommDictionarySub).%OpenId(PostType)
	.i $D(PostCount(WardId,AJCode))=0  s PostCount(WardId,AJCode)=0
	.i (AJJobInterval="H") s PostNumber=1
	.else  s PostNumber=0.5
	.s PostCount(WardId,AJCode)=PostCount(WardId,AJCode)+PostNumber
	.s TotalCount(WardId)=TotalCount(WardId)+PostNumber
	.i cdsobj.CodeDesc["夜" s NightCount(WardId)=NightCount(WardId)+PostNumber
	q
OutWardPost
	s WardCode=$P(^CTLOC(WardId),"^",1)
	s ret=WardId_"^"_WardCode
	i FindType="All" d
	.s PostId = "" f  s PostId = $O(^DHCMGNUR.MgNurPostD(PostId)) q:PostId=""  d
	..s PostObj = ##class(DHCMGNUR.MgNurPost).%OpenId(PostId)
	..q:(PostObj.PostValid="N")
	..i $d(PostCount(WardId,PostId))'=0 s ret = ret_"^"_PostCount(WardId,PostId)
	..else  s ret = ret_"^0"
	.i $d(NightCount(WardId))'=0 s ret = ret_"^"_NightCount(WardId)
	.else  s ret=ret_"^0"
	.i $d(TotalCount(WardId))'=0 s ret = ret_"^"_TotalCount(WardId)
	.else  s ret=ret_"^0"
	.d OutputPostRow
	i FindType="Ward" d
	.set WardPostCount=##class(DHCMGNUR.MgNurWardPost).getCount(WardId)
	.for Order=1:1:WardPostCount d
	..s PostId = $O(^DHCMGNUR.MgNurWardPostI("WardOrder"," "_WardId," "_Order,"")) q:PostId=""
	..set a=##class(DHCMGNUR.MgNurWardPost).%OpenId(PostId)
	..set WardPostId=a.PostID
	..set PostObj = ##class(DHCMGNUR.MgNurPost).%OpenId(WardPostId)
	..set PostValid = PostObj.PostValid
	..q:(PostValid="N")
	..i $d(PostCount(WardId,WardPostId))'=0 s ret = ret_"^"_PostCount(WardId,WardPostId)
	..else  s ret = ret_"^0"
	.i $d(NightCount(WardId))'=0 s ret = ret_"^"_NightCount(WardId)
	.else  s ret=ret_"^0"
	.i $d(TotalCount(WardId))'=0 s ret = ret_"^"_TotalCount(WardId)
	.else  s ret=ret_"^0"
	.d OutputPostRow
	q
OutputPostRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod countPostByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = countPostByWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod countPostByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = countPostByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","countHolidayByWard","1018^2014-08-11^2014-08-17")
Query countHolidayByWard(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod countHolidayByWardExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s WardId=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s HolidayCount="",TolalCount=""
	i WardId'="" d GetWardHoliday
	else  d
	.s WardOrder="" f  s WardOrder = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder)) q:WardOrder=""  do
	..s PerWardId = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder,"")) q:PerWardId=""
	..s PerWardObj = ##class(DHCMGNUR.MgNurPerWard).%OpenId(PerWardId)
	..s WardId= PerWardObj.WardLoc
	..q:$d(^CTLOC(WardId))=0
	..d GetWardHoliday
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetWardHoliday
	s HolidayCount(WardId)=0 s TotalCount(WardId)=0
	s NurseID="" f  s NurseID=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId,NurseID)) q:NurseID=""  d
	.s PersonID=$P(NurseID," ",2)
	.f AdmDate=StDate:1:EndDate d
	..s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_PersonID," "_AdmDate,"")) q:AJRowId="" 
	..d GetHolidayCell
	d OutWardHoliday
	q
GetHolidayCell
	s AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	s AJTypes = AJObject.AJType
	f i=1:1:$L(AJTypes,",") d
	.s AJType=$P(AJTypes,",",i)
	.s AJJobInterval = $P(AJObject.AJJobInterval,",",i)
	.q:(AJType'="Holiday") ;&&(AJType'="Test")
	.s AJCode = $P(AJObject.AJCodeDR,",",i)
	.i $D(HolidayCount(WardId,AJCode))=0  s HolidayCount(WardId,AJCode)=0
	.i (AJJobInterval="H") s PostNumber=1
	.else  s PostNumber=0.5
	.s HolidayCount(WardId,AJCode)=HolidayCount(WardId,AJCode)+PostNumber
	.s TotalCount(WardId)=TotalCount(WardId)+PostNumber
	q
OutWardHoliday
	s WardCode=$P(^CTLOC(WardId),"^",1)
	s ret=WardId_"^"_WardCode
	s hldid="" f  s hldid=$O(^DHCMGNUR.MgNurHolidayCodeD(hldid)) q:hldid=""  d
	.s hldobj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(hldid)
	.q:hldobj.HolidayDesc="N"
	.i $d(HolidayCount(WardId,hldid))'=0 s ret = ret_"^"_HolidayCount(WardId,hldid)
	.else  s ret = ret_"^"
	i $d(TotalCount(WardId))'=0 s ret = ret_"^"_TotalCount(WardId)
	else  s ret=ret_"^"
	d OutputHolidayRow
	q
OutputHolidayRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod countHolidayByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = countHolidayByWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod countHolidayByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = countHolidayByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJob","countScoreByWard","1018^2014-08-11^2014-08-17")
Query countScoreByWard(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod countScoreByWardExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s WardId=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s NightCount="" s TotalCount="" s TotalScore="" ;s PostCount=""
	i WardId'="" d GetWardPost
	else  d
	.s WardOrder="" f  s WardOrder = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder)) q:WardOrder=""  do
	..s PerWardId = $O(^DHCMGNUR.MgNurPerWardI("WardOrd",WardOrder,"")) q:PerWardId=""
	..s PerWardObj = ##class(DHCMGNUR.MgNurPerWard).%OpenId(PerWardId)
	..s WardId= PerWardObj.WardLoc
	..q:$d(^CTLOC(WardId))=0
	..d GetWardPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetWardPost
	s NightCount(WardId)=0 s TotalCount(WardId)=0 s TotalScore(WardId)=0
	s NurseID="" f  s NurseID=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId,NurseID)) q:NurseID=""  d
	.s PersonID=$P(NurseID," ",2)
	.f AdmDate=StDate:1:EndDate d
	..s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_PersonID," "_AdmDate,"")) q:AJRowId="" 
	..d GetPostCell
	d OutWardScore
	q
GetPostCell
	s AJObject = ##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	s AJTypes = AJObject.AJType
	f i=1:1:$L(AJTypes,",") d
	.s AJType=$P(AJTypes,",",i)
	.q:AJType'="Post"
	.s AJCode = $P(AJObject.AJCodeDR,",",i)
	.s AJJobInterval = $P(AJObject.AJJobInterval,",",i)
	.s PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJCode)
	.s PostCode = PostObject.PostCode
	.s PostHours = PostObject.PostHours
	.s PostType=PostObject.PostType
	.s cdsobj=##class(DHCMGNUR.CommDictionarySub).%OpenId(PostType)
	.;i $D(PostCount(WardId,AJCode))=0  s PostCount(WardId,AJCode)=0
	.i (AJJobInterval="H") s PostNumber=1
	.else  s PostNumber=0.5
	.;s PostCount(WardId,AJCode)=PostCount(WardId,AJCode)+PostNumber
	.s TotalCount(WardId)=TotalCount(WardId)+PostNumber
	.i cdsobj.CodeDesc["夜" s NightCount(WardId)=NightCount(WardId)+PostNumber
	q
OutWardScore
	s WardCode=$P(^CTLOC(WardId),"^",1)
	s ret=WardId_"^"_WardCode
	i $d(NightCount(WardId))'=0 s ret = ret_"^"_NightCount(WardId)
	else  s ret=ret_"^0"
	i $d(TotalCount(WardId))'=0 s ret = ret_"^"_TotalCount(WardId)
	else  s ret=ret_"^0"
	s TotalScore(WardId)=NightCount(WardId)+(TotalCount(WardId)-NightCount(WardId))*0.7
	s ret=ret_"^"_TotalScore(WardId)
	d OutputScoreRow
	q
OutputScoreRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod countScoreByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = countScoreByWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod countScoreByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = countScoreByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query countWorkload(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod countWorkloadExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod countWorkloadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = countWorkloadExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod countWorkloadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = countWorkloadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(DHCMGNUR.MgNurArrangeJob).FindControlData("1018^9151^2014-09-20^MP")
ClassMethod FindControlData(parr As %String) As %String
{
	q:parr=""
	s ^TEMP("g1202004")=parr
	s ret=""
	s WardId=$P(parr,"^",1)
	s NurseId=$P(parr,"^",2)
	s StDate=$zdh($P(parr,"^",3),3)
	s EndDate=$zdh($P(parr,"^",4),3)
	s NurseType=$P(parr,"^",5)
	f AdmDate=StDate:1:EndDate d ///该护士一周的班次统计
	.s parm=WardId_"^"_NurseId_"^"_$zd(AdmDate,3)_"^"_NurseType
	.s temp="" k temp
	.d ..getValue(parm,.temp)
	.i $g(temp("Post"))'="" d
	..i $g(TotalPost)="" s TotalPost=temp("Post")
	..e  s TotalPost=TotalPost+temp("Post")
	.e  s TotalPost=0
	.i $g(temp("PostHour"))'="" d
	..i $g(TotalPostHour)="" s TotalPostHour=temp("PostHour")
	..e  s TotalPostHour=TotalPostHour+temp("PostHour")
	.e  s TotalPostHour=0
	.i $g(temp("Night"))'="" d
	..i $g(TotalNight)="" s TotalNight=temp("Night")
	..e  s TotalNight=TotalNight+temp("Night")
	.e  s TotalNight=0
	.i $g(temp("NightHour"))'="" d
	..i $g(TotalNightHour)="" s TotalNightHour=temp("NightHour")
	..e  s TotalNightHour=TotalNightHour+temp("NightHour")
	.e  s TotalNightHour=0
	.i $g(temp("Holiday"))'="" d
	..i $g(TotalHoliday)="" s TotalHoliday=temp("Holiday")
	..e  s TotalHoliday=TotalHoliday+temp("Holiday")
	.e  s TotalHoliday=0
	.i $g(temp("OverTime"))'="" d
	..i $g(TotalOverTime)="" s TotalOverTime=temp("OverTime")
	..e  s TotalOverTime=TotalOverTime+temp("OverTime") 
	.e  s TotalOverTime=0
	s ret="班数|"_TotalPost_"^班次小时数|"_TotalPostHour_"^夜班数|"_TotalNight_"^夜班小时数|"_TotalNightHour
	s ret=ret_"^假期数|"_TotalHoliday_"^加班小时数|"_TotalOverTime
	q ret
}

/// d ##class(DHCMGNUR.MgNurArrangeJob)getValue("1018^9151^2014-09-20^MP",.temp)
ClassMethod getValue(parr As %String, temp As %String) As %String
{
	s ^TEMP("g12020005")=parr
	q:parr="" ""
	s temp("Post")=0,temp("PostHour")=0,temp("Night")=0,temp("NightHour")=0,temp("Holiday")=0,temp("OverTime")=0
	s WardId=$P(parr,"^",1)
	s NurseId=$P(parr,"^",2)
	s AdmDate=$zdh($P(parr,"^",3),3)
	s NurseType=$P(parr,"^",4)
	s ID=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_$zcvt(NurseType,"U")," "_NurseId," "_AdmDate,""))
	q:ID="" ""
	s a=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(ID)
	f i=1:1:$L(a.AJType,",") d
	.s AJType=$P(a.AJType,",",i)
	.s AJCode=$P(a.AJCodeDR,",",i)
	.s AJJobInterval=$P(a.AJJobInterval,",",i)
	.i AJType="Post" d
	..s b=##class(DHCMGNUR.MgNurPost).%OpenId(AJCode)
	..s PostType=b.PostType
	..s cdsobj=##class(DHCMGNUR.CommDictionarySub).%OpenId(PostType)
	..s PostHours=b.PostHours
	..i AJJobInterval="H" d
	...s temp("Post")=temp("Post")+1
	...s temp("PostHour")=temp("PostHour")+PostHours
	...i cdsobj.CodeDesc["夜" d
	....s temp("Night")=temp("Night")+1
	....s temp("NightHour")=temp("NightHour")+PostHours
	..e  d
	...s temp("Post")=temp("Post")+(1/2)
	...s temp("PostHour")=temp("PostHour")+(PostHours/2)
	...i cdsobj.CodeDesc["夜" d
	....s temp("Night")=temp("Night")+(1/2)
	....s temp("NightHour")=temp("NightHour")+(PostHours/2)
	.i AJType="Holiday" d
	..i AJJobInterval="H" d
	...s temp("Holiday")=temp("Holiday")+1
	...i $g(temp("Holiday",AJCode))="" s temp("Holiday")=1
	...e  s temp("Holiday",AJCode)=temp("Holiday")+1
	..e  d
	...s temp("Holiday")=temp("Holiday")+(1/2)
	...i $g(temp("Holiday",AJCode))="" s temp("Holiday")=(1/2) 
	...e  s temp("Holiday",AJCode)=temp("Holiday")+(1/2)
	.i AJType="OverTime" d
	..s temp("OverTime")=temp("OverTime")+$E(AJCode,2,$L(AJCode))
	q
}

ClassMethod GetDataType(parr As %String) As %String
{
	q:parr=""
	s WardId = $P(parr,"^",1)
	s StDate = $zdh($P(parr,"^",2),3)
	s EndDate = $zdh($P(parr,"^",3),3)
	s tmp="" 
	s ret=""
	d ##class(DHCMGNUR.MgNurArgJobChild).getDeptNurse(parr,.tmp)
	s nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.s PersonID=PerArray("PersonID")
	.s PersonType=PerArray("PersonType")
	.f AdmDate=StDate:1:EndDate d
	..i ret="" s ret=PersonID_"-"_$zd(AdmDate,3)_"|"
	..e  s ret=ret_"^"_PersonID_"-"_$zd(AdmDate,3)_"|"
	..s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_WardId," "_PersonType," "_$zcvt(PersonID,"U")," "_AdmDate,"")) 
	..q:AJRowId=""
	..;b ;00
	..s ajobj=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(AJRowId)
	..s ajtypes=ajobj.AJType
	..s ajcodes=ajobj.AJCodeDR
	..s paret=""
	..f i=1:1:$L(ajcodes,",") d
	...s ajcode=$P(ajcodes,",",i)
	...s ajtype=$P(ajtypes,",",i)
	...i ajtype="Holiday" d
	....s hldyobj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(ajcode)
	....s hldydesc=hldyobj.HolidayDesc
	....;i (hldydesc["教")!(hldydesc["病") d
	....i (hldydesc["教") d
	.....i paret'="H-J" s paret="H-J"
	....e  i hldydesc'="----" s paret="H"
	...i ajtype="Post" d
	....s postobj=##class(DHCMGNUR.MgNurPost).%OpenId(ajcode)
	....s posttype=postobj.PostType
	....q:posttype=""
	....s cdsobj=##class(DHCMGNUR.CommDictionarySub).%OpenId(posttype)
	....i cdsobj.CodeDesc["夜" i paret'["H" s paret="P-N"
	....e  s paret="P"
	..s ret=ret_paret
	q ret
}

ClassMethod WeekCopy(parr As %String) As %String
{
	s wardid=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s enddate=$P(parr,"^",3)
	s parm=wardid_"^"_stdate_"^"_enddate
	s nurmaster=$P(parr,"^",4)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s laststdate=stdate-7
	s lastenddate=enddate-7
	f admdate=laststdate:1:lastenddate d
	.s ajid="" f  s ajid=$O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_wardid," "_admdate,ajid)) q:ajid=""  d
	..s ajobj=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(ajid)
	..s persontype=ajobj.AJNurseType
	..s perid=ajobj.AJNurseDR
	..i persontype="N" s flag=##class(web.DHCNurArgJobNurInfo).CheckNurDept(perid_"^"_parm)
	..else  s flag=##class(web.DHCNurArgJobNurInfo).CheckTmpNurDept(perid_"^"_parm)
	..q:flag=0
	..s ajid2=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_wardid," "_persontype," "_$zcvt(perid,"U")," "_(admdate+7),""))
	..i ajid2="" s ajobj2=##class(DHCMGNUR.MgNurArrangeJob).%New()
	..e  s ajobj2=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(ajid2)
	..s ajobj2.AJCodeDR=ajobj.AJCodeDR
	..s ajobj2.AJJobInterval=ajobj.AJJobInterval
	..s ajobj2.AJNurseDR=ajobj.AJNurseDR
	..s ajobj2.AJNurseType=ajobj.AJNurseType
	..s ajobj2.AJRemarks=ajobj.AJRemarks
	..s ajobj2.AJStTime=ajobj.AJStTime
	..s ajobj2.AJEndTime=ajobj.AJEndTime
	..s ajobj2.AJType=ajobj.AJType
	..s ajobj2.AJWardDR=wardid
	..s ajobj2.AJDate=admdate+7
	..s ajobj2.AJNurseMaster=nurmaster
	..s ajobj2.AJModifyDate=+$h
	..s ajobj2.AJModifyTime=$P($h,",",2)
	..d ajobj2.%Save()
	q 1
}

Storage Default
{
<Data name="MgNurArrangeJobDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AJCodeDR</Value>
</Value>
<Value name="3">
<Value>AJDate</Value>
</Value>
<Value name="4">
<Value>AJEndTime</Value>
</Value>
<Value name="5">
<Value>AJJobInterval</Value>
</Value>
<Value name="6">
<Value>AJModifyDate</Value>
</Value>
<Value name="7">
<Value>AJModifyTime</Value>
</Value>
<Value name="8">
<Value>AJNurseDR</Value>
</Value>
<Value name="9">
<Value>AJNurseMaster</Value>
</Value>
<Value name="10">
<Value>AJRemarks</Value>
</Value>
<Value name="11">
<Value>AJStTime</Value>
</Value>
<Value name="12">
<Value>AJType</Value>
</Value>
<Value name="13">
<Value>AJWardDR</Value>
</Value>
<Value name="14">
<Value>AJConnBed</Value>
</Value>
<Value name="15">
<Value>AJNurseType</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurArrangeJobD</DataLocation>
<DefaultData>MgNurArrangeJobDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurArrangeJobD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurArrangeJobI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurArrangeJobS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
