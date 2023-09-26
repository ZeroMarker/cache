/// Desc:         电子病历锁表（锁instanceID）
/// Creator:      yb
/// CreateDate:   2022-8-11
Class EMRinstance.LockOp Extends %Persistent
{

/// 用户ID
Property UserID As %String;

/// 计算机IP
Property Computer As %String;

/// 锁定日期
Property LockDate As %Date;

/// 锁定时间
Property LockTime As %Time;

/// 操作目录DocID
Property DocID As %String;

/// 操作文档InstanceID
Property InstanceID As %String;

/// 就诊ID
Property EpisodeID As %String;

/// 模板ID
Property TemplateID As %String;

/// session
Property SessionID As %String;

/// 计算机名称
Property ComputerName As %String;

/// 用户科室ID
Property UserLocID As %String;

/// 操作目录CategoryID
Property CategoryID As %String;

Index IdxMain On (EpisodeID, InstanceID) [ Unique ];

Index IdxSessionID On SessionID;

Index IdxEpisodeID On EpisodeID;

Storage Default
{
<Data name="LockOpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>Computer</Value>
</Value>
<Value name="4">
<Value>LockDate</Value>
</Value>
<Value name="5">
<Value>LockTime</Value>
</Value>
<Value name="6">
<Value>DocID</Value>
</Value>
<Value name="7">
<Value>InstanceID</Value>
</Value>
<Value name="8">
<Value>EpisodeID</Value>
</Value>
<Value name="9">
<Value>TemplateID</Value>
</Value>
<Value name="10">
<Value>SessionID</Value>
</Value>
<Value name="11">
<Value>ComputerName</Value>
</Value>
<Value name="12">
<Value>UserLocID</Value>
</Value>
<Value name="13">
<Value>CategoryID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.LockOpD</DataLocation>
<DefaultData>LockOpDefaultData</DefaultData>
<IdLocation>^DHCEMRI.LockOpD</IdLocation>
<IndexLocation>^DHCEMRI.LockOpI</IndexLocation>
<StreamLocation>^DHCEMRI.LockOpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
