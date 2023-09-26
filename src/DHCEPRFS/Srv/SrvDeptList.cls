Class DHCEPRFS.Srv.SrvDeptList Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvDeptList";

/// 获取科室列表
ClassMethod GetDeptList(ALocID As %String) As DHCEPRFS.DataSet.EDeptListDS [ WebMethod ]
{
	s ^TempAA= ALocID
	s:( ALocID = $c(0)) ALocID = ""
	s result = ##Class(DHCEPRFS.DataSet.EDeptListDS).%New()
	d result.SetArgs(ALocID)
	q result
}

}
