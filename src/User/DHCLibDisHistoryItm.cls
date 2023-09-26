/// 名称: 药品业务表6.4业务辅助表-既往史业务表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCLibDisHistoryItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = LDH_RowId, SqlTableName = DHC_LibDisHistoryItm, StorageStrategy = SQLStorage ]
{

/// LDH_RowId  ^DHCLIBDISHISI
Property LDHInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = LDH_Inst_Dr ];

Property LDHDhDr As DHCDisHistoryFeild [ SqlColumnNumber = 3, SqlFieldName = LDH_Dh_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLIBDISHISI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LDH_Dh_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LDH_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLIBDISHISI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LDH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LDH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCLIBDISHISI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LDH_Dh_Dr</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LDH_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LDH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LDH_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLibDisHistoryItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
