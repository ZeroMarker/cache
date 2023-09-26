Class EMRinstance.FileStoreAdm Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PatientID As %String [ Required, SqlColumnNumber = 2 ];

Property EpisodeID As %String [ Required, SqlColumnNumber = 3 ];

Property AdmDate As %Date [ Required, SqlColumnNumber = 4 ];

Index IdxDate On AdmDate;

Index IdxEpisodeID On EpisodeID [ Unique ];

Storage Default
{
<Data name="FileStoreAdmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>AdmDate</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.FileStoreAdmD</DataLocation>
<DefaultData>FileStoreAdmDefaultData</DefaultData>
<IdLocation>^DHCEMRI.FileStoreAdmD</IdLocation>
<IndexLocation>^DHCEMRI.FileStoreAdmI</IndexLocation>
<StreamLocation>^DHCEMRI.FileStoreAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
