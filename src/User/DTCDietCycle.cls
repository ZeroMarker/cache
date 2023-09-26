/// Diet Cycle(2182)
Class User.DTCDietCycle Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DTC_DietCycle, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property CYCLEARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = CYCLE_ARCIM_DR ];

/// Des Ref ARCOS
Property CYCLEARCOSDR As ARCOrdSets [ SqlColumnNumber = 6, SqlFieldName = CYCLE_ARCOS_DR ];

/// Cycle Number
Property CYCLECycleNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CYCLE_CycleNumber ];

/// Des Ref DOW
Property CYCLEDOWDR As CTDayOfWeek [ SqlColumnNumber = 2, SqlFieldName = CYCLE_DOW_DR ];

/// Des Ref MealType
Property CYCLEMealTypeDR As DTCMealType [ SqlColumnNumber = 4, SqlFieldName = CYCLE_MealType_DR ];

Parameter EXTENTSIZE = 16;

Storage SQLStorage
{
<ExtentSize>16</ExtentSize>
<Property name="CYCLEARCIMDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CYCLEARCOSDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CYCLECycleNumber">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="CYCLEDOWDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CYCLEMealTypeDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^DTC("CYCLE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CYCLE_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CYCLE_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CYCLE_CycleNumber">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CYCLE_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CYCLE_MealType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CYCLE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CYCLE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CYCLE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCycle">
<Global>^DTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CYCLE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CYCLE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DOW"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CYCLE_DOW_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CYCLE_CycleNumber})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CYCLE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CYCLE_RowId</SqlRowIdName>
<StreamLocation>^User.DTCDietCycleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
