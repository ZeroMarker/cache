Class User.DHCEQBuyPlanList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BPL_RowID, SqlTableName = DHC_EQBuyPlanList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BPL_BuyPlanDR
Property BPLBuyPlanDR As User.DHCEQBuyPlan [ SqlColumnNumber = 2, SqlFieldName = BPL_BuyPlanDR ];

/// BPL_Name
Property BPLName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BPL_Name ];

/// BPL_ModelDR
Property BPLModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = BPL_ModelDR ];

/// BPL_ManuFacDR
Property BPLManuFacDR As User.DHCEQCVendor [ SqlColumnNumber = 5, SqlFieldName = BPL_ManuFacDR ];

/// BPL_TestFlag
Property BPLTestFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = BPL_TestFlag ];

/// BPL_PriceFee
Property BPLPriceFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = BPL_PriceFee ];

/// BPL_QuantityNum
Property BPLQuantityNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = BPL_QuantityNum ];

/// BPL_TotalFee
Property BPLTotalFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BPL_TotalFee ];

/// BPL_Remark
Property BPLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BPL_Remark ];

/// BPL_BuyRequestListDR
Property BPLBuyRequestListDR As User.DHCEQBuyRequestList [ SqlColumnNumber = 11, SqlFieldName = BPL_BuyRequestListDR ];

/// BPL_ExecNum
Property BPLExecNum As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = BPL_ExecNum ];

/// BPL_UpdateUserDR
Property BPLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BPL_UpdateUserDR ];

/// BPL_UpdateDate
Property BPLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = BPL_UpdateDate ];

/// BPL_UpdateTime
Property BPLUpdateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = BPL_UpdateTime ];

/// BPL_CurrencyDR
Property BPLCurrencyDR As User.DHCEQCCurrency [ SqlColumnNumber = 16, SqlFieldName = BPL_CurrencyDR ];

/// BPL_EquipCatDR
Property BPLEquipCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 17, SqlFieldName = BPL_EquipCatDR ];

/// BPL_ArriveNum
Property BPLArriveNum As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = BPL_ArriveNum ];

/// BPL_ItemDR
Property BPLItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 19, SqlFieldName = BPL_ItemDR ];

/// BPL_ArriveDate
Property BPLArriveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = BPL_ArriveDate ];

/// BPL_Hold3
Property BPLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BPL_Hold3 ];

/// BPL_RefuseFlag
Property BPLRefuseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = BPL_RefuseFlag ];

/// BPL_RefuseReason
Property BPLRefuseReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BPL_RefuseReason ];

/// BPL_ContractNum
Property BPLContractNum As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = BPL_ContractNum ];

/// BPL_Hold1
Property BPLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BPL_Hold1 ];

/// BPL_Hold2
Property BPLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = BPL_Hold2 ];

/// BPL_Hold4
Property BPLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BPL_Hold4 ];

/// BPL_Hold5
Property BPLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BPL_Hold5 ];

/// add by csj 20191127
Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
	Set buyplandr = {BPL_BuyPlanDR}
	d ##class(web.DHCEQ.EM.BUSBuyPlan).AfterUpdateBPList(buyplandr)
}

/// add by csj 20191127
Trigger AfterUpdate [ Event = UPDATE, Time = AFTER ]
{
	Set buyplandr = {BPL_BuyPlanDR}
	d ##class(web.DHCEQ.EM.BUSBuyPlan).AfterUpdateBPList(buyplandr)
}

/// add by csj 20191128
Trigger AfterDelete [ Event = DELETE, Time = AFTER ]
{
	Set buyplandr = {BPL_BuyPlanDR}
	d ##class(web.DHCEQ.EM.BUSBuyPlan).AfterUpdateBPList(buyplandr)
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuyPlanList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BPL_ArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BPL_ArriveNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BPL_BuyPlanDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BPL_BuyRequestListDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BPL_ContractNum">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BPL_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BPL_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BPL_ExecNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BPL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BPL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BPL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BPL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BPL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BPL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BPL_ManuFacDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BPL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BPL_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BPL_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BPL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BPL_RefuseFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BPL_RefuseReason">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BPL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BPL_TestFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BPL_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BPL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BPL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BPL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQBuyPlanList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BPL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BPL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuyPlan">
<Global>^DHCEQBuyPlanList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BPL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyPlan"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BPL_BuyPlanDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBuyRequestList">
<Global>^DHCEQBuyPlanList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BPL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyRequestList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BPL_BuyRequestListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuyPlanListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
