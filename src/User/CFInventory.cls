/// CF Inventory             (INCF,545)
Class User.CFInventory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_Inventory, StorageStrategy = SQLStorage ]
{

/// INCF RowId
Property INCFRowId As %Float [ InitialExpression = 1, Required, SqlFieldName = INCF_RowId ];

/// If Acknowledge is required for Iss/Trf
Property INCFAckFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = INCF_AckFlag ];

/// On Line inventory update flag
Property INCFOnLineInv As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = INCF_OnLineInv ];

/// Maxmimum locking wait time to update item
Property INCFLockWaitTime As %Float(MAXVAL = 50, MINVAL = 0) [ SqlColumnNumber = 4, SqlFieldName = INCF_LockWaitTime ];

/// Negative Stock
Property INCFNegStk As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = INCF_NegStk ];

/// Default Receive Type
Property INCFDefRecTypeDR As INCGdRecType [ SqlColumnNumber = 6, SqlFieldName = INCF_DefRecType_DR ];

/// Ward Stock Option
Property INCFWardStk As %String(DISPLAYLIST = ",Fixed Replenishment Qty,Replenish Up To Replenishment Qty", MAXLEN = 33, TRUNCATE = 1, VALUELIST = ",F,E") [ SqlColumnNumber = 7, SqlComputeCode = { s {INCF_WardStk}="E"
}, SqlComputed, SqlFieldName = INCF_WardStk ];

/// Counter Policy
Property INCFCounter As %String(DISPLAYLIST = ",Location Own Counter,One Counter for all Location", MAXLEN = 28, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 8, SqlComputeCode = { s {INCF_Counter}="O"
}, SqlComputed, SqlFieldName = INCF_Counter ];

/// Auto generate Ward Stk Replenishment
Property INCFAutoWdRep As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = INCF_AutoWdRep ];

/// Default Return Amount
Property INCFDFRetAmt As %String(DISPLAYLIST = ",Gross,Net,Null", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",G,N,L") [ SqlColumnNumber = 10, SqlComputeCode = { s {INCF_DFRetAmt}="G"
}, SqlComputed, SqlFieldName = INCF_DFRetAmt ];

/// Form Printing
Property INCFPrintForm As %String(DISPLAYLIST = ",Auto Print,Prompt,None", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",A,P,N") [ SqlColumnNumber = 11, SqlComputeCode = { s {INCF_PrintForm}="N"
}, SqlComputed, SqlFieldName = INCF_PrintForm ];

/// Is Batch No Required
Property INCFBatchReq As %String(DISPLAYLIST = ",Required,Optional,Non Required", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",R,O,N") [ SqlColumnNumber = 12, SqlFieldName = INCF_BatchReq ];

/// Is Expiry Date Required
Property INCFExpReq As %String(DISPLAYLIST = ",Required,Optional,Non Required", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",R,O,N") [ SqlColumnNumber = 13, SqlFieldName = INCF_ExpReq ];

/// Can modify Login Default ? (User Name)
Property INCFModiLoginDefUser As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = INCF_ModiLoginDefUser ];

/// Can modify default login location ?
Property INCFModiLoginDefLoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INCF_ModiLoginDefLoc ];

/// Only Receive Loc can Acknowledge Trf
Property INCFOwnLocAck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 16, SqlFieldName = INCF_OwnLocAck ];

/// Description
Property INCFDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = INCF_Description ];

/// Last Update Date
Property INCFUpdateDate As %Date [ SqlColumnNumber = 18, SqlFieldName = INCF_UpdateDate ];

/// Last Update Time
Property INCFUpdateTime As %Time [ SqlColumnNumber = 19, SqlFieldName = INCF_UpdateTime ];

/// Last Update User
Property INCFUpdateUserDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 20, SqlFieldName = INCF_UpdateUser_DR ];

/// Update AR Item Cost Upon Receive
Property INCFUpdateARCost As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = INCF_UpdateARCost ];

/// Allow to Receive More than Requested
Property INCFRecvMoreRequest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = INCF_RecvMoreRequest ];

/// Restrict Stock Transfer by StockTake Group
Property INCFRestrictTransferSTKGroup As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = INCF_RestrictTransferSTKGroup ];

/// Restrict Purchase Order by Purch Order Type
Property INCFRestrictPObyPOType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = INCF_RestrictPObyPOType ];

/// Recalculate Reorder Level/Quantity
Property INCFRecalculateReorderLevel As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = INCF_RecalculateReorderLevel ];

/// Recalculate Replenish Level/Quantity
Property INCFRecalculateReplenishLevel As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = INCF_RecalculateReplenishLevel ];

/// Skip No Stock Items on Add All
Property INCFSkipNoStockItemsonAddAll As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = INCF_SkipNoStockItemsonAddAll ];

/// Always Default To Transfer
Property INCFAlwaysDefaultToTransfer As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = INCF_AlwaysDefaultToTransfer ];

/// Days for Past Transaction
Property INCFDaysPastTransaction As %Float [ SqlColumnNumber = 29, SqlFieldName = INCF_DaysPastTransaction ];

/// Des Ref CodeCounter
Property INCFCodeCounterDR As PACCounterType [ SqlColumnNumber = 30, SqlFieldName = INCF_CodeCounter_DR ];

/// Ignore OE Tax
Property INCFIgnoreOETax As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = INCF_IgnoreOETax ];

/// AllowMixedTax
Property INCFAllowMixedTax As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = INCF_AllowMixedTax ];

/// ReturnNonPharmacyDiscon
Property INCFReturnNonPharmacyDiscon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = INCF_ReturnNonPharmacyDiscon ];

/// Return Pharmacy Stock upon Discon
Property INCFReturnPharmStockDiscon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = INCF_ReturnPharmStockDiscon ];

/// Unify Stock Take N Adjustment screens
Property INCFUnifyTakeNAdjustment As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = INCF_UnifyTakeNAdjustment ];

/// Docket Date Mandatory on Stock Rec
Property INCFDocketDateMandStockRec As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = INCF_DocketDateMandStockRec ];

/// Use Stock Loc Restr for stock Inquiry
Property INCFUseStkLocRestrInquiry As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = INCF_UseStkLocRestrInquiry ];

/// Show in Zero batches in STK Screen
Property INCFShowZeroBatchesSTK As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = INCF_ShowZeroBatchesSTK ];

/// PromptCommercialNameOnPO
Property INCFPromptCommercialNameOnPO As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = INCF_PromptCommercialNameOnPO ];

/// Disable OK Diff Vendors
Property INCFDisableOKDiffVendors As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = INCF_DisableOKDiffVendors ];

/// DefaultAvePriceOnStRec
Property INCFDefaultAvePriceOnStRec As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = INCF_DefaultAvePriceOnStRec ];

/// Transfer Acknowledge Reason Mandatory
Property INCFTransAckReasonMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = INCF_TransAckReasonMandatory ];

/// Do not Allow Update Stock Item Code
Property INCFDontUpdateStItemCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = INCF_DontUpdateStItemCode ];

/// RestrictDrugMOrdersByLoc
Property INCFRestrictDrugMOrdersByLoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = INCF_RestrictDrugMOrdersByLoc ];

/// StTransFormatNumber
Property INCFStTransFormatNumber As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = INCF_StTransFormatNumber ];

/// TransDecimalRestrict
Property INCFTransDecimalRestrict As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = INCF_TransDecimalRestrict ];

/// StReqDoNotAllowMultItems
Property INCFStReqDoNotAllowMultItems As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = INCF_StReqDoNotAllowMultItems ];

/// DelItmTransForNoStatusDrMan
Property INCFDelItmTransForNoStatusDrMan As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = INCF_DelItmTransForNoStatusDrMan ];

/// UseExternalStockSytem
Property INCFUseExternalStockSytem As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = INCF_UseExternalStockSytem ];

/// StTakeNoCountQtyDefault
Property INCFStTakeNoCountQtyDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = INCF_StTakeNoCountQtyDefault ];

/// StTakeGDFNewWay
Property INCFStTakeGDFNewWay As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = INCF_StTakeGDFNewWay ];

/// StTkSecondCountRequired
Property INCFStTkSecondCountRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = INCF_StTkSecondCountRequired ];

/// No SearchByAnyPart
Property INCFNoSearchByAnyPart As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = INCF_NoSearchByAnyPart ];

Index RowIDBasedIDKeyIndex On INCFRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFInventory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFInventory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFInventory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFInventory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFInventory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFInventory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFInventory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFInventory","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFInventory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFInventory","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFInventory","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<Property name="INCFAckFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFAllowMixedTax">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFAlwaysDefaultToTransfer">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFAutoWdRep">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFBatchReq">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INCFCodeCounterDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFCounter">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFDFRetAmt">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INCFDaysPastTransaction">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFDefRecTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFDefaultAvePriceOnStRec">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFDelItmTransForNoStatusDrMan">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFDescription">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFDisableOKDiffVendors">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFDocketDateMandStockRec">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFDontUpdateStItemCode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFExpReq">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INCFIgnoreOETax">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFLockWaitTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFModiLoginDefLoc">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFModiLoginDefUser">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFNegStk">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFNoSearchByAnyPart">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFOnLineInv">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFOwnLocAck">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFPrintForm">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INCFPromptCommercialNameOnPO">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFRecalculateReorderLevel">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFRecalculateReplenishLevel">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFRecvMoreRequest">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFRestrictDrugMOrdersByLoc">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFRestrictPObyPOType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFRestrictTransferSTKGroup">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFReturnNonPharmacyDiscon">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFReturnPharmStockDiscon">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFRowId">
<Selectivity>1</Selectivity>
</Property>
<Property name="INCFShowZeroBatchesSTK">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFSkipNoStockItemsonAddAll">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFStReqDoNotAllowMultItems">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFStTakeGDFNewWay">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFStTakeNoCountQtyDefault">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFStTkSecondCountRequired">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFStTransFormatNumber">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFTransAckReasonMandatory">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFTransDecimalRestrict">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFUnifyTakeNAdjustment">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFUpdateARCost">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFUpdateDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFUpdateTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFUpdateUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFUseExternalStockSytem">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCFUseStkLocRestrInquiry">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INCFWardStk">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>1</SqlIdExpression>
<SQLMap name="DataMasterINCF">
<Data name="INCF_AckFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCF_AllowMixedTax">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INCF_AlwaysDefaultToTransfer">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INCF_AutoWdRep">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCF_BatchReq">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCF_CodeCounter_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INCF_Counter">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCF_DFRetAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCF_DaysPastTransaction">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INCF_DefRecType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCF_DefaultAvePriceOnStRec">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INCF_DelItmTransForNoStatusDrMan">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INCF_Description">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INCF_DisableOKDiffVendors">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INCF_DocketDateMandStockRec">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INCF_DontUpdateStItemCode">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INCF_ExpReq">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INCF_IgnoreOETax">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INCF_LockWaitTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCF_ModiLoginDefLoc">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INCF_ModiLoginDefUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INCF_NegStk">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCF_NoSearchByAnyPart">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INCF_OnLineInv">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCF_OwnLocAck">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INCF_PrintForm">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCF_PromptCommercialNameOnPO">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INCF_RecalculateReorderLevel">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INCF_RecalculateReplenishLevel">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INCF_RecvMoreRequest">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INCF_RestrictDrugMOrdersByLoc">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INCF_RestrictPObyPOType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INCF_RestrictTransferSTKGroup">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INCF_ReturnNonPharmacyDiscon">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INCF_ReturnPharmStockDiscon">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INCF_ShowZeroBatchesSTK">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INCF_SkipNoStockItemsonAddAll">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INCF_StReqDoNotAllowMultItems">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INCF_StTakeGDFNewWay">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INCF_StTakeNoCountQtyDefault">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INCF_StTkSecondCountRequired">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INCF_StTransFormatNumber">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INCF_TransAckReasonMandatory">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INCF_TransDecimalRestrict">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INCF_UnifyTakeNAdjustment">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INCF_UpdateARCost">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INCF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INCF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INCF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INCF_UseExternalStockSytem">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INCF_UseStkLocRestrInquiry">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INCF_WardStk">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IN"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INCF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INCF_RowId</SqlRowIdName>
<StreamLocation>^User.CFInventoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
