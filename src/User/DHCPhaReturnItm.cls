Class User.DHCPhaReturnItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHARI_Rowid, SqlTableName = DHC_PhaReturnItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHARIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPhaReturnItmLB As User.DHCPhaReturnItmLB [ Cardinality = children, Inverse = PHARILPHARIParref ];

/// DHC_PhaReturn Parent Reference
Relationship PHARIPHARParref As User.DHCPhaReturn [ Cardinality = parent, Inverse = ChildDHCPhaReturnItm, Required, SqlFieldName = PHARI_PHAR_Parref ];

/// PHARI_ChildSub
Property PHARIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHARI_ChildSub ];

/// PHARI_OEDIS_DR
Property PHARIOEDISDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PHARI_OEDIS_DR ];

/// PHARI_Price
Property PHARIPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHARI_Price ];

/// PHARI_Qty
Property PHARIQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHARI_Qty ];

/// PHARI_REASON_DR
Property PHARIREASONDR As User.BLCReasonForRefund [ SqlColumnNumber = 6, SqlFieldName = PHARI_REASON_DR ];

/// PHARI_ReservedQty
Property PHARIReservedQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHARI_ReservedQty ];

/// PHARI_Amount
Property PHARIAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHARI_Amount ];

/// PHARI_PAADM_DR
Property PHARIPAADMDR As User.PAAdm [ SqlColumnNumber = 9, SqlFieldName = PHARI_PAADM_DR ];

/// PHARI_AdmLoc_DR
Property PHARIAdmLocDR As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = PHARI_AdmLoc_DR ];

/// PHARI_Bed_DR
Property PHARIBedDR As User.PACBed [ SqlColumnNumber = 11, SqlFieldName = PHARI_Bed_DR ];

/// PHARI_RETRQI_DR
Property PHARIRETRQIDR As User.DHCPhaRetRequestItm [ SqlColumnNumber = 12, SqlFieldName = PHARI_RETRQI_DR ];

/// PHARI_INCI_DR
Property PHARIINCIDR As User.INCItm [ SqlColumnNumber = 13, SqlFieldName = PHARI_INCI_DR ];

/// PHARI_DateDosing
Property PHARIDateDosing As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PHARI_DateDosing ];

/// PHARI_DoDis_Dr
Property PHARIDoDisDr As User.DHCOEDispensing [ SqlColumnNumber = 15, SqlFieldName = PHARI_DoDis_Dr ];

/// PHARI_DeptLoc_DR
Property PHARIDeptLocDR As User.CTLoc [ SqlColumnNumber = 16, SqlFieldName = PHARI_DeptLoc_DR ];

/// 外包装完好（Y/N）
Property PHARIPackIntact As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = PHARI_PackIntact ];

/// 变质（Y/N）
Property PHARIDeterFailure As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = PHARI_DeterFailure ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="datamaster">
<Data name="PHARI_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHARI_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHARI_Bed_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHARI_DateDosing">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHARI_DeptLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHARI_DeterFailure">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHARI_DoDis_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHARI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHARI_OEDIS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHARI_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHARI_PackIntact">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHARI_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHARI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHARI_REASON_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHARI_RETRQI_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHARI_ReservedQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PHARET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaReturn.PHAR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHARI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaReturn.PHAR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHARI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexPharInci">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHARINCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PhaReturn.PHAR_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHARI_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHARI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexReqItm">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaReturn.PHAR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHARI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"REQUEST"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHARI_RETRQI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHARI_PHAR_Parref}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHARI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinci">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaReturn.PHAR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHARI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHARI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PhaReturn.PHAR_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHARI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexoedis">
<Global>^PHARET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PhaReturn.PHAR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PHARI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"OEDIS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHARI_OEDIS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PHARI_DateDosing}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_PhaReturn.PHAR_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{PHARI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaReturnItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
