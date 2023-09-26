Class User.DHCItmAdd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCIA_Rowid, SqlTableName = DHC_ItmAdd, StorageStrategy = SQLStorage ]
{

/// DARCIM_ARCIM_DR
Property DHCIAItmDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DHCIA_Itm_DR ];

/// DARCIM_ARCIM_DR
Property DHCIAAddItmDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DHCIA_AddItm_DR ];

/// DARCIM_MaxQty
Property DHCIAQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCIA_Qty ];

/// DARCIM_ARCIM_DR
Property DHCIALocDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = DHCIA_Loc_DR ];

/// 接收科室
Property DHCIARecLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = DHCIA_RecLoc_DR ];

/// 用法
Property DHCIAInstrDR As User.PHCInstruc [ SqlColumnNumber = 7, SqlFieldName = DHCIA_Instr_DR ];

/// 院区
Property DHCIAHospDR As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = DHCIA_Hosp_DR ];

/// 单次剂量
Property DHCIADoseQty As %String [ SqlColumnNumber = 9, SqlFieldName = DHCIA_DoseQty ];

/// 剂量单位
Property DHCIADoseUomDR As User.CTUOM [ SqlColumnNumber = 10, SqlFieldName = DHCIA_DoseUom_DR ];

/// 标本
Property DHCIASpecCode As %String [ SqlColumnNumber = 11, SqlFieldName = DHCIA_SpecCode ];

/// 根据主医嘱基本单位数量计算绑定数量
Property DHCIACalByBindOrdQty As %String [ SqlColumnNumber = 12, SqlFieldName = DHCIA_CalByBindOrdQty ];

/// 限制最大年龄
Property DHCIALimitMaxAge As %String [ SqlColumnNumber = 13, SqlFieldName = DHCIA_LimitMaxAge ];

/// 限制最小年龄
Property DHCIALimitSmallAge As %String [ SqlColumnNumber = 14, SqlFieldName = DHCIA_LimitSmallAge ];

/// 限制就诊类型
Property DHCIALimitAdmType As %String [ SqlColumnNumber = 15, SqlFieldName = DHCIA_LimitAdmType ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCItmMastAdd(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCIA_AddItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCIA_CalByBindOrdQty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCIA_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCIA_DoseUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCIA_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCIA_Instr_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCIA_Itm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCIA_LimitAdmType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCIA_LimitMaxAge">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCIA_LimitSmallAge">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCIA_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCIA_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCIA_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCIA_SpecCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCItmMastAdd</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCIA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCIA_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM ">
<Global>^DHCItmMastAdd</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCIA_Hosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCIA_Itm_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCIA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
