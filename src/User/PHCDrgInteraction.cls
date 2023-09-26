/// PHC Drug Interaction(1856)
Class User.PHCDrgInteraction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_DrgInteraction, StorageStrategy = SQLStorage ]
{

/// Childsub
Property INTChildsub As %Float [ InitialExpression = {$i(^PHCD($p(%d(0),$c(1)),"INT",0))}, SqlColumnNumber = 2, SqlFieldName = INT_Childsub ];

/// Des Ref DrugMaser
Property INTDrugMaserDR As PHCDrgMast [ SqlColumnNumber = 3, SqlFieldName = INT_DrugMaser_DR ];

/// PHC_DrgMast Parent Reference
Relationship INTParRef As PHCDrgMast [ Cardinality = parent, Inverse = ChildPHCDrgInteraction, Required, SqlFieldName = INT_ParRef ];

Index RowIDBasedIDKeyIndex On INTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 12;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCDrgInteraction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgInteraction","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCDrgInteraction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgInteraction","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCDrgInteraction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgInteraction","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCDrgInteraction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgInteraction","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCDrgInteraction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgInteraction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>12</ExtentSize>
<Property name="INTChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTDrugMaserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="INTParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="INT_DrugMaser_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PHCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDrug">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Drug"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INT_DrugMaser_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INT_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDrgInteractionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
