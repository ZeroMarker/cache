///     
Class dbo.BBAGTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AGTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKAGTestItem created via DDL
ForeignKey FKAGTestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_AGTestItem ];

/// Foreign Key FKAGTestItemHospital created via DDL
ForeignKey FKAGTestItemHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_AGTestItem_Hospital ];

Index IndexMaster On (AGType, HospitalDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (AGType, HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBAGTESTITEM On RowID [ PrimaryKey, SqlName = PK_BB_AGTESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ Required, SqlColumnNumber = 3 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property IsPrompt As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property ResultList As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

Property Days As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BBAGTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGType</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>TestItemDR</Value>
</Value>
<Value name="5">
<Value>IsPrompt</Value>
</Value>
<Value name="6">
<Value>ResultList</Value>
</Value>
<Value name="7">
<Value>Days</Value>
</Value>
<Value name="8">
<Value>SeqNum</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAGTestItemD</DataLocation>
<DefaultData>BBAGTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BBAGTestItemD</IdLocation>
<IndexLocation>^dbo.BBAGTestItemI</IndexLocation>
<StreamLocation>^dbo.BBAGTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
