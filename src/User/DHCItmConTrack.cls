Class User.DHCItmConTrack Extends (%Persistent, User.Abstract) [ SqlRowIdName = ItmCont_RowId, SqlTableName = DHC_ItmConTrack, StorageStrategy = SQLStorage ]
{

Property DHCSTMCONTDR As User.DHCConTrack [ SqlColumnNumber = 2, SqlFieldName = ItmCont_Cont_DR ];

Property DHCSTMITMDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = ItmCont_INCItm_DR ];

Property DHCSTMContDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = ItmCont_Date ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCSTMITMCONTRACK)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ItmCont_Cont_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ItmCont_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ItmCont_INCItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSTMITMCONTRACK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ItmCont_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ItmCont_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^DHCSTMITMCONTRACK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ItmCont_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ItmCont_INCItm_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ItmCont_Cont_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{ItmCont_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexContInci">
<Global>^DHCSTMITMCONTRACK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ItmCont_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CONTRACT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ItmCont_Cont_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ItmCont_INCItm_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ItmCont_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ItmCont_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSTMITMConTrackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTMITMCONTRACK)
	s oldI = +$g(^mdata("DHCSTMITMCONTRACK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTMITMCONTRACK = maxI
	s ^mdata("DHCSTMITMCONTRACK") = maxI
}

}
