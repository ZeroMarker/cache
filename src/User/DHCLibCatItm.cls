/// 名称: 药品业务表6.7业务辅助表-分类业务表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCLibCatItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CATI_RowId, SqlTableName = DHC_LibCatItm, StorageStrategy = SQLStorage ]
{

/// CATI_RowId  ^DHCLIBCATI
Property CATIInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = CATI_Inst_Dr ];

Property CATICatDr As DHCPHLibCat [ SqlColumnNumber = 3, SqlFieldName = CATI_Cat_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLIBCATI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CATI_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CATI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLIBCATI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CATI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{CATI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCLIBCATI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CATI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CATI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CATI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CATI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLibCatItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
