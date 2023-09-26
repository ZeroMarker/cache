/// 名称:EMRservice.entity.EBindField
/// 描述:数据引用entity
/// 修改：yejian
/// 编写日期: 2014-2-11
Class EMRservice.entity.EBindField Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property FieldName As %String(TRUNCATE = 1);

Property FieldType As %String(TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryID As %String(TRUNCATE = 1);

Property DicID As %String(TRUNCATE = 1);

/// 返回值类型：Dict / Mono/ Mult
Property ValueType As %String(TRUNCATE = 1);

}
