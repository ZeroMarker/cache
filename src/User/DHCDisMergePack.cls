Class User.DHCDisMergePack Extends %Persistent [ SqlRowIdName = MP_RowId, SqlTableName = DHC_DisMergePack, StorageStrategy = NewStorage1 ]
{

/// 类型  MP_ReqType
Property MPReqType As %Text(MAXLEN = 120) [ SqlColumnNumber = 2, SqlFieldName = MP_ReqType ];

/// 陪送/配送id  MP_Pointer
Property MPPointer As %Text(MAXLEN = 120) [ SqlColumnNumber = 3, SqlFieldName = MP_Pointer ];

/// 打包号  MP_PackNo
Property MPPackNo As %Text(MAXLEN = 120) [ SqlColumnNumber = 4, SqlFieldName = MP_PackNo ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISMP)</SqlIdExpression>
<SQLMap name="Map1">
<Data name="MP_PackNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MP_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MP_ReqType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISMP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Noindex">
<Global>^DHCDISMP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PackNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MP_PackNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MP_ReqType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MP_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Typeindex">
<Global>^DHCDISMP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MP_ReqType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MP_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisMergePackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
