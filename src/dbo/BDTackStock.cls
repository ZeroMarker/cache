///     
Class dbo.BDTackStock Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TackStock, StorageStrategy = Default ]
{

/// Foreign Key FKBDTStockAddUser created via DDL
ForeignKey FKBDTStockAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TStock_AddUser ];

/// Foreign Key FKBDTStockCancelUser created via DDL
ForeignKey FKBDTStockCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TStock_CancelUser ];

/// Foreign Key FKBDTStockCheckUser created via DDL
ForeignKey FKBDTStockCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TStock_CheckUser ];

/// Foreign Key FKBDTStockWorkGroup created via DDL
ForeignKey FKBDTStockWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_TStock_WorkGroup ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On AddUserDR [ SqlName = Index_AddUser, Type = index ];

Index IndexCancelDate On CancelDate [ SqlName = Index_CancelDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexTackStockNo On TackStockNo [ SqlName = Index_TackStockNo, Type = index, Unique ];

Index IndexWorkGroupDR On WorkGroupDR [ SqlName = Index_WorkGroupDR, Type = index ];

/// DDL Primary Key Specification
Index PKBDTACKSTOCK On RowID [ PrimaryKey, SqlName = PK_BD_TACKSTOCK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TackStockNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BDTackStockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TackStockNo</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>CheckDate</Value>
</Value>
<Value name="9">
<Value>CheckTime</Value>
</Value>
<Value name="10">
<Value>CheckUserDR</Value>
</Value>
<Value name="11">
<Value>CancelDate</Value>
</Value>
<Value name="12">
<Value>CancelTime</Value>
</Value>
<Value name="13">
<Value>CancelUserDR</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTackStockD</DataLocation>
<DefaultData>BDTackStockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDTackStockD</IdLocation>
<IndexLocation>^dbo.BDTackStockI</IndexLocation>
<StreamLocation>^dbo.BDTackStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
