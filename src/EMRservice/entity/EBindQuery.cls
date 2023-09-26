/// 名称:EMRservice.entity.EBindQuery
/// 描述:数据引用entity
/// 修改：yejian
/// 编写日期: 2014-2-11
Class EMRservice.entity.EBindQuery Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ClassName As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryName As %String(TRUNCATE = 1);

Property SingleResult As %String(TRUNCATE = 1);

Property Mark As %String(TRUNCATE = 1);

/// 绑定类型(查询:Query/空，方法：Method)
Property BindType As %String(TRUNCATE = 1);

}
