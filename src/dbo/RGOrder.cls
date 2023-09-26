/// RGOrder
Class dbo.RGOrder Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_Order, StorageStrategy = Default ]
{

Index IndexCancelDate On CancelDate [ SqlName = Index_CancelDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index IndexOrderNo On OrderNo [ SqlName = Index_OrderNo, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexSupplier On SupplierDR [ SqlName = Index_Supplier, Type = index ];

/// DDL Primary Key Specification
Index PKRGORDER On RowID [ PrimaryKey, SqlName = PK_RG_ORDER, Type = index, Unique ];

/// Foreign Key FKRGOrderCanceller created via DDL
ForeignKey FKRGOrderCanceller(CancellerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Order_Canceller ];

/// Foreign Key FKRGOrderChecker created via DDL
ForeignKey FKRGOrderChecker(CheckerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Order_Checker ];

/// Foreign Key FKRGOrderCreator created via DDL
ForeignKey FKRGOrderCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Order_Creator ];

/// Foreign Key FKRGOrderGroup created via DDL
ForeignKey FKRGOrderGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Order_Group ];

/// Foreign Key FKRGOrderSupplier created via DDL
ForeignKey FKRGOrderSupplier(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_Order_Supplier ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 采购单号  
Property OrderNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 试剂小组  
Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 供应商  
Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 采购周期  
Property PurchasePeriod As %Library.Float [ Required, SqlColumnNumber = 6 ];

/// 状态  
Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 入库状态  
Property StkInStatus As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 创建日期  
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 创建时间  
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 创建人  
Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 审核人  
Property CheckerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 取消日期  
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 取消时间  
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 取消人  
Property CancellerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 取消原因  
Property CancelReason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 18 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 19 ];

///       
Property Urgent As %Library.Boolean [ SqlColumnNumber = 20 ];

Property TotalPrice As %Library.Double [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="RGOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderNo</Value>
</Value>
<Value name="3">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="4">
<Value>SupplierDR</Value>
</Value>
<Value name="5">
<Value>PurchasePeriod</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>CreatorDR</Value>
</Value>
<Value name="10">
<Value>CheckDate</Value>
</Value>
<Value name="11">
<Value>CheckTime</Value>
</Value>
<Value name="12">
<Value>CheckerDR</Value>
</Value>
<Value name="13">
<Value>CancelDate</Value>
</Value>
<Value name="14">
<Value>CancelTime</Value>
</Value>
<Value name="15">
<Value>CancellerDR</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
<Value name="17">
<Value>CancelReason</Value>
</Value>
<Value name="18">
<Value>StkInStatus</Value>
</Value>
<Value name="19">
<Value>Urgent</Value>
</Value>
<Value name="20">
<Value>TotalPrice</Value>
</Value>
</Data>
<DataLocation>^dbo.RGOrderD</DataLocation>
<DefaultData>RGOrderDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGOrderD</IdLocation>
<IndexLocation>^dbo.RGOrderI</IndexLocation>
<StreamLocation>^dbo.RGOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
