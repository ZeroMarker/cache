Class User.DHCLVConfig Extends (%Persistent, User.Abstract) [ SqlRowIdName = LVC_RowId, SqlTableName = DHC_LVConfig, StorageStrategy = SQLStorage ]
{

Property LVCInciDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = LVC_InciDR ];

Property LVCLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = LVC_CTLocDR ];

Property LVCNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LVC_Number ];

Property LVCScg As User.DHCStkCatGroup [ SqlColumnNumber = 5, SqlFieldName = LVC_ScgDr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCLVCONFIG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LVC_CTLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LVC_InciDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LVC_Number">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LVC_ScgDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCLVCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LVC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LVC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndescLocScg">
<Global>^DHCLVCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LVC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LVC_ScgDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LVC_CTLocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LVC_InciDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LVC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocInci">
<Global>^DHCLVCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LVC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LVC_CTLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LVC_InciDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LVC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LVC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLVCofigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLVCONFIG)
	s oldI = +$g(^mdata("DHCLVCONFIG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLVCONFIG = maxI
	s ^mdata("DHCLVCONFIG") = maxI
}

}
