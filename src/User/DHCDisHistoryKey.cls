Class User.DHCDisHistoryKey Extends %Persistent [ SqlRowIdName = DHK_RowId, SqlTableName = DHC_DisHistoryKey, StorageStrategy = NewStorage1 ]
{

// ^DHCDISHISK   ^DHCDISHISKi

Property DHKDHDr As User.DHCDisHistoryFeild [ SqlColumnNumber = 2, SqlFieldName = DHK_DH_Dr ];

Property DHKKey As %String [ SqlColumnNumber = 3, SqlFieldName = DHK_Key ];

Property DHKSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DHK_SysFlag ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDISHISK(0))</SqlIdExpression>
<SQLMap name="IndexKEYDHDR">
<Global>^DHCDISHISKi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KEYDHDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DHK_Key})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHK_DH_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKey">
<Global>^DHCDISHISKi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Key"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHK_DH_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({DHK_Key})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DHK_DH_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHK_Key">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHK_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDISHISK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHK_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisHistoryKeyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
