Class dhc.ca.cache.data.CostResultSum Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CostResultSum_rowid, SqlTableName = CostResultSum, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On CostResultSumchildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistSets Parent Reference
Relationship CostResultSumparRef As dhc.ca.cache.data.CostDistSets [ Cardinality = parent, Inverse = ChildCostResultSum, Required, SqlFieldName = CostResultSum_parRef ];

/// CostResultSum_childSub
Property CostResultSumchildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),$c(1),1),"CostResultSum",0))}, SqlColumnNumber = 2, SqlFieldName = CostResultSum_childSub ];

/// CostResultSum_intervalDr
Property CostResultSumintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 3, SqlFieldName = CostResultSum_intervalDr ];

/// CostResultSum_branchFlag
Property CostResultSumbranchFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CostResultSum_branchFlag ];

//Property CostResultSumblDr As dhc.ca.cache.data.UnitDepts

/// CostResultSum_blDr
Property CostResultSumblDr As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = CostResultSum_blDr ];

/// CostResultSum_self
Property CostResultSumself As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = CostResultSum_self ];

/// CostResultSum_dist
Property CostResultSumdist As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = CostResultSum_dist ];

/// CostResultSum_cat
Property CostResultSumcat As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = CostResultSum_cat ];

/// CostResultSum_sum
Property CostResultSumsum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = CostResultSum_sum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="CostResultSum_blDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CostResultSum_branchFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CostResultSum_cat">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CostResultSum_dist">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CostResultSum_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CostResultSum_self">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CostResultSum_sum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CostResultSum_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CostResultSum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostResultSum_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIntFlagID">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostResultSum_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntFlagID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostResultSum_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultSum_branchFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultSum_blDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultSum_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntIDFlag">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostResultSum_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntIDFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostResultSum_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultSum_blDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultSum_branchFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultSum_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.CostResultSumS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
