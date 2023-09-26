Class dhc.bonus.extend.UnitLeveSet Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UnitLeveSetID ]
{

Property UnitLeveCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property UnitLeveName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property UnitLeveShutcut As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property UnitLeveDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property SuperiorID As %Library.Integer [ SqlColumnNumber = 6 ];

Property UnitLeveOrder As %Library.Integer [ SqlColumnNumber = 7 ];

Property LastStage As %Library.Integer [ Required, SqlColumnNumber = 8 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 9 ];

Index ParentOrder On (SuperiorID, UnitLeveOrder);

Index UnitLeveCode On UnitLeveCode;

Storage Default
{
<Data name="UnitLeveSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UnitLeveCode</Value>
</Value>
<Value name="3">
<Value>UnitLeveName</Value>
</Value>
<Value name="4">
<Value>UnitLeveShutcut</Value>
</Value>
<Value name="5">
<Value>UnitLeveDesc</Value>
</Value>
<Value name="6">
<Value>SuperiorID</Value>
</Value>
<Value name="7">
<Value>LastStage</Value>
</Value>
<Value name="8">
<Value>UnitLeveOrder</Value>
</Value>
<Value name="9">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsUnitLeveSetD</DataLocation>
<DefaultData>UnitLeveSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsUnitLeveSetD</IdLocation>
<IndexLocation>^dhcbsUnitLeveSetI</IndexLocation>
<StreamLocation>^dhcbsUnitLeveSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
