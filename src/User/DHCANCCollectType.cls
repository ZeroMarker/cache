Class User.DHCANCCollectType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = ANCCT_RowId, SqlTableName = DHC_ANC_CollectType, StorageStrategy = CacheSQLStorage ]
{

Relationship ChildDHCANCCollectTypeItem As User.DHCANCCollectTypeItem [ Cardinality = children, Inverse = ANCCTIParref ];

Property ANCCTCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCCT_Code ];

Property ANCCTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCCT_Desc ];

Property ANCCTActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ANCCT_Active ];

Property ANCCTType As %String(DISPLAYLIST = ",AN,ICU,BP", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",A,I,B") [ SqlColumnNumber = 5, SqlFieldName = ANCCT_Type ];

Storage CacheSQLStorage
{
<DataLocation>^DHCANC</DataLocation>
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCANC("CType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCCT_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCCT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCCT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANCCT_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCCT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANCCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCCT_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANCCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ANCCT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCANCCollectTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Storage CacheStorage
{
}

}
