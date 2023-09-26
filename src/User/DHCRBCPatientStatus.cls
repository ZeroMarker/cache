Class User.DHCRBCPatientStatus Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPS_RowID, SqlTableName = DHCRBC_PatientStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DPS_Code
Property DPSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DPS_Code ];

/// DPS_Desc
Property DPSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DPS_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCStatus("PatientStatus"))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCStatusi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DPS_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DPS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCStatus</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PatientStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DPS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCPatientStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
