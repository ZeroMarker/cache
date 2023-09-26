///     
Class dbo.RGStkIn Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkIn, StorageStrategy = Default ]
{

Index IndexCancelDate On CancelDate [ SqlName = Index_CancelDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexStkInNo On StkInNo [ SqlName = Index_StkInNo, Type = index, Unique ];

Index IndexSupplier On SupplierDR [ SqlName = Index_Supplier, Type = index ];

Index IndexFromGroup On FromReagentGroupDR [ SqlName = Index_FromGroup, Type = index ];

Index IndexOperateType On OperateTypeCode [ SqlName = Index_OperateType, Type = index ];

Index IndexBillType On BillTypeDR [ SqlName = Index_BillType, Type = index ];

Index IndexReagentGroup On ReagentGroupDR [ SqlName = Index_ReagentGroup, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTKIN On RowID [ PrimaryKey, SqlName = PK_RG_STKIN, Type = index, Unique ];

/// Foreign Key FKRGStkInCanceller created via DDL
ForeignKey FKRGStkInCanceller(CancellerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkIn_Canceller ];

/// Foreign Key FKRGStkInChecker created via DDL
ForeignKey FKRGStkInChecker(CheckerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkIn_Checker ];

/// Foreign Key FKRGStkInCreator created via DDL
ForeignKey FKRGStkInCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkIn_Creator ];

/// Foreign Key FKRGStkInGroup created via DDL
ForeignKey FKRGStkInGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_StkIn_Group ];

/// Foreign Key FKRGStkInFromGroup created via DDL
ForeignKey FKRGStkInFromGroup(FromReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_StkIn_FromGroup ];

/// Foreign Key FKRGStkInBillType created via DDL
ForeignKey FKRGStkInBillType(BillTypeDR) References dbo.BTRGBillType(PKBTRGBILLTYPE) [ SqlName = FK_RG_StkIn_BillType ];

/// Foreign Key FKRGStkInPurchaser created via DDL
ForeignKey FKRGStkInPurchaser(PurchaserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkIn_Purchaser ];

/// Foreign Key FKRGStkInSupplier created via DDL
ForeignKey FKRGStkInSupplier(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_StkIn_Supplier ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkInNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property FromReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property OperateTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

Property BillTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property PurchaserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Sender As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

Property TotalPrice As %Library.Float [ Required, SqlColumnNumber = 11 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 14 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 15 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property CheckerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property CancellerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property CancelReason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 22 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 23 ];

Property LastTransId As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="RGStkInDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkInNo</Value>
</Value>
<Value name="3">
<Value>OrderNoDR</Value>
</Value>
<Value name="4">
<Value>SupplierDR</Value>
</Value>
<Value name="5">
<Value>OperateTypeDR</Value>
</Value>
<Value name="6">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="7">
<Value>PurchaserDR</Value>
</Value>
<Value name="8">
<Value>Sender</Value>
</Value>
<Value name="9">
<Value>TotalPrice</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>CreateTime</Value>
</Value>
<Value name="13">
<Value>CreatorDR</Value>
</Value>
<Value name="14">
<Value>CheckDate</Value>
</Value>
<Value name="15">
<Value>CheckTime</Value>
</Value>
<Value name="16">
<Value>CheckerDR</Value>
</Value>
<Value name="17">
<Value>CancelDate</Value>
</Value>
<Value name="18">
<Value>CancelTime</Value>
</Value>
<Value name="19">
<Value>CancellerDR</Value>
</Value>
<Value name="20">
<Value>Remark</Value>
</Value>
<Value name="21">
<Value>CancelReason</Value>
</Value>
<Value name="22">
<Value>FromReagentGroupDR</Value>
</Value>
<Value name="23">
<Value>OperateTypeCode</Value>
</Value>
<Value name="24">
<Value>BillTypeDR</Value>
</Value>
<Value name="25">
<Value>LastTransId</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkInD</DataLocation>
<DefaultData>RGStkInDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkInD</IdLocation>
<IndexLocation>^dbo.RGStkInI</IndexLocation>
<StreamLocation>^dbo.RGStkInS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
