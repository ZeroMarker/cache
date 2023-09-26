Class User.DHCRBCAppointMethod Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRAM_Rowid, SqlTableName = DHCRBC_AppointMethod, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRAM_Code
Property DRAMCode As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRAM_Code ];

/// DRAM_Desc
Property DRAMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRAM_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCAppointMethod)</SqlIdExpression>
<SQLMap name="MasterMapData">
<Data name="DRAM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRAM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCAppointMethod</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRAM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRAM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCAppointMethodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
