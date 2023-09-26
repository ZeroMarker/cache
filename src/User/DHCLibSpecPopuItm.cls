/// 名称: 药品业务表6.6业务辅助表-特殊人群业务表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCLibSpecPopuItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SPEPI_RowId, SqlTableName = DHC_LibSpecPopuItm, StorageStrategy = SQLStorage ]
{

/// SPEPI_RowId  ^DHCLIBSPEPI
Property SPEPIInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = SPEPI_Inst_Dr ];

Property SPEPISpecDr As DHCSpecialPopu [ SqlColumnNumber = 3, SqlFieldName = SPEPI_Spec_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLIBSPEPI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SPEPI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPEPI_Spec_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCLIBSPEPI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SPEPI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SPEPI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexInst">
<Global>^DHCLIBSPEPI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SPEPI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPEPI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SPEPI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPEPI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLibSpecPopuItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
