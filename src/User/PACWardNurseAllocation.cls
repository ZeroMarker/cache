/// PAC Ward Nurse Allocation(1357)
Class User.PACWardNurseAllocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WardNurseAllocation, StorageStrategy = SQLStorage ]
{

/// Des Ref CTCP
Property NURCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = NUR_CTCP_DR ];

/// Childsub
Property NURChildsub As %Float [ InitialExpression = {$i(^PAWARD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"NUR",0))}, SqlColumnNumber = 2, SqlFieldName = NUR_Childsub ];

/// PAC_Ward Parent Reference
Relationship NURParRef As PACWard [ Cardinality = parent, Inverse = ChildPACWardNurseAllocation, Required, SqlFieldName = NUR_ParRef ];

Index RowIDBasedIDKeyIndex On NURChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 30;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWardNurseAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardNurseAllocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWardNurseAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardNurseAllocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWardNurseAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardNurseAllocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWardNurseAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardNurseAllocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWardNurseAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWardNurseAllocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>30</ExtentSize>
<Property name="NURCTCPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NURChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="NURParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="NUR_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>NUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NUR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NUR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NUR_RowId</SqlRowIdName>
<StreamLocation>^User.PACWardNurseAllocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
