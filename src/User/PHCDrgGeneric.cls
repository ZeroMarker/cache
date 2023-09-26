/// PHC Drug Generic(1845)
Class User.PHCDrgGeneric Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_DrgGeneric, StorageStrategy = SQLStorage ]
{

/// Childsub
Property GENChildsub As %Float [ InitialExpression = {$i(^PHCD($p(%d(0),$c(1)),"GEN",0))}, SqlColumnNumber = 2, SqlFieldName = GEN_Childsub ];

/// Des Ref Generic
Property GENGenericDR As PHCGeneric [ SqlColumnNumber = 3, SqlFieldName = GEN_Generic_DR ];

/// PHC_DrgMast Parent Reference
Relationship GENParRef As PHCDrgMast [ Cardinality = parent, Inverse = ChildPHCDrgGeneric, Required, SqlFieldName = GEN_ParRef ];

Index RowIDBasedIDKeyIndex On GENChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCDrgGeneric).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgGeneric","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCDrgGeneric).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgGeneric","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCDrgGeneric).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgGeneric","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCDrgGeneric).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgGeneric","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCDrgGeneric).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCDrgGeneric","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="GENChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="GENGenericDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="GENParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="GEN_Generic_DR">
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
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GEN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GEN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGeneric">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GEN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Gener"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GEN_Generic_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GEN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GEN_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDrgGenericS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
