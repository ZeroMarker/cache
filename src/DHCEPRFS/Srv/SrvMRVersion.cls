Class DHCEPRFS.Srv.SrvMRVersion Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRVersion";

/// Desc:	注册MRVersion并获取其RowID
ClassMethod RegMRVersionID(AMREpisdoeID As %String, AVersion As %String) As %String [ WebMethod ]
{
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).RegMRVersionID(AMREpisdoeID, AVersion)
	q mrVersionID
}

/// Desc:	获取指定MRVersion的RowID
ClassMethod GetMRVersionID(AMREpisdoeID As %String, AVersion As %String) As %String [ WebMethod ]
{
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisdoeID, AVersion)
	q mrVersionID
}

/// Desc:	获取指定MRVersion的RowID
ClassMethod GetCommonMRVersionID(AMRID As %String, AVersion As %String, AType As %String = "") As %String [ WebMethod ]
{
	s:(AType = $c(0)) AType = ""
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMRID, AVersion,AType)
	q mrVersionID
}

ClassMethod GetMRVersionIDByVersionType(AMREpisdoeID As %String, AVersionTypeCode As %String) As %String [ WebMethod ]
{
	s AVersion = ##class(DHCEPRFS.BL.BLVersionCodeMapping).GetVersionByCode(AVersionTypeCode)
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisdoeID, AVersion)
	q mrVersionID
}

}
