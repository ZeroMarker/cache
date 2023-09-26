Class dhc.ca.cache.data.LevelDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LevelDepts_rowid, SqlTableName = LevelDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On LevelDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// DeptLevelSets Parent Reference
Relationship LevelDeptsparRef As dhc.ca.cache.data.DeptLevelSets [ Cardinality = parent, Inverse = ChildLevelDepts, Required, SqlFieldName = LevelDepts_parRef ];

/// LevelDepts_childSub
Property LevelDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCADEPTLEVELSETS($p(%d(0),$c(1),1),"Depts",0))}, SqlColumnNumber = 2, SqlFieldName = LevelDepts_childSub ];

/// LevelDepts_deptDr
Property LevelDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = LevelDepts_deptDr ];

/// LevelDepts_recCost
Property LevelDeptsrecCost As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LevelDepts_recCost ];

/// LevelDepts_order
Property LevelDeptsorder As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = LevelDepts_order ];

/// LevelDepts_distCost
Property LevelDeptsdistCost As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = LevelDepts_distCost ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="LevelDepts_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LevelDepts_distCost">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LevelDepts_order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LevelDepts_recCost">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCADEPTLEVELSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DeptLevelSets.DeptLevelSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LevelDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DeptLevelSets.DeptLevelSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Depts"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LevelDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDept">
<Global>^DHCCADEPTLEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DeptLevelSets.DeptLevelSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LevelDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptLevelSets.DeptLevelSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LevelDepts_deptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LevelDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeptOrder">
<Global>^DHCCADEPTLEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DeptLevelSets.DeptLevelSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LevelDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptLevelSets.DeptLevelSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LevelDepts_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LevelDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.LevelDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
