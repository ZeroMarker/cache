/// 基础数据平台-临床知识库-检查业务表
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2015-1-6
Class User.DHCLibExaItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = EXAI_RowId, SqlTableName = DHC_LibExaItm, StorageStrategy = SQLStorage ]
{

/// EXAI_RowId  ^DHCLIBEXAI
Property EXAIInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = EXAI_Inst_Dr ];

Property EXAIExamDr As DHCExamineFeild [ SqlColumnNumber = 3, SqlFieldName = EXAI_Exam_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLIBEXAI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EXAI_Exam_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EXAI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLIBEXAI</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{EXAI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCLIBEXAI</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EXAI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXAI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EXAI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLibExaItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
