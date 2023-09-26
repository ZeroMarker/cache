Class DHCEPRFS.Prison.Srv.SrvThirdParty Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvThirdParty";

/// Desc: OA每完成一个犯人的文档就会调用此接口(初步对OA文档不分类，统一称为"申请审批表")
/// Input:	PAINumber:犯人监禁编号    CompleteDate:填表完成日期    CompleteTime:填表完成时间    FilePath:文件地址(json格式)
ClassMethod OAComplete(PAINumber As %String, CompleteDate As %String, CompleteTime As %String, FilePath As %String) As %String [ WebMethod ]
{
	s sc = ##class(DHCEPRFS.Prison.BL.BLThirdParty).OAComplete(PAINumber,CompleteDate,CompleteTime,FilePath)
	q sc
}

}
