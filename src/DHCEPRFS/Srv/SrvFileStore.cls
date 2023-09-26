/// DHCEPRFS.Srv.SrvFileStore
Class DHCEPRFS.Srv.SrvFileStore Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "SrvFileStore";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

ClassMethod GetFileStoreConfig(ADate As %String) As %String [ WebMethod ]
{
	s tmpDate = $zdh(ADate,3)
	q ##Class(DHCEPRFS.BL.BLFileStoreConfig).GetFileStoreConfig(tmpDate,"DHCEPRFS")
}

}
