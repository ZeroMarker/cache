/// 名称: 药品业务表 12临床意义
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCLabClinical Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = LABC_RowId, SqlTableName = DHC_LabClinical, StorageStrategy = SQLStorage ]
{

/// LABC_RowId  ^DHCLABCLI
Property LABCInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = LABC_Inst_Dr ];

Property LABCCliText As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LABC_CliText ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLABCLI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LABC_CliText">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LABC_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLABCLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LABC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LABC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="InstIndex">
<Global>^DHCLABCLI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LABC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LABC_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LABC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LABC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLabClinicalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
