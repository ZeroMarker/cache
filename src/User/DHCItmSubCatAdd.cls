Class User.DHCItmSubCatAdd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCICA_Rowid, SqlTableName = DHC_ItmSubCatAdd, StorageStrategy = SQLStorage ]
{

/// DHCICA_ItemCat_DR
Property DHCICAItemCatDR As User.ARCItemCat [ SqlColumnNumber = 2, SqlFieldName = DHCICA_ItemCat_DR ];

/// DHCICA_AddItm_DR
Property DHCICAAddItmDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DHCICA_AddItm_DR ];

/// DHCICA_Qty
Property DHCICAQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCICA_Qty ];

/// DHCICA_Loc_DR
Property DHCICALocDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = DHCICA_Loc_DR ];

/// 接收科室
Property DHCICARecLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = DHCICA_RecLoc_DR ];

/// 用法
Property DHCICAInstrDR As User.PHCInstruc [ SqlColumnNumber = 7, SqlFieldName = DHCICA_Instr_DR ];

/// 院区
Property DHCICAHospDR As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = DHCICA_Hosp_DR ];

/// 单次剂量
Property DHCICADoseQty As %String [ SqlColumnNumber = 9, SqlFieldName = DHCICA_DoseQty ];

/// 剂量单位
Property DHCICADoseUomDR As User.CTUOM [ SqlColumnNumber = 10, SqlFieldName = DHCICA_DoseUom_DR ];

/// 标本
Property DHCICASpecCode As %String [ SqlColumnNumber = 11, SqlFieldName = DHCICA_SpecCode ];

/// 限制绑定的就诊,英文逗号分隔
Property DHCICALimitAdmType As %String [ SqlColumnNumber = 12, SqlFieldName = DHCICA_LimitAdmType ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCItmSubCatAdd(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCICA_AddItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCICA_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCICA_DoseUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCICA_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCICA_Instr_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCICA_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCICA_LimitAdmType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCICA_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCICA_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCICA_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCICA_SpecCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCItmSubCatAdd</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCICA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCICA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemCatDr">
<Global>^DHCItmSubCatAdd</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCICA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCICA_Hosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCICA_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCICA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCICA_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCItmSubCatAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
