/// INC Item                 (INCI,262)
Class User.INCItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_Itm, StorageStrategy = SQLStorage ]
{

Relationship ChildINCItmLoc As INCItmLoc [ Cardinality = children, Inverse = INCILINCIParRef ];

Relationship ChildINCItmBat As INCItmBat [ Cardinality = children, Inverse = INCIBINCIParRef ];

Relationship ChildINCItmVen As INCItmVen [ Cardinality = children, Inverse = INCVParRef ];

Relationship ChildINCItmRcp As INCItmRcp [ Cardinality = children, Inverse = INRECParRef ];

Relationship ChildINCItmConsumption As INCItmConsumption [ Cardinality = children, Inverse = CONSParRef ];

Relationship ChildINCItmStockLocations As INCItmStockLocations [ Cardinality = children, Inverse = LOCParRef ];

Relationship ChildINCItmProp As INCItmProp [ Cardinality = children, Inverse = PropParRef ];

/// Des Ref to INCPO (Stock type/ PO Type)
Property INCIINCPODR As INCPOGroup [ SqlColumnNumber = 4, SqlFieldName = INCI_INCPO_DR ];

/// Des Ref to INCTG (Stock take group)
Property INCIINCTGDR As INCStkTkGp [ SqlColumnNumber = 5, SqlFieldName = INCI_INCTG_DR ];

/// Not Used Des Ref to INCCA (Ctrl Account)
Property INCIINCCADR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INCI_INCCA_DR ];

/// Des Ref to CTVAT (des ref to get VAT)
Property INCICTVATDR As CTVat [ SqlColumnNumber = 7, SqlFieldName = INCI_CTVAT_DR ];

/// Des Ref to CTLOC (Main Loc/Warehouse)
Property INCICTLOCDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = INCI_CTLOC_DR ];

/// Minimum Quantity (Safety stock level)
Property INCIMinQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 9, SqlFieldName = INCI_MinQty ];

/// Maximum Quantity (Limit of storage)
Property INCIMaxQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 10, SqlFieldName = INCI_MaxQty ];

/// Reorder Level (EOQ)
Property INCIReordLevel As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 11, SqlFieldName = INCI_ReordLevel ];

/// Reorder Quantity (EOQ)
Property INCIReordQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 12, SqlFieldName = INCI_ReordQty ];

/// Des Ref to CTUOM (Unit of Measurement)
Property INCICTUOMDR As CTUOM [ Required, SqlColumnNumber = 13, SqlFieldName = INCI_CTUOM_DR ];

/// Des Ref to INCSC (Stock category)
Property INCIINCSCDR As INCStkCat [ SqlColumnNumber = 14, SqlFieldName = INCI_INCSC_DR ];

/// Logical Quantity (Qty Available)
Property INCILogQty As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ InitialExpression = 0, SqlColumnNumber = 16, SqlFieldName = INCI_LogQty ];

/// Unit Cost
Property INCIUnitCost As %Float(MAXVAL = 99999999999.9999, MINVAL = -99999999999.9999) [ InitialExpression = 0, SqlColumnNumber = 28, SqlFieldName = INCI_UnitCost ];

/// Not Use Flag
Property INCINotUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 38, SqlFieldName = INCI_NotUseFlag ];

/// Issue Transfer Flag
Property INCIIsTrfFlag As %String(DISPLAYLIST = ",Issue Only,Transfer Only,Both Iss & Trf", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",I,T,B") [ InitialExpression = "Both Iss & Trf", Required, SqlColumnNumber = 41, SqlFieldName = INCI_IsTrfFlag ];

/// Des Ref to ARCIM 
Property INCIARCIMDR As ARCItmMast [ SqlColumnNumber = 43, SqlComputeCode = { i {INCI_OriginalARCIM_DR}="" s {INCI_ARCIM_DR}="" q
 s {INCI_ARCIM_DR}=$$CO43^at262({INCI_OriginalARCIM_DR})
}, SqlComputed, SqlFieldName = INCI_ARCIM_DR, Transient ];

/// Inventory Code
Property INCICode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 44, SqlFieldName = INCI_Code ];

/// Inventory Description
Property INCIDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = INCI_Desc ];

/// Remarks
Property INCIRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = INCI_Remarks, SqlListType = SUBNODE ];

/// Batch No Required
Property INCIBatchReq As %String(DISPLAYLIST = ",Required,Optional,Non Required", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",R,O,N") [ SqlColumnNumber = 48, SqlFieldName = INCI_BatchReq ];

/// Expiry Date Required
Property INCIExpReq As %String(DISPLAYLIST = ",Required,Optional,Non Required", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",R,O,N") [ SqlColumnNumber = 49, SqlFieldName = INCI_ExpReq ];

/// Original ARCIM Des Ref
Property INCIOriginalARCIMDR As ARCItmMast [ SqlColumnNumber = 50, SqlFieldName = INCI_OriginalARCIM_DR ];

/// Sterile Flag
Property INCISterile As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 51, SqlFieldName = INCI_Sterile ];

/// Dirty Qty
Property INCIDirtyQty As %Float [ SqlColumnNumber = 52, SqlFieldName = INCI_DirtyQty ];

/// Finance Category
Property INCIFinanceCategory As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = INCI_FinanceCategory ];

/// Des Ref INC SterCat
Property INCISterCatDR As INCSterileCategory [ SqlColumnNumber = 54, SqlFieldName = INCI_SterCat_DR ];

/// Update Date
Property INCIUpdateDate As %Date [ SqlColumnNumber = 55, SqlFieldName = INCI_UpdateDate ];

/// Update Time
Property INCIUpdateTime As %Time [ SqlColumnNumber = 56, SqlFieldName = INCI_UpdateTime ];

/// Update User
Property INCIUpdateUser As SSUser [ SqlColumnNumber = 57, SqlFieldName = INCI_UpdateUser ];

/// Stock Qty of Prev. Year
Property INCIStockQtyLastYear As %Float [ SqlColumnNumber = 58, SqlFieldName = INCI_StockQtyLastYear ];

/// Stock Amt of Prev. Year
Property INCIStockAmtLastYear As %Float [ SqlColumnNumber = 59, SqlFieldName = INCI_StockAmtLastYear ];

/// Des Ref CTUOM (Purchasing)
Property INCICTUOMPurchDR As CTUOM [ SqlColumnNumber = 60, SqlFieldName = INCI_CTUOM_Purch_DR ];

/// Des Ref Vendor
Property INCIFinalVendorDR As APCVendor [ SqlColumnNumber = 61, SqlComputeCode = { s {INCI_FinalVendor_DR}=$$CO61^at262({INCI_RowId})
}, SqlComputed, SqlFieldName = INCI_FinalVendor_DR, Transient ];

/// Stock Locations of item
Property INCIStockLocations As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 62, SqlFieldName = INCI_StockLocations ];

/// Ward Stock Replenishment Option
Property INCIWardStock As %String(DISPLAYLIST = ",Fixed Replenishment Qty,Replenish up to Replenishment Qty", MAXLEN = 33, TRUNCATE = 1, VALUELIST = ",F,E") [ SqlColumnNumber = 63, SqlFieldName = INCI_WardStock ];

/// BarCode
Property INCIBarCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 64, SqlFieldName = INCI_BarCode ];

/// Des Ref Account
Property INCIAccountDR As GLCAcct [ SqlColumnNumber = 65, SqlFieldName = INCI_Account_DR ];

/// Reporting Days
Property INCIReportingDays As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 66, SqlFieldName = INCI_ReportingDays ];

/// Des Ref Account1
Property INCIAccount1DR As GLCAcct [ SqlColumnNumber = 67, SqlFieldName = INCI_Account1_DR ];

/// Des Ref PrefVendor
Property INCIPrefVendorDR As APCVendor [ SqlColumnNumber = 68, SqlFieldName = INCI_PrefVendor_DR ];

/// Des Ref PackInstr
Property INCIPackInstrDR As INCPackInstructions [ SqlColumnNumber = 69, SqlFieldName = INCI_PackInstr_DR ];

/// Des Ref LightSens
Property INCILightSensDR As INCLightSensibility [ SqlColumnNumber = 70, SqlFieldName = INCI_LightSens_DR ];

/// 门诊最小发药单位
Property INCICTUOMOutPatDR As CTUOM [ SqlColumnNumber = 71, SqlFieldName = INCI_CTUOM_OutPat_DR ];

/// 住院最小发药单位
Property INCICTUOMInPatDR As CTUOM [ SqlColumnNumber = 72, SqlFieldName = INCI_CTUOM_InPat_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItm","OnAfterInsert")
 d POFILINS^at262
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItm","OnAfterUpdate")
 d POFILUPD^at262
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItm","OnBeforeDelete")
 d VALDEL^at262
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItm","OnBeforeUpdate")
 d VALUPD^at262
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItm","OnBeforeInsert")
 d VALINS^at262
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItm","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INCI(0))</SqlIdExpression>
<SQLMap name="DataMasterINCI">
<Data name="INCI_Account1_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>12</Piece>
</Data>
<Data name="INCI_Account_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>10</Piece>
</Data>
<Data name="INCI_BarCode">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>9</Piece>
</Data>
<Data name="INCI_BatchReq">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="INCI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="INCI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="INCI_CTUOM_InPat_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="INCI_CTUOM_OutPat_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="INCI_CTUOM_Purch_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="INCI_CTVAT_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="INCI_Code">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="INCI_Desc">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="INCI_DirtyQty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="INCI_ExpReq">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>11</Piece>
</Data>
<Data name="INCI_FinanceCategory">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>13</Piece>
</Data>
<Data name="INCI_INCCA_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="INCI_INCPO_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="INCI_INCSC_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="INCI_INCTG_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="INCI_IsTrfFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="INCI_LightSens_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>15</Piece>
</Data>
<Data name="INCI_LogQty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="INCI_MaxQty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="INCI_MinQty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="INCI_NotUseFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>9</Piece>
</Data>
<Data name="INCI_OriginalARCIM_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="INCI_PackInstr_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>14</Piece>
</Data>
<Data name="INCI_PrefVendor_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>13</Piece>
</Data>
<Data name="INCI_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INCI_ReordLevel">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="INCI_ReordQty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="INCI_ReportingDays">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>11</Piece>
</Data>
<Data name="INCI_SterCat_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>14</Piece>
</Data>
<Data name="INCI_Sterile">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>12</Piece>
</Data>
<Data name="INCI_StockAmtLastYear">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Data name="INCI_StockLocations">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>7</Piece>
</Data>
<Data name="INCI_StockQtyLastYear">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="INCI_UnitCost">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="INCI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="INCI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="INCI_UpdateUser">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="INCI_WardStock">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>8</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIMDR">
<Condition>{INCI_OriginalARCIM_DR}'=""</Condition>
<Global>^INCI</Global>
<PopulationPct>90</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIM_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$p({INCI_OriginalARCIM_DR},"||",1)</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBarCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BarCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCI_BarCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode1">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCI_Code})_"Z"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc1">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCI_Desc})_"Z"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCICode">
<Condition>{INCI_Code}'=""</Condition>
<ConditionFields>INCI_Code</ConditionFields>
<Global>^INCI</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INCI_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIDesc">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INCI_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMainStore">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MainStore"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPOType">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCI_INCPO_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrefVendRO">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrefVenRO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{INCI_PrefVendor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INCI_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexROLevelCode">
<Condition>
<![CDATA[{INCI_LogQty}<{INCI_ReordLevel}]]></Condition>
<ConditionFields>INCI_Code,INCI_LogQty,INCI_ReordLevel</ConditionFields>
<Global>^INCI</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ROCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCI_Code})_"Z"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexROLevelDesc">
<Condition>
<![CDATA[{INCI_LogQty}<{INCI_ReordLevel}]]></Condition>
<ConditionFields>INCI_Desc,INCI_LogQty,INCI_ReordLevel</ConditionFields>
<Global>^INCI</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RODesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCI_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSterCateg">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SterCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCI_SterCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSterile">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCI_Sterile}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStockCateg">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StkCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCI_INCSC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdate">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Update"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCI_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCI_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
