Class User.DHCInStkTkItmWd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSTW_RowID, SqlTableName = DHC_InStkTkItmWd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INSTWChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_InStkTkItm Parent Reference
Relationship INSTWINSTIParref As User.DHCInStkTkItm [ Cardinality = parent, Inverse = ChildDHCInStkTkItmWd, Required, SqlFieldName = INSTW_INSTI_Parref ];

/// INSTW_ChildSub
Property INSTWChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = INSTW_ChildSub ];

/// INSTW_CTUOM_DR
Property INSTWCTUOMDR As User.CTUOM [ SqlColumnNumber = 3, SqlFieldName = INSTW_CTUOM_DR ];

/// INSTW_CountQty
Property INSTWCountQty As %Library.Float(MAXVAL = 999999999999, MINVAL = -999999999999) [ SqlColumnNumber = 4, SqlFieldName = INSTW_CountQty ];

/// INSTW_CountPerson_DR
Property INSTWCountPersonDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = INSTW_CountPerson_DR ];

/// INSTW_CountDate
Property INSTWCountDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = INSTW_CountDate ];

/// INSTW_CountTime
Property INSTWCountTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = INSTW_CountTime ];

/// INSTW_InStkItmFlag
Property INSTWInStkItmFlag As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INSTW_InStkItmFlag ];

/// INSTW_PHW_DR
Property INSTWPHWDR As User.DHCInStkTkWindow [ SqlColumnNumber = 9, SqlFieldName = INSTW_PHW_DR ];

/// INSTW_QtyPuom
Property INSTWQtyPuom As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INSTW_QtyPuom ];

/// INSTW_QtyBuom
Property INSTWQtyBuom As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INSTW_QtyBuom ];

/// INSTW_StkBinDesc
Property INSTWStkBinDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INSTW_StkBinDesc ];

/// INSTW_BLbQty   录入点批次库存（基本单位）
Property INSTWBLbQty As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INSTW_BLbQty ];

/// INSTW_ChangeBQty   变动数量
Property INSTWChangeBQty As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INSTW_ChangeBQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DateMasterDHCINSTW">
<Data name="INSTW_BLbQty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSTW_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSTW_ChangeBQty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSTW_CountDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSTW_CountPerson_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSTW_CountQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSTW_CountTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSTW_InStkItmFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSTW_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSTW_QtyBuom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSTW_QtyPuom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSTW_StkBinDesc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCINST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INSTW_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"STW"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTW_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItmWindow">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INSTW_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ITMWINDOW"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSTW_PHW_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTW_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INSTW_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"STWPERSON"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSTW_CountPerson_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTW_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStkBinDesc">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INSTW_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BIN"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSTW_StkBinDesc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTW_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWindow">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INSTW_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"WINDOW"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSTW_PHW_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTW_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdateperson">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>INSTW_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DATEPERSON"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INSTW_CountDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSTW_CountPerson_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSTW_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexinflagwindow">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>INSTW_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"INFLAGWINDOW"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INSTW_PHW_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSTW_InStkItmFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSTW_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInStkTkItmWdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
