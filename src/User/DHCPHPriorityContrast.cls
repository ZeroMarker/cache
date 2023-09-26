/// 基础数据平台-临床知识库-医嘱优先级对照
Class User.DHCPHPriorityContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHPCT_RowId, SqlTableName = DHC_PHPriorityContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHPRCON

Property PHPCTPriorityCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHPCT_PriorityCode ];

Property PHPCTPriorityDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHPCT_PriorityDesc ];

Property PHPCTHisPriorityCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHPCT_HisPriorityCode ];

Property PHPCTHisPriorityDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHPCT_HisPriorityDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHPRCON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHPRCON</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHPCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPCT_PriorityCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHPCT_HisPriorityCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHPCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCPHPRCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHPCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPCT_HisPriorityCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHPCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHPCT_HisPriorityCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHPCT_HisPriorityDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHPCT_PriorityCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHPCT_PriorityDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHPRCON</Global>
<RowIdSpec name="1">
<Field>PHPCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHPCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHPCT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHPriorityContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
