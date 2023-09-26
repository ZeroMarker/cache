/// PJXBaseData
Class dhc.pa.inter.PJXBaseData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PJXBaseData_rowid, SqlTableName = PJXBaseData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PJXBaseData_ssUserDr
Property PJXBaseDatassUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PJXBaseData_ssUserDr ];

/// PJXBaseData_period
Property PJXBaseDataperiod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PJXBaseData_period ];

/// PJXBaseData_periodType
Property PJXBaseDataperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PJXBaseData_periodType ];

/// PJXBaseData_KPIDr
Property PJXBaseDataKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 5, SqlFieldName = PJXBaseData_KPIDr ];

/// PJXBaseData_actualValue
Property PJXBaseDataactualValue As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PJXBaseData_actualValue ];

/// PJXBaseData_auditDate
Property PJXBaseDataauditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PJXBaseData_auditDate ];

/// PJXBaseData_auditUserDr
Property PJXBaseDataauditUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PJXBaseData_auditUserDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAPJXBD(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="PJXBaseData_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PJXBaseData_actualValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PJXBaseData_auditDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PJXBaseData_auditUserDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PJXBaseData_period">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PJXBaseData_periodType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PJXBaseData_ssUserDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPAPJXBD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PJXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PJXBaseData_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPTPeriodKPI">
<Global>^DHCCJXPAPJXBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PJXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTPeriodKPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PJXBaseData_periodType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PJXBaseData_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PJXBaseData_KPIDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PJXBaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPTPeriodUser">
<Global>^DHCCJXPAPJXBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PJXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTPeriodUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PJXBaseData_periodType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PJXBaseData_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PJXBaseData_ssUserDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PJXBaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPTypePeriod">
<Global>^DHCCJXPAPJXBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PJXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTypePeriod"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PJXBaseData_periodType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PJXBaseData_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PJXBaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexssUser">
<Global>^DHCCJXPAPJXBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PJXBaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ssUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PJXBaseData_ssUserDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PJXBaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.PJXBaseDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
