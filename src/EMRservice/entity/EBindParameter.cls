/// 名称:EMRservice.entity.EBindParameter
/// 描述:数据引用entity
/// 修改：yejian
/// 编写日期: 2014-2-11
Class EMRservice.entity.EBindParameter Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property ParameterName As %String(TRUNCATE = 1);

Property ParameterType As %String(TRUNCATE = 1);

Property QueryID As %String(TRUNCATE = 1);

}
