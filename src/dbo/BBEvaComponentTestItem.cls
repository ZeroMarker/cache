///     
Class dbo.BBEvaComponentTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_EvaComponentTestItem, StorageStrategy = Default ]
{

Index IndexMaster On (BloodComponentsDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBloodComponentsTestItem On RowID [ PrimaryKey, SqlName = PK_BB_BloodComponentsTestItem_1, Type = index, Unique ];

/// Foreign Key FKBldComponentsTestItemBldComponents created via DDL
ForeignKey FKTestItemBldComponents(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_TestItem_BldComponents ];

/// Foreign Key FKBldComponentsTestItemTestItem created via DDL
ForeignKey FKBldComponentsTestItemTestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BldComponentsTestItem_TestItem ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBEvaComponentTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodComponentsDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBEvaComponentTestItemD</DataLocation>
<DefaultData>BBEvaComponentTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BBEvaComponentTestItemD</IdLocation>
<IndexLocation>^dbo.BBEvaComponentTestItemI</IndexLocation>
<StreamLocation>^dbo.BBEvaComponentTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
