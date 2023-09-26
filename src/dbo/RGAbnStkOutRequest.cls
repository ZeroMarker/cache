/// 特殊出库请求（退货、报废）
Class dbo.RGAbnStkOutRequest Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_AbnStkOutRequest, StorageStrategy = Default ]
{

Index IndexMaster On StkOutRequestNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReagentGroup On (ReagentGroupDR, CreateDate) [ SqlName = Index_ReagentGroup, Type = index ];

Index IndexStatus On (Status, CreateDate, ReagentGroupDR) [ SqlName = Index_Status, Type = index ];

Index IndexCheckDate On (CheckDate, ReagentGroupDR) [ SqlName = Index_CheckDate, Type = index ];

Index IndexApproveDate On (ApproveDate, ReagentGroupDR) [ SqlName = Index_ApproveDate, Type = index ];

/// DDL Primary Key Specification
Index PKRGAbnStkOutRequest On RowID [ PrimaryKey, SqlName = PK_RG_AbnStkOutRequest, Type = index, Unique ];

ForeignKey FKRGAbnStkOutRequestCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_AbnStkOutRequest_Creator ];

ForeignKey FKRGAbnStkOutRequestReagentGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_AbnStkOutRequest_ReagentGroup ];

ForeignKey FKRGAbnStkOutRequestChecker(CheckerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_AbnStkOutRequest_Checker ];

ForeignKey FKRGAbnStkOutRequestSupplier(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_AbnStkOutRequest_Supplier ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkOutRequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property StkOutStatus As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property CheckerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Approver As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

Property ApproveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property ApproveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Property Type As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 17 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property Reason As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="RGAbnStkOutRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkOutRequestNo</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>StkOutStatus</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>CreatorDR</Value>
</Value>
<Value name="8">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="9">
<Value>CheckDate</Value>
</Value>
<Value name="10">
<Value>CheckTime</Value>
</Value>
<Value name="11">
<Value>CheckerDR</Value>
</Value>
<Value name="12">
<Value>Approver</Value>
</Value>
<Value name="13">
<Value>ApproveDate</Value>
</Value>
<Value name="14">
<Value>ApproveTime</Value>
</Value>
<Value name="15">
<Value>Remark</Value>
</Value>
<Value name="16">
<Value>Type</Value>
</Value>
<Value name="17">
<Value>SupplierDR</Value>
</Value>
<Value name="18">
<Value>Reason</Value>
</Value>
</Data>
<DataLocation>^dbo.RGAbnStkOutRequestD</DataLocation>
<DefaultData>RGAbnStkOutRequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGAbnStkOutRequestD</IdLocation>
<IndexLocation>^dbo.RGAbnStkOutRequestI</IndexLocation>
<StreamLocation>^dbo.RGAbnStkOutRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
