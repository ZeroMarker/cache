Class User.DHCEQBuyRequestDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BRD_RowID, SqlTableName = DHC_EQBuyRequestDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BRD_BuyRequestListDR
Property BRDBuyRequestListDR As User.DHCEQBuyRequestList [ SqlColumnNumber = 2, SqlFieldName = BRD_BuyRequestListDR ];

/// BRD_Material
Property BRDMaterial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BRD_Material ];

/// BRD_OperatorCount
Property BRDOperatorCount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BRD_OperatorCount ];

/// BRD_MedicalItem
Property BRDMedicalItem As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BRD_MedicalItem ];

/// BRD_Consumption
Property BRDConsumption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BRD_Consumption ];

/// BRD_YearRunTime
Property BRDYearRunTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BRD_YearRunTime ];

/// BRD_RatingPower
Property BRDRatingPower As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BRD_RatingPower ];

/// BRD_CountInLoc
Property BRDCountInLoc As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BRD_CountInLoc ];

/// BRD_DepreLimitYear
Property BRDDepreLimitYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BRD_DepreLimitYear ];

/// BRD_FeeOfEmployee
Property BRDFeeOfEmployee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BRD_FeeOfEmployee ];

/// BRD_FeeOfDepre
Property BRDFeeOfDepre As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BRD_FeeOfDepre ];

/// BRD_FeeOfMaterial
Property BRDFeeOfMaterial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BRD_FeeOfMaterial ];

/// BRD_UsePerWeekNum
Property BRDUsePerWeekNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BRD_UsePerWeekNum ];

/// BRD_WorkLoadPerWeekNum
Property BRDWorkLoadPerWeekNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BRD_WorkLoadPerWeekNum ];

/// BRD_UsePriceFee
Property BRDUsePriceFee As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = BRD_UsePriceFee ];

/// BRD_UseYearsNum
Property BRDUseYearsNum As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = BRD_UseYearsNum ];

/// BRD_ReclaimYearsNum
Property BRDReclaimYearsNum As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = BRD_ReclaimYearsNum ];

/// BRD_CountNum
Property BRDCountNum As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = BRD_CountNum ];

/// BRD_UseRate
Property BRDUseRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BRD_UseRate ];

/// BRD_GoodRate
Property BRDGoodRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BRD_GoodRate ];

/// BRD_YearIncomeFee
Property BRDYearIncomeFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BRD_YearIncomeFee ];

/// BRD_CostFee
Property BRDCostFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BRD_CostFee ];

/// BRD_YearMaintFee
Property BRDYearMaintFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BRD_YearMaintFee ];

/// BRD_AdviseModel
Property BRDAdviseModel As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BRD_AdviseModel ];

/// BRD_Hold1	使用状况
Property BRDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = BRD_Hold1 ];

/// BRD_Hold2	与现有同类设备共性
Property BRDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BRD_Hold2 ];

/// BRD_Hold3	与现有同类设备区别
Property BRDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BRD_Hold3 ];

/// BRD_Hold4	耗材名称
Property BRDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BRD_Hold4 ];

/// BRD_Hold5	耗材规格型号
Property BRDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BRD_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuyRequestDetail("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BRD_AdviseModel">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BRD_BuyRequestListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BRD_Consumption">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BRD_CostFee">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BRD_CountInLoc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BRD_CountNum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BRD_DepreLimitYear">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BRD_FeeOfDepre">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BRD_FeeOfEmployee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BRD_FeeOfMaterial">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BRD_GoodRate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BRD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BRD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BRD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BRD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BRD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BRD_Material">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BRD_MedicalItem">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BRD_OperatorCount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BRD_RatingPower">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BRD_ReclaimYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BRD_UsePerWeekNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BRD_UsePriceFee">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BRD_UseRate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BRD_UseYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BRD_WorkLoadPerWeekNum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BRD_YearIncomeFee">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BRD_YearMaintFee">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BRD_YearRunTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQBuyRequestDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BRD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BRD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuyRequestList">
<Global>^DHCEQBuyRequestDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BRD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyRequestList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BRD_BuyRequestListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BRD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuyRequestDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
