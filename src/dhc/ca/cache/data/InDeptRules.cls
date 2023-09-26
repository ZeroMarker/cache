Class dhc.ca.cache.data.InDeptRules Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDeptRules_rowid, SqlTableName = InDeptRules, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InDeptRuleschildSub [ IdKey, PrimaryKey, Unique ];

/// InDistRules Parent Reference
Relationship InDeptRulesparRef As dhc.ca.cache.data.InDistRules [ Cardinality = parent, Inverse = ChildInDeptRules, Required, SqlFieldName = InDeptRules_parRef ];

/// InDeptRules_childSub
Property InDeptRuleschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINDISTRULE($p(%d(0),$c(1),1),"InDRules",0))}, SqlColumnNumber = 2, SqlFieldName = InDeptRules_childSub ];

/// InDeptRules_deptDr
Property InDeptRulesdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = InDeptRules_deptDr ];

/// InDeptRules_percent
Property InDeptRulespercent As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = InDeptRules_percent ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InDeptRules_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InDeptRules_percent">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCAINDISTRULE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDistRules.InDistRules_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>InDeptRules_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDistRules.InDistRules_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InDRules"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptRules_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInDept">
<Global>^DHCCAINDISTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDistRules.InDistRules_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InDeptRules_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDistRules.InDistRules_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDeptRules_deptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDeptRules_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDeptRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
