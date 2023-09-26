///     
Class dbo.RGStkOut Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkOut, StorageStrategy = Default ]
{

Index IndexCancelDate On CancelDate [ SqlName = Index_CancelDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index IndexReagentGroup On FromReagentGroupDR [ SqlName = Index_ReagentGroup, Type = index ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexStkInStatus On StkInStatus [ SqlName = Index_StkInStatus, Type = index ];

Index IndexStkOutNo On StkOutNo [ SqlName = Index_StkOutNo, Type = index, Unique ];

Index IndexSupplier On SupplierDR [ SqlName = Index_Supplier, Type = index ];

Index IndexToGroup On ToReagentGroupDR [ SqlName = Index_ToGroup, Type = index ];

Index IndexOperateType On OperateTypeCode [ SqlName = Index_OperateType, Type = index ];

Index IndexBillType On BillTypeDR [ SqlName = Index_BillType, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTKOUT On RowID [ PrimaryKey, SqlName = PK_RG_STKOUT, Type = index, Unique ];

/// Foreign Key FKRGStkOutOperaterType created via DDL
ForeignKey FKRGStkOutBillType(BillTypeDR) References dbo.BTRGBillType(PKBTRGBILLTYPE) [ SqlName = FK_RG_StkOut_BillType ];

/// Foreign Key FKRGStkOutToGroup created via DDL
ForeignKey FKRGStkOutToGroup(ToReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_StkOut_ToGroup ];

/// Foreign Key FKRGTransferCanceller created via DDL
ForeignKey FKRGStkOutCanceller(CancellerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkOut_Canceller ];

/// Foreign Key FKRGTransferChecker created via DDL
ForeignKey FKRGStkOutChecker(CheckerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkOut_Checker ];

/// Foreign Key FKRGTransferCreator created via DDL
ForeignKey FKRGStkOutCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_StkOut_Creator ];

/// Foreign Key FKRGTransferFromGroup created via DDL
ForeignKey FKRGStkOutFromGroup(FromReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_StkOut_FromGroup ];

/// Foreign Key FKRGStkOutSupplier created via DDL
ForeignKey FKRGStkOutSupplier(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_StkOut_Supplier ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkOutNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property ToReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property FromReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property OperateTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 7 ];

Property BillTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property StkInStatus As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property CheckerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property CancellerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property CancelReason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 20 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="RGStkOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkOutNo</Value>
</Value>
<Value name="3">
<Value>RelationStkOutDR</Value>
</Value>
<Value name="4">
<Value>ToReagentGroupDR</Value>
</Value>
<Value name="5">
<Value>FromReagentGroupDR</Value>
</Value>
<Value name="6">
<Value>OperateTypeDR</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
<Value name="10">
<Value>CreatorDR</Value>
</Value>
<Value name="11">
<Value>CheckDate</Value>
</Value>
<Value name="12">
<Value>CheckTime</Value>
</Value>
<Value name="13">
<Value>CheckerDR</Value>
</Value>
<Value name="14">
<Value>CancelDate</Value>
</Value>
<Value name="15">
<Value>CancelTime</Value>
</Value>
<Value name="16">
<Value>CancellerDR</Value>
</Value>
<Value name="17">
<Value>Remark</Value>
</Value>
<Value name="18">
<Value>CancelReason</Value>
</Value>
<Value name="19">
<Value>SupplierDR</Value>
</Value>
<Value name="20">
<Value>OperateTypeCode</Value>
</Value>
<Value name="21">
<Value>BillTypeDR</Value>
</Value>
<Value name="22">
<Value>StkInStatus</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkOutD</DataLocation>
<DefaultData>RGStkOutDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkOutD</IdLocation>
<IndexLocation>^dbo.RGStkOutI</IndexLocation>
<StreamLocation>^dbo.RGStkOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
