Class User.DHCRBCIllStatus Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIS_RowID, SqlTableName = DHCRBC_IllStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 253;

/// DIS_PaAdm_DR
Property DISPaAdmDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DIS_PaAdm_DR ];

/// DIS_Oeorditem_DR
Property DISOeorditemDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DIS_Oeorditem_DR ];

/// DIS_IllStatus
Property DISIllStatus As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DIS_IllStatus ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCApp("IllStatus"))</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DIS_IllStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIS_Oeorditem_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIS_PaAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IllStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexpaadmrowid">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"illstatu-roditem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIS_PaAdm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexstatus">
<Global>^DHCRBAppi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DIS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIS_IllStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCIllStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
