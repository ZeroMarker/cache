/// Description草药毒性字典表 DHC_PHToxicity
/// Creator:谷雪萍
/// Data:2017-07-19
Class User.DHCPHToxicity Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = Tox_RowId, SqlTableName = DHC_PHToxicity, StorageStrategy = SQLStorage ]
{

// ^DHCPHTOX,^DHCPHTOXi

Property ToxCode As %String [ SqlColumnNumber = 2, SqlFieldName = Tox_Code ];

Property ToxDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Tox_Desc ];

Property ToxActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Tox_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHTOX(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHTOXi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Tox_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({Tox_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Tox_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHTOXi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Tox_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({Tox_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Tox_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="Tox_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Tox_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Tox_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHTOX</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Tox_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Tox_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>Tox_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHToxicityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
