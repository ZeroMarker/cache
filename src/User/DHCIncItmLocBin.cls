/// 科室库存项货位表
/// 
Class User.DHCIncItmLocBin Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = INCILB_ROWID, SqlTableName = DHC_IncItmLocBin, StorageStrategy = SQLStorage ]
{

Property INCILBItmLocDr As User.INCItmLoc [ SqlColumnNumber = 2, SqlFieldName = INCILB_ItmLoc_Dr ];

Property INCILBStkBinDr As User.INCStkBin [ SqlColumnNumber = 3, SqlFieldName = INCILB_StkBin_Dr ];

/// 药品在此货位的顺序号
Property INCILBSerialNo As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INCILB_SerialNo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINCILB(0))</SqlIdExpression>
<SQLMap name="IndexBin">
<Global>^DHCINCILB</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Bin"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCILB_StkBin_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCILB_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCINCILB</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCILB_ItmLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCILB_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="INCILB_ItmLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCILB_SerialNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCILB_StkBin_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINCILB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCILB_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INCILB_ROWID}</Expression>
<StartValue>0</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INCILB_ROWID</SqlRowIdName>
<StreamLocation>^User.DHCIncItmLocBinS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
