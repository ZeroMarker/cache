/// SS Group Stock Items(1867)
Class User.SSGroupStockItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupStockItems, StorageStrategy = SQLStorage ]
{

/// Childsub
Property INCIChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"INCI",0))}, SqlColumnNumber = 2, SqlFieldName = INCI_Childsub ];

/// Des Ref INCI
Property INCIINCIDR As INCItm [ SqlColumnNumber = 3, SqlFieldName = INCI_INCI_DR ];

/// SS_Group Parent Reference
Relationship INCIParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupStockItems, Required, SqlFieldName = INCI_ParRef ];

/// Qty
Property INCIQty As %Float [ SqlColumnNumber = 4, SqlFieldName = INCI_Qty ];

Index RowIDBasedIDKeyIndex On INCIChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupStockItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockItems","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupStockItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockItems","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupStockItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockItems","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupStockItems).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockItems","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupStockItems).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockItems","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INCI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INCI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INCI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCI_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INCI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCI_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupStockItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
