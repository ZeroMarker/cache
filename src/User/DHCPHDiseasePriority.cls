/// 名称: 药品业务表 医嘱优先级维护
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2015-12-10
Class User.DHCPHDiseasePriority Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PDP_RowId, SqlTableName = DHC_PHDiseasePriority, StorageStrategy = SQLStorage ]
{

/// PDP_RowId  ^DHCPHDISPR
Property PDPInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PDP_Inst_Dr ];

Property PDPPriorityDR As DHCPHExtPriority [ SqlColumnNumber = 3, SqlFieldName = PDP_Priority_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDISPR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDP_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDP_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDISPR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PDP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHDISPR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDP_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseasePriorityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
