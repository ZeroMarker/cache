Class User.DHCMarkDoc Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCMarkDoc ]
{

Index MarkdDocMarkIndex On (MarkdDocDr, MarkdMarkDr);

Index MarkMarkDocIndex On (MarkdMarkDr, MarkdDocDr);

Index MarkddepDrIndex On MarkddepDr;

Property MarkdDocDr As CTCareProv;

Property MarkdMarkDr As CTCareProv;

Property MarkddepDr As CTLoc;

Property Markddefault As %String;

Storage Default
{
<Data name="DHCMarkDocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MarkdDocDr</Value>
</Value>
<Value name="3">
<Value>MarkdMarkDr</Value>
</Value>
<Value name="4">
<Value>MarkddepDr</Value>
</Value>
<Value name="5">
<Value>Markddefault</Value>
</Value>
</Data>
<DataLocation>^User.DHCMarkDocD</DataLocation>
<DefaultData>DHCMarkDocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMarkDocD</IdLocation>
<IndexLocation>^User.DHCMarkDocI</IndexLocation>
<StreamLocation>^User.DHCMarkDocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
