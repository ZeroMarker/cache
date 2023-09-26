Class User.PHAIPLabelConfig Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlRowIdName = PILC_RowID, SqlTableName = PHAIP_LabelConfig, StorageStrategy = SQLStorage ]
{

Property PILCType As %String(MAXLEN = 5) [ SqlColumnNumber = 2, SqlFieldName = PILC_Type ];

Property PILCINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = PILC_INCI_DR ];

Property PILCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PILC_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CD.PHA.IN.LabelConfig(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="PILC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PILC_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PILC_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CD.PHA.IN.LabelConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PILC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PILC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeInci">
<Global>^CD.PHA.IN.LabelConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PILC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeInci"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PILC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PILC_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PILC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PILC_RowID</SqlRowIdName>
<StreamLocation>^User.PHAIPLabelConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
