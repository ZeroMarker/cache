///     
Class dbo.RGTrace Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_Trace, StorageStrategy = Default ]
{

Index IndexBillNo On (BillNo, BillTypeDR) [ SqlName = Index_BillNo, Type = index ];

Index IndexMaster On (LotDR, BillTypeDR, TraceDate, TraceTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexOperateType On OperateTypeCode [ SqlName = Index_OperateType, Type = index ];

Index IndexProcessType On (ProcessType, TraceDate) [ SqlName = Index_ProcessType, Type = index ];

Index IndexReagentGroupDate On (ReagentGroupDR, TraceDate) [ SqlName = Index_ReagentGroupDate, Type = index ];

Index IndexUserDate On (UserDR, TraceDate) [ SqlName = Index_UserDate, Type = index ];

/// DDL Primary Key Specification
Index PKRGTRACE On RowID [ PrimaryKey, SqlName = PK_RG_TRACE, Type = index, Unique ];

/// Foreign Key FKRGTraceGroup created via DDL
ForeignKey FKRGTraceGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Trace_Group ];

/// Foreign Key FKRGTraceLot created via DDL
ForeignKey FKRGTraceLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_Trace_Lot ];

/// Foreign Key FKRGTraceUser created via DDL
ForeignKey FKRGTraceUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Trace_User ];

/// Foreign Key FKRGBillType created via DDL
ForeignKey FKRGBillType(BillTypeDR) References dbo.BTRGBillType(PKBTRGBILLTYPE) [ SqlName = FK_RG_Trace_BillType ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TraceDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TraceTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ProcessType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 6 ];

Property OperateTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 7 ];

Property BillTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property BillNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 9 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Property Quantity As %Library.Float [ Required, SqlColumnNumber = 12 ];

Storage Default
{
<Data name="RGTraceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TraceDate</Value>
</Value>
<Value name="3">
<Value>TraceTime</Value>
</Value>
<Value name="4">
<Value>UserDR</Value>
</Value>
<Value name="5">
<Value>ProcessType</Value>
</Value>
<Value name="6">
<Value>OperateTypeCode</Value>
</Value>
<Value name="7">
<Value>BillTypeDR</Value>
</Value>
<Value name="8">
<Value>BillNo</Value>
</Value>
<Value name="9">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="10">
<Value>LotDR</Value>
</Value>
<Value name="11">
<Value>Quantity</Value>
</Value>
</Data>
<DataLocation>^dbo.RGTraceD</DataLocation>
<DefaultData>RGTraceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGTraceD</IdLocation>
<IndexLocation>^dbo.RGTraceI</IndexLocation>
<StreamLocation>^dbo.RGTraceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
