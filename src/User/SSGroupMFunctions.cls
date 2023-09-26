/// SS Functions in a Group (SSGMF,774)
Class User.SSGroupMFunctions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupMFunctions, StorageStrategy = SQLStorage ]
{

/// Des Ref to SSMFS
Property SSGMFMFunction As SSMFunctions [ Required, SqlColumnNumber = 3, SqlFieldName = SSGMF_MFunction ];

/// SSGRP Parent Reference
Relationship SSGMFSSGRPParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupMFunctions, Required, SqlFieldName = SSGMF_SSGRP_ParRef ];

Index RowIDBasedIDKeyIndex On SSGMFMFunction [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 6554;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupMFunctions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupMFunctions","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupMFunctions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupMFunctions","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupMFunctions).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupMFunctions","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupMFunctions).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupMFunctions","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupMFunctions).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupMFunctions","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6554</ExtentSize>
<Property name="SSGMFMFunction">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSGMFSSGRPParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMap">
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SSGMF_MFunction</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"SSGMF"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SSGMF_MFunction}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSGMF_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupMFunctionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
