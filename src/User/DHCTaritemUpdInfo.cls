Class User.DHCTaritemUpdInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UpdInfo_RowID, SqlTableName = DHCTaritemUpdInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UpdInfo_Taritem_Dr
Property UpdInfoTaritemDr As User.DHCTarItem [ SqlColumnNumber = 2, SqlFieldName = UpdInfo_Taritem_Dr ];

/// UpdInfo_ItemCode_Dr
Property UpdInfoItemCodeDr As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UpdInfo_ItemCode_Dr ];

/// UpdInfo_OldInfo
Property UpdInfoOldInfo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UpdInfo_OldInfo ];

/// UpdInfo_NewInfo
Property UpdInfoNewInfo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UpdInfo_NewInfo ];

/// UpdInfo_UpdDate
Property UpdInfoUpdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = UpdInfo_UpdDate ];

/// UpdInfo_UpdTime
Property UpdInfoUpdTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = UpdInfo_UpdTime ];

/// UpdInfo_UpdUser
Property UpdInfoUpdUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = UpdInfo_UpdUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTARITEMUPDINFO)</SqlIdExpression>
<SQLMap name="datamaster">
<Data name="UpdInfo_ItemCode_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UpdInfo_NewInfo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UpdInfo_OldInfo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UpdInfo_Taritem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UpdInfo_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UpdInfo_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UpdInfo_UpdUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCTARITEMUPDINFO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UpdInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UpdInfo_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indextaritemcode">
<Global>^DHCTARITEMUPDINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UpdInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TARI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UpdInfo_Taritem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITEMCODE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UpdInfo_ItemCode_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UpdInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexupdate">
<Global>^DHCTARITEMUPDINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UpdInfo_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UpdInfo_UpdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UpdInfo_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTaritemUpdInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
