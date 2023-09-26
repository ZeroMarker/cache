Class dhc.ca.cache.data.DeptLevelSets Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DeptLevelSets_rowid, SqlTableName = DeptLevelSets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildLevelDepts As dhc.ca.cache.data.LevelDepts [ Cardinality = children, Inverse = LevelDeptsparRef ];

/// DeptLevelSets_code
Property DeptLevelSetscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DeptLevelSets_code ];

/// DeptLevelSets_name
Property DeptLevelSetsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DeptLevelSets_name ];

/// DeptLevelSets_shortcut
Property DeptLevelSetsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DeptLevelSets_shortcut ];

/// DeptLevelSets_remark
Property DeptLevelSetsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DeptLevelSets_remark ];

/// DeptLevelSets_end
Property DeptLevelSetsend As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DeptLevelSets_end ];

/// DeptLevelSets_active
Property DeptLevelSetsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DeptLevelSets_active ];

/// DeptLevelSets_parent
Property DeptLevelSetsparent As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DeptLevelSets_parent ];

/// DeptLevelSets_order
Property DeptLevelSetsorder As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DeptLevelSets_order ];

/// DeptLevelSets_repFlag
Property DeptLevelSetsrepFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DeptLevelSets_repFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCADEPTLEVELSETS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DeptLevelSets_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DeptLevelSets_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DeptLevelSets_end">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DeptLevelSets_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DeptLevelSets_order">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DeptLevelSets_parent">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DeptLevelSets_remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DeptLevelSets_repFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DeptLevelSets_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCADEPTLEVELSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DeptLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DeptLevelSets_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCADEPTLEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DeptLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptLevelSets_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DeptLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCADEPTLEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DeptLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptLevelSets_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DeptLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCADEPTLEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DeptLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptLevelSets_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DeptLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCCADEPTLEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DeptLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptLevelSets_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DeptLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParentOrder">
<Global>^DHCCADEPTLEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DeptLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParentOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptLevelSets_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DeptLevelSets_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DeptLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCADEPTLEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DeptLevelSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptLevelSets_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DeptLevelSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.DeptLevelSetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
