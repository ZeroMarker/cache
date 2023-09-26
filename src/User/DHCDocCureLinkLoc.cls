Class User.DHCDocCureLinkLoc Extends %Persistent [ SqlTableName = DHC_DocCureLinkLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property DDCLLMainLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DDCLL_MainLoc_Dr ];

Property DDCLLLinkLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DDCLL_LinkLoc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocCureLinkLoc)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DDCLL_LinkLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCLL_MainLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDocCureLinkLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DDCLL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLinkLoc">
<Global>^DHCDocCureLinkLoci</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DDCLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LINKLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCLL_LinkLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCLL_MainLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMainLoc">
<Global>^DHCDocCureLinkLoci</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MAINLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCLL_MainLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDCLL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureLinkLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
