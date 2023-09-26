Class EMRinstance.EMRCustomLogs Extends %Persistent
{

Index IdxAdmDocAction On (EpisodeID, EMRDocID, Action);

Property EpisodeID As %String(TRUNCATE = 1);

/// 病历结构ID，即打印模板在病历结构表中的RowID
Property EMRDocID As %String(TRUNCATE = 1);

/// 病历顺序号，对唯一病历，该值始终为1，对可重复病历的可重复模板，该值为相应的ListNo, 对可重复病历的唯一模板，该值为0
Property EMRNum As %Integer;

Property InstanceDataID As %String;

Property HappenDate As %Date;

Property HappenTime As %Time;

Property UserID As %String(TRUNCATE = 1);

Property Action As %String(TRUNCATE = 1);

Property IP As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EMRCustomLogsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EMRDocID</Value>
</Value>
<Value name="4">
<Value>EMRNum</Value>
</Value>
<Value name="5">
<Value>InstanceDataID</Value>
</Value>
<Value name="6">
<Value>HappenDate</Value>
</Value>
<Value name="7">
<Value>HappenTime</Value>
</Value>
<Value name="8">
<Value>UserID</Value>
</Value>
<Value name="9">
<Value>Action</Value>
</Value>
<Value name="10">
<Value>IP</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.EMRCustomLogsD</DataLocation>
<DefaultData>EMRCustomLogsDefaultData</DefaultData>
<IdLocation>^DHCEMRI.EMRCustomLogsD</IdLocation>
<IndexLocation>^DHCEMRI.EMRCustomLogsI</IndexLocation>
<StreamLocation>^DHCEMRI.EMRCustomLogsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
