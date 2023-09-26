Class dhc.ca.cache.data.Locs Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Locs_rowid, SqlTableName = Locs, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Locs_code
Property Locscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Locs_code ];

/// Locs_name
Property Locsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Locs_name ];

/// Locs_phones
Property Locsphones As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Locs_phones ];

/// Locs_location
Property Locslocation As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Locs_location ];

/// Locs_remark
Property Locsremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Locs_remark ];

/// Locs_start_date
Property Locsstartdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = Locs_start_date ];

/// Locs_end_date
Property Locsenddate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = Locs_end_date ];

/// Locs_active
Property Locsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = Locs_active ];

/// Locs_desc
Property Locsdesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Locs_desc ];

/// Locs_hosp_dr
Property Locshospdr As dhc.ca.cache.data.Hospitals [ SqlColumnNumber = 11, SqlFieldName = Locs_hosp_dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCALOCS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Locs_active">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Locs_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Locs_desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Locs_end_date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Locs_hosp_dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Locs_location">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Locs_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Locs_phones">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Locs_remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Locs_start_date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCCALOCS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_hosp_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospActive">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospActive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_hosp_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_active}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospCode">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_hosp_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospDesc">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_hosp_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospName">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_hosp_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCALOCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Locs_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Locs_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Locs_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.LocsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
