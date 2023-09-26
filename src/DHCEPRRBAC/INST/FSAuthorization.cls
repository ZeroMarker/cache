Class DHCEPRRBAC.INST.FSAuthorization Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 	欲申请的就诊信息
/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病人号
Property PatientID As %String(TRUNCATE = 1);

/// 病案号
Property MedRecordNo As %String(TRUNCATE = 1);

/// 登记号
Property RegNo As %String(TRUNCATE = 1);

Property DetailNum As %Integer;

Relationship TheFSAuthorizationGroup As DHCEPRRBAC.INST.FSAuthorizationGroup [ Cardinality = parent, Inverse = TheFSAuthorization ];

Index IdxEpisode On EpisodeID;

Index IdxPatientID On PatientID;

Index IdxMedRecordNo On MedRecordNo;

Index IdxRegNo On RegNo;

Index IdxMain On (TheFSAuthorizationGroup, DetailNum) [ Unique ];

Index IdxMainMedRecordNo On (TheFSAuthorizationGroup, MedRecordNo);

Storage Default
{
<Data name="FSAuthorizationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>MREpisodeID</Value>
</Value>
<Value name="4">
<Value>MedRecordNo</Value>
</Value>
<Value name="5">
<Value>RegNo</Value>
</Value>
<Value name="6">
<Value>AppointDate</Value>
</Value>
<Value name="7">
<Value>AppointTime</Value>
</Value>
<Value name="8">
<Value>AppointEndDate</Value>
</Value>
<Value name="9">
<Value>AppointEndTime</Value>
</Value>
<Value name="10">
<Value>AppointUserID</Value>
</Value>
<Value name="11">
<Value>RequestUserID</Value>
</Value>
<Value name="12">
<Value>RequestDept</Value>
</Value>
<Value name="13">
<Value>RequestDate</Value>
</Value>
<Value name="14">
<Value>RequestTime</Value>
</Value>
<Value name="15">
<Value>EPRAction</Value>
</Value>
<Value name="16">
<Value>AppointType</Value>
</Value>
<Value name="17">
<Value>AppointStatus</Value>
</Value>
<Value name="18">
<Value>RoleID</Value>
</Value>
<Value name="19">
<Value>MRPatientID</Value>
</Value>
<Value name="20">
<Value>PatientID</Value>
</Value>
<Value name="21">
<Value>RequestSSGroup</Value>
</Value>
<Value name="22">
<Value>DetailNum</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.FSAuthD</DataLocation>
<DefaultData>FSAuthorizationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.FSAuthD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.FSAuthI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.FSAuthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
