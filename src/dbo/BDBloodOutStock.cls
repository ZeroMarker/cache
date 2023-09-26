///     
Class dbo.BDBloodOutStock Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_BloodOutStock, StorageStrategy = Default ]
{

Index IndexAddDate On (WorkGroupDR, AddDate) [ SqlName = Index_AddDate, Type = index ];

Index IndexCheckDate On (WorkGroupDR, CheckDate) [ SqlName = Index_CheckDate, Type = index ];

Index IndexMaster On (OutStockNo, TransactionDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDBloodOutStock On RowID [ PrimaryKey, SqlName = PK_BD_BloodOutStock, Type = index, Unique ];

/// Foreign Key FKBloodOutStockTransaction created via DDL
ForeignKey FKBloodOutStockTransaction(TransactionDR) References dbo.BBTransaction(PKBBTRANSACTION) [ SqlName = FK_BloodOutStock_Transaction ];

/// Foreign Key FKOutStockAddSYSUser created via DDL
ForeignKey FKOutStockAddSYSUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_OutStockAdd_SYSUser ];

/// Foreign Key FKOutStockAimBTWorkGroup created via DDL
ForeignKey FKOutStockAimBTWorkGroup(AimWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_OutStockAim_BTWorkGroup ];

/// Foreign Key FKOutStockBTWorkGroup created via DDL
ForeignKey FKOutStockBTWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_OutStock_BTWorkGroup ];

/// Foreign Key FKOutStockCheckSYSUser created via DDL
ForeignKey FKOutStockCheckSYSUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_OutStockCheck_SYSUser ];

/// Foreign Key FKOutStockBTWorkGroup created via DDL
ForeignKey FKOutStockExtHospital(ExtHospitalDR) References dbo.BBExtHospital(PKBBEXTHOSPITAL) [ SqlName = FK_OutStock_ExtHospital ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OutStockNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property TransactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Property AimWorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 14 ];

Property ExtHospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property SendWay As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 16 ];

Property PayWay As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BDBloodOutStockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OutStockNo</Value>
</Value>
<Value name="3">
<Value>TransactionDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>CheckDate</Value>
</Value>
<Value name="8">
<Value>CheckTime</Value>
</Value>
<Value name="9">
<Value>CheckUserDR</Value>
</Value>
<Value name="10">
<Value>WorkGroupDR</Value>
</Value>
<Value name="11">
<Value>AimWorkGroupDR</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>ExtHospitalDR</Value>
</Value>
<Value name="15">
<Value>SendWay</Value>
</Value>
<Value name="16">
<Value>PayWay</Value>
</Value>
</Data>
<DataLocation>^dbo.BDBloodOutStockD</DataLocation>
<DefaultData>BDBloodOutStockDefaultData</DefaultData>
<IdLocation>^dbo.BDBloodOutStockD</IdLocation>
<IndexLocation>^dbo.BDBloodOutStockI</IndexLocation>
<StreamLocation>^dbo.BDBloodOutStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
