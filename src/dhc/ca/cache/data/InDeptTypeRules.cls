Class dhc.ca.cache.data.InDeptTypeRules Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDeptTypeRules_rowid, SqlTableName = InDeptTypeRules, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InDeptTypeRuleschildSub [ IdKey, PrimaryKey, Unique ];

/// InDistRules Parent Reference
Relationship InDeptTypeRulesparRef As dhc.ca.cache.data.InDistRules [ Cardinality = parent, Inverse = ChildInDeptTypeRules, Required, SqlFieldName = InDeptTypeRules_parRef ];

/// InDeptTypeRules_childSub
Property InDeptTypeRuleschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINDISTRULE($p(%d(0),$c(1),1),"InDTRules",0))}, SqlColumnNumber = 2, SqlFieldName = InDeptTypeRules_childSub ];

/// InDeptTypeRules_deptType
Property InDeptTypeRulesdeptType As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = InDeptTypeRules_deptType ];

/// InDeptTypeRules_percent
Property InDeptTypeRulespercent As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = InDeptTypeRules_percent ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InDeptTypeRules_deptType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InDeptTypeRules_percent">
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
<Field>InDeptTypeRules_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDistRules.InDistRules_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InDTRules"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptTypeRules_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDeptTypeRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
