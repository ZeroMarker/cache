Class DHCEPRFS.BL.BLUpdateMrEpisode Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.BL.BLUpdateMrEpisode).AddTask("1","50")
ClassMethod AddTask(AMREpisodeID As %String, APriority As %String) As %String
{
	s obj = ##Class(DHCEPRFS.INST.MREpisodeUpdateTask).%New()
	s obj.MREpisodeID = AMREpisodeID
	s obj.Priority = APriority
	s obj.TaskDate = $p($h,",",1)
	s obj.TaskTime = $p($h,",",2)
	s status = obj.%Save()
	d obj.%Close()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// debug: w ##class(DHCEPRFS.BL.BLUpdateMrEpisode).UpdateMrEpisode()
ClassMethod UpdateMrEpisode() As %String
{
	b "s"
	//可能多个实例同时请求，开始事务
	TSTART
	
	s $zt = "OnMoveErrorHandler"
	
	s count = ""
	&sql(select count(*) into :count from DHCEPRFS_INST.MREpisodeUpdateTask)
	if (count = "") 
	{
		TROLLBACK
		q ""
	}
	elseif(count = 0)
	{
		TCOMMIT
		q "0"
	}
	else
	{
		s taskDate = $o(^DHCEPRFS.INST.MREpisodeUDI("IdxDateTime",""),-1)
		s taskTime = $o(^DHCEPRFS.INST.MREpisodeUDI("IdxDateTime",taskDate,""),-1)
		s rowID = $o(^DHCEPRFS.INST.MREpisodeUDI("IdxDateTime",taskDate,taskTime,""))
		if (rowID = "")
		{
			TROLLBACK
			q ""	
		}
		s obj = ##class(DHCEPRFS.INST.MREpisodeUpdateTask).%OpenId(rowID)
		s mrEpisodeID = obj.MREpisodeID
		d obj.%Close()
		s status = ##Class(DHCEPRFS.INST.MREpisodeUpdateTask).%DeleteId(rowID)
		if ('$$$ISOK(status))
		{
			TROLLBACK
			q ""
		}
		
		s ret = ..UpdateMrEpisodeData(mrEpisodeID)	
		if (ret = "")
		{
			TROLLBACK
			q ""	
		}
		s ret = ..UpdateMrEpisodeFeeData(mrEpisodeID)
		if (ret = "")
		{
			TROLLBACK
			q ""		
		}
		s ret = ..UpdateMrEpisodeFPData(mrEpisodeID)
		if (ret = "")
		{
			TROLLBACK
			q ""
		}
		
		s ret = ..UpdateMrPateintData(mrEpisodeID)
		if (ret = "")
		{
			TROLLBACK
			q ""
		}
		
		s ret = ..UpdateMrEpisodePatData(mrEpisodeID)
		if (ret = "")
		{
			TROLLBACK
			q ""
		}
		else
		{
			TCOMMIT
			q mrEpisodeID
		}	
	}

OnMoveErrorHandler
	TROLLBACK
	q ""
}

ClassMethod UpdateMrEpisodeData(AMREpisodeID As %String) As %String
{
	s ret = ##class(DHCEPRFS.BL.BLMREpisode).UpdateMREpisode(AMREpisodeID)
	q ret
}

ClassMethod UpdateMrEpisodeFPData(AMREpisodeID As %String) As %String
{
	s ret = ##class(DHCEPRFS.BL.BLMREpisodeFP).UpdateMREpisodeFP(AMREpisodeID)
	q ret
}

ClassMethod UpdateMrEpisodeFeeData(AMREpisodeID As %String) As %String
{
	s ret = ##class(DHCEPRFS.BL.BLMREpisodeFee).UpdateMREpisodeFee(AMREpisodeID)
	q ret
}

/// w ##class(DHCEPRFS.BL.BLUpdateMrEpisode).UpdateMrPateintData("1")
ClassMethod UpdateMrPateintData(AMREpisodeID As %String) As %String
{
	s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s mrPatientID = obj.MRPatientID 
	s episodeID = obj.EpisodeID
	s objP = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s patientID = objP.PatientID
	s ret = ##class(DHCEPRFS.BL.BLMRPatient).UpdateMRPatient(patientID,"DHC",episodeID,"")
	q ret
}

ClassMethod UpdateMrEpisodePatData(AMREpisodeID As %String) As %String
{
	s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s mrPatientID = obj.MRPatientID 
	s objP = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s patientID = objP.PatientID
	s episodeID = obj.EpisodeID
	s ret = ##class(DHCEPRFS.BL.BLMRPatient).UpdateMREpisodePat(patientID,"DHC",episodeID)	
	q ret
}

}
