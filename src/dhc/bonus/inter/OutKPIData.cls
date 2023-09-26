/// OutKPIData
Class dhc.bonus.inter.OutKPIData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OutKPIData_rowid, SqlTableName = OutKPIData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OutKPIData_outUnitCode
Property OutKPIDataoutUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OutKPIData_outUnitCode ];

/// OutKPIData_outUnitName
Property OutKPIDataoutUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OutKPIData_outUnitName ];

/// OutKPIData_outUnitLocCode
Property OutKPIDataoutUnitLocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OutKPIData_outUnitLocCode ];

/// OutKPIData_outUnitLocName
Property OutKPIDataoutUnitLocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OutKPIData_outUnitLocName ];

/// OutKPIData_unitType
Property OutKPIDataunitType As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OutKPIData_unitType ];

/// OutKPIData_outKpiCode
Property OutKPIDataoutKpiCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OutKPIData_outKpiCode ];

/// OutKPIData_outKpiName
Property OutKPIDataoutKpiName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OutKPIData_outKpiName ];

/// OutKPIData_period
Property OutKPIDataperiod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OutKPIData_period ];

/// OutKPIData_periodType
Property OutKPIDataperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = OutKPIData_periodType ];

/// OutKPIData_actValue
Property OutKPIDataactValue As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = OutKPIData_actValue ];

/// OutKPIData_active
Property OutKPIDataactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = OutKPIData_active ];

/// OutKPIData_handFlag
Property OutKPIDatahandFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = OutKPIData_handFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAOUTKPIDATA(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="OutKPIData_actValue">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OutKPIData_active">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OutKPIData_handFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OutKPIData_outKpiCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OutKPIData_outKpiName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OutKPIData_outUnitCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OutKPIData_outUnitLocCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OutKPIData_outUnitLocName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OutKPIData_outUnitName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OutKPIData_period">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OutKPIData_periodType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OutKPIData_unitType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^dhcbsOutKPIData</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OutKPIData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OutKPIData_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPTPKPICode">
<Global>^dhcbsOutKPIData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OutKPIData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTPKPICode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutKPIData_periodType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutKPIData_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutKPIData_outKpiCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutKPIData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPTPUnitCode">
<Global>^dhcbsOutKPIData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OutKPIData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTPUnitCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutKPIData_periodType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutKPIData_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutKPIData_outUnitCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutKPIData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPTPUnitType">
<Global>^dhcbsOutKPIData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OutKPIData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTPUnitType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutKPIData_periodType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutKPIData_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutKPIData_unitType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutKPIData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPTPeriod">
<Global>^dhcbsOutKPIData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OutKPIData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTPeriod"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutKPIData_periodType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutKPIData_period}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutKPIData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.bonus.inter.OutKPIDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
