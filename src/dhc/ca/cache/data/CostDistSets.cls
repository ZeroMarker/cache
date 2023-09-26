Class dhc.ca.cache.data.CostDistSets Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CostDistSets_rowid, SqlTableName = CostDistSets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildCostResultData As dhc.ca.cache.data.CostResultData [ Cardinality = children, Inverse = CostResultDataparRef ];

Relationship ChildCostDistMethods As dhc.ca.cache.data.CostDistMethods [ Cardinality = children, Inverse = CostDistMethodsparRef ];

Relationship ChildCostResultSum As dhc.ca.cache.data.CostResultSum [ Cardinality = children, Inverse = CostResultSumparRef ];

Relationship ChildDeptAmount As dhc.ca.cache.data.DeptAmount [ Cardinality = children, Inverse = DeptAmountparRef ];

Relationship ChildDeptCostDetial As dhc.ca.cache.data.DeptCostDetial [ Cardinality = children, Inverse = DeptCostDetialparRef ];

Relationship ChildDeptCostItem As dhc.ca.cache.data.DeptCostItem [ Cardinality = children, Inverse = DeptCostItemparRef ];

Relationship ChildDeptCostSrc As dhc.ca.cache.data.DeptCostSrc [ Cardinality = children, Inverse = DeptCostSrcparRef ];

/// CostDistSets_order
Property CostDistSetsorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = CostDistSets_order ];

/// CostDistSets_code
Property CostDistSetscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CostDistSets_code ];

/// CostDistSets_name
Property CostDistSetsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CostDistSets_name ];

/// CostDistSets_shortcut
Property CostDistSetsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CostDistSets_shortcut ];

/// CostDistSets_deptSetDr
Property CostDistSetsdeptSetDr As dhc.ca.cache.data.DeptLevelSets [ SqlColumnNumber = 6, SqlFieldName = CostDistSets_deptSetDr ];

/// CostDistSets_remark
Property CostDistSetsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CostDistSets_remark ];

/// CostDistSets_active
Property CostDistSetsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CostDistSets_active ];

/// CostDistSets_distFlag
Property CostDistSetsdistFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CostDistSets_distFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCACOSTDISTSETS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="CostDistSets_active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CostDistSets_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CostDistSets_deptSetDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CostDistSets_distFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CostDistSets_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CostDistSets_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CostDistSets_remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CostDistSets_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CostDistSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CostDistSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CostDistSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CostDistSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.CostDistSetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
