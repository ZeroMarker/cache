/// 血液盘库单
Class dbo.BDStockCheck Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_StockCheck ]
{

/// Foreign Key FKBDStockCheckWorkGroupDR created via DDL
ForeignKey FKBDStockCheckWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BDStockCheckWorkGroupDR ];

/// Foreign Key FKBDStockCheckAddUserDR created via DDL
ForeignKey FKBDStockCheckAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDStockCheckAddUserDR ];

/// Foreign Key FKBDStockCheckCheckUserDR created via DDL
ForeignKey FKBDStockCheckCheckUserDR(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDStockCheckCheckUserDR ];

/// Foreign Key FKBDStockCheckCancelUserDR created via DDL
ForeignKey FKBDStockCheckCancelUserDR(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDStockCheckCancelUserDR ];

/// DDL Primary Key Specification
Index PKBDSTOCKCHECK On RowID [ PrimaryKey, SqlName = PK_BD_STOCKCHECK, Type = index, Unique ];

Index IndexMaster On StockCheckNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroup On (WorkGroupDR, CheckDate) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 盘库单号
Property StockCheckNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 添加日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 添加时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 添加人
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 审核日期
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 审核时间
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 审核人
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 状态 10:新建 20:审核 30:作废
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ Required, SqlColumnNumber = 11 ];

/// 备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 12 ];

/// 作废日期
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 作废时间
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 作废人
Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BDStockCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StockCheckNo</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
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
<Value>Status</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>CancelDate</Value>
</Value>
<Value name="13">
<Value>CancelTime</Value>
</Value>
<Value name="14">
<Value>CancelUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDStockCheckD</DataLocation>
<DefaultData>BDStockCheckDefaultData</DefaultData>
<IdLocation>^dbo.BDStockCheckD</IdLocation>
<IndexLocation>^dbo.BDStockCheckI</IndexLocation>
<StreamLocation>^dbo.BDStockCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
