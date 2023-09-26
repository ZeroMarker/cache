Class User.DHCVISLinkQueueType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCVISLinkQueueType ]
{

/// 代码
Property linkQueueCode As %String;

/// 描述
Property linkQueueDesc As %String;

/// 备注
Property linkQueueNote As %String;

/// 创建日期
Property createDate As %Date;

/// 创建时间
Property createTime As %Time;

/// 启用标志
Property activeFlag As %String;

Index QueueCodeIndex On linkQueueCode;

Index QueueDescIndex On linkQueueDesc;

Storage Default
{
<Data name="DHCVISLinkQueueTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>linkQueueCode</Value>
</Value>
<Value name="3">
<Value>linkQueueDesc</Value>
</Value>
<Value name="4">
<Value>createDate</Value>
</Value>
<Value name="5">
<Value>createTime</Value>
</Value>
<Value name="6">
<Value>activeFlag</Value>
</Value>
<Value name="7">
<Value>linkQueueNote</Value>
</Value>
</Data>
<DataLocation>^User.DHCVISLinkQueueTypeD</DataLocation>
<DefaultData>DHCVISLinkQueueTypeDefaultData</DefaultData>
<IdLocation>^User.DHCVISLinkQueueTypeD</IdLocation>
<IndexLocation>^User.DHCVISLinkQueueTypeI</IndexLocation>
<StreamLocation>^User.DHCVISLinkQueueTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
