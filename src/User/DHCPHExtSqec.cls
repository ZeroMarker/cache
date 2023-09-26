/// 药品规格字典表　
/// 2016-09-30
/// 谷雪萍
Class User.DHCPHExtSqec Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHS_RowId, SqlTableName = DHC_PHExtSqec, StorageStrategy = SQLStorage ]
{

// ^DHCPHESQE

Property PHSCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHS_Code ];

Property PHSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHS_Desc ];

Property PHSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHS_ActiveFlag ];

Property PHSSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHS_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHESQE(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHESQE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHS_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHESQE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHS_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHS_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHESQE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHExtSqecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
