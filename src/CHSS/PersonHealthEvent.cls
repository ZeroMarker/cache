Class CHSS.PersonHealthEvent Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = EventRowId, SqlTableName = PersonHealthEvent ]
{

/// EventType
Property EventType As %Library.Integer;

/// EventName
Property EventName As %Library.Integer;

/// EventDate
Property EventDate As %Library.Date;

/// Remark
Property Remark As %Library.String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="PersonHealthEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>DetailEventDate</Value>
</Value>
<Value name="4">
<Value>DetailEventName</Value>
</Value>
<Value name="5">
<Value>DetailEventType</Value>
</Value>
<Value name="6">
<Value>EventRowId</Value>
</Value>
<Value name="7">
<Value>Remak</Value>
</Value>
<Value name="8">
<Value>EventDate</Value>
</Value>
<Value name="9">
<Value>EventName</Value>
</Value>
<Value name="10">
<Value>EventType</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHealthEventD</DataLocation>
<DefaultData>PersonHealthEventDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHealthEventD</IdLocation>
<IndexLocation>^CHSS.PersonHealthEventI</IndexLocation>
<StreamLocation>^CHSS.PersonHealthEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
