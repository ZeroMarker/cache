Class DHCEPRSearch.Srv.SrvExportQuery Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService 
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprsearchservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvExportQuery";

ClassMethod Add(AUserID As %String, AResultColumnsName As %String, AResultXMLString As %GlobalCharacterStream, AMedRecordNoS As %String, AConditions As %GlobalCharacterStream, ADisLocID As %String, AStartDisDate As %String, AEndDisDate As %String, AResultColumns As %String, AMREpisodeIDS As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRSearch.BL.BLExportQuery).Add(AUserID, AResultColumnsName, AResultXMLString, AMedRecordNoS, AConditions, ADisLocID, AStartDisDate, AEndDisDate, AResultColumns, AMREpisodeIDS)
	q ret
}

}
