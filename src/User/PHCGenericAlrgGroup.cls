/// GenericAlrgGroup(2616)
Class User.PHCGenericAlrgGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_GenericAlrgGroup, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ALGChildsub [ IdKey, PrimaryKey, Unique ];

/// PHC_Generic Parent Reference
Relationship ALGParRef As PHCGeneric [ Cardinality = parent, Inverse = ChildPHCGenericAlrgGroup, Required, SqlFieldName = ALG_ParRef ];

/// Childsub
Property ALGChildsub As %Float [ InitialExpression = {$i(^PHCGE("GE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ALG",0))}, SqlColumnNumber = 2, SqlFieldName = ALG_Childsub ];

/// Des Ref AllergyGroup
Property ALGAllergyGroupDR As PHCAllergyGroup [ SqlColumnNumber = 3, SqlFieldName = ALG_AllergyGroup_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCGenericAlrgGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericAlrgGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCGenericAlrgGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericAlrgGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCGenericAlrgGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericAlrgGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCGenericAlrgGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericAlrgGroup","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCGenericAlrgGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericAlrgGroup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ALG_AllergyGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PHCGE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ALG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ALG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlg">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ALG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ALG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Alg"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALG_AllergyGroup_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALG_RowId</SqlRowIdName>
<StreamLocation>^User.PHCGenericAlrgGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
