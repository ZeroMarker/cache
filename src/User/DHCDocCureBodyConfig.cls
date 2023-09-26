Class User.DHCDocCureBodyConfig Extends %Persistent [ SqlRowIdName = DDCBC_RowID, SqlTableName = DHC_DocCureBodyConfig, StorageStrategy = SQLStorage ]
{

Property DDCBCBodyImageId As %String [ SqlColumnNumber = 2, SqlFieldName = DDCBC_BodyImageId ];

Property DDCBCBodyPointDesc As %String [ SqlColumnNumber = 3, SqlFieldName = DDCBC_BodyPointDesc ];

Property DDCBCBodyPointValue As %String(MAXLEN = 9999) [ SqlColumnNumber = 4, SqlFieldName = DDCBC_BodyPointValue ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDocCureBCi(0))</SqlIdExpression>
<SQLMap name="BodyImageIndex">
<Global>^DHCDocCureBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCBC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ImageId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCBC_BodyImageId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCBC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMap">
<Data name="DDCBC_BodyImageId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCBC_BodyPointDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCBC_BodyPointValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureBC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCBC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DDCBC_RowID}</Expression>
<StartValue>0</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DDCBC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureBodyConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
