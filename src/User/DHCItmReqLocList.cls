Class User.DHCItmReqLocList Extends (%Persistent, User.Abstract) [ SqlRowIdName = LL_RowId, SqlTableName = DHC_ItmReqLocList, StorageStrategy = SqlStorage1 ]
{

Property LLINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = LL_INCI_DR ];

Property LLCTLOCDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = LL_CTLOC_DR ];

Storage SqlStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCItmRQLL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LL_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCItmRQLL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInciLoc">
<Global>^DHCItmRQLL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCILOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LL_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{LL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{LL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmReqLocListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
