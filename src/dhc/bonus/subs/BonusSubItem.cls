Class dhc.bonus.subs.BonusSubItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubItemID ]
{

Index SubsItemCode On SubItemCode As Exact;

Index SubsItemName On SubItemName As Exact;

Property SubItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property SubItemName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property SubItemType As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Property SuperiorItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 5 ];

//是否末级 0：否，1：是

Property LastStage As %Library.Integer [ Required, SqlColumnNumber = 6 ];

//有效用1,无效用0

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 7 ];

Property ItemPrice As %Library.Float [ SqlColumnNumber = 8 ];

Index ValidTypeUpID On (IsValid As exact, SuperiorItemID As exact);

Storage Default
{
<Data name="BonusSubItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubItemCode</Value>
</Value>
<Value name="3">
<Value>SubItemName</Value>
</Value>
<Value name="4">
<Value>SubItemType</Value>
</Value>
<Value name="5">
<Value>SuperiorItemID</Value>
</Value>
<Value name="6">
<Value>LastStage</Value>
</Value>
<Value name="7">
<Value>IsValid</Value>
</Value>
<Value name="8">
<Value>ItemPrice</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubItemD</DataLocation>
<DefaultData>BonusSubItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubItemD</IdLocation>
<IndexLocation>^dhcbsSubItemI</IndexLocation>
<StreamLocation>^dhcbsSubItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
