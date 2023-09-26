Class dhc.ca.cache.data.Hospitals Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Hospitals_rowid, SqlTableName = Hospitals, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Hospitals_code
Property Hospitalscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Hospitals_code ];

/// Hospitals_name
Property Hospitalsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Hospitals_name ];

/// Hospitals_desc
Property Hospitalsdesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Hospitals_desc ];

/// Hospitals_remark
Property Hospitalsremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Hospitals_remark ];

/// Hospitals_active
Property Hospitalsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = Hospitals_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAHOSPITALS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Hospitals_active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Hospitals_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Hospitals_desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Hospitals_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Hospitals_remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCAHOSPITALS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Hospitals_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Hospitals_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAHOSPITALS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Hospitals_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Hospitals_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Hospitals_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAHOSPITALS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Hospitals_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Hospitals_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Hospitals_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCAHOSPITALS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Hospitals_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Hospitals_desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Hospitals_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAHOSPITALS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Hospitals_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Hospitals_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Hospitals_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.HospitalsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
