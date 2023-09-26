Class User.DHCEQPayPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PP_RowID, SqlTableName = DHC_EQPayPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PP_Desc
Property PPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PP_Desc ];

/// PP_SourceType
Property PPSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PP_SourceType ];

/// PP_SourceID
Property PPSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PP_SourceID ];

/// PP_PayType
Property PPPayType As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PP_PayType ];

/// PP_DateType
Property PPDateType As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PP_DateType ];

/// PP_PlanPayDate
Property PPPlanPayDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PP_PlanPayDate ];

/// PP_PeriodNum
Property PPPeriodNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PP_PeriodNum ];

/// PP_PeriodUnitDR
Property PPPeriodUnitDR As User.DHCEQCCycleUnit [ SqlColumnNumber = 9, SqlFieldName = PP_PeriodUnitDR ];

/// PP_PayPercent
Property PPPayPercent As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PP_PayPercent ];

/// PP_PayAmount
Property PPPayAmount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PP_PayAmount ];

/// PP_Condition
Property PPCondition As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PP_Condition ];

/// PP_PayFlag
Property PPPayFlag As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PP_PayFlag ];

/// PP_Remark
Property PPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PP_Remark ];

/// PP_Hold1
Property PPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PP_Hold1 ];

/// PP_Hold2
Property PPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PP_Hold2 ];

/// PP_Hold3
Property PPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PP_Hold3 ];

/// PP_Hold4
Property PPHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PP_Hold4 ];

/// PP_Hold5
Property PPHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PP_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPayPlan("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PP_Condition">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PP_DateType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PP_PayAmount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PP_PayFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PP_PayPercent">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PP_PayType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PP_PeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PP_PeriodUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PP_PlanPayDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PP_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PP_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQPayPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQPayPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPayPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
