Class User.DHCItmSpecList Extends (%Persistent, User.Abstract) [ SqlRowIdName = SPEC_RowId, SqlTableName = DHC_ItmSpecList, StorageStrategy = SqlStorage ]
{

Property SPECINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = SPEC_INCI_DR ];

Property SPECDesc As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SPEC_Desc ];

Property SPECSeqNo As %Numeric [ SqlColumnNumber = 4, SqlFieldName = SPEC_SeqNo ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$I(^DHCItmSpecList(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SPEC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPEC_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPEC_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCItmSpecList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SPEC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SPEC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCItmSpecList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SPEC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPEC_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SPEC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPEC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmSpecListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
