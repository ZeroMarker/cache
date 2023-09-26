Class EMRservice.BL.BLEMRCustomLogs Extends %RegisteredObject
{

ClassMethod InsertOPprintLog(episodeID, emrDocID, instanceID, usrID As %String)
{
	s log = ##Class(EMRinstance.EMRCustomLogs).%New()
	s log.EpisodeID = episodeID
	s log.EMRDocID = emrDocID
	s log.EMRNum = 1
	s log.InstanceDataID = instanceID
	s dt = $H
	s log.HappenDate = $P(dt, ",", "1")
	s log.HappenTime = $P(dt, ",", "2")
	s log.UserID = usrID
	s log.Action = "PRINT"
	//s log.IP	
	d log.%Save()
}

/// w ##Class(EMRservice.BL.opInterface).GetOPprintLog("8651","137")
ClassMethod GetOPprintLog(episodeID, emrDocID As %String) As %String
{
	s id = "", ret = ""
	for {
		s id = $O(^DHCEMRI.EMRCustomLogsI("IdxAdmDocAction", " "_episodeID, " "_emrDocID, " PRINT", id))
		q:(""=id)
		s log = ##Class(EMRinstance.EMRCustomLogs).%OpenId(id)
		s name = ""
		s:(""'=log.UserID) name = $p(^SSU("SSUSR",log.UserID), "^", 2)	
		s datetime = $zd(log.HappenDate,3)_" "_$zt(log.HappenTime,1)
		
		s item = "{""name"":"""_name_""",""datetime"":"""_datetime_"""}"
		if (ret="") { s ret = item }
		else { s ret = ret_","_item }
	}
	
	q "["_ret_"]"
}

}
