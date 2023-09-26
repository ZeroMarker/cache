/// 名称: 术语扩展配置表
/// 描述: 术语扩展
/// 编写者：叶剑
/// 编写日期: 2016-11-24
Class EPRmeta.GlossaryClassProperty Extends %Persistent
{

/// 所属表名EMRinstance.InstanceDat
Property ClassName As %String;

/// 属性名称(冗余字段用于显示单元名称)
Property PropertyName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 属性值：CreateDate|CreateTime
Property Propertys As %String(MAXLEN = 100, TRUNCATE = 1);

/// 取值类型：V(预留扩展用)
Property ValueType As %String;

/// 标示类型 INSTANCE
Property Type As %String;

/// 目录ID
Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Storage Default
{
<Data name="GlossaryClassPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>PropertyName</Value>
</Value>
<Value name="7">
<Value>Propertys</Value>
</Value>
<Value name="8">
<Value>ValueType</Value>
</Value>
<Value name="9">
<Value>ParentID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.GlyClassPropertyD</DataLocation>
<DefaultData>GlossaryClassPropertyDefaultData</DefaultData>
<IdLocation>^DHCEPRM.GlyClassPropertyD</IdLocation>
<IndexLocation>^DHCEPRM.GlyClassPropertyI</IndexLocation>
<StreamLocation>^DHCEPRM.GlyClassPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
