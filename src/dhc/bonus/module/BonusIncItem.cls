/// 收入项目字典
Class dhc.bonus.module.BonusIncItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusIncItemID ]
{

//项目编码

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

//项目名称

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//是否核算

Property IsValid As %Library.Integer [ SqlColumnNumber = 4 ];

Property UpdateDate As %Library.String [ SqlColumnNumber = 5 ];

Index BonusIncItemIdx On ItemCode;

Storage Default
{
<Data name="BonusIncItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsmodule.BonusIncItemD</DataLocation>
<DefaultData>BonusIncItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmodule.BonusIncItemD</IdLocation>
<IndexLocation>^dhcbsmodule.BonusIncItemI</IndexLocation>
<StreamLocation>^dhcbsmodule.BonusIncItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
