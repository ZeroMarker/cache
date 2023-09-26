/// PAC Default Admission Dep(1644)
Class User.PACDefaultAdmDepartment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_DefaultAdmDepartment, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property DEFDEPCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = DEFDEP_CTLOC_DR ];

/// Des Ref CTLOC
Property DEFDEPExecLocDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = DEFDEP_ExecLoc_DR ];

/// Des Ref InsType
Property DEFDEPInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = DEFDEP_InsType_DR ];

/// Des Ref RBC Service Group
Property DEFDEPRBCServiceGroupDR As RBCServiceGroup [ SqlColumnNumber = 2, SqlFieldName = DEFDEP_RBC_ServiceGroup_DR ];

/// Service Key
Property DEFDEPServiceKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DEFDEP_ServiceKey ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACDefaultAdmDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDefaultAdmDepartment","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACDefaultAdmDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDefaultAdmDepartment","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACDefaultAdmDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDefaultAdmDepartment","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACDefaultAdmDepartment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDefaultAdmDepartment","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACDefaultAdmDepartment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDefaultAdmDepartment","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("DEFDEP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DEFDEP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DEFDEP_ExecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEFDEP_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEFDEP_RBC_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEFDEP_ServiceKey">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DEFDEP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEFDEP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEFDEP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DEFDEP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEFDEP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEFDEP_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEFDEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServGrp">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DEFDEP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEFDEP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SerGrp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEFDEP_RBC_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEFDEP_InsType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DEFDEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServIns">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DEFDEP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEFDEP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ServInsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEFDEP_ServiceKey}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEFDEP_InsType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DEFDEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DEFDEP_RowId</SqlRowIdName>
<StreamLocation>^User.PACDefaultAdmDepartmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
