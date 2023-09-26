/// VBexe Options in Group (SSGVO,1149)
Class User.SSGroupVBExFunctOpt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupVBExFunctOpt, StorageStrategy = SQLStorage ]
{

/// SS_GroupVBExecFunction Parent Reference
Relationship VBOPTParRef As SSGroupVBExecFunction [ Cardinality = parent, Inverse = ChildSSGroupVBExFunctOpt, Required, SqlFieldName = VBOPT_ParRef ];

/// Des Ref to VBEXOP
Property VBOPTVBEXOPDR As SSVBMenuOptions [ Required, SqlColumnNumber = 2, SqlFieldName = VBOPT_VBEXOP_DR ];

Index RowIDBasedIDKeyIndex On VBOPTVBEXOPDR [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1000000;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupVBExFunctOpt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupVBExFunctOpt","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupVBExFunctOpt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupVBExFunctOpt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupVBExFunctOpt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupVBExFunctOpt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupVBExFunctOpt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupVBExFunctOpt","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupVBExFunctOpt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupVBExFunctOpt","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<Property name="VBOPTParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="VBOPTVBEXOPDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SS_GroupVBExecFunction.VBEX_SSVBF_DR</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>VBOPT_VBEXOP_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VBEX"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_GroupVBExecFunction.VBEX_SSVBF_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"VBOP"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VBOPT_VBEXOP_DR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VBOPT_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupVBExFunctOptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
