/// 基础数据平台-临床知识库-检查部位和HIS部位对照表
Class User.DHCPHPartContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHEP_RowId, SqlTableName = DHC_PHPartContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHPACON

Property PHEPPartCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHEP_PartCode ];

Property PHEPPartDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHEP_PartDesc ];

Property PHEPHisPartCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHEP_HisPartCode ];

Property PHEPHisPartDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHEP_HisPartDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHPACON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHPACON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHEP_HisPartCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_PartCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCPHPACON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHEP_HisPartCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKBCode">
<Global>^DHCPHPACON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PartCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHEP_PartCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHEP_HisPartCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEP_HisPartDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHEP_PartCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEP_PartDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHPACON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHEP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHPartContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
