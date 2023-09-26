Class EMRmeta.PowerAction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Parameter TraceYes = "Y";

Parameter TraceNo = "N";

Property Alias As %Library.String(TRUNCATE = 1);

Property Code As %Library.String(TRUNCATE = 1);

Property BeforeStatus As %Library.String(TRUNCATE = 1);

Property AfterStatus As %Library.String(TRUNCATE = 1);

Property Description As %Library.String(TRUNCATE = 1);

/// value: TraceYes, TraceNo
Property TraceTrigger As %Library.String(TRUNCATE = 1);

Storage Default
{
<Data name="PowerActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionAfterStatus</Value>
</Value>
<Value name="3">
<Value>ActionAlias</Value>
</Value>
<Value name="4">
<Value>ActionBeforeStatus</Value>
</Value>
<Value name="5">
<Value>ActionCode</Value>
</Value>
<Value name="6">
<Value>ActionDesc</Value>
</Value>
<Value name="7">
<Value>ActionTraceTrigger</Value>
</Value>
<Value name="8">
<Value>AfterStatus</Value>
</Value>
<Value name="9">
<Value>Alias</Value>
</Value>
<Value name="10">
<Value>BeforeStatus</Value>
</Value>
<Value name="11">
<Value>Code</Value>
</Value>
<Value name="12">
<Value>Description</Value>
</Value>
<Value name="13">
<Value>TraceTrigger</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PowerActionD</DataLocation>
<DefaultData>PowerActionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.PowerActionD</IdLocation>
<IndexLocation>^DHCEMRM.PowerActionI</IndexLocation>
<StreamLocation>^DHCEMRM.PowerActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
