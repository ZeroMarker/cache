Class epr.CTDietType Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

Parameter SQLDATEFROM = "DateFrom";

Parameter SQLDATETO;

Parameter SQLCODE = "Code";

Parameter SQLDESCRIPTION = "Description";

Parameter SQLROWID = "ID";

Property Code As %String(TRUNCATE = 1);

Property Cycles As list Of epr.CTDietCycle;

Property DateFrom As %Date;

Property Description As %String(TRUNCATE = 1);

Property FirstCycleSttDate As %Date;

Property LenOfCycle As %Integer;

Property NumOfCycles As %Integer;

Property Active As %String(TRUNCATE = 1);

Property OrigMealType As %String(TRUNCATE = 1);

Property CTLocDR As User.CTLoc;

Property CTHospDR As User.CTHospital;

Storage Default
{
<Data name="CTDietTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Cycles</Value>
</Value>
<Value name="4">
<Value>DateFrom</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>FirstCycleSttDate</Value>
</Value>
<Value name="7">
<Value>LenOfCycle</Value>
</Value>
<Value name="8">
<Value>NumOfCycles</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>OrigMealType</Value>
</Value>
<Value name="11">
<Value>CTLocDR</Value>
</Value>
<Value name="12">
<Value>CTHospDR</Value>
</Value>
</Data>
<DataLocation>^epr.CTDietTypeD</DataLocation>
<DefaultData>CTDietTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTDietTypeD</IdLocation>
<IndexLocation>^epr.CTDietTypeI</IndexLocation>
<StreamLocation>^epr.CTDietTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
