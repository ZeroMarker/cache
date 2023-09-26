Class dhc.ca.cache.data.InDataCardRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDataCardRule_rowid, SqlTableName = InDataCardRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InDataCardRulechildSub [ IdKey, PrimaryKey, Unique ];

/// InDataCarding Parent Reference
Relationship InDataCardRuleparRef As dhc.ca.cache.data.InDataCarding [ Cardinality = parent, Inverse = ChildInDataCardRule, Required, SqlFieldName = InDataCardRule_parRef ];

/// InDataCardRule_childSub
Property InDataCardRulechildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINDATACARDING($p(%d(0),$c(1),1),"Rule",0))}, SqlColumnNumber = 2, SqlFieldName = InDataCardRule_childSub ];

/// InDataCardRule_itemDr
Property InDataCardRuleitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 3, SqlFieldName = InDataCardRule_itemDr ];

/// InDataCardRule_srDeptDr
Property InDataCardRulesrDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = InDataCardRule_srDeptDr ];

/// InDataCardRule_deDeptDr
Property InDataCardRuledeDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 5, SqlFieldName = InDataCardRule_deDeptDr ];

//zjw 20160115新增病人类型

/// InDataCardRule_pattype
Property InDataCardRulepattype As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InDataCardRule_pattype ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InDataCardRule_deDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InDataCardRule_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InDataCardRule_pattype">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InDataCardRule_srDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCAINDATACARDING</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDataCarding.InDataCarding_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>InDataCardRule_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDataCarding.InDataCarding_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Rule"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDataCardRule_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSrDeptDr">
<Global>^DHCCAINDATACARDING</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDataCarding.InDataCarding_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InDataCardRule_childSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SrDeptDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDataCarding.InDataCarding_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDataCardRule_srDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDataCardRule_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSrDrItemDr">
<Global>^DHCCAINDATACARDING</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDataCarding.InDataCarding_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>InDataCardRule_childSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SrDrItemDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDataCarding.InDataCarding_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDataCardRule_srDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDataCardRule_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{InDataCardRule_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSrDrPatType">
<Global>^DHCCAINDATACARDING</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDataCarding.InDataCarding_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>InDataCardRule_childSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SrDrPatType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDataCarding.InDataCarding_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDataCardRule_srDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDataCardRule_pattype}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{InDataCardRule_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSrDrPatTypeItemDr">
<Global>^DHCCAINDATACARDING</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDataCarding.InDataCarding_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>InDataCardRule_childSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SrDrPattypeItemDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDataCarding.InDataCarding_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDataCardRule_srDeptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDataCardRule_pattype}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{InDataCardRule_itemDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{InDataCardRule_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDataCardRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
