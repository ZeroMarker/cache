Class User.DHCEQBuyRequestList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BRL_RowID, SqlTableName = DHC_EQBuyRequestList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BRL_BuyRequestDR
Property BRLBuyRequestDR As User.DHCEQBuyRequest [ SqlColumnNumber = 2, SqlFieldName = BRL_BuyRequestDR ];

/// BRL_Name
Property BRLName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BRL_Name ];

/// BRL_ModelDR
Property BRLModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = BRL_ModelDR ];

/// BRL_ManuFacDR
Property BRLManuFacDR As User.DHCEQCVendor [ SqlColumnNumber = 5, SqlFieldName = BRL_ManuFacDR ];

/// BRL_TestFlag
Property BRLTestFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = BRL_TestFlag ];

/// BRL_PriceFee
Property BRLPriceFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = BRL_PriceFee ];

/// BRL_QuantityNum
Property BRLQuantityNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = BRL_QuantityNum ];

/// BRL_TotalFee
Property BRLTotalFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BRL_TotalFee ];

/// BRL_Remark
Property BRLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BRL_Remark ];

/// BRL_UpdateUserDR
Property BRLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BRL_UpdateUserDR ];

/// BRL_UpdateDate
Property BRLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = BRL_UpdateDate ];

/// BRL_UpdateTime
Property BRLUpdateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = BRL_UpdateTime ];

/// BRL_BuyPlanDR
Property BRLBuyPlanDR As User.DHCEQBuyPlan [ SqlColumnNumber = 14, SqlFieldName = BRL_BuyPlanDR ];

/// BRL_CurrencyDR
Property BRLCurrencyDR As User.DHCEQCCurrency [ SqlColumnNumber = 15, SqlFieldName = BRL_CurrencyDR ];

/// BRL_EquipCatDR
Property BRLEquipCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 16, SqlFieldName = BRL_EquipCatDR ];

/// BRL_AdviseModel
Property BRLAdviseModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BRL_AdviseModel ];

/// BRL_ItemDR
Property BRLItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 18, SqlFieldName = BRL_ItemDR ];

/// BRL_RequestReason
Property BRLRequestReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BRL_RequestReason ];

/// BRL_ArriveDate
Property BRLArriveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = BRL_ArriveDate ];

/// BRL_RequestNum
Property BRLRequestNum As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = BRL_RequestNum ];

/// BRL_FundsOriginDR
Property BRLFundsOriginDR As User.DHCEQCFundsType [ SqlColumnNumber = 22, SqlFieldName = BRL_FundsOriginDR ];

/// BRL_PurchaseTypeDR
Property BRLPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 23, SqlFieldName = BRL_PurchaseTypeDR ];

/// BRL_PurposeTypeDR
Property BRLPurposeTypeDR As User.DHCEQCPurposeType [ SqlColumnNumber = 24, SqlFieldName = BRL_PurposeTypeDR ];

/// BRL_UnitDR
Property BRLUnitDR As User.DHCEQCUOM [ SqlColumnNumber = 25, SqlFieldName = BRL_UnitDR ];

/// BRL_StatCatDR
Property BRLStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 26, SqlFieldName = BRL_StatCatDR ];

/// BRL_LimitYearsNum
Property BRLLimitYearsNum As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = BRL_LimitYearsNum ];

/// BRL_Hold1
Property BRLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BRL_Hold1 ];

/// BRL_Hold2
Property BRLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BRL_Hold2 ];

/// BRL_Hold3
Property BRLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BRL_Hold3 ];

/// BRL_Hold4
Property BRLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = BRL_Hold4 ];

/// BRL_Hold5 设备功能(概要)
Property BRLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = BRL_Hold5 ];

/// BRL_Hold6
Property BRLHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = BRL_Hold6 ];

/// BRL_Hold7
Property BRLHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = BRL_Hold7 ];

/// BRL_Hold8
Property BRLHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = BRL_Hold8 ];

/// BRL_Hold9
Property BRLHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = BRL_Hold9 ];

/// BRL_Hold10
Property BRLHold10 As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = BRL_Hold10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuyRequestList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BRL_AdviseModel">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BRL_ArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BRL_BuyPlanDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BRL_BuyRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BRL_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BRL_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BRL_FundsOriginDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BRL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BRL_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BRL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BRL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BRL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BRL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BRL_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BRL_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="BRL_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BRL_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="BRL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BRL_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BRL_ManuFacDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BRL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BRL_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BRL_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BRL_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BRL_PurposeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BRL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BRL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BRL_RequestNum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BRL_RequestReason">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BRL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BRL_TestFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BRL_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BRL_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BRL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BRL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BRL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQBuyRequestList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuyRequest">
<Global>^DHCEQBuyRequestList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyRequest"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BRL_BuyRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuyRequestListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
