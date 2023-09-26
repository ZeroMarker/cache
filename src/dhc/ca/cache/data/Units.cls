Class dhc.ca.cache.data.Units Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Units_rowid, SqlTableName = Units, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Units_code
Property Unitscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Units_code ];

/// Units_name
Property Unitsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Units_name ];

/// Units_shortcut
Property Unitsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Units_shortcut ];

/// Units_address
Property Unitsaddress As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Units_address ];

/// Units_phone
Property Unitsphone As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Units_phone ];

/// Units_contact
Property Unitscontact As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Units_contact ];

/// Units_remark
Property Unitsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Units_remark ];

/// Units_unitTypeDr
Property UnitsunitTypeDr As dhc.ca.cache.data.UnitTypes [ SqlColumnNumber = 9, SqlFieldName = Units_unitTypeDr ];

/// Units_active
Property Unitsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = Units_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAUNITS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Units_active">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Units_address">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Units_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Units_contact">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Units_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Units_phone">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Units_remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Units_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Units_unitTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCAUNITS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAUNITS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Units_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAUNITS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Units_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAUNITS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Units_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAUNITS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Units_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnittype">
<Global>^DHCCAUNITS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Unittype"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Units_unitTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnittypeActive">
<Global>^DHCCAUNITS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>L5</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnittypeActive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Units_unitTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Units_active}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnittypeCode">
<Global>^DHCCAUNITS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>L5</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnittypeCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Units_unitTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Units_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnittypeName">
<Global>^DHCCAUNITS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>L5</Expression>
<Field>Units_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnittypeName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Units_unitTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Units_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Units_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.UnitsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
