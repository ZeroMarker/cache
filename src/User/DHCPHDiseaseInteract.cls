/// 名称: 药品业务表 8.相互作用、互斥项目业务表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-2
Class User.DHCPHDiseaseInteract Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PDINT_RowId, SqlTableName = DHC_PHDiseaseInteract, StorageStrategy = SQLStorage ]
{

/// PDINT_RowId  ^DHCPHDINTER
Property PDINTInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PDINT_Inst_Dr ];

Property PDINTGenDr As DHCPHExtGeneric [ SqlColumnNumber = 3, SqlFieldName = PDINT_Gen_Dr ];

/// 管控级别: Warn警示, Control管控, Stat统计
Property PDINTManage As %String(DISPLAYLIST = ",Warn,Control,Stat", VALUELIST = ",W,C,S") [ SqlColumnNumber = 4, SqlFieldName = PDINT_Manage ];

/// 类型：相互作用Interact、配伍禁忌Incompatibility、互斥项目MutualExclusion
Property PDINTType As %String(DISPLAYLIST = ",Interact,Incompatibility,MutualExclusion", VALUELIST = ",I,INC,M") [ SqlColumnNumber = 5, SqlFieldName = PDINT_Type ];

/// 医嘱标识:1 组内 2组间 3全部 2016/09/28 用于有些药品组内配伍不行，组间可以情况
Property PDINTFlag As %String(DISPLAYLIST = ",组内,组间,全部", VALUELIST = ",1,2,3") [ SqlColumnNumber = 6, SqlFieldName = PDINT_Flag ];

/// 商品名指针2016/12/02
Property PDINTDrugDr As DHCPHProName [ SqlColumnNumber = 7, SqlFieldName = PDINT_Drug_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHDINTER(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDINT_Drug_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDINT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDINT_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDINT_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDINT_Manage">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDINT_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHDINTER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDINT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PDINT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHDINTER</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDINT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDINT_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDINT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDINT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHDiseaseInteractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
