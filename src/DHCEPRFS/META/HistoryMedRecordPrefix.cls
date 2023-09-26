Class DHCEPRFS.META.HistoryMedRecordPrefix Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Prefix As %String(TRUNCATE = 1);

Index IdxMain On Prefix [ Unique ];

Storage Default
{
<Data name="HistoryMedRecordPrefixDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Prefix</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.HistoryMPRD</DataLocation>
<DefaultData>HistoryMedRecordPrefixDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.HistoryMPRD</IdLocation>
<IndexLocation>^DHCEPRFS.META.HistoryMPRI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.HistoryMPRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
