/// 特殊出库请求明细
Class dbo.RGAbnStkOutRequestItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_AbnStkOutRequestItems, StorageStrategy = Default ]
{

Index IndexMaster On (StkOutRequestDR, ReagentDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRGAbnStkOutRequestItems On RowID [ PrimaryKey, SqlName = PK_RG_AbnStkOutRequestItems, Type = index, Unique ];

ForeignKey FKRGAbnStkOutRequestItemsAbnStkOutRequest(StkOutRequestDR) References dbo.RGAbnStkOutRequest(PKRGAbnStkOutRequest) [ SqlName = FK_RG_AbnStkOutRequestItems_AbnStkOutRequest ];

ForeignKey FKRGAbnStkOutRequestItemsReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_AbnStkOutRequestItems_Reagent ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkOutRequestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property RequestQty As %Library.Float [ Required, SqlColumnNumber = 5 ];

Property ApproveQty As %Library.Float [ SqlColumnNumber = 6 ];

Property StkOutQty As %Library.Float [ SqlColumnNumber = 7 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RGAbnStkOutRequestItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkOutRequestDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>RequestQty</Value>
</Value>
<Value name="5">
<Value>ApproveQty</Value>
</Value>
<Value name="6">
<Value>StkOutQty</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RGAbnStkOutRequestItemsD</DataLocation>
<DefaultData>RGAbnStkOutRequestItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGAbnStkOutRequestItemsD</IdLocation>
<IndexLocation>^dbo.RGAbnStkOutRequestItemsI</IndexLocation>
<StreamLocation>^dbo.RGAbnStkOutRequestItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
