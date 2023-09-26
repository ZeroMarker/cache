Class CT.STER.CSSD.PrintRules Extends %Persistent [ SqlTableName = PrintRules ]
{

/// 打印代码
Property PRCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = PR_Code ];

/// 打印描述
Property PRDesc As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = PR_Desc ];

Index CSSDPRCode On PRCode As Exact;

Storage Default
{
<Data name="PrintRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PRCode</Value>
</Value>
<Value name="3">
<Value>PRDesc</Value>
</Value>
</Data>
<DataLocation>^CT.STER.CSSD.PrintRulesD</DataLocation>
<DefaultData>PrintRulesDefaultData</DefaultData>
<IdLocation>^CT.STER.CSSD.PrintRulesD</IdLocation>
<IndexLocation>^CT.STER.CSSD.PrintRulesI</IndexLocation>
<StreamLocation>^CT.STER.CSSD.PrintRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
