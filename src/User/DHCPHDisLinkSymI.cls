/// 名称: 诊断与症状建议用药或检查
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-9-1
Class User.DHCPHDisLinkSymI Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = LSY_RowId, SqlTableName = DHC_PHDisLinkSymI, StorageStrategy = SQLStorage ]
{

/// ^DHCPHDLSYI
Property LSYLinkDr As DHCPHDisLinkSym [ SqlColumnNumber = 2, SqlFieldName = LSY_Link_Dr ];

Property LSYGenDr As DHCPHExtGeneric [ SqlColumnNumber = 3, SqlFieldName = LSY_Gen_Dr ];

Property LSYFlag As %String [ SqlColumnNumber = 4, SqlFieldName = LSY_Flag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDLSYI(0))</SqlIdExpression>
<SQLMap name="GenIndex">
<Global>^DHCPHDLSYI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LSY_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LSY_Gen_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LSY_Link_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LSY_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LinkIndex">
<Global>^DHCPHDLSYI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LSY_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LSY_Link_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LSY_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="LSY_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LSY_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LSY_Link_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHDLSYI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LSY_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LSY_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LSY_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDisLinkSymIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
