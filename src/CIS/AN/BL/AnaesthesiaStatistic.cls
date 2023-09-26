Class CIS.AN.BL.AnaesthesiaStatistic Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-11-25
/// Description： 	查询麻醉效果评价
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindAnaestEvaluation","2018-12-04","2018-12-04","")
Query FindAnaestEvaluation(startDate As %String, endDate As %String, andocCode As %String, andocId As %String = "") As %Query(ROWSPEC = "RowId,OperScheduleId,Month,Date,PatName,Gender,MedcareNo,Operation,GeneralAnInduction,GeneralAnMaintain,GeneralAnEnding,IntraspinalAn,NerveBlock,Complication") [ SqlProc ]
{
}

ClassMethod FindAnaestEvaluationExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocCode As %String, andocId As %String = "") As %Status
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
	
	set andocId=""
	set andocCode=$ZCVT(andocCode,"U")
	if (andocCode'="") && (andocId="") set andocId=$o(^CTPCP(0,"Code",andocCode,""))
	
	set indexNode="OPDate"
	
	for date=startDateH:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set anaSupervisor=operSchedule.AnaExpert
			set anesthesiologist=operSchedule.Anesthesiologist
			set anaAssistants=operSchedule.AnaAssistant
			set statusCode=operSchedule.Status.Code
			
			continue:(anesthesiologist="")&&(anaSupervisor="")
			continue:(andocId="")
			continue:(andocId'="")&&(andocCode'="All")&&(anesthesiologist'=andocId)&&(anaSupervisor'=andocId)&&((","_anaAssistants_",")'[(","_andocId_","))
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			continue:operSchedule.AnaStartDT=""  //无麻醉开始时间不计算
			
			set PatName="",Gender="",Age="",MedcareNo=""
			set OperScheduleId=opsId
			set MedcareNo=""
			
			set patQuery=##class(%ResultSet).%New("CIS.AN.COM.Admission:FindPatient")
			set sc=patQuery.Execute(operSchedule.EpisodeID)
			while(patQuery.%Next())
			{
				set PatName=patQuery.Get("PatName")
				set Gender=patQuery.Get("PatGender")
				set Age=patQuery.Get("PatAge")	
				set MedcareNo=patQuery.Get("MedcareNo")
			}
			
			set Operation=""
			
			set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
			set sc=anaOperQuery.Execute(opsId)
	
			set operation="",operationDesc="",surgeon="",surgeonDesc="",assistant="",assistantDesc="",operPosDesc=""
			set operInfo="",bodySiteDesc="",surgeonShortDesc="",operNote=""
			while(anaOperQuery.%Next())
			{
				set:(Operation'="") Operation=Operation_"+"
				set operationDesc=anaOperQuery.Get("OperationDesc")
				set operNote=anaOperQuery.Get("OperNote")
				set:(operationDesc="") operationDesc=operationDesc_operNote
				set Operation=Operation_operationDesc
			}
			
			set GeneralAnInduction="",GeneralAnMaintain="",GeneralAnEnding=""
			set IntraspinalAn="",NerveBlock="",Complication=""
			set EvaluationId=$o(^CIS.AN.AnaestEvaluationI("OPS",opsId,""))
			if EvaluationId'=""
			{
				set evaluation=##class(CIS.AN.AnaestEvaluation).%OpenId(EvaluationId)
				set GeneralAnInduction=evaluation.GeneralAnInduction
				set GeneralAnMaintain=evaluation.GeneralAnMaintain
				set GeneralAnEnding=evaluation.GeneralAnEnding
				set IntraspinalAn=evaluation.IntraspinalAn
				set NerveBlock=evaluation.NerveBlock
				set Complication=evaluation.Complication
			}
			
			do OutputRow
		}	
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(EvaluationId,OperScheduleId,Month,Day,PatName,
		Gender,MedcareNo,Operation,GeneralAnInduction,GeneralAnMaintain,
		GeneralAnEnding,IntraspinalAn,NerveBlock,Complication)
	s ind=ind+1
	q
}

ClassMethod FindAnaestEvaluationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnaestEvaluationExecute ]
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

ClassMethod FindAnaestEvaluationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnaestEvaluationExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-25
/// Description： 	查询输血登记
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindBloodTrans","2020-06-04","2020-12-04","")
Query FindBloodTrans(startDate As %String, endDate As %String, andocId As %String) As %Query(ROWSPEC = "RowId,OperScheduleId,Month,Date,PatName,Gender,MedcareNo,Operation,RBCs,Plasma,Cryopre,BloodPlatelet") [ SqlProc ]
{
}

ClassMethod FindBloodTransExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocId As %String) As %Status
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
	
	kill BloodCodeList
	set BloodCodeList("FreshFrozenPlasma")="Plasma"
	set BloodCodeList("FrozenPlasma")="Plasma"
	set BloodCodeList("RBCs")="RBCs"
	set BloodCodeList("Cryoprecipitate")="Cryopre"
	set BloodCodeList("BloodPlatelet")="BloodPlatelet"
	
	for date=startDateH:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anaSupervisor=anaesthesia.AnaExpert
			set anesthesiologist=anaesthesia.Anesthesiologist
			set anaAssistants=anaesthesia.AnaAssistant
			set statusCode=operSchedule.Status.Code
			
			continue:(anesthesiologist="")&&(anaSupervisor="")
			continue:(andocId'="")&&(anesthesiologist'=andocId)&&(anaSupervisor'=andocId)&&((","_anaAssistants_",")'[(","_andocId_","))
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			continue:anaesthesia.AnaStartDT=""  //无麻醉开始时间不计算
			
			set PatName="",Gender="",Age="",MedcareNo=""
			set OperScheduleId=opsId
			set MedcareNo=""
			
			set patQuery=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindPatient")
			set sc=patQuery.Execute(operSchedule.EpisodeID)
			while(patQuery.%Next())
			{
				set PatName=patQuery.Get("PatName")
				set Gender=patQuery.Get("PatGender")
				set Age=patQuery.Get("PatAge")	
				set MedcareNo=patQuery.Get("MedcareNo")
			}
			
			set Operation=""
			
			set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
			set sc=anaOperQuery.Execute(opsId)
	
			set operation="",operationDesc="",surgeon="",surgeonDesc="",assistant="",assistantDesc="",operPosDesc=""
			set operInfo="",bodySiteDesc="",surgeonShortDesc="",operNote=""
			while(anaOperQuery.%Next())
			{
				set:(Operation'="") Operation=Operation_"+"
				set operationDesc=anaOperQuery.Get("OperationDesc")
				set operNote=anaOperQuery.Get("OperNote")
				set:(operationDesc="") operationDesc=operationDesc_operNote
				set Operation=Operation_operationDesc
			}
		
			do GetBloodUsage(opsId)
			
			set RBCs=$g(bloodUsage("RBCs"))
			set Plasma=$g(bloodUsage("Plasma"))
			set Cryopre=$g(bloodUsage("Cryopre"))
			set BloodPlatelet=$g(bloodUsage("BloodPlatelet"))
			
			continue:(RBCs<=0)&&(Plasma<=0)&&(Cryopre<=0)&&(BloodPlatelet<=0) //无输血内容
			
			do OutputRow
		}	
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

GetBloodUsage(opsId)
	set bloodTransDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaesthesiaStatistic:GetBloodTransfusion",opsId)
	kill bloodUsage
	
	for i=1:1:bloodTransDatas.Size
	{
		set bloodTransData=bloodTransDatas.GetAt(i)
		quit:bloodTransData=""
		
		set itemCode=bloodTransData.GetValue("ItemCode")
		set dose=bloodTransData.GetValue("DoseQty")
		set code=$g(BloodCodeList(itemCode))
		set:code="" code="other"
		set bloodUsage(code)=$g(bloodUsage(code))+dose
	}
	
	quit
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(EvaluationId,OperScheduleId,Month,Day,PatName,
		Gender,MedcareNo,Operation,RBCs,Plasma,
		Cryopre,BloodPlatelet)
	s ind=ind+1
	q
}

ClassMethod FindBloodTransFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBloodTransExecute ]
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

ClassMethod FindBloodTransClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBloodTransExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-25
/// Description： 	获取输血数据
/// Table：        	CIS.AN.DrugData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","GetBloodTransfusion","14090")
Query GetBloodTransfusion(opsId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	DoseUnit->Description As DoseUnitDesc,
	AnaData->ParaItem->CategoryItem->DataItem->Code As ItemCode
	from CIS_AN.DrugData 
	where AnaData->ParaItem->RecordSheet->OperSchedule=:opsId
	and AnaData->EditFlag="N"
	and (AnaData->ParaItem->Code="BloodTransfusion" 
	or AnaData->ParaItem->CategoryItem->DataCategory->Code="BloodTransfusion")
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-8
/// Description： 	通过就诊号查询手术
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.EpisodeID:就诊号
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindOperScheduleByAdm","19")
Query FindOperScheduleByAdm(EpisodeID As %String) As %Query(ROWSPEC = "RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,AppOrderItem") [ SqlProc ]
{
}

ClassMethod FindOperScheduleByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	if (EpisodeID="")
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	set visibleStatusList=$lb("RoomIn","RoomOut","PACUIn","PACUOut","Finish")
	set opsId=0
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("Adm"," "_EpisodeID,opsId))
		quit:(opsId="")
			
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set statusCode=operSchedule.Status.Code
			
		continue:'$ListFind(visibleStatusList,statusCode)
			
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow
	s ^CacheTemp(repid,ind)=..GetOperSchedule(opsId)
	s ind=ind+1
	q
}

ClassMethod FindOperScheduleByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperScheduleByAdmExecute ]
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

ClassMethod FindOperScheduleByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperScheduleByAdmExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-8
/// Description： 	查询麻醉病人统计
/// Table：        	CIS.AN.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindPatient","2018-12-04","2018-12-04","")
Query FindPatient(userDeptId As %String, startDate As %String, endDate As %String, andocId As %String = "", filterMedcareNo As %String = "") As %Query(ROWSPEC = "RowId,Date,PatDept,PatName,Gender,Age,MedcareNo,Operation,Surgeon,AnaDoctor,ChargeRecord,ChargePrintCount,AnaDuration,AnaestMethod") [ SqlProc ]
{
}

ClassMethod FindPatientExecute(ByRef qHandle As %Binary, userDeptId As %String, startDate As %String, endDate As %String, andocId As %String = "", filterMedcareNo As %String = "") As %Status
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
	
	set moduleCode="AnaestRecord"
	set indexNode="OPDate"
	
	for date=startDateH:1:endDateH+1
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set anaSupervisor=operSchedule.AnaExpert
			set anesthesiologist=operSchedule.Anesthesiologist
			set anaAssistants=operSchedule.AnaAssistant
			set statusCode=operSchedule.Status.Code
			
			set:anesthesiologist="" anesthesiologist=anaSupervisor
			
			continue:anesthesiologist=""
			continue:(andocId'="")&&(anesthesiologist'=andocId)&&(anaSupervisor'=andocId)&&((","_anaAssistants_",")'[(","_andocId_","))
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			continue:operSchedule.AnaStartDT=""  //无麻醉开始时间不计算
			
			set theatreInDT=operSchedule.TheatreInDT
			set theatreInTime=$e(theatreInDT,12,19)
			set theatreInTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(theatreInTime,"")
			continue:(date=startDateH)&&(theatreInTimeH<21600)
			continue:(date>endDateH)&&(theatreInTimeH>=21600)
			
			set patDeptID=operSchedule.PatDeptID
			set patDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",patDeptID)
		
			set PatName="",Gender="",Age="",MedcareNo=""
			set OperScheduleId=opsId
			set MedcareNo=""
			
			set patQuery=##class(%ResultSet).%New("CIS.AN.COM.Admission:FindPatient")
			set sc=patQuery.Execute(operSchedule.EpisodeID)
			while(patQuery.%Next())
			{
				set PatName=patQuery.Get("PatName")
				set Gender=patQuery.Get("PatGender")
				set Age=patQuery.Get("PatAge")	
				set MedcareNo=patQuery.Get("MedcareNo")
			}
			
			continue:(filterMedcareNo'="")&&(MedcareNo'[filterMedcareNo)
			
			set Operation=""
			
			set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
			set sc=anaOperQuery.Execute(opsId)
	
			set operationList="",surgeonList=""
			while(anaOperQuery.%Next())
			{
				set operationDesc=anaOperQuery.Get("OperationDesc")
				set operNote=anaOperQuery.Get("OperNote")
				set:operationDesc="" operationDesc=operNote
				set:operationDesc'="" operationList=operationList_$lb(operationDesc)
				
				set surgeon=anaOperQuery.Get("SurgeonDesc")
				set:surgeon'="" surgeonList=surgeonList_$lb(surgeon)
			}
			
			set operation=$ListToString(operationList,"+")
			set surgeon=$ListToString(surgeonList,",")
	
			set chargeRecord=""
			set hasChargeDetail=##class(CIS.AN.BL.ChargeStatistic).HasChargeDetail(userDeptId,opsId)
			set:hasChargeDetail>0 chargeRecord="√"
			
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")

			set printCount=##class(CIS.AN.BL.PrintLog).GetPrintCount(recordSheetId,"ChargeRecord")
			
			set anaestMethod=##class(CIS.AN.BL.OperSchedule).GetAnaestMethod(opsId)
			
			set anesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anesthesiologist)
			set:(anesthesiologistDesc="") anesthesiologistDesc=anesthesiologist
			
			set anaStartDT=operSchedule.AnaStartDT
			set theatreOutDT=operSchedule.TheatreOutDT
			
			set anaDuration=$e(anaStartDT,12,19)_"~"_$e(theatreOutDT,12,19)
			
			do restoreOutput
		}	
	}
	
	set date=""
	for
	{
		set date=$o(outputList(date))
		quit:date=""
		
		set anaDoctor=""
		for
		{
			set anaDoctor=$o(outputList(date,anaDoctor))
			quit:anaDoctor=""
			
			set opsId=""
			for
			{
				set opsId=$o(outputList(date,anaDoctor,opsId))
				quit:opsId=""
				
				set data=outputList(date,anaDoctor,opsId)
				do OutputRow
			}
		}
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

restoreOutput
	set outputList(date,anesthesiologistDesc,opsId)=$lb(opsId,dateStr,patDeptDesc,PatName,Gender,
								Age,MedcareNo,operation,surgeon,anesthesiologistDesc,
								chargeRecord,printCount,anaDuration,anaestMethod)
	quit

OutputRow
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod FindPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatientExecute ]
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

ClassMethod FindPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatientExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-01-14
/// Description： 	查询麻醉方法统计
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindAnaestMethod","2018-12-04","2020-12-04","")
Query FindAnaestMethod(startDate As %String, endDate As %String, andocCode As %String = "", andocId As %String = "") As %Query(ROWSPEC = "AnaestMethod,Qty") [ SqlProc ]
{
}

ClassMethod FindAnaestMethodExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocCode As %String = "", andocId As %String = "") As %Status
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
	
	set andocId=""
	set andocCode=$ZCVT(andocCode,"U")
	if (andocCode'="") && (andocId="") set andocId=$o(^CTPCP(0,"Code",andocCode,""))
	
	kill anaestMethodList
	set indexNode="OPDate",operCount=0
	
	for date=startDateH:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anaSupervisor=anaesthesia.AnaExpert
			set anesthesiologist=anaesthesia.Anesthesiologist
			set anaAssistants=anaesthesia.AnaAssistant
			set statusCode=operSchedule.Status.Code
			
			continue:(anesthesiologist="")&&(anaSupervisor="")
			continue:(andocId'="")&&(andocCode'="All")&&(anesthesiologist'=andocId)&&(anaSupervisor'=andocId)&&((","_anaAssistants_",")'[(","_andocId_","))
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			continue:anaesthesia.AnaStartDT=""  //无麻醉开始时间不计算
			
			set anaestCatheterId=""
			for
			{
				set anaestCatheterId=$o(^CIS.AN.AnaestCatheterI("IAna",mainAnaId,anaestCatheterId))
				quit:anaestCatheterId=""
				
				set anaestCatheter=##class(CIS.AN.AnaestCatheter).%OpenId(anaestCatheterId)
				if (anaestCatheter.AnaMethod'="")
				{
					set methodId=anaestCatheter.AnaMethod
					set methodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",methodId)
					set anaestMethodList(methodId)=methodDesc
					set anaestMethodList(methodId,opsId)=""
				}
			}
			
			set operCount=operCount+1
		}	
	}
	
	set methodId="",totalQty=0
	for
	{
		set methodId=$o(anaestMethodList(methodId))
		quit:methodId=""
		
		set methodDesc=anaestMethodList(methodId)
		set opsId="",qty=0
		for
		{
			set opsId=$o(anaestMethodList(methodId,opsId))
			quit:opsId=""
			
			set qty=qty+1
		}
		set totalQty=totalQty+qty
		do OutputRow
	}
	
	set methodDesc="总计"
	set qty=totalQty
	do OutputRow
	
	set methodDesc="总手术例数"
	set qty=operCount
	do OutputRow
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	s ^CacheTemp(repid,ind)=$lb(methodDesc,qty)
	s ind=ind+1
	q
}

ClassMethod FindAnaestMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnaestMethodExecute ]
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

ClassMethod FindAnaestMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnaestMethodExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2020-04-02
/// Description： 	查询麻醉医生工分
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","ScoreAnaDoctorWork","2020-03-01","2020-03-31","")
Query ScoreAnaDoctorWork(startDate As %String, endDate As %String, andocId As %String = "") As %Query(ROWSPEC = "DoctorId,DoctorName,Score,Qty,Detail") [ SqlProc ]
{
}

ClassMethod ScoreAnaDoctorWorkExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocId As %String = "") As %Status
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
	
	kill resultList
	set indexNode="OPDate",operCount=0
	
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			set TheatreInDT=anaestObj.GetValue("TheatreInDT")			// 入手术间时间
			set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")			// 离手术间时间
			set AnaStartDT=anaestObj.GetValue("AnaStartDT")				// 麻醉开始时间
			
			set ShiftDoctor=anaestObj.GetValue("ShiftDoctor")			// 麻醉接班医生
			set ShiftDoctorDesc=anaestObj.GetValue("ShiftDoctorDesc")	// 麻醉接班医生
			set Anesthesiologist=anaestObj.GetValue("Anesthesiologist")				// 麻醉医生
			set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")		// 麻醉医生
			
			if opsId=219 break //
			continue:AnaStartDT=""  //无麻醉开始时间不计算
			
			set workScore=..CalculateWorkScore(TheatreInDT,TheatreOutDT)
			set actualWorkScore=workScore
			
			//有接班医生时平分
			set:ShiftDoctor'="" actualWorkScore=workScore/2
			
			if Anesthesiologist'=""
			{
				set resultList(Anesthesiologist)=AnesthesiologistDesc
				set resultList(Anesthesiologist,"Score")=$g(resultList(Anesthesiologist,"Score"))+actualWorkScore
				set resultList(Anesthesiologist,"Qty")=$g(resultList(Anesthesiologist,"Qty"))+1
				set resultList(Anesthesiologist,"Detail")=$g(resultList(Anesthesiologist,"Detail"))_$lb(opsId)
			}
			
			if ShiftDoctor'=""
			{
				set resultList(ShiftDoctor)=ShiftDoctorDesc
				set resultList(ShiftDoctor,"Score")=$g(resultList(ShiftDoctor,"Score"))+actualWorkScore
				set resultList(ShiftDoctor,"Qty")=$g(resultList(ShiftDoctor,"Qty"))+1
				set resultList(ShiftDoctor,"Detail")=$g(resultList(ShiftDoctor,"Detail"))_$lb(opsId)
			}
		}	
	}
	
	set doctorId=""
	for
	{
		set doctorId=$o(resultList(doctorId))
		quit:doctorId=""
		
		set doctorName=resultList(doctorId)
		set score=$g(resultList(doctorId,"Score"))
		set qty=$g(resultList(doctorId,"Qty"))
		set detail=$ListToString($g(resultList(Anesthesiologist,"Detail")),",")
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	s ^CacheTemp(repid,ind)=$lb(doctorId,doctorName,score,qty,detail)
	s ind=ind+1
	q
}

ClassMethod ScoreAnaDoctorWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ScoreAnaDoctorWorkExecute ]
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

ClassMethod ScoreAnaDoctorWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ScoreAnaDoctorWorkExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod CalculateWorkScore(startDateTime, endDateTime) As %String
{
	set result=0
	set duration=##class(CIS.AN.COM.DateTime).CalculateDurationS(startDateTime,endDateTime,"M")
	set result=$s(duration<110:1,1:(1+((duration-110)\60)+((duration-110)#60>0)))
	quit result
}

/// Creator：      	yongyang
/// CreatDate：    	2020-04-06
/// Description： 	查询指定日期范围内的麻醉医生工分对应的手术明细
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.anaDocId
/// Return：       	ResultSet  PatDeptDesc,MedcareNo,PatName,PatAge,OperDate,AnaMethod,DataValue,DataValueList,ArrAnaDocDesc,SurgeonDesc
///                            科室        住院号    患者姓名 年龄  手术日期  麻醉方法  镇痛方法  镇痛明细     麻醉医生      手术医生
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindAnalgesia","2020-03-01","2020-03-31")
Query FindAnaDocScoreDetail(startDate As %String, endDate As %String, anaDocId As %String = "") As %Query(ROWSPEC = "WorkScore,RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc")
{
}

ClassMethod FindAnaDocScoreDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, anaDocId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	
	//转换时间
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	for date=startDateH:1:endDateH+1
	{
		//手术计划表
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:opsId=""
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			
			set patDeptID=operSchedule.PatDeptID.%Id(),PatDeptDesc=operSchedule.PatDeptID.Description
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			continue:anaesthesia.AnaStartDT=""
			
			set ShiftDoctor="",ShiftDoctorDesc="",Anesthesiologist="",AnesthesiologistDesc=""
			if anaesthesia.ShiftDoctor'=""
			{
				set ShiftDoctor=anaesthesia.ShiftDoctor 					// 麻醉接班医生
				set ShiftDoctorDesc=##class(CIS.AN.COM.String).GetDescByID("CF.AN.CareProvider","FullName",ShiftDoctor)	// 麻醉接班医生
			}
			
			if anaesthesia.Anesthesiologist'=""
			{
				set Anesthesiologist=anaesthesia.Anesthesiologist.%Id()				// 麻醉医生
				set AnesthesiologistDesc=anaesthesia.Anesthesiologist.FullName		// 麻醉医生
			}
			
			continue:(anaDocId'="")&&(anaDocId'=Anesthesiologist)&&(anaDocId'=ShiftDoctor)
			
			set workScore=..CalculateWorkScore(anaesthesia.TheatreInDT,anaesthesia.TheatreOutDT)
			set actualWorkScore=workScore
			
			//有接班医生时平分
			set:ShiftDoctor'="" actualWorkScore=workScore/2
			
			do OutputRow
		}		
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	s Data=$lb(actualWorkScore)_..GetOperSchedule(opsId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindAnaDocScoreDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnaDocScoreDetailExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAnaDocScoreDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnaDocScoreDetailExecute ]
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
	Quit $$$OK
}

ClassMethod GetOperSchedule(opsId As %String) As %List
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	// 获取患者信息
	set EpisodeID=operSchedule.EpisodeID
	set ExtAnaestID=operSchedule.ExtAnaestID
	set targetQuery="CIS.AN.BL.Admission:FindPatient"
    if ##class(CIS.AN.BL.Admission).ExistsInstance(EpisodeID) set targetQuery="CIS.AN.BL.Admission:FindPatientNew"
	set patInfoObj=##class(CIS.AN.COM.Query).ToObject(targetQuery,EpisodeID)
	set PatName=patInfoObj.GetValue("PatName")
	set PatGender=patInfoObj.GetValue("PatGender")
	set PatAge=patInfoObj.GetValue("PatAge")
	set PatDOB=patInfoObj.GetValue("PatDOB")
	set RegNo=patInfoObj.GetValue("RegNo")
	set MedcareNo=patInfoObj.GetValue("MedcareNo")	
	set PatientID=patInfoObj.GetValue("PatientID")
	set MRAdmID=patInfoObj.GetValue("MRAdmID")
	set AdmReason=patInfoObj.GetValue("AdmReason")
	set PatCardID=patInfoObj.GetValue("CardID")
	set AdmDateH=patInfoObj.GetValue("AdmDateH")
	set Patient=PatName_(PatGender_" "_PatAge)			// 患者基本信息，格式为：张三(男 30岁)
	set PreopAdmDays=operSchedule.OperDate-AdmDateH		// 术前住院日
	
	// 手术申请信息
	set AppCareProvID=operSchedule.AppCareProvID		// 手术申请医护人员ID
	set AppCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operSchedule.AppCareProvID)
	set PatDeptID=operSchedule.PatDeptID
	set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
	set PatWardID=operSchedule.PatWardID
	set PatWardDesc=##class(CIS.AN.COM.String).GetDescByID("User.PACWard","WARDDesc",operSchedule.PatWardID)
	
	set PatBedID=operSchedule.PatBedID	
	set PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
	set:(PatBedCode="") PatBedCode=operSchedule.PatBedID				// 一般HIS为第三方系统时，将床位代码直接存入PatBedID字段
	
	set WardBed=PatWardDesc_" "_PatBedCode
	
	set AppDeptID=operSchedule.AppDeptID				// 手术申请科室
	set AppDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AppDeptID)
	
	set OperDeptID=operSchedule.OperDeptID				// 手术室
	set OperDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
	
	set AppUserID=operSchedule.AppUserID
	
	// 麻醉科
	set AnaDept=operSchedule.AnaDept
	set AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
	
	set SourceType=operSchedule.SourceType				// 手术类型
	set SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
	
	set Status=operSchedule.Status.%Id()				// 手术状态ID
	set StatusDesc=operSchedule.Status.Description		// 手术状态名称
	set StatusColor=operSchedule.Status.BGColor			// 手术状态背景颜色
	set StatusCode=operSchedule.Status.Code				// 手术状态代码
	
	set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")			// 手术日期(计划)
	set DateFormat=$lg(^websys.ConfigurationD(1),10)
	if ((DateFormat="DMY")&&(OperDate'="")) set OperDate=$zd($zdh(OperDate,3),4)
	set OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")			// 手术开始时间(计划)
	
	set OperDuration=operSchedule.OperDuration			// 手术持续时长(计划)
	set ReentryOperation=operSchedule.ReentryOperation  // 非计划重返手术
	set ReentryOperationDesc=##class(CIS.AN.OperSchedule).ReentryOperationLogicalToDisplay(operSchedule.ReentryOperation)
	set DaySurgery=operSchedule.DaySurgery  // 202002+dyl+日间手术
	set OPAdmType=operSchedule.OPAdmType	//202003+dyl+门诊手术
	set ComeHosTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.ComeHosTime,"")
	set PatPhoneNumber=operSchedule.PatPhoneNumber	//202003+dyl+门诊手术
	set PatNeedNotice=operSchedule.PatNeedNotice	//202003+dyl+门诊手术
	
	set Anaesthesia=operSchedule.Anaesthesia			// 是否麻醉科参与麻醉
	set AnaesthesiaDesc=##class(CIS.AN.OperSchedule).AnaesthesiaLogicalToDisplay(operSchedule.Anaesthesia)
	set PrevAnaMethod=operSchedule.PrevAnaMethod		// 拟施麻醉方法
	set PrevAnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",operSchedule.PrevAnaMethod)
	
	set PlanSeq=operSchedule.PlanSeq					// 计划台次
	set SeqType=operSchedule.SeqType					// 台次类型(正常台，连台)
	set SeqTypeDesc=##class(CIS.AN.OperSchedule).SeqTypeLogicalToDisplay(operSchedule.SeqType)
	
	set PrevDiagnosis=operSchedule.PrevDiagnosis		// 术前诊断
	set PostDiagnosis=operSchedule.PostDiagnosis		// 术后诊断
	set planOperData=..GetPlanOperList(opsId,.planOperData)		// 拟施手术
	set PlanOperDesc=planOperData(1,"OperationDesc")			// 拟施手术名称
	set PlanOperNote=planOperData(1,"OperNote")					// 拟施手术名称备注
	set PlanSurgeonDesc=planOperData(1,"SurgeonDesc")			// 拟施手术医生姓名
	set PlanAsstDesc=planOperData(1,"AssistantDesc")			// 拟施手术助手姓名
	Set PlanFirstAsstDesc=$p(PlanAsstDesc,",",1)				// 拟施手术一助姓名
	set PlanSurgeonExpert=planOperData(1,"SurgeonExpert")		// 拟施手术专家主刀
	set BodySite=operSchedule.BodySite							// 手术部位
	set BodySiteDesc=..GetBodySiteDesc(BodySite)				// 手术部位名称
	set OperPosition=operSchedule.OperPosition					// 手术体位
	Set OperPositionDesc=..GetOperPosDesc(OperPosition)			// 手术体位名称
	set BladeType=operSchedule.BladeType
	set BladeTypeDesc=""
	set:(BladeType'="") BladeTypeDesc=operSchedule.BladeType.Description
	set SurIntership=operSchedule.SurIntership					// 实习进修人员
	set SurVisitors=operSchedule.SurVisitors					// 手术参观人员
	set operData=..GetOperList(opsId,.operData)					// 实施手术
	set OperDesc=operData(1,"OperationDesc")					// 实施手术名称
	set OperNote=operData(1,"OperNote")							// 实施手术名称备注
	set SurgeonDesc=operData(1,"SurgeonDesc")					// 实施手术医生姓名
	set AsstDesc=operData(1,"AssistantDesc")					// 实施手术助手姓名
	Set FirstAsstDesc=$p(AsstDesc,",",1)						// 实施手术一助姓名
	set SurgeonExpert=operData(1,"SurgeonExpert")				// 实施手术专家主刀
	set SurCareProv=SurgeonDesc
	set:AsstDesc'="" SurCareProv=SurgeonDesc_","_AsstDesc
	
	set SurgicalMaterials=operSchedule.SurgicalMaterials		// 手术要求  仪器器械
	set SpecialCondition=operSchedule.SpecialConditions			// 特殊情况
	set HighConsume=operSchedule.HighConsume					// 高值耗材
	set IsoOperation=operSchedule.IsoOperation					// 隔离手术
	set IsoOperationDesc=##class(CIS.AN.OperSchedule).IsoOperationLogicalToDisplay(operSchedule.IsoOperation)
	set ECC=operSchedule.ECC									// 体外循环
	set ECCDesc=##class(CIS.AN.OperSchedule).ECCLogicalToDisplay(operSchedule.ECC)
	set TransAutoBlood=operSchedule.TransAutoblood				// 自体血回输
	set TransAutoBloodDesc=##class(CIS.AN.OperSchedule).TransAutobloodLogicalToDisplay(operSchedule.TransAutoblood)
	set PrepareBlood=operSchedule.PrepareBlood					// 是否备血
	set PrepareBloodDesc=##class(CIS.AN.OperSchedule).PrepareBloodLogicalToDisplay(operSchedule.PrepareBlood)
	set InfectionOper=operSchedule.InfectionOper				// 感染手术
	set InfectionOperDesc=##class(CIS.AN.OperSchedule).InfectionOperLogicalToDisplay(operSchedule.InfectionOper)
	set MIS=operSchedule.MIS									// 微创手术
	set MISDesc=$CASE(MIS,"Y":"是","N":"否",:"")
	set Antibiosis=operSchedule.Antibiosis						// 使用抗生素
	set AntibiosisDesc=##class(CIS.AN.OperSchedule).AntibiosisLogicalToDisplay(operSchedule.Antibiosis)
	set OperRequirement=..GetOperRequirement(opsId)				// 手术要求信息
	
	set BloodType=operSchedule.BloodType						// 检验信息 ABO血型
	set BloodTypeDesc=##class(CIS.AN.OperSchedule).BloodTypeLogicalToDisplay(operSchedule.BloodType)
	set RHType=operSchedule.RHBloodType							// RH血型
	set RHBloodTypeDesc=##class(CIS.AN.OperSchedule).RHBloodTypeLogicalToDisplay(operSchedule.RHBloodType)
	set HbsAg=operSchedule.HbsAg								// 乙肝表面抗原
	set HbsAgDesc=##class(CIS.AN.OperSchedule).HbsAgLogicalToDisplay(operSchedule.HbsAg)
	set HcvAb=operSchedule.HcvAb								// 丙肝抗体
	set HcvAbDesc=##class(CIS.AN.OperSchedule).HcvAbLogicalToDisplay(operSchedule.HcvAb)
	set HivAb=operSchedule.HivAb								// 艾滋病抗体
	set HivAbDesc=##class(CIS.AN.OperSchedule).HivAbLogicalToDisplay(operSchedule.HivAb)
	set Syphilis=operSchedule.Syphilis							// 梅毒
	set SyphilisDesc=##class(CIS.AN.OperSchedule).SyphilisLogicalToDisplay(operSchedule.Syphilis)
	
	// 手术排班信息
	set OperRoom="",RoomDesc="",RoomCode=""						// 手术间
	if (operSchedule.OperRoom'="")
	{
		set OperRoom=operSchedule.OperRoom.%Id()				// 手术间ID
		set RoomDesc=operSchedule.OperRoom.Description			// 手术间名称
		set RoomCode=operSchedule.OperRoom.Code					// 手术间代码
	}
	set OperSeq=operSchedule.OperSeq							// 手术台次
	set ScrubNurse=operSchedule.ScrubNurse						// 器械护士，多个护士以","拼接
	set ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurse)		// 器械护士姓名
	set FirstScrubNurse=$p(ScrubNurse,",",1),FirstScrubNurseDesc=$p(ScrubNurseDesc,",",1)
	set SecScrubNurse=$p(ScrubNurse,",",2),SecScrubNurseDesc=$p(ScrubNurseDesc,",",2)
	set CircualNurse=operSchedule.CircualNurse					// 巡回护士，多个护士以","拼接
	set CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CircualNurse)	// 巡回护士姓名
	set FirstCircualNurse=$p(CircualNurse,",",1),FirstCircualNurseDesc=$p(CircualNurseDesc,",",1)
	set SecCircualNurse=$p(CircualNurse,",",2),SecCircualNurseDesc=$p(CircualNurseDesc,",",2)
	set InternshipNurse=""  //operSchedule.InternshipNurse			// 实习护士
	
	// 麻醉信息
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set TheatreInDT=anaestObj.GetValue("TheatreInDT")			// 入手术间时间
	set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")			// 离手术间时间
	
	set OperStartDT=anaestObj.GetValue("OperStartDT")			// 手术开始时间
	set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
	set AnaStartDT=anaestObj.GetValue("AnaStartDT")				// 麻醉开始时间
	set AnaFinishDT=anaestObj.GetValue("AnaFinishDT")			// 麻醉结束时间
	set TubeInDT=anaestObj.GetValue("TubeInDT")					// 插管时间
	set TubeOutDT=anaestObj.GetValue("TubeOutDT")				// 拔管时间
	set AreaInDT=anaestObj.GetValue("AreaInDT")					// 入手术室时间
	set AreaOutDT=anaestObj.GetValue("AreaOutDT")				// 离手术室时间
	
	set PACUInDT=anaestObj.GetValue("PACUInDT")					// 入PACU时间
	set PACUOutDT=anaestObj.GetValue("PACUOutDT")				// 离PACU时间
	set OperDateTime=OperStartDT								// 手术开始时间
	set:(OperDateTime="") OperDateTime=OperDate_" "_OperTime
	set PACUDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(PACUInDT,PACUOutDT,"H")
	set ROperDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(OperStartDT,OperFinishDT,"H")
	set WaitDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(TheatreInDT,AnaStartDT,"M")	
	set AnaestID=anaestObj.GetValue("RowId")					// 麻醉申请ID
	set AnaMethod=anaestObj.GetValue("AnaMethod")				// 麻醉方法ID
	set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)   // 麻醉方法名称
	set ArrAnaMethod=anaestObj.GetValue("ArrAnaMethod")				// 排班麻醉方法ID
	set ArrAnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",ArrAnaMethod)	// 麻醉方法名称
	set AnaExpert=anaestObj.GetValue("AnaExpert")				// 麻醉指导
	set AnaExpertDesc=anaestObj.GetValue("AnaExpertDesc")		// 麻醉指导姓名
	set ArrAnaExpert=anaestObj.GetValue("ArrAnaExpert")				// 排班麻醉指导
	set ArrAnaExpertDesc=anaestObj.GetValue("ArrAnaExpertDesc")		// 排班麻醉指导姓名
	
	set Anesthesiologist=anaestObj.GetValue("Anesthesiologist")	// 麻醉医生
	set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")		// 麻醉医生姓名
	set ArrAnesthesiologist=anaestObj.GetValue("ArrAnesthesiologist")	// 排班麻醉医生
	set ArrAnesthesiologistDesc=anaestObj.GetValue("ArrAnesthesiologistDesc")		// 排班麻醉医生姓名
	set AnaAssistant=anaestObj.GetValue("AnaAssistant")			// 麻醉助手
	set AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaAssistant)		// 麻醉助手姓名
	set ArrAnaAssistant=anaestObj.GetValue("ArrAnaAssistant")			// 排班麻醉助手
	set ArrAnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrAnaAssistant)		// 排班麻醉助手姓名
	set AnaStaff=anaestObj.GetValue("AnaStaff")					// 实习进修
	set ArrAnaStaff=anaestObj.GetValue("ArrAnaStaff")					// 排班实习进修
	set ASAClass=anaestObj.GetValue("ASAClass")					// ASA分级
	set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")			// ASA分级描述
	set PreOperNote=anaestObj.GetValue("PreOperNote")			// 术前特殊情况
	set PreMedication=anaestObj.GetValue("PreMedication")		// 术前用药
	set PreFasting=anaestObj.GetValue("PreFasting")				// 术前禁食
	set PreFastingDesc=anaestObj.GetValue("PreFastingDesc")		// 术前禁食
	set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc")		// 离手术间去向代码
	set TheatreOutTransLocDesc=anaestObj.GetValue("TheatreOutTransLocDesc")		// 离手术间去向名称
	
	set careprovlist=""
	set:AnesthesiologistDesc'="" careprovlist=careprovlist_$lb(AnesthesiologistDesc)
	set:AnaExpertDesc'="" careprovlist=careprovlist_$lb(AnaExpertDesc)
	set:AnaAssistantDesc'="" careprovlist=careprovlist_$lb(AnaAssistantDesc)
	set:AnaStaff'="" careprovlist=careprovlist_$lb(AnaStaff)
	set AnaCareProv=$ListToString(careprovlist,",")
	
	set MainAnaesthesia=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AppDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)	// 手术申请日期时间
	
	set PatHeight=operSchedule.PatHeight
	set PatWeight=operSchedule.PatWeight
	set AnaestMethod=..GetAnaestMethod(opsId)
	
	set opaId=operSchedule.ExternalID
	
	// 获取排班信息
	set ArrOperRoom="",ArrRoomCode="",ArrRoomDesc="",ArrOperSeq="",ArrScrubNurse="",ArrScrubNurseDesc="",ArrCircualNurse="",ArrCircualNurseDesc=""
	set:($IsObject(operSchedule.ArrOperRoom)) ArrOperRoom=operSchedule.ArrOperRoom.%Id(),ArrRoomDesc=operSchedule.ArrOperRoom.Description,ArrRoomCode=operSchedule.ArrOperRoom.Code
	set ArrOperSeq=operSchedule.ArrOperSeq
	set ArrScrubNurse=operSchedule.ArrScrubNurse
	set ArrScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrScrubNurse)
	set ArrCircualNurse=operSchedule.ArrCircualNurse
	set ArrCircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrCircualNurse)
	set ArrFirstScrubNurse=$p(ArrScrubNurse,",",1),ArrFirstScrubNurseDesc=$p(ArrScrubNurseDesc,",",1)
	set ArrSecScrubNurse=$p(ArrScrubNurse,",",2),ArrSecScrubNurseDesc=$p(ArrScrubNurseDesc,",",2)
	set ArrFirstCircualNurse=$p(ArrCircualNurse,",",1),ArrFirstCircualNurseDesc=$p(ArrCircualNurseDesc,",",1)
	set ArrSecCircualNurse=$p(ArrCircualNurse,",",2),ArrSecCircualNurseDesc=$p(ArrCircualNurseDesc,",",2)

	set MDROS=operSchedule.MDROS		// 多重耐药菌
	set MDROSDesc=$CASE(MDROS,"N":"未知","-":"阴性","+":"阳性",:"")
	set AppOrderItem=operSchedule.AppOrderItem
	set PACUBed="",PACUBedDesc=""
	set:operSchedule.PACUBed'="" PACUBed=operSchedule.PACUBed.%Id(),PACUBedDesc=operSchedule.PACUBed.Description
	
	
	set result=$lb(opsId,opsId,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,
				   PatientID, MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,
				   PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,
				   StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,
				   PrevAnaMethodDesc,PlanSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,
				   OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialCondition,HighConsume,
				   IsoOperation,ECC,TransAutoBlood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHType,
				   HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,
				   CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCircualNurse,FirstCircualNurseDesc,SecCircualNurse,
				   SecCircualNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,
				   AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,
				   Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,
				   InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,
				   PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,
				   ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,
				   opaId,
				   ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,
				   ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCircualNurse,ArrFirstCircualNurseDesc,ArrSecCircualNurse,ArrSecCircualNurseDesc,
				   MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,
				   ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,AppOrderItem)
	quit result
}

ClassMethod GetOperRequirement(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operReq="",splitChar=","
	set:(operSchedule.IsoOperation="Y") operReq="隔离手术"
	if (operSchedule.ECC="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"体外循环手术"	
	}
	if (operSchedule.TransAutoblood="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"自体血回输"	
	}
	if (operSchedule.PrepareBlood="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"术前备血"	
	}
	if (operSchedule.InfectionOper="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"感染手术"	
	}
	if (operSchedule.MIS="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"微创手术"	
	}
	if (operSchedule.Antibiosis="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"使用抗生素"	
	}
	quit operReq
}

/// Creator：      	ccq
/// CreatDate：    	2019年7月4日
/// Description： 	根据手术申请ID获取拟施手术名称
/// Table：        	CIS_AN.OperSchedule,CIS_AN.PlanOperList
/// Input:			opsId:手术申请ID
/// Return：        拟施手术信息json字符串
/// w ##class(CIS.AN.BL.OperScheduleList).GetPlanOperList("7")
ClassMethod GetPlanOperList(opsId As %String, planOperData As %String) As %String
{
	set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindPlanOperationList",opsId)
	set operIdStr="",operDescStr="",operNoteStr="",surgeonStr="",surgeonDescStr="",assistantStr="",assistantDescStr="",splitChar=",",mainSplitChar="&&&"
	set surgeonExpertStr="",surgeonList="",surgeonDescList="",assistantList="",assistantDescList=""
	
	for i=1:1:operList.Size
	{
		set operObj=operList.GetAt(i)
		set operId=operObj.GetValue("Operation")
		set:(operIdStr'="") operIdStr=operIdStr_splitChar
		set operIdStr=operIdStr_operId
		
		set operDesc=operObj.GetValue("OperationDesc")
		set:(operDescStr'="") operDescStr=operDescStr_splitChar
		set operDescStr=operDescStr_operDesc
		
		set operNote=operObj.GetValue("OperNote")
		set:(operNoteStr'="") operNoteStr=operNoteStr_splitChar
		set operNoteStr=operNoteStr_operNote
		
		set surgeon=operObj.GetValue("Surgeon")
		if (surgeonList="") 
		{
			set surgeonList=$lfs(surgeon,splitChar)	
		}
		else
		{
			set:($lf(surgeonList,surgeon)=0) $li(surgeonList,$ll(surgeonList)+1)=surgeon	
		}
		
		//set:(surgeonStr'="") surgeonStr=surgeonStr_splitChar
		//set surgeonStr=surgeonStr_surgeon
		
		set surgeonDesc=operObj.GetValue("SurgeonDesc") 	
		set:(surgeonDesc="") surgeonDesc=surgeon
		if (surgeonDescList="") 
		{
			set surgeonDescList=$lfs(surgeonDesc,splitChar)	
		}
		else
		{
			set:($lf(surgeonDescList,surgeonDesc)=0) $li(surgeonDescList,$ll(surgeonDescList)+1)=surgeonDesc	
		}
		//set:(surgeonDescStr'="") surgeonDescStr=surgeonDescStr_splitChar
		//set surgeonDescStr=surgeonDescStr_surgeonDesc
		
		set assistant=operObj.GetValue("Assistant")
		if (assistantList="") 
		{
			set assistantList=$lfs(assistant,splitChar)	
		}
		else
		{
			for j=1:1:$l(assistant,splitChar)
			{
				set curAssist=$p(assistant,splitChar,j)
				set:($lf(assistantList,curAssist)=0) $li(assistantList,$ll(assistantList)+1)=curAssist	
			}
				
		}
		//set:(assistantStr'="") assistantStr=assistantStr_splitChar
		//set assistantStr=assistantStr_assistant
		
		set assistantDesc=operObj.GetValue("AssistantDesc")
		if (assistantDescList="") 
		{
			set assistantDescList=$lfs(assistantDesc,splitChar)	
		}
		else
		{
			for k=1:1:$l(assistantDesc,splitChar)
			{
				set curAssistDesc=$p(assistantDesc,splitChar,k)
				set:($lf(assistantDescList,curAssistDesc)=0) $li(assistantDescList,$ll(assistantDescList)+1)=curAssistDesc	
			}
			
		}
		//set:(assistantDescStr'="") assistantDescStr=assistantDescStr_splitChar
		//set assistantDescStr=assistantDescStr_assistantDesc

		set surgeonExpert=operObj.GetValue("SurgeonExpert")
		set:(surgeonExpertStr'="") surgeonExpertStr=surgeonExpertStr_splitChar
		set surgeonExpertStr=surgeonExpertStr_surgeonExpert
	}
	
	k planOperData
	set planOperData(1,"OperSchedule")=opsId
	set planOperData(1,"Operation")=operIdStr
	set planOperData(1,"OperationDesc")=operDescStr
	set planOperData(1,"OperNote")=operNoteStr
	set planOperData(1,"Surgeon")=$lts(surgeonList,splitChar)				//surgeonStr
	set planOperData(1,"SurgeonDesc")=$lts(surgeonDescList,splitChar)								//surgeonDescStr
	set planOperData(1,"Assistant")=$lts(assistantList,splitChar) //assistantStr
	set planOperData(1,"AssistantDesc")=$lts(assistantDescList,splitChar) //assistantDescStr
	set planOperData(1,"SurgeonExpert")=surgeonExpertStr
	
	set result=##class(CIS.AN.COM.String).ToJson(.planOperData)
	quit result
}

/// Creator：      	ccq
/// CreatDate：    	2019年7月4日
/// Description： 	根据手术申请ID获取拟施手术名称
/// Table：        	CIS_AN.OperSchedule,CIS_AN.PlanOperList
/// Input:			opsId:手术申请ID
/// Return：        拟施手术信息json字符串
/// w ##class(CIS.AN.BL.OperScheduleList).GetPlanOperList("7")
ClassMethod GetOperList(opsId As %String, planOperData As %String) As %String
{
	set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
	set operIdStr="",operDescStr="",operNoteStr="",surgeonStr="",surgeonDescStr="",assistantStr="",assistantDescStr="",splitChar=",",mainSplitChar="&&&"
	set surgeonExpertStr="",surgeonList="",surgeonDescList="",assistantList="",assistantDescList=""
	for i=1:1:operList.Size
	{
		set operObj=operList.GetAt(i)
		set operId=operObj.GetValue("Operation")
		set:(operIdStr'="") operIdStr=operIdStr_splitChar
		set operIdStr=operIdStr_operId
		
		set operDesc=operObj.GetValue("OperationDesc")
		set:(operDescStr'="") operDescStr=operDescStr_splitChar
		set operDescStr=operDescStr_operDesc
		
		set operNote=operObj.GetValue("OperNote")
		set:(operNoteStr'="") operNoteStr=operNoteStr_splitChar
		set operNoteStr=operNoteStr_operNote
		
		set surgeon=operObj.GetValue("Surgeon")
		if (surgeonList="") 
		{
			set surgeonList=$lfs(surgeon,splitChar)	
		}
		else
		{
			set:($lf(surgeonList,surgeon)=0) $li(surgeonList,$ll(surgeonList)+1)=surgeon	
		}
		
		//set:(surgeonStr'="") surgeonStr=surgeonStr_splitChar
		//set surgeonStr=surgeonStr_surgeon
		
		set surgeonDesc=operObj.GetValue("SurgeonDesc") 	
		set:(surgeonDesc="") surgeonDesc=surgeon
		if (surgeonDescList="") 
		{
			set surgeonDescList=$lfs(surgeonDesc,splitChar)	
		}
		else
		{
			set:($lf(surgeonDescList,surgeonDesc)=0) $li(surgeonDescList,$ll(surgeonDescList)+1)=surgeonDesc	
		}
		//set:(surgeonDescStr'="") surgeonDescStr=surgeonDescStr_splitChar
		//set surgeonDescStr=surgeonDescStr_surgeonDesc
		
		set assistant=operObj.GetValue("Assistant")
		if (assistantList="") 
		{
			set assistantList=$lfs(assistant,splitChar)	
		}
		else
		{
			for j=1:1:$l(assistant,splitChar)
			{
				set curAssist=$p(assistant,splitChar,j)
				set:($lf(assistantList,curAssist)=0) $li(assistantList,$ll(assistantList)+1)=curAssist	
			}
				
		}
		//set:(assistantStr'="") assistantStr=assistantStr_splitChar
		//set assistantStr=assistantStr_assistant
		
		set assistantDesc=operObj.GetValue("AssistantDesc")
		if (assistantDescList="") 
		{
			set assistantDescList=$lfs(assistantDesc,splitChar)	
		}
		else
		{
			for k=1:1:$l(assistantDesc,splitChar)
			{
				set curAssistDesc=$p(assistantDesc,splitChar,k)
				set:($lf(assistantDescList,curAssistDesc)=0) $li(assistantDescList,$ll(assistantDescList)+1)=curAssistDesc	
			}
			
		}
		//set:(assistantDescStr'="") assistantDescStr=assistantDescStr_splitChar
		//set assistantDescStr=assistantDescStr_assistantDesc

		set surgeonExpert=operObj.GetValue("SurgeonExpert")
		set:(surgeonExpertStr'="") surgeonExpertStr=surgeonExpertStr_splitChar
		set surgeonExpertStr=surgeonExpertStr_surgeonExpert
	}
	
	k planOperData
	set planOperData(1,"OperSchedule")=opsId
	set planOperData(1,"Operation")=operIdStr
	set planOperData(1,"OperationDesc")=operDescStr
	set planOperData(1,"OperNote")=operNoteStr
	set planOperData(1,"Surgeon")=$lts(surgeonList,splitChar)				//surgeonStr
	set planOperData(1,"SurgeonDesc")=$lts(surgeonDescList,splitChar)								//surgeonDescStr
	set planOperData(1,"Assistant")=$lts(assistantList,splitChar) //assistantStr
	set planOperData(1,"AssistantDesc")=$lts(assistantDescList,splitChar) //assistantDescStr
	set planOperData(1,"SurgeonExpert")=surgeonExpertStr
	
	set result=##class(CIS.AN.COM.String).ToJson(.planOperData)
	quit result
}

/// Creator：      	yongyang
/// CreatDate：    	2020年2月6日
/// Description： 	根据手术申请ID获取麻醉方法名称（带有导管信息）
/// Table：        	CIS_AN.OperSchedule,CIS_AN.AnaestCatheter
/// Input:			opsId:手术申请ID
/// Return：        麻醉方法名称（带有导管信息）
/// w ##class(CIS.AN.BL.OperScheduleList).GetAnaestMethod("6")
ClassMethod GetAnaestMethod(opsId As %String) As %String
{
	set dataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaestCatheter",opsId)
	set result="",catheterInfo=""
	for i=1:1:dataList.Size
	{
		set dataObj=dataList.GetAt(i)
		set AnaMethodDesc=dataObj.GetValue("AnaMethodDesc")
		set CatheterDesc=dataObj.GetValue("CatheterDesc")
		set CatheterTypeDesc=dataObj.GetValue("CatheterTypeDesc")
		set CatheterDepthDesc=dataObj.GetValue("CatheterDepthDesc")
		set CatheterPathDesc=dataObj.GetValue("CatheterPathDesc")
		set CatheterToolDesc=dataObj.GetValue("CatheterToolDesc")
		set CatheterDirectionDesc=dataObj.GetValue("CatheterDirectionDesc")
		set PunctureSpaceDesc=dataObj.GetValue("PunctureSpaceDesc")
		set PositionMethodDesc=dataObj.GetValue("PositionMethodDesc")
		
		set catheterInfo=""
		set:CatheterDesc'="" catheterInfo=catheterInfo_$lb(CatheterDesc)
		set:CatheterTypeDesc'="" catheterInfo=catheterInfo_$lb(CatheterTypeDesc)
		set:CatheterDepthDesc'="" catheterInfo=catheterInfo_$lb(CatheterDepthDesc)
		set:CatheterPathDesc'="" catheterInfo=catheterInfo_$lb(CatheterPathDesc)
		set:CatheterToolDesc'="" catheterInfo=catheterInfo_$lb(CatheterToolDesc)
		set:CatheterDirectionDesc'="" catheterInfo=catheterInfo_$lb(CatheterDirectionDesc)
		set:PunctureSpaceDesc'="" catheterInfo=catheterInfo_$lb(PunctureSpaceDesc)
		set:PositionMethodDesc'="" catheterInfo=catheterInfo_$lb(PositionMethodDesc)
		
		if catheterInfo="" set result=result_$lb(AnaMethodDesc)
		else  set result=result_$lb(AnaMethodDesc_"("_$ListToString(catheterInfo,",")_")")
	}
	
	quit $ListToString(result,"+")
}

ClassMethod GetORAnaestID(opsId As %String) As %String
{
	set anaestID=""
	&sql(select ExtAnaestID into :anaestID from CIS_AN.OperSchedule where RowId=:opsId)
	quit anaestID
}

ClassMethod GetBodySiteDesc(bodySiteStr As %String) As %String
{
	set bodySiteDesc=""
	set count=$l(bodySiteStr,",")
	for i=1:1:count
	{
		set bodySiteID=$p(bodySiteStr,",",i)
		continue:(##class(CT.AN.BodySite).%ExistsId(bodySiteID)=0)
		set bodySiteObj=##class(CT.AN.BodySite).%OpenId(bodySiteID)
		set:(bodySiteDesc'="")&(bodySiteObj.Description'="") bodySiteDesc=bodySiteDesc_","
		set bodySiteDesc=bodySiteDesc_bodySiteObj.Description
	}	
	quit bodySiteDesc
}

ClassMethod GetOperPosDesc(operPosStr As %String) As %String
{
	set operPosDesc=""
	set count=$l(operPosStr,",")
	for i=1:1:count
	{
		set operPosID=$p(operPosStr,",",i)
		continue:(##class(CT.AN.OperPosition).%ExistsId(operPosID)=0)
		set operPosObj=##class(CT.AN.OperPosition).%OpenId(operPosID)
		set:(operPosDesc'="")&(operPosObj.Description'="") operPosDesc=operPosDesc_","
		set operPosDesc=operPosDesc_operPosObj.Description
	}	
	quit operPosDesc
}

/// Creator：      	hht
/// CreatDate：    	2019-03-11
/// Description： 	统计指定日期范围内的术后镇痛患者情况
/// Table：        	DHCAN.Model.OperSchedule,DHCAN.BLL.RecordSheet,DHCAN.Model.RecParaItem,DHCAN.Model.AnaData,DHCAN.Model.EventData
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.dataCategory:数据项分类，4.editFlag:编辑状态，5.categoryItem:数据项，6.eventDetailItem:事件明细项 
/// Return：       	ResultSet  PatDeptDesc,MedcareNo,PatName,PatAge,OperDate,AnaMethod,DataValue,DataValueList,ArrAnaDocDesc,SurgeonDesc
///                            科室        住院号    患者姓名 年龄  手术日期  麻醉方法  镇痛方法  镇痛明细     麻醉医生      手术医生
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindAnalgesia","2022-07-01","2022-07-26")
Query FindAnalgesia(startDate As %String, endDate As %String, anaDocId As %String = "") As %Query(ROWSPEC = "GroupMark,AnalgesiaType,AnalgesiaDetail,RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc")
{
}

ClassMethod FindAnalgesiaExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, anaDocId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	
	//转换时间
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	for date=startDateH:1:endDateH+1
	{
		//手术计划表
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:opsId=""
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="PACUIn")&&(statusCode'="Finish")
			
			continue:operSchedule.PatDeptID=""
			
			set patDeptID=operSchedule.PatDeptID
			set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			//continue:anaesthesia.AnaStartDT=""
			continue:(anaDocId'="")&&(anaDocId'=anaesthesia.Anesthesiologist)
			
			kill analgesiaDataList
			set hasAnalgesia=##class(CIS.AN.BL.AnesthetistWorkload).GetAnalgesiaData(opsId,.analgesiaDataList)
			//continue:hasAnalgesia'="Y"
			
			do GetAnalgesiaDetail
			do OutputRow
		}		
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

GetAnalgesiaDetail
	set analgesiaDetail="",analgesiaType=""
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
			set analgesiaDetail=analgesiaDetail_$lb(description_":"_eventData.DataValue_""_unit)
			if description["配方" set analgesiaType=eventData.DataValue
		}				
	}
	set analgesiaDetail=$ListToString(analgesiaDetail,"<br/>")
	quit
OutputRow
	s Data=$lb("One",analgesiaType,analgesiaDetail)_..GetOperSchedule(opsId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindAnalgesiaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnalgesiaExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAnalgesiaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnalgesiaExecute ]
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
	Quit $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-06
/// Description： 	分日期统计ASA分级的手术
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnesthetistWorkload","FindASAStat","2018-11-01","2018-11-30")
Query FindPACUStat(startDate As %String, endDate As %String, anaDocId As %String = "") As %Query(ROWSPEC = "Date,Qty,StewardQty") [ SqlProc ]
{
}

ClassMethod FindPACUStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, anaDocId As %String = "") As %Status
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
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			
			//continue:anaesthesia.OperFinishDT=""  //无手术结束时间不计算
			
			continue:anaesthesia.TheatreOutTransLoc'="PACU"
			
			set statList("Total","Qty")=$g(statList("Total","Qty"))+1
			set statList("Date",date,"Qty")=$g(statList("Date",date,"Qty"))+1
			
			set pacuRecordId=##class(CIS.AN.BL.PACURecord).GetPACURecordId(opsId)
			continue:pacuRecordId=""
			
			set pacuRecord=##class(CIS.AN.PACURecord).%OpenId(pacuRecordId)
			set steward=0
			if $IsObject(pacuRecord.OutSteward) set steward=pacuRecord.OutSteward.Score
			if +steward>4 
			{
				set statList("Total","StewardQty")=$g(statList("Total","StewardQty"))+1
				set statList("Date",date,"StewardQty")=$g(statList("Date",date,"StewardQty"))+1
			}
		}	
	}
	
	set DateStr="总计"
	set Qty=+$g(statList("Total","Qty"))
	set StewardQty=+$g(statList("Total","StewardQty"))
	do OutputRow
	
	set date=""
	for
	{
		set date=$o(statList("Date",date),-1)
		quit:date=""
		
		set DateStr=$zd(date,3)
		set Qty=+$g(statList("Date",date,"Qty"))
		set StewardQty=+$g(statList("Date",date,"StewardQty"))
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	set ^CacheTemp(repid,ind)=$lb(DateStr,Qty,StewardQty)
	set ind=ind+1
	q
}

ClassMethod FindPACUStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPACUStatExecute ]
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

ClassMethod FindPACUStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPACUStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-25
/// Description： 	统计输血总量
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","StatBloodTrans","2020-03-01","2020-12-31","")
Query StatBloodTrans(startDate As %String, endDate As %String, andocId As %String) As %Query(ROWSPEC = "Code,Desc,Qty,Count") [ SqlProc ]
{
}

ClassMethod StatBloodTransExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocId As %String) As %Status
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
	
	kill totalInfo
	kill summaryCategory,summaryCodeList
	do SetSummaryCode
	
	for date=startDateH:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anaSupervisor=anaesthesia.AnaExpert
			set anesthesiologist=anaesthesia.Anesthesiologist
			set anaAssistants=anaesthesia.AnaAssistant
			set statusCode=operSchedule.Status.Code
			
			//continue:(anesthesiologist="")&&(anaSupervisor="")
			continue:(andocId'="")&&(anesthesiologist'=andocId)&&(anaSupervisor'=andocId)&&((","_anaAssistants_",")'[(","_andocId_","))
			
			continue:anaesthesia.AnaStartDT=""  //无麻醉开始时间不计算
		
			do ..GetDrugSummaryInfo(opsId,.summaryCodeList,.totalInfo)
			break //
		}	
	}
	
	set summaryCode=""
	for
	{
		set summaryCode=$o(summaryCategory(summaryCode))
		quit:summaryCode=""
		
		set desc=summaryCategory(summaryCode)
		set uom=$g(summaryCategory(summaryCode,"Uom"))
		set qty=$g(totalInfo("Category",summaryCode,"Qty"))
		set:qty>0 qty=qty_uom
		set count=$g(totalInfo("Category",summaryCode,"Count"))
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(summaryCode,desc,qty,count)
	s ind=ind+1
	q

SetSummaryCode
	/// summaryCategory(分类代码)=汇总名称
	set summaryCategory("Plasma")="血浆",summaryCategory("Plasma","Uom")="ml"
	set summaryCategory("RedCell")="红细胞",summaryCategory("RedCell","Uom")="u"
	set summaryCategory("Cryopre")="冷沉淀",summaryCategory("Cryopre","Uom")="u"
	set summaryCategory("BloodPlate")="血小板",summaryCategory("BloodPlate","Uom")="u"
	
	do ..GetSummaryCodeList(.summaryCategory,.summaryCodeList)
	
	set totalInfo("Category","Plasma","Qty")=0,totalInfo("Category","Plasma","Count")=0
	set totalInfo("Category","RedCell","Qty")=0,totalInfo("Category","RedCell","Count")=0
	set totalInfo("Category","Cryopre","Qty")=0,totalInfo("Category","Cryopre","Count")=0
	set totalInfo("Category","BloodPlate","Qty")=0,totalInfo("Category","BloodPlate","Count")=0
	quit
}

ClassMethod StatBloodTransFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatBloodTransExecute ]
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

ClassMethod StatBloodTransClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatBloodTransExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-25
/// Description： 	统计输血总量
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindBloodTransDetail","2020-03-01","2020-03-31","Plasma")
Query FindBloodTransDetail(startDate As %String, endDate As %String, andocId As %String, filterSummaryCode As %String) As %Query(ROWSPEC = "BloodTransDetail,RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc") [ SqlProc ]
{
}

ClassMethod FindBloodTransDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocId As %String, filterSummaryCode As %String) As %Status
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
	
	kill totalInfo
	kill summaryCategory,summaryCodeList
	do SetSummaryCode
	
	for date=startDateH:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anaSupervisor=anaesthesia.AnaExpert
			set anesthesiologist=anaesthesia.Anesthesiologist
			set anaAssistants=anaesthesia.AnaAssistant
			set statusCode=operSchedule.Status.Code
			
			//continue:(anesthesiologist="")&&(anaSupervisor="")
			continue:(andocId'="")&&(anesthesiologist'=andocId)&&(anaSupervisor'=andocId)&&((","_anaAssistants_",")'[(","_andocId_","))
			
			continue:anaesthesia.AnaStartDT=""  //无麻醉开始时间不计算
		
			kill totalInfo
			do ..GetDrugSummaryInfo(opsId,.summaryCodeList,.totalInfo)
			break //
			continue:+$g(totalInfo("Category",filterSummaryCode,"Qty"))=0 //对应类别统计值为0
			
			set dataItemId="",detailList=""
			for
			{
				set dataItemId=$o(totalInfo("DataItem",dataItemId))
				quit:dataItemId=""
				
				set desc=$g(totalInfo("DataItem",dataItemId))
				set qty=$g(totalInfo("DataItem",dataItemId,"Qty"))
				set summaryCode=$o(summaryCodeList(dataItemId,""))
				set uom=$g(summaryCategory(summaryCode,"Uom"))
				set detailList=detailList_$lb(desc_" "_qty_uom)
			}
			
			set bloodTransDetail=$ListToString(detailList,",")
			do OutputRow
		}	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(bloodTransDetail)_..GetOperSchedule(opsId)
	s ind=ind+1
	q

SetSummaryCode
	/// summaryCategory(分类代码)=汇总名称
	set summaryCategory("Plasma")="血浆",summaryCategory("Plasma","Uom")="ml"
	set summaryCategory("RedCell")="红细胞",summaryCategory("RedCell","Uom")="u"
	set summaryCategory("Cryopre")="冷沉淀",summaryCategory("Cryopre","Uom")="u"
	set summaryCategory("BloodPlate")="血小板",summaryCategory("BloodPlate","Uom")="u"
	
	do ..GetSummaryCodeList(.summaryCategory,.summaryCodeList)
	quit
}

ClassMethod FindBloodTransDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBloodTransDetailExecute ]
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

ClassMethod FindBloodTransDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBloodTransDetailExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod GetSummaryCodeList(ByRef summaryCategory, ByRef summaryCodeList) As %String
{
	set categoryCode=""
	for
	{
		set categoryCode=$o(summaryCategory(categoryCode))
		quit:categoryCode=""
		
		set categoryId=$o(^CT.AN.DataCategoryI("ICode"," "_$ZCVT(categoryCode,"U"),""))
		
		continue:categoryId=""
		set categoryItemId=""
		for
		{
			set categoryItemId=$o(^CT.AN.DataCateItemI("IDataCategory",categoryId,categoryItemId))
			quit:categoryItemId=""
			
			set categoryItem=##class(CT.AN.DataCateItem).%OpenId(categoryItemId)
			set dataItemId=categoryItem.DataItem.%Id()
			set dataItemDesc=categoryItem.DataItem.Description
			set summaryCodeList(dataItemId,categoryCode)=""
			set summaryCodeList(dataItemId)=dataItemDesc
		}
	}
	
	quit "over"
}

ClassMethod GetDrugSummaryInfo(opsId, ByRef summaryCodeList, ByRef totalInfo) As %String
{
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set drugDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindDrugDatas",recordSheetId,"N")
	for i=1:1:(drugDatas.Size)
	{
		set drugData = drugDatas.GetAt(i)
		continue:drugData=""
		set dataItemId = drugData.GetValue("DataItem")
		set rowId = drugData.GetValue("RowId")
		continue:'$d(summaryCodeList(dataItemId))
	
		set sumQty=##class(CIS.AN.BL.AnaestRecord).CalcDrugSumQty(rowId)
		
		set totalInfo("DataItem",dataItemId,"Qty")=$g(totalInfo("DataItem",dataItemId,"Qty"))+sumQty
		set totalInfo("DataItem",dataItemId)=summaryCodeList(dataItemId)
		
		set summaryCode=""
		for
		{
			set summaryCode=$o(summaryCodeList(dataItemId,summaryCode))
			quit:summaryCode=""
			
			set totalInfo("Category",summaryCode,"Qty")=$g(totalInfo("Category",summaryCode,"Qty"))+sumQty
			if '$d(totalInfo("Category",summaryCode,"OPS",opsId)) 
			{
				set totalInfo("Category",summaryCode,"Count")=$g(totalInfo("Category",summaryCode,"Count"))+1
			}
			set totalInfo("Category",summaryCode,"OPS",opsId)=""
		}
	}
	
	quit "over"
}

/// Creator：      	雍阳
/// CreatDate：    	2020-04-05
/// Description： 	恢复室日报
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindAnaestEvaluation","2018-12-04","2018-12-04","")
Query PACUDaily(startDate As %String, endDate As %String, andocId As %String) As %Query(ROWSPEC = "OutRoomException,PACUSignUserName,RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc") [ SqlProc ]
{
}

ClassMethod PACUDailyExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, andocId As %String) As %Status
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
	
	for date=startDateH:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anaSupervisor=anaesthesia.AnaExpert
			set anesthesiologist=anaesthesia.Anesthesiologist
			set anaAssistants=anaesthesia.AnaAssistant
			set statusCode=operSchedule.Status.Code
			
			continue:(anesthesiologist="")&&(anaSupervisor="")
			continue:(andocId'="")&&(anesthesiologist'=andocId)&&(anaSupervisor'=andocId)&&((","_anaAssistants_",")'[(","_andocId_","))
			continue:anaesthesia.AnaStartDT=""  //无麻醉开始时间不计算
			continue:anaesthesia.TheatreOutTransLoc'="PACU"  //离室未转入PACU的不输出
			
			set moduleCode="PACURecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
			continue:recordSheetId=""
			
			set outRoomException=anaesthesia.OutRoomExceptionalCase
			
			set signId=##class(CIS.AN.BL.Signature).GetSignId(recordSheetId,"AnaDoctorSign")
			set signUserName=""
			
			if signId'=""
			{
				set signature=##class(CIS.AN.Signature).%OpenId(signId)
				set signUserName=signature.SignUser.FullName
			}
			
			do OutputRow
		}	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(outRoomException,signUserName)_..GetOperSchedule(opsId)
	s ind=ind+1
	q
}

ClassMethod PACUDailyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PACUDailyExecute ]
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

ClassMethod PACUDailyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PACUDailyExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	元琳
/// CreatDate：    	2020-04-22
/// Description： 	质控统计
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindQualityControlStat","2020-04-01","2020-04-30")
Query FindQualityControlStat(startDate As %String, endDate As %String) As %Query(ROWSPEC = "Date,ANPersentage,ANIN,ANOUT,IntraspinalDelivery,ANPatientRatio,ANPatientRatioGB,ASAI,ASAII,ASAIII,ASAIV,ASAV,ASANone,EmergencyRatio,IntraspinalAnesthesia,IntubationAnesthesia,NonIntubationAnesthesia,CompoundAnesthesia,OtherAnesthesia,OPCancelled,PACUTransferDelay,PACUHypothermia,ICUUnplanned,UnplannedSecondaryIntubation,DeathWithin24H,CardiacArrestWithin24H,IntraoperativeAutotransfusion,SevereAnaphylaxis,CentralVenipuncture,NeurologicalComplications,IntubationComplication,NewComaIncidence") [ SqlProc ]
{
}

ClassMethod FindQualityControlStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set operCount=0
	set EmergencyRatioPersentage=0,OPCancelledPersentage=0,UnplannedSecondaryIntubationPersentage=0,CardiacArrestWithin24HPersentage=0,SevereAnaphylaxisPersentage=0,CentralVenipuncturePersentage=0,NeurologicalComplicationsPersentage=0,IntubationComplicationPersentage=0
	set ASAI=0,ASAII=0,ASAIII=0,ASAIV=0,ASAV=0,ASANone=0
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
			set RecordSheet="",value=""
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""

			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			
			//continue:anaesthesia.OperFinishDT=""  //无手术结束时间不计算
			set operCount=operCount+1
			
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	        set AnaStartDT=anaestObj.GetValue("AnaStartDT")				// 麻醉开始时间
	        if AnaStartDT'=""                                           // 有麻醉时间认为做了麻醉监护
	        {
				set statList("Total","ANIN","Qty")=$g(statList("Total","ANIN","Qty"))+1
				set statList("Date",date,"ANIN","Qty")=$g(statList("Date",date,"ANIN","Qty"))+1
	        }
			set asaClassId=anaestObj.GetValue("ASAClass")
			set asaClassDesc=anaestObj.GetValue("ASAClassDesc")
			if asaClassDesc'=""
			{
				set asaClassCode=$$GetASACode(asaClassDesc)
				set statList("Total",asaClassCode,"Qty")=$g(statList("Total",asaClassCode,"Qty"))+1
				set statList("Date",date,asaClassCode,"Qty")=$g(statList("Date",date,asaClassCode,"Qty"))+1
			}
			else
			{
				set asaClassDesc="无"
				set asaClassCode="None"
				set statList("Total",asaClassCode,"Qty")=$g(statList("Total",asaClassCode,"Qty"))+1
				set statList("Date",date,asaClassCode,"Qty")=$g(statList("Date",date,asaClassCode,"Qty"))+1
			}
			if operSchedule.SourceType="E"
			{
				set statList("Total","EM","Qty")=$g(statList("Total","EM","Qty"))+1
				set statList("Date",date,"EM","Qty")=$g(statList("Date",date,"EM","Qty"))+1
			}
			/*
			if anaesthesia.AnaMethod'=""
			{
				set AnaMethodId=anaesthesia.AnaMethod.%Id()
				set AnaMethodDesc=anaesthesia.AnaMethod.Description
				set AnaType=anaesthesia.AnaMethod.AnaType.Description
				set statList("Total",AnaType,"Qty")=$g(statList("Total",AnaType,"Qty"))+1
				set statList("Date",date,AnaType,"Qty")=$g(statList("Date",date,AnaType,"Qty"))+1
			}
			else
			{
				set AnaMethodId="-"
				set AnaMethodDesc="其他麻醉"
				set statList("Total",AnaMethodDesc,"Qty")=$g(statList("Total",AnaMethodDesc,"Qty"))+1
				set statList("Date",date,AnaMethodDesc,"Qty")=$g(statList("Date",date,AnaMethodDesc,"Qty"))+1
			}
			*/
			//麻醉开始后手术取消率
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=102)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem="NotOperAfterAn")
			if value="是"
			{
				set statList("Total","NotOperAfterAn","Qty")=$g(statList("Total","NotOperAfterAn","Qty"))+1
				set statList("Date",date,"NotOperAfterAn","Qty")=$g(statList("Date",date,"NotOperAfterAn","Qty"))+1
			}
			//非其他预期的相关事件
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=102)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem="NoExpectedEvent")
			if value["非计划二次气管插管"
			{
				set statList("Total","NoExpectedEventCHK1","Qty")=$g(statList("Total","NoExpectedEventCHK1","Qty"))+1
				set statList("Date",date,"NoExpectedEventCHK1","Qty")=$g(statList("Date",date,"NoExpectedEventCHK1","Qty"))+1
			}
			if value["心跳骤停"
			{
				set statList("Total","NoExpectedEventCHK2","Qty")=$g(statList("Total","NoExpectedEventCHK2","Qty"))+1
				set statList("Date",date,"NoExpectedEventCHK2","Qty")=$g(statList("Date",date,"NoExpectedEventCHK2","Qty"))+1
			}
			//麻醉期间严重过敏反应发生率
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=102)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem="AllergicReaction")
			if value="是"
			{
				set statList("Total","AllergicReactionCHK1","Qty")=$g(statList("Total","AllergicReactionCHK1","Qty"))+1
				set statList("Date",date,"AllergicReactionCHK1","Qty")=$g(statList("Date",date,"AllergicReactionCHK1","Qty"))+1
			}
			//中心静脉穿刺严重并发症发生率
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=102)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem="CentralVenipunctureText")
			if value'=""
			{
				set statList("Total","CentralVenipunctureText","Qty")=$g(statList("Total","CentralVenipunctureText","Qty"))+1
				set statList("Date",date,"CentralVenipunctureText","Qty")=$g(statList("Date",date,"CentralVenipunctureText","Qty"))+1
			}
			//椎管内麻醉后严重神经并发症发生率
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=102)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem="SpinalAnMethod")
			if value["并发症"
			{
				set statList("Total","SpinalAnMethod","Qty")=$g(statList("Total","SpinalAnMethod","Qty"))+1
				set statList("Date",date,"SpinalAnMethod","Qty")=$g(statList("Date",date,"SpinalAnMethod","Qty"))+1
			}
			//全麻气管插管拔管后声音嘶哑发生率
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=102)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem="IntubationComplication")
			if value'=""
			{
				set statList("Total","IntubationComplication","Qty")=$g(statList("Total","IntubationComplication","Qty"))+1
				set statList("Date",date,"IntubationComplication","Qty")=$g(statList("Date",date,"IntubationComplication","Qty"))+1
			}
		}	
	}
	b
	set DateStr="总计"
	set ANPersentage=0                                           //手术室外麻醉为0,内外比无法统计
	set ANIN=+$g(statList("Total","ANIN","Qty"))
	set ANOUT=0                                                  //手术室外麻醉无法统计
	set IntraspinalDelivery=0                                    //椎管内分娩镇痛比例无法统计
	set ASAISUM=+$g(statList("Total","ASAI","Qty"))
	set ASAIISUM=+$g(statList("Total","ASAII","Qty"))
	set ASAIIISUM=+$g(statList("Total","ASAIII","Qty"))
	set ASAIVSUM=+$g(statList("Total","ASAIV","Qty"))
	set ASAVSUM=+$g(statList("Total","ASAV","Qty"))
	set ASANoneSUM=+$g(statList("Total","None","Qty"))
	set ASASUM=ASAISUM+ASAIISUM+ASAIIISUM+ASAIVSUM+ASAVSUM+ASANoneSUM
	if +ASASUM'=0
	{
		set ASAIPersentage=ASAISUM/ASASUM*100
		set ASAIPersentage=$fn(ASAIPersentage,"",2)
		set ASAIIPersentage=ASAIISUM/ASASUM*100
		set ASAIIPersentage=$fn(ASAIIPersentage,"",2)
		set ASAIIIPersentage=ASAIIISUM/ASASUM*100
		set ASAIIIPersentage=$fn(ASAIIIPersentage,"",2)
		set ASAIVPersentage=ASAIVSUM/ASASUM*100
		set ASAIVPersentage=$fn(ASAIVPersentage,"",2)
		set ASAVPersentage=ASAVSUM/ASASUM*100
		set ASAVPersentage=$fn(ASAVPersentage,"",2)
		set ASANonePersentage=ASANoneSUM/ASASUM*100
		set ASANonePersentage=$fn(ASANonePersentage,"",2)
		set ASAI=ASAISUM_"("_ASAIPersentage_"%"_")"
		set ASAII=ASAIISUM_"("_ASAIIPersentage_"%"_")"
		set ASAIII=ASAIIISUM_"("_ASAIIIPersentage_"%"_")"
		set ASAIV=ASAIVSUM_"("_ASAIVPersentage_"%"_")"
		set ASAV=ASAVSUM_"("_ASAVPersentage_"%"_")"
		set ASANone=ASANoneSUM_"("_ASANonePersentage_"%"_")"
	}
	set EmergencyRatioSUM=+$g(statList("Total","EM","Qty"))
	if operCount'=0 set EmergencyRatioPersentage=EmergencyRatioSUM/operCount*100
	set EmergencyRatioPersentage=$fn(EmergencyRatioPersentage,"",2)
	set EmergencyRatio=EmergencyRatioSUM_"("_EmergencyRatioPersentage_"%"_")"
	set IntraspinalAnesthesiaSUM=+$g(statList("Total","稚管内麻醉","Qty")) //椎管内麻醉
	set IntubationAnesthesiaSUM=+$g(statList("Total","全身麻醉","Qty")) //插管(喉罩)全麻
	set NonIntubationAnesthesiaSUM=+$g(statList("Total","面罩全身麻醉","Qty")) //非插管全麻
	set CompoundAnesthesiaSUM=+$g(statList("Total","复合麻醉","Qty")) //复合麻醉
	set OtherAnesthesiaSUM=+$g(statList("Total","其他麻醉","Qty")) //其他麻醉方式 神经阻滞
	set ANMethodSUM=IntraspinalAnesthesiaSUM+IntubationAnesthesiaSUM+NonIntubationAnesthesiaSUM+CompoundAnesthesiaSUM+OtherAnesthesiaSUM
	if +ANMethodSUM'=0
	{
		set IntraspinalAnesthesiaPersentage=IntraspinalAnesthesiaSUM/ANMethodSUM*100
		set IntraspinalAnesthesiaPersentage=$fn(IntraspinalAnesthesiaPersentage,"",2)
		set IntubationAnesthesiaPersentage=IntubationAnesthesiaSUM/ANMethodSUM*100
		set IntubationAnesthesiaPersentage=$fn(IntubationAnesthesiaPersentage,"",2)
		set NonIntubationAnesthesiaPersentage=NonIntubationAnesthesiaSUM/ANMethodSUM*100
		set NonIntubationAnesthesiaPersentage=$fn(NonIntubationAnesthesiaPersentage,"",2)
		set CompoundAnesthesiaPersentage=CompoundAnesthesiaSUM/ANMethodSUM*100
		set CompoundAnesthesiaPersentage=$fn(CompoundAnesthesiaPersentage,"",2)
		set OtherAnesthesiaPersentage=OtherAnesthesiaSUM/ANMethodSUM*100
		set OtherAnesthesiaPersentage=$fn(OtherAnesthesiaPersentage,"",2)
		set IntraspinalAnesthesia=IntraspinalAnesthesiaSUM_"("_IntraspinalAnesthesiaPersentage_"%"_")"
		set IntubationAnesthesia=IntubationAnesthesiaSUM_"("_IntubationAnesthesiaPersentage_"%"_")"
		set NonIntubationAnesthesia=NonIntubationAnesthesiaSUM_"("_NonIntubationAnesthesiaPersentage_"%"_")"
		set CompoundAnesthesia=CompoundAnesthesiaSUM_"("_CompoundAnesthesiaPersentage_"%"_")"
		set OtherAnesthesia=OtherAnesthesiaSUM_"("_OtherAnesthesiaPersentage_"%"_")"
	}
	set OPCancelledSUM=+$g(statList("Total","NotOperAfterAn","Qty")) //麻醉开始后手术取消率
	if operCount'=0 set OPCancelledPersentage=OPCancelledSUM/operCount*100
	set OPCancelledPersentage=$fn(OPCancelledPersentage,"",2)
	set OPCancelled=OPCancelledSUM_"("_OPCancelledPersentage_"%"_")"
	set ICUUnplanned=0                                            //非计划转入ICU率无法统计
	set UnplannedSecondaryIntubationSUM=+$g(statList("Total","NoExpectedEventCHK1","Qty")) //非计划二次气管插管率
	if operCount'=0 set UnplannedSecondaryIntubationPersentage=UnplannedSecondaryIntubationSUM/operCount*100
	set UnplannedSecondaryIntubationPersentage=$fn(UnplannedSecondaryIntubationPersentage,"",2)
	set UnplannedSecondaryIntubation=UnplannedSecondaryIntubationSUM_"("_UnplannedSecondaryIntubationPersentage_"%"_")"
	set CardiacArrestWithin24HSUM=+$g(statList("Total","NoExpectedEventCHK2","Qty")) //麻醉开始后24小时内心跳骤停率
	if operCount'=0 set CardiacArrestWithin24HPersentage=CardiacArrestWithin24HSUM/operCount*100
	set CardiacArrestWithin24HPersentage=$fn(CardiacArrestWithin24HPersentage,"",2)
	set CardiacArrestWithin24H=CardiacArrestWithin24HSUM_"("_CardiacArrestWithin24HPersentage_"%"_")"
	set SevereAnaphylaxisSUM=+$g(statList("Total","AllergicReactionCHK1","Qty")) //麻醉期间严重过敏反应发生率
	if operCount'=0 set SevereAnaphylaxisPersentage=SevereAnaphylaxisSUM/operCount*100
	set SevereAnaphylaxisPersentage=$fn(SevereAnaphylaxisPersentage,"",2)
	set SevereAnaphylaxis=SevereAnaphylaxisSUM_"("_SevereAnaphylaxisPersentage_"%"_")"
	set CentralVenipunctureSUM=+$g(statList("Total","CentralVenipunctureText","Qty")) //中心静脉穿刺严重并发症发生率
	if operCount'=0 set CentralVenipuncturePersentage=CentralVenipunctureSUM/operCount*100
	set CentralVenipuncturePersentage=$fn(CentralVenipuncturePersentage,"",2)
	set CentralVenipuncture=CentralVenipunctureSUM_"("_CentralVenipuncturePersentage_"%"_")"
	set NeurologicalComplicationsSUM=+$g(statList("Total","SpinalAnMethod","Qty")) //椎管内麻醉后严重神经并发症发生率
	if operCount'=0 set NeurologicalComplicationsPersentage=NeurologicalComplicationsSUM/operCount*100
	set NeurologicalComplicationsPersentage=$fn(NeurologicalComplicationsPersentage,"",2)
	set NeurologicalComplications=NeurologicalComplicationsSUM_"("_NeurologicalComplicationsPersentage_"%"_")"
	set IntubationComplicationSUM=+$g(statList("Total","IntubationComplication","Qty")) //全麻气管插管拔管后声音嘶哑发生率
	if operCount'=0 set IntubationComplicationPersentage=IntubationComplicationSUM/operCount*100
	set IntubationComplicationPersentage=$fn(IntubationComplicationPersentage,"",2)
	set IntubationComplication=IntubationComplicationSUM_"("_IntubationComplicationPersentage_"%"_")"
	do OutputRow
	
	set date=""
	for
	{
		set date=$o(statList("Date",date),-1)
		quit:date=""
		
		set DateStr=$zd(date,3)
		set ANPersentage=0                                                     //手术室外麻醉为0,内外比无法统计
		set ANIN=+$g(statList("Date",date,"ANIN","Qty"))
	    set ANOUT=0                                                            //手术室外麻醉无法统计
	    set IntraspinalDelivery=0                                              //椎管内分娩镇痛比例无法统计
		set ASAI=+$g(statList("Date",date,"ASAI","Qty"))
		set ASAII=+$g(statList("Date",date,"ASAII","Qty"))
		set ASAIII=+$g(statList("Date",date,"ASAIII","Qty"))
		set ASAIV=+$g(statList("Date",date,"ASAIV","Qty"))
		set ASAV=+$g(statList("Date",date,"ASAV","Qty"))
		set ASANone=+$g(statList("Date",date,"None","Qty"))
		set EmergencyRatio=+$g(statList("Date",date,"EM","Qty"))
	    set IntraspinalAnesthesia=+$g(statList("Date",date,"稚管内麻醉","Qty")) //椎管内麻醉
	    set IntubationAnesthesia=+$g(statList("Date",date,"全身麻醉","Qty")) //插管(喉罩)全麻
	    set NonIntubationAnesthesia=+$g(statList("Date",date,"面罩全身麻醉","Qty")) //非插管全麻
	    set CompoundAnesthesia=+$g(statList("Date",date,"复合麻醉","Qty")) //复合麻醉
	    set OtherAnesthesia=+$g(statList("Date",date,"其他麻醉","Qty")) //其他麻醉方式
	    set OPCancelled=+$g(statList("Date",date,"NotOperAfterAn","Qty")) //麻醉开始后手术取消率
	    set ICUUnplanned=0                                                //非计划转入ICU率无法统计
	    set UnplannedSecondaryIntubation=+$g(statList("Date",date,"NoExpectedEventCHK1","Qty")) //非计划二次气管插管率
	    set CardiacArrestWithin24H=+$g(statList("Date",date,"NoExpectedEventCHK2","Qty")) //麻醉开始后24小时内心跳骤停率
	    set SevereAnaphylaxis=+$g(statList("Date",date,"AllergicReactionCHK1","Qty")) //麻醉期间严重过敏反应发生率
	    set CentralVenipuncture=+$g(statList("Date",date,"CentralVenipunctureText","Qty")) //中心静脉穿刺严重并发症发生率
	    set NeurologicalComplications=+$g(statList("Date",date,"SpinalAnMethod","Qty")) //椎管内麻醉后严重神经并发症发生率
	    set IntubationComplication=+$g(statList("Date",date,"IntubationComplication","Qty")) //全麻气管插管拔管后声音嘶哑发生率
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

GetASACode(desc)
	set code = $s(desc["Ⅰ":"ASAI",desc["Ⅱ":"ASAII",desc["Ⅲ":"ASAIII",desc["Ⅳ":"ASAIV",desc["Ⅴ":"ASAV",1:"None")
	quit code
	
OutputRow
	set Total=ASAI+ASAII+ASAIII+ASAIV+ASAV+ASANone
	set ^CacheTemp(repid,ind)=$lb(DateStr,ANPersentage,ANIN,ANOUT,IntraspinalDelivery,ANPatientRatio,ANPatientRatioGB,ASAI,ASAII,ASAIII,ASAIV,ASAV,ASANone,EmergencyRatio,IntraspinalAnesthesia,IntubationAnesthesia,NonIntubationAnesthesia,CompoundAnesthesia,OtherAnesthesia,OPCancelled,PACUTransferDelay,PACUHypothermia,ICUUnplanned,UnplannedSecondaryIntubation,DeathWithin24H,CardiacArrestWithin24H,IntraoperativeAutotransfusion,SevereAnaphylaxis,CentralVenipuncture,NeurologicalComplications,IntubationComplication,NewComaIncidence)
	set ind=ind+1
	q
}

ClassMethod FindQualityControlStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualityControlStatExecute ]
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

ClassMethod FindQualityControlStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualityControlStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	元琳
/// CreatDate：    	2020-07-15
/// Description： 	手术例数统计(急诊/择期/日间)
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.手术类型
/// d ##class(CIS.AN.BL.AnaesthesiaStatistic).GetStatusNum("2020-06-01","2020-06-30","")
ClassMethod GetStatusNum(stdate As %String, enddate As %String, type As %String) As %String
{
	set Num=0
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(stdate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(enddate,"")
	quit:(startDateH>endDateH) 0
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			if operSchedule.SourceType=type set Num=Num+1
		}
	}
	quit Num
}

/// Creator：      	元琳
/// CreatDate：    	2020-07-22
/// Description： 	按手术级别统计手术例数
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.手术类型，4.手术级别
/// d ##class(CIS.AN.BL.AnaesthesiaStatistic).GetOpClassNum("2020-06-01","2020-06-30","","")
ClassMethod GetOpClassNum(stdate As %String, enddate As %String, type As %String, opclass As %String) As %String
{
	set Num=0
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(stdate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(enddate,"")
	quit:(startDateH>endDateH) 0
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set optype=operSchedule.SourceType
			set operInfo=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
			for i=1:1:operInfo.Size
			{
				set operObj=operInfo.GetAt(i)
				set OperClass=operObj.GetValue("OperClass")
				set OperClassDesc=operObj.GetValue("OperClassDesc")
				if ((optype=type)&&(OperClassDesc=opclass)) set Num=Num+1
			}
		}
	}
	quit Num
}

/// Creator：      	元琳
/// CreatDate：    	2020-07-22
/// Description： 	手术例数明细
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.手术类型，4.手术级别
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindOperationList","2020-06-01","2020-06-30","")
Query FindOperationList(startDate As %String, endDate As %String, type As %String = "", opclass As %String = "", asa As %String = "") As %Query(ROWSPEC = "StatusColor,StatusDesc,SourceType,SourceTypeDesc,OperDate,RoomDesc,OperSeq,PatName,PatGender,PatAge,PatDeptDesc,PrevDiagnosis,OperDesc,OperClassDesc,PlanSurgeonDesc,AnaMethodDesc,AnesthesiologistDesc,ASAClassDesc") [ SqlProc ]
{
}

ClassMethod FindOperationListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, opclass As %String, asa As %String) As %Status
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
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set StatusColor=operSchedule.Status.BGColor
			set StatusDesc=operSchedule.Status.Description
			set SourceType=operSchedule.SourceType
			set SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
	        set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
			if (operSchedule.OperRoom'="")
			{
				set RoomDesc=operSchedule.OperRoom.Description
			}
			set OperSeq=operSchedule.OperSeq
			set EpisodeID=operSchedule.EpisodeID
			set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
			set PatName=patInfoObj.GetValue("PatName")
			set PatGender=patInfoObj.GetValue("PatGender")
			set PatAge=patInfoObj.GetValue("PatAge")
			set PatDeptID=operSchedule.PatDeptID
			set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
			set PrevDiagnosis=$tr(operSchedule.PrevDiagnosis,$c(4),"")
	        set PrevDiagnosis=##class(CIS.AN.BL.OperSchedule).GetDiagnosisDesc(PrevDiagnosis)
			set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)
			set OperDesc=operData(1,"OperationDesc")
	        set SurgeonDesc=operData(1,"SurgeonDesc")
			set operInfo=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
	        set OperClass="",OperClassDesc=""
	        for i=1:1:operInfo.Size
	        {
				set operObj=operInfo.GetAt(i)
				set OperClass=operObj.GetValue("OperClassDesc")
				set:(OperClassDesc'="") OperClassDesc=OperClassDesc_","
				set OperClassDesc=OperClassDesc_OperClass
			}
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			set AnaMethod=anaestObj.GetValue("AnaMethod")
			set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)	// 麻醉方法名称
	        set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")
	        set ASAClass=anaestObj.GetValue("ASAClass")
	        set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")
			continue:(type'="")&(type'=SourceType)
			continue:(opclass'="")&(opclass'="无级手术")&(OperClassDesc'[opclass)
			continue:(opclass="无级手术")&(OperClassDesc'="")
			continue:(asa'="")&(asa'="无")&(asa'=ASAClass)
			continue:(asa="无")&(ASAClass'="")
			do OutputRow
		}	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(StatusColor,StatusDesc,SourceType,SourceTypeDesc,OperDate,RoomDesc,OperSeq,PatName,PatGender,PatAge,PatDeptDesc,PrevDiagnosis,OperDesc,OperClassDesc,SurgeonDesc,AnaMethodDesc,AnesthesiologistDesc,ASAClassDesc)
	s ind=ind+1
	q
}

ClassMethod FindOperationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationListExecute ]
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

ClassMethod FindOperationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	元琳
/// CreatDate：    	2020-07-22
/// Description： 	按ASA分级统计麻醉例数
/// Table：        	CIS.AN.OperSchedule,CIS_AN.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.手术类型
/// d ##class(CIS.AN.BL.AnaesthesiaStatistic).GetASANum("2020-06-01","2020-06-30","")
ClassMethod GetASANum(stdate As %String, enddate As %String, asa As %String) As %String
{
	set Num=0
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(stdate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(enddate,"")
	quit:(startDateH>endDateH) 0
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			set ASAClass=anaestObj.GetValue("ASAClass")
			if ASAClass=asa set Num=Num+1
		}
	}
	quit Num
}

/// Creator：      	元琳
/// CreatDate：    	2020-08-12
/// Description： 	统计麻醉医生工作量
/// Table：        	CIS.AN.OperSchedule,CIS_AN.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocId:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindPersonWorkStat","2020-10-01","2020-10-08","")
Query FindPersonWorkStat(startDate As %String, endDate As %String, andocCode As %String = "", andocId As %String = "") As %Query(ROWSPEC = "AnaDoctorName,OperCount1,OperTime1,OperCount2,OperTime2,OperCount3,OperTime3,OperCount4,OperTime4,OperCount5,OperTime5,OperCount0,OperTime0,OperCountB,OperTimeB,OperCountE,OperTimeE,OperDetail") [ SqlProc ]
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
	
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set statusCode=operSchedule.Status.Code
			set OperDuration=operSchedule.OperDuration
			set SourceType=operSchedule.SourceType
			//continue:(statusCode'="RoomOut")&&(statusCode'="PACUIn")&&(statusCode'="Finish")
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			set ASAClass=anaestObj.GetValue("ASAClass")
	        set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anesthesiologist=""
			set anesthesiologist=anaesthesia.Anesthesiologist 
			continue:(andocId'="")&&(anesthesiologist'=andocId)
			
			continue:anesthesiologist=""
			if ASAClass'=""
			{
				set ASAClassCode=$$GetASACode(ASAClassDesc)
				set statList("Total",anesthesiologist,ASAClassCode)=$g(statList("Total",anesthesiologist,ASAClassCode))+1
				if OperDuration'="" set statList("OperDuration",anesthesiologist,ASAClassCode)=$g(statList("OperDuration",anesthesiologist,ASAClassCode))+OperDuration
			}
			else
			{
				set ASAClass="-"
				set ASAClassDesc="无"
				set ASAClassCode="None"
				set statList("Total",anesthesiologist,ASAClassCode)=$g(statList("Total",anesthesiologist,ASAClassCode))+1
				if OperDuration'="" set statList("OperDuration",anesthesiologist,ASAClassCode)=$g(statList("OperDuration",anesthesiologist,ASAClassCode))+OperDuration
			}
			set statList("Total",anesthesiologist,SourceType)=$g(statList("Total",anesthesiologist,SourceType))+1
			if OperDuration'="" set statList("OperDuration",anesthesiologist,SourceType)=$g(statList("OperDuration",anesthesiologist,SourceType))+OperDuration
		}
	}
	s Pre=0
	s ASAI="",ASAII="",ASAIII="",ASAIV="",ASAV="",ASA0=""
	s ASAIDuration="",ASAIIDuration="",ASAIIIDuration="",ASAIVDuration="",ASAVDuration="",ASA0Duration=""
	s OperCountB="",OperCountE="",DurationB="",DurationE=""
    s AnaDoctorId="" f  s AnaDoctorId=$o(statList("Total",AnaDoctorId)) q:AnaDoctorId=""  d
    .q:AnaDoctorId=Pre
    .s AnaDoctorName=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",AnaDoctorId)
    
	.s ASAI=$g(statList("Total",AnaDoctorId,"ASAI"))
	.i ASAI="" s ASAI=0
	.s ASAII=$g(statList("Total",AnaDoctorId,"ASAII"))
	.i ASAII="" s ASAII=0
	.s ASAIII=$g(statList("Total",AnaDoctorId,"ASAIII"))
	.i ASAIII="" s ASAIII=0
	.s ASAIV=$g(statList("Total",AnaDoctorId,"ASAIV"))
	.i ASAIV="" s ASAIV=0
	.s ASAV=$g(statList("Total",AnaDoctorId,"ASAV"))
	.i ASAV="" s ASAV=0
	.s ASA0=$g(statList("Total",AnaDoctorId,"None"))
	.i ASA0="" s ASA0=0
	
	.s ASAIDuration=$g(statList("OperDuration",AnaDoctorId,"ASAI"))
	.i ASAIDuration="" s ASAIDuration=0
	.s ASAIIDuration=$g(statList("OperDuration",AnaDoctorId,"ASAII"))
	.i ASAIIDuration="" s ASAIIDuration=0
	.s ASAIIIDuration=$g(statList("OperDuration",AnaDoctorId,"ASAIII"))
	.i ASAIIIDuration="" s ASAIIIDuration=0
	.s ASAIVDuration=$g(statList("OperDuration",AnaDoctorId,"ASAIV"))
	.i ASAIVDuration="" s ASAIVDuration=0
	.s ASAVDuration=$g(statList("OperDuration",AnaDoctorId,"ASAV"))
	.i ASAVDuration="" s ASAVDuration=0
	.s ASA0Duration=$g(statList("OperDuration",AnaDoctorId,"None"))
	.i ASA0Duration="" s ASA0Duration=0
	
	.s OperCountB=$g(statList("Total",AnaDoctorId,"B"))
	.i OperCountB="" s OperCountB=0
	.s OperCountE=$g(statList("Total",AnaDoctorId,"E"))
	.i OperCountE="" s OperCountE=0
	
	.s DurationB=$g(statList("OperDuration",AnaDoctorId,"B"))
	.i DurationB="" s DurationB=0
	.s DurationE=$g(statList("OperDuration",AnaDoctorId,"E"))
	.i DurationE="" s DurationE=0
    .s Pre=AnaDoctorId
	.do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetASACode(desc)
	set code = $s(desc["Ⅰ":"ASAI",desc["Ⅱ":"ASAII",desc["Ⅲ":"ASAIII",desc["Ⅳ":"ASAIV",desc["Ⅴ":"ASAV",1:"None")
	quit code
OutputRow
	set ^CacheTemp(repid,ind)=$lb(AnaDoctorName,ASAI,ASAIDuration,ASAII,ASAIIDuration,ASAIII,ASAIIIDuration,ASAIV,ASAIVDuration,ASAV,ASAVDuration,ASA0,ASA0Duration,OperCountB,DurationB,OperCountE,DurationE,"")
	set ind=ind+1
	quit
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

/// Creator：      	元琳
/// CreatDate：    	2020-09-22
/// Description： 	麻醉分级例数明细
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.手术类型，4.手术级别
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindOperationDetail","2020-09-01","2020-09-30","",2)
Query FindOperationDetail(startDate As %String, endDate As %String, type As %String = "", asa As %String = "", anDoc As %String = "", nursetype As %String = "", nurseId As %String = "") As %Query(ROWSPEC = "OpDate,PatName,Gender,Age,Loc,BedNo,RegNo,MedCare,OperDesc,OperClass,OpDoc,AnDoc,AnExpert,AnAssistant,AnNurse,AnMethod,ASA,AnDuration,CirNurse,ScrubNurse,OpDuration") [ SqlProc ]
{
}

ClassMethod FindOperationDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, asa As %String, anDoc As %String, nursetype As %String, nurseId As %String) As %Status
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
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set PatDeptID=operSchedule.PatDeptID
			set EpisodeID=operSchedule.EpisodeID
			set SourceType=operSchedule.SourceType
			set ScrubNurse=operSchedule.ScrubNurse
			set ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurse)
			set CircualNurse=operSchedule.CircualNurse
			set CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CircualNurse)	
			set OperDuration=operSchedule.OperDuration
			set PatBedID=operSchedule.PatBedID	
	        set PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
	        set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
			set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
			set PatName=patInfoObj.GetValue("PatName")
			set PatGender=patInfoObj.GetValue("PatGender")
			set PatAge=patInfoObj.GetValue("PatAge")
			set RegNo=patInfoObj.GetValue("RegNo")
	        set MedcareNo=patInfoObj.GetValue("MedcareNo")	
			set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
			set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)
			set OperDesc=operData(1,"OperationDesc")
	        set SurgeonDesc=operData(1,"SurgeonDesc")
			set operInfo=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
			set OperClass="",OperClassDesc=""
			for i=1:1:operInfo.Size
			{
				set operObj=operInfo.GetAt(i)
				set OperClass=operObj.GetValue("OperClassDesc")
				set:(OperClassDesc'="") OperClassDesc=OperClassDesc_","
				set OperClassDesc=OperClassDesc_OperClass
			}
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			set AnaMethod=anaestObj.GetValue("AnaMethod")
			set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)
	        set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")
	        continue:(anDoc'="")&(anDoc'=AnesthesiologistDesc)
	        set ASAClass=anaestObj.GetValue("ASAClass")
	        set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")
	        set AnaExpertDesc=anaestObj.GetValue("AnaExpertDesc")
	        set AnaAssistant=anaestObj.GetValue("AnaAssistant")
	        set AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaAssistant)
			set AnaMethod=anaestObj.GetValue("AnaMethod")
	        set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)	// 麻醉方法名称
	        
    		set AnaestID=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,0))   // 麻醉申请ID
	        set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(AnaestID)
	        if (anaesthesia'="")
	        {
		        set AnNurseID=anaesthesia.ArrAnaNurse
				set AnNurse=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnNurseID)	
		        set AnaStartDT=anaesthesia.AnaStartDT,AnaFinishDT=anaesthesia.AnaFinishDT
		        set AnDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(AnaStartDT,AnaFinishDT,"M")
		        set AnDuration=$fn(AnDuration/60,"",1)_"h"
	        }
	        continue:(type'="")&(type'=SourceType)
			continue:(asa'="")&(asa'="无")&(asa'=ASAClass)
			continue:(asa="无")&(ASAClass'="")
			continue:(nursetype="C")&(nurseId'="")&(nurseId'=CircualNurseDesc)
			continue:(nursetype="T")&(nurseId'="")&(nurseId'=ScrubNurseDesc)
			do OutputRow
		}	
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(OperDate,PatName,PatGender,PatAge,PatDeptDesc,PatBedCode,RegNo,MedcareNo,OperDesc,OperClassDesc,SurgeonDesc,AnesthesiologistDesc,AnaExpertDesc,AnaAssistantDesc,AnNurse,AnaMethodDesc,ASAClassDesc,AnDuration,CircualNurseDesc,ScrubNurseDesc,OperDuration)
	s ind=ind+1
	q
}

ClassMethod FindOperationDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationDetailExecute ]
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

ClassMethod FindOperationDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationDetailExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	元琳
/// CreatDate：    	2020-09-12
/// Description： 	统计手术护士工作量
/// Table：        	CIS.AN.OperSchedule,CIS_AN.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.nurseId:手术护士ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindNurseWorkStat","2022-06-01","2022-06-23","")
Query FindNurseWorkStat(startDate As %String, endDate As %String, locId As %String = "") As %Query(ROWSPEC = "NurseName,Circual1,Scrub1,Total1,Circual2,Scrub2,Total2,Circual3,Scrub3,Total3,Circual4,Scrub4,Total4,Circual5,Scrub5,Total5,CircualB,ScrubB,TotalB,CircualE,ScrubE,TotalE") [ SqlProc ]
{
}

ClassMethod FindNurseWorkStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locId As %String = "") As %Status
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
	set careProvSet=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindCareProvByLoc")
	set sc=careProvSet.Execute("",locId)
	while (careProvSet.%Next())
	{
		set NurseId=careProvSet.Get("RowId")
		set NurseName=careProvSet.Get("Description")
		set statList("Total","Nurse",NurseId)=NurseName
		for date=startDateH:1:endDateH
		{
			set opsId=0
			for
			{
				set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
				quit:(opsId="")
				set OperDuration=0
				set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
				set ScrubNurse=operSchedule.ScrubNurse
				set CircualNurse=operSchedule.CircualNurse
				set statusCode=operSchedule.Status.Code
				continue:statusCode'="Finish"
				set SourceType=operSchedule.SourceType
				
				set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
				set ASAClass=anaestObj.GetValue("ASAClass")
				set OperStartDT=anaestObj.GetValue("OperStartDT")
				set OperFinishDT=anaestObj.GetValue("OperFinishDT")
				if $p(OperStartDT," ",2)'="" s OperStartDT=$zth($p(OperStartDT," ",2),2)
				if $p(OperFinishDT," ",2)'="" s OperFinishDT=$zth($p(OperFinishDT," ",2),2)
				set OperDuration=$fn((OperFinishDT-OperStartDT)/3600,"",2)
				if (NurseId=ScrubNurse) do
				.set statList("Total","ScrubNurse",NurseId,+ASAClass)=$g(statList("Total","ScrubNurse",NurseId,+ASAClass))+1
				.set statList("Total","ScrubSourceType",NurseId,SourceType)=$g(statList("Total","ScrubSourceType",NurseId,SourceType))+1
				.if OperDuration'=0 set statList("OperDuration","ScrubNurse",NurseId,+ASAClass)=$g(statList("OperDuration","ScrubNurse",NurseId,+ASAClass))+OperDuration
				.if OperDuration'=0 set statList("OperDuration","ScrubSourceType",NurseId,SourceType)=$g(statList("OperDuration","ScrubSourceType",NurseId,SourceType))+OperDuration
				if (NurseId=CircualNurse) do
				.set statList("Total","CircualNurse",NurseId,+ASAClass)=$g(statList("Total","CircualNurse",NurseId,+ASAClass))+1
				.set statList("Total","CircualSourceType",NurseId,SourceType)=$g(statList("Total","CircualSourceType",NurseId,SourceType))+1
				.if OperDuration'=0 set statList("OperDuration","CircualNurse",NurseId,+ASAClass)=$g(statList("OperDuration","CircualNurse",NurseId,+ASAClass))+OperDuration
				.if OperDuration'=0 set statList("OperDuration","CircualSourceType",NurseId,SourceType)=$g(statList("OperDuration","CircualSourceType",NurseId,SourceType))+OperDuration
			}
		}
	}
	b ;2222
	s NurseDr="" f  s NurseDr=$o(statList("Total","Nurse",NurseDr)) q:NurseDr=""  d
    .s NurseDesc=$g(statList("Total","Nurse",NurseDr))
    .s CircualDuration1=+$g(statList("OperDuration","CircualNurse",NurseDr,1))
    .s CircualDuration2=+$g(statList("OperDuration","CircualNurse",NurseDr,2))
    .s CircualDuration3=+$g(statList("OperDuration","CircualNurse",NurseDr,3))
    .s CircualDuration4=+$g(statList("OperDuration","CircualNurse",NurseDr,4))
    .s CircualDuration5=+$g(statList("OperDuration","CircualNurse",NurseDr,5))
    .s Circual1=+$g(statList("Total","CircualNurse",NurseDr,1))_"/"_CircualDuration1_"h"
    .s Circual2=+$g(statList("Total","CircualNurse",NurseDr,2))_"/"_CircualDuration2_"h"
    .s Circual3=+$g(statList("Total","CircualNurse",NurseDr,3))_"/"_CircualDuration3_"h"
    .s Circual4=+$g(statList("Total","CircualNurse",NurseDr,4))_"/"_CircualDuration4_"h"
    .s Circual5=+$g(statList("Total","CircualNurse",NurseDr,5))_"/"_CircualDuration5_"h"
    .
    .s ScrubDuration1=+$g(statList("OperDuration","ScrubNurse",NurseDr,1))
    .s ScrubDuration2=+$g(statList("OperDuration","ScrubNurse",NurseDr,2))
    .s ScrubDuration3=+$g(statList("OperDuration","ScrubNurse",NurseDr,3))
    .s ScrubDuration4=+$g(statList("OperDuration","ScrubNurse",NurseDr,4))
    .s ScrubDuration5=+$g(statList("OperDuration","ScrubNurse",NurseDr,5))
    .s Scrub1=+$g(statList("Total","ScrubNurse",NurseDr,1))_"/"_ScrubDuration1_"h"
    .s Scrub2=+$g(statList("Total","ScrubNurse",NurseDr,2))_"/"_ScrubDuration2_"h"
    .s Scrub3=+$g(statList("Total","ScrubNurse",NurseDr,3))_"/"_ScrubDuration3_"h"
    .s Scrub4=+$g(statList("Total","ScrubNurse",NurseDr,4))_"/"_ScrubDuration4_"h"
    .s Scrub5=+$g(statList("Total","ScrubNurse",NurseDr,5))_"/"_ScrubDuration5_"h"
    .
    .s CircualDurationB=+$g(statList("OperDuration","CircualSourceType",NurseId,"B"))
    .s CircualDurationE=+$g(statList("OperDuration","CircualSourceType",NurseId,"E"))
    .s ScrubDurationB=+$g(statList("OperDuration","ScrubSourceType",NurseId,"B"))
    .s ScrubDurationE=+$g(statList("OperDuration","ScrubSourceType",NurseId,"E"))
    .s CircualB=+$g(statList("Total","CircualSourceType",NurseDr,"B"))_"/"_CircualDurationB_"h"
    .s CircualE=+$g(statList("Total","CircualSourceType",NurseDr,"E"))_"/"_CircualDurationE_"h"
    .s ScrubB=+$g(statList("Total","ScrubSourceType",NurseDr,"B"))_"/"_ScrubDurationB_"h"
    .s ScrubE=+$g(statList("Total","ScrubSourceType",NurseDr,"E"))_"/"_ScrubDurationE_"h"
	.
    .s Total1=$p(Circual1,"/",1)+$p(Scrub1,"/",1)
    .s TotalDuration1=CircualDuration1+ScrubDuration1
    .s Total1=Total1_"/"_TotalDuration1_"h"
    .s Total2=$p(Circual2,"/",1)+$p(Scrub2,"/",1)
    .s TotalDuration2=CircualDuration2+ScrubDuration2
    .s Total2=Total2_"/"_TotalDuration2_"h"
    .s Total3=$p(Circual3,"/",1)+$p(Scrub3,"/",1)
    .s TotalDuration3=CircualDuration3+ScrubDuration3
    .s Total3=Total3_"/"_TotalDuration3_"h"
    .s Total4=$p(Circual4,"/",1)+$p(Scrub4,"/",1)
    .s TotalDuration4=CircualDuration4+ScrubDuration4
    .s Total4=Total4_"/"_TotalDuration4_"h"
    .s Total5=$p(Circual5,"/",1)+$p(Scrub5,"/",1)
    .s TotalDuration5=CircualDuration5+ScrubDuration5
    .s Total5=Total5_"/"_TotalDuration5_"h"
    .s TotalB=$p(CircualB,"/",1)+$p(ScrubB,"/",1)
    .s TotalDurationB=CircualDurationB+ScrubDurationB
    .s TotalB=TotalB_"/"_TotalDurationB_"h"
    .s TotalE=$p(CircualE,"/",1)+$p(ScrubE,"/",1)
    .s TotalDurationE=CircualDurationE+ScrubDurationE
    .s TotalE=TotalE_"/"_TotalDurationE_"h"
	.do OutputRow
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set ^CacheTemp(repid,ind)=$lb(NurseDesc,Circual1,Scrub1,Total1,Circual2,Scrub2,Total2,Circual3,Scrub3,Total3,Circual4,Scrub4,Total4,Circual5,Scrub5,Total5,CircualB,ScrubB,TotalB,CircualE,ScrubE,TotalE)
	set ind=ind+1
	quit
}

ClassMethod FindNurseWorkStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseWorkStatExecute ]
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

ClassMethod FindNurseWorkStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseWorkStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindEmergencyOper","2020-10-01","2020-11-11","")
Query FindEmergencyOper(startDate As %String, endDate As %String, LocId As %String = "") As %Query(ROWSPEC = "loc,emergencyNum,proportion,LaterScheduledOperNum")
{
}

ClassMethod FindEmergencyOperExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, LocId As %String = "") As %Status
{
	
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
  	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set locId=0
	for 
	{
		set locId=$order(^CTLOC(locId))
		quit:(locId="")
		quit:(LocId'="")&&(LocId'=locId)
		set LocDesc=$P($g(^CTLOC(locId)),"^",2)
		s count=0,count1=0,proportions=0,count2=0
		set indexNode="OPDate"
		for date=startDateH:1:endDateH
		{
			set opsId=0
			for
			{
				set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
				quit:(opsId="")
				set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
				;set AppDeptID=operSchedule.AppDeptID
				;quit:(LocId'="")&&(LocId'=AppDeptID)
				set SourceType=operSchedule.SourceType				
				set SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
				if (SourceType'="") set count=count+1
				if (SourceType="E") set count1=count1+1    //急诊手术例数
				if (count'=0) set proportions=$fn(100*(count1/count),"",2)_"%"
				
				set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
				set OperStartDT=anaestObj.GetValue("OperStartDT")
				set OperDateTime=OperStartDT
				set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
				set DateFormat=$lg(^websys.ConfigurationD(1),10)
				if ((DateFormat="DMY")&&(OperDate'="")) set OperDate=$zd($zdh(OperDate,3),4)
				if (OperStartDT>OperDate) set count2=count2+1   //晚于预安排手术
	
			}	
		} 	
		
		d OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(LocDesc,count1,proportions,count2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindEmergencyOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEmergencyOperExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindEmergencyOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEmergencyOperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	李杰
/// CreatDate：    	2021年8月9日
/// Description： 	查询质控统计
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期, 3.anaDeptId:麻醉科室Id
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindOperQualityControl","2021-08-01","2021-08-31","114","14177")
Query FindOperQualityControl(startDate As %String, endDate As %String, anaDeptId As %String, userId As %String = "") As %Query(ROWSPEC = "SeqNo,OperQualityTitle,Count,CountCode,Total,TotalCode,Rate") [ SqlProc ]
{
}

ClassMethod FindOperQualityControlExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, anaDeptId As %String, userId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	

	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if ((startDateH>endDateH) || (userId=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}


	kill ^tmpFindOperQualityControl(userId)
	kill statList
	set indexNode="OPDate",operCount=0,pacuCount=0
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
			set anaDept=operSchedule.AnaDept
			set operDept=operSchedule.OperDeptID
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	        set AnaStartDT=anaestObj.GetValue("AnaStartDT")				// 麻醉开始时间
	        
	        set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc") //离开手术间后去向
	        set PACUInDT=anaestObj.GetValue("PACUInDT")
			set PACUOutDT=anaestObj.GetValue("PACUOutDT")
			
	        if ((PACUInDT'="") && (PACUOutDT'=""))  //入恢复室的
	        {
				set pacuCount=pacuCount+1
				set ^tmpFindOperQualityControl(userId, "pacuCount","Qty",opsId)=""
		    }
	        
	        set asaClassId=anaestObj.GetValue("ASAClass")
			set asaClassDesc=anaestObj.GetValue("ASAClassDesc")
			if asaClassDesc'=""
			{
				set asaClassCode=$$GetASACode(asaClassDesc)
				set statList("Total",asaClassCode,"Qty")=$g(statList("Total",asaClassCode,"Qty"))+1
				set ^tmpFindOperQualityControl(userId, asaClassCode,"Qty", opsId)=""
			}
			else
			{
				set asaClassDesc="无"
				set asaClassCode="None"
				set statList("Total",asaClassCode,"Qty")=$g(statList("Total",asaClassCode,"Qty"))+1
				set ^tmpFindOperQualityControl(userId, asaClassCode,"Qty", opsId)=""
			}
			if operSchedule.SourceType="E"
			{
				set statList("Total","EM","Qty")=$g(statList("Total","EM","Qty"))+1
				set ^tmpFindOperQualityControl(userId, "EM","Qty", opsId)=""
			}
			
			set AnaMethod=anaestObj.GetValue("AnaMethod")				// 麻醉方法ID
			set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)
			if (AnaMethod'="")
			{
				set AnaMethodCode=$piece(^ORC("ANMET",AnaMethod),"^",1)
				set AnaMethodDesc=$piece(^ORC("ANMET",AnaMethod),"^",2)
				set AnaTypeId=$piece(^ORC("ANMET",AnaMethod),"^",3)
				set AnaType=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestType","ANTYPEDesc",AnaTypeId)
				if (AnaType="稚管内麻醉") 
				{
					set statList("Total","稚管内麻醉","Qty")=$g(statList("Total","稚管内麻醉","Qty"))+1
					set ^tmpFindOperQualityControl(userId, "稚管内麻醉","Qty", opsId)=""
				}
				if (AnaMethodCode="41")
				{
					set statList("Total","插管（喉罩）全麻","Qty")=$g(statList("Total","插管（喉罩）全麻","Qty"))+1
					set ^tmpFindOperQualityControl(userId, "插管（喉罩）全麻","Qty", opsId)=""
				}
				if ((AnaMethodCode="11") || (AnaMethodCode="12") || (AnaMethodCode="13"))
				{
					set statList("Total","非插管全麻","Qty")=$g(statList("Total","非插管全麻","Qty"))+1
					set ^tmpFindOperQualityControl(userId, "非插管全麻","Qty", opsId)=""
				}
				if (AnaType="联合麻醉") 
				{
					set statList("Total","复合麻醉","Qty")=$g(statList("Total","复合麻醉","Qty"))+1
					set ^tmpFindOperQualityControl(userId, "复合麻醉","Qty", opsId)=""
				}
				if ((AnaType="局部麻醉") || (AnaType="周围神经阻滞麻醉")) 
				{
					set statList("Total","其他麻醉方式","Qty")=$g(statList("Total","其他麻醉方式","Qty"))+1
					set ^tmpFindOperQualityControl(userId, "其他麻醉方式","Qty", opsId)=""
				}
				if ((PACUInDT'="") && (PACUOutDT'=""))
				{
					if ((AnaMethodCode="41") || (AnaMethodCode="11") || (AnaMethodCode="12") || (AnaMethodCode="13"))
					{
						set statList("Total","PACU-全身麻醉","Qty")=$g(statList("Total","PACU-全身麻醉","Qty"))+1
						set ^tmpFindOperQualityControl(userId, "PACU-全身麻醉","Qty", opsId)=""
					}
					if ((AnaType="周围神经阻滞麻醉") || (AnaType="稚管内麻醉")) 
					{
						set statList("Total","PACU-区域阻滞麻醉","Qty")=$g(statList("Total","PACU-区域阻滞麻醉","Qty"))+1
						set ^tmpFindOperQualityControl(userId, "PACU-区域阻滞麻醉","Qty", opsId)=""
					}
					if ((AnaType="联合麻醉")) 
					{
						set statList("Total","PACU-联合麻醉","Qty")=$g(statList("Total","PACU-联合麻醉","Qty"))+1
						set ^tmpFindOperQualityControl(userId, "PACU-联合麻醉","Qty", opsId)=""
					}
					if ((AnaType="局部麻醉")) 
					{
						set statList("Total","PACU-其他麻醉","Qty")=$g(statList("Total","PACU-其他麻醉","Qty"))+1
						set ^tmpFindOperQualityControl(userId, "PACU-其他麻醉","Qty", opsId)=""
					}
				}
				
			}
			else
			{
				set AnaMethodId="-"
				set AnaMethodDesc="未填写麻醉方法"
				set statList("Total",AnaMethodDesc,"Qty")=$g(statList("Total",AnaMethodDesc,"Qty"))+1
			}
			
			if ((operDept="113") && (anaDept="114"))
			{ 
				set statList("Total","InOperRoomCount","Qty")=$g(statList("Total","InOperRoomCount","Qty"))+1
				set ^tmpFindOperQualityControl(userId, "InOperRoomCount","Qty", opsId)=""
			}
			else  
			{
				set statList("Total","OutOperRoomCount","Qty")=$g(statList("Total","OutOperRoomCount","Qty"))+1
				set ^tmpFindOperQualityControl(userId, "OutOperRoomCount","Qty", opsId)=""
			}
			
			//麻醉后手术取消率
			set:($$JudgeModuleDataValueByCode(opsId,152,"QualityControl1","麻醉后手术取消")="Y") statList("Total","OperCancelSUM","Qty")=$g(statList("Total","OperCancelSUM","Qty"))+1
			
			
			//麻醉后监测治疗室(PACU)转出延迟率
			set moduleId=151, dateItemCode="mingganzhibiao.zhuanchuyanchi"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["转出延迟(入室>3h)"
			{
				set statList("Total","PACUTransferDelaySUM","Qty")=$g(statList("Total","PACUTransferDelaySUM","Qty"))+1
			}
			
			//PACU入室后低体温
			set moduleId=151, dateItemCode="rushi.tiwen"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if (+value>0)&&(+value<36)
			{
				set statList("Total","InRoomLowTemperatureSum","Qty")=$g(statList("Total","InRoomLowTemperatureSum","Qty"))+1
			}
			
			//非计划转入ICU率
			set moduleId=152, dateItemCode="QualityControl3"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["非计划转入ICU"
			{
				set statList("Total","NonePlanInICUSUM","Qty")=$g(statList("Total","NonePlanInICUSUM","Qty"))+1
			}
			
			//非计划二次气管插管率
			set moduleId=152, dateItemCode="QualityControl4"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["非计划二次气管插管"
			{
				set statList("Total","NonePlanTwiceIntubeSum","Qty")=$g(statList("Total","NonePlanTwiceIntubeSum","Qty"))+1
			}
			
			//麻醉开始后24小时内死亡率
			set moduleId=152, dateItemCode="QualityControl6"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["麻醉后24小时内死亡"
			{
				set statList("Total","DeathAfterAnaest24HourSUM","Qty")=$g(statList("Total","DeathAfterAnaest24HourSUM","Qty"))+1
			}
			
			//麻醉开始后24小时内心脏骤停率
			set moduleId=152, dateItemCode="QualityControl5"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["麻醉开始后24小时内非医疗操作性心跳骤停"
			{
				set statList("Total","CardiacArrestAfterAnaest24HourSUM","Qty")=$g(statList("Total","CardiacArrestAfterAnaest24HourSUM","Qty"))+1
			}
			
			//麻醉期间严重过敏反应发生率
			set moduleId=152, dateItemCode="QualityControl7"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["麻醉期间严重过敏反应"
			{
				set statList("Total","SevereAllergicReactionSUM","Qty")=$g(statList("Total","SevereAllergicReactionSUM","Qty"))+1
			}
			
			//中心静脉穿刺严重并发症发生率
			set moduleId=152, dateItemCode="QualityControl8"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["中心静脉穿刺严重并发症"
			{
				set statList("Total","SevereCentralVenipunctureSUM","Qty")=$g(statList("Total","SevereCentralVenipunctureSUM","Qty"))+1
			}
			
			//椎管内麻醉后严重神经并发症发生率
			set moduleId=152, dateItemCode="QualityContro15"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["椎管内麻醉后严重神经并发症"
			{
				set statList("Total","ComplicatOfSpinalAnesthSUM","Qty")=$g(statList("Total","ComplicatOfSpinalAnesthSUM","Qty"))+1
			}
			
			//全麻气管插管拔管后声音嘶哑发生率
			set moduleId=152, dateItemCode="QualityControl10"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["全麻气管插管、拔管后声嘶"
			{
				set statList("Total","IntubeOuttubeHoarsenessSUM","Qty")=$g(statList("Total","IntubeOuttubeHoarsenessSUM","Qty"))+1
			}
			
			//麻醉后新发昏迷发生率
			set moduleId=152, dateItemCode="QualityContro111"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["麻醉后新发昏迷"
			{
				set statList("Total","PostAnaestComaSUM","Qty")=$g(statList("Total","PostAnaestComaSUM","Qty"))+1
			}
			
			//PACU运送患者意外事件发生率
			set moduleId=152, dateItemCode="QualityControl16"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["PACU运送患者意外事件发生"
			{
				set statList("Total","PACUTransPatientAccidentSUM","Qty")=$g(statList("Total","PACUTransPatientAccidentSUM","Qty"))+1
			}
			
			//PACU非计划引流管道拔出发生率
			set moduleId=152, dateItemCode="QualityControl17"
			set RecordSheet="",value=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
			if value["PACU非计划引流管道拔出发生"
			{
				set statList("Total","NonePlanDrainageTubeOutSUM","Qty")=$g(statList("Total","NonePlanDrainageTubeOutSUM","Qty"))+1
			}
			
			//PACU术后疼痛干预有效率
			set moduleId=151, dateItemCode1="rushi.tengtongzhishu", dateItemCode2="tengtongzhishu.chulicuoshi"
			set RecordSheet="",value1="", value2=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value1 from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode1)
			if RecordSheet'="" &sql(select DataValue into :value2 from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode2)
			if (+value1>4)
			{
				set statList("Total","PostOperPainInterfereSUM","Sum")=$g(statList("Total","PostOperPainInterfereSUM","Sum"))+1
				if (+value1>4 && value2'="")
				{
					if (value2'="不干预") set statList("Total","PostOperPainInterfereSUM","Qty")=$g(statList("Total","PostOperPainInterfereSUM","Qty"))+1
				}
			}
			
			//PACU术后低体温干预有效率
			set moduleId=151, dateItemCode1="rushi.tiwen", dateItemCode2="ditiwenchulicuoshi"
			set RecordSheet="",value1="", value2=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value1 from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode1)
			if RecordSheet'="" &sql(select DataValue into :value2 from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode2)
			if ((+value1<36) && (+value1>0))
			{
				set statList("Total","InPACULowTemperatureSUM","Sum")=$g(statList("Total","InPACULowTemperatureSUM","Sum"))+1
				if (+value1<36 && value2'="")
				{
					if (value2'="不干预") set statList("Total","InPACULowTemperatureSUM","Qty")=$g(statList("Total","InPACULowTemperatureSUM","Qty"))+1
				}
			}
			
			//PACU术后恶心呕吐干预有效率
			set moduleId=151, dateItemCode1="exinoutu.you", dateItemCode2="exinoutu.chuzhicuoshi"
			set RecordSheet="",value1="", value2=""
			&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
			if RecordSheet'="" &sql(select DataValue into :value1 from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode1)
			if RecordSheet'="" &sql(select DataValue into :value2 from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode2)
			if (value1["是")
			{
				set statList("Total","InPACUNauseaVomitingSUM","Sum")=$g(statList("Total","InPACUNauseaVomitingSUM","Sum"))+1
				if (value1["是" && value2'="")
				{
					if (value2'="不干预") set statList("Total","InPACUNauseaVomitingSUM","Qty")=$g(statList("Total","InPACUNauseaVomitingSUM","Qty"))+1
				}
			}
			
			set operCount=operCount+1
			set ^tmpFindOperQualityControl(userId, "operCount","Qty", opsId)=""
		}	
	}
	
	set CareProvCount=0
	set rset=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindCareProv")
	do rset.Execute("",anaDeptId)
	while (rset.Next()) 
	{
		set Description=rset.Get("Description")
		continue:Description="doctor"
		set CareProvCount=CareProvCount+1
	}
	
	//椎管内分娩镇痛率(GB) 无法统计
	set IntraspinalDeliveryCount=0
	set IntraspinalDeliveryTotal=+$g(statList("Total","稚管内麻醉","Qty"))
	
	//手术室内外麻醉比例
	set InOperRoomCount=+$g(statList("Total","InOperRoomCount","Qty"))
	set OutOperRoomCount=+$g(statList("Total","OutOperRoomCount","Qty"))
	
	set ASAI=+$g(statList("Total","ASAI","Qty"))
	set ASAII=+$g(statList("Total","ASAII","Qty"))
	set ASAIII=+$g(statList("Total","ASAIII","Qty"))
	set ASAIV=+$g(statList("Total","ASAIV","Qty"))
	set ASAV=+$g(statList("Total","ASAV","Qty"))
	set ASANone=+$g(statList("Total","None","Qty"))
	set emergencyOperCount=+$g(statList("Total","EM","Qty"))
	
	set IntraspinalAnesthesiaSUM=+$g(statList("Total","稚管内麻醉","Qty")) 
	set IntubationAnesthesiaSUM=+$g(statList("Total","插管（喉罩）全麻","Qty")) 
	set NonIntubationAnesthesiaSUM=+$g(statList("Total","非插管全麻","Qty")) 
	set CompoundAnesthesiaSUM=+$g(statList("Total","复合麻醉","Qty")) 
	set OtherAnesthesiaSUM=+$g(statList("Total","其他麻醉方式","Qty"))
	
	set PACUGeneralAnesthesiaSUM=+$g(statList("Total","PACU-全身麻醉","Qty"))
	set PACURegionalBlockAnesthesiaSUM=+$g(statList("Total","PACU-区域阻滞麻醉","Qty"))
	set PACUCombinedAnesthesiaSUM=+$g(statList("Total","PACU-联合麻醉","Qty"))
	set PACUOtherAnesthesiaSUM=+$g(statList("Total","PACU-其他麻醉","Qty"))
	
	set OperCancelSUM=+$g(statList("Total","OperCancelSUM","Qty"))  //麻醉后手术取消
	set InRoomLowTemperatureSum=+$g(statList("Total","InRoomLowTemperatureSum","Qty"))
	set NonePlanInICUSUM=+$g(statList("Total","NonePlanInICUSUM","Qty"))
	set NonePlanTwiceIntubeSum=+$g(statList("Total","NonePlanTwiceIntubeSum","Qty"))
	set DeathAfterAnaest24HourSUM=+$g(statList("Total","DeathAfterAnaest24HourSUM","Qty"))
	set PACUTransferDelaySUM=+$g(statList("Total","PACUTransferDelaySUM","Qty"))
	set CardiacArrestAfterAnaest24HourSUM=+$g(statList("Total","CardiacArrestAfterAnaest24HourSUM","Qty"))
	
	//术中自体血输注率  暂不知统计规则
	set SelfBloodTransfutionSUM=0
	
	set SevereAllergicReactionSUM=+$g(statList("Total","SevereAllergicReactionSUM","Qty"))
	set SevereCentralVenipunctureSUM=+$g(statList("Total","SevereCentralVenipunctureSUM","Qty"))
	
	//椎管内麻醉后严重神经并发症发生率 
	set ComplicatOfSpinalAnesthSUM=+$g(statList("Total","ComplicatOfSpinalAnesthSUM","Qty"))
	
	set IntubeOuttubeHoarsenessSUM=+$g(statList("Total","IntubeOuttubeHoarsenessSUM","Qty"))
	set PostAnaestComaSUM=+$g(statList("Total","PostAnaestComaSUM","Qty"))
	
	set PACUTransPatientAccidentSUM=+$g(statList("Total","PACUTransPatientAccidentSUM","Qty"))
	set NonePlanDrainageTubeOutSUM=+$g(statList("Total","NonePlanDrainageTubeOutSUM","Qty"))
	
	set PostOperPainInterfereSUM=+$g(statList("Total","PostOperPainInterfereSUM","Sum")), PostOperPainInterfereQty=+$g(statList("Total","PostOperPainInterfereSUM","Qty"))
	set InPACULowTemperatureSUM=+$g(statList("Total","InPACULowTemperatureSUM","Sum")), InPACULowTemperatureQty=+$g(statList("Total","InPACULowTemperatureSUM","Qty"))
	set InPACUNauseaVomitingSUM=+$g(statList("Total","InPACUNauseaVomitingSUM","Sum")), InPACUNauseaVomitingQty=+$g(statList("Total","InPACUNauseaVomitingSUM","Qty"))
	
	
	set SeqNo=1, OperQualityTitle="手术室内/外麻醉比例", Count="", CountCode="", Total="", TotalCode="", Rate=""
	do OutputRow
	
	set SeqNo=2, OperQualityTitle="&emsp;&emsp; 手术室内麻醉比例", Count=InOperRoomCount, CountCode="InOperRoomCount", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=3, OperQualityTitle="&emsp;&emsp; 手术室外麻醉比例", Count=OutOperRoomCount, CountCode="OutOperRoomCount", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=4, OperQualityTitle="椎管内分娩镇痛率(GB)", Count=IntraspinalDeliveryCount, CountCode="", Total=IntraspinalDeliveryTotal, TotalCode="稚管内麻醉", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=5, OperQualityTitle="麻醉科医患比(人均麻醉量)", Count=CareProvCount, CountCode="", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=6, OperQualityTitle="各ASA分级麻醉患者比例", Count="", CountCode="", Total="", TotalCode="", Rate=""
	do OutputRow
	
	set SeqNo=7, OperQualityTitle="&emsp;&emsp; I级", Count=ASAI, CountCode="ASAI", Total=ASAI+ASAII+ASAIII+ASAIV+ASAV+ASANone, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=8, OperQualityTitle="&emsp;&emsp; II级", Count=ASAII, CountCode="ASAII", Total=ASAI+ASAII+ASAIII+ASAIV+ASAV+ASANone, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=9, OperQualityTitle="&emsp;&emsp; III级", Count=ASAIII, CountCode="ASAIII", Total=ASAI+ASAII+ASAIII+ASAIV+ASAV+ASANone, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=10, OperQualityTitle="&emsp;&emsp; IV级", Count=ASAIV, CountCode="ASAIV", Total=ASAI+ASAII+ASAIII+ASAIV+ASAV+ASANone, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=11, OperQualityTitle="&emsp;&emsp; V级", Count=ASAV, CountCode="ASAV", Total=ASAI+ASAII+ASAIII+ASAIV+ASAV+ASANone, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=12, OperQualityTitle="&emsp;&emsp; 未定级", Count=ASANone, CountCode="None", Total=ASAI+ASAII+ASAIII+ASAIV+ASAV+ASANone, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=13, OperQualityTitle="急诊非择期麻醉比例", Count=emergencyOperCount, CountCode="EM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=14, OperQualityTitle="各类麻醉方法比例", Count="", CountCode="", Total="", TotalCode="", Rate=""
	do OutputRow
	
	set SeqNo=15, OperQualityTitle="&emsp;&emsp; 椎管内麻醉", Count=IntraspinalAnesthesiaSUM, CountCode="椎管内麻醉", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=16, OperQualityTitle="&emsp;&emsp; 插管(喉罩)全麻", Count=IntubationAnesthesiaSUM, CountCode="插管（喉罩）全麻", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=17, OperQualityTitle="&emsp;&emsp; 非插管全麻", Count=NonIntubationAnesthesiaSUM, CountCode="非插管全麻", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=18, OperQualityTitle="&emsp;&emsp; 复合麻醉", Count=CompoundAnesthesiaSUM, CountCode="复合麻醉", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=19, OperQualityTitle="&emsp;&emsp; 其他麻醉方式", Count=OtherAnesthesiaSUM, CountCode="其他麻醉方式", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=20, OperQualityTitle="麻醉后手术取消率", Count=OperCancelSUM, CountCode="OperCancelSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=21, OperQualityTitle="麻醉后监测治疗室(PACU)转出延迟率", Count=PACUTransferDelaySUM, CountCode="PACUTransferDelaySUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow

	set SeqNo=22, OperQualityTitle="PACU入室低体温", Count=InRoomLowTemperatureSum, CountCode="InRoomLowTemperatureSum", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=23, OperQualityTitle="非计划转入ICU率", Count=NonePlanInICUSUM, CountCode="NonePlanInICUSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=24, OperQualityTitle="非计划二次气管插管", Count=NonePlanTwiceIntubeSum, CountCode="NonePlanTwiceIntubeSum", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow

	set SeqNo=25, OperQualityTitle="麻醉开始后24小时内死亡率", Count=DeathAfterAnaest24HourSUM, CountCode="DeathAfterAnaest24HourSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=26, OperQualityTitle="麻醉开始后24小时内心跳骤停率", Count=CardiacArrestAfterAnaest24HourSUM, CountCode="CardiacArrestAfterAnaest24HourSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=27, OperQualityTitle="术中自体血输注率", Count=SelfBloodTransfutionSUM, CountCode="SelfBloodTransfutionSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=28, OperQualityTitle="麻醉期间严重过敏反应发生率", Count=SevereAllergicReactionSUM, CountCode="SevereAllergicReactionSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=29, OperQualityTitle="中心静脉穿刺严重并发症发生率", Count=SevereCentralVenipunctureSUM, CountCode="SevereCentralVenipunctureSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=30, OperQualityTitle="椎管内麻醉后严重神经并发症发生率", Count=ComplicatOfSpinalAnesthSUM, CountCode="ComplicatOfSpinalAnesthSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=31, OperQualityTitle="全麻气管插管拔管后声音嘶哑发生率", Count=IntubeOuttubeHoarsenessSUM, CountCode="IntubeOuttubeHoarsenessSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=32, OperQualityTitle="麻醉后新发昏迷发生率", Count=PostAnaestComaSUM, CountCode="PostAnaestComaSUM", Total=operCount, TotalCode="operCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=33, OperQualityTitle="PACU收治各类麻醉患者比率", Count="", CountCode="", Total="", TotalCode="", Rate=""
	do OutputRow
	
	set SeqNo=34, OperQualityTitle="&emsp;&emsp; PACU-全身麻醉患者比例", Count=PACUGeneralAnesthesiaSUM, CountCode="PACU-全身麻醉", Total=pacuCount, TotalCode="pacuCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=35, OperQualityTitle="&emsp;&emsp; PACU-区域阻滞麻醉患者比例", Count=PACURegionalBlockAnesthesiaSUM, CountCode="PACU-区域阻滞麻醉", Total=pacuCount, TotalCode="pacuCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=36, OperQualityTitle="&emsp;&emsp; PACU-联合麻醉患者比例", Count=PACUCombinedAnesthesiaSUM, CountCode="PACU-联合麻醉", Total=pacuCount, TotalCode="pacuCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=37, OperQualityTitle="&emsp;&emsp; PACU-其他麻醉患者比例", Count=PACUOtherAnesthesiaSUM, CountCode="PACU-其他麻醉", Total=pacuCount, TotalCode="pacuCount", Rate="0.00%"
	if (+Total>0) set Rate=$fn(Count/Total*100, "", 2)_"%"
	do OutputRow
	
	set SeqNo=38, OperQualityTitle="PACU运送患者意外事件发生率", Count=PACUTransPatientAccidentSUM, CountCode="", Total=pacuCount, TotalCode="pacuCount", Rate="0.00‰"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=39, OperQualityTitle="PACU非计划引流管道拔出发生率", Count=NonePlanDrainageTubeOutSUM, CountCode="", Total=pacuCount, TotalCode="pacuCount", Rate="0.00‰"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=40, OperQualityTitle="PACU术后疼痛干预有效率", Count=PostOperPainInterfereQty, CountCode="", Total=PostOperPainInterfereSUM, TotalCode="", Rate="0.00‰"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=41, OperQualityTitle="PACU术后低体温干预有效率", Count=InPACULowTemperatureQty, CountCode="", Total=InPACULowTemperatureSUM, TotalCode="", Rate="0.00‰"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	set SeqNo=42, OperQualityTitle="PACU术后恶心呕吐干预有效率", Count=InPACUNauseaVomitingQty, CountCode="", Total=InPACUNauseaVomitingSUM, TotalCode="", Rate="0.00‰"
	if (+Total>0) set Rate=$fn(Count/Total*1000, "", 2)_"‰"
	do OutputRow
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

GetASACode(desc)
	set code = $s(desc["Ⅰ":"ASAI",desc["Ⅱ":"ASAII",desc["Ⅲ":"ASAIII",desc["Ⅳ":"ASAIV",desc["Ⅴ":"ASAV",1:"None")
	quit code  
	
JudgeModuleDataValueByCode(opsId,moduleId,dataItemCode,targetValue)
	set result="N"
	set RecordSheet="",value=""
	&sql(select RowId into :RecordSheet from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule=:moduleId)
	if RecordSheet'="" &sql(select DataValue into :value from CIS_AN.OperData where RecordSheet=:RecordSheet and DataItem=:dateItemCode)
	if value[targetValue set result="Y" 
	quit result                
	
OutputRow
	s ^CacheTemp(repid,ind)=$lb(SeqNo,OperQualityTitle,Count,CountCode,Total,TotalCode,Rate)
	s ind=ind+1
	q
}

ClassMethod FindOperQualityControlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperQualityControlExecute ]
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

ClassMethod FindOperQualityControlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperQualityControlExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindOperStatDetail","14177","InOperRoomCount")
Query FindOperStatDetail(userId As %String, statCode As %String) As %Query(ROWSPEC = "OpsId,StatusDesc,StatusColor,SourceType,SourceTypeDesc,OperDate,PatName,PatGender,PatAge,PatDeptDesc,PatBedCode,RegNo,MedcareNo,OperDesc,OperClass,SurgeonDesc,AnesthesiologistDesc,AnaExpertDesc,AnaAssistantDesc,AnNurse,AnaMethodDesc,ASAClassDesc,CircualNurseDesc,ScrubNurseDesc,PACUInDT,PACUOutDT,OperDeptDesc,AnaDeptDesc") [ SqlProc ]
{
}

ClassMethod FindOperStatDetailExecute(ByRef qHandle As %Binary, userId As %String, statCode As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	if ((userId="") || (statCode=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	if ('$d(^tmpFindOperQualityControl(userId, statCode,"Qty")))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	set opsId=0
	for
	{
		set opsId=$order(^tmpFindOperQualityControl(userId, statCode,"Qty",opsId))
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set PatDeptID=operSchedule.PatDeptID
		set EpisodeID=operSchedule.EpisodeID
		set SourceType=operSchedule.SourceType
		set ScrubNurse=operSchedule.ScrubNurse
		set Status=operSchedule.Status.%Id()				// 手术状态ID
		set StatusDesc=operSchedule.Status.Description		// 手术状态名称
		set StatusColor=operSchedule.Status.BGColor
		set SourceType=operSchedule.SourceType				// 手术类型
		set SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
		set ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurse)
		set CircualNurse=operSchedule.CircualNurse
		set CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CircualNurse)	
		set OperDuration=operSchedule.OperDuration
		set PatBedID=operSchedule.PatBedID	
		set PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
		set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
		set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
		set PatName=patInfoObj.GetValue("PatName")
		set PatGender=patInfoObj.GetValue("PatGender")
		set PatAge=patInfoObj.GetValue("PatAge")
		set RegNo=patInfoObj.GetValue("RegNo")
		set MedcareNo=patInfoObj.GetValue("MedcareNo")	
		set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
		set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)
		set OperDesc=operData(1,"OperationDesc")
		set OperClass=""
		set SurgeonDesc=operData(1,"SurgeonDesc")
		set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
		set AnaMethod=anaestObj.GetValue("AnaMethod")
		set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)
		set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")
		set ASAClass=anaestObj.GetValue("ASAClass")
		set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")
		set AnaExpertDesc=anaestObj.GetValue("AnaExpertDesc")
		set AnaAssistant=anaestObj.GetValue("AnaAssistant")
		set AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaAssistant)
		set AnaMethod=anaestObj.GetValue("AnaMethod")
		set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)	// 麻醉方法名称
		set PACUInDT=anaestObj.GetValue("PACUInDT")
		set PACUOutDT=anaestObj.GetValue("PACUOutDT")
		set OperDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
		set AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
		do OutputRow
	}	
	
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
		
OutputRow
	s ^CacheTemp(repid,ind)=$lb(opsId,StatusDesc,StatusColor,SourceType,SourceTypeDesc,OperDate,PatName,PatGender,PatAge,PatDeptDesc,PatBedCode,RegNo,MedcareNo,OperDesc,OperClass,SurgeonDesc,AnesthesiologistDesc,AnaExpertDesc,AnaAssistantDesc,AnNurse,AnaMethodDesc,ASAClassDesc,CircualNurseDesc,ScrubNurseDesc,PACUInDT,PACUOutDT,OperDeptDesc,AnaDeptDesc)
	s ind=ind+1
	q
}

ClassMethod FindOperStatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperStatDetailExecute ]
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

ClassMethod FindOperStatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperStatDetailExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	元琳
/// CreatDate：    	2023-01-18
/// Description： 	手术例数统计(按手术状态/手术级别/麻醉分级)
/// Table：        	CIS.AN.OperSchedule,CIS_AN.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.手术类型
/// d ##class(CIS.AN.BL.AnaesthesiaStatistic).GetOperationDetail("2022-01-01","2022-01-20")
ClassMethod GetOperationDetail(stdate As %String, enddate As %String, hospId As %String = "") As %String
{
	// 按手术状态统计例数(急诊/择期)
    set retArr(1,"EMNumByStatus")=..GetStatusNum(stdate,enddate,"E")
    set retArr(1,"OPNumByStatus")=..GetStatusNum(stdate,enddate,"B")
    
	// 按手术级别统计例数(无极/一级/二级/三级/四级)
    set retArr(1,"EMNumOpClass")=..GetOpClassNum(stdate,enddate,"E","")
    set retArr(1,"EMNumOpClass1")=..GetOpClassNum(stdate,enddate,"E","一级手术")
    set retArr(1,"EMNumOpClass2")=..GetOpClassNum(stdate,enddate,"E","二级手术")
    set retArr(1,"EMNumOpClass3")=..GetOpClassNum(stdate,enddate,"E","三级手术")
    set retArr(1,"EMNumOpClass4")=..GetOpClassNum(stdate,enddate,"E","四级手术")
    
    set retArr(1,"OPNumOpClass")=..GetOpClassNum(stdate,enddate,"B","")
    set retArr(1,"OPNumOpClass1")=..GetOpClassNum(stdate,enddate,"B","一级手术")
    set retArr(1,"OPNumOpClass2")=..GetOpClassNum(stdate,enddate,"B","二级手术")
    set retArr(1,"OPNumOpClass3")=..GetOpClassNum(stdate,enddate,"B","三级手术")
    set retArr(1,"OPNumOpClass4")=..GetOpClassNum(stdate,enddate,"B","四级手术")
    
	// 按麻醉分级统计例数(无/一级/二级/三级/四级/五级)
    set retArr(1,"ASANum")=..GetASANum(stdate,enddate,"")
    set retArr(1,"ASANum1")=..GetASANum(stdate,enddate,"1")
    set retArr(1,"ASANum2")=..GetASANum(stdate,enddate,"2")
    set retArr(1,"ASANum3")=..GetASANum(stdate,enddate,"3")
    set retArr(1,"ASANum4")=..GetASANum(stdate,enddate,"4")
    set retArr(1,"ASANum5")=..GetASANum(stdate,enddate,"5")
    set result=##class(CIS.AN.COM.String).ToJson(.retArr)
    quit result
}

}
