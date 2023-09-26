///     
Class dbo.BTEQAItemPlan Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EQAItemPlan, StorageStrategy = Default ]
{

Index IndexMaster On (EQAItemDR, StartYear) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBTEQAItEMPLAN On RowID [ PrimaryKey, SqlName = PK_BT_EQAItEMPLAN, Type = index, Unique ];

/// Foreign Key FKBTEQAItemPlanEQAItem created via DDL
ForeignKey FKBTEQAItemPlanEQAItem(EQAItemDR) References dbo.BTEQAItem(PKBTEQAITEM) [ SqlName = FK_BT_EQAItemPlan_EQAItem ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property EQAItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property StartYear As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property EndYear As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property SampleType As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property TestLevel As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7 ];

Property YearSpecimens As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

Property YearTests As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

Property TransportWay As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

Property Price As %Library.Float [ SqlColumnNumber = 11 ];

Property TargetMethod As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

Property ItemSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property Analytes As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 14 ];

Property JoinItemSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTEQAItemPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EQAItemDR</Value>
</Value>
<Value name="3">
<Value>StartYear</Value>
</Value>
<Value name="4">
<Value>EndYear</Value>
</Value>
<Value name="5">
<Value>SampleType</Value>
</Value>
<Value name="6">
<Value>TestLevel</Value>
</Value>
<Value name="7">
<Value>YearSpecimens</Value>
</Value>
<Value name="8">
<Value>YearTests</Value>
</Value>
<Value name="9">
<Value>TransportWay</Value>
</Value>
<Value name="10">
<Value>Price</Value>
</Value>
<Value name="11">
<Value>TargetMethod</Value>
</Value>
<Value name="12">
<Value>ItemSum</Value>
</Value>
<Value name="13">
<Value>Analytes</Value>
</Value>
<Value name="14">
<Value>JoinItemSum</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEQAItemPlanD</DataLocation>
<DefaultData>BTEQAItemPlanDefaultData</DefaultData>
<IdLocation>^dbo.BTEQAItemPlanD</IdLocation>
<IndexLocation>^dbo.BTEQAItemPlanI</IndexLocation>
<StreamLocation>^dbo.BTEQAItemPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
