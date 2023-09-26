///     
Class dbo.BDAutologousAssTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AutologousAssTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKAutoAssTestIteAutoAss created via DDL
ForeignKey FKAutoAssTestIteAutoAss(AutologousAssDR) References dbo.BDAutologousAss(PKBDAutologousAss) [ SqlName = FKAutoAssTestIteAutoAss ];

/// Foreign Key FKAutoAssTestItem created via DDL
ForeignKey FKAutoAssTestItem(TestItemDR) References dbo.BBAutologousAssTestItem(PKBBAutologousAssTestItem) [ SqlName = FKAutoAssTestItem ];

/// DDL Primary Key Specification
Index PKBDAutologousAssTestItem On RowID [ PrimaryKey, SqlName = PK_BD_AutologousAssTestItem, Type = index, Unique ];

Index IndexMaster On (AutologousAssDR, TestItemDR) [ SqlName = Index_Master, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property AutologousAssDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestItemRes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property IsTestItemFit As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDAutologousAssTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AutologousAssDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>TestItemRes</Value>
</Value>
<Value name="5">
<Value>IsTestItemFit</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAutologousAssTestItemD</DataLocation>
<DefaultData>BDAutologousAssTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BDAutologousAssTestItemD</IdLocation>
<IndexLocation>^dbo.BDAutologousAssTestItemI</IndexLocation>
<StreamLocation>^dbo.BDAutologousAssTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
