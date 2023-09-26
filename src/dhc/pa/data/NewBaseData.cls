/// NewBaseData
Class dhc.pa.data.NewBaseData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXBaseData_rowid, SqlTableName = NewBaseData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// JXBaseData_period
Property JXBaseDataperiod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JXBaseData_period ];

/// JXBaseData_periodType
Property JXBaseDataperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JXBaseData_periodType ];

/// JXBaseData_jxUnitDr
Property JXBaseDatajxUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 4, SqlFieldName = JXBaseData_jxUnitDr ];

/// JXBaseData_jxUnitCode
Property JXBaseDatajxUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = JXBaseData_jxUnitCode ];

/// JXBaseData_jxUnitName
Property JXBaseDatajxUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = JXBaseData_jxUnitName ];

/// JXBaseData_KPIDr
Property JXBaseDataKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 7, SqlFieldName = JXBaseData_KPIDr ];

/// JXBaseData_KPICode
Property JXBaseDataKPICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = JXBaseData_KPICode ];

/// JXBaseData_KPIName
Property JXBaseDataKPIName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = JXBaseData_KPIName ];

/// JXBaseData_actualValue
Property JXBaseDataactualValue As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = JXBaseData_actualValue ];

/// JXBaseData_auditDate
Property JXBaseDataauditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = JXBaseData_auditDate ];

/// JXBaseData_auditUserDr
Property JXBaseDataauditUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = JXBaseData_auditUserDr ];

/// JXBaseData_dataState
Property JXBaseDatadataState As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = JXBaseData_dataState ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAJXBASEDATA(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="JXBaseData_KPICode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JXBaseData_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JXBaseData_KPIName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JXBaseData_actualValue">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JXBaseData_auditDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JXBaseData_auditUserDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="JXBaseData_dataState">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JXBaseData_jxUnitCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JXBaseData_jxUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JXBaseData_jxUnitName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JXBaseData_period">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JXBaseData_periodType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAJXBASEDATA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{JXBaseData_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPPT">
<Global>^DHCCJXPAJXBASEDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>JXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PeriodPeriodType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXBaseData_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXBaseData_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JXBaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPTKpiCode">
<Global>^DHCCJXPAJXBASEDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>JXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPTKpiCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXBaseData_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXBaseData_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JXBaseData_KPICode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{JXBaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPTUnitCode">
<Global>^DHCCJXPAJXBASEDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>JXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPTUnitCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXBaseData_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXBaseData_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JXBaseData_jxUnitCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{JXBaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPTUnitKpi">
<Global>^DHCCJXPAJXBASEDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>JXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPTUnitKpi"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXBaseData_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXBaseData_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JXBaseData_jxUnitDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{JXBaseData_KPIDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{JXBaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.NewBaseDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
