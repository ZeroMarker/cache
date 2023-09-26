Class User.DHCDisNodeLocLink Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = NLL_RowID, SqlTableName = DHC_DisNodeLocLink, StorageStrategy = SQLStorage ]
{

//NLL_Loc_Dr 关联科室

Property NLLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = NLL_Loc_Dr ];

//NLL_NodeLoc_Dr

Property NLLNodeLocDr As User.DHCDisNodeLoc [ SqlColumnNumber = 3, SqlFieldName = NLL_NodeLoc_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISNLL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NLL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NLL_NodeLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDISNLL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{NLL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="NodeLocDrIndex">
<Global>^DHCDISNLL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NodeLocDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NLL_NodeLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="NodeLocIndex">
<Global>^DHCDISNLL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NLL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NodeLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NLL_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NLL_NodeLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisNodeLocLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
