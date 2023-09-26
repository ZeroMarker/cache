/// DHC IN Stock Take Itm
Class User.DHCInStkTkItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSTI_RowId, SqlTableName = DHC_InStkTkItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INSTIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCInStkTkItmWd As User.DHCInStkTkItmWd [ Cardinality = children, Inverse = INSTWINSTIParref ];

Relationship ChildDHCInStkTkItmTrack As User.DHCInStkTkItmTrack [ Cardinality = children, Inverse = INSTITINSTIParref ];

/// DHC_InStkTk Parent Reference
Relationship INSTIINSTParref As User.DHCInStkTk [ Cardinality = parent, Inverse = ChildDHCInStkTkItm, Required, SqlFieldName = INSTI_INST_Parref ];

/// INSTI_ChildSub
Property INSTIChildSub As %Library.Float [ InitialExpression = {$i(^DHCINST($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"STI",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INSTI_ChildSub ];

/// INSTI_INCLB_DR
Property INSTIINCLBDR As User.INCItmLcBt [ Required, SqlColumnNumber = 3, SqlFieldName = INSTI_INCLB_DR ];

/// INSTI_FreezeQty
Property INSTIFreezeQty As %Library.Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 4, SqlFieldName = INSTI_FreezeQty ];

/// INSTI_FreezeDate
Property INSTIFreezeDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = INSTI_FreezeDate ];

/// INSTI_FreezeTime
Property INSTIFreezeTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = INSTI_FreezeTime ];

/// INSTI_Count1Qty
Property INSTICount1Qty As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 7, SqlFieldName = INSTI_Count1Qty ];

/// INSTI_Count1Date
Property INSTICount1Date As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = INSTI_Count1Date ];

/// INSTI_Count1Time
Property INSTICount1Time As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = INSTI_Count1Time ];

/// INSTI_Count1Person_DR
Property INSTICount1PersonDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = INSTI_Count1Person_DR ];

/// INSTI_Variance1
Property INSTIVariance1 As %Library.Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 11, SqlFieldName = INSTI_Variance1 ];

/// INSTI_Remarks
Property INSTIRemarks As %Library.String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INSTI_Remarks ];

/// INSTI_Status
Property INSTIStatus As %Library.String(COLLATION = "AlphaUp", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INSTI_Status ];

/// INSTI_Count2Date
Property INSTICount2Date As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 14, SqlFieldName = INSTI_Count2Date ];

/// INSTI_Count2Time
Property INSTICount2Time As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = INSTI_Count2Time ];

/// INSTI_Count2Qty
Property INSTICount2Qty As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 16, SqlFieldName = INSTI_Count2Qty ];

/// INSTI_Count2Person_DR
Property INSTICount2PersonDR As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = INSTI_Count2Person_DR ];

/// INSTI_Variance2
Property INSTIVariance2 As %Library.Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 18, SqlFieldName = INSTI_Variance2 ];

/// INSTI_CTUOM_DR
Property INSTICTUOMDR As User.CTUOM [ SqlColumnNumber = 19, SqlFieldName = INSTI_CTUOM_DR ];

/// INSTI_INCI_DR
Property INSTIINCIDR As User.INCItm [ SqlColumnNumber = 20, SqlFieldName = INSTI_INCI_DR ];

/// INSTI_BatchNo
Property INSTIBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INSTI_BatchNo ];

/// INSTI_ExpiryDate
Property INSTIExpiryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = INSTI_ExpiryDate ];

/// INSTI_CTLOC_DR
Property INSTICTLOCDR As User.CTLoc [ SqlColumnNumber = 23, SqlFieldName = INSTI_CTLOC_DR ];

/// INSTI_INADI_DR
Property INSTIINADIDR As User.DHCINAdjItm [ SqlColumnNumber = 24, SqlFieldName = INSTI_INADI_DR ];

/// INSTI_StockCode
Property INSTIStockCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INSTI_StockCode ];

/// INSTI_StockDesc
Property INSTIStockDesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INSTI_StockDesc ];

/// INSTI_StockBarCode
Property INSTIStockBarCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INSTI_StockBarCode ];

/// INSTI_LocDFlag
Property INSTILocDFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INSTI_LocDFlag ];

/// INSTI_StkBinDesc
Property INSTIStkBinDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INSTI_StkBinDesc ];

/// INSTI_Sp
Property INSTISp As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = INSTI_Sp ];

/// INSTI_SpAmt
Property INSTIFreezeSpAmt As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = INSTI_FreezeSpAmt ];

/// INSTI_Rp
Property INSTIRp As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = INSTI_Rp ];

/// INSTI_RpAmt
Property INSTIFreezeRpAmt As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = INSTI_FreezeRpAmt ];

/// INSTI_Count1SpAmt
Property INSTICount1SpAmt As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = INSTI_Count1SpAmt ];

/// INSTI_Count1RpAmt
Property INSTICount1RpAmt As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = INSTI_Count1RpAmt ];

/// INSTI_Variance1SpAmt
Property INSTIVariance1SpAmt As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = INSTI_Variance1SpAmt ];

/// INSTI_Variance1RpAmt
Property INSTIVariance1RpAmt As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = INSTI_Variance1RpAmt ];

/// 应盘进价金额
Property INSTICount2RpAmt As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = INSTI_Count2RpAmt ];

/// 应盘售价金额
Property INSTICount2SpAmt As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = INSTI_Count2SpAmt ];

/// INSTI_SSUSR_Treasurer_DR 财务审核人
Property INSTISSUSRTreasurerDR As User.SSUser [ SqlColumnNumber = 40, SqlFieldName = INSTI_SSUSR_Treasurer_DR ];

/// INSTI_TreasurerDate  财务审核日期
Property INSTITreasurerDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 41, SqlFieldName = INSTI_TreasurerDate ];

/// INSTI_TreasurerTime  财务审核时间
Property INSTITreasurerTime As %Library.Time [ SqlColumnNumber = 42, SqlFieldName = INSTI_TreasurerTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DateMasterDHCINSTI">
<Data name="INSTI_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INSTI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INSTI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INSTI_Count1Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSTI_Count1Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSTI_Count1Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSTI_Count1RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INSTI_Count1SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INSTI_Count1Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSTI_Count2Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSTI_Count2Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSTI_Count2Qty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSTI_Count2RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INSTI_Count2SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INSTI_Count2Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSTI_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INSTI_FreezeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSTI_FreezeQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSTI_FreezeRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INSTI_FreezeSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INSTI_FreezeTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSTI_INADI_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INSTI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INSTI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSTI_LocDFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INSTI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INSTI_Rp">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INSTI_SSUSR_Treasurer_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INSTI_Sp">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INSTI_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INSTI_StkBinDesc">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INSTI_StockBarCode">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INSTI_StockCode">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INSTI_StockDesc">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INSTI_TreasurerDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INSTI_TreasurerTime">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INSTI_Variance1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INSTI_Variance1RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INSTI_Variance1SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INSTI_Variance2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCINST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INSTI_ChildSub</Field>
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
<Expression>{INSTI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarcode">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INSTI_StockBarCode})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INSTI_StockCode})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCLBDR">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INSTI_ChildSub</Field>
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
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemLocation">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"ITEMLOC"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocBarCode">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"LOCCODE"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INSTI_StockBarCode})</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocCode">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"LOCCODE"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INSTI_StockCode})</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDesc">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"LOCDESC"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INSTI_StockDesc})</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdesc">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INSTI_StockDesc})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInStkTkItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
