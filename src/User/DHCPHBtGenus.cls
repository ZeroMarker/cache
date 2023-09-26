/// 名称：菌属表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-7 
Class User.DHCPHBtGenus Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = BTGE_RowId, SqlTableName = DHC_PHBtGenus, StorageStrategy = SQLStorage ]
{

// ^DHCPHBTGE,^DHCPHBTGEi

Property BTGECode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BTGE_Code ];

Property BTGEDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BTGE_Desc ];

Property BTGEActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BTGE_ActiveFlag ];

Property BTGESysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BTGE_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHBTGE(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHBTGEi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BTGE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({BTGE_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BTGE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHBTGEi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BTGE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({BTGE_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BTGE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BTGE_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BTGE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BTGE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BTGE_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHBTGE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BTGE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BTGE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BTGE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHBtGenusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
