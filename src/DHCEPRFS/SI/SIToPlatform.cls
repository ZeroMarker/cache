Class DHCEPRFS.SI.SIToPlatform Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SIToPlatform";

/// Desc:   获取PDF路径
/// Input: AEpisodeID - 就诊rowid, AMRItemIDS - 归档项目ID的串
/// Return: PDF路径
/// Debug：  w ##Class(DHCEPRFS.SI.SIToHIS).IsRecordCreated(AEpisodeID,AMRItemIDS)
ClassMethod GetPDFPathByItemID(AEpisodeID As %String, AMRItemIDS As %String, ADocumentID As %String = "") As %String [ WebMethod ]
{
    s ret = ##class(DHCEPRFS.BI.BIToPlatform).GetPDFPathByItemID(AEpisodeID, AMRItemIDS,ADocumentID)
    q ret
}

/// Debug：  w ##Class(DHCEPRFS.SI.SIToPlatform).RegDoc(AMRItemID,AXMLStr)
ClassMethod RegDoc(AMRItemID As %String, AXMLStr As %String) As %String [ WebMethod ]
{
    q ##class(DHCEPRFS.BI.BIToPlatform).RegDoc(AMRItemID,AXMLStr)
}

ClassMethod RegDocNew(AMRItemID As %String, AXMLStr As %String, AOperIP As %String) As %String [ WebMethod ]
{
    q ##class(DHCEPRFS.BI.BIToPlatform).RegDocNew(AMRItemID,AXMLStr, AOperIP)
}

ClassMethod AddProcessResult(AAdmTaskXmlInfoID As %String, ASucceedFlag As %String, AProcessIP As %String, APlatformXMLInfo As %String, APlatformRet As %String) As %String [ WebMethod ]
{
    q ##class(DHCEPRFS.BI.BIToPlatform).AddProcessResult(AAdmTaskXmlInfoID,ASucceedFlag,AProcessIP,APlatformXMLInfo,APlatformRet)
}

}
