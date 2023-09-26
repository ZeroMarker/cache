Class dhc.ca.cache.data.LocLevel Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LocLevel_rowid, SqlTableName = LocLevel, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildLocLevelLast As dhc.ca.cache.data.LocLevelLast [ Cardinality = children, Inverse = LocLevelLastparRef ];

/// LocLevel_code
Property LocLevelcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LocLevel_code ];

/// LocLevel_name
Property LocLevelname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LocLevel_name ];

/// LocLevel_desc
Property LocLeveldesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LocLevel_desc ];

/// LocLevel_remark
Property LocLevelremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = LocLevel_remark ];

/// LocLevel_end
Property LocLevelend As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = LocLevel_end ];

/// LocLevel_active
Property LocLevelactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = LocLevel_active ];

/// LocLevel_parent
Property LocLevelparent As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = LocLevel_parent ];

/// LocLevel_order
Property LocLevelorder As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = LocLevel_order ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCALOCLEVEL(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="LocLevel_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LocLevel_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LocLevel_desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LocLevel_end">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LocLevel_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LocLevel_order">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LocLevel_parent">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LocLevel_remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCALOCLEVEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LocLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{LocLevel_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCALOCLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LocLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocLevel_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LocLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCALOCLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LocLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocLevel_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LocLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCALOCLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LocLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocLevel_desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LocLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCALOCLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LocLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocLevel_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LocLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCCALOCLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LocLevel_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LocLevel_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LocLevel_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LocLevel_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.LocLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
