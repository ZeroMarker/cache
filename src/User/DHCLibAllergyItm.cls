/// 名称: 药品业务表6.5业务辅助表-过敏史业务表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCLibAllergyItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = LALC_RowId, SqlTableName = DHC_LibAllergyItm, StorageStrategy = SQLStorage ]
{

/// LALC_RowId  ^DHCLIBALLI
Property LALCInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = LALC_Inst_Dr ];

Property LALCAllergyDr As DHCAllergyFeild [ SqlColumnNumber = 3, SqlFieldName = LALC_Allergy_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLIBALLI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LALC_Allergy_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LALC_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLIBALLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LALC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LALC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInstdr">
<Global>^DHCLIBALLI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LALC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LALC_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LALC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LALC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLibAllergyItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
