Import SQLUser

Class web.DHCBPPatSetUpBedGroup Extends %Persistent
{

/// 添加病人绑定床位组(自动分配到床位组内)
/// w ##class(web.DHCBPPatSetUpBedGroup).InsertPatSetUpBedGroup("1^1749^196^N^7:00")
ClassMethod InsertPatSetUpBedGroup(PatBedGroupInfoStr) As %String
{
	q:PatBedGroupInfoStr="" "无保存数据"
	s bedGroupId=$P(PatBedGroupInfoStr,"^",1) //床位
	s registerId=$P(PatBedGroupInfoStr,"^",2) //透析登记号
	s daySeqNo=$P(PatBedGroupInfoStr,"^",6)
    s bedId=$P(PatBedGroupInfoStr,"^",7)
	s bppId=..GetPatSetUpBedGroupID(registerId,daySeqNo)
	q:bppId'="" "此病人已绑定床位组"
	s retStr=..GetIdenticalWeekBindBed(registerId, bedGroupId, daySeqNo, bedId) //同一床位组内是否存在相同天、相同班次的绑定床位
	q:retStr'="" retStr	
    s PatBedGroupInfo=##class(User.DHCBPPatSetUpBedGroup).%New()    
    s PatBedGroupInfo.BPPBPCBedGroupDr=##class(User.DHCBPCBedGroup).%OpenId(bedGroupId)
    s PatBedGroupInfo.BPPBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
    s PatBedGroupInfo.BPPUserDr=$P(PatBedGroupInfoStr,"^",3)
    s PatBedGroupInfo.BPPStatus=$P(PatBedGroupInfoStr,"^",4)
    s PatBedGroupInfo.BPPDate=+$h
    s PatBedGroupInfo.BPPTime=$P($h,",",2)
    s PatBedGroupInfo.BPPReceptionTime=$P(PatBedGroupInfoStr,"^",5)
    s PatBedGroupInfo.BPPDaySeqNo=daySeqNo
    i bedId'="" d
    	.s PatBedGroupInfo.BPPBPCBedDr=##class(User.DHCBPCBed).%OpenId(bedId)
    s result=PatBedGroupInfo.%Save()
    d PatBedGroupInfo.%Close()
    i result=1 s result=0
    q result
}

/// w ##class(web.DHCBPPatSetUpBedGroup).DeletePatSetUpBedGroup()
ClassMethod DeletePatSetUpBedGroup(bppId) As %String
{
	q:bppId="" "ID不能为空!"	
	s result=0
	&SQL(delete from DHC_BP_PatSetUpBedGroup where BPP_RowId=:bppId)
	s result=SQLCODE
	q result
}

/// 获取病人关联床位组列表
/// bedGroupId床位组ID，curStatus绑定状态:N正常，D删除
/// d ##class(%ResultSet).RunQuery("web.DHCBPPatSetUpBedGroup","FindPatSetUpBedGroup","","1","N")
Query FindPatSetUpBedGroup(registerId As %String = "", bedGroupId As %String = "", curStatus As %String = "N") As %Query(ROWSPEC = "Id,BedGroupId,BedGroupDesc,RegisterId,RegNo,PatientName,Age,Gender,CtcpId,CtcpDesc,Date,Time,Status,ReceptionTime,DaySeqNo,BedId,BedDesc") [ SqlProc ]
{
}

ClassMethod FindPatSetUpBedGroupExecute(ByRef qHandle As %Binary, registerId As %String = "", bedGroupId As %String = "", curStatus As %String = "N") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	i (registerId="")&&(bedGroupId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s bppId=""
	if (registerId'="")
	{
		f  s bppId=$o(^DHCBPPatSetUpBedGroup(0,"PatRegister",registerId,bppId)) q:bppId=""  d
			.q:$$GetPatSetUpBedGroup()<0
			.d OutputRow
	}
	if (bedGroupId'="")
	{
		f  s bppId=$o(^DHCBPPatSetUpBedGroup(0,"BedGroup",bedGroupId,bppId)) q:bppId=""  d
			.q:$$GetPatSetUpBedGroup()<0
			.d OutputRow
	}	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetPatSetUpBedGroup()
	q:bppId="" -1
	s Id=bppId
	//w bppId,!
	//s bebGroupId=$lg(^DHCBPPatSetUpBedGroup(bppId),1)
	s BedGroupId=$lg(^DHCBPPatSetUpBedGroup(bppId),1)
	s BedGroupDesc=$lg(^DHCBPC("BedGroup",BedGroupId),2)
	s RegisterId=$lg(^DHCBPPatSetUpBedGroup(bppId),2)
	s papmiId=$lg(^DHCBPPatRegister(RegisterId),1)
	q:papmiId="" -2
	s RegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s PatientName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s Age=##class(web.DHCClinicCom).CalAge(patBirth,+$h)
	s Gender=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s CtcpId=$lg(^DHCBPPatSetUpBedGroup(bppId),3)
	s CtcpDesc=""
	i CtcpId'="" d
		.s CtcpDesc=##class(web.DHCBPCom).GetNameById(CtcpId)
	s Date=$lg(^DHCBPPatSetUpBedGroup(bppId),4)
	i Date'="" d
		.s Date=##class(web.DHCClinicCom).ConvertToDate(Date)
	s Time=$lg(^DHCBPPatSetUpBedGroup(bppId),5)
	i Time'="" d
		.s Time=##class(web.DHCClinicCom).ConvertToTime(Time)
	s Status=$lg(^DHCBPPatSetUpBedGroup(bppId),6)		
	q:(curStatus'="")&&(curStatus'=Status) -3
	i Status="N" s Status="正常"
	i Status="D" s Status="删除"
	s ReceptionTime=$lg(^DHCBPPatSetUpBedGroup(bppId),7)
	s DaySeqNo=$lg(^DHCBPPatSetUpBedGroup(bppId),8)
	i DaySeqNo="A" s DaySeqNo="上午"	
	i DaySeqNo="P" s DaySeqNo="下午"
	i DaySeqNo="E" s DaySeqNo="晚上"
	s BedId=$lg(^DHCBPPatSetUpBedGroup(bppId),9)
	s BedDesc=""
	i BedId'="" s BedDesc=$lg($g(^DHCBPC("Bed",BedId)),2)
	q 0    
OutputRow
	set Data=$lb(Id,BedGroupId,BedGroupDesc,RegisterId,RegNo,PatientName,Age,Gender,CtcpId,CtcpDesc,Date,Time,Status,ReceptionTime,DaySeqNo,BedId,BedDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPatSetUpBedGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatSetUpBedGroupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindPatSetUpBedGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatSetUpBedGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取班次的接诊时间段内有效当前周接诊时间，确定当前周循环到第几周，班次接诊时间段对应接诊时间
/// bpprId病人登记ID，bpaDate透析日期，DaySeqNo班次
/// 返回病人当前周对应的接诊时间
/// w ##class(web.DHCBPPatSetUpBedGroup).GetCalReceptionTime(1054,65623,"A")
ClassMethod GetCalReceptionTime(bpprId, bpaDate, daySeqNo) As %String
{
	q:bpprId="" ""
	q:daySeqNo="" ""
	s bppId=..GetPatSetUpBedGroupID(bpprId,daySeqNo)
	q:bppId="" ""
	s result=""	
	s cycle=0,originIndex=1
	s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
	s rtList=##Class(web.DHCBPCom).GetPatReceptionTime(bpprPatLocationDr)
	s rtAList=$p(rtList,"^",1)
	s rtPList=$p(rtList,"^",2)
	s rtEList=$p(rtList,"^",3)
	s rtAListCount=$l(rtAList,";")
	s rtPListCount=$l(rtPList,";")
	s rtEListCount=$l(rtEList,";")
	s receptionTime=$lg(^DHCBPPatSetUpBedGroup(bppId),7)	
	q:receptionTime="" ""
	i daySeqNo="A" d
		.s cycle=rtAListCount
		.f i=1:1:rtAListCount d  //制定接诊时间所属起始周索引
			..i $p(rtAList,";",i)=receptionTime s originIndex=i q
	e  i daySeqNo="P" d
		.s cycle=rtPListCount
		.f i=1:1:rtPListCount d //制定接诊时间所属起始周索引
			..i $p(rtPList,";",i)=receptionTime s originIndex=i q
	e  i daySeqNo="E" d
		.s cycle=rtEListCount
		.f i=1:1:rtEListCount d //制定接诊时间所属起始周索引
			..i $p(rtEList,";",i)=receptionTime s originIndex=i q
	//w receptionTime_"/"_lastATime_"/"_lastPTime_"/"_daySeqNo_"/"_rtAListCount,!
	i cycle=0 q result
	s effectDate=$lg(^DHCBPPatSetUpBedGroup(bppId),4)	
	s effectWeekDay=$zd(effectDate,10)
	i effectWeekDay=0 s effectWeekDay=7
	w effectDate_"/"_effectWeekDay,!
	s virtualEffectDate=effectDate-effectWeekDay+1
	w bpaDate_"/"_virtualEffectDate,!
	s virWeekSeqNo=(bpaDate-virtualEffectDate)\7+1  //距离今日周数(制定接诊时间当日距离今日，换算成周数)
	w virWeekSeqNo_"/"_originIndex,!
	s virWeekSeqNo=virWeekSeqNo+originIndex-1  //实际周总数(距离今日周数+制定接诊时间所属起始周索引-1)
	w virWeekSeqNo_"/"_cycle,!
	s curWeekCircle=virWeekSeqNo#cycle  //接诊时间集合对应的周索引
	w curWeekCircle_"/"_cycle,!
	i curWeekCircle=0 s curWeekCircle=cycle
	//w curWeekCircle,!
	i daySeqNo="A" s result=$p(rtAList,";",curWeekCircle)
	e  i daySeqNo="P" s result=$p(rtPList,";",curWeekCircle)
	e  i daySeqNo="E" s result=$p(rtEList,";",curWeekCircle)
    e  s result=""
	//w effectDate_"/"_receptionTime_"/"_effectWeekDay_"/"_virtualEffectDate_"/"_virWeekSeqNo_"/"_cycle,!
	q result
}

/// 获取病人绑定床位组记录ID
/// bpprId患者登记ID，daySeqNo班次
/// 存在记录返回ID，不存在记录返回为空，
/// w ##class(web.DHCBPPatSetUpBedGroup).GetPatSetUpBedGroupID("26","P")
ClassMethod GetPatSetUpBedGroupID(bpprId, daySeqNo) As %String
{
	q:bpprId="" ""
	s bppId="",result=""
	f  s bppId=$o(^DHCBPPatSetUpBedGroup(0,"PatRegister",bpprId,bppId)) q:bppId=""  d		
		.s Status=$lg(^DHCBPPatSetUpBedGroup(bppId),6)	
		.q:Status="D"
		.s DaySeqNo=$lg(^DHCBPPatSetUpBedGroup(bppId),8)
		.//w daySeqNo_"/"_DaySeqNo,!
		.q:(daySeqNo'="")&&(daySeqNo'=DaySeqNo)
		.s result=bppId
	q result
}

/// 获取同一床位组内，相同天、相同班次的绑定床位(关联床位组)
/// w ##class(web.DHCBPPatSetUpBedGroup).GetIdenticalWeekBindBed("93","8","A","71")
ClassMethod GetIdenticalWeekBindBed(registerId As %String, bedGroupId As %String = "", daySeqNo As %String = "", bedId As %String = "") As %String
{
	s retStr=""
    q:registerId="" ""
    q:bedId="" ""
    s papmiId=$lg(^DHCBPPatRegister(registerId),1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s res=##class(%Library.ResultSet).%New("web.DHCBPScheme:FindBPCurSchemeList")
	do res.Execute(registerId)
	while (res.Next())
    {
	    //s ^temmfc(registerId,1)="循环"_res.Data("Id")
	    s schemeId=res.Data("Id")
	    s cycle=1 //单双周索引(sql查询改变值)
	    &sql(select max(BPAS_WeekSeqNo) into :cycle from dhc_bp_arrangescheme where BPAS_BPScheme_Dr=:schemeId and (BPAS_IsTemporary='N' OR BPAS_IsTemporary is null) and (BPAS_IfActive='Y' OR BPAS_IfActive is null) and (BPAS_IfAbandon='N' OR  BPAS_IfAbandon is null)) 
	    s arrangeSchemeId=""
		f  s arrangeSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",schemeId,arrangeSchemeId)) q:(arrangeSchemeId="")  d
			.s asIfActive=$lg(^DHCBPArrangeScheme(arrangeSchemeId),9)
			.q:asIfActive'="Y"
			.s asIfAbandon=$lg(^DHCBPArrangeScheme(arrangeSchemeId),17)
			.q:asIfAbandon="Y"
			.s asIsTemporary=$lg(^DHCBPArrangeScheme(arrangeSchemeId),19)
    		.q:asIsTemporary="Y"
			.s asWeekSeqNo=$lg(^DHCBPArrangeScheme(arrangeSchemeId),6)
			.s asWeekDay=$lg(^DHCBPArrangeScheme(arrangeSchemeId),7)
			.s asDaySeq=$lg(^DHCBPArrangeScheme(arrangeSchemeId),8)
			.s asEffectDate=$lg(^DHCBPArrangeScheme(arrangeSchemeId),10)			
			.q:asEffectDate=""			
			.s asEffectWeekDay=$zd(asEffectDate,10)
			.s asVirtualEffectDate=asEffectDate-asEffectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
			.s asVirWeekSeqNo=(+$h-asVirtualEffectDate)\7+1
			.s asRemainder=asVirWeekSeqNo#cycle
			.i asRemainder=0 s asCirWeekSeq=cycle
			.e  s asCirWeekSeq=asRemainder
			.//s ^temmfc(registerId,2,"arrangeSchemeId",arrangeSchemeId)=asIfActive_"/"_asIfAbandon_"/"_asIsTemporary_"/"_asEffectDate_"/"_asCirWeekSeq_"/"_asWeekSeqNo_"/"_asWeekDay_"/"_asDaySeq
			.s bppId=""
	    	.f  s bppId=$o(^DHCBPPatSetUpBedGroup(0,"BedGroup",bedGroupId,bppId)) q:bppId=""  d
	    		..s bpprId=$lg(^DHCBPPatSetUpBedGroup(bppId),2)
				..q:registerId=bpprId
	    		..s Status=$lg(^DHCBPPatSetUpBedGroup(bppId),6)
	    		..q:Status'="N"
				..s DaySeqNo=$lg(^DHCBPPatSetUpBedGroup(bppId),8)
				..q:(daySeqNo'="")&&(DaySeqNo'=daySeqNo)				
				..s SetUpBedId=$lg(^DHCBPPatSetUpBedGroup(bppId),9)
				..q:(bedId'="")&&(SetUpBedId'=bedId)
				..//s ^temmfc(registerId,3,"bpprId",bpprId,"bppId",bppId)=Status_"/"_daySeqNo_"/"_bpprId
				..s sId=""
	   			..f  s sId=$o(^DHCBPScheme(0,"PatRegister",bpprId,sId)) q:sId=""  d
	   				...s endDate=$lg(^DHCBPScheme(sId),3)
	   				...q:endDate'="2980013"	   				
					...s arrSchemeId=""
					...f  s arrSchemeId=$o(^DHCBPArrangeScheme(0,"Scheme",sId,arrSchemeId)) q:(arrSchemeId="")  d
						....s ifActive=$lg(^DHCBPArrangeScheme(arrSchemeId),9)
						....q:ifActive'="Y"
						....s ifAbandon=$lg(^DHCBPArrangeScheme(arrSchemeId),17)
						....q:ifAbandon="Y"
						....s isTemporary=$lg(^DHCBPArrangeScheme(arrSchemeId),19)
    					....q:isTemporary="Y"
						....s effectDate=$lg(^DHCBPArrangeScheme(arrSchemeId),10)			
						....q:effectDate=""
						....s weekSeqNo=$lg(^DHCBPArrangeScheme(arrSchemeId),6)
						....s weekDay=$lg(^DHCBPArrangeScheme(arrSchemeId),7)
						....s daySeq=$lg(^DHCBPArrangeScheme(arrSchemeId),8)
						....s effectWeekDay=$zd(effectDate,10)
						
						....s virtualEffectDate=effectDate-effectWeekDay+1   //虚拟开始日期，当本周使用了安排计划，相当于下周一开始就算第二周，所以将起始生效时间虚拟为本周一
						....s virWeekSeqNo=(+$h-virtualEffectDate)\7+1
						....s remainder=virWeekSeqNo#cycle
						....i remainder=0 s cirWeekSeq=cycle
						....e  s cirWeekSeq=remainder
						....//s ^temmfc(registerId,4,"bpprId",bpprId,"arrSchemeId",arrSchemeId)=ifActive_"/"_ifAbandon_"/"_isTemporary_"/"_effectDate_"/"_cirWeekSeq_"/"_weekSeqNo_"/"_weekDay_"/"_daySeq
						....//q:asCirWeekSeq'=cirWeekSeq
						....q:(asCirWeekSeq'=cirWeekSeq)&&(asWeekSeqNo=weekSeqNo)
						....q:(asCirWeekSeq=cirWeekSeq)&&(asWeekSeqNo'=weekSeqNo)
						....q:(asWeekDay'=weekDay)&&(asDaySeq'=daySeq)
						....//s ^temmfc(registerId,4,"bpprId",bpprId,"arrSchemeId",arrSchemeId,"通过")=ifActive_"/"_ifAbandon_"/"_isTemporary_"/"_effectDate_"/"_cirWeekSeq_"/"_weekSeqNo_"/"_weekDay_"/"_daySeq
						....s papmiId2=$lg(^DHCBPPatRegister(bpprId),1)
						....s regNo2=$p($g(^PAPER(papmiId2,"PAT",1)),"^",1)
						....s patName2=$p($g(^PAPER(papmiId2,"ALL")),"^",1)
						....s daySeqDesc=""
						....i daySeq="A" s daySeqDesc="上午"	
						....i daySeq="P" s daySeqDesc="下午"
						....i daySeq="E" s daySeqDesc="晚上"
						....s retStr=patName_"的透析计划中星期"_weekDay_daySeqDesc_"的透析与"_patName2_"的存在冲突风险，关联床位组绑定床位失败！"
    }
    d res.Close()	
	q retStr
}

Storage Default
{
<Data name="DHCBPPatSetUpBedGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBPPatSetUpBedGroupD</DataLocation>
<DefaultData>DHCBPPatSetUpBedGroupDefaultData</DefaultData>
<IdLocation>^web.DHCBPPatSetUpBedGroupD</IdLocation>
<IndexLocation>^web.DHCBPPatSetUpBedGroupI</IndexLocation>
<StreamLocation>^web.DHCBPPatSetUpBedGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
