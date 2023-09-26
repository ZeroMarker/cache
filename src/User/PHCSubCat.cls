/// PHC Pharm Idx SubCat    (PHCSC,549)
Class User.PHCSubCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PHC_SubCat, StorageStrategy = SQLStorage ]
{

Relationship ChildPHCMinorSubCat As PHCMinorSubCat [ Cardinality = children, Inverse = MINParRef ];

/// ChildSub (New Key)
Property PHCSCChildSub As %Float [ InitialExpression = {$i(^PHCC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"SC",0))}, SqlColumnNumber = 4, SqlFieldName = PHCSC_ChildSub ];

/// Sub Category Code
Property PHCSCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHCSC_Code ];

/// Description
Property PHCSCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PHCSC_Desc ];

/// Lookup Display
Property PHCSCLookupDisplay As %String(COLLATION = "Exact", MAXLEN = 78, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlComputeCode = { s {PHCSC_LookupDisplay}=$$CO05^at549({PHCSC_PHCC_ParRef},{PHCSC_Code},{PHCSC_Desc})
}, SqlComputed, SqlFieldName = PHCSC_LookupDisplay, Transient ];

/// PHCC Parent Reference
Relationship PHCSCPHCCParRef As PHCCat [ Cardinality = parent, Inverse = ChildPHCSubCat, Required, SqlFieldName = PHCSC_PHCC_ParRef ];

Index RowIDBasedIDKeyIndex On PHCSCChildSub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 141;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCSubCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCSubCat","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCSubCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCSubCat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCSubCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCSubCat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCSubCat).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCSubCat","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCSubCat).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCSubCat","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>141</ExtentSize>
<Property name="PHCSCChildSub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCSCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCSCDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCSCLookupDisplay">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHCSCPHCCParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterPHCSC">
<Data name="PHCSC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_Cat.PHCC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCSC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHC_Cat.PHCC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCSC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHCSCCode">
<Global>^PHCC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_Cat.PHCC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCSC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SC_Code"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCSC_Code})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHC_Cat.PHCC_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCSC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCSCDesc">
<Global>^PHCC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_Cat.PHCC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCSC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SC_Desc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCSC_Desc})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHC_Cat.PHCC_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCSC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCSC_RowId</SqlRowIdName>
<StreamLocation>^User.PHCSubCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
