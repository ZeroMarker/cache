/// 名称: 药品业务表 14诊断提示申请项目
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCLabDiagItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = LDI_RowId, SqlTableName = DHC_LabDiagItm, StorageStrategy = SQLStorage ]
{

/// LDI_RowId  ^DHCLABDIAGI
/// 病症
Property LDIDiagDr As DHCPHDiseaseList [ SqlColumnNumber = 2, SqlFieldName = LDI_Diag_Dr ];

/// 检验项目类别
Property LDICatDr As DHCPHLibCat [ SqlColumnNumber = 3, SqlFieldName = LDI_Cat_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLABDIAGI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LDI_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LDI_Diag_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLABDIAGI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LDI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{LDI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LDI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLabDiagItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
