/// 基础数据平台-临床知识库-医嘱优先级表
Class User.DHCPHExtPriority Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHEP_RowId, SqlTableName = DHC_PHExtPriority, StorageStrategy = SQLStorage ]
{

// ^DHCPHEP

Property PHEPCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHEP_Code ];

Property PHEPDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHEP_Desc ];

Property PHEPPriority As %String [ SqlColumnNumber = 4, SqlFieldName = PHEP_Priority ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHEP(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHEPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEP_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHEPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEP_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHEP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEP_Priority">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHEP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHEP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHExtPriorityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
