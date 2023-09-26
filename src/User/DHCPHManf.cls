/// 基础数据平台-临床知识库-厂家字典表
Class User.DHCPHManf Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHMA_RowId, SqlTableName = DHC_PHManf, StorageStrategy = SQLStorage ]
{

// ^DHCPHMANF

Property PHMACode As %String [ SqlColumnNumber = 2, SqlFieldName = PHMA_Code ];

Property PHMADesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHMA_Desc ];

Property PHMAActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHMA_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHMANF(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHMANF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHMA_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMap">
<Data name="PHMA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHMANF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHMA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHMANF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHMA_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHMA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHManfS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
