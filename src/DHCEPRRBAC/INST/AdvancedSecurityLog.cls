Class DHCEPRRBAC.INST.AdvancedSecurityLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 系统标识		
Property SysCode As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

Property MREpisodeID As %String(TRUNCATE = 1);

/// 是否生效（此表记录永不删除，当前不起效则插入一条为N的记录，生效则插入一条为Y的记录）
Property Active As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property ActionDate As %Date;

Property ActionTime As %Time;

Property Type As %String(TRUNCATE = 1);

Index IdxEpisodeID On EpisodeID;

Index IdxMREpisodeID On MREpisodeID;

Storage Default
{
<Data name="AdvancedSecurityLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionDate</Value>
</Value>
<Value name="3">
<Value>ActionTime</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>SysCode</Value>
</Value>
<Value name="8">
<Value>MREpisodeID</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.ASecurityLD</DataLocation>
<DefaultData>AdvancedSecurityLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.ASecurityLD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.ASecurityLI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.ASecurityLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
