/// 中草药颗粒剂饮片转换系数
/// ^DHCPHCCONVERT
Class User.DHCPhcConvert Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = DHC_PhcConvert, StorageStrategy = CacheSQLStorage ]
{

Property PCFromType As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PC_FromType ];

Property PCFromPhcDr As User.PHCDrgMast [ SqlColumnNumber = 3, SqlFieldName = PC_FromPhc_Dr ];

Property PCFromNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PC_FromNum ];

Property PCToType As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PC_ToType ];

Property PCToPhcDr As User.PHCDrgMast [ SqlColumnNumber = 6, SqlFieldName = PC_ToPhc_Dr ];

Property PCToNum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PC_ToNum ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCPHCCONVERT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PC_FromNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PC_FromPhc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PC_FromType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PC_ToNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PC_ToPhc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PC_ToType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHCCONVERT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFromTo">
<Global>^DHCPHCCONVERT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FromTo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PC_FromPhc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PC_ToPhc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToFrom">
<Global>^DHCPHCCONVERT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToFrom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PC_ToPhc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PC_FromPhc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PC_RowId</SqlRowIdName>
<StreamLocation>^DHCPHCCONVERTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
