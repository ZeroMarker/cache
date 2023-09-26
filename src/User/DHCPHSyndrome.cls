/// 证型/证候字典
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-18
Class User.DHCPHSyndrome Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = DRO_RowId, SqlTableName = DHC_PHSyndrome, StorageStrategy = SQLStorage ]
{

// ^DHCPHSYDRO

Property DROCode As %String [ SqlColumnNumber = 2, SqlFieldName = DRO_Code ];

Property DRODesc As %String [ SqlColumnNumber = 3, SqlFieldName = DRO_Desc ];

Property DROActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DRO_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHSYDRO(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHSYDRO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DRO_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHSYDRO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DRO_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DRO_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHSYDRO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DRO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DRO_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHSyndromeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
