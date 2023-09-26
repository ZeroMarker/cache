Class DHCEPRFS.SI.SIToHIS Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SIToHIS";

/// Desc:	获取PDF路径
/// Input: AEpisodeID - 就诊rowid, AMRItemIDS - 归档项目ID的串
/// Return:	PDF路径
/// Debug：	w ##Class(DHCEPRFS.SI.SIToHIS).IsRecordCreated(AEpisodeID,AMRItemIDS)
ClassMethod GetPDFPathByItemID(AEpisodeID As %String, AMRItemIDS As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BI.BIToHIS).GetPDFPathByItemID(AEpisodeID, AMRItemIDS)
	q ret
}

}
