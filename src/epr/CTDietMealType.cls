Class epr.CTDietMealType Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Property MealTypeDR As User.DTCMealType;

Property OrderSets As list Of User.ARCOrdSets;

Property Code As %String(TRUNCATE = 1);

Property PrefOrderSetDR As User.ARCOrdSets;

Storage Default
{
<Data name="CTDietMealTypeState">
<Subscript>"epr.CTDietMealType"</Subscript>
<Value name="1">
<Value>MealTypeDR</Value>
</Value>
<Value name="2">
<Value>OrderSets</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>PrefOrderSet</Value>
</Value>
<Value name="5">
<Value>PrefOrderSetDR</Value>
</Value>
</Data>
<State>CTDietMealTypeState</State>
<StreamLocation>^epr.CTDietMealTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
