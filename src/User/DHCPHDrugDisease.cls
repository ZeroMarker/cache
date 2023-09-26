/// 名称: 药品业务表 4病症(包括适应症、禁忌症)维护 
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCPHDrugDisease Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHDD_RowId, SqlTableName = DHC_PHDrugDisease, StorageStrategy = SQLStorage ]
{

/// PHDD_RowId  ^DHCPHDDIS
Property PHDDInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHDD_Inst_Dr ];

/// PHDD_Pointer_Dr
Property PHDDPointerDr As %String [ SqlColumnNumber = 3, SqlFieldName = PHDD_Pointer_Dr ];

Property PHDDDiseaDr As DHCPHDiseaseList [ SqlColumnNumber = 4, SqlFieldName = PHDD_Disea_Dr ];

/// 作用模式：Indication适应症、Contraindication禁忌症、Disease病症
Property PHDDMode As %String(DISPLAYLIST = ",Indication,Contraindication,Disease", VALUELIST = ",I,C,D") [ SqlColumnNumber = 5, SqlFieldName = PHDD_Mode ];

Property PHDDGenDr As DHCPHExtGeneric [ SqlColumnNumber = 6, SqlFieldName = PHDD_Gen_Dr ];

/// 类型：禁用、慎用
Property PHDDType As %String(DISPLAYLIST = ",Forbidden,CautiousUse", VALUELIST = ",F,C") [ SqlColumnNumber = 7, SqlFieldName = PHDD_Type ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDDIS(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHDD_Disea_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDD_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDD_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDD_Mode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDD_Pointer_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDD_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHDDIS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHDD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHDDIS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDD_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMode">
<Global>^DHCPHDDIS</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHDD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Mode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDD_Disea_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDD_Mode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDD_Inst_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHDD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHDD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDrugDiseaseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
