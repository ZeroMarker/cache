/// 血袋入库单
Class dbo.BDPackIn Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackIn, StorageStrategy = Default ]
{

/// Foreign Key FKBDPackInAddUser created via DDL
ForeignKey FKBDPackInAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PackIn_AddUser ];

/// Foreign Key FKBDPackInSupplier created via DDL
ForeignKey FKBDPackInSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BD_PackIn_Supplier ];

/// Foreign Key FKBDPackInWorkGroup created via DDL
ForeignKey FKBDPackInWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_PackIn_WorkGroup ];

/// Foreign Key FKBDPackInWorkGroup created via DDL
ForeignKey FKBDPackInTransaction(TransactionDR) References dbo.BBTransaction(PKBBTRANSACTION) [ SqlName = FK_BD_PackIn_Transaction ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexMaster On PackInNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSupplier On (SupplierDR, AddDate) [ SqlName = Index_Supplier, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKIN On RowID [ PrimaryKey, SqlName = PK_BD_PACKIN, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 入库单号  
Property PackInNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 血站  
Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 血站出库单号  
Property SupplierOutNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 增加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 增加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 增加用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

/// 入库类型  1 血站血液入库 2 自体血入库 3 其他入库（取消出库）
Property OPType As %Library.SmallInt [ SqlColumnNumber = 11 ];

/// 关联出库单号  
Property OutStockNo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

/// 处理事件  
Property TransactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 审核用户  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 状态  10 登记 20 审核
Property Status As %Library.SmallInt [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BDPackInDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackInNo</Value>
</Value>
<Value name="3">
<Value>SupplierDR</Value>
</Value>
<Value name="4">
<Value>SupplierOutNo</Value>
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
<Value>WorkGroupDR</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>OPType</Value>
</Value>
<Value name="11">
<Value>OutStockNo</Value>
</Value>
<Value name="12">
<Value>TransactionDR</Value>
</Value>
<Value name="13">
<Value>CheckDate</Value>
</Value>
<Value name="14">
<Value>CheckTime</Value>
</Value>
<Value name="15">
<Value>CheckUserDR</Value>
</Value>
<Value name="16">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackInD</DataLocation>
<DefaultData>BDPackInDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDPackInD</IdLocation>
<IndexLocation>^dbo.BDPackInI</IndexLocation>
<StreamLocation>^dbo.BDPackInS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
