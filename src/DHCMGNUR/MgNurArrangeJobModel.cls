/// 排班模板存储
Class DHCMGNUR.MgNurArrangeJobModel Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 排班病区
Property AJWardDR As %String(TRUNCATE = 1) [ SqlFieldName = AJ_WardDR ];

/// 护士MgPersonsDR
Property AJNurseDR As %String(TRUNCATE = 1) [ SqlFieldName = AJ_Nurse ];

/// 排班代码
Property AJCodeDR As %String(TRUNCATE = 1) [ SqlFieldName = AJ_Code_DR ];

/// 排班类型
Property AJType As %String(TRUNCATE = 1) [ Required, SqlFieldName = AJ_Type ];

/// 班次日期
Property AJWeek As %String(TRUNCATE = 1) [ SqlFieldName = AJ_Week ];

/// 班次开始时间
Property AJStTime As %String(TRUNCATE = 1) [ SqlFieldName = AJ_StTime ];

/// 班次结束时间
Property AJEndTime As %String(TRUNCATE = 1) [ SqlFieldName = AJ_EndTime ];

/// 班时段
Property AJJobInterval As %String(TRUNCATE = 1) [ SqlFieldName = AJ_JobInterval ];

/// 模板指针DHCMGNUR.MgNurRosterModel
Property AJModelDR As %String(TRUNCATE = 1) [ SqlFieldName = AJ_Model_DR ];

/// 备注
Property AJRemarks As %String(TRUNCATE = 1) [ SqlFieldName = AJ_Remarks ];

/// 排班护士长
Property AJNurseMaster As %String(TRUNCATE = 1) [ SqlFieldName = AJ_NurseMaster ];

/// 排班日期
Property AJModifyDate As %Date [ SqlFieldName = AJ_Modify_Date ];

/// 排版时间
Property AJModifyTime As %Time [ SqlFieldName = AJ_Modify_Time ];

Index AJNurseIndex On AJNurseDR;

Index AJWeekIndex On AJWeek;

Index AJTypeIndex On AJType;

Index AJCodeDRIndex On AJCodeDR;

Index AJModelDRIndex On AJModelDR;

Index AJWardDRIndex On AJWardDR;

Index AJNurWeekIndex On (AJModelDR, AJWardDR, AJNurseDR, AJWeek);

Index AJNurseMasterIndex On AJNurseMaster;

/// 插入一条记录
/// Input:病区^模板^护士^班次^班次类型^班次日期^班次开始时间^
///       班次结束日期^备注^排班护士长
/// w ##class(DHCMGNUR.MgNurArrangeJobModel).SaveAJMData("1018^12^9324^6^Post^Monday^^^^6253^A")
ClassMethod SaveAJMData(parr As %String) As %String
{
	q:parr=""
	set AJMWardDR = $P(parr,"^",1)
	set AJModelDR = $P(parr,"^",2)
	q:AJModelDR=""
	set AJNurseDR = $P(parr,"^",3)
	set AJStTime = $P(parr,"^",7)
	set AJEndTime = $P(parr,"^",8)
	if $P(parr,"^",7)'="" set AJStTime = $zth(AJStTime)
	if $P(parr,"^",8)'="" set AJEndTime = $zth(AJEndTime)
	set AJWeek = $$ALPHAUP^SSUTIL4($P(parr,"^",6))
	set AJMRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_AJModelDR," "_AJMWardDR," "_AJNurseDR," "_AJWeek,""))
	b ;01
	if AJMRowId="" do
	.set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%New()
	.set AJMObject.AJWardDR = AJMWardDR
	.set AJMObject.AJModelDR = AJModelDR
	.set AJMObject.AJNurseDR = AJNurseDR
	.set AJMObject.AJCodeDR = $P(parr,"^",4)
	.set AJMObject.AJType = $P(parr,"^",5)
	.set AJMObject.AJWeek = AJWeek
	.set AJMObject.AJStTime=AJStTime
	.set AJMObject.AJEndTime = AJEndTime
	.set AJMObject.AJRemarks = $P(parr,"^",9)
	.set AJMObject.AJNurseMaster = $P(parr,"^",10)
	.set AJMObject.AJModifyDate = $P($h,",",1)
	.set AJMObject.AJModifyTime = $P($h,",",2)
	.set AJMObject.AJJobInterval = $P(parr,"^",11)
	else  do
	.set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	.set AJMObject.AJCodeDR = AJMObject.AJCodeDR_","_$P(parr,"^",4)
	.set AJMObject.AJType = AJMObject.AJType_","_$P(parr,"^",5)
	.set AJMObject.AJStTime = AJMObject.AJStTime_","_AJStTime
	.set AJMObject.AJEndTime = AJMObject.AJEndTime_","_AJEndTime
	.set AJMObject.AJRemarks = AJMObject.AJRemarks_"\"_$P(parr,"^",9)
	.set AJMObject.AJModifyDate = $P($h,",",1)
	.set AJMObject.AJModifyTime = $P($h,",",2)
	.set AJMObject.AJJobInterval =AJMObject.AJJobInterval_","_$P(parr,"^",11)
	TStart
	set sc = AJMObject.%Save()
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

ClassMethod SaveAJMData2(parr As %String) As %String
{
	q:parr=""
	set AJMWardDR = $P(parr,"^",1)
	set AJModelDR = $P(parr,"^",2) q:AJModelDR=""
	set AJNurseDR = $P(parr,"^",3)
	set AJWeek = $$ALPHAUP^SSUTIL4($P(parr,"^",6))
	set AJMRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_AJModelDR," "_AJMWardDR," "_AJNurseDR," "_AJWeek,""))
	if AJMRowId="" do
	.set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%New()
	.set AJMObject.AJWardDR = AJMWardDR
	.set AJMObject.AJModelDR = AJModelDR
	.set AJMObject.AJNurseDR = AJNurseDR
	.set AJMObject.AJCodeDR = $P(parr,"^",4)
	.set AJMObject.AJType = $P(parr,"^",5)
	.set AJMObject.AJWeek = AJWeek
	.set AJMObject.AJStTime=$P(parr,"^",7)
	.set AJMObject.AJEndTime = $P(parr,"^",8)
	.set AJMObject.AJRemarks = $P(parr,"^",9)
	.set AJMObject.AJNurseMaster = $P(parr,"^",10)
	.set AJMObject.AJModifyDate = $P($h,",",1)
	.set AJMObject.AJModifyTime = $P($h,",",2)
	.set AJMObject.AJJobInterval = $P(parr,"^",11)
	else  do
	.set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	.set AJMObject.AJCodeDR = AJMObject.AJCodeDR_","_$P(parr,"^",4)
	.set AJMObject.AJType = AJMObject.AJType_","_$P(parr,"^",5)
	.set AJMObject.AJStTime = AJMObject.AJStTime_","_$P(parr,"^",7)
	.set AJMObject.AJEndTime = AJMObject.AJEndTime_","_$P(parr,"^",8)
	.set AJMObject.AJRemarks = AJMObject.AJRemarks_"\"_$P(parr,"^",9)
	.set AJMObject.AJModifyDate = $P($h,",",1)
	.set AJMObject.AJModifyTime = $P($h,",",2)
	.set AJMObject.AJJobInterval =AJMObject.AJJobInterval_","_$P(parr,"^",11)
	TStart
	set sc = AJMObject.%Save()
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

/// 按单元格查询排班信息
/// Input:WardId^ModelId^NurseId^Week
/// Output:JobDesc
/// w ##class(DHCMGNUR.MgNurArrangeJobModel).FindAJMData("1018^14^9151^Monday")
ClassMethod FindAJMData(parr As %String) As %String
{
	q:parr=""
	set AJMWardDR = $P(parr,"^",1)
	set AJModelDR = $P(parr,"^",2)
	set AJNurseDR = $P(parr,"^",3)
	set AJWeek = $$ALPHAUP^SSUTIL4($P(parr,"^",4))
	set AJMRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_AJModelDR," "_AJMWardDR," "_AJNurseDR," "_AJWeek,""))
	q:AJMRowId=""
	set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	set AJMType = AJMObject.AJType
	set AJMCodeDR = AJMObject.AJCodeDR
	b ;01
	set ret=""
	for i=1:1:$L(AJMCodeDR,",") do
	.set AJMTypeItem = $P(AJMType,",",i)
	.set AJMCodeId = $P(AJMCodeDR,",",i)
	.b ;02
	.if AJMTypeItem="Post" do
	..set PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJMCodeId)
	..set PostDesc = PostObject.PostDesc
	..set PostHour = PostObject.PostHours
	..set PostType = PostObject.PostType
	..b ;03
	..if ret="" set ret=PostDesc_"^"_PostHour_"^"_PostType
	..else  set ret=ret_","_PostDesc_"^"_PostHour_"^"_PostType
	.if (AJMTypeItem="Holiday")||(AJMTypeItem="Rest") do
	..set holidayobj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(AJMCodeId)
	..set HolidayDesc = holidayobj.HolidayDesc
	..b ;04
	..if ret="" set ret=HolidayDesc_"^0^N"
	..else  set ret=ret_","_HolidayDesc_"^0^N"
	.if AJMTypeItem="OverTime" do
	..b ;05
	..if ret="" set ret= AJMCodeDR_"^0^N"
	..else  set ret = ret_","_AJMCodeDR_"^0^N"
	q ret
}

ClassMethod FindAJMData2(parr As %String) As %String
{
	;d ##class(DHCMGNUR.MgNurArrangeJobModel).FindAJMData2("1018^1^8172^Tuesday")
	q:parr=""
	set AJMWardDR = $P(parr,"^",1)
	set AJModelDR = $P(parr,"^",2)
	set AJNurseDR = $P(parr,"^",3)
	set AJWeek = $$ALPHAUP^SSUTIL4($P(parr,"^",4))
	set ret=""
	set AJMRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_AJModelDR," "_AJMWardDR," "_AJNurseDR," "_AJWeek,""))
	q:AJMRowId=""
	set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	set AJMType = AJMObject.AJType
	set AJMCodeDR = AJMObject.AJCodeDR
	set AJStTime = AJMObject.AJStTime
	set AJEndTime = AJMObject.AJEndTime
	set AJJobInterval = AJMObject.AJJobInterval
	set AJRemarks = AJMObject.AJRemarks
	set ret=AJMType_"^"_AJMCodeDR_"^"_AJStTime_"^"_AJEndTime_"^"_AJJobInterval_"^"_AJRemarks
	b ;01
	q ret
}

/// 按排班模板和病区查询排班信息
/// Input：ModelId^WardId
/// do ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJobModel","QueryAJMData","1^27")
Query QueryAJMData(parr As %String) As %Query(ROWSPEC = "ret")
{
}

ClassMethod QueryAJMDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TEMP("12171039001")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	if parr="" 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	set ModelId = $P(parr,"^",1)
	set WardId = $P(parr,"^",2)
	set WeeksDesc="Monday^Tuesday^Wednesday^Thursday^Friday^Saturday^Sunday"
	set tmp=""
	set StDate=$zd(+$h-$zd(+$h,10)+1,3)
	set EndDate=$zd(+$h-$zd(+$h,10)+7,3)
	set parm=WardId_"^"_StDate_"^"_EndDate
	d ##class(DHCMGNUR.MgNurArgJobChild).getDeptNurse(parm,.tmp)
	set nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.do GetItemData1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetItemData1
	set Count=0
	set NCount=0
	s PersonID=PerArray("PersonID")
	s PersonName=PerArray("PersonName")
	s PersonBtyDesc=PerArray("PersonBty")
	s PersonType=PerArray("PersonType")
	s ret="NurseID|"_PersonID_"^NurseName|"_PersonName_"^NurseType|"_PersonType
	for i=1:1:7 do
	.set HolidayFlag=0
	.set Week=$P(WeeksDesc,"^",i)
	.s ret=ret_"^"_Week_"|"
	.set JobDesc(Week)=""
	.set AJMRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_ModelId," "_WardId," "_PersonID," "_$zcvt(Week,"U"),"")) 
	.q:AJMRowId=""
	.set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	.set AJMType = AJMObject.AJType
	.set AJMCodeDR = AJMObject.AJCodeDR
	.for j=1:1:$L(AJMCodeDR,",") do
	..set AJMTypeItem = $P(AJMType,",",j)
	..set AJMCodeId = $P(AJMCodeDR,",",j)
	..if AJMTypeItem="Post" do
	...set PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJMCodeId)
	...;set PostHourNum = PostObject.PostHourNum
	...set PostType = PostObject.PostType
	...set TypeObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(PostType)
	...set TypeDesc=TypeObj.CodeDesc
	...set AJJobInterval = $P(AJMObject.AJJobInterval,",",j)
	...;if JobDesc(Week)="" set JobDesc(Week)=PostObject.PostCode
	...;else  set JobDesc(Week)=JobDesc(Week)_"/"_PostObject.PostCode
	...i JobDesc(Week)="" s JobDesc(Week)=PostObject.PostDesc
	...e  s JobDesc(Week)=JobDesc(Week)_"/"_PostObject.PostDesc
	...if ((AJJobInterval'="H")&&(AJJobInterval'="")) do
	....set JobDesc(Week) = JobDesc(Week)_"("_AJJobInterval_")" 
	....set Count=Count+(1/2)
	....if TypeDesc["夜" set NCount=NCount+(1/2)
	...else  set Count=Count+1 if TypeDesc["夜" set NCount=NCount+1
	..if (AJMTypeItem="Holiday")||(AJMTypeItem="Rest") do
	...set HolidayFlag=1
	...set holidayobj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(AJMCodeId)
	...set holidaydesc=holidayobj.HolidayDesc
	...if JobDesc(Week)="" set JobDesc(Week)= holidaydesc
	...else  set JobDesc(Week)= JobDesc(Week)_"/"_holidaydesc
	..if AJMTypeItem="OverTime" do
	...if JobDesc(Week)="" set JobDesc(Week)=AJMCodeDR
	...else  set JobDesc(Week)=JobDesc(Week)_"/"_AJMCodeDR
	.if HolidayFlag=1 set JobDesc(Week)= JobDesc(Week)
	.s ret=ret_JobDesc(Week)
	s ret=ret_"^Remarks|"_PersonBtyDesc_"^WorkNum|"_Count_"^NigthNum|"_NCount
	do OutputAJMRow
	q
OutputAJMRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryAJMDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAJMDataExecute ]
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

ClassMethod QueryAJMDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAJMDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurArrangeJobModel","QueryAJMData2","1^352")
Query QueryAJMData2(parr As %String) As %Query(ROWSPEC = "PersonID,PersonName,ModayJob,TuesdayJob,WednesdayJob,ThursdayJob,FridayJob,SaturdayJob,SundayJob,PersonBtyDesc,Count,NCount")
{
}

ClassMethod QueryAJMData2Execute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if parr="" 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	set ModelId = $P(parr,"^",1)
	set WardId = $P(parr,"^",2)
	set WeeksDesc="MONDAY^TUESDAY^WEDNESDAY^THURSDAY^FRIDAY^SATURDAY^SUNDAY"
	set tmp=""
	set StDate=$zd(+$h-$zd(+$h,10)+1,3)
	set EndDate=$zd(+$h-$zd(+$h,10)+7,3)
	set parm=WardId_"^"_StDate_"^"_EndDate
	d ##class(web.DHCNurArgJobNurInfo).getDeptNurse(parm,.tmp)
	set nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.do GetItemData1
	;set MgPersonId=""
	;for  set MgPersonId=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardId,MgPersonId)) q:MgPersonId=""  do
	.;do GetItemData1
	;set MgPersonId=""
	;for  set MgPersonId=$O(^DHCMGNUR.MgPersonsI("TempDep"," "_WardId,MgPersonId)) q:MgPersonId=""  do
	.;do GetItemData1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetItemData1
	set Count=0
	set NCount=0
	;w !,Count_","_NCount
	s PersonID=PerArray("PersonID")
	s PersonName=PerArray("PersonName")
	s PersonBtyDesc=PerArray("PersonBty")
	s PersonType=PerArray("PersonType")
	/*i PersonType="MP" d
	.set MgPersonId=$O(^DHCMGNUR.MgPersonsI("SSID"," "_PersonID,""))
	.set MgPersonsObj=##class(DHCMGNUR.MgPersons).%OpenId(MgPersonId)
	;set PersonID = MgPersonsObj.PersonID
	;set PersonName = MgPersonsObj.PersonName
	.;set PersonLoc = MgPersonsObj.PersonDepDR
	.;set PersonLocDesc = $P(^CTLOC(PersonLoc),"^",2)
	;set PersonBattery = MgPersonsObj.PersonBattery
	;if PersonBattery'="" set PersonBtyDesc = PersonBattery.Code
	;else  set PersonBtyDesc=""*/
	for i=1:1:7 do
	.set HolidayFlag=0
	.set Week=$P(WeeksDesc,"^",i)
	.set JobDesc(Week)=""
	.set AJMRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_ModelId," "_WardId," "_PersonID," "_Week,"")) 
	.q:AJMRowId=""
	.set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	.set AJMType = AJMObject.AJType
	.set AJMCodeDR = AJMObject.AJCodeDR
	.for j=1:1:$L(AJMCodeDR,",") do
	..set AJMTypeItem = $P(AJMType,",",j)
	..set AJMCodeId = $P(AJMCodeDR,",",j)
	..if AJMTypeItem="Post" do
	...set PostObject = ##class(DHCMGNUR.MgNurPost).%OpenId(AJMCodeId)
	...;set PostHourNum = PostObject.PostHourNum
	...set PostIsNight = PostObject.PostIsNight
	...set AJJobInterval = $P(AJMObject.AJJobInterval,",",j)
	...if JobDesc(Week)="" set JobDesc(Week)=PostObject.PostCode
	...else  set JobDesc(Week)=JobDesc(Week)_"/"_PostObject.PostCode
	...if ((AJJobInterval'="H")&&(AJJobInterval'="")) do
	....set JobDesc(Week) = JobDesc(Week) ;_"("_AJJobInterval_")" 
	....set Count=Count+(1/2)
	....if PostIsNight="Y" set NCount=NCount+1
	...else  set Count=Count+1 if PostIsNight="Y" set NCount=NCount+1
	..if (AJMTypeItem="Holiday")||(AJMTypeItem="Rest") do
	...set HolidayFlag=1
	...set CommDicId = $O(^DHCMGNUR.CommDictionaryI("Code"," 休假代码",""))
	...set HolidayObject = ##class(DHCMGNUR.CommDictionarySub).%OpenId(CommDicId_"||"_AJMCodeId)
	...if JobDesc(Week)="" set JobDesc(Week)= HolidayObject.Code
	...else  set JobDesc(Week)= JobDesc(Week)_"/"_HolidayObject.Code
	..if AJMTypeItem="OverTime" do
	...if JobDesc(Week)="" set JobDesc(Week)=AJMCodeDR
	...else  set JobDesc(Week)=JobDesc(Week)_"/"_AJMCodeDR
	.if HolidayFlag=1 set JobDesc(Week)= JobDesc(Week)
	do OutputAJMRow
	q
OutputAJMRow      
	set Data=$lb(PersonID,PersonName,JobDesc("MONDAY"),JobDesc("TUESDAY"),JobDesc("WEDNESDAY"),JobDesc("THURSDAY"),JobDesc("FRIDAY"),JobDesc("SATURDAY"),JobDesc("SUNDAY"),PersonBtyDesc,Count,NCount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryAJMData2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAJMData2Execute ]
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

ClassMethod QueryAJMData2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAJMData2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 删除排班模板信息
/// w ##class(DHCMGNUR.MgNurArrangeJobModel).DeleteAJMData("14^1018^9151^Monday")
ClassMethod DeleteAJMData(parr As %String) As %String
{
	set ModelId=$P(parr,"^",1)
	set WardId=$P(parr,"^",2)
	set NurseId=$P(parr,"^",3)
	set Week=$$ALPHAUP^SSUTIL4($P(parr,"^",4))
	set AJMRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_ModelId," "_WardId," "_NurseId," "_Week,""))
	q:AJMRowId=""
	set AJMObject = ##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJMRowId)
	TStart
	set sc = AJMObject.%DeleteId(AJMRowId)
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

/// d ##class(DHCMGNUR.MgNurArrangeJobModel).GetDataType("27^2")
ClassMethod GetDataType(parr As %String) As %String
{
	q:parr=""
	s WardId = $P(parr,"^",1)
	s modelid=$P(parr,"^",2)
	set StDate=$zd(+$h-$zd(+$h,10)+1,3)
	set EndDate=$zd(+$h-$zd(+$h,10)+7,3)
	set parm=WardId_"^"_StDate_"^"_EndDate
	s tmp=""
	set WeeksDesc="MONDAY^TUESDAY^WEDNESDAY^THURSDAY^FRIDAY^SATURDAY^SUNDAY" 
	s ret=""
	d ##class(DHCMGNUR.MgNurArgJobChild).getDeptNurse(parm,.tmp)
	s nOrder="" f  s nOrder=$O(tmp(nOrder)) q:nOrder=""  d
	.s PerArray=""
	.s NurData=tmp(nOrder)
	.d ##class(web.DHCNurRosterComm).setTmp(NurData,.PerArray)
	.s PersonID=PerArray("PersonID")
	.s PersonType=PerArray("PersonType")
	.f admweek=1:1:7 d
	..s WeekDesc=$P(WeeksDesc,"^",admweek)
	..s:ret="" ret=PersonID_"-"_WeekDesc_"|"
	..s:ret'="" ret=ret_"^"_PersonID_"-"_WeekDesc_"|"
	..s AJRowId=$O(^DHCMGNUR.MgNurArrangeJobModelI("AJNurWeekIndex"," "_modelid," "_WardId," "_$zcvt(PersonID,"U")," "_$zcvt(WeekDesc,"U"),"")) 
	..q:AJRowId=""
	..b ;00
	..s ajobj=##class(DHCMGNUR.MgNurArrangeJobModel).%OpenId(AJRowId)
	..s ajtypes=ajobj.AJType
	..s ajcodes=ajobj.AJCodeDR
	..s paret=""
	..f i=1:1:$L(ajcodes,",") d
	...s ajcode=$P(ajcodes,",",i)
	...s ajtype=$P(ajtypes,",",i)
	...i ajtype="Holiday" d
	....s hldyobj=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(ajcode)
	....s hldydesc=hldyobj.HolidayDesc
	....i hldydesc["教" d
	.....i paret'="H-J" s paret="H-J"
	....e  s paret="H"
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

Storage Default
{
<Data name="MgNurArrangeJobModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AJNurseDR</Value>
</Value>
<Value name="3">
<Value>AJType</Value>
</Value>
<Value name="4">
<Value>AJWardDR</Value>
</Value>
<Value name="5">
<Value>AJCodeDR</Value>
</Value>
<Value name="6">
<Value>AJDate</Value>
</Value>
<Value name="7">
<Value>AJModifyDate</Value>
</Value>
<Value name="8">
<Value>AJModifyTime</Value>
</Value>
<Value name="9">
<Value>AJNurseMaster</Value>
</Value>
<Value name="10">
<Value>AJRemarks</Value>
</Value>
<Value name="11">
<Value>AJTime</Value>
</Value>
<Value name="12">
<Value>AJEndTime</Value>
</Value>
<Value name="13">
<Value>AJModelDR</Value>
</Value>
<Value name="14">
<Value>AJStTime</Value>
</Value>
<Value name="15">
<Value>AJWeek</Value>
</Value>
<Value name="16">
<Value>AJHalfJob</Value>
</Value>
<Value name="17">
<Value>AJJobLong</Value>
</Value>
<Value name="18">
<Value>AJJobInterval</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurArrangeJobModelD</DataLocation>
<DefaultData>MgNurArrangeJobModelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurArrangeJobModelD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurArrangeJobModelI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurArrangeJobModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
