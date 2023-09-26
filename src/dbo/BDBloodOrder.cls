///     
Class dbo.BDBloodOrder Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_BloodOrder, StorageStrategy = Default ]
{

/// Foreign Key FKBDBOrderAddUser created via DDL
ForeignKey FKBDBOrderAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_BOrder_AddUser ];

/// Foreign Key FKBDBOrderCancelUser created via DDL
ForeignKey FKBDBOrderCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_BOrder_CancelUser ];

/// Foreign Key FKBDBOrderCheckUser created via DDL
ForeignKey FKBDBOrderCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_BOrder_CheckUser ];

/// Foreign Key FKBDBOrderSupplier created via DDL
ForeignKey FKBDBOrderSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BD_BOrder_Supplier ];

/// Foreign Key FKBDBOrderWorkGroup created via DDL
ForeignKey FKBDBOrderWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_BOrder_WorkGroup ];

ForeignKey FKBDBOrderSendUser(SendUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_BOrder_SendUser ];

Index IndexAddDate On (AddDate, WorkGroupDR) [ SqlName = Index_AddDate, Type = index ];

Index IndexCheckDate On (CheckDate, WorkGroupDR) [ SqlName = Index_CheckDate, Type = index ];

Index IndexUseDate On (UseDate, WorkGroupDR) [ SqlName = Index_UseDate, Type = index ];

Index IndexMaster On OrderNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSupplier On (SupplierDR, CheckDate) [ SqlName = Index_Supplier, Type = index ];

/// DDL Primary Key Specification
Index PKBDBLOODORDER On RowID [ PrimaryKey, SqlName = PK_BD_BLOODORDER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrderNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property DeliverWay As %Library.SmallInt [ SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 15 ];

Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 16 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 17 ];

Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property SendUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property OrderType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 21 ];

Property BookType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 22 ];

Property UseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property UseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Property ACKDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Property ACKTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Property ACKRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 27 ];

Storage Default
{
<Data name="BDBloodOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderNo</Value>
</Value>
<Value name="3">
<Value>SupplierDR</Value>
</Value>
<Value name="4">
<Value>DeliverWay</Value>
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
<Value>WorkGroupDR</Value>
</Value>
<Value name="15">
<Value>Status</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
<Value name="17">
<Value>SendDate</Value>
</Value>
<Value name="18">
<Value>SendTime</Value>
</Value>
<Value name="19">
<Value>SendUserDR</Value>
</Value>
<Value name="20">
<Value>OrderType</Value>
</Value>
<Value name="21">
<Value>BookType</Value>
</Value>
<Value name="22">
<Value>UseDate</Value>
</Value>
<Value name="23">
<Value>UseTime</Value>
</Value>
<Value name="24">
<Value>ACKDate</Value>
</Value>
<Value name="25">
<Value>ACKTime</Value>
</Value>
<Value name="26">
<Value>ACKRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDBloodOrderD</DataLocation>
<DefaultData>BDBloodOrderDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDBloodOrderD</IdLocation>
<IndexLocation>^dbo.BDBloodOrderI</IndexLocation>
<StreamLocation>^dbo.BDBloodOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
