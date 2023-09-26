Class epr.CTDietDay Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Property Meals As list Of epr.CTDietMealType;

Property Description As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CTDietDayState">
<Subscript>"epr.CTDietDay"</Subscript>
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Meals</Value>
</Value>
</Data>
<State>CTDietDayState</State>
<StreamLocation>^epr.CTDietDayS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
