/// 名称: 药品业务表6.7业务辅助表-分类业务表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCPhysiologyVal Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHYV_RowId, SqlTableName = DHC_PhysiologyVal, StorageStrategy = SQLStorage ]
{

/// PHYV_RowId  ^DHCPHYVAL
Property PHYVInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHYV_Inst_Dr ];

Property PHYVFeildDr As DHCPhysiologyFeild [ SqlColumnNumber = 3, SqlFieldName = PHYV_Feild_Dr ];

/// 生理参数类型 心率A，血压B
Property PHYVType As %String(DISPLAYLIST = ",HEARTR,BLOODP,SYSTOLIC,DIASTOLIC", VALUELIST = ",H,B,S,D") [ SqlColumnNumber = 4, SqlFieldName = PHYV_Type ];

Property PHYVMinVal As %String [ SqlColumnNumber = 5, SqlFieldName = PHYV_MinVal ];

Property PHYVMaxVal As %String [ SqlColumnNumber = 6, SqlFieldName = PHYV_MaxVal ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHYVAL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHYV_Feild_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHYV_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHYV_MaxVal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHYV_MinVal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHYV_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHYVAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHYV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHYV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHYVAL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHYV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHYV_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHYV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHYV_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPhysiologyValS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
