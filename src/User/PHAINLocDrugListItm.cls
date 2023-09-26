Class User.PHAINLocDrugListItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = LDLI_RowId, SqlTableName = PHAIN_LocDrugListItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LDLICHILDSUB [ IdKey, PrimaryKey, Unique ];

Index ArcIDKeyIndex On (LDLPARREF, LDLIArcDr) [ Unique ];

Index PhcgIDKeyIndex On (LDLPARREF, LDLIPHCGDr) [ Unique ];

Relationship LDLPARREF As User.PHAINLocDrugList [ Cardinality = parent, Inverse = ChildDHCLDL, Required, SqlFieldName = LDLI_PARREF ];

/// DULI_CHILDSUB
Property LDLICHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LDLI_CHILDSUB ];

/// LDLI_Arc_Dr  医嘱项指向
Property LDLIArcDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = LDLI_Arc_Dr ];

/// LDLI_PHCG_Dr  医嘱项指向
Property LDLIPHCGDr As User.PHCGeneric [ SqlColumnNumber = 4, SqlFieldName = LDLI_PHCG_Dr ];

Storage SQLStorage
{
<SQLMap name="IndexArc">
<Global>^CF.PHA.IN.LocDrugListItm</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHAIN_LocDrugList.LDL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LDLI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ARC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LDLI_Arc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_LocDrugList.LDL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LDLI_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCG">
<Global>^CF.PHA.IN.LocDrugListItm</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHAIN_LocDrugList.LDL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LDLI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHCG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LDLI_PHCG_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_LocDrugList.LDL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LDLI_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LDLIMASTER">
<Data name="LDLI_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LDLI_PHCG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.PHA.IN.LocDrugListItm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_LocDrugList.LDL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LDLI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_LocDrugList.LDL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LDLI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LDLI_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LDLI_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINLocDrugListItm</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
