Class CIS.AN.BL.RealTimeMonitor Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2019-04-25
/// Description： 	获取实时监控索引界面汇总信息
/// Table：        	CIS.AN.OperSchedule
/// Input:			暂时先返回汇总数量，后可改为将列表一并返回
/// Return：       	json
/// w ##class(CIS.AN.BL.RealTimeMonitor).GetSummaryInfo()
ClassMethod GetSummaryInfo(date As %String = "") As %String
{
	if date="" set date=$zd(+$h,3)
	kill statusCountList,statusList
	set statusList(1,"ALL")="全部"
	set statusList(2,"Proceeding")="进行中"
	set statusList(3,"Unfinished")="未完成"
	set statusList(4,"Finished")="已完成"
	set statusList(5,"Stopped")="停手术"
	
	
	set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.RealTimeMonitor:FindOperSchedule")
	set sc=anaOperQuery.Execute(date,"ALL")
	while(anaOperQuery.%Next())
	{
		set currentStatus=anaOperQuery.Get("CurrentStatus")
		set statusCountList(currentStatus)=$g(statusCountList(currentStatus))+1
		set statusCountList("ALL")=$g(statusCountList("ALL"))+1
		b ;002
	}
	
	write "{"
	write """date"":""",date,""","
	write """types"":["
	
	set first=1
	set seq=""
	for
	{
		set seq=$o(statusList(seq))
		quit:seq=""
		
		set status=""
		for
		{
			set status=$O(statusList(seq,status))
			quit:status=""
		
			set statusDesc=statusList(seq,status)
			set count=+$g(statusCountList(status))
			
			if 'first write ","
			write "{"
			write """code"":""",status,""""
			write ",","""text"":""",statusDesc,""""
			write ",","""qty"":",count
			write "}"
			
			set first=0
		}
	}
	
	write "]"
	write "}"
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2019-04-25
/// Description： 	获取实时监控手术间总览界面汇总信息
/// Table：        	CIS.AN.OperSchedule
/// Input:			
/// Return：       	json
/// w ##class(CIS.AN.BL.RealTimeMonitor).GetRoomSummaryInfo()
ClassMethod GetRoomSummaryInfo(date As %String = "") As %String
{
	if date="" set date=$zd(+$h,3)
	kill roomList,roomCountList,currentOperList
	
	set roomQuery=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindOperRoom")
	set sc=roomQuery.Execute("","R")
	while(roomQuery.%Next())
	{
		set roomDesc=roomQuery.Get("Description")
		set room=roomQuery.Get("RowId")
		set floor=roomQuery.Get("OperFloor")
		set floorDesc=roomQuery.Get("OperFloorDesc")
		set operDept=roomQuery.Get("OperDeptID")
		set operDeptDesc=roomQuery.Get("OperDeptDesc")
		;b ;0000098
		set roomList(operDept)=operDeptDesc
		set roomList(operDept,room)=$lb(roomDesc,floor,floorDesc)
	}
	
	set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.RealTimeMonitor:FindOperSchedule")
	set sc=anaOperQuery.Execute(date,"ALL")
	while(anaOperQuery.%Next())
	{
		set room=+anaOperQuery.Get("OperRoom")
		set roomDesc=anaOperQuery.Get("RoomDesc")
		b ;000009
		set currentStatus=anaOperQuery.Get("CurrentStatus")
		set floor=anaOperQuery.Get("FloorDesc")
		continue:(currentStatus="Stopped")||(currentStatus="")
		continue:room=""
		
		set roomCountList(room,currentStatus)=$g(roomCountList(room,currentStatus))+1
		set roomCountList(room,"ALL")=$g(roomCountList(room,"ALL"))+1
		
		if currentStatus="Proceeding"
		{
			set currentOperList(room,"Patient")=anaOperQuery.Get("Patient")
			set currentOperList(room,"MedcareNo")=anaOperQuery.Get("MedcareNo")
			set currentOperList(room,"PatDept")=anaOperQuery.Get("PatDeptDesc")
			set currentOperList(room,"Diagnosis")=anaOperQuery.Get("PrevDiagnosisDesc")
			set currentOperList(room,"Operation")=anaOperQuery.Get("OperationDesc")
			set currentOperList(room,"AnaMethod")=anaOperQuery.Get("AnaestMethod")
			set currentOperList(room,"Surgeon")=anaOperQuery.Get("SurgeonDesc")
			set currentOperList(room,"AnaDoctor")=anaOperQuery.Get("AnesthesiologistDesc")
			set currentOperList(room,"ScrubNurse")=anaOperQuery.Get("ScrubNurseDesc")
			set currentOperList(room,"CircualNurse")=anaOperQuery.Get("CircualNurseDesc")
			set currentOperList(room,"IsEmerency")=$s((anaOperQuery.Get("SourceType")="E"):"Y",1:"N")
			set currentOperList(room,"IsLongDuration")=anaOperQuery.Get("LongOperation")
		}
	}
	
	write "{"
	write """OperDepts"":"   ///按手术科室返回手术间
	write "["
	
	set firstDept=1
	set dept=""
	for
	{
		set dept=$o(roomList(dept))
		quit:dept=""
		
		set deptDesc=roomList(dept)
		
		if 'firstDept write ","
		write "{","""RowId"":""",dept,""""
		write ",","""Description"":""",deptDesc,""""
		write ",","""Rooms"":["
		
		set availableRoomCount=0,roomCount=0,occupiedRoomCount=0
		set firstRoom=1
		set room=0
		for
		{
			set room=$O(roomList(dept,room))
			quit:room=""
		
			set roomDesc=$lg(roomList(dept,room),1)
			set floor=$lg(roomList(dept,room),2)
			set floorDesc=$lg(roomList(dept,room),3)
			
			set roomCount=roomCount+1
			if $g(roomCountList(room,"Proceeding"))>0 set occupiedRoomCount=occupiedRoomCount+1

			set vitalSign=..GetRoomVitalSignInfo(dept,room,date)
			
			if 'firstRoom write ","
			write "{"
			
			write """RowId"":",room
			write ",","""Description"":""",roomDesc,""""
			write ",","""Floor"":""",floor,""""
			write ",","""FloorDesc"":""",floorDesc,""""

			write ",","""VitalSign"":"
			write vitalSign
			
			write ",","""OperCount"":"
			write "{"
			write """All"":",+$g(roomCountList(room,"ALL"))
			write ",","""Proceeding"":",+$g(roomCountList(room,"Proceeding"))
			write ",","""Finished"":",+$g(roomCountList(room,"Finished"))
			write "}"
			
			write ",","""CurrentOper"":"
			
			if $d(currentOperList(room))  ///加载当前手术
			{	
				write "{"
				
				set field="",firstField=1
				for
				{
					set field=$o(currentOperList(room,field))
					quit:field=""
					
					if 'firstField write ","
					write """",field,""":""",currentOperList(room,field),""""
					set firstField=0
				}
				
				write "}"
			}
			else 
			{
				write "null"
			}
			
			write "}"
			set firstRoom=0
		}
		
		write "]"
	
		set availableRoomCount=roomCount-occupiedRoomCount
		write ",","""Summary"":"
		write "{"
		write """Total"":",roomCount
		write ",","""Occupied"":",occupiedRoomCount
		write ",","""Available"":",availableRoomCount
		write "}"
		
		write "}"
		set firstDept=0
	}
	
	write "]"
	write "}"
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2019-04-26
/// Description： 	获取手术列表
/// Table：        	CIS.AN.OperSchedule
/// Input:			date:日期，type: "ALL"-所有，"Proceeding"-进行中，"Unfinished"-未完成，"Finished"-已完成，"Stopped"-停手术
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.RealTimeMonitor","FindOperSchedule","2019-01-01","2019-01-31", "29")
Query FindOperSchedule(date As %String, type As %String = "ALL") As %Query(ROWSPEC = "CurrentStatus,RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PrevDiagnosisDesc,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,ECGDoctor,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,PostDiagnosisDesc,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,TheatreInTime,AnestStartTime,OperStartTime,OperEndTime,AnestEndTime,TheatreOutTime,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,OPFeeFlag,OPFeeFlagDesc,ANFeeFlag,ANFeeFlagDesc,OperRiskAssessment,OperSafetyCheck,OperCount,AnaestConsent,PrevANVisit,PostANVisit,AnaestRecord,PACURecord,AnaestConclusion,MainPACURecordID,PACUDoctor,PACUDoctorDesc,PACUShiftDoctor,PACUShiftDoctorDesc,WardReceiveCareProv,CarriedTube,Complication,PostOperNote,PACUInSteward,PACUInStewardScore,PACUOutSteward,PACUOutStewardScore,AnaDept,AnaDeptDesc,PACUInTime,PACUOutTime,OperExecDeptID,OperExecDeptDesc,ArrOperTime,PACUInStewardConscious,PACUInStewardRespiration,PACUInStewardMotion,PACUOutStewardConscious,PACUOutStewardRespiration,PACUOutStewardMotion,LaborStartDT,LaborEndDT,LaborEndTransLoc,LaborEndTransLocDesc,StatCategory,StatCategoryDesc,StatSeq,SiteDepth,Endoscopy,ArrAnaNurse,ArrAnaNurseDesc,AnaNurse,AnaNurseDesc,AdmType,DrugAllergy,DrugAllergyNote,AppDocPhoneNo,Operation,EstimatedOperTime") [ SqlProc ]
{
}

ClassMethod FindOperScheduleExecute(ByRef qHandle As %Binary, date As %String, type As %String = "ALL") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set date=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date,"")
	
	set indexNode="OPDate"
	set opsId=0
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
		;b ;00
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		;b ;01
		set currentStatus=""
		set operStatus=operSchedule.Status.Code
		if operStatus="RoomIn" set currentStatus="Proceeding"
		else  if operStatus="RoomOut"  set currentStatus="Finished"
		else  if operStatus="Stop"  set currentStatus="Stopped"
		else  set currentStatus="Unfinished"
		
		continue:(type'="ALL")&&(type'="")&&(currentStatus'=type)
		
		do OutputRow
		
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	set ^CacheTemp(repid,ind)=$lb(currentStatus)_##class(CIS.AN.BL.OperScheduleList).GetOperSchedule(opsId)
	set ind=ind+1
	q
}

ClassMethod FindOperScheduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperScheduleExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOperScheduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperScheduleExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-04-26
/// Description： 	获取手术列表（实时进度显示）通过时间筛选，只返回完成和进行中的手术
/// Table：        	CIS.AN.OperSchedule
/// Input:			startTime:开始日期时间，endTime:结束日期时间
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.RealTimeMonitor","FindProcessOper","2019-05-29 8:00:00","2019-05-30 8:00:00")
Query FindProcessOper(startDateTime As %String, endDateTime As %String) As %Query(ROWSPEC = "CurrentStatus,RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PrevDiagnosisDesc,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,ECGDoctor,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,PostDiagnosisDesc,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,TheatreInTime,AnestStartTime,OperStartTime,OperEndTime,AnestEndTime,TheatreOutTime,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,OPFeeFlag,OPFeeFlagDesc,ANFeeFlag,ANFeeFlagDesc,OperRiskAssessment,OperSafetyCheck,OperCount,AnaestConsent,PrevANVisit,PostANVisit,AnaestRecord,PACURecord,AnaestConclusion,MainPACURecordID,PACUDoctor,PACUDoctorDesc,PACUShiftDoctor,PACUShiftDoctorDesc,WardReceiveCareProv,CarriedTube,Complication,PostOperNote,PACUInSteward,PACUInStewardScore,PACUOutSteward,PACUOutStewardScore,AnaDept,AnaDeptDesc,PACUInTime,PACUOutTime,OperExecDeptID,OperExecDeptDesc,ArrOperTime,PACUInStewardConscious,PACUInStewardRespiration,PACUInStewardMotion,PACUOutStewardConscious,PACUOutStewardRespiration,PACUOutStewardMotion,LaborStartDT,LaborEndDT,LaborEndTransLoc,LaborEndTransLocDesc,StatCategory,StatCategoryDesc,StatSeq,SiteDepth,Endoscopy,ArrAnaNurse,ArrAnaNurseDesc,AnaNurse,AnaNurseDesc,AdmType,DrugAllergy,DrugAllergyNote,AppDocPhoneNo,Operation,EstimatedOperTime") [ SqlProc ]
{
}

ClassMethod FindProcessOperExecute(ByRef qHandle As %Binary, startDateTime As %String, endDateTime As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDate=$e(startDateTime,1,10)
	set startTime=$e(startDateTime,11,18)
	set endDate=$e(endDateTime,1,10)
	set endTime=$e(endDateTime,11,18)
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	
	set indexNode="OPDate"
	
	for date=startDateH:1:startDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
			set theatreInDT=AnaesthesiaObj.TheatreInDT
			set theatreOutDT=AnaesthesiaObj.TheatreOutDT
			set areaInDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","TheatreInTime")
			set areaOutDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","TheatreOutTime")
			
			set:areaInDT="" areaInDT=theatreInDT
			set:areaOutDT="" areaOutDT=theatreOutDT
			set beforeStart=0,afterEnd=0
			set:areaOutDT'="" beforeStart=##class(CIS.AN.COM.DateTime).CompareDateTimeS(startDateTime,areaOutDT)
			set:areaInDT'="" afterEnd=##class(CIS.AN.COM.DateTime).CompareDateTimeS(areaInDT,endDateTime)
			continue:(beforeStart>0)||(afterEnd>0)  //不在时间区域内的手术不返回
		
			set currentStatus=""
			set operStatus=operSchedule.Status.Code
			if operStatus="RoomIn" set currentStatus="Proceeding"
			else  if operStatus="RoomOut"  set currentStatus="Finished"
			else  if operStatus="Stop"  set currentStatus="Stopped"
			else  set currentStatus="Unfinished"
		
			continue:(currentStatus'="Proceeding")&&(currentStatus'="Finished")
		
			do OutputRow
		}
		
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	set ^CacheTemp(repid,ind)=$lb(currentStatus)_##class(CIS.AN.BL.OperScheduleList).GetOperSchedule(opsId)
	set ind=ind+1
	q
}

ClassMethod FindProcessOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProcessOperExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindProcessOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindProcessOperExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-04-26
/// Description： 	获取手术进度
/// Table：        	CIS.AN.OperSchedule
/// Input:			
/// Return：       	json
/// d ##class(CIS.AN.BL.RealTimeMonitor).GetProcesses("2019-01-01")
ClassMethod GetProcesses(date As %String = "") As %String
{
}

ClassMethod GetRoomVitalSignInfo(operDeptID As %String, operRoomId As %String, operDate As %String) As %String
{
	//b //ccq2
	Set operDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate)
	Set now=$p($h,",",2),today=+$h
	Set opsId = "",vitalSign=##class(%DynamicObject).%New()
	For {
		Set opsId = $ORDER(^CIS.AN.OperScheduleI("OperDeptDate"," "_operDeptID,operDateH,opsId))
		Quit:opsId=""
		//b //ccq
		// process ^CIS.AN.OperScheduleI(operDeptID,operDate,opsId)
		Set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		continue:(operSchedule.Status.Code'="RoomIn")											// 只获取术中状态手术的生命体征
		continue:(operSchedule.OperRoom="")																// 未安排手术间
		continue:(operSchedule.OperRoom.%Id()'=operRoomId)								// 手术间与参数不一致

		Set recordSheetId=""
		&sql(select RowId into :recordSheetId from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule->Code='AnaestRecord')
		continue:('##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId))			// 还未创建麻醉记录单
		Set currentEquipID=..GetCurrentEquipID(recordSheetId)
		continue:('##class(CF.AN.DeptEquip).%ExistsId(currentEquipID))				// 当前采集设备ID不存在时，也跳过。	

		// 获取生命体征值
		&sql(declare VitalSignDataCursor cursor for select
				ChannelNo,DataValue into :ChannelNo,:DataValue
				from CIS_AN.CollectedData
				where :currentEquipID [ STRING('^',Equip,'^')
				and CollectDate=:today
				and ABS(CollectTime-:now)<=60)				// 取当前时间前后一分钟的数据
		&sql(open VitalSignDataCursor)
		for
		{
			&sql(fetch VitalSignDataCursor)
			quit:(SQLCODE'=0)
			do vitalSign.%Set(ChannelNo,DataValue)
		}
		&sql(close VitalSignDataCursor)
	}

	quit vitalSign.%ToJSON()
}

ClassMethod GetVitalSignInfo(date As %String = "") As %String
{
	Set operDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(date)
	Set now=$p($h,",",2),today=+$h
	Set operDeptID = "",retObj=##class(%DynamicObject).%New()
	Set retObj.OperDepts=##class(%DynamicArray).%New()
	For {
		Set operDeptID = $ORDER(^CIS.AN.OperScheduleI(operDeptID))
		Quit:operDeptID=""
		// process array(operDeptID)
		Set operDept=##class(%DynamicObject).%New()
		set operDept.RowId=operDeptID
		Set operDept.Description=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operDeptID)
		Set roomCount=0
		&sql(select count(*) into :roomCount from CF_AN.Location where OperDeptID=:operDeptID and LocType='R' and Active='Y')
		Set operDept.Summary=##class(%DynamicObject).%New()
		Set operDept.Summary.RoomCount=roomCount
		set operDept.Rooms=##class(%DynamicArray).%New()
		
		Set opsId = "",occupiedCount=0
		For {
			Set opsId = $ORDER(^CIS.AN.OperScheduleI(operDeptID,operDateH,opsId))
			Quit:opsId=""
			Set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:(operSchedule.Status.Code'="RoomIn")			// 只显示术中状态的手术的生命体征。
			continue:(operSchedule.OperRoom="")								// 只显示分配了手术间的手术的生命体征。
			Set recordSheetId=""
			&sql(select RowId into :recordSheetId from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule->Code='AnaestRecord')
			continue:('##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId))			// 还未创建麻醉记录单
			Set currentEquipID=..GetCurrentEquipID(recordSheetId)
			continue:('##class(CF.AN.DeptEquip).%ExistsId(currentEquipID))				// 当前采集设备ID不存在时，也跳过。	
			Set operRoom=##class(%DynamicObject).%New()
			Set operRoom.RowId=operSchedule.OperRoom.%Id()
			set operRoom.Code=operSchedule.OperRoom.Code
			set operRoom.Description=operSchedule.OperRoom.Description
			set operRoom.VitalSign=##class(%DynamicObject).%New()
			
			Set occupiedCount=occupiedCount+1

			// 获取生命体征值
			&sql(declare CollectedDataCursor cursor for select
					ChannelNo,DataValue into :ChannelNo,:DataValue
					from CIS_AN.CollectedData
					where Equip=:currentEquipID
					and CollectDate=:today
					and ABS(CollectTime-:now)<=60)				// 取当前时间前后一分钟的数据
			&sql(open CollectedDataCursor)
			for
			{
				&sql(fetch CollectedDataCursor)
				quit:(SQLCODE'=0)
				do operRoom.VitalSign.%Set(ChannelNo,DataValue)
				set operRoom.VitalSign.InRange=..InThresholdRange(ChannelNo,DataValue)
			}
			
			&sql(close CollectedDataCursor)
			do operDept.Rooms.%Push(operRoom)
		}

		Set operDept.Summary.Occupied=occupiedCount
		Set operDept.Summary.Available=roomCount-occupiedCount
		do retObj.OperDepts.%Push(operDept)
	}

	quit retObj.%ToJSON()
}

ClassMethod GetCurrentEquipID(recordSheetId As %String) As %String
{
	set now=+$h+(+$p($h,",",2)/100000),currentEquipID=""
	&sql(declare EquipCursor cursor for select 
			Equip,StartDate,StartTime,EndDate,EndTime 
			into :EquipID,:StartDate,:StartTime,:EndDate,:EndTime
			from CIS_AN.EquipRecord 
			where RecordSheet=:recordSheetId)
	&sql(open EquipCursor)
	for
	{
		&sql(fetch EquipCursor)
		quit:(SQLCODE'=0)
		Set startDT=+StartDate+(+StartTime/100000)
		Set endDT=+EndDate+(+EndTime/100000)
		continue:(startDT>now)
		continue:(endDT<now)&(endDT>0)
		Set:(currentEquipID'="") currentEquipID=currentEquipID_"^"
		Set currentEquipID=currentEquipID_EquipID
	}
	&sql(close EquipCursor)
	quit "^"_currentEquipID_"^"
}

ClassMethod InThresholdRange(channelNo As %String, dataValue As %String) As %Boolean
{
	set dataValue=+dataValue
	set warningMax=1000000,warningMin=-1000000,maxValue="",minValue=""
	&sql(select WarningMax,WarningMin,MaxValue,MinValue into :warningMax,:warningMin,:maxValue,:minValue from CT_AN.VitalSign where ChannelNo=:channelNo)
	quit:(dataValue>warningMax) 0
	quit:(dataValue<warningMin) 0
	quit 1
}

// 获取麻醉的手术时间

/// w ##class(CIS.AN.BL.RealTimeMonitor).GetAnaRecordTime(86)
ClassMethod GetAnaRecordTime(opsId As %String) As %String
{
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set rowDataArr=##class(%DynamicArray).%New()
	
	
	set rowData=##class(%DynamicObject).%New()
	set rowData.title="入室"
	set TheatreInDT=anaestObj.GetValue("TheatreInDT")
	set TheatreInDT=..modifyDateTime(TheatreInDT)
	set rowData.context=TheatreInDT
	do rowDataArr.%Push(rowData)
	
	set rowData=##class(%DynamicObject).%New()
	set rowData.title="麻醉开始"
	set AnaStartDT=anaestObj.GetValue("AnaStartDT")
	set AnaStartDT=..modifyDateTime(AnaStartDT)
	set rowData.context=AnaStartDT
	do rowDataArr.%Push(rowData)
	
	set rowData=##class(%DynamicObject).%New()
	set rowData.title="手术开始"
	set OperStartDT=anaestObj.GetValue("OperStartDT")
	set OperStartDT=..modifyDateTime(OperStartDT)
	set rowData.context=OperStartDT
	do rowDataArr.%Push(rowData)
	
	set rowData=##class(%DynamicObject).%New()
	set rowData.title="手术结束"
	set OperFinishDT=anaestObj.GetValue("OperFinishDT")
	set OperFinishDT=..modifyDateTime(OperFinishDT)
	set rowData.context=OperFinishDT
	do rowDataArr.%Push(rowData)
	
	set rowData=##class(%DynamicObject).%New()
	set rowData.title="离室"
	set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")
	set TheatreOutDT=..modifyDateTime(TheatreOutDT)
	set rowData.context=TheatreOutDT
	do rowDataArr.%Push(rowData)
	
	quit rowDataArr.%ToJSON()
}

ClassMethod modifyDateTime(datetime As %String)
{
	quit:datetime="" ""
	set dateStr=$p(datetime," ",1)
	set timeStr=$p(datetime," ",2)
	set dateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(dateStr)
	set timeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(timeStr)
	set mdatetime=##class(web.DHCClinicCom).ConvertToDateTime(dateH,timeH)
	quit mdatetime
}

}
