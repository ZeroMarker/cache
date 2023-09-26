/// Desc:病历查询结果列
/// Creator:Candy
Class DHCEPRFS.Srv.SrvResultColumn Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvResultColumn";

/// Desc：获取结果列
/// Creator：Candy
ClassMethod GetColumns(Column As %String) As %XML.DataSet [ WebMethod ]
{
   s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLResultColumn:GetColumns")
   d obj.SetArgs(Column)
   q obj
}

}
