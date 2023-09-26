///     
Class dbo.BBTransactionStatus Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_TransactionStatus, StorageStrategy = Default ]
{

/// Foreign Key FKBBTStatusStatusAfter created via DDL
ForeignKey FKBBTStatusStatusAfter(StatusAfterDR) References dbo.BBPackStatus(PKBBPACKSTATUS) [ SqlName = FK_BB_TStatus_StatusAfter ];

/// Foreign Key FKBBTStatusStatusBefore created via DDL
ForeignKey FKBBTStatusStatusBefore(StatusBeforeDR) References dbo.BBPackStatus(PKBBPACKSTATUS) [ SqlName = FK_BB_TStatus_StatusBefore ];

/// Foreign Key FKBBTStatusTran created via DDL
ForeignKey FKBBTStatusTran(TransactionDR) References dbo.BBTransaction(PKBBTRANSACTION) [ SqlName = FK_BB_TStatus_Tran ];

Index IndexAfterStatus On StatusAfterDR [ SqlName = Index_AfterStatus, Type = index ];

Index IndexBeforeStatus On StatusBeforeDR [ SqlName = Index_BeforeStatus, Type = index ];

Index IndexTransaction On TransactionDR [ SqlName = Index_Transaction, Type = index ];

/// DDL Primary Key Specification
Index PKBBTRANSACTIONSTATUS On RowID [ PrimaryKey, SqlName = PK_BB_TRANSACTIONSTATUS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TransactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property UseModule As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property StatusBeforeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property StatusAfterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 7 ];

Property IsSuperOnly As %Library.Boolean [ SqlColumnNumber = 8 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BBTransactionStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransactionDR</Value>
</Value>
<Value name="3">
<Value>UseModule</Value>
</Value>
<Value name="4">
<Value>StatusBeforeDR</Value>
</Value>
<Value name="5">
<Value>StatusAfterDR</Value>
</Value>
<Value name="6">
<Value>IsDefault</Value>
</Value>
<Value name="7">
<Value>IsSuperOnly</Value>
</Value>
<Value name="8">
<Value>SeqNum</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBTransactionStatusD</DataLocation>
<DefaultData>BBTransactionStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBTransactionStatusD</IdLocation>
<IndexLocation>^dbo.BBTransactionStatusI</IndexLocation>
<StreamLocation>^dbo.BBTransactionStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
