Class User.DHCRBCReportStatus Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRS_RowID, SqlTableName = DHCRBC_ReportStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRS_Code
Property DRSCode As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRS_Code ];

/// DRS_Desc
Property DRSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRS_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCStatus("ReportStatus"))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRS_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCStatus</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ReportStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCReportStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
