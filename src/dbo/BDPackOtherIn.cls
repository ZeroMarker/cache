///     
Class dbo.BDPackOtherIn Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackOtherIn, StorageStrategy = Default ]
{

/// Foreign Key FKAddUserPackOtherIn created via DDL
ForeignKey FKAddUserPackOtherIn(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AddUser_PackOtherIn ];

/// Foreign Key FKCheckUserPackOtherIn created via DDL
ForeignKey FKCheckUserPackOtherIn(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CheckUser_PackOtherIn ];

/// Foreign Key FKTransactionPackOtherIn created via DDL
ForeignKey FKTransactionPackOtherIn(TransactionDR) References dbo.BBTransaction(PKBBTRANSACTION) [ SqlName = FK_Transaction_PackOtherIn ];

/// Foreign Key FKWorkGroupPackOtherIn created via DDL
ForeignKey FKWorkGroupPackOtherIn(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroup_PackOtherIn ];

Index IndexAddDate On (AddDate, WorkGroupDR) [ SqlName = Index_AddDate, Type = index ];

Index IndexCheckDate On (CheckDate, WorkGroupDR) [ SqlName = Index_CheckDate, Type = index ];

Index IndexMaster On PackOtherInNo [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKPackOtherIn On RowID [ PrimaryKey, SqlName = PK_Pack_OtherIn, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PackOtherInNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property TransactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BDPackOtherInDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackOtherInNo</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>CheckDate</Value>
</Value>
<Value name="7">
<Value>CheckTime</Value>
</Value>
<Value name="8">
<Value>CheckUserDR</Value>
</Value>
<Value name="9">
<Value>WorkGroupDR</Value>
</Value>
<Value name="10">
<Value>TransactionDR</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackOtherInD</DataLocation>
<DefaultData>BDPackOtherInDefaultData</DefaultData>
<IdLocation>^dbo.BDPackOtherInD</IdLocation>
<IndexLocation>^dbo.BDPackOtherInI</IndexLocation>
<StreamLocation>^dbo.BDPackOtherInS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
