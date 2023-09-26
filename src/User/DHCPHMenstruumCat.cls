/// 基础数据平台-临床知识库-溶媒分类字典
Class User.DHCPHMenstruumCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHMC_RowId, SqlTableName = DHC_PHMenstruumCat, StorageStrategy = SQLStorage ]
{

// ^DHCPHMCT

Property PHMCCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHMC_Code ];

Property PHMCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHMC_Desc ];

Property PHMCActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHMC_Active ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHMCT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHMC_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHMCT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPHMCTi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHMC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHMCTi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHMC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHMC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHMenstruumCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
