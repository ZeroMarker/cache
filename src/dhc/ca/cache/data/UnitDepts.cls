Class dhc.ca.cache.data.UnitDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UnitDepts_rowid, SqlTableName = UnitDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UnitDepts_code
Property UnitDeptscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = UnitDepts_code ];

/// UnitDepts_name
Property UnitDeptsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UnitDepts_name ];

/// UnitDepts_shortcut
Property UnitDeptsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UnitDepts_shortcut ];

/// UnitDepts_address
Property UnitDeptsaddress As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UnitDepts_address ];

/// UnitDepts_remark
Property UnitDeptsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UnitDepts_remark ];

/// UnitDepts_start
Property UnitDeptsstart As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = UnitDepts_start ];

/// UnitDepts_stop
Property UnitDeptsstop As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = UnitDepts_stop ];

/// UnitDepts_unitDr
Property UnitDeptsunitDr As dhc.ca.cache.data.Units [ SqlColumnNumber = 9, SqlFieldName = UnitDepts_unitDr ];

/// UnitDepts_propertyDr
Property UnitDeptspropertyDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UnitDepts_propertyDr ];

/// UnitDepts_active
Property UnitDeptsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = UnitDepts_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAUNITDEPTS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="UnitDepts_active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UnitDepts_address">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UnitDepts_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UnitDepts_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UnitDepts_propertyDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UnitDepts_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UnitDepts_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UnitDepts_start">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UnitDepts_stop">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UnitDepts_unitDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCAUNITDEPTS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnit">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Unit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitActive">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitActive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_active}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitCode">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitName">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitProperty">
<Global>^DHCCAUNITDEPTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UnitDepts_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitProperty"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitDepts_unitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitDepts_propertyDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitDepts_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.UnitDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
