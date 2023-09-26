Class User.DHCLinkHisNurseOrd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LHN_ROWID, SqlTableName = DHC_LinkHisNurseOrd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LHN_ORDER_NO
Property LHNORDERNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LHN_ORDER_NO ];

/// LHN_ORDER_SUB_NO
Property LHNORDERSUBNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LHN_ORDERSUB_NO ];

/// LHN_OEORD_DR
Property LHNOEORDDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LHN_OEORD_DR ];

/// LHN_STATUS
Property LHNSTATUS As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = LHN_STATUS ];

/// LHN_PAADM
Property LHNPAADM As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LHN_PAADM ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLHN)</SqlIdExpression>
<SQLMap name="IndexByPaadm">
<Global>^DHCLHN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LHN_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LHN_PAADM}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LHN_ORDER_NO}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LHN_ORDERSUB_NO}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{LHN_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfOEORI">
<Global>^DHCLHN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>LHN_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LHN_PAADM}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LHN_OEORD_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LHN_ORDER_NO}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{LHN_ORDERSUB_NO}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{LHN_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataMap">
<Data name="LHN_OEORD_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LHN_ORDERSUB_NO">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LHN_ORDER_NO">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LHN_PAADM">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LHN_ROWID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LHN_STATUS">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCLHN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LHN_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LHN_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLinkHisNurseOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
