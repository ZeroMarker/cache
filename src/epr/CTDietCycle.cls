Class epr.CTDietCycle Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Property Day As list Of epr.CTDietDay;

Property Description As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CTDietCycleState">
<Subscript>"epr.CTDietCycle"</Subscript>
<Value name="1">
<Value>Day</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
</Data>
<State>CTDietCycleState</State>
<StreamLocation>^epr.CTDietCycleS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
