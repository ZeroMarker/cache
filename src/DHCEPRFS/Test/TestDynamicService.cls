Class DHCEPRFS.Test.TestDynamicService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvTestDynamicService";

ClassMethod GetPDFPath(Apara As %String) As %String
{
	q "<PathCount>2</PathCount><PathList><Path><RowID /><FilePath>ftp://192.168.99.58/2015/04/22/D93724</FilePath></Path><Path><RowID /><FilePath>ftp://192.168.99.58/2015/04/24/V461468</FilePath></Path></PathList></Response>"
}

}
