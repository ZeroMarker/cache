Class User.DHCPEReportPrintRecords Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RPR_RowID, SqlTableName = DHC_PE_ReportPrintRecords, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEReportPrintRecords";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RPRChildSub [ IdKey, PrimaryKey, Unique ];

/// RPR_ChildSub
Property RPRChildSub As %Library.Float [ InitialExpression = {$i(^DHCPERPT($p(%d(0),$c(1),1),"Print",0))}, Required, SqlColumnNumber = 2, SqlFieldName = RPR_ChildSub ];

/// DHC_PE_Report Parent Reference
Relationship RPRParRef As User.DHCPEReport [ Cardinality = parent, Inverse = ChildDHCPEReportPrintRecords, Required, SqlFieldName = RPR_ParRef ];

/// RPR_PrintDate
Property RPRPrintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = RPR_PrintDate ];

/// RPR_PrintTime
Property RPRPrintTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = RPR_PrintTime ];

/// RPR_PrintUser_DR
Property RPRPrintUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RPR_PrintUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RPR_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RPR_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RPR_PrintUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPERPT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_Report.RPT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RPR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_PE_Report.RPT_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Print"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RPR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEReportPrintRecordsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
