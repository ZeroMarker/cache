/// GenericIngr(2615)
Class User.PHCGenericIngr Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_GenericIngr, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INGRChildsub [ IdKey, PrimaryKey, Unique ];

/// PHC_Generic Parent Reference
Relationship INGRParRef As PHCGeneric [ Cardinality = parent, Inverse = ChildPHCGenericIngr, Required, SqlFieldName = INGR_ParRef ];

/// Childsub
Property INGRChildsub As %Float [ InitialExpression = {$i(^PHCGE("GE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"INGR",0))}, SqlColumnNumber = 2, SqlFieldName = INGR_Childsub ];

/// Des Ref Generic
Property INGRGenericDR As PHCGeneric [ SqlColumnNumber = 3, SqlFieldName = INGR_Generic_DR ];

/// Des Ref Igredient
Property INGRIgredientDR As PHCIngredient [ SqlColumnNumber = 4, SqlFieldName = INGR_Igredient_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCGenericIngr).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericIngr","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCGenericIngr).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericIngr","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCGenericIngr).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericIngr","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCGenericIngr).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericIngr","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCGenericIngr).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericIngr","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INGR_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGR_Igredient_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCGE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INGR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INGR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGener">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INGR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INGR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INGR_Generic_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INGR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIngr">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INGR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INGR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Ingr"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INGR_Igredient_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INGR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INGR_RowId</SqlRowIdName>
<StreamLocation>^User.PHCGenericIngrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
