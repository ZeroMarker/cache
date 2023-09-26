Class DHCEPRFS.Srv.SrvAdmTaskCreate Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvAdmTaskCreate";

ClassMethod CreateTask(APatientID As %String, AEpisodeID As %String, ADetails As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLAdmTaskCreate).CreateTask(APatientID,AEpisodeID,ADetails)
}

ClassMethod CompleteTask(AEpisodeID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLAdmTaskCreate).CompleteTask(AEpisodeID)
}

ClassMethod SetItemStart(APatientID As %String, AEpisodeID As %String, ACategoryID As %String, ACategoryDetail As %String, AMRItemID As %String, AInvokeMethod As %String, ACreateIP As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLAdmTaskCreate).SetItemStart(APatientID,AEpisodeID,ACategoryID,ACategoryDetail,AMRItemID,AInvokeMethod, ACreateIP)
}

ClassMethod SetItemFinish(APatientID As %String, AEpisodeID As %String, AMRItemID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLAdmTaskCreate).SetItemFinish(APatientID,AEpisodeID,AMRItemID)
}

ClassMethod GetCreateLog(AEpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLAdmTaskCreate:GetCreateLog")
	d obj.SetArgs(AEpisodeID)
	q obj
}

}
