Class User.DHCEQAMonthReportList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AMRL_RowID, SqlTableName = DHC_EQAMonthReportList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AMRL_Year
Property AMRLYear As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AMRL_Year ];

/// AMRL_Month
Property AMRLMonth As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = AMRL_Month ];

/// AMRL_LocDR
Property AMRLLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AMRL_LocDR ];

/// AMRL_MonthStr
Property AMRLMonthStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AMRL_MonthStr ];

/// AMRL_StockBegin
Property AMRLStockBegin As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = AMRL_StockBegin ];

/// AMRL_StockIn
Property AMRLStockIn As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = AMRL_StockIn ];

/// AMRL_StockReturn
Property AMRLStockReturn As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = AMRL_StockReturn ];

/// AMRL_StockReduce
Property AMRLStockReduce As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = AMRL_StockReduce ];

/// AMRL_StockMoveOut
Property AMRLStockMoveOut As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = AMRL_StockMoveOut ];

/// AMRL_StockMoveIn
Property AMRLStockMoveIn As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = AMRL_StockMoveIn ];

/// AMRL_StockEnd
Property AMRLStockEnd As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = AMRL_StockEnd ];

/// AMRL_StartDate
Property AMRLStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AMRL_StartDate ];

/// AMRL_EndDate
Property AMRLEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = AMRL_EndDate ];

/// AMRL_MakeDate
Property AMRLMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = AMRL_MakeDate ];

/// AMRL_MakeTime
Property AMRLMakeTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = AMRL_MakeTime ];

/// AMRL_MakeUserDR
Property AMRLMakeUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AMRL_MakeUserDR ];

/// AMRL_AccessoryTypeDR
Property AMRLAccessoryTypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 18, SqlFieldName = AMRL_AccessoryTypeDR ];

/// AMRL_AccessoryCatDR
Property AMRLAccessoryCatDR As User.DHCEQCAccessoryCat [ SqlColumnNumber = 19, SqlFieldName = AMRL_AccessoryCatDR ];

/// AMRL_Hold1
Property AMRLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AMRL_Hold1 ];

/// AMRL_Hold2
Property AMRLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AMRL_Hold2 ];

/// AMRL_Hold3
Property AMRLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AMRL_Hold3 ];

/// AMRL_Hold4
Property AMRLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AMRL_Hold4 ];

/// AMRL_Hold5
Property AMRLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AMRL_Hold5 ];

/// AMRL_Hold6
Property AMRLHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AMRL_Hold6 ];

/// AMRL_Hold7
Property AMRLHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AMRL_Hold7 ];

/// AMRL_Hold8
Property AMRLHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = AMRL_Hold8 ];

/// AMRL_Hold9
Property AMRLHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = AMRL_Hold9 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAMonthReportList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AMRL_AccessoryCatDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AMRL_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AMRL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AMRL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AMRL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AMRL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AMRL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AMRL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AMRL_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AMRL_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AMRL_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AMRL_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AMRL_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AMRL_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AMRL_MakeTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AMRL_MakeUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AMRL_Month">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AMRL_MonthStr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AMRL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AMRL_StockBegin">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AMRL_StockEnd">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AMRL_StockIn">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AMRL_StockMoveIn">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AMRL_StockMoveOut">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AMRL_StockReduce">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AMRL_StockReturn">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AMRL_Year">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQAMonthReportList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AMRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AMRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccessoryCat">
<Global>^DHCEQAMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AMRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AccessoryCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMRL_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMRL_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AMRL_AccessoryCatDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AMRL_LocDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AMRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQAMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AMRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMRL_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMRL_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AMRL_LocDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AMRL_AccessoryCatDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AMRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocType">
<Global>^DHCEQAMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AMRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LocType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMRL_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMRL_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AMRL_LocDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AMRL_AccessoryTypeDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AMRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonth">
<Global>^DHCEQAMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AMRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YearMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMRL_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMRL_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AMRL_AccessoryTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AMRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQAMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>AMRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AMRL_AccessoryTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AMRL_Year}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AMRL_Month}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AMRL_AccessoryCatDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AMRL_LocDR}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{AMRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAMonthReportListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
