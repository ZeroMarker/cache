Class EPRservice.Quality.BLRecordModifyLog Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod RegLogEPR(AEpisodeID As %String, ADocID As %String, AEPRNum As %String, AAction As %String, AActUserID As %String) As %String
{
	s id = ..RegRecordModifyLog(AEpisodeID,"EPR",ADocID,AEPRNum,AAction,AActUserID)
	q id
}

ClassMethod RegRecordModifyLog(AEpisodeID As %String, AEMRVersion As %String, ADocID As %String, AEPRNum As %String, AAction As %String, AActUserID As %String) As %String
{
	s id = ..GetModifyLogID(AEpisodeID, AEMRVersion, ADocID, AEPRNum, AAction)
	if (id = "")
	{
		s id = ..CreateModifyLog(AEpisodeID, AEMRVersion, ADocID, AEPRNum, AAction, AActUserID)
	}
	else
	{
		do ..UpdateModifyLog(id, AActUserID)
	}
	
	q id
}

ClassMethod GetModifyLogID(AEpisodeID As %String, AEMRVersion As %String, ADocID As %String, AEPRNum As %String, AAction As %String) As %String
{
	s id = $O(^DHCEPRQ.RecordModifyLogI("IdxMain"," "_AEpisodeID, " "_$zcvt(AEMRVersion,"u"), " "_ADocID, " "_AEPRNum, " "_$zcvt(AAction,"u"),""))
	q id
}

ClassMethod CreateModifyLog(AEpisodeID As %String, AEMRVersion As %String, ADocID As %String, AEPRNum As %String, AAction As %String, AActUserID As %String) As %String
{
	s obj = ##Class(EPRinstance.Quality.RecordModifyLog).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.EMRVersion = AEMRVersion
	s obj.EPRDocID = ADocID
	s obj.EPRNum = AEPRNum
	s obj.ActionCode = AAction
	s obj.ActUserID = AActUserID
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod UpdateModifyLog(AQCLogID As %String, AActUserID As %String) As %Boolean
{
	s obj = ##Class(EPRinstance.Quality.RecordModifyLog).%OpenId(AQCLogID)
	q:(obj = "") "0"
	
	s obj.ActUserID = AActUserID
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

ClassMethod HasModifyRecord(AEpisodeID As %String, AActDate As %String, AActTime As %String) As %Boolean
{
	s date = $O(^DHCEPRQ.RecordModifyLogI("IdxOnActDateTime", " "_AEpisodeID,AActDate))
	q:(date '= "") "1"
	
	s time = $O(^DHCEPRQ.RecordModifyLogI("IdxOnActDateTime", " "_AEpisodeID, AActDate, AActTime))
	q:(time '= "") "1"	
		
	q "0"
}

ClassMethod GetModifyList(AEpisodeID As %String, AActDate As %String, AActTime As %String) As %ListOfDataTypes
{
	s list = ##Class(%ListOfDataTypes).%New() 
	
	s date = AActDate - 1
	for {
		s date = $O(^DHCEPRQ.RecordModifyLogI("IdxOnActDateTime", " "_AEpisodeID,date))
		q:(date = "")
	
		if (date = AActDate) {s time = AActTime} else {s time = ""}
		for {
			s time = $O(^DHCEPRQ.RecordModifyLogI("IdxOnActDateTime", " "_AEpisodeID, date, time))
			q:(time = "")
			
			s actCode = ""
			for {
				s actCode = $O(^DHCEPRQ.RecordModifyLogI("IdxOnActDateTime", " "_AEpisodeID, date, time,actCode))
				q:(actCode = "")
				
				s id = ""
				for {
					s id = $O(^DHCEPRQ.RecordModifyLogI("IdxOnActDateTime", " "_AEpisodeID, date, time,actCode,id))
					q:(id = "")
					
					d list.Insert(id)
				}
			}
		}
	}
	
	q list
}

}
