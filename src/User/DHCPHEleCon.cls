/// 名称: 药品业务表-成分浓度业务表(整组浓度含量)
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2016-11-21
Class User.DHCPHEleCon Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHEC_RowId, SqlTableName = DHC_PHEleCon, StorageStrategy = SQLStorage ]
{

/// PHEC_RowId  ^DHCPHEC
Property PHECInstDr As DHCPHInstructions [ SqlColumnNumber = 2, SqlFieldName = PHEC_Inst_Dr ];

Property PHECPHExtIngr As DHCPHExtIngr [ SqlColumnNumber = 3, SqlFieldName = PHEC_PHExtIngr ];

Property PHECIngrQty As %Float [ SqlColumnNumber = 4, SqlFieldName = PHEC_IngrQty ];

Property PHECUomDr As DHCPHExtUom [ SqlColumnNumber = 5, SqlFieldName = PHEC_Uom_Dr ];

//(DISPLAYLIST = ",大于,小于,等于,不大于,不小于,不等于", VALUELIST = ",>,<,=,!>,!<,<>")

Property PHECRelation As %String [ SqlColumnNumber = 6, SqlFieldName = PHEC_Relation ];

Property PHECTotalQty As %Float [ SqlColumnNumber = 7, SqlFieldName = PHEC_TotalQty ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHEC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHEC_IngrQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEC_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEC_PHExtIngr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEC_Relation">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHEC_TotalQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHEC_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHEC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHEC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInst">
<Global>^DHCPHEC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHEC_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHEC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHEleConS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
