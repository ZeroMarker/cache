Class User.DHCDisSerGroLinkLoc Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SGLL_RowID, SqlTableName = DHC_DisSerGroLinkLoc, StorageStrategy = SQLStorage ]
{

/// 关联服务组  SGLL_SerGro_Dr
Property SGLLSerGroDr As User.DHCDisServiceGroup [ SqlColumnNumber = 2, SqlFieldName = SGLL_SerGro_Dr ];

/// 关联科室  SGLL_Loc_Dr
Property SGLLLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = SGLL_Loc_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISSGLL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SGLL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SGLL_SerGro_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISSGLL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SGLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SGLL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCDISSGLL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SGLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SGLL_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SGLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSGLoc">
<Global>^DHCDISSGLL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SGLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SGLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SGLL_SerGro_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SGLL_Loc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SGLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisSerGroLinkLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
