/// Desc:       用户行为记录
/// Creator:    candy
/// CreateDate: 2015-1-30
Class EMRinstance.Trace.ActionLog Extends (%Persistent, %XML.Adaptor)
{

/// 用户ID
Property UserID As %String;

/// 登录科室
Property UserLocID As %String;

/// 动作
Property Action As %String;

/// 操作内容
Property Content As %String;

/// 登录IP
Property IP As %String;

/// 日志记录日期
Property LogDate As %Date;

/// 日志记录时间
Property LogTime As %Time;

Storage Default
{
<Data name="ActionLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>UserLocID</Value>
</Value>
<Value name="4">
<Value>Action</Value>
</Value>
<Value name="5">
<Value>Content</Value>
</Value>
<Value name="6">
<Value>IP</Value>
</Value>
<Value name="7">
<Value>LogDate</Value>
</Value>
<Value name="8">
<Value>LogTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRT.ActionLogD</DataLocation>
<DefaultData>ActionLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRT.ActionLogD</IdLocation>
<IndexLocation>^DHCEMRT.ActionLogI</IndexLocation>
<StreamLocation>^DHCEMRT.ActionLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
