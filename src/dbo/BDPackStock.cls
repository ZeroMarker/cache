/// 血液盘库单
Class dbo.BDPackStock Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackStock ]
{

Index IndexMaster On PackStockNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAddDate On (WorkGroupDR, AddDate) [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexCheckDate On (WorkGroupDR, CheckDate) [ SqlName = Index_CheckDate, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

/// DDL Primary Key Specification
Index PKPACKSTOCK On RowID [ PrimaryKey, SqlName = PK_BD_PACKSTOCK, Type = index, Unique ];

/// Foreign Key FKBDStockAddUser created via DDL
ForeignKey FKBDStockAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Stock_AddUser ];

/// Foreign Key FKBDStockCheckUser created via DDL
ForeignKey FKBDStockCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Stock_CheckUser ];

/// Foreign Key FKBDStockCheckUser created via DDL
ForeignKey FKBDStockDisUser(DisUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Stock_DisUser ];

/// Foreign Key FKBDStockOutUser created via DDL
ForeignKey FKBDStockOutUser(StockOutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Stock_OutUser ];

/// Foreign Key FKBDStockWorkGroup created via DDL
ForeignKey FKBDStockWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_Stock_WorkGroup ];

/// Foreign Key FKBDStockOutStock created via DDL
ForeignKey FKBDStockOutStock(BloodOutStockDR) References dbo.BDBloodOutStock(PKBDBloodOutStock) [ SqlName = FK_BD_Stock_OutStock ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property PackStockNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

/// 10:新建 20:审核 30:盘点出库 40:作废
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 12 ];

Property DisDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property DisTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property DisUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 盘点出库对应时间节点记录，其对应的数据可在盘点出库记录中详细查到
Property StockOutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property StockOutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property StockOutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property BloodOutStockDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="BDPackStockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackStockNo</Value>
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
<Value>WorkGroupDR</Value>
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
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>DisDate</Value>
</Value>
<Value name="13">
<Value>DisTime</Value>
</Value>
<Value name="14">
<Value>DisUserDR</Value>
</Value>
<Value name="15">
<Value>SotckOutDate</Value>
</Value>
<Value name="16">
<Value>StockOutTime</Value>
</Value>
<Value name="17">
<Value>StockOutUserDR</Value>
</Value>
<Value name="18">
<Value>BloodOutStockDR</Value>
</Value>
<Value name="19">
<Value>StockOutDate</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackStockD</DataLocation>
<DefaultData>BDPackStockDefaultData</DefaultData>
<IdLocation>^dbo.BDPackStockD</IdLocation>
<IndexLocation>^dbo.BDPackStockI</IndexLocation>
<StreamLocation>^dbo.BDPackStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
