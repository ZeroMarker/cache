Class EMRservice.entity.ETextKBCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 目录名称
Property Name As %String;

/// 目录类型
Property Type As %String;

/// 父节点
Property ParentID As %String;

/// 目录顺序
Property Sequence As %String;

/// 是否有效
Property IsValid As %String;

}
