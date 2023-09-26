/// 门诊病历分配信息表
Class EPRinstance.Quality.OutPatAssignInfo Extends %Persistent
{

Index IdxMedDoctorID On MedDoctorID;

Index IdxDateGap On DateGap;

Index IdxEpisodeID On EpisodeID;

// 分配者ID

Property AssignUserID As %String;

// 质控医生ID

Property MedDoctorID As %String;

// 患者就诊号

Property EpisodeID As %String [ Required ];

// 分配时间段

Property DateGap As %String(MAXLEN = 200);

Storage Default
{
<Data name="DHCEPRQ.QualityOutPatAssignInfoD">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>DateGap</Value>
</Value>
<Value name="2">
<Value>CheckFlag</Value>
</Value>
</Data>
<Data name="OutPatAssignInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssignUserID</Value>
</Value>
<Value name="3">
<Value>MedDoctorID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>ID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.OutPatAssignInfoD</DataLocation>
<DefaultData>DHCEPRQ.OutPatAssignInfoD</DefaultData>
<IdLocation>^DHCEPRQ.OutPatAssignInfoD</IdLocation>
<IndexLocation>^DHCEPRQ.OutPatAssignInfoI</IndexLocation>
<StreamLocation>^DHCEPRQ.OutPatAssignInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
