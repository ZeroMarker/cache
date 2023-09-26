/// 名称:EMRservice.entity.EEpisodeDataItem
/// 描述:就诊数据项entity
/// 修改：yejian
/// 编写日期: 2014-2-11
Class EMRservice.entity.EEpisodeDataItem Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property FieldName As %String(TRUNCATE = 1);

Property DataType As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

}
