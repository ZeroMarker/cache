/// IN Stock Take Group(1666)
Class User.INStkTkGrp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_StkTkGrp, StorageStrategy = SQLStorage ]
{

/// Childsub
Property TGChildsub As %Float [ InitialExpression = {$i(^INST($p(%d(0),$c(1)),"TG",0))}, SqlColumnNumber = 2, SqlFieldName = TG_Childsub ];

/// IN_StkTk Parent Reference
Relationship TGParRef As INStkTk [ Cardinality = parent, Inverse = ChildINStkTkGrp, Required, SqlFieldName = TG_ParRef ];

/// Des Ref StkGroup
Property TGStkGroupDR As INCStkTkGp [ SqlColumnNumber = 3, SqlFieldName = TG_StkGroup_DR ];

Index RowIDBasedIDKeyIndex On TGChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INStkTkGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkTkGrp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INStkTkGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkTkGrp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INStkTkGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkTkGrp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INStkTkGrp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkTkGrp","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INStkTkGrp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INStkTkGrp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TG_StkGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^INST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>TG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Grp"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TG_StkGroup_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TG_RowId</SqlRowIdName>
<StreamLocation>^User.INStkTkGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
