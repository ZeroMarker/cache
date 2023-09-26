Class User.DHCWLSTDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WLSTDT_Rowid, SqlTableName = DHC_WLSTDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On WLSTDTChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_WLSTItem Parent Reference
Relationship WLSTDTWLSTITParRef As User.DHCWLSTItem [ Cardinality = parent, Inverse = ChildDHCWLSTDetail, Required, SqlFieldName = WLSTDT_WLSTIT_ParRef ];

/// WLSTDT_ARCBG_DR
Property WLSTDTARCBGDR As User.ARCBillGrp [ SqlColumnNumber = 4, SqlFieldName = WLSTDT_ARCBG_DR ];

/// WLSTDT_ARCBS_DR
Property WLSTDTARCBSDR As User.ARCBillSub [ SqlColumnNumber = 5, SqlFieldName = WLSTDT_ARCBS_DR ];

/// WLSTDT_ARCIM_DR
Property WLSTDTARCIMDR As User.ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = WLSTDT_ARCIM_DR ];

/// WLSTDT_ARCIC_DR
Property WLSTDTARCICDR As User.ARCItemCat [ SqlColumnNumber = 7, SqlFieldName = WLSTDT_ARCIC_DR ];

/// WLSTDT_ChildSub
Property WLSTDTChildSub As %Library.Float [ InitialExpression = {$i(^DHCWLSTAT($P(%d(0),"||"),"ITEM",$P(%d(0),"||",2),"DETAIL",0))}, SqlColumnNumber = 8, SqlFieldName = WLSTDT_ChildSub ];

/// WLSTDT_TarIM_DR
Property WLSTDTTarIMDR As User.DHCTarItem [ SqlColumnNumber = 9, SqlFieldName = WLSTDT_TarIM_DR ];

/// WLSTDT_TarAC_Dr
Property WLSTDTTarACDr As User.DHCTarAcctCate [ SqlColumnNumber = 10, SqlFieldName = WLSTDT_TarAC_Dr ];

/// WLSTDT_TarSC_Dr
Property WLSTDTTarSCDr As User.DHCTarSubCate [ SqlColumnNumber = 11, SqlFieldName = WLSTDT_TarSC_Dr ];

/// WLSTDT_TarOC_Dr
Property WLSTDTTarOCDr As User.DHCTarOutpatCate [ SqlColumnNumber = 12, SqlFieldName = WLSTDT_TarOC_Dr ];

/// WLSTDT_TarEC_Dr
Property WLSTDTTarECDr As User.DHCTarEMCCate [ SqlColumnNumber = 13, SqlFieldName = WLSTDT_TarEC_Dr ];

/// WLSTDT_TarMC_Dr
Property WLSTDTTarMCDr As User.DHCTarMRCate [ SqlColumnNumber = 14, SqlFieldName = WLSTDT_TarMC_Dr ];

/// WLSTDT_TarIC_Dr
Property WLSTDTTarICDr As User.DHCTarInpatCate [ SqlColumnNumber = 15, SqlFieldName = WLSTDT_TarIC_Dr ];

/// WLSTDT_TarMCNew_Dr
Property WLSTDTTarMCNewDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = WLSTDT_TarMCNew_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasteWLSTDT">
<Data name="WLSTDT_ARCBG_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLSTDT_ARCBS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLSTDT_ARCIC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLSTDT_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLSTDT_TarAC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WLSTDT_TarEC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WLSTDT_TarIC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WLSTDT_TarIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WLSTDT_TarMCNew_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WLSTDT_TarMC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WLSTDT_TarOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WLSTDT_TarSC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCWLSTAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{WLSTDT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCBG">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ARCBG"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_ARCBG_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCBS">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ARCBS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_ARCBS_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIC">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ARCIC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_ARCIC_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarAC">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TarAC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_TarAC_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarEC">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TarEC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_TarEC_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarIC">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TarIC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_TarIC_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarIM">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TARIM"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_TarIM_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarMC">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TarMC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_TarMC_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarMCNew">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TarMCNew"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_TarMCNew_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarOC">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TarOC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_TarOC_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarSC">
<Global>^DHCWLSTAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_WLStat.WLSTAT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_WLSTItem.WLSTIT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>WLSTDT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_WLStat.WLSTAT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_WLSTItem.WLSTIT_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DETAIL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"TarSC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLSTDT_TarSC_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{WLSTDT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWLSTDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
