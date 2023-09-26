/// DHC_ICU_TotalIO
Class User.DHCICUTotalIO Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUTIO_RowId, SqlTableName = DHC_ICU_TotalIO, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCICUTotalIOItem As User.DHCICUTotalIOItem [ Cardinality = children, Inverse = ICUTIOIParref ];

Parameter EXTENTSIZE = 2500;

/// ICUTIO_ICUA_Dr
Property ICUTIOICUADr As User.DHCICUArrange [ SqlColumnNumber = 2, SqlFieldName = ICUTIO_ICUA_Dr ];

/// ICUTIO_StartDate
Property ICUTIOStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = ICUTIO_StartDate ];

/// ICUTIO_EndDate
Property ICUTIOEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = ICUTIO_EndDate ];

/// ICUTIO_StartTime
Property ICUTIOStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = ICUTIO_StartTime ];

/// ICUTIO_EndTime
Property ICUTIOEndTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = ICUTIO_EndTime ];

/// ICUTIO_TotalInput
Property ICUTIOTotalInput As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ICUTIO_TotalInput ];

/// ICUTIO_TotalOutput
Property ICUTIOTotalOutput As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ICUTIO_TotalOutput ];

/// ICUTIO_AmtFluidInfused
Property ICUTIOAmtFluidInfused As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ICUTIO_AmtFluidInfused ];

/// ICUTIO_AmtBloodTranfused
Property ICUTIOAmtBloodTranfused As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ICUTIO_AmtBloodTranfused ];

/// ICUTIO_AmtWater
Property ICUTIOAmtWater As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ICUTIO_AmtWater ];

/// ICUTIO_AmtFood
Property ICUTIOAmtFood As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ICUTIO_AmtFood ];

/// ICUTIO_AmtOtherInput
Property ICUTIOAmtOtherInput As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = ICUTIO_AmtOtherInput ];

/// ICUTIO_AmtUrine
Property ICUTIOAmtUrine As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = ICUTIO_AmtUrine ];

/// ICUTIO_AmtBloodLoss
Property ICUTIOAmtBloodLoss As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = ICUTIO_AmtBloodLoss ];

/// ICUTIO_AmtBodyFluidLoss
Property ICUTIOAmtBodyFluidLoss As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ICUTIO_AmtBodyFluidLoss ];

/// ICUTIO_AmtDialysisLoss
Property ICUTIOAmtDialysisLoss As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = ICUTIO_AmtDialysisLoss ];

/// ICUTIO_AmtOtherOutput
Property ICUTIOAmtOtherOutput As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = ICUTIO_AmtOtherOutput ];

/// ICUTIO_CreateUser_Dr
Property ICUTIOCreateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ICUTIO_CreateUser_Dr ];

/// ICUTIO_CreateDate
Property ICUTIOCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = ICUTIO_CreateDate ];

/// ICUTIO_CreateTime
Property ICUTIOCreateTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = ICUTIO_CreateTime ];

/// ICUTIO_UpdateUser_Dr
Property ICUTIOUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = ICUTIO_UpdateUser_Dr ];

/// ICUTIO_UpdateDate
Property ICUTIOUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = ICUTIO_UpdateDate ];

/// ICUTIO_UpdateTime
Property ICUTIOUpdateTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = ICUTIO_UpdateTime ];

/// ICUTIO_Summary
Property ICUTIOSummary As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ICUTIO_Summary ];

/// ICUTIO_AmtMannitol
Property ICUTIOAmtMannitol As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = ICUTIO_AmtMannitol ];

/// ICUTIO_LiquidOralIntakes
Property ICUTIOLiquidOralIntakes As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = ICUTIO_LiquidOralIntakes ];

/// ICUTIO_SolidOralIntakes
Property ICUTIOSolidOralIntakes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = ICUTIO_SolidOralIntakes ];

/// ICUTIO_GstDecompression
Property ICUTIOGstDecompression As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = ICUTIO_GstDecompression ];

/// ICUTIO_AmtStool
Property ICUTIOAmtStool As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = ICUTIO_AmtStool ];

/// ICUTIO_MinipumpIntakes
Property ICUTIOMinipumpIntakes As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = ICUTIO_MinipumpIntakes ];

/// ICUTIO_SummaryData
Property ICUTIOSummaryData As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = ICUTIO_SummaryData ];

/// ICUTIO_PlanIntakes
Property ICUTIOPlanIntakes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = ICUTIO_PlanIntakes ];

/// ICUTIO_PlanDrugIntakes
Property ICUTIOPlanDrugIntakes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ICUTIO_PlanDrugIntakes ];

Storage SQLStorage
{
<ExtentSize>2500</ExtentSize>
<SqlIdExpression>$i(^DHCICUTotalIO(0))</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="ICUTIO_AmtBloodLoss">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ICUTIO_AmtBloodTranfused">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUTIO_AmtBodyFluidLoss">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ICUTIO_AmtDialysisLoss">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ICUTIO_AmtFluidInfused">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUTIO_AmtFood">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUTIO_AmtMannitol">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ICUTIO_AmtOtherInput">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUTIO_AmtOtherOutput">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ICUTIO_AmtStool">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ICUTIO_AmtUrine">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ICUTIO_AmtWater">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUTIO_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ICUTIO_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ICUTIO_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ICUTIO_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUTIO_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUTIO_GstDecompression">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ICUTIO_ICUA_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUTIO_LiquidOralIntakes">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ICUTIO_MinipumpIntakes">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ICUTIO_PlanDrugIntakes">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ICUTIO_PlanIntakes">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ICUTIO_SolidOralIntakes">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ICUTIO_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUTIO_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUTIO_Summary">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ICUTIO_SummaryData">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ICUTIO_TotalInput">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUTIO_TotalOutput">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUTIO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ICUTIO_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ICUTIO_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^DHCICUTotalIO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICUTIO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ICUTIO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICUArrange">
<Global>^DHCICUTotalIO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUTIO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICUA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUTIO_ICUA_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUTIO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCICUTotalIO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICUTIO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUTIO_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUTIO_ICUA_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUTIO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUTotalIOS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
