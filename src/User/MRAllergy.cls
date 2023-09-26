/// MR Patient Allergy      (MRALL,295)
Class User.MRAllergy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Allergy, StorageStrategy = SQLStorage ]
{

/// Des Ref to ALG
Property MRALLALGDR As PAAllergy [ SqlColumnNumber = 3, SqlComputeCode = { i {MRALL_Entered}="" s {MRALL_ALG_DR}="" q
 s {MRALL_ALG_DR}=$$CO03^at295({MRALL_Type_DR},{MRALL_ALG_DR})
}, SqlComputed, SqlComputeOnChange = (MRALLEntered, MRALLTypeDR), SqlFieldName = MRALL_ALG_DR ];

/// MRALL Childsub (NewKey)
Property MRALLChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^MR($p(%d(0),$c(1),1),"ALL",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MRALL_Childsub ];

/// Date
Property MRALLDate As %Date [ SqlColumnNumber = 14, SqlFieldName = MRALL_Date ];

/// Des Ref to CTPCP
Property MRALLDocCodeDR As CTCareProv [ InitialExpression = {$g(XCONF("WORKING PROVIDER"))}, Required, SqlColumnNumber = 8, SqlFieldName = MRALL_DocCode_DR ];

/// Entered Allergy (Comp)
Property MRALLEntered As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MRALL_Entered ];

/// Des Ref to MRADM
Relationship MRALLMRADMParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRAllergy, Required, SqlFieldName = MRALL_MRADM_ParRef ];

/// Other Allergy
Property MRALLOthAllergy As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlComputeCode = { i {MRALL_Entered}="" s {MRALL_OthAllergy}="" q
 s {MRALL_OthAllergy}=$$CO05^at295({MRALL_Type_DR},{MRALL_Entered})
}, SqlComputed, SqlComputeOnChange = (MRALLEntered, MRALLTypeDR), SqlFieldName = MRALL_OthAllergy ];

/// Des Ref to PHCGE
Property MRALLPHCGEDR As PHCGeneric [ SqlColumnNumber = 13, SqlComputeCode = { i {MRALL_Entered}="" s {MRALL_PHCGE_DR}="" q
 s {MRALL_PHCGE_DR}=$$CO13^at295({MRALL_Type_DR})
}, SqlComputed, SqlComputeOnChange = (MRALLTypeDR, MRALLEntered), SqlFieldName = MRALL_PHCGE_DR ];

/// Des Ref to PHCSC
Property MRALLPHCSCDR As PHCSubCat [ SqlColumnNumber = 12, SqlComputeCode = { i {MRALL_Entered}="" s {MRALL_PHCSC_DR}="" q
 s {MRALL_PHCSC_DR}=$$CO12^at295({MRALL_Type_DR})
}, SqlComputed, SqlComputeOnChange = (MRALLTypeDR, MRALLEntered), SqlFieldName = MRALL_PHCSC_DR ];

/// Reaction on allergy
Property MRALLReaction As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = MRALL_Reaction ];

/// MRALL_Sort
Property MRALLSort As %String(COLLATION = "Exact", MAXLEN = 48, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlComputeCode = { i {MRALL_Type_DR}="" s {MRALL_Sort}="" q
 i {MRALL_MRADM_ParRef}="" s {MRALL_Sort}="" q
 s {MRALL_Sort}={MRALL_Type_DR}_{MRALL_MRADM_ParRef}
}, SqlComputed, SqlFieldName = MRALL_Sort, Transient ];

/// Status of Allergy
Property MRALLStatus As %String(DISPLAYLIST = ",ACTIVE  ,RESOLVED", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",A,R") [ SqlColumnNumber = 6, SqlFieldName = MRALL_Status ];

/// Time
Property MRALLTime As %Time [ SqlColumnNumber = 15, SqlFieldName = MRALL_Time ];

/// Des Ref to MRC Allergy Type
Property MRALLTypeDR As MRCAllType [ SqlColumnNumber = 9, SqlFieldName = MRALL_Type_DR ];

Index RowIDBasedIDKeyIndex On MRALLChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRAllergy).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRAllergy","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRAllergy).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRAllergy","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRAllergy).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRAllergy","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRAllergy).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRAllergy","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRAllergy).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRAllergy","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MRALLDataMasterMap">
<Data name="MRALL_ALG_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRALL_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRALL_DocCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRALL_Entered">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRALL_OthAllergy">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRALL_PHCGE_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRALL_PHCSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRALL_Reaction">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRALL_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRALL_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRALL_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRALL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ALL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRALL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRALL_RowId</SqlRowIdName>
<StreamLocation>^User.MRAllergyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
