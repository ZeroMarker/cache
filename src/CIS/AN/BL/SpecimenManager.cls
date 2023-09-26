/// 标本管理业务类
Class CIS.AN.BL.SpecimenManager Extends %RegisteredObject
{

/// Creator：      	chenchangqing
/// CreatDate：    	2018-5-31
/// Description： 	查询标本登记信息
/// Table：        	DHC_AN.SpecimenReg
/// Input:			recordSheetID:手术麻醉记录表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.SpecimenManager","FindSpecimenRegList","1040")
Query FindSpecimenRegList(recordSheetID As %String) As %Query(ROWSPEC = "RowId,RegNo,MedcareNo,PatName,PatGender,PatAge,PatWardDesc,PatBedCode,RegDate,Specimen,SpecDesc,SpecNo,OutDateTime,FixDateTime,Handle,HandleDesc") [ SqlProc ]
{
}

ClassMethod FindSpecimenRegListExecute(ByRef qHandle As %Binary, recordSheetID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetID)=0)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK		
	}
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetID)
	set opsQuery=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
	set sc=opsQuery.Execute("","","",recordSheet.OperSchedule.%Id())
	set regNo="",medcareNo="",patName="",patGender="",patAge="",patWardDesc="",patBedCode=""
	while(opsQuery.%Next())
	{
		set regNo=opsQuery.Get("RegNo")
		set medcareNo=opsQuery.Get("MedcareNo")
		set patName=opsQuery.Get("PatName")
		set patGender=opsQuery.Get("PatGender")
		set patAge=opsQuery.Get("PatAge")
		set patWardDesc=opsQuery.Get("PatWardDesc")
		set patBedCode=opsQuery.Get("PatBedCode")	
	}
	set specimenRegQuery=##class(%ResultSet).%New("CIS.AN.BL.DataQueries:FindSpecimenReg")
	set sc=specimenRegQuery.Execute(recordSheetID)
	while(specimenRegQuery.%Next())
	{
		set rowId=specimenRegQuery.Get("RowId")
		set regDate=specimenRegQuery.Get("RegDate")
		set specimen=specimenRegQuery.Get("Specimen")
		set specimenDesc=specimenRegQuery.Get("SpecDesc")
		set:(specimenDesc="") specimenDesc=specimenRegQuery.Get("SpecimenNote")
		set specNo=medcareNo_"OP"_recordSheet.OperSchedule.%Id()_"SP"_rowId
		set outDateTime=specimenRegQuery.Get("OutDateTime")	
		set fixDateTime=specimenRegQuery.Get("FixDateTime")
		set handle=specimenRegQuery.Get("Handle")
		set handleDesc=specimenRegQuery.Get("HandleDesc")
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(rowId,regNo,medcareNo,patName,patGender,patAge,patWardDesc,patBedCode,regDate,specimen,specimenDesc,specNo,outDateTime,fixDateTime,handle,handleDesc)
	s ind=ind+1
	q
}

ClassMethod FindSpecimenRegListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpecimenRegListExecute ]
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

ClassMethod FindSpecimenRegListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpecimenRegListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018-7-24
/// Description： 	查询标本交接信息
/// Table：        	CIS_AN.SpecimenShift
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.SpecimenManager","FindSpecimenShiftList","2018-07-24","2018-07-24")
Query FindSpecimenShiftList(startDate As %String, endDate As %String, patName As %String = "", medcareNo As %String = "", circleNurseId As %String = "", dutyNurseId As %String = "") As %Query(ROWSPEC = "RowId,ShiftDate,PatName,PatDeptDesc,PatGender,PatAge,MedcareNo,PrevDiagnosisDesc,SpecimenDesc,SpecimenQty,CirNurse,DutyNurse,CirShiftDT,PathRecipient,PathShiftDT") [ SqlProc ]
{
}

ClassMethod FindSpecimenShiftListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, patName As %String = "", medcareNo As %String = "", circleNurseId As %String = "", dutyNurseId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	
	if (endDateH<startDateH)!(startDateH=0)!(endDateH=0)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK		
	}
	
	for i=startDateH:1:endDateH
	{
		set specimenShiftId=0
		for
		{
			set specimenShiftId=$order(^CIS.AN.SpecimenShiftI("ShiftDate",i,specimenShiftId))
			quit:(specimenShiftId="")
			set shiftDate=##class(CIS.AN.COM.DateTime).ConvertToDate(i)
			set specimenShift=##class(CIS.AN.SpecimenShift).%OpenId(specimenShiftId)
			set operShedule=specimenShift.SpecimenReg.RecordSheet.OperSchedule
			set curPatName="",patDeptDesc="",patGender="",patAge="",curMedcareNo="",prevDiagnosisDesc=""
			set rset=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
			set sc=rset.Execute("","","",operShedule.%Id())
			while(rset.%Next())
			{
				set curPatName=rset.Get("PatName")
				set patDeptDesc=rset.Get("PatDeptDesc")
				set patGender=rset.Get("PatGender")
				set patAge=rset.Get("PatAge")
				set curMedcareNo=rset.Get("MedcareNo")
				set prevDiagnosisDesc=rset.Get("PrevDiagnosisDesc")	
			}	
			continue:(patName'="")&(patName'=curPatName)
			continue:(medcareNo'="")&(medcareNo'=curMedcareNo)
			set specimenDesc=specimenShift.SpecimenReg.SpecimenNote
			set specimenQty=specimenShift.SpecimenQty
			set curCirNurseId=specimenShift.CircualNurse
			continue:(circleNurseId'="")&(circleNurseId'=curCirNurseId)
			set curCirNurse=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",curCirNurseId)
			set curDutyNurseId=specimenShift.DutyNurse
			continue:(dutyNurseId'="")&(curDutyNurseId'=dutyNurseId)
			set curDutyNurse=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",curDutyNurseId)
			set cirShiftDT=##class(CIS.AN.COM.DateTime).ConvertToDate(specimenShift.CirShiftDate)_" "_##class(CIS.AN.COM.DateTime).ConvertToTime(specimenShift.CirShiftTime)
			set pathRecipient=specimenShift.PathRecipient
			set pathRecipient=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",pathRecipient)
			set pathShiftDT=##class(CIS.AN.COM.DateTime).ConvertToDate(specimenShift.PathShiftDate)_" "_##class(CIS.AN.COM.DateTime).ConvertToTime(specimenShift.PathShiftTime)
			do OutputRow
		}	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(specimenShiftId,shiftDate,curPatName,patDeptDesc,patGender,patAge,curMedcareNo,prevDiagnosisDesc,specimenDesc,specimenQty,curCirNurse,curDutyNurse,cirShiftDT,pathRecipient,pathShiftDT)
	s ind=ind+1
	q
}

ClassMethod FindSpecimenShiftListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpecimenShiftListExecute ]
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

ClassMethod FindSpecimenShiftListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpecimenShiftListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod SaveSpecimen(dataPara As %String) As %String
{
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	m firstData=array(1)
	set specimenId=$get(firstData("RowId")),saveResult="S^"
	tstart
	if (##class(CIS.AN.SpecimenReg).%ExistsId(specimenId))
	{
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.firstData)	
	}
	else
	{
		set specimenNote=$get(firstData("SpecimenNote"))
		set specCount=$length(specimenNote,"+")
		for i=1:1:specCount
		{
			m specData=array(1)
			set specData("SpecimenNote")=$p(specimenNote,"+",i)
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.specData)
			quit:($piece(saveResult,"^",1)'="S")
		}
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod DelSpecimen(dataPara) As %String
{
	set $zt="Error"
	set dataCount=$l(dataPara,",")
	set saveResult="S^"
	tstart
	for i=1:1:dataCount
	{
		set dataId=$p(dataPara,",",i)
		set sc=##class(CIS.AN.SpecimenReg).%DeleteId(dataId)
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($p(saveResult,"^",1)="E")
	}
	if ($p(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2017-03-27
/// Description： 	查询时间轴信息
/// Table：        	DHCAN.TimeLine
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindTimeLines","1")
Query FindPlacentaList(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   PreserveTime,
	   OperSchedule,
	   OperSchedule->RegNo As RegNo,
	   OperSchedule->MedicareNo As MedcareNo,
	   OperSchedule->PatName As PatName,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',OperSchedule->PatDeptID) As PatDeptDesc,
	   CIS_AN_COM.DateTime_CalAge(OperSchedule->PatDOB,+$h) As PatAge,
	   OperSchedule->OperRoom->Description As RoomDesc,
	   CIS_AN_COM.String_GetDescByIDStr('User.CTCareProv','CTPCPDesc',OperSchedule->ScrubNurse) As ScrubNurseDesc,
	   CIS_AN_COM.String_GetDescByIDStr('User.CTCareProv','CTPCPDesc',OperSchedule->CircualNurse) As CircualNurseDesc,
	   %ODBCOUT(OperSchedule->OperDate) As OperDate,
	   CreateUser,
	   UpdateUser
	   From CIS_AN.Placenta
	   where OperSchedule=:opsId
}

/// Creator：      	陈长青
/// CreatDate：    	2020-09-12
/// Description： 	获取标本信息
/// Table：        	CIS_AN.Specimen
/// Input:			opsId:手术申请ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.SpecimenManager","FindSpecimenList","491")
Query FindSpecimenList(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Description,
	   OperSchedule,
	   OperSchedule->RegNo As RegNo,
	   OperSchedule->MedicareNo As MedcareNo,
	   OperSchedule->PatName As PatName,
	   OperSchedule->PatGender As PatGender,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',OperSchedule->PatDeptID) As PatDeptDesc,
	   CIS_AN_COM.DateTime_CalAge(OperSchedule->PatDOB,+$h) As PatAge,
	   OperSchedule->OperRoom->Description As RoomDesc,
	   CIS_AN_COM.String_GetDescByIDStr('User.CTCareProv','CTPCPDesc',OperSchedule->ScrubNurse) As ScrubNurseDesc,
	   CIS_AN_COM.String_GetDescByIDStr('User.CTCareProv','CTPCPDesc',OperSchedule->CircualNurse) As CircualNurseDesc,
	   %ODBCOUT(OperSchedule->OperDate) As OperDate,
	   CreateUser,
	   UpdateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   %ODBCOUT(OutTime) As OutTime,
	   %ODBCOUT(SoakTime) As SoakTime,
	   %ODBCOUT(SendOutTime) As SendOutTime,
	   Description,
	   SpecimenType,
	   %External(SpecimenType) As SpecimenTypeDesc,
	   Qty,
	   CIS_AN_BL.OperationList_GetOperDesc(OperSchedule) As OperDesc,
	   OperSchedule->OperSeq As OperSeq,
	   CIS_AN_BL.OperationList_GetSurgeonDescNew(OperSchedule) As SurgeonDesc,
	   CIS_AN_BL.OperScheduleList_GetDiagnosisDesc(OperSchedule->PrevDiagnosis) As PrevDiagnosisDesc	   
	   From CIS_AN.Specimen
	   where OperSchedule=:opsId
}

}
