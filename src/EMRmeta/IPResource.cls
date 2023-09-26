/// 住院、急诊资源区页签配置
Class EMRmeta.IPResource Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock ]
{

Index IdxframeId On frameId;

Index Idxposition On position;

/// 页签Id标识符
Property frameId As %String(TRUNCATE = 1);

/// 页签标题
Property title As %String(TRUNCATE = 1);

/// 页签链接内容
Property source As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 页签宽度
Property width As %Integer;

/// 默认为空：在住院、急诊的资源区内都显示； I：在住院的资源区内显示； E：在急诊的资源区中显示
Property visible As %String(TRUNCATE = 1);

/// 页签排序位置
Property position As %Integer;

Storage Default
{
<Data name="IPResourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>frameId</Value>
</Value>
<Value name="3">
<Value>title</Value>
</Value>
<Value name="4">
<Value>source</Value>
</Value>
<Value name="5">
<Value>width</Value>
</Value>
<Value name="6">
<Value>visible</Value>
</Value>
<Value name="7">
<Value>position</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.IPResourceD</DataLocation>
<DefaultData>IPResourceDefaultData</DefaultData>
<IdLocation>^DHCEMRM.IPResourceD</IdLocation>
<IndexLocation>^DHCEMRM.IPResourceI</IndexLocation>
<StreamLocation>^DHCEMRM.IPResourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
