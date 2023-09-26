/// 名称: 商品名与His对照　
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期:  2016-10-11
Class User.DHCPHProContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHPC_RowId, SqlTableName = DHC_PHProContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHPCO

Property PHPCCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHPC_Code ];

Property PHPCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHPC_Desc ];

Property PHPCHisCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHPC_HisCode ];

Property PHPCHisDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHPC_HisDesc ];

Property PHPCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PHPC_ActiveFlag ];

Property PHPCSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHPC_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHPCO(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHPCO</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHPC_HisCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHPC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="HisCodeIndex">
<Global>^DHCPHPCO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPC_HisCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHPC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHPC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHPC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHPC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHPC_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHPC_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHPC_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHPCO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHPC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHPC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHProContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
