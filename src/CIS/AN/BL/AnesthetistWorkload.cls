/// 麻醉医生工作量
Class CIS.AN.BL.AnesthetistWorkload Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-11-25
/// Description： 	查询麻醉医生所参与的手术
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnesthetistWorkload","FindOperScheduleList","2018-12-04","2018-12-04","")
Query FindOperScheduleList(startDate As %String, endDate As %String, andocID As %String, appDeptID As %String = "", operName As %String = "", eventName As %String = "") As %Query(ROWSPEC = "RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc") [ SqlProc ]
{
}

ClassMethod FindOperScheduleListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocID As %String, appDeptID As %String = "", operName As %String = "", eventName As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set operName=$ZCVT(operName,"U")
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anesthesiologist=""
			set anesthesiologist=anaesthesia.Anesthesiologist
			
			continue:anesthesiologist=""
			continue:(andocID'="")&&(andocID'="All")&&(anesthesiologist'=andocID) //麻醉医生匹配
						
			continue:anaesthesia.OperFinishDT=""  //无手术结束时间不计算
			
			set appDept=""
			set appDept=operSchedule.AppDeptID
			continue:(appDeptID'="")&&(appDept'=appDeptID) //申请科室匹配
			
			set operationName=""
			set operListRowId=$o(^CIS.AN.OperListI("IOPS",opsId,""),-1)
			if operListRowId>0 
			{
				set operList=##class(CIS.AN.OperList).%OpenId(operListRowId)
				if operList.Operation'="" set operationName=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERDesc",operList.Operation)
				else  set operationName=operList.OperNote
				set operationName=$ZCVT(operationName,"U")
			}
			continue:(operName'="")&&((operListRowId="")||(operationName'[operName)) //手术名称匹配
			
			if eventName'=""
			{
				set hasEvent=..HasEvent(opsId,eventName)
				continue:(hasEvent="N")  //数据中没有对应的事件
			}
			do OutputRow
		}	
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=##class(CIS.AN.BL.AnaesthesiaStatistic).GetOperSchedule(opsId)
	s ind=ind+1
	q
}

ClassMethod FindOperScheduleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperScheduleListExecute ]
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

ClassMethod FindOperScheduleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperScheduleListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 
/// Creator：      	雍阳
/// CreatDate：    	2018-01-03
/// Description： 	监护数据中是否包含某事件名
/// Table：        	DHCAN.Model.AnaData
/// Input:			opsId:手术计划ID，eventName:事件名称
/// Return：       	ResultSet
/// d ##class(DHCAN.BLL.AnesthetistWorkload).HasEvent(1,"进胸")
ClassMethod HasEvent(opsId, eventName) As %String
{
	set result="N"
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set paraItemId=..GetParaItemId(recordSheetId,"OperationEvent")
	
	set rset=##class(%ResultSet).%New("CIS.AN.BL.AnesthetistWorkload:FindEventData")
	set sc=rset.Execute(paraItemId)
	while(rset.%Next())
	{
		set dataItemDesc=rset.Get("DataItemDesc")
		if dataItemDesc[eventName
		{
			set result="Y"
			quit
		}
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2020-04-09
/// Description： 	获取镇痛数据
/// Table：        	CIS.AN.AnaData
/// Input:			
/// Return：       	ResultSet
ClassMethod GetAnalgesiaData(opsId, ByRef dataList) As %String
{
	set result="N"
	set moduleCode = "AnaestRecord",analgesiaCode="PCA"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set paraItemId=..GetParaItemId(recordSheetId,"OperationEvent")
	
	set rset=##class(%ResultSet).%New("CIS.AN.BL.AnesthetistWorkload:FindEventData")
	set sc=rset.Execute(paraItemId)
	while(rset.%Next())
	{
		set rowId=rset.Get("RowId")
		set dataItemCode=rset.Get("DataItemCode")
		if dataItemCode=analgesiaCode
		{
			set result="Y"
			set dataList(rowId)=""
		}
	}
	
	quit result
}

/// 根据事件代码获取事件具体数据项目
ClassMethod GetEventData(opsId, eventCode, ByRef dataList) As %String
{
	set result="N"
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set paraItemId=..GetParaItemId(recordSheetId,"OperationEvent")
	
	set rset=##class(%ResultSet).%New("CIS.AN.BL.AnesthetistWorkload:FindEventData")
	set sc=rset.Execute(paraItemId)
	while(rset.%Next())
	{
		set rowId=rset.Get("RowId")
		set dataItemCode=rset.Get("DataItemCode")
		if dataItemCode=eventCode
		{
			set result="Y"
			set dataList(rowId)=""
		}
	}
	
	quit result
}

/// Creator：      	李杰
/// CreatDate：    	2022年2月18日
/// Description： 	判断事件中是否有对应的项目明细
/// Table：        	CIS.AN.AnaData
/// Input:			
/// Return：       	"Y"-有， "N"-无
/// w ##class(CIS.AN.BL.AnesthetistWorkload).IfEventDataHasDetail(807,"PCA","配方")
ClassMethod IfEventDataHasDetail(opsId, eventCode, targetLabel, targetValue = "") As %String
{
	set result="N"
	set ret=##class(CIS.AN.BL.AnesthetistWorkload).GetEventData(opsId, eventCode, .analgesiaDataList)
	quit:ret="N" "N"
	
	set anaDataId=0,eventDetailItemId="",DataValueList="",description="",unit=""
	for
	{	
		set anaDataId=$order(analgesiaDataList(anaDataId))
		quit:anaDataId=""
		
		set eventDataId=""
		for
		{
			set eventDataId=$o(^CIS.AN.EventDataI("IAnaData",anaDataId,eventDataId))
			quit:eventDataId=""
			
			set eventData=##class(CIS.AN.EventData).%OpenId(eventDataId)
			set description=eventData.EventDetailItem.Description
			set unit=eventData.EventDetailItem.Unit
			set dataValue=eventData.DataValue
			;w description,",",dataValue,!
			if ((targetLabel=description)&&(targetValue="")&&(dataValue'=""))
			{
				set result="Y"
			}
			if ((targetLabel=description)&&(targetValue=dataValue))
			{
				set result="Y"
			}
		}				
	}
	
	quit result
}

/// Creator：      	李杰
/// CreatDate：    	2022年2月18日
/// Description： 	判断事件出现次数
/// Table：        	CIS.AN.AnaData
/// Input:			
/// Return：       	事件次数
/// w ##class(CIS.AN.BL.AnesthetistWorkload).GetEventDataCount(776,"NerveBlockBUltrasound")
ClassMethod GetEventDataCount(opsId, eventCode) As %String
{
	set count=0
	set ret=##class(CIS.AN.BL.AnesthetistWorkload).GetEventData(opsId, eventCode, .analgesiaDataList)
	quit:ret="N" 0
	
	set anaDataId=0,eventDetailItemId="",DataValueList="",description="",unit=""
	for
	{	
		set anaDataId=$order(analgesiaDataList(anaDataId))
		quit:anaDataId=""
		set count=count+1			
	}
	
	quit count
}

ClassMethod GetParaItemId(recordSheetId, code) As %String
{
	set paraItemId=""
	&sql(SELECT RowId into :paraItemId FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	if SQLCODE quit ""
	quit paraItemId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-01-03
/// Description： 	查询事件数据
/// Table：        	DHCAN.Model.AnaData
/// Input:			recordSheetId:表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.BLL.AnesthetistWorkload","FindEventData","1")
Query FindEventData(eventParaItemId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	DataItem->Code As DataItemCode,
	DataItem->Description As DataItemDesc,
	DataItem->ItemCategory As ItemCategory
	from CIS_AN.AnaData 
	where ParaItem=:eventParaItemId
	and EditFlag="N"
	and DataItem->ItemCategory="E"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-25
/// Description： 	查询单个麻醉医生所参与的手术的数量和时间汇总
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocId:麻醉医生ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.AnesthetistWorkload).GetPersonalStat("2018-11-01","2018-11-30","29")
ClassMethod GetPersonalStat(startDate, endDate, andocId) As %String
{
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		write ""
	}
	
	set indexNode="OPDate"
	
	write "{"
	write """rows"":["
	kill operScheduleList,columnList
	set totalOperCounter=0,totalTimeSpan=0,isFirstRow=1
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set anesthesiologist=operSchedule.Anesthesiologist
			continue:anesthesiologist=""
			continue:(andocID'="")&&(anesthesiologist'=andocID)
			
			set theatreInDT=operSchedule.TheatreInDT
			set tubeOutDT=operSchedule.TubeOutDT
			continue:(theatreInDT="")||(tubeOutDT="")
			
			set duration=$zt(+$p(theatreInDT,",",2),2)_"-"_$zt(+$p(tubeOutDT,",",2),2)
			set timespan=##class(CIS.AN.COM.DateTime).CalculateDuration(+theatreInDT,+$p(theatreInDT,",",2),+tubeOutDT,+$p(tubeOutDT,",",2),"S")
			set timespan=$fn(timespan/3600,"",2)
			set totalOperCounter=totalOperCounter+1
			set totalTimeSpan=totalTimeSpan+timespan
			
			set operScheduleList(date,+theatreInDT,+$p(theatreInDT,",",2))=$lb(opsId,duration,timespan)
		}
		
		if 'isFirstRow write ","
		write "{""Date"":""",$zd(date,3),""","
		set theatreInDate="",counter=0,dailyTimeSpan=0
		for
		{
			set theatreInDate=$o(operScheduleList(date,theatreInDate))
			quit:theatreInDate=""
			
			set time=""
			for
			{
				set time=$o(operScheduleList(date,theatreInDate,time))
				quit:time=""
				
				set duration=$lg(operScheduleList(date,theatreInDate,time),2)
				set timespan=$lg(operScheduleList(date,theatreInDate,time),3)
				set dailyTimeSpan=dailyTimeSpan+timespan
				set counter=counter+1
				write """OperSeq_",counter,""":"_duration
				set columnList(counter)=""
			}
		}	
		
		write """DailyTimeSpan"":""",dailyTimeSpan,"h"""
		write "}"
		set isFirstRow=0
	}
	
	write "]"
	write ",""columns"":[["
	write "{"
	write """field"":""Date"""
	write ",""title"":""日期"""
	write "}"
	set columnIndex=""
	for
	{
		set columnIndex=$o(columnList(columnIndex))
		quit:columnIndex=""
		
		write ","
		write "{"
		write """field"":""OperSeq_",columnIndex,""""
		write ",""title"":""第",columnIndex,"台"""
		write ",""width"":60"
		write "}"
	}
	
	write ",{"
	write """field"":""DailyTimeSpan"""
	write ",""title"":""工作时长"""
	write "}"
	write "]]"
	
	write ",""Total"":{""Count"":",totalOperCounter,"""Timespan"":",totalTimeSpan,"}"
	write "}"
	
	quit
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-06
/// Description： 	分日期统计ASA分级的手术
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnesthetistWorkload","FindASAStat","2018-11-01","2018-11-30")
Query FindASAStat(startDate As %String, endDate As %String) As %Query(ROWSPEC = "Date,ASAI,ASAIPersentage,ASAII,ASAIIPersentage,ASAIII,ASAIIIPersentage,ASAIV,ASAIVPersentage,ASAV,ASAVPersentage,ASAVI,ASANone,Total") [ SqlProc ]
{
}

ClassMethod FindASAStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	
	kill statList

	for date=startDateH:1:endDateH
	{
		set statList("Date",date)=""
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="PACUIn")&&(statusCode'="Finish")
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			
			//continue:anaesthesia.OperFinishDT=""  //无手术结束时间不计算
			
			if anaesthesia.ASAClass'=""
			{
				set asaClassId=anaesthesia.ASAClass
				set asaClassDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCASAClassPhActiv","ORASADesc",asaClassId)
				set asaClassCode=$$GetASACode(asaClassDesc)
				set statList("Total",asaClassCode,"Qty")=$g(statList("Total",asaClassCode,"Qty"))+1
				set statList("Date",date,asaClassCode,"Qty")=$g(statList("Date",date,asaClassCode,"Qty"))+1
			}
			else
			{
				set asaClassId="-"
				set asaClassDesc="无"
				set asaClassCode="None"
				set statList("Total",asaClassCode,"Qty")=$g(statList("Total",asaClassCode,"Qty"))+1
				set statList("Date",date,asaClassCode,"Qty")=$g(statList("Date",date,asaClassCode,"Qty"))+1
			}
		}	
	}
	
	set DateStr="总计"
	set ASAI=+$g(statList("Total","ASAI","Qty"))
	set ASAII=+$g(statList("Total","ASAII","Qty"))
	set ASAIII=+$g(statList("Total","ASAIII","Qty"))
	set ASAIV=+$g(statList("Total","ASAIV","Qty"))
	set ASAV=+$g(statList("Total","ASAV","Qty"))
	set ASANone=+$g(statList("Total","None","Qty"))
	do OutputRow
	
	set date=""
	for
	{
		set date=$o(statList("Date",date),-1)
		quit:date=""
		
		set DateStr=$zd(date,3)
		set ASAI=+$g(statList("Date",date,"ASAI","Qty"))
		set ASAII=+$g(statList("Date",date,"ASAII","Qty"))
		set ASAIII=+$g(statList("Date",date,"ASAIII","Qty"))
		set ASAIV=+$g(statList("Date",date,"ASAIV","Qty"))
		set ASAV=+$g(statList("Date",date,"ASAV","Qty"))
		set ASANone=+$g(statList("Date",date,"None","Qty"))
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

GetASACode(desc)
	set code = $s(desc["Ⅰ":"ASAI",desc["Ⅱ":"ASAII",desc["Ⅲ":"ASAIII",desc["Ⅳ":"ASAIV",desc["Ⅴ":"ASAV",1:"None")
	quit code
	
OutputRow
	set Total=ASAI+ASAII+ASAIII+ASAIV+ASAV+ASANone
	set ASAIPersentage=$s(Total>0:$fn(ASAI*100/Total,"",2)_"%",1:"")
	set ASAIIPersentage=$s(Total>0:$fn(ASAII*100/Total,"",2)_"%",1:"")
	set ASAIIIPersentage=$s(Total>0:$fn(ASAIII*100/Total,"",2)_"%",1:"")
	set ASAIVPersentage=$s(Total>0:$fn(ASAIV*100/Total,"",2)_"%",1:"")
	set ASAVPersentage=$s(Total>0:$fn(ASAV*100/Total,"",2)_"%",1:"")
	set ^CacheTemp(repid,ind)=$lb(DateStr,ASAI,ASAIPersentage,ASAII,ASAIIPersentage,
								  ASAIII,ASAIIIPersentage,ASAIV,ASAIVPersentage,
								  ASAV,ASAVPersentage,ASAVI,ASANone,Total)
	set ind=ind+1
	q
}

ClassMethod FindASAStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindASAStatExecute ]
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

ClassMethod FindASAStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindASAStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-6
/// Description： 	同步手术开始时间
/// Table：        	CIS.AN.OperSchedule
/// Input:			
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.AnesthetistWorkload).SyncOperStartDT("9254")
ClassMethod SyncOperStartDT(opsId) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	quit:operSchedule.OperFinishDT="" "E^手术未完成"
	
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set operStartDT=$$GetOperStartDT(recordSheetId)
	write operStartDT,!
	
	set operSchedule.OperStartDT=operStartDT
	do operSchedule.%Save()
	
	quit "S^"
GetOperStartDT(recordSheetId)
    set rowId="",startDate="",startTime=""
    
	&sql(select StartDate,StartTime into :startDate,:startTime from CIS_AN.AnaData
		where ParaItem->RecordSheet=:recordSheetId
		and ParaItem->CategoryItem=30
		and EditFlag="N")
		
	quit:rowId>0 $zd(startDate,3)_" "_$zt(startTime)
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-06
/// Description： 	分日期统计麻醉医生工作量
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocId:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnesthetistWorkload","FindPersonWorkStat","2020-03-01","2020-03-31", "",614)
Query FindPersonWorkStat(startDate As %String, endDate As %String, andocCode As %String = "", andocId As %String = "") As %Query(ROWSPEC = "Month,Date,OperSeq1,OperSeq2,OperSeq3,OperSeq4,OperSeq5,TotalTime,TotalMinutes,OperCount") [ SqlProc ]
{
}

ClassMethod FindPersonWorkStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocCode As %String = "", andocId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set andocCode=$ZCVT(andocCode,"U")
	if (andocCode'="") && (andocId="") set andocId=$o(^CTPCP(0,"Code",andocCode,""))
	
	set indexNode="OPDate"
	
	kill statList
	for date=startDateH:1:endDateH
	{
		set month=$e($zd(date,3),0,7)
		set statList("Date",month,date)=""
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="PACUIn")&&(statusCode'="Finish")
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anesthesiologist=""
			set anesthesiologist=anaesthesia.Anesthesiologist
			//set anesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anesthesiologist)
		
			continue:anesthesiologist=""
			continue:(andocId'="")&&(anesthesiologist'=andocId)
			
			set theatreInDT=anaesthesia.TheatreInDT
			set tubeOutDT=anaesthesia.TubeOutDT
			continue:(theatreInDT="")||(tubeOutDT="")
			
			set largestTime=..GetLargestDataTime(date,opsId)
			set theatreOutDT=anaesthesia.TheatreOutDT
			set:theatreOutDT="" theatreOutDT=largestTime
			set duration=$e($p(theatreInDT," ",2),0,5)_"—"_$e($p(theatreOutDT," ",2),0,5)
			set timespan=##class(CIS.AN.COM.DateTime).CalculateDurationS(theatreInDT,theatreOutDT,"S")
			set timespan=$fn(timespan/60,"",2)
			
			set statList("Date",month,date,theatreInDT)=$lb(opsId,duration,timespan)
			set statList("Month",month,"Count")=+$g(statList("Month",month,"Count"))+1
			set statList("Month",month,"TotalTime")=+$g(statList("Month",month,"TotalTime"))+timespan
		}
	}
	break //
	set month=""
	for
	{
		set month=$o(statList("Date",month))
		quit:month=""
		
		set date=""
		for
		{
			set date=$o(statList("Date",month,date))
			quit:date=""
			
			kill row
			set row("Month")=month
			set row("Date")=$e($zd(date,3),9,11)_" "_$zd(date,11)
			set seq=0
			set time="",totalTime=0
			for
			{
				set time=$o(statList("Date",month,date,time))
				quit:time=""
				
				set seq=seq+1
				set row("OperSeq"_seq)=$lg(statList("Date",month,date,time),2)
				set totalTime=totalTime+$lg(statList("Date",month,date,time),3)
			}
			set row("OperCount")=seq
			set row("TotalMinutes")=totalTime
			set row("TotalTime")=(totalTime\60)_"小时"_(totalTime#60)_"分钟"
			do OutputRow
		}
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	set Month=$g(row("Month"))
	set Date=$g(row("Date"))
	set OperSeq1=$g(row("OperSeq1"))
	set OperSeq2=$g(row("OperSeq2"))
	set OperSeq3=$g(row("OperSeq3"))
	set OperSeq4=$g(row("OperSeq4"))
	set OperSeq5=$g(row("OperSeq5"))
	set TotalMinutes=$g(row("TotalMinutes"))
	set TotalTime=$g(row("TotalTime"))
	set OperCount=$g(row("OperCount"))
	set ^CacheTemp(repid,ind)=$lb(Month,Date,OperSeq1,OperSeq2,OperSeq3,OperSeq4,OperSeq5,TotalTime,TotalMinutes,OperCount)
	set ind=ind+1
	q
}

ClassMethod FindPersonWorkStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonWorkStatExecute ]
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

ClassMethod FindPersonWorkStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonWorkStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 
/// Creator：      	雍阳
/// CreatDate：    	2018-12-06
/// Description： 	获取麻醉记录单上最大的时间
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.date:日期，2.opsId:手术安排ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.AnesthetistWorkload).GetLargestDataTime(64968,10141)
ClassMethod GetLargestDataTime(date, opsId) As %String [ SqlProc ]
{
	set ParaItemCode="NSBP"  ///从无创收缩压的数据来回去最大值
	set paraItemId=""
	
	&sql(select RowId into :paraItemId from CIS_AN.ParaItem 
		where RecordSheet->OperSchedule=:opsId and Code=:ParaItemCode)
	
	quit:paraItemId="" ""
	
	set result=""
	set loopDate=date+1
	set loopTime="",largestTime=""
	for
	{
		set loopTime=$o(^CIS.AN.AnaDataI("ItemTime",paraItemId,loopDate,loopTime),-1)
		quit:loopTime=""
		
		set anaDataId=$o(^CIS.AN.AnaDataI("ItemTime",paraItemId,loopDate,loopTime,""),-1)
		set anaData=##class(CIS.AN.AnaData).%OpenId(anaDataId)
		continue:anaData.EditFlag="D"
		
		set largestTime=$zd(anaData.StartDate,3)_" "_$zt(anaData.StartTime)
		quit
	}
	
	if largestTime=""
	{
		set loopDate=date
		set loopTime=""
		for
		{
			set loopTime=$o(^CIS.AN.AnaDataI("ItemTime",paraItemId,loopDate,loopTime),-1)
			quit:loopTime=""
		
			set anaDataId=$o(^CIS.AN.AnaDataI("ItemTime",paraItemId,loopDate,loopTime,""),-1)
			set anaData=##class(CIS.AN.AnaData).%OpenId(anaDataId)
			continue:anaData.EditFlag="D"
		
			set largestTime=$zd(anaData.StartDate,3)_" "_$zt(anaData.StartTime)
			quit
		}
	}
	
	quit largestTime
}

/// Creator：      	杨国宾
/// CreatDate：    	2020-10-13
/// Description： 	查询归档日志
/// Table：        	CIS.AN.ArchiveLog
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnesthetistWorkload","FindArchiveLog","2020-09-01","2020-09-30")
Query FindArchiveLog(stdate, enddate) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   %ODBCOUT(ArchiveDate)_" "_%ODBCOUT(ArchiveTime) As ArchiveDateTime,
	   Url,
	   RecordSheet->DataModule->Description As ModuleDesc,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',ArchiveUser) As ArchiveUserDesc,
	   ArchiveUser
	   From CIS_AN.ArchiveLog where (%ODBCOUT(ArchiveDate)>=:stdate) and (%ODBCOUT(ArchiveDate)<=:enddate)
}

}
