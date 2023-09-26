/// 课程表(SqlStorage)
/// 夏双玲
Class User.DHCCoursex Extends %Persistent [ SqlTableName = DHC_Coursex, StorageStrategy = NewStorage1 ]
{

Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCCOURSE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Crs_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Crs_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Crs_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>DHCCOURSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Crs_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Crs_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>DHCCOURSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Crs_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Crs_Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Crs_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Crs_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Crs_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCoursexS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
