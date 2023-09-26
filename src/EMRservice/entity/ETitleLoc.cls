/// 名称: EMRservice.entity.ETitleLoc
/// 描述: 标题配置表对象
/// 编写者：yejian
/// 编写日期: 2015-12-17
Class EMRservice.entity.ETitleLoc Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 标题ID
Property TitleID As %String;

/// 标题名称(冗余字段)
Property TitleName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

}
