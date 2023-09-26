/// 基础数据平台-临床知识库-单位字典表
Class User.DHCPHExtUom Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHEU_RowId, SqlTableName = DHC_PHExtUom, StorageStrategy = SQLStorage ]
{

// ^DHCPHEUO

Property PHEUCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHEU_Code ];

Property PHEUDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHEU_Desc ];

Property PHEUActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHEU_ActiveFlag ];

Property PHEUSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHEU_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHEUO(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHEUOi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHEU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEU_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHEUOi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEU_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHEU_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEU_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHEUO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHEU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEU_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHExtUomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
