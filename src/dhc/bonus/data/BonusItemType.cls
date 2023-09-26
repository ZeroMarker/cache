/// FA奖金项目类别
Class dhc.bonus.data.BonusItemType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusItemTypeID ]
{

Index Code On BonusItemTypeCode As Exact;

Index Name On BonusItemTypeName As Exact;

Property BonusItemTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusItemTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusItemTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusItemTypeCode</Value>
</Value>
<Value name="3">
<Value>BonusItemTypeName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusItemTypeD</DataLocation>
<DefaultData>BonusItemTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusItemTypeD</IdLocation>
<IndexLocation>^dhcbsBonusItemTypeI</IndexLocation>
<StreamLocation>^dhcbsBonusItemTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
