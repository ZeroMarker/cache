/// IN Purchase Order Details(1092)
Class User.INPOItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = IN_POItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INPOIChildsub [ IdKey, PrimaryKey, Unique ];

/// IN_PO Parent Reference
Relationship INPO As INPO [ Cardinality = parent, Inverse = ChildINPOItm, Required, SqlFieldName = IN_PO ];

/// INPOI Childsub(New Key)
Property INPOIChildsub As %Float [ InitialExpression = {$i(^INPO($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"POI",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INPOI_Childsub ];

/// Date Needed
Property INPOIDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = INPOI_Date ];

/// Des Ref to INCI
Property INPOIINCIDR As INCItm [ Required, SqlColumnNumber = 4, SqlFieldName = INPOI_INCI_DR ];

/// Des Ref to CTUOM
Property INPOICTUOMDR As CTUOM [ Required, SqlColumnNumber = 5, SqlFieldName = INPOI_CTUOM_DR ];

/// Unit Cost
Property INPOIUnitCost As %Float(MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = INPOI_UnitCost ];

/// Gross Amount
Property INPOIGrossAmt As %Float [ SqlColumnNumber = 7, SqlFieldName = INPOI_GrossAmt ];

/// Requested Quantity
Property INPOIReqQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ Required, SqlColumnNumber = 8, SqlFieldName = INPOI_Req_Qty ];

/// Purchase Qty
Property INPOIPurQty As %Float [ SqlColumnNumber = 9, SqlFieldName = INPOI_Pur_Qty ];

/// Remarks
Property INPOIRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = INPOI_Remarks, SqlListType = SUBNODE ];

/// Delivered Qty
Property INPOIDelivQty As %Float [ SqlColumnNumber = 11, SqlFieldName = INPOI_Deliv_Qty ];

/// Discount Rate
Property INPOIDisc As %Float(MAXVAL = 100, MINVAL = 0) [ SqlColumnNumber = 12, SqlFieldName = INPOI_Disc ];

/// Des Ref CTLOC
Property INPOICTLOCDR As CTLoc [ SqlColumnNumber = 13, SqlFieldName = INPOI_CTLOC_DR ];

/// Des Ref Goods receive type
Property INPOIINCGRDR As INCGdRecType [ SqlColumnNumber = 14, SqlFieldName = INPOI_INCGR_DR ];

/// Des Ref User
Property INPOIUserApprovedDR As SSUser [ SqlColumnNumber = 15, SqlFieldName = INPOI_UserApproved_DR ];

/// Date Approved
Property INPOIDateApproved As %Date [ SqlColumnNumber = 16, SqlFieldName = INPOI_DateApproved ];

/// TimeApproved
Property INPOITimeApproved As %Time [ SqlColumnNumber = 17, SqlFieldName = INPOI_TimeApproved ];

/// Tax Amount
Property INPOITaxAmount As %Float [ SqlColumnNumber = 18, SqlFieldName = INPOI_TaxAmount ];

/// Pre VAT Amount
Property INPOIPreVATAmount As %Float [ SqlColumnNumber = 19, SqlFieldName = INPOI_PreVATAmount ];

/// OutsQty
Property INPOIOutsQty As %Float [ SqlColumnNumber = 20, SqlFieldName = INPOI_OutsQty ];

/// Des Ref CommItems
Property INPOICommItemsDR As INCCommercialItem [ SqlColumnNumber = 21, SqlFieldName = INPOI_CommItems_DR ];

/// ConfirmedQtyUponXF
Property INPOIConfirmedQtyUponXF As %Float [ SqlColumnNumber = 22, SqlFieldName = INPOI_ConfirmedQtyUponXF ];

/// 第三方采购平台订单ID
Property INPOIThirdOrderDetailId As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INPOI_ThirdOrderDetailId ];

/// 医共体订单子表ID
Property INPOIHDCMDetailId As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INPOI_HDCMDetailId ];

/// Cancelled	取消标志
Property INPOICancelled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = INPOI_Cancelled ];

/// 草药产地
Property INPOIOrigDR As User.DHCSTOrigin [ SqlColumnNumber = 26, SqlFieldName = INPOI_Orig_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INPOItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPOItm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INPOItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPOItm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INPOItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPOItm","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INPOItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPOItm","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPOItm","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INPOItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INPOItm","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INPOI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INPOI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPOI_Cancelled">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INPOI_CommItems_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INPOI_ConfirmedQtyUponXF">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INPOI_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INPOI_DateApproved">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INPOI_Deliv_Qty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INPOI_Disc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INPOI_GrossAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INPOI_HDCMDetailId">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INPOI_INCGR_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INPOI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INPOI_Orig_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INPOI_OutsQty">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INPOI_PreVATAmount">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INPOI_Pur_Qty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPOI_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INPOI_Req_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INPOI_TaxAmount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INPOI_ThirdOrderDetailId">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INPOI_TimeApproved">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INPOI_UnitCost">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INPOI_UserApproved_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^INPO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_PO.IN_PO</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INPOI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_PO.IN_PO}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPOI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDHCMi">
<Global>^INPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO.IN_PO</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INPOI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HDCMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPOI_HDCMDetailId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO.IN_PO}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INPOI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^INPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO.IN_PO</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INPOI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPOI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO.IN_PO}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INPOI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocInci">
<Global>^INPO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IN_PO.IN_PO</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INPOI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LocInci"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INPOI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INPOI_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{IN_PO.IN_PO}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INPOI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutsINCI">
<Condition>{INPOI_OutsQty}</Condition>
<ConditionFields>INPOI_OutsQty</ConditionFields>
<Global>^INPO</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PO.IN_PO</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INPOI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutsINCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPOI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_PO.IN_PO}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INPOI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IN_POItm</SqlRowIdName>
<StreamLocation>^User.INPOItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
