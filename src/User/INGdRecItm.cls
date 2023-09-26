/// IN Goods Rec Note Detail(INGRI,299)
Class User.INGdRecItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_GdRecItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INGRIChildSub [ IdKey, PrimaryKey, Unique ];

/// Des ref To INGR
Relationship INGRIINGRParRef As INGdRec [ Cardinality = parent, Inverse = ChildINGdRecItm, Required, SqlFieldName = INGRI_INGR_ParRef ];

/// INGRI Childsub (New Key)
Property INGRIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INGR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"GRI",0))}, SqlColumnNumber = 2, SqlFieldName = INGRI_ChildSub ];

/// Des Ref To INCLB
Property INGRIINCLBDR As INCItmLcBt [ SqlColumnNumber = 4, SqlFieldName = INGRI_INCLB_DR ];

/// Stock Description
Property INGRIStkDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = INGRI_StkDesc ];

/// Des Ref to INC_GdRecType
Property INGRIINCGRDR As INCGdRecType [ SqlColumnNumber = 11, SqlFieldName = INGRI_INCGR_DR ];

/// Base Net Amount 
Property INGRIBNetAmt As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 12, SqlFieldName = INGRI_BNetAmt ];

/// Discount Rate
Property INGRIDisc As %Float(MAXVAL = 100, MINVAL = 0) [ SqlColumnNumber = 13, SqlFieldName = INGRI_Disc ];

/// Des Ref To Service Tax
Property INGRIServiceTaxDR As ARCServTax [ SqlColumnNumber = 14, SqlFieldName = INGRI_ServiceTax_DR ];

/// Net Amount in foreign currency
Property INGRINetAmt As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 16, SqlFieldName = INGRI_NetAmt ];

/// Gross Amount
Property INGRIGrossAmt As %Float(MAXVAL = 999999999999, MINVAL = 0) [ Required, SqlColumnNumber = 17, SqlComputeCode = { i {INGRI_RecQty}="" s {INGRI_GrossAmt}="" q
 i {INGRI_UnitCost}="" s {INGRI_GrossAmt}="" q
 s {INGRI_GrossAmt}=(+{INGRI_RecQty})*(+{INGRI_UnitCost})
}, SqlComputed, SqlComputeOnChange = (INGRIRecQty, INGRIUnitCost), SqlFieldName = INGRI_GrossAmt ];

/// UnitCost
Property INGRIUnitCost As %Float(MAXVAL = 999999999999, MINVAL = 0) [ Required, SqlColumnNumber = 30, SqlFieldName = INGRI_UnitCost ];

/// UOM
Property INGRICTUOMDR As CTUOM [ Required, SqlColumnNumber = 32, SqlFieldName = INGRI_CTUOM_DR ];

/// Receiving Quantity
Property INGRIRecQty As %Float(MAXVAL = 9999999999) [ Required, SqlColumnNumber = 33, SqlFieldName = INGRI_RecQty ];

/// Batch No
Property INGRIBatchNo As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = INGRI_BatchNo ];

/// Expiry Date
Property INGRIExpDate As %Date [ SqlColumnNumber = 35, SqlFieldName = INGRI_ExpDate ];

/// Des Ref to CTLOC
Property INGRICTLOCDR As CTLoc [ Required, SqlColumnNumber = 36, SqlFieldName = INGRI_CTLOC_DR ];

/// Share of the Overall Discount
Property INGRIOverallDiscShare As %Float(MAXVAL = 9999.99, MINVAL = 0) [ SqlColumnNumber = 37, SqlFieldName = INGRI_OverallDiscShare ];

/// Share of Handling Charges
Property INGRIHandChargeShare As %Float(MAXVAL = 99999.99, MINVAL = 0) [ SqlColumnNumber = 38, SqlFieldName = INGRI_HandChargeShare ];

/// Des Ref INPOI
Property INGRIINPOIDR As INPOItm [ SqlColumnNumber = 39, SqlFieldName = INGRI_INPOI_DR ];

/// Margin
Property INGRIMargin As %Float [ SqlColumnNumber = 40, SqlFieldName = INGRI_Margin ];

/// Remarks
Property INGRIRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = INGRI_Remarks, SqlListType = subnode ];

/// Tax Amount
Property INGRITaxAmount As %Float [ SqlColumnNumber = 42, SqlFieldName = INGRI_TaxAmount ];

/// PreVATAmt
Property INGRIPreVATAmt As %Float [ SqlColumnNumber = 43, SqlFieldName = INGRI_PreVATAmt ];

/// Des Ref CommItems
Property INGRICommItemsDR As INCCommercialItem [ SqlColumnNumber = 44, SqlFieldName = INGRI_CommItems_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INGdRecItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRecItm","OnAfterInsert")
 s INGRInew=1
 d VALINS^at299
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INGdRecItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRecItm","OnAfterUpdate")
 s INGRInew=1
 d VALUPD^at299
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INGdRecItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRecItm","OnBeforeDelete")
 d VALDEL^at299
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INGdRecItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRecItm","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRecItm","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INGdRecItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRecItm","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterINGRI">
<Data name="INGRI_BNetAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGRI_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INGRI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGRI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INGRI_CommItems_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INGRI_Disc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGRI_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INGRI_GrossAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGRI_HandChargeShare">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INGRI_INCGR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGRI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGRI_INPOI_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INGRI_Margin">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INGRI_NetAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INGRI_OverallDiscShare">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INGRI_PreVATAmt">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INGRI_RecQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INGRI_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INGRI_ServiceTax_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INGRI_StkDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGRI_TaxAmount">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INGRI_UnitCost">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^INGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_GdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_GdRec.INGR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GRI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCLBDR">
<Condition>{INGRI_INCLB_DR}'=""</Condition>
<Global>^INGRI</Global>
<PopulationPct>95</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>IN_GdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GRI_INCIB"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$CIBrow^at299({INGRI_INCLB_DR})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IN_GdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INGRI_RowId</SqlRowIdName>
<StreamLocation>^User.INGdRecItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
