/// VIP体检人次                                                                                                           
Class dhc.bonus.subs.BonusTJPersonCount Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusTJPersonCountID ]
{

Property DeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property CheakNums As %Library.Integer [ SqlColumnNumber = 3 ];

Property CheakDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property InDate As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BonusTJPersonCountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptCode</Value>
</Value>
<Value name="3">
<Value>CheakNums</Value>
</Value>
<Value name="4">
<Value>CheakDate</Value>
</Value>
<Value name="5">
<Value>InDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsTJPersonCountD</DataLocation>
<DefaultData>BonusTJPersonCountDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsTJPersonCountD</IdLocation>
<IndexLocation>^dhcbsTJPersonCountI</IndexLocation>
<StreamLocation>^dhcbsTJPersonCountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
