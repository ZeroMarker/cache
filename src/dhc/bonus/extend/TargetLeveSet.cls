Class dhc.bonus.extend.TargetLeveSet Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TargetLeveSetID ]
{

Property TargetLeveCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property TargetLeveName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property TargetLeveShutcut As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property TargetLeveDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property SuperiorID As %Library.Integer [ Required, SqlColumnNumber = 6 ];

Property TargetLeveOrder As %Library.Integer [ SqlColumnNumber = 7 ];

Property LastStage As %Library.Integer [ Required, SqlColumnNumber = 8 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="TargetLeveSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TargetLeveCode</Value>
</Value>
<Value name="3">
<Value>TargetLeveName</Value>
</Value>
<Value name="4">
<Value>TargetLeveShutcut</Value>
</Value>
<Value name="5">
<Value>TargetLeveDesc</Value>
</Value>
<Value name="6">
<Value>SuperiorID</Value>
</Value>
<Value name="7">
<Value>TargetLeveOrder</Value>
</Value>
<Value name="8">
<Value>LastStage</Value>
</Value>
<Value name="9">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsTargetLeveSetD</DataLocation>
<DefaultData>TargetLeveSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsTargetLeveSetD</IdLocation>
<IndexLocation>^dhcbsTargetLeveSet</IndexLocation>
<StreamLocation>^dhcbsTargetLeveSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
