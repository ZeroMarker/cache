/// JXGroup
Class dhc.pa.data.JXGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXGroup_rowid, SqlTableName = JXGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// JXGroup
Property JXGroupcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JXGroup_code ];

/// JXGroup_name
Property JXGroupname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JXGroup_name ];

/// JXGroup_IDSet
Property JXGroupIDSet As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JXGroup_IDSet ];

/// JXGroup_isInput
Property JXGroupisInput As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = JXGroup_isInput ];

/// JXGroup_type
Property JXGrouptype As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = JXGroup_type ];

/// JXGroup_desc
Property JXGroupdesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = JXGroup_desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAJXGROUP(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="JXGroup_IDSet">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JXGroup_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JXGroup_desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JXGroup_isInput">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JXGroup_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JXGroup_type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCCJXPAJXGROUP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JXGroup_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{JXGroup_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPAJXGROUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXGroup_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXGroup_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXGroup_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPAJXGROUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXGroup_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXGroup_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXGroup_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCCJXPAJXGROUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXGroup_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXGroup_type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXGroup_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeSet">
<Global>^DHCCJXPAJXGROUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>JXGroup_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXGroup_type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXGroup_IDSet}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JXGroup_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.JXGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
