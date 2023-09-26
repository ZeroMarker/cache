/// 名称: 联合用药
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-11-24
Class User.DHCPHMustDrug Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHMD_RowId, SqlTableName = DHC_PHMustDrug, StorageStrategy = SQLStorage ]
{

/// PHMD_RowId  ^DHCPHMD
Property PHMDInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHMD_Inst_Dr ];

/// 关联药
Property PHMDAssDrugDr As DHCPHProName [ SqlColumnNumber = 3, SqlFieldName = PHMD_AssDrug_Dr ];

/// 必用药品
Property PHMDMustDrugDr As DHCPHProName [ SqlColumnNumber = 4, SqlFieldName = PHMD_MustDrug_Dr ];

/// 关系 (DISPLAYLIST = ",大于,小于,等于,不大于,不小于,不等于", VALUELIST = ",>,<,=,!>,!<,<>")
Property PHMDRelation As %String [ SqlColumnNumber = 5, SqlFieldName = PHMD_Relation ];

/// 数量
Property PHMDMustQty As %String [ SqlColumnNumber = 6, SqlFieldName = PHMD_MustQty ];

/// 单位
Property PHMDMustUomDr As DHCPHExtUom [ SqlColumnNumber = 7, SqlFieldName = PHMD_MustUom_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHMD(0))</SqlIdExpression>
<SQLMap name="IndexInst">
<Global>^DHCPHMD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMD_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHMD_AssDrug_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMD_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMD_MustDrug_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMD_MustQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMD_MustUom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHMD_Relation">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHMD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHMD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHMustDrugS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
