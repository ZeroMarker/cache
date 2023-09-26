/// FA奖金方案项目
Class dhc.bonus.data.BonusSchemeItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSchemeItemID ]
{

Index BonusType On BonusType As Exact;

Index SchemeItemCode On SchemeItemCode As Exact;

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 2 ];

Property BonusItemTypeID As dhc.bonus.data.BonusItemType [ SqlColumnNumber = 3 ];

Property SchemeItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property SchemeItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property DataSource As %Library.Integer [ SqlColumnNumber = 6 ];

Property BonusFormula As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property BonusFormulaDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property BonusType As %Library.Integer [ Required, SqlColumnNumber = 9 ];

Property CalculatePriority As %Library.Integer [ Required, SqlColumnNumber = 10 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 11 ];

Property UpdateDate As %Library.Date [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BonusSchemeItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemeID</Value>
</Value>
<Value name="3">
<Value>SchemeItemCode</Value>
</Value>
<Value name="4">
<Value>SchemeItemName</Value>
</Value>
<Value name="5">
<Value>BonusItemTypeID</Value>
</Value>
<Value name="6">
<Value>DataSource</Value>
</Value>
<Value name="7">
<Value>BonusFormula</Value>
</Value>
<Value name="8">
<Value>BonusFormulaDesc</Value>
</Value>
<Value name="9">
<Value>BonusType</Value>
</Value>
<Value name="10">
<Value>CalculatePriority</Value>
</Value>
<Value name="11">
<Value>IsValid</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusSchemeItemD</DataLocation>
<DefaultData>BonusSchemeItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusSchemeItemD</IdLocation>
<IndexLocation>^dhcbsBonusSchemeItemI</IndexLocation>
<StreamLocation>^dhcbsBonusSchemeItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
