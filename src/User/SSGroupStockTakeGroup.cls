/// SS Group Stock Take Group(1619)
Class User.SSGroupStockTakeGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupStockTakeGroup, StorageStrategy = SQLStorage ]
{

/// Childsub
Property STGChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"STG",0))}, SqlColumnNumber = 2, SqlFieldName = STG_Childsub ];

/// SS_Group Parent Reference
Relationship STGParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupStockTakeGroup, Required, SqlFieldName = STG_ParRef ];

/// Des Ref StockTakeGroup
Property STGStockTakeGroupDR As INCStkTkGp [ SqlColumnNumber = 3, SqlFieldName = STG_StockTakeGroup_DR ];

Index RowIDBasedIDKeyIndex On STGChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 44;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupStockTakeGroup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockTakeGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupStockTakeGroup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockTakeGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupStockTakeGroup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockTakeGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupStockTakeGroup).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockTakeGroup","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupStockTakeGroup).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupStockTakeGroup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>44</ExtentSize>
<Property name="STGChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="STGParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="STGStockTakeGroupDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="STG_StockTakeGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>STG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"STG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStockTakeGroup">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>STG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"STG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"STGroup"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{STG_StockTakeGroup_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{STG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>STG_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupStockTakeGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
