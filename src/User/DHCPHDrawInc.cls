Class User.DHCPHDrawInc Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDWI_RowID, SqlTableName = DHC_PHDrawInc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Index RowIDBasedIDKeyIndex On PHDWIChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表 Parent Reference
Relationship PHDWIPHDWParref As User.DHCPHDraw [ Cardinality = parent, Inverse = ChildDHCPHDrawInc, Required, SqlFieldName = PHDWI_PHDW_Parref ];

/// PHDWI_ChildSub
Property PHDWIChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPHDRAW($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"INC",0))}, SqlColumnNumber = 2, SqlFieldName = PHDWI_ChildSub ];

Property PHDWIInciDr As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = PHDWI_Inci_Dr ];

/// 申请数量
Property PHDWIQtyTotal As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHDWI_QtyTotal ];

/// 实际配药数量
Property PHDWIQtyActual As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHDWI_QtyActual ];

/// 单位
Property PHDWIUomDr As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = PHDWI_Uom_Dr ];

/// 备药完成
Property PHDWICompFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = PHDWI_CompFlag ];

/// 明细备药人
Property PHDWIUserCompDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PHDWI_UserComp_Dr ];

/// 装箱核对人
Property PHDWIUserPackDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PHDWI_UserPack_Dr ];

/// 备药日期
Property PHDWIDateComp As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PHDWI_DateComp ];

/// 备药时间
Property PHDWITimeComp As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = PHDWI_TimeComp ];

/// 装箱核对日期
Property PHDWIDatePack As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PHDWI_DatePack ];

/// 装箱核对时间
Property PHDWITimePack As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = PHDWI_TimePack ];

/// 装箱完成标志
Property PHDWICompPackFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 14, SqlFieldName = PHDWI_CompPackFlag ];

/// 整散标志
Property PHDWIPackFlag As %String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PHDWI_PackFlag ];

/// 最终发药数量
Property PHDWIQtyLast As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = PHDWI_QtyLast ];

/// 入盒标志
Property PHDWIBoxFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 17, SqlFieldName = PHDWI_BoxFlag ];

/// 置后标志
Property PHDWIAfterFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 18, SqlFieldName = PHDWI_AfterFlag ];

Index PHDWIInciDrIndex On PHDWIInciDr;

Relationship ChildDHCPHDrawOrder As User.DHCPHDrawOrder [ Cardinality = children, Inverse = PHDWOPHDWIParref ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHDWI_AfterFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHDWI_BoxFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHDWI_CompFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDWI_CompPackFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHDWI_DateComp">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHDWI_DatePack">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHDWI_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDWI_PackFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHDWI_QtyActual">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDWI_QtyLast">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHDWI_QtyTotal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDWI_TimeComp">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHDWI_TimePack">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHDWI_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDWI_UserComp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHDWI_UserPack_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHDRAW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDraw.PHDW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHDWI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDraw.PHDW_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHDWI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHDraw.PHDW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHDWI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDWI_Inci_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHDraw.PHDW_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDWI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.DHCPHDrawIncS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
