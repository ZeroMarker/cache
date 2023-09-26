Class dhc.ca.cache.data.DataLevelSets Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DataLevelSets_rowid, SqlTableName = DataLevelSets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildLevelItems As dhc.ca.cache.data.LevelItems [ Cardinality = children, Inverse = LevelItemsparRef ];

/// DataLevelSets_code
Property DataLevelSetscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DataLevelSets_code ];

/// DataLevelSets_name
Property DataLevelSetsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DataLevelSets_name ];

/// DataLevelSets_shortcut
Property DataLevelSetsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DataLevelSets_shortcut ];

/// DataLevelSets_remark
Property DataLevelSetsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DataLevelSets_remark ];

/// DataLevelSets_end
Property DataLevelSetsend As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DataLevelSets_end ];

/// DataLevelSets_active
Property DataLevelSetsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DataLevelSets_active ];

/// DataLevelSets_parent
Property DataLevelSetsparent As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DataLevelSets_parent ];

/// DataLevelSets_order
Property DataLevelSetsorder As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DataLevelSets_order ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCADATALEVELSETS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DataLevelSets_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DataLevelSets_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DataLevelSets_end">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DataLevelSets_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DataLevelSets_order">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DataLevelSets_parent">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DataLevelSets_remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DataLevelSets_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCADATALEVELSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DataLevelSets_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelSets_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelSets_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelSets_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DataLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelSets_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevelSets_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DataLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelSets_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DataLevelSetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
