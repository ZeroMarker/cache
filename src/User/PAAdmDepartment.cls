/// Admission Department(1435)
Class User.PAAdmDepartment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmDepartment, StorageStrategy = SQLStorage ]
{

Relationship ChildPAAdmDepartmentRoom As PAAdmDepartmentRoom [ Cardinality = children, Inverse = ROOMParRef ];

/// Des Ref CTLOC
Property DEPCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = DEP_CTLOC_DR ];

/// Date
Property DEPDate As %Date [ SqlColumnNumber = 2, SqlFieldName = DEP_Date ];

/// PA_Adm Parent Reference
Relationship DEPParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmDepartment, Required, SqlFieldName = DEP_ParRef ];

Index RowIDBasedIDKeyIndex On DEPDate [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartment","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartment","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartment","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmDepartment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartment","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmDepartment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartment","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DEP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DEP_Date</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEP_Date}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DEP_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmDepartmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
