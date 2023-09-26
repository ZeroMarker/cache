Class User.DHCEmPatChkGCS Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = PCG_RowId, SqlTableName = DHC_EmPatChkGCS, StorageStrategy = NewStorage1 ]
{

/// 预检表 PCG_Chk_Dr
Property PCGChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCG_Chk_Dr ];

/// 格拉斯哥主id  PCG_GCS_Dr
Property PCGGCSDr As User.DHCEmGCS [ SqlColumnNumber = 3, SqlFieldName = PCG_GCS_Dr ];

/// 格拉斯哥子表id  PCG_GCSI_Dr
Property PCGGCSIDr As User.DHCEmGCSItem [ SqlColumnNumber = 4, SqlFieldName = PCG_GCSI_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMPCG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCG_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCG_GCSI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCG_GCS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChkDr">
<Global>^DHCEMPCG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ChkDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCG_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkGCSS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
