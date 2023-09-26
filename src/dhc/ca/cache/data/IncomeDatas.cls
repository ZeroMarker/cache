Class dhc.ca.cache.data.IncomeDatas Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IncomeDatas_rowid, SqlTableName = IncomeDatas, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IncomeDatas_intervalDr
Property IncomeDatasintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 2, SqlFieldName = IncomeDatas_intervalDr ];

/// IncomeDatas_feeDate
Property IncomeDatasfeeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = IncomeDatas_feeDate ];

/// IncomeDatas_patType
Property IncomeDataspatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IncomeDatas_patType ];

/// IncomeDatas_itemCode
Property IncomeDatasitemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IncomeDatas_itemCode ];

/// IncomeDatas_itemName
Property IncomeDatasitemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IncomeDatas_itemName ];

/// IncomeDatas_itemDr
Property IncomeDatasitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 7, SqlFieldName = IncomeDatas_itemDr ];

/// IncomeDatas_fee
Property IncomeDatasfee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = IncomeDatas_fee ];

/// IncomeDatas_cost
Property IncomeDatascost As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = IncomeDatas_cost ];

/// IncomeDatas_fDeptCode
Property IncomeDatasfDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IncomeDatas_fDeptCode ];

/// IncomeDatas_fDeptName
Property IncomeDatasfDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IncomeDatas_fDeptName ];

/// IncomeDatas_fDeptDr
Property IncomeDatasfDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 12, SqlFieldName = IncomeDatas_fDeptDr ];

/// IncomeDatas_tDeptCode
Property IncomeDatastDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IncomeDatas_tDeptCode ];

/// IncomeDatas_tDeptName
Property IncomeDatastDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IncomeDatas_tDeptName ];

/// IncomeDatas_tDeptDr
Property IncomeDatastDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 15, SqlFieldName = IncomeDatas_tDeptDr ];

/// IncomeDatas_patDeptCode
Property IncomeDataspatDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IncomeDatas_patDeptCode ];

/// IncomeDatas_patDeptName
Property IncomeDataspatDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IncomeDatas_patDeptName ];

/// IncomeDatas_patDeptDr
Property IncomeDataspatDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 18, SqlFieldName = IncomeDatas_patDeptDr ];

/// IncomeDatas_inType
Property IncomeDatasinType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IncomeDatas_inType ];

/// IncomeDatas_inPersonDr
Property IncomeDatasinPersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 20, SqlFieldName = IncomeDatas_inPersonDr ];

/// IncomeDatas_remark
Property IncomeDatasremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IncomeDatas_remark ];

/// IncomeDatas_inDate
Property IncomeDatasinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = IncomeDatas_inDate ];

/// IncomeDatas_PatWardCode
Property IncomeDatasPatWardCode As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = IncomeDatas_PatWardCode ];

/// IncomeDatas_PatWardDesc
Property IncomeDatasPatWardDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = IncomeDatas_PatWardDesc ];

/// IncomeDatas_PatWardDr
Property IncomeDatasPatWardDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 25, SqlFieldName = IncomeDatas_PatWardDr ];

/// IncomeDatas_PatDocCode
Property IncomeDatasPatDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = IncomeDatas_PatDocCode ];

/// IncomeDatas_PatDocDesc
Property IncomeDatasPatDocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IncomeDatas_PatDocDesc ];

/// IncomeDatas_PatDocDr
Property IncomeDatasPatDocDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 28, SqlFieldName = IncomeDatas_PatDocDr ];

/// IncomeDatas_fDocCode
Property IncomeDatasfDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = IncomeDatas_fDocCode ];

/// IncomeDatas_fDocName
Property IncomeDatasfDocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = IncomeDatas_fDocName ];

/// IncomeDatas_fDocDr
Property IncomeDatasfDocDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 31, SqlFieldName = IncomeDatas_fDocDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINCOMEDATAS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="IncomeDatas_PatDocCode">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IncomeDatas_PatDocDesc">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IncomeDatas_PatDocDr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IncomeDatas_PatWardCode">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IncomeDatas_PatWardDesc">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IncomeDatas_PatWardDr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IncomeDatas_cost">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IncomeDatas_fDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IncomeDatas_fDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IncomeDatas_fDeptName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IncomeDatas_fDocCode">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IncomeDatas_fDocDr">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IncomeDatas_fDocName">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IncomeDatas_fee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IncomeDatas_feeDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IncomeDatas_inDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IncomeDatas_inPersonDr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IncomeDatas_inType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IncomeDatas_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IncomeDatas_itemCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IncomeDatas_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IncomeDatas_itemName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IncomeDatas_patDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IncomeDatas_patDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IncomeDatas_patDeptName">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IncomeDatas_patType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IncomeDatas_remark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IncomeDatas_tDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IncomeDatas_tDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IncomeDatas_tDeptName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCCAINCOMEDATAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInterval">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Interval"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalFdeptItem">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalFdeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_fDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalFdeptdr">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalFdeptdr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_fDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalFeedate">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalFeedate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_feeDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalInperdr">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalInperdr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_inPersonDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalIntype">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalIntype"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_inType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalItemdr">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalItemdr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalPatdeptItem">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalPatdeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_patDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalPatdeptdr">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalPatdeptdr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_patDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalPattype">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalPattype"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_patType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalTdeptItem">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalTdeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_tDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalTdeptdr">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalTdeptdr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_tDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalTypeFdept">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalTypeFdept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_patType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_fDeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalTypeFdeptItem">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalTypeFdeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_patType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_fDeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IncomeDatas_itemDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalTypePatdept">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalTypePatdept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_patType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_patDeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalTypePatdeptItem">
<Global>^DHCCAINCOMEDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>IncomeDatas_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalTypePatdeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IncomeDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IncomeDatas_patType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IncomeDatas_patDeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IncomeDatas_itemDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{IncomeDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.IncomeDatasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
