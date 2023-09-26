/// SGroup Doc Resource Restrictions(17
Class User.SSGroupDocResRestrictions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupDocResRestrictions, StorageStrategy = SQLStorage ]
{

/// Des REf CTCP_DR
Property DRESCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = DRES_CTCP_DR ];

/// Childsub
Property DRESChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"DRES",0))}, SqlColumnNumber = 2, SqlFieldName = DRES_Childsub ];

/// SS_Group Parent Reference
Relationship DRESParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupDocResRestrictions, Required, SqlFieldName = DRES_ParRef ];

/// Des Ref RBC Equip
Property DRESRBCEqDR As RBCEquipment [ SqlColumnNumber = 4, SqlFieldName = DRES_RBC_Eq_DR ];

Index RowIDBasedIDKeyIndex On DRESChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupDocResRestrictions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupDocResRestrictions","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupDocResRestrictions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupDocResRestrictions","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupDocResRestrictions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupDocResRestrictions","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupDocResRestrictions).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupDocResRestrictions","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupDocResRestrictions).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupDocResRestrictions","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="DRES_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRES_RBC_Eq_DR">
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
<Field>DRES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DRES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRES_CTCP_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DRES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEq">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DRES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Eq"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DRES_RBC_Eq_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DRES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DRES_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupDocResRestrictionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
