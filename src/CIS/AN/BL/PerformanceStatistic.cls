Class CIS.AN.BL.PerformanceStatistic Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2019-1-10
/// Description： 	手术护士绩效计算
/// Table：        	
/// Input:			startDate,endDate
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PerformanceStatistic","NurseWorkScore","2018-12-10","2018-12-10")
Query NurseWorkScore(startDate As %String, endDate As %String) As %Query(ROWSPEC = "Nurse,NurseName,Score,ScoreNote")
{
}

ClassMethod NurseWorkScoreExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
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
	set indexNode="OPDate"
	kill operStatList,operScoreList
	
	set operScores = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:FindOperPerformScore")
	for i=1:1:operScores.Size
	{
		set operScore=operScores.GetAt(i)
		quit:operScore=""
		
		set operScoreList(operScore.GetValue("OperName"))=operScore.GetValue("Score")
	}
	
	set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
			
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set theatreInTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","TheatreInTime")
			set theatreOutTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","TheatreOutTime")
			continue:(theatreInTime="")!(theatreOutTime="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set operDate=operSchedule.OperDate
			set medcareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",operSchedule.EpisodeID)
			set patName=operSchedule.PatName
			
			set Operation=""
			
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
			
			set score=$$MatchScore(Operation)
			
			set scrubNurse1=##class(CIS.AN.BL.Signature).GetOperNurseBySignature(opsId,"ScNurseSign")
			set scrubNurseUser1=##class(CIS.AN.COM.Admission).GetUserIDByCareProv(scrubNurse1)
			do AddIntoCache(scrubNurseUser1,"器械")
			set scrubNurse2=##class(CIS.AN.BL.Signature).GetOperNurseBySignature(opsId,"ScNurseSign2")
			set scrubNurseUser2=##class(CIS.AN.COM.Admission).GetUserIDByCareProv(scrubNurse2)
			do AddIntoCache(scrubNurseUser2,"器械")
			set scrubNurse3=##class(CIS.AN.BL.Signature).GetOperNurseBySignature(opsId,"ScNurseSign3")
			set scrubNurseUser3=##class(CIS.AN.COM.Admission).GetUserIDByCareProv(scrubNurse3)
			do AddIntoCache(scrubNurseUser3,"器械")
			set circualNurse1=##class(CIS.AN.BL.Signature).GetOperNurseBySignature(opsId,"CirNurseSign")
			set circualNurseUser1=##class(CIS.AN.COM.Admission).GetUserIDByCareProv(circualNurse1)
			do AddIntoCache(circualNurseUser1,"巡回")
			set circualNurse2=##class(CIS.AN.BL.Signature).GetOperNurseBySignature(opsId,"CirNurseSign2")
			set circualNurseUser2=##class(CIS.AN.COM.Admission).GetUserIDByCareProv(circualNurse2)
			do AddIntoCache(circualNurseUser2,"巡回")
			set circualNurse3=##class(CIS.AN.BL.Signature).GetOperNurseBySignature(opsId,"CirNurseSign3")
			set circualNurseUser3=##class(CIS.AN.COM.Admission).GetUserIDByCareProv(circualNurse3)
			do AddIntoCache(circualNurseUser3,"巡回")
			
		}
	}
	
	set nurseId=""
	for
	{
		set nurseId=$o(operStatList(nurseId))
		quit:nurseId=""
		
		set nurseName=$g(operStatList(nurseId))
		set date="",totalScore=0,totalScoreNote=""
		for
		{
			set date=$o(operStatList(nurseId,date))
			quit:date=""
			
			set totalScoreNote=totalScoreNote_$zd(date,3)_":"
			set opsId="",scoreNote=""
			for
			{
				set opsId=$o(operStatList(nurseId,date,opsId))
				quit:opsId=""
				
				set score=$lg(operStatList(nurseId,date,opsId),1)
				set totalScore=totalScore+score
				set medcareNo=$lg(operStatList(nurseId,date,opsId),2)
				set patName=$lg(operStatList(nurseId,date,opsId),3)
				set role=$lg(operStatList(nurseId,date,opsId),4)
				set Operation=$lg(operStatList(nurseId,date,opsId),5)
				set scoreNote=patName_" "_medcareNo_" "_role_" "_Operation_";"
				set totalScoreNote=totalScoreNote_scoreNote_"<br>"
			}
		}
		
		do OutputRow
	}
	
	kill operStatList
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
MatchScore(Operation)
	kill scoreList
	set operName=""
	for
	{
		set operName=$o(operScoreList(operName))
		quit:operName=""
		
		if Operation[operName
		{
			set scoreList(+operScoreList(operName))=""
		}
	}
	
	set scoreIndex="",count=0, score=0,factor=0.5
	for
	{
		set scoreIndex=$o(scoreList(scoreIndex),-1)
		quit:scoreIndex=""
		
		set count=count+1
		if count=1 set score=scoreIndex
		else  set score=score+(scoreIndex*factor)
	}
	
	quit score
 	
AddIntoCache(userId,role)
	set userInfo=##class(CIS.AN.COM.Admission).GetUserTypeName(userId)
	if (userInfo'="") {
		set operStatList(userId)=$p(userInfo,"^",2)
		set operStatList(userId,operDate,opsId)=$lb(score,medcareNo,patName,role,Operation)
	}
	
	quit

OutputRow
 	Set Data=$lb(nurse,nurseName,totalScore,scoreNote)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod NurseWorkScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NurseWorkScoreExecute ]
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

ClassMethod NurseWorkScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NurseWorkScoreExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
