/// 资源区病历引用项目定义
Class EPRmeta.CT.ResMedRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property RecordName As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property RecordType As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property PrintDocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property ContentScheme As %String(MAXLEN = 10240, TRUNCATE = 1) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Integer [ SqlColumnNumber = 6 ];

Property Title As %String [ SqlColumnNumber = 7 ];

Index IdxRecordName On (RecordName, Sequence);

Storage Default
{
<Data name="ResMedRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordName</Value>
</Value>
<Value name="3">
<Value>RecordType</Value>
</Value>
<Value name="4">
<Value>PrintDocID</Value>
</Value>
<Value name="5">
<Value>ContentScheme</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Title</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CT.ResMedRecordD</DataLocation>
<DefaultData>ResMedRecordDefaultData</DefaultData>
<IdLocation>^DHCEPRM.CT.ResMedRecordD</IdLocation>
<IndexLocation>^DHCEPRM.CT.ResMedRecordI</IndexLocation>
<StreamLocation>^DHCEPRM.CT.ResMedRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
