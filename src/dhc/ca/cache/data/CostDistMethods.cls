Class dhc.ca.cache.data.CostDistMethods Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CostDistMethods_rowid, SqlTableName = CostDistMethods, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On CostDistMethodschildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildOutCostDepts As dhc.ca.cache.data.OutCostDepts [ Cardinality = children, Inverse = OutCostDeptsparRef ];

Relationship ChildInCostItems As dhc.ca.cache.data.InCostItems [ Cardinality = children, Inverse = InCostItemsparRef ];

Relationship ChildOutCostItems As dhc.ca.cache.data.OutCostItems [ Cardinality = children, Inverse = OutCostItemsparRef ];

Relationship ChildInRecDepts As dhc.ca.cache.data.InRecDepts [ Cardinality = children, Inverse = InRecDeptsparRef ];

Relationship ChildOutRecDepts As dhc.ca.cache.data.OutRecDepts [ Cardinality = children, Inverse = OutRecDeptsparRef ];

Relationship ChildDistParams As dhc.ca.cache.data.DistParams [ Cardinality = children, Inverse = DistParamsparRef ];

Relationship ChildInCostDepts As dhc.ca.cache.data.InCostDepts [ Cardinality = children, Inverse = InCostDeptsparRef ];

/// CostDistSets Parent Reference
Relationship CostDistMethodsparRef As dhc.ca.cache.data.CostDistSets [ Cardinality = parent, Inverse = ChildCostDistMethods, Required, SqlFieldName = CostDistMethods_parRef ];

/// CostDistMethods_childSub
Property CostDistMethodschildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),$c(1),1),"CDM",0))}, SqlColumnNumber = 2, SqlFieldName = CostDistMethods_childSub ];

/// CostDistMethods_priority
Property CostDistMethodspriority As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = CostDistMethods_priority ];

/// CostDistMethods_layerDr
Property CostDistMethodslayerDr As dhc.ca.cache.data.DeptLevelSets [ SqlColumnNumber = 4, SqlFieldName = CostDistMethods_layerDr ];

/// CostDistMethods_code
Property CostDistMethodscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CostDistMethods_code ];

/// CostDistMethods_name
Property CostDistMethodsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CostDistMethods_name ];

/// CostDistMethods_itemDr
Property CostDistMethodsitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 7, SqlFieldName = CostDistMethods_itemDr ];

/// CostDistMethods_paramPeriDr
Property CostDistMethodsparamPeriDr As dhc.ca.cache.data.AccPeriod [ SqlColumnNumber = 8, SqlFieldName = CostDistMethods_paramPeriDr ];

/// CostDistMethods_active
Property CostDistMethodsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CostDistMethods_active ];

/// CostDistMethods_ioFlag
Property CostDistMethodsioFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CostDistMethods_ioFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="CostDistMethods_active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CostDistMethods_code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CostDistMethods_ioFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CostDistMethods_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CostDistMethods_layerDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CostDistMethods_name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CostDistMethods_paramPeriDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CostDistMethods_priority">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CostDistMethods_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistMethods_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCDMPrio">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>CostDistMethods_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDMPrio"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistMethods_priority}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostDistMethods_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCDMPrioAct">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostDistMethods_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDMPrioAct"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistMethods_priority}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostDistMethods_active}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostDistMethods_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCDMSLC">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostDistMethods_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDMSLC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistMethods_layerDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostDistMethods_code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostDistMethods_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCDMSLN">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostDistMethods_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDMSLN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistMethods_layerDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostDistMethods_name}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostDistMethods_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCDMSLP">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CostDistMethods_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDMSLP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CostDistMethods_layerDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CostDistMethods_priority}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CostDistMethods_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.CostDistMethodsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
