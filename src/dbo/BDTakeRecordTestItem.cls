///     
Class dbo.BDTakeRecordTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TakeRecordTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKBDTRTITakeRecord created via DDL
ForeignKey FKBDTRTITakeRecord(TakeRecordDR) References dbo.BDTakeRecord(PKBDTAKERECORD) [ SqlName = FK_BD_TRTI_TakeRecord ];

/// Foreign Key FKBDTRTIitem created via DDL
ForeignKey FKBDTRTIitem(TakeTestItemDR) References dbo.BBTakeTestItem(PKBBTAKETESTITEM) [ SqlName = FK_BD_TRTI_item ];

Index IndexMaster On (TakeRecordDR, TakeTestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDTAKERECORDTESTITEM On RowID [ PrimaryKey, SqlName = PK_BD_TAKERECORDTESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TakeRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TakeTestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDTakeRecordTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TakeRecordDR</Value>
</Value>
<Value name="3">
<Value>TakeTestItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Unit</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTakeRecordTestItemD</DataLocation>
<DefaultData>BDTakeRecordTestItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDTakeRecordTestItemD</IdLocation>
<IndexLocation>^dbo.BDTakeRecordTestItemI</IndexLocation>
<StreamLocation>^dbo.BDTakeRecordTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
