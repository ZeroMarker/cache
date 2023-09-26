Class EMRservice.BL.BLActionsLogsInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLActionsLogsInfo","GetActionsLogsList","2015-04-17","2015-04-17","","N","","L","")
Query GetActionsLogsList(AStartDate As %String, AEndDate As %String, AUserID As %String, AuditFlag As %String, AModel As %String, AType As %String, AConditions As %String) As %Query(ROWSPEC = "EventLogRowID:%String,LogModelDr:%String,LogModelDesc:%String,LogModelCode:%String,DetComputerIP:%String,DetComputerMac:%String,DetComputerName:%String,DetGroupDr:%String,DetGroupDesc:%String,DetLocDr:%String,DetLocDesc:%String,DetDate:%String,DetTime:%String,DetUserDr:%String,DetUserName:%String,DetConditions:%String,PatName:%String,PapmiNo:%String,MedicareNo:%String")
{
}

ClassMethod GetActionsLogsListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String, AuditFlag As %String, AModel As %String, AType As %String, AConditions As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s AStartDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AStartDate)
	s AEndDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AEndDate)
	
	//s TestConditions = "{"_"""userID"""_":"_"""359"""_","_"""userName"""_":"_"""孙凤霞"""_"}"
	//s AConditions = TestConditions
	s EventLog = ##Class(%ResultSet).%New("web.DHCEventLog:Find")
	s EventLogList = EventLog.Execute(AStartDate,AEndDate,AUserID,AuditFlag,AModel,AType)
	
	While (EventLog.Next())
 	{
	 	s EventLogRowID = $g(EventLog.Data("LogRowId"))
	 	s LogModelDesc = $g(EventLog.Data("LogModelDesc"))
	 	s LogModelDr = $g(EventLog.Data("LogModelDr"))
	 	s LogModelCode = $lg(^User.DHCEventModelD(LogModelDr),2)
	 	s LogModelKey = $lg(^User.DHCEventModelD(LogModelDr),6)
	 	s LogModelNote = $lg(^User.DHCEventModelD(LogModelDr),7)
	 	//过滤掉非电子病历操作的记录
	 	continue:(LogModelKey '= "EMR")
	 	
	 	s EventLogDetails = ##Class(%ResultSet).%New("web.DHCEventLogDetails:Find")
		s EventLogDetailsList = EventLogDetails.Execute(EventLogRowID)
		
		While (EventLogDetails.Next())
 		{
	 		s DetConditions = $g(EventLogDetails.Data("DetConditions"))
	 		
	 		s SysOptionStream = ##class(%GlobalBinaryStream).%New()
			d SysOptionStream.Write(DetConditions)
	 		s JsonObj = ##Class(EMRservice.Parser.Json).%New()
	 		s DetConditionsJson = JsonObj.Deserialize(SysOptionStream)
	 		continue:(DetConditionsJson.Count() = 0)
	 		
	 		s ConditionsStream = ##class(%GlobalBinaryStream).%New()
			d ConditionsStream.Write(AConditions)
	 		s JsonObj = ##Class(EMRservice.Parser.Json).%New()
	 		s ConditionsJson = JsonObj.Deserialize(ConditionsStream)
	 		
	 		s Flag = "True"
	 		s key = ""
	 		for int=1:1:ConditionsJson.Count()
	 		{
		 		s key = ConditionsJson.Next(key)
		 		if (ConditionsJson.GetAt(key) '= "")&&(DetConditionsJson.GetAt(key) '= ConditionsJson.GetAt(key))
		 		{
			 		s Flag = "False"
			 	}
		 	}
	 		//如果日志符合查询条件，输出；否则不输出；
	 		if (Flag = "True")
	 		{
		 		//DetComputerIP:%String,DetComputerMac:%String,DetComputerName:%String,DetGroupDr:%String,DetGroupDesc:%String,DetLocDr:%String,DetLocDesc:%String,DetDate:%String,DetTime:%String,DetUserDr:%String,DetUserName:%String
		 		s DetComputerIP = $g(EventLogDetails.Data("DetComputerIP"))
		 		s DetComputerMac = $g(EventLogDetails.Data("DetComputerMac"))
		 		s DetComputerName = $g(EventLogDetails.Data("DetComputerName"))
		 		s DetGroupDr = $g(EventLogDetails.Data("DetGroupDr"))
		 		s DetGroupDesc = $g(EventLogDetails.Data("DetGroupDesc"))
		 		s DetLocDr = $g(EventLogDetails.Data("DetLocDr"))
		 		s DetLocDesc = $g(EventLogDetails.Data("DetLocDesc"))
		 		s DetDate = $g(EventLogDetails.Data("DetDate"))
		 		s DetTime = $g(EventLogDetails.Data("DetTime"))
		 		s DetUserDr = $g(EventLogDetails.Data("DetUserDr"))
		 		s DetUserName = $g(EventLogDetails.Data("DetUserName"))
		 		
		 		s PatientID = DetConditionsJson.GetAt("patientID")
				s EpisodeID = DetConditionsJson.GetAt("episodeID")
				
				if (PatientID="")
		 		{
			 		s PatientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
			 	}
				
		 		if (PatientID '= "")
		 		{
					//患者登记号
					s PapmiNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
					//患者姓名
					s PatName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(PatientID)
					//患者病案号
					s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(EpisodeID)
		 		}
		 		
		 		set ^CacheTemp(repid,ind) = $LB(EventLogRowID,LogModelDr,LogModelDesc,LogModelCode,DetComputerIP,DetComputerMac,DetComputerName,DetGroupDr,DetGroupDesc,DetLocDr,DetLocDesc,DetDate,DetTime,DetUserDr,DetUserName,DetConditions,PatName,PapmiNo,MedicareNo)
				set ind = ind + 1
		 	}
	 		
 		}
 	}
	
	Quit $$$OK
}

ClassMethod GetActionsLogsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetActionsLogsListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetActionsLogsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetActionsLogsListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
