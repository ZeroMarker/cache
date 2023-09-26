/// 名称: 药品业务表 6.1业务辅助表-成分辅助表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCPHIngrItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHINI_RowId, SqlTableName = DHC_PHIngrItm, StorageStrategy = SQLStorage ]
{

/// PHINI_RowId  ^DHCPHINI
Property PHINIInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHINI_Inst_Dr ];

/// 药品成分
Property PHINIIngrDr As DHCPHExtIngr [ SqlColumnNumber = 3, SqlFieldName = PHINI_Ingr_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHINI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHINI_Ingr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHINI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHINI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHINI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHINI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHINI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHINI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHINI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHINI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHINI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHIngrItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
