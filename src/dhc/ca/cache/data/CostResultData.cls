Class dhc.ca.cache.data.CostResultData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CostResultData_rowid, SqlTableName = CostResultData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On CostResultDatachildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistSets Parent Reference
Relationship CostResultDataparRef As dhc.ca.cache.data.CostDistSets [ Cardinality = parent, Inverse = ChildCostResultData, Required, SqlFieldName = CostResultData_parRef ];

/// CostResultData_childSub
Property CostResultDatachildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),$c(1),1),"CostResultData",0))}, SqlColumnNumber = 2, SqlFieldName = CostResultData_childSub ];

/// CostResultData_intervalDr
Property CostResultDataintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 3, SqlFieldName = CostResultData_intervalDr ];

/// CostResultData_distedDeptDr
Property CostResultDatadistedDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = CostResultData_distedDeptDr ];

/// CostResultData_distDeptDr
Property CostResultDatadistDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 5, SqlFieldName = CostResultData_distDeptDr ];

/// CostResultData_itemDr
Property CostResultDataitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 6, SqlFieldName = CostResultData_itemDr ];

/// CostResultData_fee
Property CostResultDatafee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = CostResultData_fee ];

/// CostResultData_distFlag
Property CostResultDatadistFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CostResultData_distFlag ];

/// CostResultData_dealFlag
Property CostResultDatadealFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CostResultData_dealFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="CostResultData_dealFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CostResultData_distDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CostResultData_distFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CostResultData_distedDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CostResultData_fee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CostResultData_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CostResultData_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CostResultData"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDIntDistdept">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIntDistdept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultData_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultData_distDeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDIntDistdeptItem">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIntDistdeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultData_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultData_distDeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultData_itemDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDIntDisteddept">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIntDisteddept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultData_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultData_distedDeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDIntDisteddeptItem">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIntDisteddeptItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultData_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultData_distedDeptDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultData_itemDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDIntItem">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIntItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultData_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultData_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDIntItemDistdept">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIntItemDistdept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultData_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultData_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultData_distDeptDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDIntItemDisteddept">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIntItemDisteddept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultData_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultData_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostResultData_distedDeptDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDInterval">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>CostResultData_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DInterval"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostResultData_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostResultData_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.CostResultDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
