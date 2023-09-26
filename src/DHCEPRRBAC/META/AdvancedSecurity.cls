Class DHCEPRRBAC.META.AdvancedSecurity Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 系统标识		
Property SysCode As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

Property MREpisodeID As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

/// 病历类型
/// SEALUP --将封存的病历添加到特殊病历
Property Type As %String(TRUNCATE = 1);

Property ActionDate As %Date;

Property ActionTime As %Time;

Index IdxEpisodeID On EpisodeID;

Index IdxMREpisodeID On MREpisodeID;

Index IdxActionDateTime On (ActionDate, ActionTime);

Index IdxUnique On (SysCode, EpisodeID);

Index IdxSealType On (SysCode, EpisodeID, Type) [ Unique ];

Storage Default
{
<Data name="AdvancedSecurityDefaultData">
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
<Value>MedRecordNo</Value>
</Value>
<Value name="7">
<Value>PatientID</Value>
</Value>
<Value name="8">
<Value>RegNo</Value>
</Value>
<Value name="9">
<Value>UserID</Value>
</Value>
<Value name="10">
<Value>SysCode</Value>
</Value>
<Value name="11">
<Value>MREpisodeID</Value>
</Value>
<Value name="12">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.META.ASecurityD</DataLocation>
<DefaultData>AdvancedSecurityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.META.ASecurityD</IdLocation>
<IndexLocation>^DHCEPRRBAC.META.ASecurityI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.META.ASecurityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
