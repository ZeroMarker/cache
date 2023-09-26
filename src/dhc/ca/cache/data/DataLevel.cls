Class dhc.ca.cache.data.DataLevel Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DataLevel_rowid, SqlTableName = DataLevel, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDataLevelLast As dhc.ca.cache.data.DataLevelLast [ Cardinality = children, Inverse = DataLevelLastparRef ];

/// DataLevel_code
Property DataLevelcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DataLevel_code ];

/// DataLevel_name
Property DataLevelname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DataLevel_name ];

/// DataLevel_desc
Property DataLeveldesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DataLevel_desc ];

/// DataLevel_remark
Property DataLevelremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DataLevel_remark ];

/// DataLevel_end
Property DataLevelend As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DataLevel_end ];

/// DataLevel_active
Property DataLevelactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DataLevel_active ];

/// DataLevel_parent
Property DataLevelparent As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DataLevel_parent ];

/// DataLevel_order
Property DataLevelorder As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DataLevel_order ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCADATALEVEL(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DataLevel_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DataLevel_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DataLevel_desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DataLevel_end">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DataLevel_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DataLevel_order">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DataLevel_parent">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DataLevel_remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCADATALEVEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DataLevel_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCADATALEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevel_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCADATALEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevel_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCADATALEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevel_desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCADATALEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevel_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCCADATALEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DataLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevel_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevel_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DataLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
