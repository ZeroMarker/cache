Class User.DHCEQMonthReportList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MRL_RowID, SqlTableName = DHC_EQMonthReportList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MRL_Year
Property MRLYear As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MRL_Year ];

/// MRL_Month
Property MRLMonth As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = MRL_Month ];

/// MRL_LocDR
Property MRLLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = MRL_LocDR ];

/// MRL_MonthStr
Property MRLMonthStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MRL_MonthStr ];

/// MRL_StatCatDR
Property MRLStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 6, SqlFieldName = MRL_StatCatDR ];

/// MRL_StockBegin
Property MRLStockBegin As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = MRL_StockBegin ];

/// MRL_StockIn
Property MRLStockIn As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = MRL_StockIn ];

/// MRL_StockReturn
Property MRLStockReturn As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = MRL_StockReturn ];

/// MRL_StockReduce
Property MRLStockReduce As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = MRL_StockReduce ];

/// MRL_StockMoveOut
Property MRLStockMoveOut As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = MRL_StockMoveOut ];

/// MRL_StockMoveIn
Property MRLStockMoveIn As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = MRL_StockMoveIn ];

/// MRL_StockEnd
Property MRLStockEnd As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = MRL_StockEnd ];

/// MRL_UsedBegin
Property MRLUsedBegin As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = MRL_UsedBegin ];

/// MRL_UsedIn
Property MRLUsedIn As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = MRL_UsedIn ];

/// MRL_UsedReturn
Property MRLUsedReturn As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = MRL_UsedReturn ];

/// MRL_UsedMoveIn
Property MRLUsedMoveIn As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = MRL_UsedMoveIn ];

/// MRL_UsedMoveOut
Property MRLUsedMoveOut As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = MRL_UsedMoveOut ];

/// MRL_Disused
Property MRLDisused As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = MRL_Disused ];

/// MRL_UsedEnd
Property MRLUsedEnd As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = MRL_UsedEnd ];

/// MRL_StartDate
Property MRLStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = MRL_StartDate ];

/// MRL_EndDate
Property MRLEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = MRL_EndDate ];

/// MRL_MakeDate
Property MRLMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = MRL_MakeDate ];

/// MRL_MakeTime
Property MRLMakeTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = MRL_MakeTime ];

/// MRL_MakeUserDR
Property MRLMakeUserDR As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = MRL_MakeUserDR ];

/// MRL_Hold1
Property MRLChangeAccount As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = MRL_ChangeAccount ];

/// MRL_Hold2
Property MRLOrigin As User.DHCEQCOrigin [ SqlColumnNumber = 27, SqlFieldName = MRL_Origin ];

/// MRL_Hold3
Property MRLEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 28, SqlFieldName = MRL_EquipTypeDR ];

/// MRL_Hold4
Property MRLTotalDepre As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = MRL_TotalDepre ];

/// MRL_Hold5
Property MRLDepre As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = MRL_Depre ];

/// MRL_Hold6
Property MRLStockDisused As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = MRL_StockDisused ];

/// MRL_StoreMoveIn
Property MRLStoreMoveIn As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = MRL_StoreMoveIn ];

/// MRL_StoreMoveOut
Property MRLStoreMoveOut As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = MRL_StoreMoveOut ];

/// MRL_Hold1
Property MRLNetFee As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = MRL_NetFee ];

/// MRL_Hold2
Property MRLStockChangeAccount As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = MRL_StockChangeAccount ];

/// MRL_Hold3
Property MRLUsedReduce As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = MRL_UsedReduce ];

/// MRL_Hold4
Property MRLStockOther As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = MRL_StockOther ];

/// MRL_Hold5
Property MRLUsedOther As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = MRL_UsedOther ];

/// MRL_FundsTypeDR
Property MRLFundsTypeDR As User.DHCEQCFundsType [ SqlColumnNumber = 39, SqlFieldName = MRL_FundsTypeDR ];

/// MRL_Hold6
Property MRLHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = MRL_Hold6 ];

/// MRL_Hold7
Property MRLHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MRL_Hold7 ];

/// MRL_Hold8
Property MRLHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = MRL_Hold8 ];

/// MRL_Hold9
Property MRLHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = MRL_Hold9 ];

/// MRL_Hold10
Property MRLHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = MRL_Hold10 ];

/// MRL_Hold11
Property MRLHold11 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = MRL_Hold11 ];

/// MRL_Hold12
Property MRLHold12 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = MRL_Hold12 ];

/// MRL_ReportType
Property MRLReportType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = MRL_ReportType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMonthReportList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MRL_ChangeAccount">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MRL_Depre">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MRL_Disused">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MRL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MRL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MRL_FundsTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MRL_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MRL_Hold11">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MRL_Hold12">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MRL_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MRL_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MRL_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MRL_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MRL_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRL_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MRL_MakeTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MRL_MakeUserDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MRL_Month">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRL_MonthStr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRL_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MRL_Origin">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MRL_ReportType">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="MRL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MRL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRL_StockBegin">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRL_StockChangeAccount">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MRL_StockDisused">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MRL_StockEnd">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MRL_StockIn">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRL_StockMoveIn">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRL_StockMoveOut">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRL_StockOther">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MRL_StockReduce">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRL_StockReturn">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRL_StoreMoveIn">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MRL_StoreMoveOut">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MRL_TotalDepre">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MRL_UsedBegin">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MRL_UsedEnd">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MRL_UsedIn">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MRL_UsedMoveIn">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MRL_UsedMoveOut">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MRL_UsedOther">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MRL_UsedReduce">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MRL_UsedReturn">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MRL_Year">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQMonthReportList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>MRL_RowID</Field>
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
<Expression>{MRL_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRL_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRL_LocDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MRL_StatCatDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{MRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocType">
<Global>^DHCEQMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>MRL_RowID</Field>
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
<Expression>{MRL_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRL_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRL_LocDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MRL_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{MRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonth">
<Global>^DHCEQMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"YearMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MRL_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRL_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{MRL_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{MRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReportType">
<Global>^DHCEQMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>MRL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ReportType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>+{MRL_ReportType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MRL_Year}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{MRL_Month}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{MRL_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{MRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatCat">
<Global>^DHCEQMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>MRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StatCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRL_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRL_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRL_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MRL_LocDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{MRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQMonthReportList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>MRL_RowID</Field>
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
<Expression>{MRL_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRL_Year}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRL_Month}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MRL_StatCatDR}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{MRL_LocDR}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{MRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMonthReportListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
