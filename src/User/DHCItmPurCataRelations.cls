Class User.DHCItmPurCataRelations Extends (%Persistent, User.Abstract) [ SqlRowIdName = ItmPCR_RowId, SqlTableName = DHC_ItmPurCataRelations, StorageStrategy = SQLStorage ]
{

Property ItmPCRINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = ItmPCR_INCI_DR ];

Property ItmPCRPurCataDR As User.DHCMatPurCatalog [ SqlColumnNumber = 3, SqlFieldName = ItmPCR_PurCata_DR ];

Property ItmPCRSMLDR As User.DHCSpecModelList [ SqlColumnNumber = 4, SqlFieldName = ItmPCR_SML_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCItmPCRelation)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="ItmPCR_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ItmPCR_PurCata_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ItmPCR_SML_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCItmPCRelation</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ItmPCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ItmPCR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCItmPCRelation</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ItmPCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ItmPCR_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ItmPCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLogInci">
<Global>^DHCItmPCRelation</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ItmPCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ItmPCR_PurCata_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ItmPCR_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ItmPCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ItmPCR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmPurCataRelationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCItmPCRelation)
	s oldI = +$g(^mdata("DHCItmPurCataRelations"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCItmPCRelation = maxI
	s ^mdata("DHCItmPurCataRelations") = maxI
}

Parameter EXTENTSIZE = 2500;

}
