Class DHCEPRFS.Srv.SrvScanLog Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvScanLog";

/*
/// Desc:	增加扫描日志
ClassMethod AddScanLog(AEScanLog As DHCEPRFS.Entity.EScanLog) As %String [ WebMethod ]
{
	s sc = ##Class(DHCEPRFS.BL.BLScanLog).AddScanLog(AEScanLog)
	q sc
}
*/
/// Desc:  获得用户未分类病历
/// Creator:Candyxu
/// CreateDate:2013-7-6
/// Input:AUserID：用户ID
/// OutPut：患者基本就诊信息
ClassMethod GetNoSortPatient(AUserID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLScanLog:GetNoSortPatient")
	d obj.SetArgs(AUserID)
	q obj
}

}
