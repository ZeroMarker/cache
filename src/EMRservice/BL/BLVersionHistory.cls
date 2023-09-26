Class EMRservice.BL.BLVersionHistory Extends %RegisteredObject
{

ClassMethod AddVersionHistoryInfos(VersionHistoryInfos As %String) As %String
{
	s objEPRLogs = ##class(EMRinstance.VersionHistory).%New()
	q:(objEPRLogs="") "0"
	
	s now = $H
	s date = $P(now,",",1)
	s time = $P(now,",",2)
	
	s objEPRLogs.TemplateDR = $p(VersionHistoryInfos,"^",1)
	s objEPRLogs.ReasonDescription = $p(VersionHistoryInfos,"^",2)
	s objEPRLogs.ContentDescription = $p(VersionHistoryInfos,"^",3)
	s objEPRLogs.LastVersion = $p(VersionHistoryInfos,"^",4)
	s objEPRLogs.CreateDate = date
	s objEPRLogs.CreateTime = time
	
	s status = objEPRLogs.%Save()
	q:('$$$ISOK(status)) "0"	
	q objEPRLogs.%Id()
}

Query SELECTALL(TemplateDR As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "TemplateDR:%String,ReasonDescription:%String,ContentDescription:%String,LastVersion:%String,CreateDate:%String,CreateTime:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_VersionHistory_SELECTALL, SqlProc ]
{
 SELECT TemplateDR,ReasonDescription,ContentDescription,LastVersion,CreateDate,CreateTime
 FROM EMRinstance.VersionHistory where TemplateDR=:TemplateDR ORDER BY TemplateDR
}

}
