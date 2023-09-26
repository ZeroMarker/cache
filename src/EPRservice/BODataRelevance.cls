Class EPRservice.BODataRelevance Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DataRelevanceInfo";

ClassMethod AddDataRelevance(RowID As %String, MethodName As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EPRservice.BLDataRelevance).GetDataRelevance(RowID,MethodName)	
	Quit result
}

ClassMethod GetServerData(AMethodName, AParam1 As %String, AParam2 As %String, AParam3 As %String, AParam4 As %String, AParam5 As %String, AParam6 As %String, AParam7 As %String, AParam8 As %String, AParam9 As %String, AParam10 As %String) As %String [ WebMethod ]
{
	s result = ##class(EPRservice.BLDataRelevance).GetServerData(AMethodName,AParam1,AParam2,AParam3,AParam4,AParam5,AParam6,AParam7,AParam8,AParam9,AParam10)	
	q result
}

}
