Class User.DHCExaBorDep Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCExaBorDep ]
{

Index BordBorDrIndex On BordBorDr;

Index BordDepDrIndex On BordDepDr;

Property BordBorDr As DHCExaBorough;

Property BordDepDr As User.CTLoc;

Property BordMemo As %String(MAXLEN = 255, TRUNCATE = 1);

Storage Default
{
<Data name="DHCExaBorDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExarBorDr</Value>
</Value>
<Value name="3">
<Value>ExarCode</Value>
</Value>
<Value name="4">
<Value>ExarMemo</Value>
</Value>
<Value name="5">
<Value>ExarName</Value>
</Value>
<Value name="6">
<Value>BordBorDr</Value>
</Value>
<Value name="7">
<Value>BordDepDr</Value>
</Value>
<Value name="8">
<Value>BordMemo</Value>
</Value>
</Data>
<DataLocation>^User.DHCExaBorDepD</DataLocation>
<DefaultData>DHCExaBorDepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCExaBorDepD</IdLocation>
<IndexLocation>^User.DHCExaBorDepI</IndexLocation>
<StreamLocation>^User.DHCExaBorDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
