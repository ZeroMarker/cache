Class User.DHCInStkTkInput Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_InStkTkInput, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DHCSTIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_InStkTk Parent Reference
Relationship DHCSTIParref As DHCInStkTk [ Cardinality = parent, Inverse = ChildDHCInStkTkInput, Required, SqlFieldName = DHCSTI_Parref ];

Relationship ChildINStktkPackage As User.DHCINStktkPackage [ Cardinality = children, Inverse = DSTKPParref ];

/// DHCSTI_ChildSub
Property DHCSTIChildSub As %Float [ SqlColumnNumber = 2, SqlFieldName = DHCSTI_ChildSub ];

/// DHCSTI_INCI_DR
Property DHCSTIINCIDR As INCItm [ SqlColumnNumber = 3, SqlFieldName = DHCSTI_INCI_DR ];

/// DHCSTI_Uom_Dr
Property DHCSTIUomDr As CTUOM [ SqlColumnNumber = 4, SqlFieldName = DHCSTI_Uom_Dr ];

/// DHCSTI_CountQty
Property DHCSTICountQty As %Float(MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCSTI_CountQty ];

/// DHCSTI_CountUser_Dr
Property DHCSTICountUserDr As SSUser [ SqlColumnNumber = 6, SqlFieldName = DHCSTI_CountUser_Dr ];

/// DHCSTI_CountDate
Property DHCSTICountDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DHCSTI_CountDate ];

/// DHCSTI_CountTime
Property DHCSTICountTime As %Time [ SqlColumnNumber = 8, SqlFieldName = DHCSTI_CountTime ];

/// DHCSTI_PHW_DR
Property DHCSTIPHWDR As User.DHCInStkTkWindow [ SqlColumnNumber = 9, SqlFieldName = DHCSTI_PHW_DR ];

/// DHCSTI_QtyPuom
Property DHCSTIQtyPuom As %Float(MINVAL = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCSTI_QtyPuom ];

/// DHCSTI_QtyBuom
Property DHCSTIQtyBuom As %Float(MINVAL = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCSTI_QtyBuom ];

/// 发药机库存
Property DHCSTIMacQtyBuom As %Float(MINVAL = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCSTI_MacQtyBuom ];

/// DHCSTI_BStkQty      录入点库存（基本单位）
Property DHCSTIBStkQty As %Float(MINVAL = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCSTI_BStkQty ];

/// DHCSTI_ChangeBQty   变动数量(基本单位)
Property DHCSTIChangeBQty As %Float [ SqlColumnNumber = 14, SqlFieldName = DHCSTI_ChangeBQty ];

/// DHCSTI_ChangePQty   变动数量(入库单位)
Property DHCSTIChangePQty As %Float [ SqlColumnNumber = 15, SqlFieldName = DHCSTI_ChangePQty ];

/// DHCSTI_Reason_Dr
Property DHCSTIReasonDr As DHCInStktkReason [ SqlColumnNumber = 16, SqlFieldName = DHCSTI_Reason_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHCSTI_BStkQty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCSTI_ChangeBQty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCSTI_ChangePQty">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCSTI_CountDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCSTI_CountQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCSTI_CountTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCSTI_CountUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCSTI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCSTI_MacQtyBuom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCSTI_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCSTI_QtyBuom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCSTI_QtyPuom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCSTI_Reason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCSTI_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"STP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCSTI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexWinInc">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DHCSTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"STP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"WININCI"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCSTI_PHW_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHCSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{DHCSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinci">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"STP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCSTI_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCInStkTkInputS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
