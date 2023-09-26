///  名称：		EMRservice.entity.EProducts
///  描述：		已上产品模块对象
///  编写者：	yejian
///  编写时间：	2019-7-2
Class EMRservice.entity.EProducts Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 产品代码
Property ProductCode As %String(TRUNCATE = 1);

/// 产品名称
Property ProductName As %String(TRUNCATE = 1);

}
