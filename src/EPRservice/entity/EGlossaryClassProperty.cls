Class EPRservice.entity.EGlossaryClassProperty Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 所属表名EMRinstance.InstanceDat
Property ClassName As %String;

/// 属性名称(冗余字段用于显示单元名称)
Property PropertyName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 属性值：CreateDate|CreateTime
Property Propertys As %String(MAXLEN = 100, TRUNCATE = 1);

/// 取值类型：V,
Property ValueType As %String;

/// 标示类型 INSTANCE
Property Type As %String;

/// 目录ID
Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %String;

}
