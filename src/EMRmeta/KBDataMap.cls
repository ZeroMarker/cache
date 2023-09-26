/// 名称:EMRmeta.KBDataMap
/// 描述:知识库关联表
/// 编写者：yejian
/// 编写日期: 2014-01-03
Class EMRmeta.KBDataMap Extends %Persistent
{

/// 索引
Index IdxOldID On (OldID, MapType) [ Unique ];

Property OldID As %String(MAXLEN = 100, TRUNCATE = 1);

Property OldName As %String(MAXLEN = 200, TRUNCATE = 1);

Property NewID As %String(MAXLEN = 100, TRUNCATE = 1);

Property NewName As %String(MAXLEN = 200, TRUNCATE = 1);

//目录：KBCATEGORY,知识库节点：KBBASE,知识库树：KBTREE,知识库Node:KBNODE

Property MapType As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="KBDataMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OldID</Value>
</Value>
<Value name="3">
<Value>OldName</Value>
</Value>
<Value name="4">
<Value>NewID</Value>
</Value>
<Value name="5">
<Value>NewName</Value>
</Value>
<Value name="6">
<Value>MapType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.KBDataMapD</DataLocation>
<DefaultData>KBDataMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.KBDataMapD</IdLocation>
<IndexLocation>^DHCEMRM.KBDataMapI</IndexLocation>
<StreamLocation>^DHCEMRM.KBDataMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
