/// 基础数据平台-临床知识库-知识库标识字典
Class User.DHCPHLibaryLabel Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHLI_RowId, SqlTableName = DHC_PHLibaryLabel, StorageStrategy = SQLStorage ]
{

// ^DHCPHLIBL

Property PHLICode As %String [ SqlColumnNumber = 2, SqlFieldName = PHLI_Code ];

Property PHLIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHLI_Desc ];

Property PHLIActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHLI_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHLIBL(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHLIBL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHLI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHLI_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHLIBL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHLI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHLI_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHLI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHLIBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHLI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHLI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHLibaryLabelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
