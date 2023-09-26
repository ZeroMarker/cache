///  名称：		EMRservice.BOProducts
///  描述：		已上产品模块BO层
///  编写者：	yejian
///  编写时间：	2017-11-9
Class EMRservice.BOProducts Extends %SOAP.WebService
{

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ProductsInfo";

/// 查询
/// Debug: w ##class(EMRservice.BOProducts).SelectAll()
ClassMethod SelectAll() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLProducts:SelectAll")
	d result.SetArgs()
	q result
}

/// 更新
/// Debug: d ##class(EMRservice.BOProducts).UpdateData(aProducts)
ClassMethod UpdateData(aProducts As EMRservice.entity.EProducts) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLProducts).UpdateData(aProducts)
}

/// 增加
/// Debug: d ##class(EMRservice.BOProducts).AddData(aProducts)
ClassMethod AddData(aProducts As EMRservice.entity.EProducts) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLProducts).AddData(aProducts)
}

/// 删除
/// Debug: d ##class(EMRservice.BOProducts).DeleteData("1")
ClassMethod DeleteData(rowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLProducts).DeleteData(rowID)
}

}
